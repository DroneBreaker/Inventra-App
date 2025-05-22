use actix_web::web;

use crate::handlers::item_handler;

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::resource("/items")
            .route(web::get().to(item_handler::get_items))
            .route(web::post().to(item_handler::create_items))
    );
}