package main

import (
	"fmt"
	"log"
	"os"
	"pagi/handler"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("please input command!!!")
	}
	fmt.Println("Selamat datang di library")
	fmt.Println()

	cmd := os.Args[1]
	switch cmd {
	case "books":
		handler.ListBook()
	case "sales":
		handler.TotalSales()
	case "customers":
		handler.ListCustomers()
	case "topauthor":
		handler.TopAuthor()
	default:
		fmt.Println("command unrecognized!")
	}

}
