

/*Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas
realizadas en enero 2020 sea superior a 1500.*/

SELECT a.IdCustomer, a.Nombre, a.Apellido
FROM MercadoLibre.Customer a
JOIN MercadoLibre.Order b ON a.IdCustomer = b.IdCustomer
WHERE DATE_DIFF(CURRENT_DATE(), a.FechaNacimiento, DAY) = 0
AND DATE_DIFF(b.FechaOrden, DATE '2020-01-01', MONTH) = 0
GROUP BY a.IdCustomer, a.Nombre, a.Apellido
HAVING COUNT(b.IdOrden) > 1500;

/*Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la
categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del
vendedor, cantidad de ventas realizadas, cantidad de productos vendidos y el monto
total transaccionado.*/

CREATE TABLE MercadoLibre.VentasPorMes AS --Tambien se puede crear una tabla temporal  CREATE TEMPORARY TABLE para no ocupar espacio de memoria
  (SELECT
    EXTRACT(YEAR FROM FechaOrden) AS Anio,
    EXTRACT(MONTH FROM FechaOrden) AS Mes,
    b.IdCustomer,
    b.Nombre,
    b.Apellido,
    COUNT(DISTINCT a.IdOrden) AS NumeroDeOrdenes,
    COUNT(DISTINCT a.IdItem) AS NumeroDeProductos,
    SUM(c.precio) AS PrecioTotal
  FROM
    MercadoLibre.Order a
  JOIN
    MercadoLibre.Customer b ON a.IdCustomer = b.IdCustomer
  JOIN
    MercadoLibre.Item c ON a.IdItem = c.IdItem
  JOIN
    MercadoLibre.Category d ON c.IdCategoria = d.IdCategoria
  WHERE
    EXTRACT(YEAR FROM FechaOrden) = 2020
    AND EXTRACT(MONTH FROM FechaOrden) BETWEEN 1 AND 12
    AND d.NombreCategoria = 'Celulares'
  GROUP BY
    Anio, Mes, b.IdCustomer, b.Nombre, b.Apellido
  );

SELECT
  Anio,
  Mes,
  Nombre,
  Apellido,
  NumeroDeOrdenes,
  NumeroDeProductos,
  PrecioTotal
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY Anio, Mes ORDER BY PrecioTotal DESC) AS RowNum
  FROM
    MercadoLibre.VentasPorMes
)
WHERE
  RowNum <= 5
ORDER BY
  Anio, Mes, PrecioTotal DESC;


/*Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día.
Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item,
vamos a tener únicamente el último estado informado por la PK definida. (Se puede
resolver a través de StoredProcedure) */



CREATE TABLE MercadoLibre.EstadoItem
(
 	IdItem INT64 NOT NULL, 
	NombreItem STRING,
  IdCategoria INT64 NOT NULL,
	Precio FLOAT64, 
	Estado STRING,
);


INSERT INTO MercadoLibre.EstadoItem (IdItem, NombreItem, IdCategoria, Precio, Estado)
SELECT
  IdItem,
  NombreItem,
  IdCategoria,
  Precio,
  Estado
FROM (
  SELECT
    IdItem,
    NombreItem,
    IdCategoria,
    Precio,
    Estado,
    ROW_NUMBER() OVER (PARTITION BY IdItem ORDER BY FechaEstado DESC) AS RowNum
  FROM
    MercadoLibre.Item
)
WHERE
  RowNum = 1;


