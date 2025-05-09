use actix_web::{get, web, App, HttpServer, Responder};
use backend::routes::{self};
use dotenvy::dotenv;
mod db;

#[get("")]
async fn hello() -> impl Responder {
    "Hello world!"
}


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::init();

    let pool = db::init_db_pool().await;

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .service(hello)
            .configure(routes::user_routes::init)
            .configure(routes::item_routes::init) 
    }) 
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
