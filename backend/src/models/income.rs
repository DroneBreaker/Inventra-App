use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Income {
    pub id: String,
    pub amount: f64,
    pub source: IncomeSource,
    pub description: String,
    pub date: DateTime<Utc>,
    pub client_id: Option<String>,
    pub invoice_id: Option<String>, // Only if this income is from an invoice
    pub advance_income_id: Option<String>, // Only if this income was converted from advance
    pub category: String,
    pub created_at: Option<DateTime<Utc>>,
    pub updated_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, Clone, PartialEq, sqlx::Type)]
pub enum IncomeSource {
    Invoice,
    DirectSale,
    Subscription,
    AdvanceIncomeConversion,
    Other,
}

impl std::fmt::Display for IncomeSource {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            IncomeSource::Invoice => write!(f, "Income"),
            IncomeSource::DirectSale => write!(f, "Direct Sale"),
            IncomeSource::Subscription => write!(f, "Subscription"),
            IncomeSource::AdvanceIncomeConversion => write!(f, "Advance Income Conversion"),
            IncomeSource::Other => write!(f, "Other"),
        }
    }
}