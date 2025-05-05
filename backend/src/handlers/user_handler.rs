use actix_web::{ web, HttpResponse, Responder};
use argon2::{password_hash::{rand_core::OsRng, PasswordHasher, SaltString}, Argon2};
use chrono::{DateTime, Utc};
use serde::Serialize;
use sqlx::MySqlPool;
use uuid::Uuid;

use crate::models::user::{CreateUser, LoginRequest, User};


#[derive(Serialize)]
struct CreateUserResponse {
    message: String,
    user: UserResponse,
}

#[derive(Serialize)]
struct UserResponse {
    id: String,
    first_name: String,
    last_name: String,
    email: String,
    username: String,
    company_name: String,
    company_id: String,
    company_tin: String,
    created_at: DateTime<Utc>,
}

fn hash_password(password: &str) -> Result<String, argon2::password_hash::Error> {
    // Generate a random salt
    let salt = SaltString::generate(&mut OsRng);
    
    // Create an Argon2 instance with default parameters
    let argon2 = Argon2::default();
    
    // Hash the password
    let password_hash = argon2.hash_password(password.as_bytes(), &salt)?
        .to_string();
    
    Ok(password_hash)
}

pub async fn get_users(db: web::Data<MySqlPool>) -> impl Responder {
    let query = r#"
        SELECT
            id, first_name, last_name, email, username, company_name, company_id, company_tin, password, created_at, updated_at, deleted_at
        FROM users
    "#;

    let result = sqlx::query_as::<_, User>(query)
        .fetch_all(db.get_ref())
        .await;

    match result {
        Ok(users) => HttpResponse::Ok().json(users),
        Err(err) => {
            eprintln!("DB error: {:?}", err);
            HttpResponse::InternalServerError().body("Failed to fetch users")
        }
    }
}

pub async fn create_user(db: web::Data<MySqlPool>, req: web::Json<CreateUser>) -> HttpResponse {
    let hashed = match hash_password(&req.password) {
        Ok(h) => h,
        Err(_) => return HttpResponse::InternalServerError().body("Password has failed"),
    };

    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    let result = sqlx::query!(
        r#"
            INSERT INTO users (id, first_name, last_name, email, username, company_name, company_id, company_tin, password, 
                created_at, updated_at, deleted_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ? ,?, ?, ?, ?)
        "#,
        id,
        req.first_name,
        req.last_name,
        req.email,
        req.username,
        req.company_name,
        req.company_id,
        req.company_tin,
        hashed,
        now,
        now,
        now
    )
    .execute(db.get_ref())
    .await;

    match result {
        Ok(_) => {
            let user_response = UserResponse {
                id,
                first_name: req.first_name.clone(),
                last_name: req.last_name.clone(),
                email: req.email.clone(),
                username: req.username.clone(),
                company_name: req.company_name.clone(),
                company_id: req.company_id.clone(),
                company_tin: req.company_tin.clone(),
                created_at: now,
            };

            // Create the combined response
            let response = CreateUserResponse {
                message: "User created successfully".to_string(),
                user: user_response,
            };

            HttpResponse::Created().json(response)
        },
        Err(err) => {
            eprintln!("DB insert error: {:?}", err);
            HttpResponse::InternalServerError().body("Failed to create user")
        }
    }
}

pub async fn get_user_by_id(db: web::Data<MySqlPool>, id: web::Path<String>) -> impl Responder {
    let result = sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = ?")
        .bind(id.into_inner())
        .fetch_optional(db.get_ref())
        .await;

    match result {
        Ok(Some(user)) => HttpResponse::Ok().json(user),
        Ok(None) => HttpResponse::NotFound().body("User not found"),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}

pub async fn get_user_by_username(db: web::Data<MySqlPool>,username: web::Path<String>) -> impl Responder {
    let result = sqlx::query_as::<_, User>("SELECT * FROM users WHERE username = ?")
        .bind(username.into_inner())
        .fetch_optional(db.get_ref())
        .await;

    match result {
        Ok(Some(user)) => HttpResponse::Ok().json(user),
        Ok(None) => HttpResponse::NotFound().body("User not found"),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}

pub async fn get_users_by_company_tin(db: web::Data<MySqlPool>,tin: web::Path<String>,) -> impl Responder {
    let result = sqlx::query_as::<_, User>("SELECT * FROM users WHERE company_tin = ?")
        .bind(tin.into_inner())
        .fetch_all(db.get_ref())
        .await;

    match result {
        Ok(users) => HttpResponse::Ok().json(users),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}

pub async fn update_user(db: web::Data<MySqlPool>, tin: web::Path<String>, req: web::Json<CreateUser>) -> impl Responder {
    let now = Utc::now();

    let result = sqlx::query!(
        r#"
        UPDATE users
        SET first_name = ?, last_name = ?, email = ?, username = ?,
            company_name = ?, company_id = ?, company_tin = ?, updated_at = ?
        WHERE company_tin = ?
        "#,
        req.first_name,
        req.last_name,
        req.email,
        req.username,
        req.company_name,
        req.company_id,
        req.company_tin,
        now,
        tin.into_inner(),
    )
    .execute(db.get_ref())
    .await;

    match result {
        Ok(_) => HttpResponse::Ok().body("User updated"),
        Err(_) => HttpResponse::InternalServerError().body("Failed to update user"),
    }
}

pub async fn delete_user(db: web::Data<MySqlPool>,id: web::Path<String>) -> impl Responder {
    let now = Utc::now();

    let result = sqlx::query!(
        "UPDATE users SET deleted_at = ? WHERE id = ?",
        now,
        id.into_inner()
    )
    .execute(db.get_ref())
    .await;

    match result {
        Ok(_) => HttpResponse::Ok().body("User soft-deleted"),
        Err(_) => HttpResponse::InternalServerError().body("Failed to delete user"),
    }
}

// pub async fn register_user(db: web::Data<MySqlPool>, req: web::Json<CreateUser>) -> impl Responder {
//     create_user(db, req).await
// }


pub async fn register_user(db: web::Data<MySqlPool>, req: web::Json<CreateUser>) -> impl Responder {
    // First, check if the company exists
    let company_exists = sqlx::query_scalar::<_, i32>("SELECT 1 FROM companies WHERE tin = ? LIMIT 1")
        .bind(&req.company_tin)
        .fetch_optional(db.get_ref())
        .await;


    match company_exists {
        Ok(Some(_)) => {
            // Company exists, proceed with user creation
            create_user(db, req).await
        },
        Ok(None) => {
            // Company doesn't exist, create it first
            let company_id = Uuid::new_v4().to_string();
            let now = Utc::now();
            
            let company_result = sqlx::query!(
                r#"
                INSERT INTO companies (id, company_name, tin, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?)
                "#,
                company_id,
                req.company_name,
                req.company_tin,
                now,
                now
            )
            .execute(db.get_ref())
            .await;
            
            // match company_result {
            //     Ok(_) => {
            //         // Now create the user
            //         create_user(db, req).await
            //     },
            //     Err(err) => {
            //         eprintln!("Company creation error: {:?}", err);
            //         return HttpResponse::InternalServerError().body("Failed to create company")
            //     }
            // }

            match company_result {
                Ok(_) => create_user(db, req).await,
                Err(err) => {
                    eprintln!("Company creation error: {:?}", err);
                    return HttpResponse::InternalServerError().body("Failed to create company");
                }
            }
        },
        Err(err) => {
            eprintln!("DB query error: {:?}", err);
            return HttpResponse::InternalServerError().body("Database error")
        }
    }
}

pub async fn login_user(db: web::Data<MySqlPool>, req: web::Json<LoginRequest>) -> impl Responder {
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE username = ? AND company_tin = ?"
    )
    .bind(&req.username)
    .bind(&req.company_tin)
    .fetch_optional(db.get_ref())
    .await;

    match user {
        Ok(Some(u)) => {
            // Parse the stored password hash
            let parsed_hash = match argon2::PasswordHash::new(&u.password) {
                Ok(hash) => hash,
                Err(_) => return HttpResponse::InternalServerError().body("Invalid password hash format"),
            };

            // Verify the password
            let argon2 = argon2::Argon2::default();
            let is_valid = parsed_hash.verify_password(&[&argon2], req.password.as_bytes()).is_ok();

            if is_valid {
                HttpResponse::Ok().json("Login successful")
            } else {
                HttpResponse::Unauthorized().body("Invalid credentials")
            }
        }
        Ok(None) => HttpResponse::NotFound().body("User not found for this company"),
        Err(_) => HttpResponse::InternalServerError().body("DB error"),
    }
}
