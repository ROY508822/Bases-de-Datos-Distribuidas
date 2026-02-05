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

4. *Pedidos con más de 3 productos*. Lista los pedidos cuyo total de unidades compradas sea mayor a 3.
   
**Solución** ✅

 ````SQL
SELECT op.orderID, SUM(op.quantity) AS total_unidades FROM orderProduct op
GROUP BY op.orderID HAVING SUM(op.quantity) > 1;
````

**Salida** 📌

   TODO listado de atributos y tuplas
   
5. *Ventas totales por producto*. Muestra el nombre del producto y el total de unidades vendidas.
   
**Solución** ✅

   TODO script SQL

**Salida** 📌

   TODO listado de atributos y tuplas

6. *Clientes que han gastado más de $1,000.00*. Lista los clientes cuyo gasto total sea mayor a 1000.
   
**Solución** ✅

   TODO script SQL

**Salida** 📌

   TODO listado de atributos y tuplas

7. *Promedio de precio por tipo de producto*. Obtén el precio promedio de los productos por cada tipo.
   
**Solución** ✅

   TODO script SQL

**Salida** 📌

   TODO listado de atributos y tuplas

8. *Proveedores con más de 5 productos*. Muestra los proveedores que suministran más de 5 productos.

   
**Solución** ✅

   TODO script SQL

**Salida** 📌

   TODO listado de atributos y tuplas

9. *Pedidos con información del cliente*. Muestra el ID del pedido, la fecha y el nombre del cliente.
   
**Solución** ✅

   TODO script SQL

**Salida** 📌

   TODO listado de atributos y tuplas

10. *Clientes sin pedidos*. Lista los clientes que no han realizado ningún pedido.

**Solución** ✅

   TODO script SQL

**Salida** 📌

   TODO listado de atributos y tuplas


📘 Qué se refuerza en nivel intermedio

✔ Agregaciones (SUM, COUNT, AVG, MAX)

✔ Agrupación de datos

✔ Filtros con HAVING

✔ JOIN entre múltiples tablas

✔ Análisis de datos reales

Llegaste al final 🚀



