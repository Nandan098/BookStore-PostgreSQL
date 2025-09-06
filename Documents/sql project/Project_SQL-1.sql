drop table if exists books;
create table books(
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

drop table if exists customers; 

create table customers(
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

drop table if exists orders;

create table orders(
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

copy books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'F:\Books.csv'
CSV header;

copy customers(Customer_ID,Name,Email,Phone,City,Country)
from 'F:\Customers.csv'
CSV header;

copy orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'F:\Orders.csv'
CSV header;

select * from books;
select * from customers;
select * from orders;


-- 1) Retrieve all books in the "Fiction" genre:
   select * from books
   where Genre='Fiction';

   
-- 2) Find books published after the year 1950:
   select * from books
   where Published_Year>1950;

-- 3) List all customers from the Canada:
    select * from customers
	where Country='Canada';


-- 4) Show orders placed in November 2023:
    select * from orders
	where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
    select sum(Stock) as total_stock from books; 


-- 6) Find the details of the most expensive book:
    select 	* from books
	order by Price DESC
	limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
    select * from orders
	where Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
    select * from orders
	where Total_Amount>20;


-- 9) List all genres available in the Books table:
    select distinct Genre from books;


-- 10) Find the book with the lowest stock:
    select * from books 
	order by Stock asc
	limit 1;


-- 11) Calculate the total revenue generated from all orders:
    select sum(Total_Amount) as total_revenue from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
    select b.Genre,sum(o.Quantity) as total_books_sold
	from books b
	join orders o on b.Book_ID=o.Book_ID
	group by Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
    select avg(Price) as average_price from books
	where Genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
    select * from orders;
	select * from customers;

	select c.Name,o.Quantity
	from customers c
	join orders o on c.Customer_ID=o.Customer_ID
	where Quantity=2;

-- 4) Find the most frequently ordered book:
    select o.Quantity,b.Title
	from orders o
	join books b on b.Book_ID=o.Book_ID
	order by o.Quantity DESC;

	select Book_ID,count(Order_ID) as order_count
	from orders
	group by Book_ID
	order by order_count DESC limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
    select * from books
	where Genre='Fantasy'
	order by Price DESC
	limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
    select b.Author,sum(o.Quantity) as total_sold
	from books b
	join orders o on b.Book_ID=o.Book_ID
	group by b.Author;


-- 7) List the cities where customers who spent over $30 are located:
    select distinct c.City,o.Total_Amount
	from customers c
	join orders o on c.Customer_ID=o.Customer_ID
	where o.Total_Amount>30;


-- 8) Find the customer who spent the most on orders:
     select c.Name,c.Customer_ID,sum(o.Total_Amount) as total_cost
	 from customers c
	 join orders o on c.Customer_ID=o.Customer_ID
	 group by c.Customer_ID
	 order by Total_cost DESC;

--9) Calculate the stock remaining after fulfilling all orders:
    select b.Book_ID,(sum(b.Stock)-sum(o.Quantity)) as total_stock 
	from books b
	join orders o on b.Book_ID=o.Book_id
	
    group by b.Book_ID
	order by b.	Book_ID ASC;
    