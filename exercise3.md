# Bloque 3. *Consultas SQL nivel básico*
_______________________________

**Instrucciones**. Utilizar la base de datos *salesbd* para construir las consultas. 
En la siguiente imagen se presenta el modelo relacional de la base de datos.
Es indispensable que primero construyas la base de datos, las tablas e insertes datos de prueba.

<img width="898" height="681" alt="salesdb" src="https://github.com/user-attachments/assets/c9aa77cf-561f-4b83-a672-2f339e73ddbf" />


Nota. Sigue el ejemplo para preparar tu entregable.

Ejemplo
---------------
0. Listado de todos las tuplas de la tabla mi_tabla con la condicion_1.
   
**Solución** ✅
```sql
   SELECT *
     FROM mi_tablas
    WHERE condicion_1
```

**Salida** 📌

OPCIÓN 1. Imagen con el resultado de la consulta. 

OPCIÓN 2. Tabla con el resultado de la consulta.

| idTabla | atributo1 | atributo2 | atributo3 | 
| --------- | --------- | --------- | --------- |
| 5671 | Nissan | Versa | 2024 |
| 5672 | Honda| City | 2025 | 
| 5673 | Toyota | Corolla | 2026 |  
| 5674 | Honda | Civic | 2026 | 


Consultas
---------------
1. Listar todos los clientes: *Obtén el customerID, nombre y email de todos los clientes*.
   
**Solución** ✅

````sql
SELECT customerID, name, email
FROM customer;
````

**Salida** 📌

| customerID | name           | email                                               |
| ---------: | -------------- | --------------------------------------------------- |
|          1 | Juan Pérez     | [juan.perez@gmail.com](mailto:juan.perez@gmail.com) |
|          2 | Ana López      | [ana.lopez@gmail.com](mailto:ana.lopez@gmail.com)   |
|          3 | Carlos Ramírez | [carlos.r@gmail.com](mailto:carlos.r@gmail.com)     |
|          4 | María Torres   | [maria.t@gmail.com](mailto:maria.t@gmail.com)       |
|          5 | Luis Hernández | [luis.h@gmail.com](mailto:luis.h@gmail.com)         |

   
2. Direcciones en una ciudad específica: *Muestra todas las direcciones que estén en la ciudad de Ciudd de Mexico*.
   
**Solución** ✅

````sql
SELECT *
FROM address
WHERE city = 'Ciudad de México';
````

**Salida** 📌

| addressID | street               | locally   | city             | postcode | state |
| --------: | -------------------- | --------- | ---------------- | -------: | ----- |
|         1 | Av. Reforma 100      | Centro    | Ciudad de México |    06000 | CDMX  |
|         3 | Av. Universidad 300  | Copilco   | Ciudad de México |    04360 | CDMX  |
|         5 | Av. Insurgentes 1500 | Del Valle | Ciudad de México |    03100 | CDMX  |

   
3. Productos con precio mayor a 200: *Lista los productos cuyo precio sea mayor a 200*.
   
**Solución** ✅

 ````sql
SELECT productID, name, price
FROM product
WHERE price > 200;
````

**Salida** 📌

| productID | name               | price    |
| --------: | ------------------ | -------- |
|         1 | Laptop Lenovo      | 18500.50 |
|         2 | Mouse Logitech     | 350.00   |
|         3 | Smartphone Samsung | 12999.99 |
|         4 | Teclado Mecánico   | 1200.00  |
|         5 | Monitor LG 24"     | 4200.00  |


4. Pedidos ordenados por fecha: *Muestra todos los pedidos ordenados desde el más reciente al más antiguo*.
   
**Solución** ✅

````sql
SELECT orderID, customerID, date, total
FROM customerOrder
ORDER BY date DESC;
````

**Salida** 📌

| orderID | customerID | date       | total |
| ------: | ---------: | ---------- | ----: |
|       5 |          5 | 2025-01-19 | 13200 |
|       4 |          4 | 2025-01-18 |  4700 |
|       3 |          3 | 2025-01-17 |  4200 |
|       2 |          2 | 2025-01-16 | 13549 |
|       1 |          1 | 2025-01-15 | 18850 |
   
5. Primeros 5 proveedores: *Obtén los primeros 5 proveedores ordenados alfabéticamente por nombre*.
   
**Solución** ✅

````sql
SELECT TOP 5 supplierID, name
FROM supplier
ORDER BY name ASC;
````

**Salida** 📌

| supplierID | name               |
| ---------: | ------------------ |
|          5 | Digital Home       |
|          2 | Global Electronics |
|          4 | Office World       |
|          3 | Smart Devices MX   |
|          1 | Tech Supplies SA   |

6. Clientes y su ciudad: *Muestra el nombre del cliente y la ciudad donde vive*.
   
**Solución** ✅

````sql
SELECT customer.name AS cliente, address.city AS ciudad
FROM customer
JOIN address ON customer.addressID = address.addressID;
````

**Salida** 📌

| cliente        | ciudad           |
| -------------- | ---------------- |
| Juan Pérez     | Ciudad de México |
| Ana López      | Ciudad de México |
| Carlos Ramírez | Ciudad de México |
| María Torres   | Guadalajara      |
| Luis Hernández | Monterrey        |

7. Productos y su proveedor: *Lista el nombre del producto y el nombre de su proveedor*.
   
**Solución** ✅

````sql
SELECT product.name AS producto, supplier.name AS proveedor
FROM product
JOIN supplier ON product.supplierID = supplier.supplierID;
````

**Salida** 📌

| producto           | proveedor          |
| ------------------ | ------------------ |
| Laptop Lenovo      | Tech Supplies SA   |
| Mouse Logitech     | Tech Supplies SA   |
| Smartphone Samsung | Global Electronics |
| Teclado Mecánico   | Smart Devices MX   |
| Monitor LG 24"     | Office World       |


8. Pedidos de un cliente específico: *Muestra todos los pedidos realizados por el cliente con customerID = 1*.
   
**Solución** ✅

````sql
SELECT orderID, date, total, status
FROM customerOrder
WHERE customerID = 1;
````

**Salida** 📌

| orderID | date       | total | status |
| ------: | ---------- | ----: | ------ |
|       1 | 2025-01-15 | 18850 | Pagado |

9. Cantidad de productos en cada pedido: *Muestra el ID del pedido y la cantidad de productos comprados en cada uno*.
   
**Solución** ✅

````sql
SELECT orderID, SUM(quantity) AS totalProductos
FROM orderProduct
GROUP BY orderID;
````

**Salida** 📌

| orderID | totalProductos |
| ------: | -------------: |
|       1 |              2 |
|       2 |              2 |

10. Clientes con dirección de envío: *Lista los clientes que tienen una dirección de tipo Shipping*.
   
**Solución** ✅

````sql
SELECT DISTINCT customer.customerID, customer.name, customerAddress.type
FROM customer
INNER JOIN customerAddress ON customer.customerID = customerAddress.customerID WHERE customerAddress.[type] = 'Shipping';
````

**Salida** 📌

| customerID | name       | type     |
| ---------: | ---------- | -------- |
|          1 | Customer 1 | Shipping |
|          2 | Customer 2 | Shipping |
|          3 | Customer 3 | Shipping |
|          4 | Customer 4 | Shipping |
|          5 | Customer 5 | Shipping |

¿Qué practicas?
---------------
- SELECT básico
- Filtros WHRE
- Ordenamiento con ORDER BY
- Limitación de resultados son LIMIT
- JOIN simples
- Uso de claves foráneas (FK)

Llegamos al final 👌
