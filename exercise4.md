# Bloque 4. *Consultas SQL nivel intermedio*
<img width="898" height="681" alt="image" src="https://github.com/user-attachments/assets/ecdb31db-b89f-4500-8f69-3b1ab5aa45d9" />

_______________________________

📌 Nivel: Intermedio

📌 Enfoque: JOIN, GROUP BY, HAVING, funciones de agregación 


**Instrucciones**. Utilizar la base de datos *salesbd* para construir las consultas. 
En la siguiente imagen se presenta el modelo relacional de la base de datos.
Es indispensable que primero construyas la base de datos, las tablas e insertes datos de prueba (puedes utilizar la de la práctica 1).

![Modelo relacional salesdb](salesdb.png)

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

![Resultado de consulta 1](tabla1.png)

OPCIÓN 2. Tabla con el resultado de la consulta.

| idTabla | atributo1 | atributo2 | atributo3 | 
| --------- | --------- | --------- | --------- |
| 5671 | Nissan | Versa | 2024 |
| 5672 | Honda| City | 2025 | 
| 5673 | Toyota | Corolla | 2026 |  
| 5674 | Honda | Civic | 2026 | 


Consultas
---------------
1. *Total de pedidos por cliente*. Muestra el nombre del cliente y la cantidad total de pedidos que ha realizado.

   
**Solución** ✅

```SQL
SELECT customer.name AS cliente, COUNT(customerOrder.orderID) AS total_pedidos FROM customer
LEFT JOIN customerOrder ON customer.customerID = customerOrder.customerID
GROUP BY customer.customerID, customer.name;
````

**Salida** 📌

| cliente        | total_pedidos |
| -------------- | ------------- |
| Juan Pérez     | 1             |
| Ana López      | 1             |
| Carlos Ramírez | 1             |
| María Torres   | 1             |
| Luis Hernández | 1             |

   
2. *Total gastado por cliente*. Obtén el nombre del cliente y el importe total gastado en todos sus pedidos.
   
**Solución** ✅

```` SQL
SELECT customer.name AS cliente, SUM(customerOrder.total) AS total_gastado FROM customer
LEFT JOIN customerOrder ON customer.customerID = customerOrder.customerID
GROUP BY customer.customerID, customer.name;
````

**Salida** 📌
|Cliente          |Total_gastado    |
| --------------- | --------------- |
|Juan Pérez       |20000            |
|Ana López        |13549            |
|Carlos Ramírez   |4200             |
|María Torres     |4700             |
|Luis Hernández   |13200            |

   
3. *Productos más caros por proveedor*. Muestra el proveedor y el precio máximo de los productos que suministra.
   
**Solución** ✅

````SQL
SELECT supplier.name AS proveedor, MAX(product.price) AS precio_maximo FROM supplier
LEFT JOIN product ON supplier.supplierID = product.supplierID
GROUP BY supplier.supplierID, supplier.name;
````

**Salida** 📌

| proveedor          | precio_maximo |
| ------------------ | ------------- |
| Tech Supplies SA   | 18501         |
| Global Electronics | 1300          |
| Smart Devices MX   | 1200          |
| Office World       | 4200          |
| Digital Home       | NULL          |

4. *Pedidos con más de 1 productos*. Lista los pedidos cuyo total de unidades compradas sea mayor a 1.
   
**Solución** ✅

 ````SQL
SELECT op.orderID, SUM(op.quantity) AS total_unidades FROM orderProduct op
GROUP BY op.orderID HAVING SUM(op.quantity) > 1;
````

**Salida** 📌

| orderID | total_unidades |
| ------: | -------------: |
|       1 |              2 |
|       2 |              2 |

   
5. *Ventas totales por producto*. Muestra el nombre del producto y el total de unidades vendidas.
   
**Solución** ✅

````SQL
SELECT p.productID, p.name, SUM(op.quantity) AS total_unidades_vendidas FROM product p
INNER JOIN orderProduct op
    ON p.productID = op.productID
GROUP BY p.productID, p.name;
````

**Salida** 📌

| productID | name               | total_unidades_vendidas |
| --------: | ------------------ | ----------------------: |
|         1 | Laptop Lenovo      |                       1 |
|         2 | Mouse Logitech     |                       1 |
|         3 | Smartphone Samsung |                       1 |
|         4 | Teclado Mecánico   |                       1 |
|         5 | Monitor LG 24"     |                       1 |


6. *Clientes que han gastado más de $10,000.00*. Lista los clientes cuyo gasto total sea mayor a 10000.
   
**Solución** ✅

````SQL
SELECT c.name, SUM(co.total) AS gasto_totsl FROM customer c
INNER JOIN customerOrder co ON c.customerID = co.customerID
GROUP BY c.name HAVING SUM(co.total) > 10000;
````

**Salida** 📌

| customerID | name           | gasto_total |
| ---------: | -------------- | ----------: |
|          1 | Juan Pérez     |       18850 |
|          2 | Ana López      |       13549 |
|          5 | Luis Hernández |       13200 |


7. *Promedio de precio por tipo de producto*. Obtén el precio promedio de los productos por cada tipo.
   
**Solución** ✅

````SQL
SELECT type, AVG(price) AS precio_promedio FROM product
GROUP BY type;
````

**Salida** 📌

| type        | precio_promedio |
| ----------- | --------------- |
| Accesorio   | 775.00          |
| Electrónica | 11900.163333    |


8. *Proveedores con más de 5 productos*. Muestra los proveedores que suministran más de 5 productos.

   
**Solución** ✅

````SQL
SELECT s.name, COUNT(p.productID) AS total_productos FROM supplier s
INNER JOIN product p ON s.supplierID = p.supplierID
GROUP BY s.supplierID, s.name HAVING COUNT(p.productID) > 1;
````

**Salida** 📌

| supplierID | name             | total_productos |
| ---------: | ---------------- | --------------: |
|          1 | Tech Supplies SA |               2 |


9. *Pedidos con información del cliente*. Muestra el ID del pedido, la fecha y el nombre del cliente.
   
**Solución** ✅

````SQL
SELECT co.orderID, co.date, c.name FROM customerOrder co
INNER JOIN customer c ON co.customerID = c.customerID;
````

**Salida** 📌

| orderID | date       | name           |
| ------: | ---------- | -------------- |
|       1 | 2025-01-15 | Juan Pérez     |
|       2 | 2025-01-16 | Ana López      |
|       3 | 2025-01-17 | Carlos Ramírez |
|       4 | 2025-01-18 | María Torres   |
|       5 | 2025-01-19 | Luis Hernández |


10. *Clientes sin pedidos*. Lista los clientes que no han realizado ningún pedido.

**Solución** ✅

````SQL
SELECT c.name FROM customer c
LEFT JOIN customerOrder co ON c.customerID = co.customerID
WHERE co.orderID IS NULL;
````

**Salida** 📌

| name |
| ---- |
|      |



📘 Qué se refuerza en nivel intermedio

✔ Agregaciones (SUM, COUNT, AVG, MAX)

✔ Agrupación de datos

✔ Filtros con HAVING

✔ JOIN entre múltiples tablas

✔ Análisis de datos reales

Llegaste al final 🚀




