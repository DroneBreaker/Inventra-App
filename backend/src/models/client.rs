use chrono::{DateTime, NaiveDateTime, Utc};
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
    pub created_at: NaiveDateTime,
    pub updated_at: NaiveDateTime,
    pub deleted_at: Option<NaiveDateTime>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type, Clone)]
pub enum ClientType {
    Customer,
    Supplier,
    Export
}