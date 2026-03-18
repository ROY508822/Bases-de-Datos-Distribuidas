Fragmentos horizontales
------------------------
3. 🧠 *Fragmento zona1DB*. Construye un fragmento horizontal que contenga todos los clientes con dirección en los estados CDMX e Hidalgo. Incluye toda la información de los clientes y su órdenes de compra.
   
**Esquema del fragmento** ✅

<img width="969" height="660" alt="image" src="https://github.com/user-attachments/assets/8df720db-b566-4b80-b9d8-6edbf3235d6d" />


**Script para crear fragmento** ✅

````SQL
CREATE DATABASE zona1DB;
USE zona1DB;

CREATE TABLE address (
    addressID  INT PRIMARY KEY,
    street     NVARCHAR(100),
    locality   NVARCHAR(100),
    city       NVARCHAR(100),
    postcode   NVARCHAR(10),
    state      NVARCHAR(50)
);

CREATE TABLE customer(
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

CREATE TABLE customerOrder(
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
bcp "SELECT * FROM ECOMMERCE.dbo.address WHERE state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\address.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM ECOMMERCE.dbo.customer c WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE ca.customerID = c.customerID AND a.state IN ('CDMX','Hidalgo'))" queryout "C:\Users\royes\Desktop\customer.csv" -c -t, -r\n -S localhost -T

bcp "SELECT ca.customerAddressID, ca.customerID, ca.addressID, ca.type, ca.position FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE a.state IN ('CDMX','Hidalgo')" queryout "C:\Users\royes\Desktop\customerAddress.csv" -c -t, -r\n -S localhost -T

bcp "SELECT * FROM ECOMMERCE.dbo.customerOrder co WHERE EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customer c WHERE c.customerID = co.customerID AND EXISTS (SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca JOIN ECOMMERCE.dbo.address a ON ca.addressID = a.addressID WHERE ca.customerID = c.customerID AND a.state IN ('CDMX','Hidalgo')))" queryout "C:\Users\royes\Desktop\customerOrder.csv" -c -t, -r\n -S localhost -T
````

**Scripts para cargar los datos al fragmento 1.** 📌

````SQL
BULK INSERT zona1DB.dbo.address
FROM 'C:\Users\royes\Desktop\address.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona1DB.dbo.customer
FROM 'C:\Users\royes\Desktop\customer.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona1DB.dbo.customerAddress
FROM 'C:\Users\royes\Desktop\customerAddress.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

BULK INSERT zona1DB.dbo.customerOrder
FROM 'C:\Users\royes\Desktop\customerOrder.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);
````

**Alternativa sencilla SQL server**

````SQL
INSERT INTO zona1DB.dbo.address
SELECT a.* FROM ECOMMERCE.dbo.address a
WHERE a.state IN ('CDMX', 'Hidalgo');

INSERT INTO zona1DB.dbo.customer
SELECT c.* FROM ECOMMERCE.dbo.customer c
WHERE EXISTS ( SELECT 1 FROM ECOMMERCE.dbo.customerAddress ca
JOIN zona1DB.dbo.address a ON ca.addressID = a.addressID
WHERE ca.customerID = c.customerID);

INSERT INTO zona1DB.dbo.customerAddress
SELECT ca.* FROM ECOMMERCE.dbo.customerAddress ca
JOIN zona1DB.dbo.customer c ON ca.customerID = c.customerID
JOIN zona1DB.dbo.address a ON ca.addressID = a.addressID;

INSERT INTO zona1DB.dbo.customerOrder
SELECT co.* FROM ECOMMERCE.dbo.customerOrder co
WHERE EXISTS ( SELECT 1 FROM zona1DB.dbo.customer c
WHERE c.customerID = co.customerID);
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
