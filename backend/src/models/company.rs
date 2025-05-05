use serde::{Serialize, Deserialize};
use chrono::{DateTime, Utc };

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Company {
    pub id: String,                           // UUID or string ID
    pub company_name: String,
    pub tin: String,                          // Tax Identification Number
    pub address: Option<String>,
    pub phone: String,                        // Phone numbers better as String
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: DateTime<Utc>
}
