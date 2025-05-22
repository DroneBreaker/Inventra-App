use actix_web::{web::{self, Path}, HttpResponse, Responder};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use chrono::Utc;
use serde_json::json;
use sqlx::{query, query_as, MySqlPool};
use uuid::Uuid;

use crate::{models::client::Client, utils::jwt::validate_jwt};

pub async fn create_clients(db: web::Data<MySqlPool>, req: web::Json<Client>, credentials: BearerAuth) -> impl Responder {
    // Validate JWT first
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => {
            eprintln!("JWT validation failed: {:?}", e);
            return HttpResponse::Unauthorized().json(json!({
                "error": "Invalid token"
            }));
        }
    };

    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    match sqlx::query!(
        r#"
            INSERT INTO clients 
                (id, client_name, client_email, client_tin, client_phone, company_tin, client_type, 
                created_at, updated_at, deleted_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        id,
        req.client_name,
        req.client_email,
        req.client_tin,
        req.client_phone,
        claims.tin,
        req.client_type,
        now, 
        now, 
        now
    )
    .execute(db.get_ref())
    .await
    {
        Ok(result) => {
            if result.rows_affected() == 1 {
                HttpResponse::Created().json(json!({
                    "message": "Client created successfully",
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