use actix_web::{web, HttpRequest, HttpResponse, Responder, Result};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use serde::{Deserialize, Serialize};
use serde_json::json;
use sqlx::{MySqlPool, Row};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use rust_decimal::Decimal;

use crate::{models::invoice::{Invoice, InvoiceFlags, InvoiceItem, InvoiceStatus}, utils::jwt::validate_jwt};

#[derive(Debug, Deserialize)]
pub struct CreateInvoiceRequest {
    pub flag: InvoiceFlags,
    pub invoice_number: String,
    pub username: String,
    pub client_name: String,
    pub client_tin: String,
    pub invoice_date: DateTime<Utc>,
    pub invoice_time: DateTime<Utc>,
    pub due_date: DateTime<Utc>,
    pub total_vat: Decimal,
    pub total_amount: Decimal, 
    pub items: Vec<CreateInvoiceItemRequest>,
    pub created_at: DateTime<Utc>
}

#[derive(Debug, Deserialize)]
pub struct CreateInvoiceItemRequest {
    pub item_code: String,
    pub quantity: i32,
    pub unit_price: Decimal,
    pub total_vat: Decimal,
    pub total_levy: Decimal,
    pub total_discount: Decimal,
    pub line_total: Decimal,
}

#[derive(Debug, Deserialize)]
pub struct UpdateInvoiceRequest {
    pub flag: Option<InvoiceFlags>,
    pub invoice_number: Option<String>,
    pub username: Option<String>,
    pub client_name: Option<String>,
    pub client_tin: Option<String>,
    pub invoice_date: Option<DateTime<Utc>>,
    pub invoice_time: Option<DateTime<Utc>>,
    pub due_date: Option<DateTime<Utc>>,
    pub status: Option<InvoiceStatus>,
    pub items: Option<Vec<CreateInvoiceItemRequest>>,
}

#[derive(Debug, Serialize)]
pub struct InvoiceResponse {
    pub invoice: Invoice,
    pub items: Vec<InvoiceItem>,
}

#[derive(Debug, Deserialize)]
pub struct InvoiceQueryParams {
    pub page: Option<i64>,
    pub limit: Option<i64>,
    pub status: Option<InvoiceStatus>,
    pub flag: Option<InvoiceFlags>,
    pub start_date: Option<DateTime<Utc>>,
    pub end_date: Option<DateTime<Utc>>,
}


pub async fn create_invoice(db: web::Data<MySqlPool>, req: web::Json<CreateInvoiceRequest>, credentials: BearerAuth) -> impl Responder {
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => {
            eprintln!("JWT validation failed: {:?}", e);
            return HttpResponse::Unauthorized().json(json!({
                "error": "Invalid token",
                "details": e.to_string()
            }));
        }
    };

    // Create IDs and timestamps
    let invoice_id = Uuid::new_v4().to_string();
    let now = Utc::now();

    // Calculate totals
    let mut total_vat = Decimal::ZERO;
    let mut total_amount = Decimal::ZERO;

    for item in &req.items {
        let line_total = item.unit_price * Decimal::from(item.quantity)
            - item.total_discount
            + item.total_vat;
        total_vat += item.total_vat;
        total_amount += line_total;
    }

    // Insert into `invoices` table
    let insert_invoice_result = sqlx::query!(
        r#"
        INSERT INTO invoices (
            id, flag, invoice_number, username, company_tin, client_name, client_tin, 
            invoice_date, invoice_time, due_date, total_amount, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        invoice_id,
        req.flag.to_string(),
        req.invoice_number,
        req.username,
        claims.tin,
        req.client_name,
        req.client_tin,
        req.invoice_date,
        req.invoice_time,
        req.due_date,
        // InvoiceStatus::Draft.to_string(),
        // total_vat,
        total_amount,
        now,
    )
    .execute(db.get_ref())
    .await;

    if let Err(e) = insert_invoice_result {
        eprintln!("Insert invoice error: {:?}", e);
        return HttpResponse::InternalServerError().json(json!({ "error": "Could not create invoice" }));
    }

    // Insert invoice items
    for item in &req.items {
        let item_id = Uuid::new_v4().to_string();
        let line_total = item.unit_price * Decimal::from(item.quantity)
            - item.total_discount
            + item.total_vat;

        let insert_item_result = sqlx::query!(
            r#"
            INSERT INTO invoice_items (
                id, invoice_id, item_code, quantity, unit_price,
                total_vat, total_levy, total_discount, line_total
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            "#,
            item_id,
            invoice_id,
            item.item_code,
            item.quantity,
            item.unit_price,
            item.total_vat,
            item.total_levy,
            item.total_discount,
            line_total
        )
        .execute(db.get_ref())
        .await;

        if let Err(e) = insert_item_result {
            eprintln!("Insert item error: {:?}", e);
            return HttpResponse::InternalServerError().json(json!({
                "error": "Could not insert invoice item"
            }));
        }
    }

    // Respond with success
    HttpResponse::Ok().json(json!({
        "message": "Invoice created successfully",
        "invoice_id": invoice_id
    }))
}


// // Get invoice by ID handler
// // pub async fn get_invoice(db: web::Data<MySqlPool>, path: web::Path<String>, credentials: BearerAuth) -> impl Responder {
// //     // Validate JWT
// //     let claims = match validate_jwt(credentials.token()) {
// //         Ok(claims) => claims,
// //         Err(e) => return HttpResponse::Unauthorized().json(json!({"error": "Invalid token"})),
// //     };

// //     let invoice_id = path.into_inner();

// //     // Get invoice with company_tin check
// //     let invoice = sqlx::query_as!(
// //         Invoice,
// //         r#"
// //         SELECT * FROM invoices 
// //         WHERE id = ? AND company_tin = ?
// //         "#,
// //         invoice_id,
// //         company_tin
// //     )
// //     .fetch_optional(&**db)
// //     .await
// //     .map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //     })?;

// //     let invoice = match invoice {
// //         Some(inv) => inv,
// //         None => return Ok(HttpResponse::NotFound().json("Invoice not found")),
// //     };

// //     // Get invoice items
// //     let items = sqlx::query_as!(
// //         InvoiceItem,
// //         r#"
// //         SELECT * FROM invoice_items 
// //         WHERE invoice_id = ?
// //         ORDER BY id
// //         "#,
// //         invoice_id
// //     )
// //     .fetch_all(&**db)
// //     .await
// //     .map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //     })?;

// //     Ok(HttpResponse::Ok().json(InvoiceResponse { invoice, items }))
// // }

// // Get all invoices for company handler
// // pub async fn get_invoices(
// //     pool: web::Data<PgPool>,
// //     req: HttpRequest,
// //     query: web::Query<InvoiceQueryParams>,
// // ) -> Result<HttpResponse> {
// //     let company_tin = extract_company_tin(&req)?;
    
// //     let page = query.page.unwrap_or(1);
// //     let limit = query.limit.unwrap_or(10);
// //     let offset = (page - 1) * limit;

// //     let mut query_builder = sqlx::QueryBuilder::new(
// //         "SELECT * FROM invoices WHERE company_tin = "
// //     );
// //     query_builder.push_bind(&company_tin);

// //     // Add filters
// //     if let Some(status) = &query.status {
// //         query_builder.push(" AND status = ");
// //         query_builder.push_bind(status);
// //     }

// //     if let Some(flag) = &query.flag {
// //         query_builder.push(" AND flag = ");
// //         query_builder.push_bind(flag);
// //     }

// //     if let Some(start_date) = &query.start_date {
// //         query_builder.push(" AND invoice_date >= ");
// //         query_builder.push_bind(start_date);
// //     }

// //     if let Some(end_date) = &query.end_date {
// //         query_builder.push(" AND invoice_date <= ");
// //         query_builder.push_bind(end_date);
// //     }

// //     query_builder.push(" ORDER BY created_at DESC LIMIT ");
// //     query_builder.push_bind(limit);
// //     query_builder.push(" OFFSET ");
// //     query_builder.push_bind(offset);

// //     let invoices = query_builder
// //         .build_query_as::<Invoice>()
// //         .fetch_all(&**pool)
// //         .await
// //         .map_err(|e| {
// //             HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //         })?;

// //     // Get total count
// //     let total_count = sqlx::query_scalar!(
// //         "SELECT COUNT(*) FROM invoices WHERE company_tin = $1",
// //         company_tin
// //     )
// //     .fetch_one(&**pool)
// //     .await
// //     .map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //     })?;

// //     Ok(HttpResponse::Ok().json(serde_json::json!({
// //         "invoices": invoices,
// //         "pagination": {
// //             "page": page,
// //             "limit": limit,
// //             "total": total_count.unwrap_or(0),
// //             "total_pages": (total_count.unwrap_or(0) + limit - 1) / limit
// //         }
// //     })))
// // }

// // // Update invoice handler
// // pub async fn update_invoice(
// //     pool: web::Data<PgPool>,
// //     req: HttpRequest,
// //     path: web::Path<String>,
// //     update_data: web::Json<UpdateInvoiceRequest>,
// // ) -> Result<HttpResponse> {
// //     let company_tin = extract_company_tin(&req)?;
// //     let invoice_id = path.into_inner();

// //     let mut tx = pool.begin().await.map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //     })?;

// //     // Check if invoice exists and belongs to company
// //     let existing_invoice = sqlx::query!(
// //         "SELECT id FROM invoices WHERE id = $1 AND company_tin = $2",
// //         invoice_id,
// //         company_tin
// //     )
// //     .fetch_optional(&mut *tx)
// //     .await
// //     .map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //     })?;

// //     if existing_invoice.is_none() {
// //         return Ok(HttpResponse::NotFound().json("Invoice not found"));
// //     }

// //     // Build dynamic update query
// //     let mut query_builder = sqlx::QueryBuilder::new("UPDATE invoices SET updated_at = NOW()");
    
// //     if let Some(flag) = &update_data.flag {
// //         query_builder.push(", flag = ");
// //         query_builder.push_bind(flag);
// //     }
    
// //     if let Some(invoice_number) = &update_data.invoice_number {
// //         query_builder.push(", invoice_number = ");
// //         query_builder.push_bind(invoice_number);
// //     }
    
// //     if let Some(username) = &update_data.username {
// //         query_builder.push(", username = ");
// //         query_builder.push_bind(username);
// //     }
    
// //     if let Some(client_name) = &update_data.client_name {
// //         query_builder.push(", client_name = ");
// //         query_builder.push_bind(client_name);
// //     }
    
// //     if let Some(client_tin) = &update_data.client_tin {
// //         query_builder.push(", client_tin = ");
// //         query_builder.push_bind(client_tin);
// //     }
    
// //     if let Some(invoice_date) = &update_data.invoice_date {
// //         query_builder.push(", invoice_date = ");
// //         query_builder.push_bind(invoice_date);
// //     }
    
// //     if let Some(invoice_time) = &update_data.invoice_time {
// //         query_builder.push(", invoice_time = ");
// //         query_builder.push_bind(invoice_time);
// //     }
    
// //     if let Some(due_date) = &update_data.due_date {
// //         query_builder.push(", due_date = ");
// //         query_builder.push_bind(due_date);
// //     }
    
// //     if let Some(status) = &update_data.status {
// //         query_builder.push(", status = ");
// //         query_builder.push_bind(status);
// //     }

// //     query_builder.push(" WHERE id = ");
// //     query_builder.push_bind(&invoice_id);
// //     query_builder.push(" AND company_tin = ");
// //     query_builder.push_bind(&company_tin);

// //     query_builder.build()
// //         .execute(&mut *tx)
// //         .await
// //         .map_err(|e| {
// //             HttpResponse::InternalServerError().json(format!("Failed to update invoice: {}", e))
// //         })?;

// //     // Update items if provided
// //     if let Some(items) = &update_data.items {
// //         // Delete existing items
// //         sqlx::query!(
// //             "DELETE FROM invoice_items WHERE invoice_id = $1",
// //             invoice_id
// //         )
// //         .execute(&mut *tx)
// //         .await
// //         .map_err(|e| {
// //             HttpResponse::InternalServerError().json(format!("Failed to delete old items: {}", e))
// //         })?;

// //         // Insert new items
// //         for item_data in items {
// //             let item_id = Uuid::new_v4().to_string();
// //             sqlx::query!(
// //                 r#"
// //                 INSERT INTO invoice_items (
// //                     id, invoice_id, item_code, quantity, unit_price, 
// //                     total_vat, total_levy, total_discount, line_total
// //                 ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
// //                 "#,
// //                 item_id,
// //                 invoice_id,
// //                 item_data.item_code,
// //                 item_data.quantity,
// //                 item_data.unit_price,
// //                 item_data.total_vat,
// //                 item_data.total_levy,
// //                 item_data.total_discount,
// //                 item_data.line_total
// //             )
// //             .execute(&mut *tx)
// //             .await
// //             .map_err(|e| {
// //                 HttpResponse::InternalServerError().json(format!("Failed to create invoice item: {}", e))
// //             })?;
// //         }

// //         // Update invoice totals
// //         let total_vat: Decimal = items.iter().map(|item| item.total_vat).sum();
// //         let total_amount: Decimal = items.iter().map(|item| item.line_total).sum();
        
// //         sqlx::query!(
// //             "UPDATE invoices SET total_vat = $1, total_amount = $2 WHERE id = $3",
// //             total_vat,
// //             total_amount,
// //             invoice_id
// //         )
// //         .execute(&mut *tx)
// //         .await
// //         .map_err(|e| {
// //             HttpResponse::InternalServerError().json(format!("Failed to update totals: {}", e))
// //         })?;
// //     }

// //     tx.commit().await.map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Transaction commit failed: {}", e))
// //     })?;

// //     Ok(HttpResponse::Ok().json("Invoice updated successfully"))
// // }

// // // Delete invoice handler
// // pub async fn delete_invoice(
// //     pool: web::Data<PgPool>,
// //     req: HttpRequest,
// //     path: web::Path<String>,
// // ) -> Result<HttpResponse> {
// //     let company_tin = extract_company_tin(&req)?;
// //     let invoice_id = path.into_inner();

// //     let mut tx = pool.begin().await.map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Database error: {}", e))
// //     })?;

// //     // Delete invoice items first (due to foreign key constraint)
// //     sqlx::query!(
// //         "DELETE FROM invoice_items WHERE invoice_id = $1",
// //         invoice_id
// //     )
// //     .execute(&mut *tx)
// //     .await
// //     .map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Failed to delete invoice items: {}", e))
// //     })?;

// //     // Delete invoice (with company_tin check)
// //     let result = sqlx::query!(
// //         "DELETE FROM invoices WHERE id = $1 AND company_tin = $2",
// //         invoice_id,
// //         company_tin
// //     )
// //     .execute(&mut *tx)
// //     .await
// //     .map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Failed to delete invoice: {}", e))
// //     })?;

// //     if result.rows_affected() == 0 {
// //         return Ok(HttpResponse::NotFound().json("Invoice not found"));
// //     }

// //     tx.commit().await.map_err(|e| {
// //         HttpResponse::InternalServerError().json(format!("Transaction commit failed: {}", e))
// //     })?;

// //     Ok(HttpResponse::Ok().json("Invoice deleted successfully"))
// // }

// // // Configure routes
// // pub fn configure_routes(cfg: &mut web::ServiceConfig) {
// //     cfg.service(
// //         web::scope("/api/invoices")
// //             .route("", web::post().to(create_invoice))
// //             .route("", web::get().to(get_invoices))
// //             .route("/{id}", web::get().to(get_invoice))
// //             .route("/{id}", web::put().to(update_invoice))
// //             .route("/{id}", web::delete().to(delete_invoice))
// //     );
// // }