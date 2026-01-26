CREATE DATABASE ECOMMERCE;
USE ECOMMERCE;

CREATE TABLE address(
    addressID int not null PRIMARY KEY,
    street varchar(80) not null,
    locally varchar(80) not null,
    city varchar(80) not null,
    postcode integer not null,
    state varchar(80) not null,
);

CREATE TABLE supplier(
    supplierID int not null PRIMARY KEY,
    name varchar(80) not null,
    phone integer not null,
    email varchar(80) not null,
    addressID int not null,
    FOREIGN KEY (addressID) REFERENCES address(addressID),
);

CREATE TABLE product(
    productID int not null PRIMARY KEY,
    name varchar(80) not null,
    type varchar(80) not null,
    amount integer not null,
    price decimal not null,
    detail varchar(80) not null,
    supplierID int not null,
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID),
);

CREATE TABLE customer(
    customerID int not null PRIMARY KEY,
    name varchar(80) not null,
    phone integer not null,
    email varchar(80) not null,
    addressID int not null,
    FOREIGN KEY (addressID) REFERENCES address(addressID),
);

CREATE TABLE customerAddress(
    customerAddressID int not null PRIMARY KEY,
    customerID int not null,
    addressID int not null,
    FOREIGN KEY (customerID) REFERENCES customer(customerID),
    FOREIGN KEY (addressID) REFERENCES address(addressID),
);

CREATE TABLE customerOrder(
    orderID int not null PRIMARY KEY,
    FOREIGN KEY (customerID) REFERENCES customer(customerID),
    date date not null,
    total integer not null,
    paymentMethod varchar(80) not null,
    status varchar(80) not null,
    customerID int not null,
);

CREATE TABLE orderProduct(
    orderProductID int not null PRIMARY KEY,
    FOREIGN KEY (orderID) REFERENCES customerOrder(orderID),
    FOREIGN KEY (productID) REFERENCES product(productID),
    quantity integer not null,
    price decimal not null,
    orderID int not null,
    productID int not null,   
);

INSERT INTO address (addressID, street, locally, city, postcode, state)
VALUES (1, 'Av. Reforma 100', 'Centro', 'Ciudad de México', 06000, 'CDMX');

INSERT INTO address (addressID, street, locally, city, postcode, state)
VALUES (2, 'Calle Juárez 45', 'Centro', 'Guadalajara', 44100, 'Jalisco');

INSERT INTO address (addressID, street, locally, city, postcode, state)
VALUES (3, 'Av. Universidad 300', 'Copilco', 'Ciudad de México', 04360, 'CDMX');

INSERT INTO address (addressID, street, locally, city, postcode, state)
VALUES (4, 'Calle Hidalgo 90', 'Centro', 'Monterrey', 64000, 'Nuevo León');

INSERT INTO address (addressID, street, locally, city, postcode, state)
VALUES (5, 'Av. Insurgentes 1500', 'Del Valle', 'Ciudad de México', 03100, 'CDMX');


INSERT INTO supplier (supplierID, name, phone, email, addressID)
VALUES (1, 'Tech Supplies SA', 55, 'contacto@techsupplies.com', 1);

INSERT INTO supplier (supplierID, name, phone, email, addressID)
VALUES (2, 'Global Electronics', 35, 'ventas@globalelec.com', 2);

INSERT INTO supplier (supplierID, name, phone, email, addressID)
VALUES (3, 'Smart Devices MX', 81, 'info@smartdevices.mx', 4);

INSERT INTO supplier (supplierID, name, phone, email, addressID)
VALUES (4, 'Office World', 33, 'ventas@officeworld.com', 2);

INSERT INTO supplier (supplierID, name, phone, email, addressID)
VALUES (5, 'Digital Home', 55, 'contacto@digitalhome.mx', 5);


INSERT INTO product (productID, name, type, amount, price, detail, supplierID)
VALUES (1, 'Laptop Lenovo', 'Electrónica', 20, 18500.50, 'Laptop 16GB RAM', 1);

INSERT INTO product (productID, name, type, amount, price, detail, supplierID)
VALUES (2, 'Mouse Logitech', 'Accesorio', 100, 350.00, 'Mouse inalámbrico', 1);

INSERT INTO product (productID, name, type, amount, price, detail, supplierID)
VALUES (3, 'Smartphone Samsung', 'Electrónica', 30, 12999.99, 'Galaxy Series', 2);

INSERT INTO product (productID, name, type, amount, price, detail, supplierID)
VALUES (4, 'Teclado Mecánico', 'Accesorio', 50, 1200.00, 'Switch azul', 3);

INSERT INTO product (productID, name, type, amount, price, detail, supplierID)
VALUES (5, 'Monitor LG 24"', 'Electrónica', 40, 4200.00, 'Full HD IPS', 4);


INSERT INTO customer (customerID, name, phone, email, addressID)
VALUES (1, 'Juan Pérez', 55, 'juan.perez@gmail.com', 3);

INSERT INTO customer (customerID, name, phone, email, addressID)
VALUES (2, 'Ana López', 81, 'ana.lopez@gmail.com', 5);

INSERT INTO customer (customerID, name, phone, email, addressID)
VALUES (3, 'Carlos Ramírez', 33, 'carlos.r@gmail.com', 1);

INSERT INTO customer (customerID, name, phone, email, addressID)
VALUES (4, 'María Torres', 55, 'maria.t@gmail.com', 2);

INSERT INTO customer (customerID, name, phone, email, addressID)
VALUES (5, 'Luis Hernández', 81, 'luis.h@gmail.com', 4);


INSERT INTO customerAddress (customerAddressID, customerID, addressID)
VALUES (1, 1, 3);

INSERT INTO customerAddress (customerAddressID, customerID, addressID)
VALUES (2, 2, 5);

INSERT INTO customerAddress (customerAddressID, customerID, addressID)
VALUES (3, 3, 1);

INSERT INTO customerAddress (customerAddressID, customerID, addressID)
VALUES (4, 4, 2);

INSERT INTO customerAddress (customerAddressID, customerID, addressID)
VALUES (5, 5, 4);

INSERT INTO customerOrder (orderID, customerID, date, total, paymentMethod, status)
VALUES (1, 1, '2025-01-15', 18850, 'Tarjeta de Crédito', 'Pagado');

INSERT INTO customerOrder (orderID, customerID, date, total, paymentMethod, status)
VALUES (2, 2, '2025-01-16', 13549, 'Transferencia', 'Enviado');

INSERT INTO customerOrder (orderID, customerID, date, total, paymentMethod, status)
VALUES (3, 3, '2025-01-17', 4200, 'Efectivo', 'Pagado');

INSERT INTO customerOrder (orderID, customerID, date, total, paymentMethod, status)
VALUES (4, 4, '2025-01-18', 4700, 'Tarjeta Débito', 'Pendiente');

INSERT INTO customerOrder (orderID, customerID, date, total, paymentMethod, status)
VALUES (5, 5, '2025-01-19', 13200, 'Tarjeta Crédito', 'Pagado');


INSERT INTO orderProduct (orderProductID, orderID, productID, quantity, price)
VALUES (1, 1, 1, 1, 18500.50);

INSERT INTO orderProduct (orderProductID, orderID, productID, quantity, price)
VALUES (2, 1, 2, 1, 350.00);

INSERT INTO orderProduct (orderProductID, orderID, productID, quantity, price)
VALUES (3, 2, 3, 1, 12999.99);

INSERT INTO orderProduct (orderProductID, orderID, productID, quantity, price)
VALUES (4, 2, 4, 1, 1200.00);

INSERT INTO orderProduct (orderProductID, orderID, productID, quantity, price)
VALUES (5, 3, 5, 1, 4200.00);
