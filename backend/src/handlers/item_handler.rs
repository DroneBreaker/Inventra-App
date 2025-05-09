use actix_web::{web, HttpResponse, Responder};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use chrono::Utc;
use sqlx::MySqlPool;
use uuid::Uuid;
use serde_json::json;


use crate::{models::item::Item, utils::jwt::validate_jwt};


pub async fn get_items(db: web::Data<MySqlPool>, credentials: BearerAuth) -> impl Responder {
    // Validate JWT using your existing utility
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => {
            eprintln!("JWT validation failed: {:?}", e);
            return HttpResponse::Unauthorized().json("Invalid token");
        }
    };

    // The company_tin is stored in claims.sub
    let company_tin = claims.sub;


    let query = r#"
        SELECT
            id, item_code, item_name, item_description, price, is_taxable, is_tax_inclusive, company_tin, item_category, is_taxable, 
            is_taxinclusive, remarks, created_at, updated_at
        FROM items
        WHERE company_tin = ?
    "#; 

    let result = sqlx::query_as::<_, Item>(query)
        .bind(company_tin)
        .fetch_all(db.get_ref())
        .await;

    match result {
        Ok(items) => HttpResponse::Ok().json(items),
        Err(err) => {
            eprintln!("DB error: {:?}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to fetch items"
        }))
        }
    }
} 


pub async fn create_items(db: web::Data<MySqlPool>, req: web::Json<Item>, credentials: BearerAuth,) -> impl Responder {
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
            INSERT INTO items 
                (id, item_code, item_name, item_description, price, is_taxable, is_tax_inclusive, 
                tourism_cst_option, company_tin, created_at, updated_at, deleted_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        id,
        req.item_code,
        req.item_name,
        req.item_description,
        req.price,
        req.is_taxable,
        req.is_tax_inclusive,
        req.tourism_cst_option,
        claims.sub, // Use company_tin from JWT claims
        now,
        now,
        Option::<chrono::DateTime<Utc>>::None // Use NULL for deleted_at
    )
    .execute(db.get_ref())
    .await
    {
        Ok(result) => {
            if result.rows_affected() == 1 {
                HttpResponse::Created().json(json!({
                    "id": id,
                    "message": "Item created successfully"
                }))
            } else {
                HttpResponse::InternalServerError().json(json!({
                    "error": "Failed to create item"
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