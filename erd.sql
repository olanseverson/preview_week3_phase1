CREATE DATABASE library;


CREATE TABLE IF NOT EXISTS customers (
    customerID INT AUTO_INCREMENT PRIMARY KEY,
    name varchar(255),
    email varchar(255) UNIQUE
);


CREATE TABLE IF NOT EXISTS authors (
    authorID int AUTO_INCREMENT PRIMARY KEY,
    name varchar(255),
    email varchar(255)
);


CREATE TABLE IF NOT EXISTS books (
    bookID int AUTO_INCREMENT PRIMARY KEY,
    title varchar(255),
    book_type varchar(255),
    authorID int,
    price decimal(10, 2),
    CONSTRAINT fk_author_id FOREIGN KEY (authorID) REFERENCES authors(authorID)
);


CREATE TABLE IF NOT EXISTS orders (
    orderID int AUTO_INCREMENT PRIMARY KEY,
    customerID int,
    bookID int,
    order_date date,
    CONSTRAINT fk_customer_id FOREIGN KEY (customerID) REFERENCES customers(customerID),
    CONSTRAINT fk_book_id FOREIGN KEY (bookID) REFERENCES books(bookID)
);


-- dml
-- Inserting data into customers table 
INSERT INTO customers (name, email) VALUES
('John', 'john@example.com'),
('Jane', 'jane@example.com'),
('Michael', 'michael@example.com'),
('Emily', 'emily@example.com'),
('David', 'david@example.com');

-- Inserting data into authors table
INSERT INTO authors (name, email) VALUES
('Stephen King', 'stephen@example.com'),
('J.K. Rowling', 'jk@example.com'),
('George Orwell', 'george@example.com'),
('Agatha Christie', 'agatha@example.com'),
('Harper Lee', 'harper@example.com');

-- Inserting data into books table
INSERT INTO books (title, book_type, authorID, price) VALUES
('The Shining', 'physical book', 1, 12.99),
('Harry Potter and the Philosopher''s Stone', 'e-book', 2, 15.99),
('1984', 'physical book', 3, 9.99),
('Murder on the Orient Express', 'physical book', 4, 11.99),
('To Kill a Mockingbird', 'e-book', 5, 10.99),
('The Hobbit', 'physical book', 2, 14.99),
('The Da Vinci Code', 'e-book', 4, 13.99),
('The Catcher in the Rye', 'physical book', 5, 10.49),
('Pride and Prejudice', 'e-book', 3, 12.49),
('The Great Gatsby', 'physical book', 1, 11.49);

-- Inserting data into orders table
INSERT INTO orders (customerID, bookID, order_date) VALUES
(1, 1, '2024-05-13'),
(2, 2, '2024-05-14'),
(3, 3, '2024-05-15'),
(4, 4, '2024-05-16'),
(5, 5, '2024-05-17'),
(1, 6, '2024-05-18'),
(2, 7, '2024-05-19'),
(3, 8, '2024-05-20'),
(4, 9, '2024-05-21'),
(5, 10, '2024-05-22');


-- query

WITH jt1 as (
	SELECT c.name, c.email, b.bookID, b.title, b.book_type, a.name as authorName, b.price, o.orderID, o.order_date from 
    customers as c 
    join orders as o
    on c.customerID = o.customerID
    join books as b
    on b.bookID = o.bookID
    join authors as a
    on a.authorID = b.authorID
)
SELECT *
from jt1
where jt1.bookID> 5;

-- query 1
SELECT b.title, b.book_type, b.price, a.name as "author name"
from books as b
join authors as a
on b.authorID = a.authorID
WHERE a.name= 'J.K. Rowling'

-- query2
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
SELECT jt.book_type, sum(jt.price) as "total price"
from jt
GROUP BY jt.book_type;

-- query 3
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

--query 4
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