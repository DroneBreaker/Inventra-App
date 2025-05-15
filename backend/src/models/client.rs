use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};


#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Client {
    pub id: String,
    pub client_name: String,
    pub client_email: String,
    pub client_tin: String,
    pub client_phone: String,
    pub company_tin: String,
    pub client_type: ClientType, // customer, supllier, export
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: DateTime<Utc>
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
pub enum ClientType {
    Customer,
    Supplier,
    Export
}