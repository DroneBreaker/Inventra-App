use actix_web::{web, HttpResponse, Responder};
use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use sqlx::MySqlPool;
use uuid::Uuid;

use crate::models::invoice::{InvoiceItem, *};

#[derive(Debug, serde::Deserialize)]
pub struct CreateInvoiceRequest {
    pub id: String,
    pub flag: InvoiceFlags,
    pub invoice_number: String,
    pub username: String,
    pub client_name: String,
    pub client_tin: String,
    pub invoice_date: chrono::DateTime<Utc>,
    pub invoice_time: chrono::NaiveTime,
    pub due_date: Option<chrono::DateTime<Utc>>,
    pub items: Vec<CreateInvoiceItemRequest>, 
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, serde::Deserialize)]
pub struct CreateInvoiceItemRequest {
    pub id: String,
    pub invoice_id: String, // foreign key to Invoice
    pub item_code: String,    // foreign key to Item
    pub quantity: i32,
    pub unit_price: Decimal,
    pub total_vat: Decimal,
    pub total_levy: Decimal,
    pub total_discount: Decimal,
    pub line_total: Decimal, // (quantity * unit_price) - discount + tax
}

pub async fn create_invoice(db: web::Data<MySqlPool>, req: web::Json<CreateInvoiceRequest>,) -> impl Responder {
    let invoice_id = Uuid::new_v4().to_string();
    let now = Utc::now();

    // Calculate totals
    let mut vat_total = Decimal::ZERO;
    let mut total_amount = Decimal::ZERO;

    for item in &req.items {
        let line_total = item.unit_price * Decimal::from(item.quantity)
            - item.total_discount
            + item.total_vat;

        // sub_total += item.unit_price * Decimal::from(item.quantity);
        vat_total += item.total_vat;
        total_amount += line_total;
    }

    // Insert invoice
    let insert_invoice = sqlx::query!(
        r#"
        INSERT INTO invoices (
            id, flag, invoice_number, username, client_name, client_tin, invoice_date, invoice_time, 
            due_date, status, company_tin, total_amount, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        invoice_id,
        req.invoice_number,
        req.client_id,
        req.company_tin,
        req.invoice_date,
        req.invoice_time,
        req.due_date,
        req,
        total_vat,
        total_amount,
        req.status as InvoiceStatus,
        now,
        now
    )
    .execute(db.get_ref())
    .await;

    if let Err(e) = insert_invoice {
        eprintln!("Insert invoice error: {:?}", e);
        return HttpResponse::InternalServerError().json(serde_json::json!({ "error": "Could not create invoice" }));
    }

    // Insert invoice items
    for item in &req.items {
        let item_id = Uuid::new_v4().to_string();
        let line_total = item.unit_price * Decimal::from(item.quantity)
            - item.total_discount
            + item.total_vat;

        let insert_item = sqlx::query!(
            r#"
            INSERT INTO invoice_items (
                id, invoice_id, item_id, quantity, unit_price,
                tax_amount, discount, line_total
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            "#,
            item_id,
            invoice_id,
            item.item_code,
            item.quantity,
            item.unit_price,
            item.total_vat,
            item.total_discount,
            line_total
        )
        .execute(db.get_ref())
        .await;

        if let Err(e) = insert_item {
            eprintln!("Insert item error: {:?}", e);
            return HttpResponse::InternalServerError().json(serde_json::json!({ 
                "error": "Could not insert invoice items" 
            }));
        }
    }

    HttpResponse::Ok().json(serde_json::json!({
        "message": "Invoice created successfully",
        "invoice_id": invoice_id
    }))
}

pub async fn get_invoice_by_id(db: web::Data<MySqlPool>,path: web::Path<String>) -> impl Responder {
    let id = path.into_inner();

    let invoice = sqlx::query_as!(
        Invoice,
        r#"
        SELECT * FROM invoices WHERE id = ?
        "#,
        id
    )
    .fetch_optional(db.get_ref())
    .await;

    match invoice {
        Ok(Some(invoice)) => HttpResponse::Ok().json(invoice),
        Ok(None) => HttpResponse::NotFound().json(serde_json::json!({ "error": "Invoice not found" })),
        Err(err) => {
            eprintln!("DB error: {:?}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({ "error": "Server error" }))
        }
    }
}

// pub async fn get_invoices_by_company_tin(db: web::Data<MySqlPool>,path: web::Path<String>,) -> impl Responder {
//     let tin = path.into_inner();

//     let invoices = sqlx::query_as!(
//         Invoice,
//         r#"
//         SELECT * FROM invoices WHERE company_tin = ?
//         "#,
//         tin
//     )
//     .fetch_all(db.get_ref())
//     .await;

//     match invoices {
//         Ok(data) => HttpResponse::Ok().json(data),
//         Err(err) => {
//             eprintln!("DB error: {:?}", err);
//             HttpResponse::InternalServerError().json(serde_json::json!({ "error": "Failed to get invoices" }))
//         }
//     }
// }

