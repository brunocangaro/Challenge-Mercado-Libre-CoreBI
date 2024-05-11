/*Creación tabla Customer*/

CREATE TABLE MercadoLibre.Customer (
    IdCustomer INT64 NOT NULL, 
    Nombre STRING,
    Apellido STRING,
    Sexo STRING,
    Direccion STRING,
    FechaNacimiento DATE,
    Telefono STRING,
);

/*Creación tabla Category*/

CREATE TABLE MercadoLibre.Category (
    IdCategoria INT64 NOT NULL,
    NombreCategoria STRING,
    Ruta STRING
);

/*Creación tabla Item*/

CREATE TABLE MercadoLibre.Item (
    IdItem INT64 NOT NULL,
    NombreItem STRING,
    IdCategoria INT64 NOT NULL,
    Precio FLOAT64,
    Estado STRING,
    FechaEstado DATE
);

/*Creación tabla Order*/

CREATE TABLE MercadoLibre.Order (
    IdOrden INT64 NOT NULL,
    IdItem INT64 NOT NULL,
    IdCustomer INT64 NOT NULL,
    FechaOrden DATE
);
