package repository

import (
	"database/sql"

	"github.com/DroneBreaker/Inventra-App/internal/models"
)

type ItemRepository interface {
	// GetAll() ([]models.Item, error)
	GetByID(id int) (*models.Item, error)
	// GetByItemName(itemName string) (*models.Item, error)
	// Update(item *models.Item) error
	// Delete(id int) error
}

type itemRepo struct {
	db *sql.DB
}

func NewItemRepository(db *sql.DB) ItemRepository {
	return &itemRepo{db: db}
}

func (r *itemRepo) GetByID(id int) (*models.Item, error) {
	item := &models.Item{}
	query := `SELECT id, itemCode, itemName, price, isTaxInclusive, itemDescription, isTaxable, 
		tourismCSTOption, itemCategory, isDiscountable, businessTIN, createdAt FROM items WHERE id = ?`
	err := r.db.QueryRow(query, id).Scan(&item.ID, &item.ItemCode, &item.ItemName, &item.Price,
		&item.IsTaxInclusive, &item.ItemDescription, &item.IsTaxable, &item.TourismCstOption,
		&item.ItemCategory, &item.IsDiscountable, &item.BusinessTIN, &item.CreatedAt)
	return item, err
}

func (r *itemRepo) GetByItemName(itemName string) (*models.Item, error) {
	item := &models.Item{}
	query := `SELECT id, itemCode, itemName, price, isTaxInclusive, itemDescription, isTaxable, 
		tourismCSTOption, itemCategory, isDiscountable, businessTIN, createdAt FROM items WHERE id = ?`
	err := r.db.QueryRow(query, itemName).Scan(&item.ID, &item.ItemCode, &item.ItemName, &item.Price,
		&item.IsTaxInclusive, &item.ItemDescription, &item.IsTaxable, &item.TourismCstOption,
		&item.ItemCategory, &item.IsDiscountable, &item.BusinessTIN, &item.CreatedAt)
	return item, err
}
