use chrono::{DateTime, Utc};
use serde::{Serialize,Deserialize};
use rust_decimal::Decimal;

use super::item::Item;

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Invoice {
    pub id: String,
    pub invoice_number: String,
    pub seller: String,
    pub company_tin: String,
    pub client_name: String,
    pub client_tin: String,
    pub invoice_date: DateTime<Utc>,
    pub due_date: DateTime<Utc>,
    #[sqlx(default)]
    pub total_vat: Decimal, 
    #[sqlx(default)]
    pub total_amount: Decimal,
    pub status: InvoiceStatus,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct InvoiceItem {
    pub id: String,
    pub invoice_id: String, // foreign key to Invoice
    pub item_id: String,    // foreign key to Item
    pub quantity: i32,
    pub unit_price: Decimal,
    pub tax_amount: Decimal,
    pub discount: Decimal,
    pub line_total: Decimal, // (quantity * unit_price) - discount + tax
}



#[derive(Debug, Serialize, Deserialize)]
pub enum InvoiceStatus {
    Draft,
    Sent,
    Paid,
    Overdue,
    Canceled,
}



