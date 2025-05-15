use actix_web::{web, HttpResponse, Responder};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use chrono::Utc;
use serde::Deserialize;
use sqlx::MySqlPool;
use uuid::Uuid;
use serde_json::json;


use crate::{models::item::{Item, ItemCategory, TourismCSTOption}, utils::jwt::validate_jwt};

#[derive(Debug, Deserialize)]
pub struct CreateItemRequest {
    pub id: i64,
    pub item_code: i64,
    pub item_name: String,
    pub item_description: String,
    pub price: f64,
    pub company_tin: String,
    pub item_category: ItemCategory, // Regular, Rent, Exempt
    pub is_taxable: bool, 
    pub is_tax_inclusive: bool,
    pub tourism_cst_option: TourismCSTOption,
    pub remarks: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateItemRequest {
    pub item_name: Option<String>,
    pub item_description: Option<String>,
    pub price: Option<f64>,
    pub item_category: Option<ItemCategory>,
    pub is_taxable: Option<bool>,
    pub is_tax_inclusive: Option<bool>,
    pub tourism_cst_option: Option<TourismCSTOption>,
    pub remarks: Option<String>,
}


pub async fn get_items(db: web::Data<MySqlPool>, credentials: BearerAuth) -> impl Responder {
    // Validate JWT using your existing utility
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => {
            eprintln!("JWT validation failed: {:?}", e);
            return HttpResponse::Unauthorized().json("Invalid token");
        }
    };

    // The company_tin is stored in claims.sub
    let company_tin = claims.sub;


    let query = r#"
        SELECT
            id, item_code, item_name, item_description, price, is_taxable, is_tax_inclusive, company_tin, item_category, is_taxable, 
            is_taxinclusive, remarks, created_at, updated_at
        FROM items
        WHERE company_tin = ?
    "#; 

    let result = sqlx::query_as::<_, Item>(query)
        .bind(company_tin)
        .fetch_all(db.get_ref())
        .await;

    match result {
        Ok(items) => HttpResponse::Ok().json(items),
        Err(err) => {
            eprintln!("DB error: {:?}", err);
            HttpResponse::InternalServerError().json(serde_json::json!({
                "error": "Failed to fetch items"
        }))
        }
    }
} 


pub async fn create_items(db: web::Data<MySqlPool>, req: web::Json<CreateItemRequest>, credentials: BearerAuth,) -> impl Responder {
    // Validate JWT first
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => {
            eprintln!("JWT validation failed: {:?}", e);
            return HttpResponse::Unauthorized().json(json!({
                "error": "Invalid token"
            }));
        }
    };

    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    match sqlx::query!(
        r#"
            INSERT INTO items 
                (id, item_code, item_name, item_description, price, is_taxable, is_tax_inclusive, 
                tourism_cst_option, remarks, company_tin, created_at, updated_at, deleted_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        "#,
        id,
        req.item_code,
        req.item_name,
        req.item_description,
        req.price,
        req.is_taxable,
        req.is_tax_inclusive,
        req.tourism_cst_option,
        req.remarks,
        claims.sub, // Use company_tin from JWT claims
        now,
        now,
        Option::<chrono::DateTime<Utc>>::None // Use NULL for deleted_at
    )
    .execute(db.get_ref())
    .await
    {
        Ok(result) => {
            if result.rows_affected() == 1 {
                HttpResponse::Created().json(json!({
                    "message": "Item created successfully",
                }))
            } else {
                HttpResponse::InternalServerError().json(json!({
                    "error": "Failed to create item"
                }))
            }
        },
        Err(err) => {
            eprintln!("Database error: {:?}", err);
            HttpResponse::InternalServerError().json(json!({
                "error": "Database operation failed",
                "details": err.to_string()
            }))
        }
    }
}

pub async fn get_item_by_id(db: web::Data<MySqlPool>, path: web::Path<(String, String)>) -> impl Responder {
    let (id, company_tin) = path.into_inner();

    let query = r#"
        SELECT * FROM items WHERE id = ? AND company_tin = ? AND deleted_at IS NULL
    "#;

    let item = sqlx::query_as::<_, Item>(query)
        .bind(id)
        .bind(company_tin)
        .fetch_optional(db.get_ref())
        .await;

    match item {
        Ok(Some(item)) => HttpResponse::Ok().json(item),
        Ok(None) => HttpResponse::NotFound().body("Item not found"),
        Err(_) => HttpResponse::InternalServerError().body("Failed to fetch item"),
    }
}

pub async fn get_clients_by_company_tin(db: web::Data<MySqlPool>, path: web::Path<String>,) -> impl Responder {
    let company_tin = path.into_inner();

    let query: &'static str = r#"
        SELECT * FROM items WHERE company_tin = ? AND deleted_at IS NULL
    "#;

    let items = sqlx::query_as::<_, Item>(query)
        .bind(company_tin)
        .fetch_all(db.get_ref())
        .await;

    match items {
        Ok(items) => HttpResponse::Ok().json(items),
        Err(_) => HttpResponse::InternalServerError().body("Failed to fetch items"),
    }
}

// pub async fn get_item_by_id(db: web::Data<MySqlPool>, path: web::Path<(String, String)>) -> impl Responder {
//     let (item_id, company_tin) = path.into_inner();
    
//     // Parse the item_id from string to i64
//     let item_id = match item_id.parse::<i64>() {
//         Ok(id) => id,
//         Err(_) => {
//             return HttpResponse::BadRequest().json(
//                 serde_json::json!({ "error": "Invalid item ID format" })
//             );
//         }
//     };

//     let result = sqlx::query_as!(
//         Item,
//         "SELECT * FROM items WHERE id = ? AND company_tin = ?",
//         item_id,
//         company_tin
//     )
//     .fetch_optional(db.get_ref())
//     .await;

//     match result {
//         Ok(Some(item)) => HttpResponse::Ok().json(item),
//         Ok(None) => HttpResponse::NotFound().json(serde_json::json!({ "error": "Item not found" })),
//         Err(e) => {
//             eprintln!("DB fetch error: {:?}", e);
//             HttpResponse::InternalServerError().json(serde_json::json!({ "error": "Failed to fetch item" }))
//         }
//     }
// }

// pub async fn get_items_by_company_tin( db: web::Data<MySqlPool>, path: web::Path<String>) -> impl Responder {
//     let company_tin = path.into_inner();

//     let result = sqlx::query_as!(
//         Item,
//         "SELECT * FROM items WHERE company_tin = ?",
//         company_tin
//     )
//     .fetch_all(db.get_ref())
//     .await;

//     match result {
//         Ok(items) => HttpResponse::Ok().json(items),
//         Err(e) => {
//             eprintln!("DB fetch error: {:?}", e);
//             HttpResponse::InternalServerError().json({ "error": "Failed to fetch items" })
//         }
//     }
// }

// pub async fn update_item(
//     pool: web::Data<MySqlPool>,
//     path: web::Path<(String, String)>, // (item_id, company_tin)
//     payload: web::Json<UpdateItemRequest>,
// ) -> impl Responder {
//     let (item_id, company_tin) = path.into_inner();
//     let now = Utc::now();

//     let result = sqlx::query!(
//         r#"UPDATE items SET
//             item_name = COALESCE(?, item_name),
//             item_description = COALESCE(?, item_description),
//             price = COALESCE(?, price),
//             item_category = COALESCE(?, item_category),
//             is_taxable = COALESCE(?, is_taxable),
//             is_tax_inclusive = COALESCE(?, is_tax_inclusive),
//             tourism_cst_option = COALESCE(?, tourism_cst_option),
//             remarks = COALESCE(?, remarks),
//             updated_at = ?
//         WHERE id = ? AND company_tin = ?"#,
//         payload.item_name.as_deref(),
//         payload.item_description.as_deref(),
//         payload.price,
//         payload.item_category.map(|c| c as ItemCategory),
//         payload.is_taxable,
//         payload.is_tax_inclusive,
//         payload.tourism_cst_option.map(|o| o as TourismCSTOption),
//         payload.remarks.as_deref(),
//         now,
//         item_id,
//         company_tin
//     )
//     .execute(pool.get_ref())
//     .await;

//     match result {
//         Ok(_) => HttpResponse::Ok().json({ "message": "Item updated" }),
//         Err(e) => {
//             eprintln!("DB update error: {:?}", e);
//             HttpResponse::InternalServerError().json({ "error": "Failed to update item" })
//         }
//     }
// }


// pub async fn delete_item(
//     pool: web::Data<MySqlPool>,
//     path: web::Path<(String, String)>, // (item_id, company_tin)
// ) -> impl Responder {
//     let (item_id, company_tin) = path.into_inner();
//     let now = Utc::now();

//     let result = sqlx::query!(
//         "UPDATE items SET deleted_at = ? WHERE id = ? AND company_tin = ?",
//         now,
//         item_id,
//         company_tin
//     )
//     .execute(pool.get_ref())
//     .await;

//     match result {
//         Ok(_) => HttpResponse::Ok().json({ "message": "Item deleted" }),
//         Err(e) => {
//             eprintln!("DB delete error: {:?}", e);
//             HttpResponse::InternalServerError().json({ "error": "Failed to delete item" })
//         }
//     }
// }
