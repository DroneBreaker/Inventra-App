#[allow(dead_code)]
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};

#[derive(Debug, serde::Serialize, Deserialize, sqlx::FromRow)]
pub struct User {
    pub id: String,
    pub first_name: String,
    pub last_name: String,
    pub email: String,
    pub username: String,
    pub company_name: String,
    pub company_id: String,
    pub company_tin: String,
    // pub role: String,  //user, admin
    pub password: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: DateTime<Utc>,
}

#[derive(Deserialize, Serialize, sqlx::FromRow)]
pub struct CreateUser {
    pub first_name: String,
    pub last_name: String,
    pub email: String,
    pub username: String,
    pub company_name: String,
    pub company_id: String,
    pub company_tin: String,
    // pub role: String,  //user, admin
    pub password: String,
}

#[derive(Serialize, Deserialize)]
pub struct LoginRequest {
    pub username: String,
    pub company_tin: String,
    pub password: String,
}
