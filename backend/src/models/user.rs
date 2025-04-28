#[derive(Debug, Serialize, Deserialize, Queryable, Insertable)]
#[table_name = "users"]
pub struct User {
    pub id: String,                           // UUID or string ID
    pub company_id: String,                   // Foreign key to companies.id
    pub name: String,
    pub email: String,
    pub password_hash: String,
    pub role: String,                         // e.g., "admin", "employee"
    pub created_at: chrono::NaiveDateTime,
    pub updated_at: chrono::NaiveDateTime,
}
