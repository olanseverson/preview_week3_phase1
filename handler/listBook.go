package handler

import (
	"fmt"
	"pagi/config"
)

func ListBook() {
	db, err := config.Connect()
	if err != nil {
		fmt.Println("Error when connecting to db")
		return
	}
	defer db.Close()

	query := `
	SELECT b.title, b.book_type, b.price, a.name as "author name"
	from books as b
	join authors as a
	on b.authorID = a.authorID
	WHERE a.name= ?	
	`

	author := "J.K. Rowling"

	rows, err := db.Query(query, author)
	if err != nil {
		fmt.Println("Error when query")
		return
	}

	defer rows.Close()

	fmt.Println("List of books by ", author)
	for rows.Next() {
		var title, book_type, name string
		var price float64

		if err := rows.Scan(&title, &book_type, &price, &name); err != nil {
			fmt.Println("error while reading rows")
			return
		}
		fmt.Printf("Author: %s, Book title: %s, Book type: %s, Price: %.2f\n", name, title, book_type, price)
	}

}
