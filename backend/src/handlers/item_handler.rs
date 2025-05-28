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
    pub id: Option<String>,
    pub item_code: String,
    pub item_name: String,
    pub item_description: Option<String>,
    pub price: f64,
    pub item_category: ItemCategory, // Regular, Rent, Exempt
    pub is_taxable: bool, 
    pub is_tax_inclusive: bool,
    pub tourism_cst_option: TourismCSTOption,
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
}


pub async fn get_items(db: web::Data<MySqlPool>, credentials: BearerAuth) -> impl Responder {
    // Validate JWT
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => {
            eprintln!("JWT validation failed: {:?}", e);
            return HttpResponse::Unauthorized().json(json!({
                "error": "Invalid token",
                "details": e.to_string()
            }));
        }
    };

    // Debug print the company_tin
    println!("Fetching items for company_tin: {}", claims.tin);

    match sqlx::query_as::<_, Item>(
        r#"
        SELECT 
            id, item_code, item_name, item_description, price, is_taxable, is_tax_inclusive, item_category, created_at, 
            updated_at, company_tin, tourism_cst_option, created_at, updated_at, deleted_at
        FROM items 
        WHERE company_tin = ? AND deleted_at IS NULL
        "#,
    )
    .bind(&claims.tin)
    .fetch_all(db.get_ref())
    .await
    {
        Ok(items) => {
            println!("Successfully fetched {} items", items.len());
            HttpResponse::Ok().json(items)
        },
        Err(err) => {
            eprintln!("Database error: {:?}\nQuery: {}", err, 
                r#"SELECT id, item_code... [your full query]"#);
            
            HttpResponse::InternalServerError().json(json!({
                "error": "Failed to fetch items",
                "details": err.to_string(),
                "suggestion": "Verify the database connection and table structure"
            }))
        }
    }
} 


pub async fn create_items(db: web::Data<MySqlPool>, req: web::Json<CreateItemRequest>, credentials: BearerAuth) -> impl Responder {
    // Validate JWT
    let claims = match validate_jwt(credentials.token()) {
        Ok(claims) => claims,
        Err(e) => return HttpResponse::Unauthorized().json(json!({"error": "Invalid token"})),
    };

    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    // Insert the item
    match sqlx::query!(
        r#"INSERT INTO items 
            (id, item_code, item_name, item_description, price, is_taxable, 
             is_tax_inclusive, tourism_cst_option, company_tin, created_at, updated_at)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"#,
        id,
        req.item_code,
        req.item_name,
        req.item_description,
        req.price,
        req.is_taxable,
        req.is_tax_inclusive,
        req.tourism_cst_option,
        claims.tin,
        now,
        now
    )
    .execute(db.get_ref())
    .await
    {
        Ok(result) if result.rows_affected() == 1 => {
            // Fetch the created item using query_as (more flexible than query_as!)
            match sqlx::query_as::<_, Item>(
                r#"
                SELECT 
                    id, item_code, item_name, item_description, price, company_tin, item_category, is_taxable,
                    is_tax_inclusive, tourism_cst_option, created_at, updated_at, deleted_at
                FROM items WHERE id = ? AND company_tin = ?
                "#,
            )
            .bind(&id)
            .bind(&claims.tin)
            .fetch_one(db.get_ref())
            .await
            {
                Ok(item) => HttpResponse::Created().json(json!({
                    "item": item,
                    "message": "Item created successfully"
                })),
                Err(e) => HttpResponse::InternalServerError().json(json!({
                    "error": "Failed to fetch created item",
                    "details": e.to_string()
                })),
            }
        },
        Ok(_) => HttpResponse::InternalServerError().json(json!({
            "error": "No rows affected"
        })),
        Err(e) => {
            // log::error!("Database insert error: {}", e);
            // log::error!("Failed query data - id: {}, item_code: {}, item_name: {}, company_tin: {}", 
            //            id, req.item_code, req.item_name, claims.tin);
            println!("Database insert error: {}", e);
            println!("Failed query data - id: {}, item_code: {}, item_name: {}, company_tin: {}", 
                       id, req.item_code, req.item_name, claims.tin);
            
            // Check for specific error types
            let error_message = if e.to_string().contains("Duplicate entry") {
                "Item with this code already exists"
            } else if e.to_string().contains("cannot be null") {
                "Required field is missing or null"
            } else if e.to_string().contains("foreign key constraint") {
                "Invalid reference to related data"
            } else {
                "Database error occurred"
            };

            HttpResponse::InternalServerError().json(json!({
                "error": error_message,
                "details": e.to_string(),
                "debug_info": {
                    "item_id": id,
                    "item_code": req.item_code,
                    "item_name": req.item_name,
                    "company_tin": claims.tin,
                    "timestamp": now
                }
            }))
        },
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
