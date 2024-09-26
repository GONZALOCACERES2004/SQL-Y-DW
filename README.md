Cada archivo está precedido del punto correspondiente en la práctica:

1 (Diagrama ER).

2 (Creación, Ingreso datos y Consultas   PostgreSQL).

3 (Creacion tabla ivr_detai   BigQuery).

4 al 11 (Consultas    BigQuery).

12( Creación tabla ivr_summary  utilizando consultas    BigQuery).

13 (Creación función  BigQuery).

14  Adicional (Creación tabla ivr_summary  utilizando tablas intermedias    BigQuery).


Utilicé LEFT JOIN en el código para crear la tabla ivr_detail por varias razones:
1.	Preservación de todos los registros de llamadas:
•	El LEFT JOIN asegura que todos los registros de la tabla se incluirán en el resultado final, incluso si no tienen módulos o pasos correspondientes en las otras tablas.
•	Esto es crucial para mantener un registro completo de todas las llamadas IVR, incluso aquellas que no pudieron haber progresado a través de módulos o pasos específicos.
2.	Manejo de datos incompletos:
•	En sistemas IVR, es posible que algunas llamadas no lleguen a ciertos módulos o pasos.
•	El LEFT JOIN permite incluir estas llamadas en el análisis, proporcionando una visión más completa del flujo de llamadas.
3.	Evitar pérdida de datos:
•	Si usáramos un INNER JOIN, perderíamos información sobre llamadas que no tienen correspondencia en las tablas de módulos o pasos, lo que podría sesgar los análisis posteriores.

En resumen, el uso de LEFT JOIN en este contexto proporciona una vista más completa y precisa de los datos de las llamadas IVR, permitiendo un análisis más robusto y evitando la pérdida de información importante.
Esto es especialmente valioso en el análisis de sistemas IVR, donde es crucial entender todos los aspectos del flujo de llamadas, incluidas las que no completan todos los pasos del proceso.
