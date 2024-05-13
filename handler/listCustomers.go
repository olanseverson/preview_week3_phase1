package handler

import (
	"fmt"
	"pagi/config"
)

func ListCustomers() {
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
	SELECT jt.name, count(jt.name) as "order count" 
	from jt
	GROUP BY jt.name
	having count(jt.name) > 1;
	`
	rows, err := db.Query(query)
	if err != nil {
		fmt.Println(err)
		return
	}

	defer rows.Close()

	for rows.Next() {
		var customername string
		var count int
		if err := rows.Scan(&customername, &count); err != nil {
			fmt.Println(err.Error())
			return
		}
		fmt.Printf("Customer Name:  %s, Order Count: %v\n", customername, count)
	}
}
