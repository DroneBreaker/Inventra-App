// use actix_web::{dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform}, Error, HttpMessage, HttpResponse};
// use futures_util::future::{ok, LocalBoxFuture, Ready};
// use crate::utils::jwt::validate_jwt;

// #[derive(Clone, Default)]
// pub struct AuthMiddleware;

// impl<S, B> Transform<S, ServiceRequest> for AuthMiddleware
// where
//     S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error> + 'static,
//     B: 'static,
// {
//     type Response = ServiceResponse<B>;
//     type Error = Error;
//     type InitError = ();
//     type Transform = AuthMiddlewareMiddleware<S>;
//     type Future = Ready<Result<Self::Transform, Self::InitError>>;

//     fn new_transform(&self, service: S) -> Self::Future {
//         ok(AuthMiddlewareMiddleware { service })
//     }
// }

// pub struct AuthMiddlewareMiddleware<S> {
//     service: S,
// }

// impl<S, B> Service<ServiceRequest> for AuthMiddlewareMiddleware<S>
// where
//     S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error> + 'static,
//     B: 'static,
// {
//     type Response = ServiceResponse<B>;
//     type Error = Error;
//     type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

//     forward_ready!(service);

//     fn call(&self, req: ServiceRequest) -> Self::Future {
//         let token_opt = req
//             .headers()
//             .get("Authorization")
//             .and_then(|h| h.to_str().ok())
//             .and_then(|auth| auth.strip_prefix("Bearer "));

//         if let Some(token) = token_opt {
//             if validate_jwt(token).is_ok() {
//                 let fut = self.service.call(req);
//                 return Box::pin(async move { fut.await });
//             }
//         }

//         Box::pin(async {
//             Ok(req.into_response(
//                 HttpResponse::Unauthorized().finish().into_body()
//             ))
//         })
//     }
// }
