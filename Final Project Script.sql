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