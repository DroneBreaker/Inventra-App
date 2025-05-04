use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Item {
    pub id: String,
    pub item_code: i64,
    pub item_name: String,
    pub item_description: String,
    pub price: f64,
    pub company_tin: String,
    pub item_category: ItemCategory, // Regular, Rent, Exempt
    pub remarks: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: DateTime<Utc>,
        // isTaxable, isTaxable, Discount
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
pub enum ItemCategory {
    RegularVAT,
    Rent,
    Exempt
}

impl std::fmt::Display for ItemCategory {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            ItemCategory::RegularVAT => write!(f, "Regular VAT"),
            ItemCategory::Rent => write!(f, "Rent"),
            ItemCategory::Exempt => write!(f, "Exempt"),
        }
    }
}
