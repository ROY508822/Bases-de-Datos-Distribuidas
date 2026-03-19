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

Fragmentos horizontales
------------------------
3. 🧠 *Fragmento zona1DB*. Construye un fragmento horizontal que contenga todos los clientes con dirección en los estados CDMX e Hidalgo. Incluye toda la información de los clientes y su órdenes de compra.
   
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

**Alternativa sencilla SQL server**

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

   
4. 🧠 *Fragmento zona2DB*. Construye un fragmento horizontal que contenga todos los clientes con dirección en los estados estado3 y estado4. Incluye toda la información de los clientes y su órdenes de compra.
   
**Esquema del fragmento** ✅

<img width="831" height="540" alt="image" src="https://github.com/user-attachments/assets/4b6704cf-0c08-4423-a21d-6ce9c8443cc4" />


**Script para crear fragmento** ✅

````SQL
CREATE DATABASE zona2DB;
USE zona2DB;

CREATE TABLE address (
    addressID  INT PRIMARY KEY,
    street     NVARCHAR(100),
    locality   NVARCHAR(100),
    city       NVARCHAR(100),
    postcode   NVARCHAR(10),
    state      NVARCHAR(50)
);

CREATE TABLE customer (
    customerID INT PRIMARY KEY,
    name       NVARCHAR(100),
    phone      NVARCHAR(20),
    email      NVARCHAR(100),
    addressID  INT
);

CREATE TABLE customerAddress (
    customerAddressID INT PRIMARY KEY,
    customerID        INT,
    addressID         INT,
    type              NVARCHAR(50),
    position          NVARCHAR(50)
);

CREATE TABLE customerOrder (
    orderID        INT PRIMARY KEY,
    customerID     INT,
    date           DATE,
    total          DECIMAL(10,2),
    paymentMethod  NVARCHAR(50),
    status         NVARCHAR(50)
);
````

**Scripts para descargar los datos de la base de datos salesbd.** 📌

````CMD
bcp "SELECT * FROM ECOMMERCE.dbo.address WHERE state IN ('Puebla','Queretaro')" queryout "C:\Users\royes\Desktop\address_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM ECOMMERCE.dbo.customer c WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE ca.customerID = c.customerID AND a.state IN ('Puebla','Queretaro'))" queryout "C:\Users\royes\Desktop\customer_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT ca.customerAddressID, ca.customerID, ca.addressID, ca.type, ca.position FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Puebla','Queretaro')" queryout "C:\Users\royes\Desktop\customerAddress_zona2.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM ECOMMERCE.dbo.customerOrder co WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customer c WHERE c.customerID = co.customerID AND EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE ca.customerID = c.customerID AND a.state IN ('Puebla','Queretaro')))" queryout "C:\Users\royes\Desktop\customerOrder_zona2.csv" -c -t, -r\n -S localhost -T
````

**Scripts para cargar los datos al fragmento 1.** 📌

````SQL
BULK INSERT zona2DB.dbo.address
FROM 'C:\Users\royes\Desktop\address_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona2DB.dbo.customer
FROM 'C:\Users\royes\Desktop\customer_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona2DB.dbo.customerAddress
FROM 'C:\Users\royes\Desktop\customerAddress_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona2DB.dbo.customerOrder
FROM 'C:\Users\royes\Desktop\customerOrder_zona2.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);
````
**Alternativa sencilla SQL server**

````SQL
INSERT INTO zona2DB.dbo.address
SELECT a.* FROM ECOMMERCE.dbo.address a
WHERE a.state IN ('Puebla', 'Queretaro');

INSERT INTO zona2DB.dbo.customer
SELECT c.* FROM ECOMMERCE.dbo.customer c
WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca
JOIN zona2DB.dbo.address a ON ca.addressID = a.addressID
WHERE ca.customerID = c.customerID);

INSERT INTO zona2DB.dbo.customerAddress
SELECT ca.* FROM ECOMMERCE.dbo.customerAddress ca
JOIN zona2DB.dbo.customer c ON ca.customerID = c.customerID
JOIN zona2DB.dbo.address a ON ca.addressID = a.addressID;

INSERT INTO zona2DB.dbo.customerOrder
SELECT co.* FROM ECOMMERCE.dbo.customerOrder co
WHERE EXISTS (SELECT 1 FROM zona2DB.dbo.customer c
WHERE c.customerID = co.customerID);
````


5. 🧠 *Fragmento zona3DB*. Construye un fragmento horizontal que contenga todos los clientes con dirección en los estados estado5 y estado6. Incluye toda la información de los clientes y su órdenes de compra.
   
**Esquema del fragmento** ✅

<img width="831" height="540" alt="image" src="https://github.com/user-attachments/assets/f503d249-1c52-4a6e-ba21-266623aada5d" />


**Script para crear fragmento** ✅

````SQL
CREATE DATABASE zona3DB;
USE zona3DB;

CREATE TABLE address (
    addressID  INT PRIMARY KEY,
    street     NVARCHAR(100),
    locality   NVARCHAR(100),
    city       NVARCHAR(100),
    postcode   NVARCHAR(10),
    state      NVARCHAR(50)
);

CREATE TABLE customer (
    customerID INT PRIMARY KEY,
    name       NVARCHAR(100),
    phone      NVARCHAR(20),
    email      NVARCHAR(100),
    addressID  INT
);

CREATE TABLE customerAddress (
    customerAddressID INT PRIMARY KEY,
    customerID        INT,
    addressID         INT,
    type              NVARCHAR(50),
    position          NVARCHAR(50)
);

CREATE TABLE customerOrder (
    orderID        INT PRIMARY KEY,
    customerID     INT,
    date           DATE,
    total          DECIMAL(10,2),
    paymentMethod  NVARCHAR(50),
    status         NVARCHAR(50)
);
````

**Scripts para descargar los datos de la base de datos salesbd.** 📌

````CMD
bcp "SELECT * FROM ECOMMERCE.dbo.address WHERE state IN ('Morelos','Veracruz')" queryout "C:\Users\royes\Desktop\address_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM ECOMMERCE.dbo.customer c WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE ca.customerID = c.customerID AND a.state IN ('Morelos','Veracruz'))" queryout "C:\Users\royes\Desktop\customer_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT ca.customerAddressID, ca.customerID, ca.addressID, ca.type, ca.position FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('Morelos','Veracruz')" queryout "C:\Users\royes\Desktop\customerAddress_zona3.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM ECOMMERCE.dbo.customerOrder co WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customer c WHERE c.customerID = co.customerID AND EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE ca.customerID = c.customerID AND a.state IN ('Morelos','Veracruz')))" queryout "C:\Users\royes\Desktop\customerOrder_zona3.csv" -c -t, -r\n -S localhost -T
````

**Scripts para cargar los datos al fragmento 1.** 📌

````SQL
BULK INSERT zona3DB.dbo.address
FROM 'C:\Users\royes\Desktop\address_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona3DB.dbo.customer
FROM 'C:\Users\royes\Desktop\customer_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona3DB.dbo.customerAddress
FROM 'C:\Users\royes\Desktop\customerAddress_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona3DB.dbo.customerOrder
FROM 'C:\Users\royes\Desktop\customerOrder_zona3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);
````
**Alternativa sencilla SQL server**

````SQL
INSERT INTO zona3DB.dbo.address
SELECT a.* FROM ECOMMERCE.dbo.address a
WHERE a.state IN ('Morelos','Veracruz');

INSERT INTO zona3DB.dbo.customer
SELECT c.* FROM ECOMMERCE.dbo.customer c
WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca
JOIN zona3DB.dbo.address a ON ca.addressID = a.addressID
WHERE ca.customerID = c.customerID);

INSERT INTO zona3DB.dbo.customerAddress
SELECT ca.* FROM ECOMMERCE.dbo.customerAddress ca
JOIN zona3DB.dbo.customer c ON ca.customerID = c.customerID
JOIN zona3DB.dbo.address a ON ca.addressID = a.addressID;

INSERT INTO zona3DB.dbo.customerOrder
SELECT co.* FROM ECOMMERCE.dbo.customerOrder co
WHERE EXISTS (SELECT 1 FROM zona3DB.dbo.customer c
WHERE c.customerID = co.customerID);
````
