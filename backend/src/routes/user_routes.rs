use actix_web::{get, web, HttpResponse, Responder};

use crate::handlers::user_handler;

#[get("/health")]
pub async fn health_check() -> impl Responder {
    HttpResponse::Ok().json("INVENTA API is running")
}

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::scope("/users")
        .route("/", web::get().to(user_handler::get_users))
        .route("/", web::post().to(user_handler::create_user))
    );
}