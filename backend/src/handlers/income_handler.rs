use actix_web::{web, HttpResponse, Responder};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, MySqlPool};
use uuid::Uuid;
use crate::models::income::{Income,IncomeSource};

use crate::models;

// Income endpoints module
// pub fn income_config(cfg: &mut web::ServiceConfig) {
//     cfg.service(
//         web::scope("/incomes")
//             .route("", web::get().to(get_all_incomes))
//             .route("", web::post().to(create_income))
//             .route("/{id}", web::get().to(get_income))
//             .route("/{id}", web::put().to(update_income))
//             .route("/{id}", web::delete().to(delete_income))
//             .route("/source/{source}", web::get().to(get_incomes_by_source))
//             .route("/customer/{customer_id}", web::get().to(get_incomes_by_customer)),
//     );
// }

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct CreateIncomeRequest {
    pub id: String,
    pub amount: f64,
    pub source: models::income::IncomeSource,
    pub description: String,
    pub date: DateTime<Utc>,
    pub client_id: Option<Uuid>,
    pub invoice_id: Option<Uuid>, // Only if this income is from an invoice
    pub advance_income_id: Option<Uuid>, // Only if this income was converted from advance
    pub category: String,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct UpdateIncomeRequest {
    pub id: String,
    pub amount: f64,
    pub source: models::income::IncomeSource,
    pub description: String,
    pub date: DateTime<Utc>,
    pub client_id: Option<Uuid>,
    pub invoice_id: Option<Uuid>, // Only if this income is from an invoice
    pub advance_income_id: Option<Uuid>, // Only if this income was converted from advance
    pub category: String,
}

#[derive(Debug, Deserialize)]
pub struct Pagination {
    pub page: Option<u32>,
    pub per_page: Option<u32>,
}

pub async fn get_all_incomes<PaginationParams>(db: web::Data<MySqlPool>, query: web::Query<Pagination>) -> impl Responder {
    let Pagination { page, per_page } = query.into_inner();
    let offset = (page.unwrap_or(1) - 1) * per_page.unwrap_or(10);

    match sqlx::query_as!(
        Income,
        r#"
        SELECT 
            id, 
            amount, 
            source as "source: IncomeSource", 
            description, 
            COALESCE(CONVERT_TZ(date, '+00:00', @@session.time_zone), UTC_TIMESTAMP()) as "date: DateTime<Utc>",
            client_id, 
            invoice_id, 
            advance_income_id, 
            category, 
            COALESCE(CONVERT_TZ(created_at, '+00:00', @@session.time_zone), UTC_TIMESTAMP()) as "created_at: DateTime<Utc>",
            COALESCE(CONVERT_TZ(updated_at, '+00:00', @@session.time_zone), UTC_TIMESTAMP()) as "updated_at: DateTime<Utc>"
        FROM incomes
        ORDER BY date DESC
        LIMIT ? OFFSET ?
        "#,
        per_page.unwrap_or(10),
        offset
    )
    .fetch_all(db.get_ref())
    .await
    {
        Ok(incomes) => HttpResponse::Ok().json(incomes),
        Err(e) => {
            eprintln!("Failed to fetch incomes: {:?}", e);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to fetch incomes".to_string(),
            }))
        }
    }
}

// POST /incomes - Create new income
pub async fn create_income(db: web::Data<MySqlPool>, req: web::Json<CreateIncomeRequest>) -> impl Responder {
    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    // First perform the INSERT
    match sqlx::query!(
        r#"
        INSERT INTO incomes (
            id, 
            amount, 
            source, 
            description, 
            date, 
            client_id, 
            invoice_id, 
            advance_income_id, 
            category, 
            created_at, 
            updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        id,
        req.amount,
        req.source.clone() as IncomeSource,
        req.description,
        req.date,
        req.client_id,
        req.invoice_id,
        req.advance_income_id,
        req.category,
        now,
        now
    )
    .execute(db.get_ref())
    .await {
        Ok(_) => {
            // Then fetch the inserted record with the proper type annotation for source
            match sqlx::query_as!(
                Income,
                r#"
                SELECT 
                    id, 
                    amount, 
                    source as "source: IncomeSource", 
                    description, 
                    date as "date: DateTime<Utc>",
                    client_id, 
                    invoice_id, 
                    advance_income_id, 
                    category, 
                    created_at as "created_at: DateTime<Utc>",
                    updated_at as "updated_at: DateTime<Utc>"
                FROM incomes 
                WHERE id = ?
                "#,
                id
            )
            .fetch_one(db.get_ref())
            .await {
                Ok(income) => HttpResponse::Created().json(serde_json::json!({
                    "message": "Income created successfully",
                    "income": income
                })),
                Err(e) => {
                    eprintln!("Failed to fetch created income: {:?}", e);
                    HttpResponse::InternalServerError().json(serde_json::json!({
                        "error": "Failed to fetch created income".to_string(),
                    }))
                }
            }
        },
        Err(e) => {
            eprintln!("Failed to create income: {:?}", e);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to create income".to_string(),
            }))
        }
    }
}

// GET /incomes/{id} - Get specific income
pub async fn get_income(db: web::Data<MySqlPool>,path: web::Path<String>) -> impl Responder {
    let income_id = path.into_inner();

    match sqlx::query_as!(
        Income,
        r#"
        SELECT 
            id, 
            amount, 
            source as "source: IncomeSource", 
            description, 
            COALESCE(CONVERT_TZ(date, '+00:00', @@session.time_zone), UTC_TIMESTAMP()) as "date: DateTime<Utc>",
            client_id, 
            invoice_id, 
            advance_income_id, 
            category, 
            COALESCE(CONVERT_TZ(created_at, '+00:00', @@session.time_zone), UTC_TIMESTAMP()) as "created_at: DateTime<Utc>",
            COALESCE(CONVERT_TZ(updated_at, '+00:00', @@session.time_zone), UTC_TIMESTAMP()) as "updated_at: DateTime<Utc>"
        FROM incomes
        WHERE id = ?
        "#,
        income_id
    )
    .fetch_optional(db.get_ref())
    .await
    {
        Ok(Some(income)) => HttpResponse::Ok().json(income),
        
        Ok(None) => HttpResponse::NotFound().json(serde_json::json!({
            "error": "Income not found".to_string(),
        })),
        
        Err(e) => {
            eprintln!("Failed to fetch income: {:?}", e);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to fetch income".to_string(),
            }))
        }
    }
}

// PUT /incomes/{id} - Update income
// async fn update_income(db: web::Data<MySqlPool>, path: web::Path<String>, income_data: web::Json<UpdateIncomeRequest>) -> impl Responder {
//     let income_id = path.into_inner();
//     let now = Utc::now();

//     match sqlx::query_as!(
//         Income,
//         r#"
//             UPDATE incomes
//             SET 
//                 amount = ?, 
//                 source = ?, 
//                 description = ?, 
//                 date = ?, 
//                 customer_id = ?,
//         "#
//     )
// }