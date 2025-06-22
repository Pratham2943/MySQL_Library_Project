# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/Pratham2943/MySQL_Library_Project/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/Pratham2943/MySQL_Library_Project/blob/main/ERD.PNG)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.
```Sql
-- Library Management System 


-- Creating Branch Table
Create Table Branch 
	( branch_id Varchar(10) Primary Key,	 
    manager_id	Varchar(10),
    branch_address	Varchar(55),
    contact_no Varchar(12)
) ;
alter table branch modify column contact_no varchar(15);

-- Creating Employees Table
Create Table Employee
	( emp_id Varchar(5) Primary Key,
    emp_name Varchar(25),	
    designation Varchar(15),
    salary	int,
    branch_id Varchar(5)
	);
    
    -- Creating Books Table
Create Table Books
	( isbn varchar(20) Primary Key,
    book_title Varchar(75),
    category Varchar(25),
    rental_price float,
    status Varchar(15),
    author Varchar(35),
    publisher varchar(55)
    );
    
    
    -- Creating Members Table
Create Table Members 
	( member_id	Varchar(15) Primary Key,
    member_name	varchar(25),
    member_address varchar(75),	
    reg_date Date
    );
    
    
    -- Crerating Issued Status Table
    Create Table Issued_Status
		( issued_id	Varchar(10)Primary Key,
        issued_member_id Varchar(10),	
        issued_book_name Varchar(75),	
        issued_date	Date,
        issued_book_isbn Varchar(25),	
        issued_emp_id Varchar(10)
		);
        
        
-- Crerating Return Status Table
Create Table Return_Status 
	( return_id	Varchar(10) Primary Key,
    issued_id Varchar(10),
    return_book_name varchar(75),	
    return_date Date,
    return_book_isbn Varchar(25)
    );
    
    
    -- Foreign Key
Alter Table issued_status
add constraint Fk_members
foreign key (issued_member_id)
references members(member_id);


Alter Table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);


Alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employee(emp_id); 


Alter table employee
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);



Alter table return_status
add constraint fk_issued_status
foreign key (issued_id)
references issued_status(issued_id);

```
### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
Insert into books (isbn, book_title, category, rental_price, status, author, publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```
**Task 2: Update an Existing Member's Address**

```sql
update members
set member_address = '129 Oak st'
where member_id = 'C101';

Select * from members;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
delete  from issued_status
where issued_id = 'IS121';

select * from issued_status;
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
select * from issued_status
where issued_emp_id = 'E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
select e.emp_name, ist.issued_emp_id, count(ist.issued_emp_id)
from employee as e
JOIN issued_status as ist on e.emp_id = ist.issued_emp_id
group by e.emp_id, ist.issued_emp_id
having count(ist.issued_emp_id) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table Book_issued_count
as 
select b.isbn, b.book_title, count(ist.issued_id) as no_issued
from books as b
join issued_status as ist on b.isbn = ist.issued_book_isbn
group by b.isbn, b.book_title;

Select * from Book_issued_count;

```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
select * from books
where category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
select category, sum(b.rental_price), count(*)
from books as b
join
issued_status as ist on b.isbn = ist.issued_book_isbn
group by category;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'Karla', '145 Main St', '2025-04-01'),
('C121', 'Hardik', '133 Main St', '2025-05-03');


select * from members
where reg_date >= current_date() - interval 180 day;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
    e.emp_id AS employee_id,
    e.emp_name AS employee_name,
    e.designation,
    b.branch_id,
    b.branch_address,
    b.contact_no,
    m.emp_name AS manager_name
FROM employee e
JOIN branch b ON e.branch_id = b.branch_id
JOIN employee m ON b.manager_id = m.emp_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
create table Books_price_more_than_7USD
as
select * from books
where rental_price > 7;

select * from Books_price_more_than_7USD;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
select distinct issued_book_name
from issued_status as ist
left join return_status as rs on ist.issued_id = rs.issued_id
where rs.return_id is null;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
-- Approach
-- issue_date == member == books == return_status (return status will use left join because we want to see everything from the first 3 tables)
-- filter books which have not been returned
-- Overdue peroid is more than 30 days   

select ist.issued_member_id, mem.member_name, bk.book_title, ist.issued_date,rs.return_date, DATEDIFF(curdate() , ist.issued_date) AS days_since_issued
from issued_status as ist
join members as mem on ist.issued_member_id = mem.member_id
join books as bk on ist.issued_book_isbn = bk.isbn
left join return_status as rs on ist.issued_id = rs.issued_id
where rs.return_date is null and DATEDIFF(curdate() , ist.issued_date) > 30
order by ist.issued_member_id;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql
-- Creating store procedure
DELIMITER //
create procedure change_return_status(
IN p_return_id varchar(10), 
IN p_issued_id varchar(10), 
IN p_book_quality varchar(10))


Begin
-- Inserting data into return based on user input
declare v_isbn varchar(50);
declare v_book_name varchar (80);
	insert into return_status (return_id, issued_id, return_date, book_quality)
    values (p_return_id, p_issued_id, current_date(), p_book_quality);
    
    select issued_book_isbn, issued_book_name 
    into v_isbn, v_book_name
    from issued_status
    where issued_id = p_issued_id;
    
    update books
    set status = 'yes'
    where isbn = v_isbn;
    
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS Message;
    
end // 
DELIMITER ;

-- Calling Function and checking records

call change_return_status('RS138', 'IS135', 'good');
select * from books
where isbn = '978-0-307-58837-1';

call change_return_status('RS148', 'IS140', 'Good');
```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
Create Table Branch_report
as
select Br.branch_id,
br.manager_id, 
count(ist.issued_id) as number_Books_issued,
count(rs.return_id) as Number_books_returned,
sum(bk.rental_price) as total_revenue
from issued_status as ist
join employee as em on ist.issued_emp_id = em.emp_id
join branch as br on em.branch_id = br.branch_id
left join return_status as rs on rs.issued_id = ist.issued_id
join books as bk on bk.isbn = ist.issued_book_isbn
group by branch_id, manager_id;


select * from branch_report;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

-- Used CTAS and Subquery

Create Table active_members as
Select * from members 
where member_id in(
Select distinct ist.issued_member_id
from issued_status as ist
join members as m on ist.issued_member_id = m.member_id
where issued_date > current_date() - interval 6 month
);

select * from active_members;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
select em.emp_id, br.branch_id, em.emp_name, count(ist.issued_id) as no_book_issued 
from  employee as em
join issued_status as ist on ist.issued_emp_id = em.emp_id
join branch as br on br.branch_id = em.branch_id
group by em.emp_id, br.branch_id
order by count(ist.issued_id) desc
limit 3;
```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.  

```sql

select mem.member_id, mem.member_name, bk.book_title, count(ist.issued_book_isbn)
from return_status as rs
join issued_status as ist on ist.issued_id = rs.issued_id
join members as mem on mem.member_id = ist.issued_member_id
join books as bk on ist.issued_book_isbn = bk.isbn
where rs.book_quality = 'Damaged' 
group by mem.member_id, bk.book_title
having count(ist.issued_book_isbn) > 2;

```  


**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

Delimiter //
Create procedure issue_book(p_issued_id varchar(10), p_member_id varchar(10), p_issued_book_isbn varchar(30), p_issued_emp_id varchar(10))

Begin
declare v_status Varchar(10);

-- checking if book is available 
select status into v_status from books
where isbn = p_issued_book_isbn;

	if 
		v_status = 'yes' then
        insert into issued_status (issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        values(p_issued_id, p_member_id, current_date(), p_issued_book_isbn, p_issued_emp_id);
        
        update books
        set status = 'no'
        where isbn = p_issued_book_isbn;
        
        select concat('The book record added sucessfully for book isbn: ', p_issued_book_isbn);
    
    
    else 
		select concat('The book is Not Available as of now: ', p_issued_book_isbn);
    
    end if;

end;

// Delimiter ;

call issue_book('IS201', 'C110', '978-0-06-025492-6', 'E102');
```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines

```sql

Create table Books_overdue_and_fine 
as
select mem.member_id, mem.member_name, count(ist.issued_member_id) as books_overdue,
SUM(DATEDIFF(CURRENT_DATE(), DATE_ADD(ist.issued_date, INTERVAL 30 DAY)) * 0.50) as Total_fine
from members as mem
join issued_status as ist on mem.member_id = ist.issued_member_id
left join return_status as rs on ist.issued_id = rs.issued_id
join books as bk on bk.isbn = ist.issued_book_isbn
where rs.return_date is null
and DATEDIFF(CURRENT_DATE(), DATE_ADD(ist.issued_date, INTERVAL 30 DAY)) > 0
group by mem.member_id, mem.member_name
having Total_fine > 0 ;

```



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

2. **Set Up the Database**: Execute the SQL scripts in the Final project script.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the Questions.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.

## Author - Pratham Kaushik

This project showcases SQL skills essential for database management and analysis. 

- **LinkedIn**: [Connect with me professionally](http://www.linkedin.com/in/pratham-kaushik-/)


Thank you for your interest in this project!
