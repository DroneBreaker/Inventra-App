use serde::{Deserialize, Serialize};


#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Client {
    id: String,
    client_name: String,
    client_tin: String,
    company_tin: String,
    client_type: String // customer, supllier, export
}