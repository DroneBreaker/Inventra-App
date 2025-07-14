use std::collections::HashMap;

use actix_web::{web::{self, Path}, HttpResponse, Responder};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use chrono::{NaiveDateTime, Utc};
use serde::Deserialize;
use serde_json::json;
use sqlx::{query, query_as, MySqlPool};
use uuid::Uuid;

use crate::{models::client::{Client, ClientType}, utils::jwt::validate_jwt};

#[derive(Debug, Deserialize)]
pub struct CreateClientRequest {
    pub id: Option<String>,
    pub client_name: String,
    pub client_email: String,
    pub client_tin: String,
    pub client_phone: String,
    pub client_type: ClientType,
} 

#[derive(Debug, Deserialize)]
pub struct UpdateClientRequest {
    pub client_name: String,
    pub client_email: String,
    pub client_tin: String,
    pub client_phone: String,
    pub client_type: ClientType,
}

pub async fn get_clients(db: web::Data<MySqlPool>, credentials: BearerAuth) -> impl Responder {
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(_) => return HttpResponse::Unauthorized().json(json!({ "error": "Invalid token" })),
    };

    
    let result = sqlx::query_as::<_, Client>(
        r#"
            SELECT 
                id, client_name, client_email, client_tin, client_phone, company_tin, 
                client_type, created_at, updated_at, deleted_at
            FROM clients 
            WHERE company_tin = ? AND deleted_at IS NULL
            ORDER BY created_at DESC
        "#,
    )
    .bind(&claims.tin)
    .fetch_all(db.get_ref())
    .await;

    match result {
        Ok(clients) => HttpResponse::Ok().json(clients),
        Err(e) => {
            eprintln!("DB error: {:?}", e);
            HttpResponse::InternalServerError().json(json!({ "error": "Failed to fetch clients" }))
        }
    }
}


pub async fn create_clients(db: web::Data<MySqlPool>, req: web::Json<CreateClientRequest>, credentials: BearerAuth) -> impl Responder {
    // Validate JWT
    // let claims = match validate_jwt(credentials.token()) {
    //     Ok(claims) => claims,
    //     Err(e) => {
    //         eprintln!("JWT validation failed: {:?}", e);
    //         return HttpResponse::Unauthorized().json(json!({
    //             "error": "Invalid token"
    //         }));
    //     }
    // };

    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => return HttpResponse::Unauthorized().json(json!({"error": "Invalid token"})),
    };

    let id = Uuid::new_v4().to_string();
    // let now = Utc::now();
    let now = Utc::now().naive_utc();


    match sqlx::query!(
        r#"
            INSERT INTO clients 
                (id, client_name, client_email, client_tin, client_phone, company_tin, client_type, 
                created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        id,
        req.client_name,
        req.client_email,
        req.client_tin,
        req.client_phone,
        claims.tin,
        req.client_type,
        now, 
        now
    )
    .execute(db.get_ref())
    .await
    {
        Ok(result) => {
            if result.rows_affected() == 1 {
                let client = Client {
                id,
                client_name: req.client_name.clone(),
                client_email: req.client_email.clone(),
                client_tin: req.client_tin.clone(),
                client_phone: req.client_phone.clone(),
                company_tin: claims.tin,
                client_type: req.client_type.clone(),
                created_at: now,
                updated_at: now,
                deleted_at: None,
            };

            
                HttpResponse::Created().json(json!({
                    "message": "Client created successfully",
                    "customer": client
                }))
            } else {
                HttpResponse::InternalServerError().json(json!({
                    "error": "Failed to create client"
                }))
            }
        },
        Err(err) => {
            eprintln!("Database error: {:?}", err);
            HttpResponse::InternalServerError().json(json!({
                "error": "Database operation failed",
                "details": err.to_string()
            }))
        }
    }
}

pub async fn get_client_by_name(db: web::Data<MySqlPool>, credentials: BearerAuth,
    path: web::Path<String>,
) -> impl Responder {
    let name = path.into_inner();
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(_) => return HttpResponse::Unauthorized().json(json!({ "error": "Invalid token" })),
    };

    let result = sqlx::query_as::<_, Client>(
        r#"
            SELECT * FROM clients
            WHERE client_name = ? AND company_tin = ? AND deleted_at IS NULL
        "#
    )
    .bind(name)
    .bind(claims.tin)
    .fetch_optional(db.get_ref())
    .await;

    match result {
        Ok(Some(client)) => HttpResponse::Ok().json(client),
        Ok(None) => HttpResponse::NotFound().json(json!({ "error": "Client not found" })),
        Err(e) => {
            eprintln!("DB error: {:?}", e);
            HttpResponse::InternalServerError().json(json!({ "error": "Failed to fetch client" }))
        }
    }
}


pub async fn update_client(db: web::Data<MySqlPool>, credentials: BearerAuth, path: web::Path<String>, 
req: web::Json<UpdateClientRequest>) -> impl Responder {
    let id = path.into_inner();
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(_) => return HttpResponse::Unauthorized().json(json!({ "error": "Invalid token" })),
    };

    let now = Utc::now();

    let result = sqlx::query!(
        r#"
        UPDATE clients
        SET client_name = ?, client_email = ?, client_tin = ?, client_phone = ?, client_type = ?, updated_at = ?
        WHERE id = ? AND company_tin = ? AND deleted_at IS NULL
        "#,
        req.client_name,
        req.client_email,
        req.client_tin,
        req.client_phone,
        req.client_type.clone(),
        now,
        id,
        claims.tin
    )
    .execute(db.get_ref())
    .await;

    match result {
        Ok(res) if res.rows_affected() == 1 => HttpResponse::Ok().json(json!({ "message": "Client updated" })),
        Ok(_) => HttpResponse::NotFound().json(json!({ "error": "Client not found or no change" })),
        Err(e) => {
            eprintln!("Update error: {:?}", e);
            HttpResponse::InternalServerError().json(json!({ "error": "Update failed" }))
        }
    }
}


pub async fn delete_client(db: web::Data<MySqlPool>, credentials: BearerAuth, path: web::Path<String>,
) -> impl Responder {
    let id = path.into_inner();
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(_) => return HttpResponse::Unauthorized().json(json!({ "error": "Invalid token" })),
    };

    let now = Utc::now();

    let result = sqlx::query!(
        r#"
        UPDATE clients
        SET deleted_at = ?
        WHERE id = ? AND company_tin = ? AND deleted_at IS NULL
        "#,
        now,
        id,
        claims.tin
    )
    .execute(db.get_ref())
    .await;

    match result {
        Ok(res) if res.rows_affected() == 1 => HttpResponse::Ok().json(json!({ "message": "Client deleted" })),
        Ok(_) => HttpResponse::NotFound().json(json!({ "error": "Client not found" })),
        Err(e) => {
            eprintln!("Delete error: {:?}", e);
            HttpResponse::InternalServerError().json(json!({ "error": "Delete failed" }))
        }
    }
}

