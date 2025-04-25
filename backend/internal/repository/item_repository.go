package repository

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"gorm.io/gorm"
)

type ItemRepository interface {
	GetAll(companyID string) ([]models.Item, error)
	Create(item *models.Item, companyID string) error
	GetByID(companyID string) (*models.Item, error)
	GetByItemName(itemName string, companyID string) (*models.Item, error)
	Update(item *models.Item, clientTIN string) error
	Delete(id int, companyID string) error
}

type itemRepo struct {
	db *gorm.DB
}

func NewItemRepository(db *gorm.DB) ItemRepository {
	return &itemRepo{db: db}
}

func (r *itemRepo) GetAll(companyID string) ([]models.Item, error) {
	items := []models.Item{}

	result := r.db.Select("id", "itemCode", "itemName", "price", "isTaxInclusive", "itemDescription", "isTaxable",
		"tourismCSTOption", "itemCategory", "isDiscountable", "companyID").Find(&items)
	return items, result.Error
}

func (r *itemRepo) Create(item *models.Item, companyID string) error {
	result := r.db.Create(item)
	return result.Error
}

func (r *itemRepo) GetByID(companyID string) (*models.Item, error) {
	var item models.Item
	result := r.db.Select("id", "itemCode", "itemName", "price", "isTaxInclusive", "itemDescription", "isTaxable",
		"tourismCSTOption", "itemCategory", "isDiscountable", "companyID", "createdAt").
		First(&item, companyID)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &item, result.Error

}

func (r *itemRepo) GetByItemName(itemName string, companyID string) (*models.Item, error) {
	var item models.Item
	result := r.db.Select("id", "itemCode", "itemName", "price", "isTaxInclusive", "itemDescription", "isTaxable",
		"tourismCSTOption", "itemCategory", "isDiscountable", "companyID", "createdAt").
		First(&item, itemName, companyID)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &item, result.Error
}

// func (r *itemRepo) GetByBusinessPartnerTIN(businessPartnerTIN string) ([]models.Item, error) {
// 	query := `SELECT id, itemCode, itemName, price, isTaxInclusive, itemDescription, isTaxable,
// 		tourismCSTOption, itemCategory, isDiscountable, businessTIN, createdAt FROM items WHERE and businessPartnerTIN = ?`
// 	rows, err := r.db.Query(query, businessPartnerTIN)
// 	if err != nil {
// 		return nil, err
// 	}
// 	defer rows.Close()

// 	for rows.Next() {
// 		var item models.Item
// 		if err := rows.Scan(&item.ID, &item.ItemCode, &item.ItemName, &item.Price, &item.IsTaxInclusive,
// 			&item.ItemDescription, &item.IsTaxable, &item.TourismCstOption, &item.ItemCategory,
// 			&item.IsDiscountable, &item.CreatedAt); err != nil {
// 			return nil, err
// 		}
// 		items = append(items, item)
// 	}
// 	return items, nil
// }

// func (r *itemRepo) Update(item *models.Item, businessPartnerTIN string) error {
// 	query := `UPDATE items SET itemCode = ?, itemName = ? price = ?, itemCategory = ? WHERE id = ? and businessPartnerTIN = ?`
// 	_, err := r.db.Exec(query, &item.ItemCode, &item.ItemName, &item.Price, &item.ItemCategory, &item.ID)
// 	return err
// }

func (r *itemRepo) Update(item *models.Item, companyID string) error {
	result := r.db.Model(item).Updates(models.Item{
		ItemCode:         item.ItemCode,
		ItemName:         item.ItemName,
		UnitPrice:        item.UnitPrice,
		IsTaxInclusive:   item.IsTaxInclusive,
		ItemDescription:  item.ItemDescription,
		IsTaxable:        item.IsTaxable,
		TourismCstOption: item.TourismCstOption,
		ItemCategory:     item.ItemCategory,
		IsDiscountable:   item.IsDiscountable,
		// CompanyID:        item.CompanyID,
		CreatedAt: item.CreatedAt,
		UpdatedAt: item.UpdatedAt,
	})
	return result.Error
}

func (r *itemRepo) Delete(id int, businessTIN string) error {
	result := r.db.Delete(&models.User{}, id)
	return result.Error
}
