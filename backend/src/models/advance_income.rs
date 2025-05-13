use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow, Clone)]
pub struct AdvanceInvoice {
    pub id: String,
    pub client_id: String,
    pub amount: f64,
    pub description: Option<String>,
    pub date_received: DateTime<Utc>,
    pub expected_delivery: Option<DateTime<Utc>>,
    pub status: AdvanceInvoiceStatus,
    pub applied_amount: f64,  // How much has been converted to actual invoice
    pub applied_to_invoice: bool,
    pub notes: Option<String>,
    pub related_invoices: Vec<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>
}

#[derive(Debug, Serialize, Deserialize, Clone, PartialEq)]
pub enum AdvanceInvoiceStatus {
    Pending,
    PartiallyApplied,
    FullyApplied
}

impl std::fmt::Display for AdvanceInvoiceStatus {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AdvanceInvoiceStatus::Pending => write!(f, "Pending"),
            AdvanceInvoiceStatus::PartiallyApplied => write!(f, "Partially Applied"),
            AdvanceInvoiceStatus::FullyApplied => write!(f, "Fully Applied")
        }
    }
}
