use chrono::{DateTime, Utc};
use serde::{Serialize,Deserialize};
use rust_decimal::Decimal;

use super::item::Item;

#[derive(Debug, Serialize, Deserialize)]
pub enum InvoiceStatus {
    Draft,
    Sent,
    Paid,
    Overdue,
    Canceled,
}


#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Invoice {
    pub id: String,
    pub invoice_number: String,
    pub client_name: String,
    pub client_tin: String,
    pub invoice_date: DateTime<Utc>,
    pub due_date: DateTime<Utc>,
    pub quantity: i32,
    pub price: Decimal,
    pub vat: Decimal, 
    #[sqlx(default)]
    pub sub_total: Decimal,
    #[sqlx(default)]
    pub total_amount: Decimal,
    pub status: InvoiceStatus,
    pub items: Vec<Item>
}

