use chrono::{DateTime, Utc};
use serde::{Serialize,Deserialize};
use rust_decimal::Decimal;


#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Invoice {
    pub id: String,
    pub flag: InvoiceFlags,
    pub invoice_number: String,
    pub username: String,
    pub company_tin: String,
    pub client_name: String,
    pub client_tin: String,
    pub invoice_date: DateTime<Utc>,
    pub invoice_time: DateTime<Utc>,
    pub due_date: DateTime<Utc>,
    #[sqlx(default)]
    pub total_vat: Decimal, 
    #[sqlx(default)]
    pub total_amount: Decimal,
    pub status: InvoiceStatus,
    pub items: Vec<InvoiceItem>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct InvoiceItem {
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

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
pub enum InvoiceFlags {
    Invoice,
    Purchase,
    PartialRefund,
    FullRefund,
    PurchaseReturn,
    CreditNote,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
pub enum InvoiceStatus {
    Draft,
    Sent,
    Paid,
    Overdue,
    Canceled,
}

impl std::fmt::Display for InvoiceFlags {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            InvoiceFlags::Invoice => write!(f, "Invoice"),
            InvoiceFlags::Purchase => write!(f, "Purchase"),
            InvoiceFlags::PartialRefund => write!(f, "Partial Purchase"),
            InvoiceFlags::FullRefund => write!(f, "Full Purchase"), 
            InvoiceFlags::PurchaseReturn => write!(f, "Purchase Return"),
            InvoiceFlags::CreditNote => write!(f, "Credit Note"),
        }
    }
}



