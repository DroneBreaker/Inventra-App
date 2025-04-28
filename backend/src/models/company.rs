#[derive(Debug, Serialize, Deserialize, Queryable, Insertable)]
#[table_name = "companies"]
pub struct Company {
    pub id: String,
	pub company_name: String,
    pub tin: String,
    pub email: String,
    pub address: Option<String>,
	pub phone: String,
	pub created_at: chrono::NativeDateTime,
	pub updated_at: chrono::NativeDateTime
}