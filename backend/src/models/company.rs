#[derive(Debug, Serialize, Deserialize, Queryable, Insertable)]
#[table_name = "companies"]
pub struct Company {
    pub id: String,                           // UUID or string ID
    pub company_name: String,
    pub tin: String,                          // Tax Identification Number
    pub email: String,
    pub address: Option<String>,
    pub phone: String,                        // Phone numbers better as String
    pub created_at: chrono::NaiveDateTime,
    pub updated_at: chrono::NaiveDateTime,
}
