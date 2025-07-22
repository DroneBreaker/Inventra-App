use sqlx::mysql::MySqlPoolOptions;
use sqlx::MySqlPool;
use std::env;

pub async fn init_db_pool() -> MySqlPool {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    MySqlPoolOptions::new()
        .max_connections(10)
        .min_connections(1)
        .acquire_timeout(std::time::Duration::from_secs(30))  // Increase timeout
        .idle_timeout(std::time::Duration::from_secs(3600)) 
        .test_before_acquire(true) // Test connections before use
        .connect(&database_url)
        .await
        .expect("Failed to create pool")
}
