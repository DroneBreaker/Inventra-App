use actix_web::{web, HttpResponse, Responder};
use sqlx::MySqlPool;

use crate::models::user::User;

pub async fn get_users(db: web::Data<MySqlPool>) -> impl Responder {
    let query = r#"
        SELECT
            id, first_name, last_name, email, username, company_name, company_id, company_tin, password, created_at, updated_at, deleted_at
            updated_at
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