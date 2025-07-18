use chrono::{NaiveDateTime};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Item {
    pub id: Option<String>,
    pub item_code: String,
    pub item_name: String,
    pub item_description: Option<String>,
    pub price: f64,
    pub company_tin: String,
    pub item_category: ItemCategory, // Regular, Rent, Exempt
    pub is_taxable: bool, 
    pub is_tax_inclusive: bool,
    pub tourism_cst_option: TourismCSTOption,
    // pub remarks: String,
    pub created_at: NaiveDateTime,    // pub created_at: DateTime<Utc>,
    pub updated_at: NaiveDateTime,    // pub updated_at: DateTime<Utc>,
    pub deleted_at: Option<NaiveDateTime>,    // pub deleted_at: DateTime<Utc>,
        // isTaxable, Discount
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
pub enum ItemCategory {
    RegularVAT,
    Rent,
    Exempt,
    NonVAT
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
pub enum TourismCSTOption {
    None,
    Tourism,
    CST
}

impl std::fmt::Display for ItemCategory {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            ItemCategory::RegularVAT => write!(f, "Regular VAT"),
            ItemCategory::Rent => write!(f, "Rent"),
            ItemCategory::Exempt => write!(f, "Exempt"),
            ItemCategory::NonVAT => write!(f, "Non VAT"),
        }
    }
}
