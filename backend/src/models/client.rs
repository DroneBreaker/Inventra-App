use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};


#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Client {
    id: String,
    client_name: String,
    client_email: String,
    client_tin: String,
    client_phone: String,
    company_tin: String,
    client_type: ClientType, // customer, supllier, export
    created_at: DateTime<Utc>,
    updated_at: DateTime<Utc>,
    deleted_at: DateTime<Utc>
}

#[derive(Debug, Serialize, Deserialize)]
pub enum ClientType {
    Customer,
    Supplier,
    Export
}