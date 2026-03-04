# Actividad de Investigación en Biblioteca  
## Las 12 Reglas de las Bases de Datos Distribuidas  
**Basado en:** C. J. Date – *Introducción a los Sistemas de Bases de Datos*, 7ª edición.

---

## Introducción

Una base de datos distribuida es aquella en la que los datos se almacenan físicamente en múltiples sitios, pero el sistema debe comportarse como si fuera una sola base de datos lógica.  

C. J. Date establece 12 reglas fundamentales que un Sistema de Gestión de Bases de Datos Distribuidas (SGBDD) debe cumplir para considerarse verdaderamente distribuido.

Estas reglas garantizan transparencia, independencia y correcto funcionamiento en entornos distribuidos.

---

# Las 12 Reglas de las Bases de Datos Distribuidas

## 1. Autonomía local
Cada sitio debe operar de manera independiente, manteniendo control sobre sus propios datos y operaciones locales.

---

## 2. No dependencia de un sitio central
No debe existir un nodo central del cual dependa todo el sistema. El sistema debe continuar funcionando aunque un nodo falle.

---

## 3. Operación continua
El sistema debe permitir operaciones continuas incluso cuando se agreguen o eliminen nodos.

---

## 4. Independencia de localización
Los usuarios no deben conocer la ubicación física de los datos. La localización debe ser completamente transparente.

---

## 5. Independencia de fragmentación
Los datos pueden estar divididos en fragmentos, pero el usuario no debe percibir dicha fragmentación.

---

## 6. Independencia de replicación
Si existen copias de los datos en distintos sitios, el usuario no debe notar su existencia.

---

## 7. Procesamiento distribuido de consultas
El sistema debe optimizar y ejecutar consultas que involucren datos almacenados en múltiples nodos.

---

## 8. Manejo distribuido de transacciones
Las transacciones que afecten varios sitios deben cumplir globalmente las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad).

---

## 9. Independencia del hardware
Los distintos nodos pueden utilizar diferentes tipos de hardware sin afectar el sistema distribuido.

---

## 10. Independencia del sistema operativo
Cada nodo puede ejecutar un sistema operativo distinto sin interferir con el funcionamiento global.

---

## 11. Independencia de la red
El sistema debe poder operar sobre diferentes arquitecturas y protocolos de red.

---

## 12. Independencia del DBMS
El sistema debe poder integrarse con distintos sistemas gestores de bases de datos, siempre que sean compatibles con los estándares requeridos.

---

# Conclusión

Las 12 reglas propuestas por C. J. Date establecen los principios esenciales para que una base de datos sea considerada verdaderamente distribuida.  

El objetivo principal es lograr transparencia total para el usuario, garantizando que el sistema funcione como una sola base de datos, aunque físicamente esté distribuida.

---

![WhatsApp Image 2026-03-04 at 17 39 48](https://github.com/user-attachments/assets/7641202c-804f-4a07-ad03-2ffa1e2f7e57)

---

<img width="1200" height="1600" alt="image" src="https://github.com/user-attachments/assets/88024c13-d81f-4e79-a7e1-74291ae374bb" />

---

![WhatsApp Image 2026-03-04 at 17 41 19](https://github.com/user-attachments/assets/54b56f57-2f77-4a06-b9aa-e5c3b51018b9)

---

# Bibliografía

Date, C. J. (2001). *Introducción a los sistemas de bases de datos* (7ª ed.). Pearson Educación.
