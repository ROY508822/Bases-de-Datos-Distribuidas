# Distribución de datos
_______________________________

📌 Vertical Fragmentation


**Instructions**. 

For this exercise, the **salesBD** database is used to build the requested fragments.
It uses the [database backup](https://github.com/edcrvl/courses/edit/main/databases/salesBD_bk.sql)  to build the two vertical fragments.

To restore the backup, use the following process.
1. Log in to the MySQL server.
```
   sqlcmd -S localhost\SQLEXPRESS -E
```
2. Create a new database named **salesDB**.
```sql
   CREATE DATABASE salesDB;
   GO
```
3. To restore the salesBD_bk.sql file in the salesDB database, you must exit MySQL and execute the following command:
```
   sqlcmd -S localhost\SQLEXPRESS -E -d salesDB -i C:\Users\royes\Downloads\salesBD_bk.sql
```
4. Verify that the restoration process was complete. Generate the general statistics report with the following script:
```sql
   SELECT
    t.name AS [Tabla],
    SUM(p.rows) AS [Registros],
    CAST(SUM(a.total_pages) * 8.0 * 1024 / SUM(p.rows) AS INT) AS [Tamaño fila (bytes)],
    ROUND(SUM(a.data_pages) * 8.0 / 1024, 2) AS [Datos (MB)],
    ROUND((SUM(a.used_pages) - SUM(a.data_pages)) * 8.0 / 1024, 2) AS [Índices (MB)],
    ROUND(SUM(a.total_pages) * 8.0 / 1024, 2) AS [Total (MB)]
FROM sys.tables t
JOIN sys.indexes i
    ON t.object_id = i.object_id
JOIN sys.partitions p
    ON i.object_id = p.object_id
    AND i.index_id = p.index_id
JOIN sys.allocation_units a
    ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY t.name
ORDER BY [Registros] DESC;
GO
```
The result should be identical to the following table:

| Tabla           | Registros | Tamaño fila (bytes) | Datos (MB) | Índices (MB) | Total (MB) |
|-----------------|-----------|---------------------|------------|--------------|------------|
| product         | 400       | 368                 | 0.02       | 0.02         | 0.14       |
| customeraddress | 330       | 670                 | 0.02       | 0.02         | 0.21       |
| orderproduct    | 300       | 737                 | 0.02       | 0.02         | 0.21       |
| customerorder   | 202       | 729                 | 0.02       | 0.02         | 0.14       |
| customer        | 200       | 737                 | 0.02       | 0.02         | 0.14       |
| supplier        | 200       | 737                 | 0.02       | 0.02         | 0.14       |
| address         | 100       | 737                 | 0.02       | 0.02         | 0.07       |

The restored backup has a design error in the **customer** table.
Obtain the schema definition of the customer table with the following command:
```sql
    EXEC sp_columns customer;
    GO
```
The result is as follows:

| Field      | Type         | Null | Key | Default | Extra          |
|------------|--------------|------|-----|---------|----------------|
| customerID | int          | NO   | PRI | NULL    | auto_increment |
| name       | varchar(100) | YES  |     | NULL    |                |
| phone      | varchar(20)  | YES  |     | NULL    |                |
| email      | varchar(100) | YES  |     | NULL    |                |
| addressID  | int          | YES  | MUL | NULL    |                |

The _addressID_ attribute must be deleted. 
To do this, execute the following statement to remove the constraint _customer_ibfk_1_ linked to the addressID attribute.
```sql
    ALTER TABLE customer
    DROP CONSTRAINT FK_customer_address;
    GO

    DROP INDEX IX_customer_addressID ON customer;
    GO
```

Now, you can delete the _addressID_ column with the following script:
```sql
ALTER TABLE customer
DROP COLUMN addressID;
```

These lab is based on the following relational model.

```mermaid
erDiagram

    address {
        int addressID PK
        string street
        string localy
        string city
        string postcode
        string state
    }

    customer {
        int customerID PK
        string name
        string phone
        string email
    }

    customerAddress {
        int customerAddressID PK
        int customerID FK
        int addressID FK
        string type
        int position
    }

    supplier {
        int supplierID PK
        string name
        string phone
        string email
        int addressID FK
    }

    product {
        int productID PK
        string name
        string type
        int amount
        decimal price
        string detail
        int supplierID FK
    }

    customerOrder {
        int orderID PK
        int customerID FK
        date date
        decimal total
        string paymentMethod
        string status
    }

    orderProduct {
        int orderProductID PK
        int orderID FK
        int productID FK
        int quantity
        decimal price
    }

    address ||--o{ customerAddress : "used by"
    customer ||--o{ customerAddress : "has"

    address ||--o{ supplier : "location of"

    supplier ||--o{ product : "supplies"

    customer ||--o{ customerOrder : "places"

    customerOrder ||--o{ orderProduct : "contains"

    product ||--o{ orderProduct : "included in"
```

# Vertical fragment: _customerDB_

## 1. 🧠 Build a vertical fragment that contains all customer data.

### ✅ Relational model of vertical fragment customerDB.

```mermaid
erDiagram

    address {
        int addressID PK
        string street
        string locality
        string city
        string postcode
        string state
    }

    customer {
        int customerID PK
        string name
        string phone
        string email
    }

    customerAddress {
        int customerAddressID PK
        int customerID FK
        int addressID FK
        string type
        string position
    }

    product {
        int productID PK
        string name
        string type
        int amount
        decimal price
        string detail
        int supplierID
    }

    customerOrder {
        int orderID PK
        int customerID FK
        date date
        decimal total
        string paymentMethod
        string status
    }

    orderProduct {
        int orderProductID PK
        int orderID FK
        int productID FK
        int quantity
        decimal price
    }


    address ||--o{ customerAddress : "used by"
    customer ||--o{ customerAddress : "has"

    customer ||--o{ customerOrder : "places"

    customerOrder ||--o{ orderProduct : "contains"

    product ||--o{ orderProduct : "included in"
```

### ✅ SQL scripts to create a fragment customerDB in MySQL.

To create the database **customerDB** use following command:

```sql
    CREATE DATABASE customerDB;
```
To create the database tables, you must use the following commands:

```sql
USE customerDB;
GO

CREATE TABLE address (
    addressID INT IDENTITY(1,1) NOT NULL,
    street NVARCHAR(100) NOT NULL,
    locality NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    postcode NVARCHAR(10) NOT NULL,
    state NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (addressID)
);
GO

CREATE TABLE customer (
    customerID INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_customer PRIMARY KEY (customerID),
);
GO

CREATE TABLE customerAddress (
    customerAddressID INT IDENTITY(1,1) NOT NULL,
    customerID INT NOT NULL,
    addressID INT NOT NULL,
    type NVARCHAR(50) NOT NULL,
    position NVARCHAR(50),
    CONSTRAINT pk_customerAddress PRIMARY KEY (customerAddressID),
    CONSTRAINT fk_ca_customer
        FOREIGN KEY (customerID)
        REFERENCES customer(customerID),
    CONSTRAINT fk_ca_address
        FOREIGN KEY (addressID)
        REFERENCES address(addressID)
);
GO

CREATE TABLE product (
    productID INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    amount INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    detail NVARCHAR(255),
    supplierID INT,
    CONSTRAINT pk_product PRIMARY KEY (productID)
);
GO

CREATE TABLE customerOrder (
    orderID INT IDENTITY(1,1) NOT NULL,
    customerID INT NOT NULL,
    date DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    paymentMethod NVARCHAR(50),
    status NVARCHAR(50) NOT NULL DEFAULT 'pending',
    CONSTRAINT pk_customerOrder PRIMARY KEY (orderID),
    CONSTRAINT fk_co_customer
        FOREIGN KEY (customerID)
        REFERENCES customer(customerID)
);
GO

CREATE TABLE orderProduct (
    orderProductID INT IDENTITY(1,1) NOT NULL,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_orderProduct PRIMARY KEY (orderProductID),
    CONSTRAINT fk_op_order
        FOREIGN KEY (orderID)
        REFERENCES customerOrder(orderID),
    CONSTRAINT fk_op_product
        FOREIGN KEY (productID)
        REFERENCES product(productID)
);
GO
```

### 📌 Scripts for downloading data from the **salesBD** database in CSV format.

From the command line, we can extract information from a table in a MySQL database and store the content in a plain text file. 
In the following example, data is extracted from the customer table in the salesDB database and saved in the customer.txt file.
``` SQL
bcp "SELECT * FROM salesDB.dbo.address" queryout "C:\Users\royes\Desktop\cust_address.txt" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.customer" queryout "C:\Users\royes\Desktop\fragcustomertrue.txt" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.customerAddress" queryout "C:\Users\royes\Desktop\cust_customerAddress.txt" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.customerOrder" queryout "C:\Users\royes\Desktop\cust_customerOrder.txt" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.product" queryout "C:\Users\royes\Desktop\cust_product.txt" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.orderProduct" queryout "C:\Users\royes\Desktop\cust_orderProduct.txt" -c -t, -r\n -S localhost -T
```

Another option is to download the table content into a file in CSV format 
with the _SELECT INTO OUTFILE_ statement as follows:

```sql
bcp "SELECT * FROM salesDB.dbo.address" queryout "C:\Users\royes\Desktop\cust_address.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.customer" queryout "C:\Users\royes\Desktop\fragcustomertrue.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.customerAddress" queryout "C:\Users\royes\Desktop\cust_customerAddress.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.customerOrder" queryout "C:\Users\royes\Desktop\cust_customerOrder.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.product" queryout "C:\Users\royes\Desktop\cust_product.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.orderProduct" queryout "C:\Users\royes\Desktop\cust_orderProduct.csv" -c -t, -r\n -S localhost -T
```

### 📌 Scripts for loading data from the CSV format files to database customerDB.

```sql
BULK INSERT customerDB.dbo.address
FROM 'C:\Users\royes\Desktop\cust_address.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT customerDB.dbo.customer
FROM 'C:\Users\royes\Desktop\cust_customer.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT customerDB.dbo.customerAddress
FROM 'C:\Users\royes\Desktop\cust_customerAddress.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT customerDB.dbo.customerOrder
FROM 'C:\Users\royes\Desktop\cust_customerOrder.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT customerDB.dbo.product
FROM 'C:\Users\royes\Desktop\cust_product.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT customerDB.dbo.orderProduct
FROM 'C:\Users\royes\Desktop\cust_orderProduct.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');
```

Another option to extract and load tables form diferent databases (ONLY SQL SERVER)

````SQL
SET IDENTITY_INSERT customerDB.dbo.address ON;

INSERT INTO customerDB.dbo.address (addressID, street, locality, city, postcode, state)
SELECT addressID, street, localy, city, postcode, state
FROM salesDB.dbo.address;

SET IDENTITY_INSERT customerDB.dbo.address OFF;


SET IDENTITY_INSERT customerDB.dbo.customer ON;

INSERT INTO customerDB.dbo.customer (customerID, name, phone, email, addressID)
SELECT customerID, name, phone, email, addressID
FROM salesDB.dbo.customer;

SET IDENTITY_INSERT customerDB.dbo.customer OFF;


SET IDENTITY_INSERT customerDB.dbo.customerAddress ON;

INSERT INTO customerDB.dbo.customerAddress (customerAddressID, customerID, addressID, type, position)
SELECT customerAddressID, customerID, addressID, type, position
FROM salesDB.dbo.customerAddress;

SET IDENTITY_INSERT customerDB.dbo.customerAddress OFF;


SET IDENTITY_INSERT customerDB.dbo.customerOrder ON;

INSERT INTO customerDB.dbo.customerOrder (orderID, customerID, date, total, paymentMethod, status)
SELECT orderID, customerID, date, total, paymentMethod, status
FROM salesDB.dbo.customerOrder;

SET IDENTITY_INSERT customerDB.dbo.customerOrder OFF;


SET IDENTITY_INSERT customerDB.dbo.product ON;

INSERT INTO customerDB.dbo.product (productID, name, type, amount, price, detail, supplierID)
SELECT productID, name, type, amount, price, detail, supplierID
FROM salesDB.dbo.product;

SET IDENTITY_INSERT customerDB.dbo.product OFF;


SET IDENTITY_INSERT customerDB.dbo.orderProduct ON;

INSERT INTO customerDB.dbo.orderProduct (orderProductID, orderID, productID, quantity, price)
SELECT orderProductID, orderID, productID, quantity, price
FROM salesDB.dbo.orderProduct;

SET IDENTITY_INSERT customerDB.dbo.orderProduct OFF;
````
# Vertical fragment: _supplierDB_

## 2. 🧠 Build a vertical fragment that contains all supplier data.

### ✅ Relational model of vertical fragment supplierDB.

```mermaid
erDiagram

    address {
        int addressID PK
        string street
        string locality
        string city
        string postcode
        string state
    }

    supplier {
        int supplierID PK
        string name
        string phone
        string email
        int addressID FK
    }

    product {
        int productID PK
        string name
        string type
        int amount
        decimal price
        string detail
        int supplierID FK
    }

    address ||--o{ supplier : "location of"

    supplier ||--o{ product : "supplies"
```

### ✅ SQL scripts to create a fragment supplierDB in MySQL.

To create the database **supplierDB** use following command:

```sql
CREATE DATABASE supplierDB;
```
To create the database tables, you must use the following commands:

```sql
USE supplierDB;
GO

CREATE TABLE address (
    addressID INT IDENTITY(1,1) NOT NULL,
    street NVARCHAR(100) NOT NULL,
    locality NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    postcode NVARCHAR(10) NOT NULL,
    state NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (addressID)
);
GO

CREATE TABLE supplier (
    supplierID INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100) NOT NULL,
    addressID INT NOT NULL,
    CONSTRAINT pk_supplier PRIMARY KEY (supplierID),
    CONSTRAINT fk_supplier_address
        FOREIGN KEY (addressID)
        REFERENCES address(addressID)
);
GO

CREATE TABLE product (
    productID INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    amount INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    detail NVARCHAR(255),
    supplierID INT NOT NULL,
    CONSTRAINT pk_product PRIMARY KEY (productID),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplierID)
        REFERENCES supplier(supplierID)
);
GO
```

### 📌 Scripts for downloading data from the **salesBD** database in CSV format.

Another option is to download the table content into a file in CSV format:

```sql
bcp "SELECT * FROM salesDB.dbo.address" queryout "C:\Users\royes\Desktop\supplier_address.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.supplier" queryout "C:\Users\royes\Desktop\supplier_supplier.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.product" queryout "C:\Users\royes\Desktop\supplier_product.csv" -c -t, -r\n -S localhost -T
```

### 📌 Scripts for loading data from the CSV format files to database customerDB.

```sql
BULK INSERT supplierDB.dbo.address
FROM 'C:\Users\royes\Desktop\supplier_address.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT supplierDB.dbo.supplier
FROM 'C:\Users\royes\Desktop\supplier_supplier.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');

BULK INSERT supplierDB.dbo.product
FROM 'C:\Users\royes\Desktop\supplier_product.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');
```

Another option to extract and load tables form diferent databases (ONLY SQL SERVER)

````SQL
SET IDENTITY_INSERT supplierDB.dbo.address ON;

INSERT INTO supplierDB.dbo.address (addressID, street, locality, city, postcode, state)
SELECT addressID, street, localy, city, postcode, state
FROM salesDB.dbo.address;

SET IDENTITY_INSERT supplierDB.dbo.address OFF;


SET IDENTITY_INSERT supplierDB.dbo.supplier ON;

INSERT INTO supplierDB.dbo.supplier (supplierID, name, phone, email, addressID)
SELECT supplierID, name, phone, email, addressID
FROM salesDB.dbo.supplier;

SET IDENTITY_INSERT supplierDB.dbo.supplier OFF;


SET IDENTITY_INSERT supplierDB.dbo.product ON;

INSERT INTO supplierDB.dbo.product (productID, name, type, amount, price, detail, supplierID)
SELECT productID, name, type, amount, price, detail, supplierID
FROM salesDB.dbo.product;

SET IDENTITY_INSERT supplierDB.dbo.product OFF;
````


