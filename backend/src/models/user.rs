// src/models/user.rs
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Queryable, Insertable)]
#[table_name = "users"]
pub struct User {
    pub id: i32,
    pub company_id: i32, // Foreign key
    pub email: String,
    pub password_hash: String,
    pub role: String, // e.g., admin, employee
    pub created_at: chrono::NaiveDateTime,
}
