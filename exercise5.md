# Bloque 4. *Consultas SQL tipo examen*
_______________________________

📌 Nivel: Intermedio
📌 Enfoque: JOIN, GROUP BY, HAVING, funciones de agregación 


**Instrucciones**. Utilizar la base de datos *salesbd* para construir las consultas. 
En la siguiente imagen se presenta el modelo relacional de la base de datos.
Es indispensable que primero construyas la base de datos, las tablas e insertes datos de prueba (puedes utilizar la de la práctica 1).

<img width="1287" height="909" alt="Captura de pantalla 2026-01-26 135717" src="https://github.com/user-attachments/assets/5504b22d-f6d2-4330-a6bd-76eada36ff16" />

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
1. 🧠 *RETO 1: Cliente con mayor gasto total*. Obtén el cliente que más dinero ha gastado en pedidos. Muestra su nombre y el total gastado.
   
**Solución** ✅

```` SQL
SELECT TOP 1 c.name, SUM(co.total) AS sum_total FROM customer c
LEFT JOIN customerOrder co ON c.customerID = co.customerID
GROUP BY c.customerID, c.name
ORDER BY sum_total DESC;
````

**Salida** 📌

| name       | total_spent |
| ---------- | ----------- |
| Juan Pérez | 18850       |

   
2. 🧠 *RETO 2: Producto más vendido (en unidades)*. Identifica el producto más vendido considerando la cantidad total de unidades vendidas.

   
**Solución** ✅

```` SQL
SELECT TOP 1 p.name, SUM(op.quantity) AS total_unidades FROM product p
INNER JOIN orderProduct op ON p.productID = op.productID
GROUP BY p.name ORDER BY total_unidades DESC;
````

**Salida** 📌

| name          | total_units_sold |
| ------------- | ---------------- |
| Laptop Lenovo | 1                |

   
3. 🧠 *RETO 3: Total de ventas por ciudad*. Muestra el total de ventas (importe) agrupado por ciudad del cliente.

   
**Solución** ✅

```` SQL
SELECT ad.city, SUM(co.total) AS TOTAL_VENTAS FROM address ad
INNER JOIN customer c ON ad.addressID = c.addressID
INNER JOIN customerOrder co ON c.customerID = co.customerID
GROUP BY ad.city;
````

**Salida** 📌

| city             | total_sales |
| ---------------- | ----------- |
| Ciudad de México | 18850       |
| Guadalajara      | 4700        |
| Monterrey        | 13200       |
| Ciudad de México | 13549       |


4. 🧠 *RETO 4: Clientes con más de una dirección*. Lista los clientes que tienen más de una dirección asociada.

   
**Solución** ✅

```` SQL
SELECT c.name, COUNT(ca.customerID) AS DIRECCIONES FROM customer c
INNER JOIN customerAddress ca ON c.customerID = ca.customerID
GROUP BY c.name HAVING COUNT(ca.customerID) > 1;
````

**Salida** 📌

| name       | total_addresses |
| ---------- | --------------- |
| Juan Pérez | 2               |

   
5. 🧠 *RETO 5: Pedidos con total superior al promedio*. Obtén los pedidos cuyo total sea mayor al promedio de todos los pedidos.

   
**Solución** ✅

```` SQL
SELECT p.name, AVG(co.total) AS promedio_total FROM product p
INNER JOIN orderProduct op ON p.productID = op.productID
INNER JOIN customerOrder co ON op.orderID = co.orderID
WHERE co.total > (SELECT AVG(total) FROM customerOrder)
GROUP BY p.name
````

**Salida** 📌

| orderID | customerID | date       | total | paymentMethod      | status  |
| ------- | ---------- | ---------- | ----- | ------------------ | ------- |
| 1       | 1          | 2025-01-15 | 18850 | Tarjeta de Crédito | Pagado  |
| 2       | 2          | 2025-01-16 | 13549 | Transferencia      | Enviado |
| 5       | 5          | 2025-01-19 | 13200 | Tarjeta Crédito    | Pagado  |


6. 🧠 *RETO 6: Proveedor con más productos vendidos*. Identifica el proveedor cuyos productos se han vendido en mayor cantidad de unidades.

   
**Solución** ✅

````SQL
SELECT TOP 1 s.name, SUM(op.quantity) AS total_unidades FROM supplier s
INNER JOIN product p ON s.supplierID = p.supplierID
INNER JOIN orderProduct op ON p.productID = op.productID
GROUP BY s.name ORDER BY total_unidades DESC
````

**Salida** 📌

| name             | total_units_sold |
| ---------------- | ---------------- |
| Tech Supplies SA | 4                |

   
7. 🧠 *RETO 7: Clientes que nunca cancelaron pedidos*. Lista los clientes que no tienen ningún pedido con estado 'Cancelled'.

   
**Solución** ✅

````SQL
SELECT DISTINCT c.name FROM customer c
WHERE c.customerID NOT IN (SELECT customerID FROM customerOrder WHERE status = 'Cancelado');
````

**Salida** 📌

| name           |
| -------------- |
| Juan Pérez     |
| Carlos Ramírez |
| María Torres   |


8. 🧠 *RETO 8: Ingreso total por método de pago*. Muestra el ingreso total generado por cada método de pago.

   
**Solución** ✅

````SQL
SELECT co.paymentMethod, SUM(co.total) AS total_metodo_pago FROM customerOrder co
GROUP BY co.paymentMethod
````

**Salida** 📌

| paymentMethod      | total_ingreso |
| ------------------ | ------------- |
| Tarjeta de Crédito | 32050         |
| Transferencia      | 13549         |
| Efectivo           | 5350          |
| Tarjeta Débito     | 4700          |


9. 🧠 *RETO 9: Pedidos con más de un producto distinto*. Lista los pedidos que incluyen más de un producto diferente.

   
**Solución** ✅

````SQL
SELECT orderID, COUNT(DISTINCT productID) AS total_productos FROM orderProduct
GROUP BY orderID HAVING COUNT(DISTINCT productID) > 1;
````

**Salida** 📌

| orderID | total_products |
| ------- | -------------- |
| 1       | 2              |
| 2       | 2              |


10. 🧠 *RETO 10: Clientes con pedidos en más de una ciudad*. Encuentra los clientes que hayan realizado pedidos desde direcciones en más de una ciudad.


**Solución** ✅

````sql
SELECT c.name, COUNT(DISTINCT a.city) AS total_ciudades FROM customer c
JOIN customerAddress ca ON c.customerID = ca.customerID
JOIN address a ON ca.addressID = a.addressID
GROUP BY c.customerID, c.name HAVING COUNT(DISTINCT a.city) > 1;
````

**Salida** 📌

| name       | total_cities |
| ---------- | ------------ |
| Juan Pérez | 2            |


📘 ¿Qué se refuerza?
✔ Lectura de esquemas
✔ Lógica de negocio
✔ Subconsultas
✔ Consultas tipo examen universitario / técnico

Dime qué quieres, cómo lo quieres y lo armamos 💪 🚀
