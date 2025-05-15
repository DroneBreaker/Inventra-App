// use actix_web::web;

// pub fn init(cfg: web::ServiceConfig) {
//     cfg.service(
//         web::scope("https://vsdcstaging.vat-gh.com/vsdc/api/v1/taxpayer/CXX000000YY-001")
//             .service(
//                 web::resource("/invoice")
//                     // .route(web::get().to(handler))
//                     .route(web::post().to(invoice_handler::create_invoice))
//             )
//     )
// }