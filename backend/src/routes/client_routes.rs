use actix_web::web;

use crate::handlers::client_handler;

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::resource("/clients")
            .route(web::get().to(client_handler::get_clients))
            .route(web::post().to(client_handler::create_clients))
            .route(web::post().to(client_handler::get_client_by_name))
    );
}