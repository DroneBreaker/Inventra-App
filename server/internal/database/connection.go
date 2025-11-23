package database

import (
	"log"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func Connect() {
	// user := os.Getenv("DB_USER")
	// password := os.Getenv("DB_PASS")
	// host := os.Getenv("DB_HOST")
	// port := os.Getenv("DB_PORT")
	// name := os.Getenv("DB_NAME")

	// dsn := fmt.Sprintf(
	// 	"%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
	// 	user, password, host, port, name,
	// )
	dsn := "root:DroneBreaker55@tcp(127.0.0.1:3306)/inventra?charset=utf8mb4&parseTime=True&loc=Local"

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to MySQL: ", err)
	}

	DB = db
	log.Println("Connected to MySQL successfully")
}

func GetDB() *gorm.DB {
	return DB
}
