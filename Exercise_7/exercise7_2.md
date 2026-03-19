These lab is based on the following relational model.

````mermaid
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
````

Horizontal fragmentation
------------------------
3. 🧠 *Fragment ZonaDB_1*. Build a horizontal fragment that contains all customers whose address is in the states of CDMX and Hidalgo. Include all customer information and their purchase orders.
   
**Esquema del fragmento** ✅

````mermaid
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
````
To create the database **ZonaDB_1** use following command:
````SQL
CREATE DATABASE ZonaDB_1;
GO
````

To create the database tables, you must use the following commands:
````SQL
USE ZonaDB_1;
GO

CREATE TABLE address (
    addressID INT NOT NULL,
    street NVARCHAR(100) NOT NULL,
    locality NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    postcode NVARCHAR(10) NOT NULL,
    state NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (addressID)
);
GO

CREATE TABLE customer (
    customerID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_customer PRIMARY KEY (customerID)
);
GO

CREATE TABLE customerAddress (
    customerAddressID INT NOT NULL,
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

-- REPLICA
CREATE TABLE supplier (
    supplierID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100),
    addressID INT,
    CONSTRAINT pk_supplier PRIMARY KEY (supplierID)
);
GO

-- REPLICA
CREATE TABLE product (
    productID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    amount INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    detail NVARCHAR(255),
    supplierID INT,
    CONSTRAINT pk_product PRIMARY KEY (productID),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplierID)
        REFERENCES supplier(supplierID)
);
GO

CREATE TABLE customerOrder (
    orderID INT NOT NULL,
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
    orderProductID INT NOT NULL,
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

-- Identity no usado por problemas de consistencia a la hora de fragmnetar se deberia de hacer un id global
````
 
### 📌 Scripts for downloading data from the **salesDB** database in CSV format.

From the command line, we can extract information from a table in a SQL Server database and store the content in a plain text file. 
In the following example, data is extracted from the tables in the salesDB database and saved in the CSV files.

````CMD
bcp "SELECT * FROM salesDB.dbo.address WHERE state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\address_zona1.csv" -c -t, -r\n -S localhost -T

bcp "SELECT DISTINCT c.* FROM salesDB.dbo.customer c JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\customer_zona1.csv" -c -t, -r\n -S localhost -T

bcp "SELECT ca.customerAddressID, ca.customerID, ca.addressID, ca.type, ca.position FROM salesDB.dbo.customerAddress ca JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\customerAddress_zona1.csv" -c -t, -r\n -S localhost -T

bcp "SELECT DISTINCT co.* FROM salesDB.dbo.customerOrder co JOIN salesDB.dbo.customer c ON co.customerID = c.customerID JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\customerOrder_zona1.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.supplier" queryout "C:\Users\royes\Desktop\supplier_zona1.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.product" queryout "C:\Users\royes\Desktop\product_zona1.csv" -c -t, -r\n -S localhost -T

bcp "SELECT op.* FROM salesDB.dbo.orderProduct op JOIN salesDB.dbo.customerOrder co ON op.orderID = co.orderID JOIN salesDB.dbo.customer c ON co.customerID = c.customerID JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\orderProduct_zona1.csv" -c -t, -r\n -S localhost -T
````

### 📌 Scripts for loading data from the CSV format files to database ZonaDB_1.

````SQL
BULK INSERT dbo.address
FROM 'C:\Users\royes\Desktop\address_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.supplier
FROM 'C:\Users\royes\Desktop\supplier_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.product
FROM 'C:\Users\royes\Desktop\product_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customer
FROM 'C:\Users\royes\Desktop\customer_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customerAddress
FROM 'C:\Users\royes\Desktop\customerAddress_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customerOrder
FROM 'C:\Users\royes\Desktop\customerOrder_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.orderProduct
FROM 'C:\Users\royes\Desktop\orderProduct_zona1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

GO
````

Another option to extract and load tables form diferent databases (ONLY SQL SERVER)

````SQL
INSERT INTO ZonaDB_1.dbo.address
SELECT a.*
FROM salesDB.dbo.address a
WHERE a.state IN ('CDMX', 'Hidalgo');

SELECT * FROM ZonaDB_1.dbo.address;

INSERT INTO ZonaDB_1.dbo.customer
SELECT DISTINCT c.*
FROM salesDB.dbo.customer c
JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID
JOIN ZonaDB_1.dbo.address a ON ca.addressID = a.addressID;

SELECT * FROM ZonaDB_1.dbo.customer;

INSERT INTO ZonaDB_1.dbo.customerAddress
SELECT ca.*
FROM salesDB.dbo.customerAddress ca
JOIN ZonaDB_1.dbo.customer c ON ca.customerID = c.customerID
JOIN ZonaDB_1.dbo.address a ON ca.addressID = a.addressID;

SELECT * FROM ZonaDB_1.dbo.customerAddress;

INSERT INTO ZonaDB_1.dbo.supplier
SELECT *
FROM salesDB.dbo.supplier;

SELECT * FROM ZonaDB_1.dbo.supplier;

INSERT INTO ZonaDB_1.dbo.product
SELECT *
FROM salesDB.dbo.product;

SELECT * FROM ZonaDB_1.dbo.product;

INSERT INTO ZonaDB_1.dbo.customerOrder
SELECT DISTINCT co.*
FROM salesDB.dbo.customerOrder co
JOIN ZonaDB_1.dbo.customer c ON co.customerID = c.customerID;

SELECT * FROM ZonaDB_1.dbo.customerOrder;

INSERT INTO ZonaDB_1.dbo.orderProduct
SELECT op.*
FROM salesDB.dbo.orderProduct op
JOIN ZonaDB_1.dbo.customerOrder co ON op.orderID = co.orderID;

SELECT * FROM ZonaDB_1.dbo.orderProduct;
````

4. 🧠 3. 🧠 *Fragment ZonaDB_2*. Build a horizontal fragment that contains all customers whose address is in the states of Queretaro and Morelos. Include all customer information and their purchase orders.
   
**Esquema del fragmento** ✅

````mermaid
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
````
To create the database **ZonaDB_2** use following command:
````SQL
CREATE DATABASE ZonaDB_2;
GO
````

To create the database tables, you must use the following commands:
````SQL
USE ZonaDB_2;
GO

CREATE TABLE address (
    addressID INT NOT NULL,
    street NVARCHAR(100) NOT NULL,
    locality NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    postcode NVARCHAR(10) NOT NULL,
    state NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (addressID)
);
GO

CREATE TABLE customer (
    customerID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_customer PRIMARY KEY (customerID)
);
GO

CREATE TABLE customerAddress (
    customerAddressID INT NOT NULL,
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

-- REPLICA
CREATE TABLE supplier (
    supplierID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100),
    addressID INT,
    CONSTRAINT pk_supplier PRIMARY KEY (supplierID)
);
GO

-- REPLICA
CREATE TABLE product (
    productID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    amount INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    detail NVARCHAR(255),
    supplierID INT,
    CONSTRAINT pk_product PRIMARY KEY (productID),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplierID)
        REFERENCES supplier(supplierID)
);
GO

CREATE TABLE customerOrder (
    orderID INT NOT NULL,
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
    orderProductID INT NOT NULL,
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

-- Identity no usado por problemas de consistencia a la hora de fragmnetar se deberia de hacer un id global
````
 
### 📌 Scripts for downloading data from the **salesDB** database in CSV format.

From the command line, we can extract information from a table in a SQL Server database and store the content in a plain text file. 
In the following example, data is extracted from the tables in the salesDB database and saved in the CSV files.

````CMD
bcp "SELECT * FROM salesDB.dbo.address WHERE state IN ('Queretaro','Morelos')" queryout "C:\Users\royes\Desktop\address_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT DISTINCT c.* FROM salesDB.dbo.customer c JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Queretaro','Morelos')" queryout "C:\Users\royes\Desktop\customer_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT ca.customerAddressID, ca.customerID, ca.addressID, ca.type, ca.position FROM salesDB.dbo.customerAddress ca JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Queretaro','Morelos')" queryout "C:\Users\royes\Desktop\customerAddress_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT DISTINCT co.* FROM salesDB.dbo.customerOrder co JOIN salesDB.dbo.customer c ON co.customerID = c.customerID JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Queretaro','Morelos')" queryout "C:\Users\royes\Desktop\customerOrder_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.supplier" queryout "C:\Users\royes\Desktop\supplier_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.product" queryout "C:\Users\royes\Desktop\product_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT op.* FROM salesDB.dbo.orderProduct op JOIN salesDB.dbo.customerOrder co ON op.orderID = co.orderID JOIN salesDB.dbo.customer c ON co.customerID = c.customerID JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Queretaro','Morelos')" queryout "C:\Users\royes\Desktop\orderProduct_zona2.csv" -c -t, -r\n -S localhost -T
````

### 📌 Scripts for loading data from the CSV format files to database ZonaDB_2.

````SQL
BULK INSERT dbo.address
FROM 'C:\Users\royes\Desktop\address_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.supplier
FROM 'C:\Users\royes\Desktop\supplier_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.product
FROM 'C:\Users\royes\Desktop\product_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customer
FROM 'C:\Users\royes\Desktop\customer_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customerAddress
FROM 'C:\Users\royes\Desktop\customerAddress_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customerOrder
FROM 'C:\Users\royes\Desktop\customerOrder_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.orderProduct
FROM 'C:\Users\royes\Desktop\orderProduct_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

GO
````

Another option to extract and load tables form diferent databases (ONLY SQL SERVER)

````SQL
INSERT INTO ZonaDB_2.dbo.address
SELECT a.*
FROM salesDB.dbo.address a
WHERE a.state IN ('Queretaro', 'Morelos');

SELECT * FROM ZonaDB_2.dbo.address;

INSERT INTO ZonaDB_2.dbo.customer
SELECT DISTINCT c.*
FROM salesDB.dbo.customer c
JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID
JOIN ZonaDB_2.dbo.address a ON ca.addressID = a.addressID;

SELECT * FROM ZonaDB_2.dbo.customer;

INSERT INTO ZonaDB_2.dbo.customerAddress
SELECT ca.*
FROM salesDB.dbo.customerAddress ca
JOIN ZonaDB_2.dbo.customer c ON ca.customerID = c.customerID
JOIN ZonaDB_2.dbo.address a ON ca.addressID = a.addressID;

SELECT * FROM ZonaDB_2.dbo.customerAddress;

INSERT INTO ZonaDB_2.dbo.supplier
SELECT *
FROM salesDB.dbo.supplier;

SELECT * FROM ZonaDB_2.dbo.supplier;

INSERT INTO ZonaDB_2.dbo.product
SELECT *
FROM salesDB.dbo.product;

SELECT * FROM ZonaDB_2.dbo.product;

INSERT INTO ZonaDB_2.dbo.customerOrder
SELECT DISTINCT co.*
FROM salesDB.dbo.customerOrder co
JOIN ZonaDB_2.dbo.customer c ON co.customerID = c.customerID;

SELECT * FROM ZonaDB_2.dbo.customerOrder;

INSERT INTO ZonaDB_2.dbo.orderProduct
SELECT op.*
FROM salesDB.dbo.orderProduct op
JOIN ZonaDB_2.dbo.customerOrder co ON op.orderID = co.orderID;

SELECT * FROM ZonaDB_2.dbo.orderProduct;
````

5. 🧠 *Fragment ZonaDB_3*. Build a horizontal fragment that contains all customers whose address is in the states of Puebla and Veracru. Include all customer information and their purchase orders.
   
**Esquema del fragmento** ✅

````mermaid
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
````
To create the database **ZonaDB_3** use following command:
````SQL
CREATE DATABASE ZonaDB_3;
GO
````

To create the database tables, you must use the following commands:
````SQL
USE ZonaDB_3;
GO

CREATE TABLE address (
    addressID INT NOT NULL,
    street NVARCHAR(100) NOT NULL,
    locality NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    postcode NVARCHAR(10) NOT NULL,
    state NVARCHAR(50) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (addressID)
);
GO

CREATE TABLE customer (
    customerID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_customer PRIMARY KEY (customerID)
);
GO

CREATE TABLE customerAddress (
    customerAddressID INT NOT NULL,
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

-- REPLICA
CREATE TABLE supplier (
    supplierID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100),
    addressID INT,
    CONSTRAINT pk_supplier PRIMARY KEY (supplierID)
);
GO

-- REPLICA
CREATE TABLE product (
    productID INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    amount INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    detail NVARCHAR(255),
    supplierID INT,
    CONSTRAINT pk_product PRIMARY KEY (productID),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplierID)
        REFERENCES supplier(supplierID)
);
GO

CREATE TABLE customerOrder (
    orderID INT NOT NULL,
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
    orderProductID INT NOT NULL,
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

-- Identity no usado por problemas de consistencia a la hora de fragmnetar se deberia de hacer un id global
````
 
### 📌 Scripts for downloading data from the **salesDB** database in CSV format.

From the command line, we can extract information from a table in a SQL Server database and store the content in a plain text file. 
In the following example, data is extracted from the tables in the salesDB database and saved in the CSV files.

````CMD
bcp "SELECT * FROM salesDB.dbo.address WHERE state IN ('Puebla','Veracruz')" queryout "C:\Users\royes\Desktop\address_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT DISTINCT c.* FROM salesDB.dbo.customer c JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Puebla','Veracruz')" queryout "C:\Users\royes\Desktop\customer_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT ca.customerAddressID, ca.customerID, ca.addressID, ca.type, ca.position FROM salesDB.dbo.customerAddress ca JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Puebla','Veracruz')" queryout "C:\Users\royes\Desktop\customerAddress_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT DISTINCT co.* FROM salesDB.dbo.customerOrder co JOIN salesDB.dbo.customer c ON co.customerID = c.customerID JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Puebla','Veracruz')" queryout "C:\Users\royes\Desktop\customerOrder_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.supplier" queryout "C:\Users\royes\Desktop\supplier_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM salesDB.dbo.product" queryout "C:\Users\royes\Desktop\product_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT op.* FROM salesDB.dbo.orderProduct op JOIN salesDB.dbo.customerOrder co ON op.orderID = co.orderID JOIN salesDB.dbo.customer c ON co.customerID = c.customerID JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID JOIN salesDB.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Puebla','Veracruz')" queryout "C:\Users\royes\Desktop\orderProduct_zona3.csv" -c -t, -r\n -S localhost -T
````

### 📌 Scripts for loading data from the CSV format files to database ZonaDB_3.

````SQL
BULK INSERT dbo.address
FROM 'C:\Users\royes\Desktop\address_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.supplier
FROM 'C:\Users\royes\Desktop\supplier_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.product
FROM 'C:\Users\royes\Desktop\product_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customer
FROM 'C:\Users\royes\Desktop\customer_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customerAddress
FROM 'C:\Users\royes\Desktop\customerAddress_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.customerOrder
FROM 'C:\Users\royes\Desktop\customerOrder_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT dbo.orderProduct
FROM 'C:\Users\royes\Desktop\orderProduct_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

GO
````

Another option to extract and load tables form diferent databases (ONLY SQL SERVER)

````SQL
INSERT INTO ZonaDB_3.dbo.address
SELECT a.*
FROM salesDB.dbo.address a
WHERE a.state IN ('Puebla','Veracruz');

SELECT * FROM ZonaDB_3.dbo.address;

INSERT INTO ZonaDB_3.dbo.customer
SELECT DISTINCT c.*
FROM salesDB.dbo.customer c
JOIN salesDB.dbo.customerAddress ca ON c.customerID = ca.customerID
JOIN ZonaDB_3.dbo.address a ON ca.addressID = a.addressID;

SELECT * FROM ZonaDB_3.dbo.customer;

INSERT INTO ZonaDB_3.dbo.customerAddress
SELECT ca.*
FROM salesDB.dbo.customerAddress ca
JOIN ZonaDB_3.dbo.customer c ON ca.customerID = c.customerID
JOIN ZonaDB_3.dbo.address a ON ca.addressID = a.addressID;

SELECT * FROM ZonaDB_3.dbo.customerAddress;

INSERT INTO ZonaDB_3.dbo.supplier
SELECT *
FROM salesDB.dbo.supplier;

SELECT * FROM ZonaDB_3.dbo.supplier;

INSERT INTO ZonaDB_3.dbo.product
SELECT *
FROM salesDB.dbo.product;

SELECT * FROM ZonaDB_3.dbo.product;

INSERT INTO ZonaDB_3.dbo.customerOrder
SELECT DISTINCT co.*
FROM salesDB.dbo.customerOrder co
JOIN ZonaDB_3.dbo.customer c ON co.customerID = c.customerID;

SELECT * FROM ZonaDB_3.dbo.customerOrder;

INSERT INTO ZonaDB_3.dbo.orderProduct
SELECT op.*
FROM salesDB.dbo.orderProduct op
JOIN ZonaDB_3.dbo.customerOrder co ON op.orderID = co.orderID;

SELECT * FROM ZonaDB_1.dbo.orderProduct;
````

### Script to reconstruct salesDB

````SQL
CREATE DATABASE salesDB3;
GO

USE salesDB3;
GO

CREATE TABLE address (
    addressID INT NOT NULL PRIMARY KEY,
    street NVARCHAR(100) NOT NULL,
    locality NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    postcode NVARCHAR(10) NOT NULL,
    state NVARCHAR(50) NOT NULL
);

CREATE TABLE customer (
    customerID INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100) NOT NULL
);

CREATE TABLE customerAddress (
    customerAddressID INT NOT NULL PRIMARY KEY,
    customerID INT NOT NULL,
    addressID INT NOT NULL,
    type NVARCHAR(50) NOT NULL,
    position NVARCHAR(50),
    FOREIGN KEY (customerID) REFERENCES customer(customerID),
    FOREIGN KEY (addressID) REFERENCES address(addressID)
);

CREATE TABLE supplier (
    supplierID INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100),
    addressID INT
);

CREATE TABLE product (
    productID INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(50),
    amount INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    detail NVARCHAR(255),
    supplierID INT,
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
);

CREATE TABLE customerOrder (
    orderID INT NOT NULL PRIMARY KEY,
    customerID INT NOT NULL,
    date DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    paymentMethod NVARCHAR(50),
    status NVARCHAR(50) NOT NULL DEFAULT 'pending',
    FOREIGN KEY (customerID) REFERENCES customer(customerID)
);

CREATE TABLE orderProduct (
    orderProductID INT NOT NULL PRIMARY KEY,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (orderID) REFERENCES customerOrder(orderID),
    FOREIGN KEY (productID) REFERENCES product(productID)
);

INSERT INTO address
SELECT * FROM ZonaDB_1.dbo.address
UNION ALL
SELECT * FROM ZonaDB_2.dbo.address
UNION ALL
SELECT * FROM ZonaDB_3.dbo.address;

INSERT INTO customer
SELECT * FROM ZonaDB_1.dbo.customer
UNION
SELECT * FROM ZonaDB_2.dbo.customer
UNION
SELECT * FROM ZonaDB_3.dbo.customer;

INSERT INTO customerAddress
SELECT * FROM ZonaDB_1.dbo.customerAddress
UNION
SELECT * FROM ZonaDB_2.dbo.customerAddress
UNION
SELECT * FROM ZonaDB_3.dbo.customerAddress;

INSERT INTO supplier
SELECT * FROM ZonaDB_1.dbo.supplier;

INSERT INTO product
SELECT * FROM ZonaDB_1.dbo.product;

INSERT INTO customerOrder
SELECT * FROM ZonaDB_1.dbo.customerOrder
UNION
SELECT * FROM ZonaDB_2.dbo.customerOrder
UNION
SELECT * FROM ZonaDB_3.dbo.customerOrder;

INSERT INTO orderProduct
SELECT * FROM ZonaDB_1.dbo.orderProduct
UNION
SELECT * FROM ZonaDB_2.dbo.orderProduct
UNION
SELECT * FROM ZonaDB_3.dbo.orderProduct;
````
### Check description to the database 

```` SQL
SELECT
    t.name AS Tabla,
    MAX(p.rows) AS Registros,
    CAST((SUM(a.data_pages) * 8.0 * 1024) / MAX(p.rows) AS INT) AS [Tuple size (bytes)],
    CAST(SUM(a.data_pages) * 8.0 / 1024 AS DECIMAL(10,2)) AS [Datos (MB)],
    CAST((SUM(a.used_pages) - SUM(a.data_pages)) * 8.0 / 1024 AS DECIMAL(10,2)) AS [Índices (MB)],
    CAST(SUM(a.used_pages) * 8.0 / 1024 AS DECIMAL(10,2)) AS [Total (MB)]
FROM sys.tables t
JOIN sys.indexes i
     ON t.object_id = i.object_id
JOIN sys.partitions p
     ON i.object_id = p.object_id
    AND i.index_id = p.index_id
JOIN sys.allocation_units a
     ON p.partition_id = a.container_id
WHERE i.index_id <= 1
GROUP BY t.name
ORDER BY Registros DESC;
````
| Table           | Rows | Tuple size (bytes) | Data (MB) | Index (MB) | Total (MB) |
|-----------------|------|--------------------|-----------|------------|------------|
| customerAddress | 110  | 74                 | 0.01      | 0.01       | 0.02       |
| customerOrder   | 101  | 81                 | 0.01      | 0.01       | 0.02       |
| orderProduct    | 100  | 81                 | 0.01      | 0.01       | 0.02       |
| product         | 100  | 163                | 0.02      | 0.02       | 0.03       |
| supplier        | 100  | 163                | 0.02      | 0.02       | 0.03       |
| address         | 100  | 163                | 0.02      | 0.02       | 0.03       |
| customer        | 100  | 163                | 0.02      | 0.02       | 0.03       |
