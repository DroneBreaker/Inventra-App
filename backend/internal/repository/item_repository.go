package repository

import (
	"database/sql"

	"github.com/DroneBreaker/Inventra-App/internal/models"
)

type ItemRepository interface {
	GetAll(businessTIN string) ([]models.Item, error)
	Create(item *models.Item, businessTIN string) error
	GetByID(id int, businessTIN string) (*models.Item, error)
	GetByItemName(itemName string, businessTIN string) (*models.Item, error)
	Update(item *models.Item, businessTIN string) error
	Delete(id int, businessTIN string) error
}

type itemRepo struct {
	db *sql.DB
}

func NewItemRepository(db *sql.DB) ItemRepository {
	return &itemRepo{db: db}
}

func (r *itemRepo) GetAll(businessTIN string) ([]models.Item, error) {
	items := []models.Item{}
	query := `SELECT id, itemCode, itemName, price, isTaxInclusive, itemDescription, isTaxable, 
		tourismCSTOption, itemCategory, isDiscountable, createdAt FROM items`
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var item models.Item
		if err := rows.Scan(&item.ID, &item.ItemCode, &item.ItemName, &item.Price, &item.IsTaxInclusive,
			&item.ItemDescription, &item.IsTaxable, &item.TourismCstOption, &item.ItemCategory,
			&item.IsDiscountable, &item.CreatedAt); err != nil {
			return nil, err
		}
		items = append(items, item)
	}
	return items, nil
}

func (r *itemRepo) Create(item *models.Item, businessTIN string) error {
	query := `INSERT INTO items (itemCode, itemName, price, isTaxInclusive, itemDescription, 
		isTaxable, tourismCSTOption) VALUES (?,?,?,?,?,?,?)`
	result, err := r.db.Exec(query, item.ItemCode, item.ItemName, item.Price, item.IsTaxInclusive,
		item.ItemDescription, item.IsTaxable, item.TourismCstOption,
	)

	if err != nil {
		return err
	}

	// Retrieve the last inserted ID
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	item.ID = int(id) // Set the ID in the item object
	item.BusinessTIN = businessTIN
	return nil
}

func (r *itemRepo) GetByID(id int, businessTIN string) (*models.Item, error) {
	item := &models.Item{}
	query := `SELECT id, itemCode, itemName, price, isTaxInclusive, itemDescription, isTaxable, 
		tourismCSTOption, itemCategory, isDiscountable, businessTIN, createdAt FROM items WHERE 
		id = ? and businessTIN = ?`
	err := r.db.QueryRow(query, id).Scan(&item.ID, &item.ItemCode, &item.ItemName, &item.Price,
		&item.IsTaxInclusive, &item.ItemDescription, &item.IsTaxable, &item.TourismCstOption,
		&item.ItemCategory, &item.IsDiscountable, &item.BusinessTIN, &item.CreatedAt)
	return item, err
}

func (r *itemRepo) GetByItemName(itemName string, businessTIN string) (*models.Item, error) {
	item := &models.Item{}
	query := `SELECT id, itemCode, itemName, price, isTaxInclusive, itemDescription, isTaxable, 
		tourismCSTOption, itemCategory, isDiscountable, businessTIN, createdAt FROM items WHERE 
		id = ? and businessTIN = ?`
	err := r.db.QueryRow(query, itemName).Scan(&item.ID, &item.ItemCode, &item.ItemName, &item.Price,
		&item.IsTaxInclusive, &item.ItemDescription, &item.IsTaxable, &item.TourismCstOption,
		&item.ItemCategory, &item.IsDiscountable, &item.BusinessTIN, &item.CreatedAt)
	return item, err
}

func (r *itemRepo) Update(item *models.Item, businessTIN string) error {
	query := `UPDATE items SET itemCode = ?, itemName = ? price = ?, itemCategory = ? WHERE id = ?`
	_, err := r.db.Exec(query, &item.ItemCode, &item.ItemName, &item.Price, &item.ItemCategory, &item.ID)
	return err
}

func (r *itemRepo) Delete(id int, businessTIN string) error {
	query := `DELETE FROM items WHERE id = ? and businessTIN = ?`
	_, err := r.db.Exec(query, id, businessTIN)
	return err
}
