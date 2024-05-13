package handler

import (
	"fmt"
	"pagi/config"
)

func TopAuthor() {
	db, err := config.Connect()
	if err != nil {
		fmt.Println("connect db: failed")
		return
	}
	defer db.Close()

	query := `
	WITH jt as (
		SELECT c.name, c.email, b.bookID, b.title, b.book_type, a.name as authorName, b.price, o.orderID, o.order_date from 
		customers as c 
		join orders as o
		on c.customerID = o.customerID
		join books as b
		on b.bookID = o.bookID
		join authors as a
		on a.authorID = b.authorID
	)
	SELECT jt.authorName, sum(jt.price) as earnings
	from jt
	GROUP BY jt.authorName
	ORDER BY earnings DESC
	limit 1;	
	`

	rows, err := db.Query(query)
	if err != nil {
		fmt.Println(err)
		return
	}

	defer rows.Close()

	for rows.Next() {
		var author string
		var sum float64
		if err := rows.Scan(&author, &sum); err != nil {
			fmt.Println(err.Error())
			return
		}
		fmt.Printf("Author:  %s, Total Revenue: $%2.f\n", author, sum)
	}
}
