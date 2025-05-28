use actix_web::{ web, HttpResponse, Responder};

use crate::handlers::user_handler;

pub async fn health_check() -> impl Responder {
    HttpResponse::Ok().json("INVENTRA API is running")
}

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::scope("/user_account")
            .route("/health", web::get().to(health_check))
            //    web::scope("/users") 
            .route("/users", web::get().to(user_handler::get_users))
            .route("/users", web::post().to(user_handler::create_user))
            .route("/users/id/{id}", web::get().to(user_handler::get_user_by_id))
            .route("/users/username/{username}", web::get().to(user_handler::get_user_by_username))
            .route("/users/company/{tin}", web::get().to(user_handler::get_users_by_company_tin))
            .route("/users/update/{tin}", web::put().to(user_handler::update_user))
            .route("/users/{id}", web::delete().to(user_handler::delete_user))
            .route("/register", web::post().to(user_handler::register_user))
            .route("/login", web::post().to(user_handler::login_user))
    );
}
