use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};


#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Client {
    id: String,
    client_name: String,
    client_tin: String,
    company_tin: String,
    client_type: String, // customer, supllier, export
    created_at: DateTime<Utc>,
    updated_at: DateTime<Utc>,
    deleted_at: DateTime<Utc>
}