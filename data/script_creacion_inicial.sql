USE GD2C2015;

IF NOT EXISTS (
    SELECT schema_name 
    FROM information_schema.schemata 
    WHERE schema_name = 'LAS_PELOTAS' 
    )

BEGIN
    EXEC sp_executesql N'CREATE SCHEMA LAS_PELOTAS;';
END

IF OBJECT_ID('LAS_PELOTAS.butacas_por_vuelo') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.butacas_por_vuelo;
END;

IF OBJECT_ID('LAS_PELOTAS.roles_por_usuario') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.roles_por_usuario;
END;

IF OBJECT_ID('LAS_PELOTAS.canjes') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.canjes;
END;

IF OBJECT_ID('LAS_PELOTAS.productos') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.productos;
END;

IF OBJECT_ID('LAS_PELOTAS.aeronaves_por_periodos') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.aeronaves_por_periodos;
END;

IF OBJECT_ID('LAS_PELOTAS.periodos_de_inactividad') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.periodos_de_inactividad;
END;

IF OBJECT_ID('LAS_PELOTAS.funcionalidades_por_rol') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.funcionalidades_por_rol;
END;

IF OBJECT_ID('LAS_PELOTAS.funcionalidades') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.funcionalidades;
END;

IF OBJECT_ID('LAS_PELOTAS.usuarios') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.usuarios;
END;

IF OBJECT_ID('LAS_PELOTAS.tarjetas_de_credito') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.tarjetas_de_credito;
END;

IF OBJECT_ID('LAS_PELOTAS.tipos_tarjeta') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.tipos_tarjeta;
END;

IF OBJECT_ID('LAS_PELOTAS.paquetes') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.paquetes;
END;

IF OBJECT_ID('LAS_PELOTAS.pasajes') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.pasajes;
END;

IF OBJECT_ID('LAS_PELOTAS.cancelaciones') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.cancelaciones;
END;

IF OBJECT_ID('LAS_PELOTAS.boletos_de_compra') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.boletos_de_compra;
END;

IF OBJECT_ID('LAS_PELOTAS.vuelos') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.vuelos;
END;

IF OBJECT_ID('LAS_PELOTAS.rutas') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.rutas;
END;

IF OBJECT_ID('LAS_PELOTAS.aeropuertos') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.aeropuertos;
END;

IF OBJECT_ID('LAS_PELOTAS.ciudades') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.ciudades;
END;

IF OBJECT_ID('LAS_PELOTAS.butacas') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.butacas;
END;

IF OBJECT_ID('LAS_PELOTAS.aeronaves') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.aeronaves;
END;

IF OBJECT_ID('LAS_PELOTAS.tipos_de_servicio') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.tipos_de_servicio;
END;

IF OBJECT_ID('LAS_PELOTAS.fabricantes') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.fabricantes;
END;

IF OBJECT_ID('LAS_PELOTAS.clientes') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.clientes;
END;

IF OBJECT_ID('LAS_PELOTAS.roles') IS NOT NULL
BEGIN
    DROP TABLE LAS_PELOTAS.roles;
END;

CREATE TABLE LAS_PELOTAS.aeronaves (
    ID  INT   IDENTITY(1,1)    PRIMARY KEY,
    MATRICULA        NVARCHAR(255)    UNIQUE NOT NULL,
    MODELO        NVARCHAR(255) DEFAULT 'MODELO',
    KG_DISPONIBLES    NUMERIC(18,0)    NOT NULL,
    FABRICANTE_ID    INT            NOT NULL,
    TIPO_SERVICIO_ID    INT            NOT NULL,
    BAJA            NVARCHAR(255),
    FECHA_ALTA      DATETIME        NOT NULL,
    CANT_BUTACAS    INT            NOT NULL,
    FECHA_BAJA    DATETIME,
    CONSTRAINT aeronaves_CK001 CHECK (BAJA IN ('DEFINITIVA', 'POR_PERIODO'))
)

CREATE TABLE LAS_PELOTAS.fabricantes (
    ID  INT  IDENTITY(1,1)    PRIMARY KEY,
    NOMBRE        NVARCHAR(255)    NOT NULL
)

CREATE TABLE LAS_PELOTAS.tipos_de_servicio (
    ID INT   IDENTITY(1,1)    PRIMARY KEY,
    NOMBRE        NVARCHAR(255)    NOT NULL,
	PORCENTAJE NUMERIC(3,2) 
)

CREATE TABLE LAS_PELOTAS.butacas (
    ID  INT     IDENTITY(1,1)    PRIMARY KEY,
    NUMERO        NUMERIC(18,0)    NOT NULL,
    TIPO            NVARCHAR(255),
    PISO            NUMERIC(18,0),
    AERONAVE_ID    INT            NOT NULL,
    CONSTRAINT butacas_CK001 CHECK (TIPO IN ('VENTANILLA', 'PASILLO')),
	CONSTRAINT butacas_CK002 CHECK (PISO IN (1,2))
)

CREATE TABLE LAS_PELOTAS.butacas_por_vuelo (
VUELO_ID INT NOT NULL,
BUTACA_ID INT NOT NULL,
ESTADO        NVARCHAR(255) DEFAULT 'LIBRE',
CONSTRAINT butacas_por_vuelo_CK001 CHECK (ESTADO IN ('LIBRE', 'COMPRADO')),
PRIMARY KEY(VUELO_ID,BUTACA_ID)
)

CREATE TABLE LAS_PELOTAS.pasajes (
    ID    INT    IDENTITY(1,1)    PRIMARY KEY,
    PRECIO        NUMERIC(18,2)		NOT NULL,
    CODIGO        NUMERIC(18,0)     UNIQUE NOT NULL,
    BUTACA_ID        INT            NOT NULL,
    CLIENTE_ID        INT            NOT NULL,
    BOLETO_COMPRA_ID INT             NOT NULL,
	INVALIDO INT DEFAULT 0,
    CANCELACION_ID INT DEFAULT NULL
)

CREATE TABLE LAS_PELOTAS.clientes (
    ID   INT     IDENTITY(1,1)    PRIMARY KEY,
    ROL_ID        INT            NOT NULL,
    NOMBRE        NVARCHAR(255)    NOT NULL,
    APELLIDO        NVARCHAR(255),
    DNI            NUMERIC(18,0) NOT NULL,
    DIRECCION        NVARCHAR(255),
    TELEFONO        NUMERIC(18,0),
    MAIL            NVARCHAR(255),
    FECHA_NACIMIENTO DATETIME,
	BAJA			INT DEFAULT 0
)

CREATE TABLE LAS_PELOTAS.boletos_de_compra (
    ID INT IDENTITY(100000,1)    PRIMARY KEY,
    FECHA_COMPRA    DATETIME          NOT NULL,
    PRECIO_COMPRA    NUMERIC(18,2)	NOT NULL,
    TIPO_COMPRA    NVARCHAR(255),
    CLIENTE_ID        INT            NOT NULL,
	MILLAS 			  INT,
	VUELO_ID         INT		NOT NULL,
	INVALIDO INT DEFAULT 0,
    CONSTRAINT boletos_de_compra_CK001 CHECK (TIPO_COMPRA IN ('EFECTIVO', 'TARJETA'))
)

CREATE TABLE LAS_PELOTAS.roles (
    ID    INT    IDENTITY(1,1)    PRIMARY KEY,
	NOMBRE 	NVARCHAR(255)		NOT NULL,
	ACTIVO	INT DEFAULT 1,
	CONSTRAINT roles_CK001 CHECK (ACTIVO IN (0,1))
)

CREATE TABLE LAS_PELOTAS.funcionalidades (
    ID INT IDENTITY(1,1)    PRIMARY KEY,
    DETALLES        NVARCHAR(255) NOT NULL
)

CREATE TABLE LAS_PELOTAS.funcionalidades_por_rol (
	ROL_ID    INT,
	FUNCIONALIDAD_ID INT, 
	PRIMARY KEY(ROL_ID,FUNCIONALIDAD_ID)
)

CREATE TABLE LAS_PELOTAS.usuarios (
    ID INT IDENTITY(1,1)    PRIMARY KEY,
    USERNAME        NVARCHAR(255)    UNIQUE NOT NULL,
    PASSWORD        NVARCHAR(255)		NOT NULL,
	FECHA_CREACION DATETIME				NOT NULL,
	ULTIMA_MODIFICACION DATETIME		NOT NULL,
	INTENTOS_LOGIN INT NOT NULL DEFAULT 0,
	ACTIVO INT,
	CONSTRAINT usuarios_CK001 CHECK (ACTIVO IN (0,1))
)

CREATE TABLE LAS_PELOTAS.roles_por_usuario (
	ROL_ID    INT,
	USUARIO_ID INT, 
	PRIMARY KEY(ROL_ID,USUARIO_ID)
)

CREATE TABLE LAS_PELOTAS.productos (
    ID  INT  IDENTITY(1,1)    PRIMARY KEY,
    NOMBRE        NVARCHAR(255)    UNIQUE,
    MILLAS_REQUERIDAS INT  NOT NULL,
    STOCK        INT      NOT NULL    
)

CREATE TABLE LAS_PELOTAS.periodos_de_inactividad (
    ID    INT     IDENTITY(1,1)    PRIMARY KEY,
    DESDE        DATETIME			NOT NULL,
    HASTA        DATETIME			NOT NULL
)

CREATE TABLE LAS_PELOTAS.aeronaves_por_periodos (
    AERONAVE_ID INT,
    PERIODO_ID  INT,
    PRIMARY KEY(AERONAVE_ID,PERIODO_ID)
)

CREATE TABLE LAS_PELOTAS.aeropuertos (
    ID  INT    IDENTITY(1,1)    PRIMARY KEY,
    NOMBRE        NVARCHAR(255)     NOT NULL,
    CIUDAD_ID        INT             NOT NULL,
	BAJA			 INT			DEFAULT 0
)

CREATE TABLE LAS_PELOTAS.vuelos (
    ID     INT    IDENTITY(1,1)     PRIMARY KEY,
    FECHA_SALIDA     DATETIME		NOT NULL,
    FECHA_LLEGADA     DATETIME,
    FECHA_LLEGADA_ESTIMADA DATETIME NOT NULL,
    AERONAVE_ID     INT            NOT NULL,
    RUTA_ID         INT            NOT NULL,
	INVALIDO		INT			DEFAULT 0
)

CREATE TABLE LAS_PELOTAS.rutas (
    ID     INT     IDENTITY(1,1)     PRIMARY KEY,
    CODIGO         NUMERIC(18,0)    NOT NULL,
    PRECIO_BASE_KG     NUMERIC(18,2)  NOT NULL,
    PRECIO_BASE_PASAJE NUMERIC(18,2) NOT NULL,
    ORIGEN_ID        INT            NOT NULL,
    DESTINO_ID        INT            NOT NULL,
	TIPO_SERVICIO_ID	INT	NOT NULL,
	BAJA			INT DEFAULT 0
)

CREATE TABLE LAS_PELOTAS.ciudades (
    ID     INT     IDENTITY(1,1)     PRIMARY KEY,
    NOMBRE         NVARCHAR(255)    NOT NULL,
	BAJA		   INT				DEFAULT 0
)

CREATE TABLE LAS_PELOTAS.paquetes(
    ID   INT  IDENTITY(1,1)     PRIMARY KEY,
    CODIGO         NUMERIC(18,0)    UNIQUE NOT NULL,
    PRECIO         NUMERIC(18,2)	NOT NULL,
    KG             NUMERIC(18,2)	NOT NULL,
    BOLETO_COMPRA_ID     INT		NOT NULL,
	INVALIDO INT DEFAULT 0,
    CANCELACION_ID INT DEFAULT NULL
)

CREATE TABLE LAS_PELOTAS.canjes (
    ID     INT    IDENTITY(1,1)     PRIMARY KEY,
    CLIENTE_ID         INT             NOT NULL,
    PRODUCTO_ID     INT             NOT NULL,
    CANTIDAD         INT			DEFAULT 1,
    FECHA_CANJE         DATETIME	NOT NULL
)

CREATE TABLE LAS_PELOTAS.tarjetas_de_credito (
    ID   INT   IDENTITY(1,1)     PRIMARY KEY,
    TIPO_TARJETA_ID    INT NOT NULL,
    NUMERO         NUMERIC(18,0)    UNIQUE NOT NULL,
    FECHA_VTO         DATETIME        NOT NULL,
    CLIENTE_ID         INT            NOT NULL
)

CREATE TABLE LAS_PELOTAS.tipos_tarjeta (
    ID   INT   IDENTITY(1,1)     PRIMARY KEY,
    NOMBRE    NVARCHAR(255) NOT NULL,
	CUOTAS INT DEFAULT 0   
)

CREATE TABLE LAS_PELOTAS.cancelaciones (
    ID   INT   IDENTITY(1,1)     PRIMARY KEY,
    FECHA_DEVOLUCION DATETIME		NOT NULL,
    BOLETO_COMPRA_ID INT            NOT NULL,
    MOTIVO         NVARCHAR(255)   NOT NULL
)

-- CONSTRAINT

ALTER TABLE LAS_PELOTAS.tarjetas_de_credito
ADD CONSTRAINT TARJETAS_FK01 FOREIGN KEY
(TIPO_TARJETA_ID) REFERENCES LAS_PELOTAS.tipos_tarjeta (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'TARJ_TIPO_TARJ' AND object_id = OBJECT_ID('LAS_PELOTAS.tarjetas_de_credito'))
    BEGIN
       CREATE INDEX TARJ_TIPO_TARJ ON LAS_PELOTAS.tarjetas_de_credito (TIPO_TARJETA_ID);
    END

ALTER TABLE LAS_PELOTAS.tarjetas_de_credito
ADD CONSTRAINT TARJETAS_FK02 FOREIGN KEY
(CLIENTE_ID) REFERENCES LAS_PELOTAS.clientes (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_TARJ_CLIE' AND object_id = OBJECT_ID('LAS_PELOTAS.tarjetas_de_credito'))
    BEGIN
       CREATE INDEX FKI_TARJ_CLIE ON LAS_PELOTAS.tarjetas_de_credito (CLIENTE_ID);
    END

ALTER TABLE LAS_PELOTAS.aeronaves
ADD CONSTRAINT AERONAVES_FK01 FOREIGN KEY
(FABRICANTE_ID) REFERENCES LAS_PELOTAS.fabricantes (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'AERO_FABRIC' AND object_id = OBJECT_ID('LAS_PELOTAS.aeronaves'))
    BEGIN
       CREATE INDEX AERO_FABRIC ON LAS_PELOTAS.aeronaves (FABRICANTE_ID);
    END

ALTER TABLE LAS_PELOTAS.aeronaves
ADD CONSTRAINT AERONAVES_FK02 FOREIGN KEY
(TIPO_SERVICIO_ID) REFERENCES LAS_PELOTAS.tipos_de_servicio (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'AERO_TIPO_SERV' AND object_id = OBJECT_ID('LAS_PELOTAS.aeronaves'))
    BEGIN
       CREATE INDEX AERO_TIPO_SERV ON LAS_PELOTAS.aeronaves (TIPO_SERVICIO_ID);
    END

ALTER TABLE LAS_PELOTAS.butacas
ADD CONSTRAINT BUTACAS_FK01 FOREIGN KEY
(AERONAVE_ID) REFERENCES LAS_PELOTAS.aeronaves (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'BUTAC_AERO' AND object_id = OBJECT_ID('LAS_PELOTAS.butacas'))
    BEGIN
       CREATE INDEX BUTAC_AERO ON LAS_PELOTAS.butacas (AERONAVE_ID);
    END

ALTER TABLE LAS_PELOTAS.butacas_por_vuelo
ADD CONSTRAINT butacas_por_vu_FK01 FOREIGN KEY
(VUELO_ID) REFERENCES LAS_PELOTAS.vuelos (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'BUTAC_VUELO_VUELO' AND object_id = OBJECT_ID('LAS_PELOTAS.butacas_por_vuelo'))
    BEGIN
       CREATE INDEX BUTAC_VUELO_VUELO ON LAS_PELOTAS.butacas_por_vuelo (VUELO_ID);
    END

ALTER TABLE LAS_PELOTAS.butacas_por_vuelo
ADD CONSTRAINT butacas_por_aeronave_FK02 FOREIGN KEY
(BUTACA_ID) REFERENCES LAS_PELOTAS.butacas (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'BUTAC_VUELO_BUTACA' AND object_id = OBJECT_ID('LAS_PELOTAS.butacas_por_vuelo'))
    BEGIN
       CREATE INDEX BUTAC_VUELO_BUTACA ON LAS_PELOTAS.butacas_por_vuelo (BUTACA_ID);
    END

ALTER TABLE LAS_PELOTAS.pasajes
ADD CONSTRAINT PASAJES_FK01 FOREIGN KEY
(BUTACA_ID) REFERENCES LAS_PELOTAS.butacas (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'PASAJ_BUTAC' AND object_id = OBJECT_ID('LAS_PELOTAS.pasajes'))
    BEGIN
       CREATE INDEX PASAJ_BUTAC ON LAS_PELOTAS.pasajes (BUTACA_ID);
    END

ALTER TABLE LAS_PELOTAS.pasajes
ADD CONSTRAINT PASAJES_FK02 FOREIGN KEY
(CLIENTE_ID) REFERENCES LAS_PELOTAS.clientes (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'PASAJ_CLIENT' AND object_id = OBJECT_ID('LAS_PELOTAS.pasajes'))
    BEGIN
       CREATE INDEX PASAJ_CLIENT ON LAS_PELOTAS.pasajes (CLIENTE_ID);
    END

ALTER TABLE LAS_PELOTAS.pasajes
ADD CONSTRAINT PASAJES_FK03 FOREIGN KEY
(BOLETO_COMPRA_ID) REFERENCES LAS_PELOTAS.boletos_de_compra (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'PASAJ_BOL_COMP' AND object_id = OBJECT_ID('LAS_PELOTAS.pasajes'))
    BEGIN
       CREATE INDEX PASAJ_BOL_COMP ON LAS_PELOTAS.pasajes (BOLETO_COMPRA_ID);
    END

ALTER TABLE LAS_PELOTAS.pasajes
ADD CONSTRAINT PASAJES_FK04 FOREIGN KEY
(CANCELACION_ID) REFERENCES LAS_PELOTAS.cancelaciones (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'PASAJ_CANC' AND object_id = OBJECT_ID('LAS_PELOTAS.pasajes'))
    BEGIN
       CREATE INDEX PASAJ_CANC ON LAS_PELOTAS.pasajes (CANCELACION_ID);
    END

ALTER TABLE LAS_PELOTAS.clientes
ADD CONSTRAINT CLIENTES_FK01 FOREIGN KEY
(ROL_ID) REFERENCES LAS_PELOTAS.roles (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'CLIENT_ROLES' AND object_id = OBJECT_ID('LAS_PELOTAS.clientes'))
    BEGIN
       CREATE INDEX CLIENT_ROLES ON LAS_PELOTAS.clientes (ROL_ID);
    END

ALTER TABLE LAS_PELOTAS.boletos_de_compra
ADD CONSTRAINT BOLETOS_DE_COMPRA_FK01 FOREIGN KEY
(CLIENTE_ID) REFERENCES LAS_PELOTAS.clientes (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_BOL_COMP_CLIENT' AND object_id = OBJECT_ID('LAS_PELOTAS.boletos_de_compra'))
    BEGIN
       CREATE INDEX FKI_BOL_COMP_CLIENT ON LAS_PELOTAS.boletos_de_compra (CLIENTE_ID);
    END

ALTER TABLE LAS_PELOTAS.boletos_de_compra
ADD CONSTRAINT boletos_FK02 FOREIGN KEY
(VUELO_ID) REFERENCES LAS_PELOTAS.vuelos (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_BOLETO_VUEL' AND object_id = OBJECT_ID('LAS_PELOTAS.boletos_de_compra'))
    BEGIN
       CREATE INDEX FKI_BOLETO_VUEL ON LAS_PELOTAS.boletos_de_compra (VUELO_ID);
    END

ALTER TABLE LAS_PELOTAS.funcionalidades_por_rol
ADD CONSTRAINT FUNCIONALIDADES_POR_ROL_FK01 FOREIGN KEY
(ROL_ID) REFERENCES LAS_PELOTAS.roles (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_FUNCXROL_ROL' AND object_id = OBJECT_ID('LAS_PELOTAS.funcionalidades_por_rol'))
    BEGIN
       CREATE INDEX FKI_FUNCXROL_ROL ON LAS_PELOTAS.funcionalidades_por_rol (ROL_ID);
    END

ALTER TABLE LAS_PELOTAS.funcionalidades_por_rol
ADD CONSTRAINT FUNCIONALIDADES_POR_ROL_FK02 FOREIGN KEY
(FUNCIONALIDAD_ID) REFERENCES LAS_PELOTAS.funcionalidades (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_FUNCXROL_FUNC' AND object_id = OBJECT_ID('LAS_PELOTAS.funcionalidades_por_rol'))
    BEGIN
       CREATE INDEX FKI_FUNCXROL_FUNC ON LAS_PELOTAS.funcionalidades_por_rol (FUNCIONALIDAD_ID);
    END

ALTER TABLE LAS_PELOTAS.aeronaves_por_periodos
ADD CONSTRAINT AERONAVES_POR_PERIODOS_FK01 FOREIGN KEY
(AERONAVE_ID) REFERENCES LAS_PELOTAS.aeronaves (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_AEROXPER_AERO' AND object_id = OBJECT_ID('LAS_PELOTAS.aeronaves_por_periodos'))
    BEGIN
       CREATE INDEX FKI_AEROXPER_AERO ON LAS_PELOTAS.aeronaves_por_periodos (AERONAVE_ID);
    END

ALTER TABLE LAS_PELOTAS.aeronaves_por_periodos
ADD CONSTRAINT AERONAVES_POR_PERIODOS_FK02 FOREIGN KEY
(PERIODO_ID) REFERENCES LAS_PELOTAS.periodos_de_inactividad (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_AEROXPER_PERXINAC' AND object_id = OBJECT_ID('LAS_PELOTAS.aeronaves_por_periodos'))
    BEGIN
       CREATE INDEX FKI_AEROXPER_PERXINAC ON LAS_PELOTAS.aeronaves_por_periodos (PERIODO_ID);
    END

ALTER TABLE LAS_PELOTAS.aeropuertos
ADD CONSTRAINT AEROPUERTOS_FK01 FOREIGN KEY
(CIUDAD_ID) REFERENCES LAS_PELOTAS.ciudades (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_AERO_CIUD' AND object_id = OBJECT_ID('LAS_PELOTAS.aeropuertos'))
    BEGIN
       CREATE INDEX FKI_AERO_CIUD ON LAS_PELOTAS.aeropuertos (CIUDAD_ID);
    END

ALTER TABLE LAS_PELOTAS.vuelos
ADD CONSTRAINT VUELOS_FK01 FOREIGN KEY
(AERONAVE_ID) REFERENCES LAS_PELOTAS.aeronaves (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_VUEL_AERO' AND object_id = OBJECT_ID('LAS_PELOTAS.vuelos'))
    BEGIN
       CREATE INDEX FKI_VUEL_AERO ON LAS_PELOTAS.vuelos (AERONAVE_ID);
    END

ALTER TABLE LAS_PELOTAS.vuelos
ADD CONSTRAINT VUELOS_FK02 FOREIGN KEY
(RUTA_ID) REFERENCES LAS_PELOTAS.rutas (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_VUEL_RUT' AND object_id = OBJECT_ID('LAS_PELOTAS.vuelos'))
    BEGIN
       CREATE INDEX FKI_VUEL_RUT ON LAS_PELOTAS.vuelos (RUTA_ID);
    END

ALTER TABLE LAS_PELOTAS.rutas
ADD CONSTRAINT rutas_FK01 FOREIGN KEY
(TIPO_SERVICIO_ID) REFERENCES LAS_PELOTAS.tipos_de_servicio (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_rutas_tipo_servicio' AND object_id = OBJECT_ID('LAS_PELOTAS.rutas'))
    BEGIN
       CREATE INDEX FKI_rutas_tipo_servicio ON LAS_PELOTAS.rutas (TIPO_SERVICIO_ID);
    END

ALTER TABLE LAS_PELOTAS.rutas
ADD CONSTRAINT RUTAS_FK02 FOREIGN KEY
(ORIGEN_ID) REFERENCES LAS_PELOTAS.aeropuertos (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_RUT_AERO' AND object_id = OBJECT_ID('LAS_PELOTAS.rutas'))
    BEGIN
       CREATE INDEX FKI_RUT_AERO ON LAS_PELOTAS.rutas (ORIGEN_ID);
    END

ALTER TABLE LAS_PELOTAS.rutas
ADD CONSTRAINT RUTAS_FK03 FOREIGN KEY
(DESTINO_ID) REFERENCES LAS_PELOTAS.aeropuertos (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_RUT_AERO2' AND object_id = OBJECT_ID('LAS_PELOTAS.rutas'))
    BEGIN
       CREATE INDEX FKI_RUT_AERO2 ON LAS_PELOTAS.rutas (DESTINO_ID);
    END

ALTER TABLE LAS_PELOTAS.paquetes
ADD CONSTRAINT paquetes_FK01 FOREIGN KEY
(BOLETO_COMPRA_ID) REFERENCES LAS_PELOTAS.boletos_de_compra (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_PAQ_BOLDECOMP' AND object_id = OBJECT_ID('LAS_PELOTAS.paquetes'))
    BEGIN
       CREATE INDEX FKI_PAQ_BOLDECOMP ON LAS_PELOTAS.paquetes (BOLETO_COMPRA_ID);
    END

ALTER TABLE LAS_PELOTAS.paquetes
ADD CONSTRAINT paquetes_FK02 FOREIGN KEY
(CANCELACION_ID) REFERENCES LAS_PELOTAS.cancelaciones (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_PAQ_CANC' AND object_id = OBJECT_ID('LAS_PELOTAS.paquetes'))
    BEGIN
       CREATE INDEX FKI_PAQ_CANC ON LAS_PELOTAS.paquetes (CANCELACION_ID);
    END

ALTER TABLE LAS_PELOTAS.canjes
ADD CONSTRAINT CANJES_FK01 FOREIGN KEY
(PRODUCTO_ID) REFERENCES LAS_PELOTAS.productos (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_CANJ_PROD' AND object_id = OBJECT_ID('LAS_PELOTAS.canjes'))
    BEGIN
       CREATE INDEX FKI_CANJ_PROD ON LAS_PELOTAS.canjes (PRODUCTO_ID);
    END

ALTER TABLE LAS_PELOTAS.canjes
ADD CONSTRAINT CANJES_FK02 FOREIGN KEY
(CLIENTE_ID) REFERENCES LAS_PELOTAS.clientes (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_CANJ_CLIE' AND object_id = OBJECT_ID('LAS_PELOTAS.canjes'))
    BEGIN
       CREATE INDEX FKI_CANJ_CLIE ON LAS_PELOTAS.canjes (CLIENTE_ID);
    END

ALTER TABLE LAS_PELOTAS.cancelaciones
ADD CONSTRAINT CANCELACIONES_FK01 FOREIGN KEY
(BOLETO_COMPRA_ID) REFERENCES LAS_PELOTAS.boletos_de_compra (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_CANC_BOLCOMP' AND object_id = OBJECT_ID('LAS_PELOTAS.cancelaciones'))
    BEGIN
       CREATE INDEX FKI_CANC_BOLCOMP ON LAS_PELOTAS.cancelaciones (BOLETO_COMPRA_ID);
    END

ALTER TABLE LAS_PELOTAS.roles_por_usuario
ADD CONSTRAINT ROLES_POR_USUARIO_FK01 FOREIGN KEY
(ROL_ID) REFERENCES LAS_PELOTAS.roles (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_ROL_POR_USUA_ROL' AND object_id = OBJECT_ID('LAS_PELOTAS.roles_por_usuario'))
    BEGIN
       CREATE INDEX FKI_ROL_POR_USUA_ROL ON LAS_PELOTAS.roles_por_usuario (ROL_ID);
    END

ALTER TABLE LAS_PELOTAS.roles_por_usuario
ADD CONSTRAINT ROLES_POR_USUARIO_FK02 FOREIGN KEY
(USUARIO_ID) REFERENCES LAS_PELOTAS.usuarios (ID)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'FKI_ROL_POR_USUA_USUARIO' AND object_id = OBJECT_ID('LAS_PELOTAS.roles_por_usuario'))
    BEGIN
       CREATE INDEX FKI_ROL_POR_USUA_USUARIO ON LAS_PELOTAS.roles_por_usuario (USUARIO_ID);
    END

--SP y FUNCIONES

IF OBJECT_ID('LAS_PELOTAS.corrigeMail') IS NOT NULL
    DROP FUNCTION LAS_PELOTAS.corrigeMail
GO

IF OBJECT_ID('LAS_PELOTAS.cantButacasLibres') IS NOT NULL
BEGIN
    DROP FUNCTION LAS_PELOTAS.cantButacasLibres
END;
GO

IF OBJECT_ID('LAS_PELOTAS.kgLibres') IS NOT NULL
BEGIN
    DROP FUNCTION LAS_PELOTAS.kgLibres
END;
GO

IF OBJECT_ID('LAS_PELOTAS.precioTotal') IS NOT NULL
    DROP FUNCTION LAS_PELOTAS.precioTotal
GO

IF OBJECT_ID('LAS_PELOTAS.addFuncionalidad') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.addFuncionalidad;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.agregarFuncionalidad') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.agregarFuncionalidad;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.cambiarNombreRol') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.cambiarNombreRol;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.quitarFuncionalidad') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.quitarFuncionalidad;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.agregarRol') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.agregarRol;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.vuelosDisponibles') IS NOT NULL
BEGIN
    DROP PROCEDURE LAS_PELOTAS.vuelosDisponibles
END;
GO

IF OBJECT_ID('LAS_PELOTAS.inhabilitarRol') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.inhabilitarRol;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.habilitarRol') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.habilitarRol;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.UpdateIntento') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.UpdateIntento;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.agregarCliente') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.agregarCliente;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.updateCliente') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.updateCliente;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.bajaCliente') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.bajaCliente;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.agregarAeronave') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.agregarAeronave;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.updateAeronave') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.updateAeronave;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.bajaAeronave') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.bajaAeronave;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.agregarRuta') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.agregarRuta;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.updateRuta') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.updateRuta;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.bajaRuta') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.bajaRuta;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.top5DestinosConPasajes') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.top5DestinosConPasajes;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.top5DestinosCancelados') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.top5DestinosCancelados;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.top5DestinosAeronavesVacias') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.top5DestinosAeronavesVacias;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.top5ClientesMillas') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.top5ClientesMillas;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.top5AeronavesFueraDeServicio') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.top5AeronavesFueraDeServicio;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.generarViaje') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.generarViaje;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.registrarLlegada') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.registrarLlegada;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.validarVuelo') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.validarVuelo;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.consultarMillas') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.consultarMillas;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.obtenerClienteConMillas') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.obtenerClienteConMillas;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.altaCanje') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.altaCanje;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.migracionButacasPorVuelo') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.migracionButacasPorVuelo;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.altaTarjeta') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.altaTarjeta;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.bajaCiudad') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.bajaCiudad;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.crearButacas') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.crearButacas;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.cambiarAeronaveDeVuelo') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.cambiarAeronaveDeVuelo;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.bajaVuelo') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.bajaVuelo;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.altaPasaje') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.altaPasaje;
END;
GO
​
IF OBJECT_ID('LAS_PELOTAS.altaPaquete') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.altaPaquete;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.cancelarPasajesDeBc') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.cancelarPasajesDeBc;
END;
GO
​
IF OBJECT_ID('LAS_PELOTAS.altaBoletoDeCompra') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.altaBoletoDeCompra;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.cancelarPasaje') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.cancelarPasaje;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.cancelarPaquete') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.cancelarPaquete;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.asignarRol') IS NOT NULL
BEGIN
	DROP PROCEDURE LAS_PELOTAS.asignarRol;
END;
GO

CREATE FUNCTION LAS_PELOTAS.corrigeMail (@s NVARCHAR (255)) 
RETURNS NVARCHAR(255)
AS
BEGIN
   IF @s is null
      RETURN null
   
   DECLARE @s2 NVARCHAR(255)
   SET @s2 = ''
   DECLARE @l int
   SET @l = len(@s)
   DECLARE @p int
   SET @p = 1
   WHILE @p <= @l
   BEGIN
      DECLARE @c int;
      SET @c = ascii(substring(@s, @p, 1))
      set @c = LOWER(@c)

      if (@c = 32) set @c = ascii('_')      
	  if @c = ascii('ä') set @c = ascii('a')
	  if @c = ascii('ë') set @c = ascii('e')
	  if @c = ascii('ï') set @c = ascii('i')
	  if @c = ascii('ö') set @c = ascii('o')
      if @c = ascii('ü') set @c = ascii('u')
	  if @c = ascii('á') set @c = ascii('a')
      if @c = ascii('é') set @c = ascii('e')
	  if @c = ascii('í') set @c = ascii('i')
	  if @c = ascii('ó') set @c = ascii('o')
	  if @c = ascii('ú') set @c = ascii('u')
	  if @c = ascii('à') set @c = ascii('a')
      if @c = ascii('è') set @c = ascii('e')
	  if @c = ascii('ì') set @c = ascii('i')
	  if @c = ascii('ò') set @c = ascii('o')
	  if @c = ascii('ù') set @c = ascii('u')
	  if @c = ascii('ñ') set @c = ascii('n')

      if (@c between 48 and 57 or @c = 64 or @c = 45 or @c = 46 
      or @c = 95 or @c between 65 and 90 or @c between 97 and 122)
		
		SET @s2 = @s2 + char(@c)
      
      SET @p = @p + 1
   END
   IF len(@s2) = 0
      return null
   return @s2
END
GO

CREATE FUNCTION LAS_PELOTAS.kgLibres(@vuelo int)
RETURNS INT
AS BEGIN
	DECLARE @kgOcupados INT;
	DECLARE @KgTot INT
	SET @kgOcupados=(SELECT SUM(p.KG) from LAS_PELOTAS.boletos_de_compra b 
	join LAS_PELOTAS.paquetes p on p.BOLETO_COMPRA_ID = b.ID
	where b.VUELO_ID = @vuelo and b.ID not in (SELECT BOLETO_COMPRA_ID FROM LAS_PELOTAS.cancelaciones))
	SET @KgTot=(SELECT a.KG_DISPONIBLES from LAS_PELOTAS.vuelos v join
	LAS_PELOTAS.aeronaves a on a.ID = v.AERONAVE_ID
	where v.ID = @vuelo )
	IF(@kgOcupados IS NULL)
		RETURN @kgTot;
	RETURN @KgTot - @kgOcupados
END
GO

CREATE FUNCTION LAS_PELOTAS.precioTotal(@id int)
RETURNS numeric(18,2)
AS BEGIN
	DECLARE @totPas numeric(18,2);
	DECLARE @totPaq numeric(18,2);
	SET @totPas=(SELECT SUM(pas.PRECIO) from LAS_PELOTAS.pasajes pas 
	where @id=pas.BOLETO_COMPRA_ID)
	SET @totPaq=(SELECT SUM(paq.PRECIO) from LAS_PELOTAS.paquetes paq 
	where @id=paq.BOLETO_COMPRA_ID)
	IF(@totPas IS NULL)
	set @totPas= 0
	IF(@totPaq IS NULL)
	set @totPaq= 0
	RETURN @totPas + @totPaq
END
GO 

CREATE FUNCTION LAS_PELOTAS.cantButacasLibres(@vuelo int)
RETURNS INT
AS BEGIN
	DECLARE @butacasLibres INT;
	set @butacasLibres = (SELECT count(b.ID) FROM LAS_PELOTAS.butacas_por_vuelo bxv 
	join LAS_PELOTAS.butacas b on b.ID = bxv.BUTACA_ID 
	where bxv.VUELO_ID = @vuelo AND bxv.ESTADO = 'LIBRE')
	RETURN  @butacasLibres
END
GO

CREATE PROCEDURE LAS_PELOTAS.agregarRol(@nombreRol nvarchar(255),@retorno int output)
AS BEGIN
	INSERT INTO LAS_PELOTAS.Roles (NOMBRE,ACTIVO) VALUES (@nombreRol, 1)
	SET @retorno = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE LAS_PELOTAS.asignarRol(@idRol int, @idUser int)
AS BEGIN
	INSERT INTO LAS_PELOTAS.roles_por_usuario(USUARIO_ID, ROL_ID)
	VALUES (@idUser, @idRol)
END
GO

CREATE PROCEDURE LAS_PELOTAS.inhabilitarRol(@idRol int)
AS BEGIN
UPDATE LAS_PELOTAS.roles
SET ACTIVO = 0
WHERE ID = @idRol
DELETE LAS_PELOTAS.roles_por_usuario WHERE ROL_ID = @idRol
END
GO

CREATE PROCEDURE LAS_PELOTAS.habilitarRol(@idRol int)
AS BEGIN
UPDATE LAS_PELOTAS.roles
SET ACTIVO = 1
WHERE ID = @idRol
END
GO

CREATE PROCEDURE LAS_PELOTAS.addFuncionalidad(@rol nvarchar(255), @func nvarchar(255)) AS
BEGIN
	INSERT INTO LAS_PELOTAS.funcionalidades_por_rol (ROL_ID, FUNCIONALIDAD_ID)
		VALUES ((SELECT id FROM LAS_PELOTAS.roles WHERE NOMBRE = @rol),
		        (SELECT id FROM LAS_PELOTAS.funcionalidades WHERE DETALLES = @func))
END
GO

CREATE PROCEDURE LAS_PELOTAS.agregarFuncionalidad(@idRol int, @idFunc int)
AS BEGIN
INSERT INTO LAS_PELOTAS.funcionalidades_por_rol (ROL_ID, FUNCIONALIDAD_ID)
VALUES (@idRol, @idFunc)
END
GO

CREATE PROCEDURE LAS_PELOTAS.quitarFuncionalidad(@idRol int, @idFunc int)
AS BEGIN
DELETE FROM LAS_PELOTAS.funcionalidades_por_rol
WHERE ROL_ID = @idRol and FUNCIONALIDAD_ID = @idFunc
END
GO

CREATE PROCEDURE LAS_PELOTAS.cambiarNombreRol(@idRol int, @nombre nvarchar(255))
AS BEGIN
UPDATE LAS_PELOTAS.roles
SET NOMBRE=@nombre
WHERE ID=@idRol
END
GO

CREATE PROCEDURE LAS_PELOTAS.UpdateIntento(@nombre varchar(25), @exitoso int)
AS BEGIN
	IF(@exitoso = 1)
		BEGIN
			UPDATE LAS_PELOTAS.usuarios  SET INTENTOS_LOGIN=0 WHERE USERNAME=@nombre
		END
	ELSE
		BEGIN
			DECLARE @cant_Intentos int
			SELECT @cant_Intentos = intentos_login FROM LAS_PELOTAS.usuarios WHERE USERNAME=@nombre
			IF( @cant_Intentos = 2)
				BEGIN
					UPDATE LAS_PELOTAS.usuarios  SET ACTIVO=0, INTENTOS_LOGIN=0 WHERE USERNAME=@nombre
				END
			ELSE
				BEGIN
					UPDATE LAS_PELOTAS.usuarios set INTENTOS_LOGIN=@cant_Intentos+1 WHERE USERNAME=@nombre
				END
		END
END
GO

CREATE PROCEDURE LAS_PELOTAS.agregarCliente(@rol_id INT, @nombreCliente nvarchar(255), @apellidoCliente nvarchar(255), 
	@documentoCliente numeric(18,0), @direccion nvarchar(255), 
	@telefono numeric(18,0), @mail nvarchar(255), @fechaNac varchar(50))
AS BEGIN
	INSERT INTO LAS_PELOTAS.Clientes (rol_id, nombre, apellido, dni, direccion,telefono,
	mail,FECHA_NACIMIENTO)  
	VALUES (@rol_id, SUBSTRING(UPPER (@nombreCliente), 1, 1) + SUBSTRING (LOWER (@nombreCliente), 2,LEN(@nombreCliente)), 
	SUBSTRING(UPPER (@apellidoCliente), 1, 1) + SUBSTRING (LOWER (@apellidoCliente), 2,LEN(@apellidoCliente)), 
	@documentoCliente, @direccion, 
	@telefono, LAS_PELOTAS.corrigeMail(@mail), convert(datetime, @fechaNac,109))
END
GO

CREATE PROCEDURE LAS_PELOTAS.updateCliente(@id INT, @direccion nvarchar(255), @telefono numeric(18,0), @mail nvarchar(255))
AS BEGIN
UPDATE LAS_PELOTAS.clientes
SET DIRECCION = @direccion, TELEFONO = @telefono, MAIL =  LAS_PELOTAS.corrigeMail(@mail)
WHERE ID = @id
END
GO

CREATE PROCEDURE LAS_PELOTAS.bajaCliente(@id  INT)
AS BEGIN
UPDATE LAS_PELOTAS.clientes
SET BAJA = 1
WHERE ID=@id;
END
GO

CREATE PROCEDURE LAS_PELOTAS.crearButacas (@idAeronave int, @butacas int)
AS BEGIN
declare @i int
declare @tipo varchar(50)
set @i = 0
	WHILE(@i != @butacas)
	begin
		if((@i%2) = 0)
		begin
		set @tipo = 'VENTANILLA'
		end
		else
		begin
		set @tipo = 'PASILLO'
		end
		INSERT INTO LAS_PELOTAS.butacas (AERONAVE_ID, NUMERO, PISO, TIPO)
		VALUES (@idAeronave, @i, 1, @tipo)
		set @i = @i+1
	end
END
GO

CREATE PROCEDURE LAS_PELOTAS.agregarAeronave(@matricula nvarchar(255), @modelo nvarchar(255), @kg_disponibles numeric(18,0), 
@fabricante int, @tipo_servicio int, @alta varchar(50), @cantButacas int)
AS BEGIN
	INSERT INTO LAS_PELOTAS.aeronaves(MATRICULA, MODELO, KG_DISPONIBLES, FABRICANTE_ID, TIPO_SERVICIO_ID, FECHA_ALTA, CANT_BUTACAS)
	VALUES (UPPER(@matricula), UPPER(@modelo), @kg_disponibles, @fabricante, @tipo_servicio, convert(datetime, @alta,109), @cantButacas)
	declare @id int
	set @id = SCOPE_IDENTITY()
	EXEC LAS_PELOTAS.crearButacas @idAeronave = @id, @butacas = @cantButacas
END
GO

CREATE PROCEDURE LAS_PELOTAS.updateAeronave(@id  INT, @fechaInicio varchar(50), @fechaFin varchar(50))
AS BEGIN
DECLARE @IDPERIODO INT
SELECT @IDPERIODO= ID FROM LAS_PELOTAS.periodos_de_inactividad WHERE DESDE=convert(datetime, @fechaInicio,109) AND 
HASTA=convert(datetime, @fechaFin,109)
	IF(@IDPERIODO IS NULL)
		BEGIN
			INSERT INTO LAS_PELOTAS.periodos_de_inactividad VALUES(convert(datetime, @fechaInicio,109),convert(datetime, @fechaFin,109)) 
			SET @IDPERIODO=SCOPE_IDENTITY()
		END
INSERT INTO  LAS_PELOTAS.aeronaves_por_periodos VALUES(@ID,@IDPERIODO)
UPDATE LAS_PELOTAS.aeronaves SET BAJA='POR_PERIODO' WHERE ID=@id; 
END
GO

CREATE PROCEDURE LAS_PELOTAS.bajaAeronave(@id  INT)
AS BEGIN
UPDATE LAS_PELOTAS.aeronaves SET BAJA='DEFINITIVA',
FECHA_BAJA= CURRENT_TIMESTAMP
WHERE ID=@id;
END
GO

CREATE PROCEDURE LAS_PELOTAS.agregarRuta(@codigo int, @precioKg numeric(18,2), @precioPasaje numeric(18,2), @origen int, @destino int, 
	@servicio int)
AS BEGIN
	INSERT INTO LAS_PELOTAS.rutas(CODIGO, PRECIO_BASE_KG, PRECIO_BASE_PASAJE, ORIGEN_ID, DESTINO_ID, TIPO_SERVICIO_ID)
	VALUES (@codigo, @precioKg, @precioPasaje, @origen, @destino, @servicio)
END
GO

CREATE PROCEDURE LAS_PELOTAS.updateRuta(@id INT, @precioKg numeric(18,2), @precioPasaje numeric(18,2), @servicio INT)
AS BEGIN
UPDATE LAS_PELOTAS.rutas
SET PRECIO_BASE_KG = @precioKg, PRECIO_BASE_PASAJE = @precioPasaje, TIPO_SERVICIO_ID = @servicio
WHERE ID = @id
END
GO

CREATE PROCEDURE LAS_PELOTAS.cancelarPasajesDeBc(@idBc int)
AS BEGIN
INSERT INTO LAS_PELOTAS.cancelaciones (BOLETO_COMPRA_ID, FECHA_DEVOLUCION, MOTIVO)
VALUES(@idBc,CURRENT_TIMESTAMP,'CANCELACION PASAJE')
UPDATE LAS_PELOTAS.pasajes
SET CANCELACION_ID = SCOPE_IDENTITY()
WHERE BOLETO_COMPRA_ID = @idBc
UPDATE LAS_PELOTAS.butacas_por_vuelo
SET ESTADO = 'LIBRE'
WHERE BUTACA_ID IN (SELECT p.BUTACA_ID FROM LAS_PELOTAS.pasajes p , LAS_PELOTAS.boletos_de_compra b WHERE b.ID = @idBc AND p.BOLETO_COMPRA_ID = b.ID)
END
GO

CREATE PROCEDURE LAS_PELOTAS.cancelarPasaje(@idPasaje int)
AS BEGIN
INSERT INTO LAS_PELOTAS.cancelaciones (BOLETO_COMPRA_ID, FECHA_DEVOLUCION, MOTIVO)
SELECT BOLETO_COMPRA_ID, CURRENT_TIMESTAMP, 'CANCELACION PASAJE' FROM LAS_PELOTAS.pasajes WHERE ID = @idPasaje
UPDATE LAS_PELOTAS.pasajes
SET CANCELACION_ID = SCOPE_IDENTITY()
WHERE ID = @idPasaje
UPDATE LAS_PELOTAS.butacas_por_vuelo
SET ESTADO = 'LIBRE'
WHERE BUTACA_ID = (SELECT BUTACA_ID FROM LAS_PELOTAS.pasajes WHERE ID = @idPasaje)
END
GO

/*CANCELACION DE TODOS LOS PAQUETES DE UN BOLETO DE COMPRA*/
CREATE PROCEDURE LAS_PELOTAS.cancelarPaquete(@idBoletoCompra int)
AS BEGIN
INSERT INTO LAS_PELOTAS.cancelaciones (BOLETO_COMPRA_ID, FECHA_DEVOLUCION, MOTIVO)
VALUES(@idBoletoCompra, CURRENT_TIMESTAMP, 'CANCELACION PAQUETE')
UPDATE LAS_PELOTAS.paquetes
SET CANCELACION_ID = SCOPE_IDENTITY()
WHERE BOLETO_COMPRA_ID = @idBoletoCompra
END
GO

CREATE PROCEDURE LAS_PELOTAS.bajaVuelo(@id int)
AS BEGIN
DELETE LAS_PELOTAS.butacas_por_vuelo WHERE VUELO_ID = @id 
UPDATE LAS_PELOTAS.vuelos 
SET INVALIDO = 1
WHERE ID = @id AND FECHA_LLEGADA IS NULL AND FECHA_SALIDA > CURRENT_TIMESTAMP
INSERT INTO LAS_PELOTAS.cancelaciones (BOLETO_COMPRA_ID, FECHA_DEVOLUCION, MOTIVO)
SELECT BC.ID, CURRENT_TIMESTAMP, 'BAJA VUELO' FROM LAS_PELOTAS.boletos_de_compra BC, LAS_PELOTAS.vuelos v WHERE BC.VUELO_ID = @id and
v.ID = bc.VUELO_ID and v.INVALIDO = 1 and bc.INVALIDO = 0
SELECT BC.ID Into  #Temp FROM LAS_PELOTAS.boletos_de_compra BC, LAS_PELOTAS.vuelos v WHERE BC.VUELO_ID = @id and
v.ID = bc.VUELO_ID and v.INVALIDO = 1 and bc.INVALIDO = 0
Declare @idBoleto int
	While (Select Count(*) From #Temp) > 0
	Begin
		Select Top 1 @idBoleto = Id From #Temp
		EXEC LAS_PELOTAS.cancelarPasajesDeBc @idBc = @idBoleto
		EXEC LAS_PELOTAS.cancelarPaquete @idBoletoCompra = @idBoleto
		Delete #Temp Where Id = @idBoleto
	End
END
GO

CREATE PROCEDURE LAS_PELOTAS.bajaRuta(@id INT)
AS BEGIN
UPDATE LAS_PELOTAS.rutas
SET BAJA = 1
WHERE ID=@id;
SELECT v.ID Into #Temp FROM LAS_PELOTAS.vuelos v WHERE v.RUTA_ID = @id
Declare @idVuelo int
	While (Select Count(*) From #Temp) > 0
	Begin
		Select Top 1 @idVuelo = Id From #Temp
		EXEC LAS_PELOTAS.bajaVuelo @id = @idVuelo
		Delete #Temp Where Id = @idVuelo
	End
END
GO

--LISTADOS ESTADISTICOS
--TOP 5 de los destino con mas pasajes comprados
CREATE PROCEDURE LAS_PELOTAS.top5DestinosConPasajes(@fechaFrom varchar(50), @fechaTo varchar(50))
AS BEGIN
select top 5 a.NOMBRE as 'Destino', count(p.ID) as 'Pasajes comprados' 
from LAS_PELOTAS.pasajes p 
join LAS_PELOTAS.boletos_de_compra bc on p.BOLETO_COMPRA_ID=bc.ID
join LAS_PELOTAS.vuelos v on bc.VUELO_ID=v.ID 
join LAS_PELOTAS.rutas r on v.RUTA_ID=r.ID
join LAS_PELOTAS.aeropuertos a on r.DESTINO_ID=a.ID
where bc.id NOT IN (select BOLETO_COMPRA_ID from LAS_PELOTAS.cancelaciones) and
p.INVALIDO=0 AND
bc.INVALIDO=0 AND
bc.FECHA_COMPRA between convert(datetime, @fechaFrom,109) and convert(datetime, @fechaTo,109)
group by a.nombre 
order by 2 desc
END
GO

--TOP 5 de los destinos con aeronaves mas vacias
CREATE PROCEDURE LAS_PELOTAS.top5DestinosAeronavesVacias(@fechaFrom varchar(50), @fechaTo varchar(50))
AS BEGIN
select top 5 a.NOMBRE as 'Destino', count(buV.VUELO_ID) as 'Butacas Vacias' 
from LAS_PELOTAS.butacas_por_vuelo buV 
join LAS_PELOTAS.vuelos v on buV.VUELO_ID=v.ID 
join LAS_PELOTAS.rutas r on v.RUTA_ID=r.ID 
join LAS_PELOTAS.aeropuertos a on r.DESTINO_ID=a.ID 
where buV.ESTADO = 'LIBRE' and
v.FECHA_SALIDA between convert(datetime, @fechaFrom,109) and convert(datetime, @fechaTo,109) and
v.FECHA_LLEGADA between convert(datetime, @fechaFrom,109) and convert(datetime, @fechaTo,109)
group by a.NOMBRE
order by 2 desc
END
GO

--TOP 5 de los clientes con mas puntos acumulados a la fecha
CREATE PROCEDURE LAS_PELOTAS.top5ClientesMillas(@fechaFrom varchar(50), @fechaTo varchar(50))
AS BEGIN
create table #tablaMillas(
Cliente varchar(255),
Millas int
)
insert into #tablaMillas 
select c.NOMBRE+' '+c.APELLIDO, sum(bc.millas)
from LAS_PELOTAS.clientes c
join LAS_PELOTAS.pasajes p on c.ID=p.CLIENTE_ID
join LAS_PELOTAS.boletos_de_compra bc on p.BOLETO_COMPRA_ID=bc.ID 
where P.CANCELACION_ID IS NULL AND
p.INVALIDO=0 AND
bc.INVALIDO=0 AND
bc.FECHA_COMPRA between DATEADD(YYYY, -1, CURRENT_TIMESTAMP) and CURRENT_TIMESTAMP
group by c.nombre, c.APELLIDO
insert into #tablaMillas 
select c.NOMBRE+' '+c.APELLIDO, sum(bc.millas)
from LAS_PELOTAS.Clientes c  
join LAS_PELOTAS.boletos_de_compra bc on bc.Cliente_ID=c.ID
join LAS_PELOTAS.paquetes p on bc.ID = p.BOLETO_COMPRA_ID
where P.CANCELACION_ID IS NULL AND
p.INVALIDO=0 AND
bc.INVALIDO=0 AND
bc.FECHA_COMPRA between DATEADD(YYYY, -1, CURRENT_TIMESTAMP) and CURRENT_TIMESTAMP
group by c.nombre, c.APELLIDO

select top 5 * from #tablaMillas
order by 2 desc
drop table #tablaMillas
END
GO

--TOP 5 de los destinos con pasajes cancelados 
CREATE PROCEDURE LAS_PELOTAS.top5DestinosCancelados(@fechaFrom varchar(50), @fechaTo varchar(50))
AS BEGIN
select top 5 a.NOMBRE as Destino, count(p.ID) as Cancelaciones from LAS_PELOTAS.pasajes p
join LAS_PELOTAS.boletos_de_compra bc on p.BOLETO_COMPRA_ID = bc.ID
join LAS_PELOTAS.vuelos v on bc.VUELO_ID = v.ID
join LAS_PELOTAS.rutas r on v.RUTA_ID=r.ID
join LAS_PELOTAS.aeropuertos a on r.DESTINO_ID=a.ID
where p.CANCELACION_ID IS NOT NULL AND
bc.FECHA_COMPRA between convert(datetime, @fechaFrom,109) and convert(datetime, @fechaTo,109)
group by a.NOMBRE 
order by 2 desc
END
GO

--TOP 5 de las aeronaves con mayor cantidad de dias fuera de servicio 
CREATE PROCEDURE LAS_PELOTAS.top5AeronavesFueraDeServicio(@fechaFrom varchar(50), @fechaTo varchar(50))
AS BEGIN
select top 5 a.matricula as 'Matricula Aeronave', sum(DATEDIFF(day,pi.desde,pi.hasta)) as 'Días fuera de servicio'
from LAS_PELOTAS.aeronaves_por_periodos ap
join LAS_PELOTAS.periodos_de_inactividad pi on ap.periodo_id=pi.id
join LAS_PELOTAS.aeronaves a on ap.aeronave_id= a.id
where pi.desde between convert(datetime, @fechaFrom,109) and convert(datetime, @fechaTo,109) AND
pi.hasta between convert(datetime, @fechaFrom,109) and convert(datetime, @fechaTo,109) 
group by a.matricula
order by 2 desc 
END
GO

CREATE PROCEDURE LAS_PELOTAS.generarViaje(@fechaSalida varchar(255), @fechaLlegadaEstimada varchar(255), @idAeronave int, @idRuta int)
AS BEGIN
INSERT INTO LAS_PELOTAS.vuelos (FECHA_SALIDA, FECHA_LLEGADA_ESTIMADA, AERONAVE_ID, RUTA_ID)
VALUES (convert(datetime, @fechaSalida,109), convert(datetime, @fechaLlegadaEstimada, 109), @idAeronave, @idRuta)
INSERT INTO LAS_PELOTAS.butacas_por_vuelo (VUELO_ID, BUTACA_ID, ESTADO)
SELECT SCOPE_IDENTITY(), b.ID, 'LIBRE' FROM LAS_PELOTAS.butacas b
WHERE b.AERONAVE_ID = @idAeronave
END
GO

CREATE PROCEDURE LAS_PELOTAS.registrarLlegada(@idVuelo int, @fechaLlegada varchar(50))
AS BEGIN
UPDATE LAS_PELOTAS.vuelos
SET FECHA_LLEGADA = convert(datetime, @fechaLlegada,109)
WHERE ID = @idVuelo
UPDATE LAS_PELOTAS.boletos_de_compra
SET MILLAS = FLOOR(PRECIO_COMPRA/10)
WHERE VUELO_ID = @idVuelo and ID not in (SELECT BOLETO_COMPRA_ID FROM LAS_PELOTAS.cancelaciones)
END
GO

CREATE PROCEDURE LAS_PELOTAS.vuelosDisponibles(@fecha varchar(50))
AS BEGIN
	Select v.ID as ID ,v.FECHA_SALIDA as 'Salida', v.FECHA_LLEGADA_ESTIMADA as 'Llegada Estimada', o.NOMBRE as Origen, d.NOMBRE as Destino,
	 LAS_PELOTAS.cantButacasLibres(v.ID) as 'Butacas Libres', LAS_PELOTAS.kgLibres(v.ID) as 'Kg Disponibles', t.NOMBRE as 'Tipo de Servicio'
	from LAS_PELOTAS.vuelos v
	join LAS_PELOTAS.rutas r on r.ID = v.RUTA_ID
	join LAS_PELOTAS.aeropuertos o on r.ORIGEN_ID = o.ID
	join LAS_PELOTAS.aeropuertos d on r.DESTINO_ID = d.ID
	join LAS_PELOTAS.aeronaves a on v.AERONAVE_ID = a.ID
	join LAS_PELOTAS.tipos_de_servicio t on t.ID = a.TIPO_SERVICIO_ID and t.ID = r.TIPO_SERVICIO_ID
	where (v.INVALIDO = 0) AND (v.FECHA_SALIDA > convert(datetime, @fecha,109)) 
	AND( (LAS_PELOTAS.cantButacasLibres(v.ID)  != 0 ) OR (LAS_PELOTAS.kgLibres(v.ID) !=0 ))
	order by 2
END
GO

CREATE PROCEDURE LAS_PELOTAS.validarVuelo (@id int, @fechaSalida varchar(50), @fechaLlegadaEstimada varchar(50))
AS BEGIN
select COUNT(v.ID) from LAS_PELOTAS.vuelos v
where v.AERONAVE_ID = @id and (v.FECHA_SALIDA > convert(datetime, @fechaSalida,109) and v.FECHA_SALIDA < convert(datetime, @fechaLlegadaEstimada,109)
or v.FECHA_LLEGADA > convert(datetime, @fechaSalida,109) and v.FECHA_LLEGADA < convert(datetime, @fechaLlegadaEstimada,109)
or v.FECHA_LLEGADA_ESTIMADA > convert(datetime, @fechaSalida,109) and v.FECHA_LLEGADA_ESTIMADA  < convert(datetime, @fechaLlegadaEstimada,109))
END
GO

CREATE PROCEDURE LAS_PELOTAS.cambiarAeronaveDeVuelo (@idVuelo int, @idAeronaveNueva int)
AS BEGIN
UPDATE LAS_PELOTAS.vuelos
SET AERONAVE_ID = @idAeronaveNueva
WHERE ID = @idVuelo
END
GO

CREATE PROCEDURE LAS_PELOTAS.migracionButacasPorVuelo
AS BEGIN
declare @cantAeronaves int
select @cantAeronaves = count(ID) from LAS_PELOTAS.aeronaves
declare @j int
set @j = 1
	while(@j != @cantAeronaves+1)
	begin
	declare @cantButacas int
	SELECT @cantButacas = a.CANT_BUTACAS from LAS_PELOTAS.aeronaves a where a.ID = @j
	declare @i int
	set @i = 0
		WHILE(@i != @cantButacas)
		begin
			IF((SELECT count(b.ID) FROM LAS_PELOTAS.butacas b, LAS_PELOTAS.vuelos v
			where v.INVALIDO = 0 and b.AERONAVE_ID = @j and v.AERONAVE_ID = @j and b.NUMERO = @i) = 0)
				begin
				INSERT INTO LAS_PELOTAS.butacas_por_vuelo(BUTACA_ID, VUELO_ID, ESTADO)
				SELECT b.ID, v.ID,'LIBRE' FROM LAS_PELOTAS.butacas b, LAS_PELOTAS.vuelos v
				where v.INVALIDO = 0 and b.AERONAVE_ID = @j and v.AERONAVE_ID = @j and b.NUMERO = @i
				end
			else
				begin
				INSERT INTO LAS_PELOTAS.butacas_por_vuelo(BUTACA_ID, VUELO_ID, ESTADO)
				SELECT b.ID, v.ID,'COMPRADO' FROM LAS_PELOTAS.butacas b, LAS_PELOTAS.vuelos v
				where v.INVALIDO = 0 and b.AERONAVE_ID = @j and v.AERONAVE_ID = @j and b.NUMERO = @i
				end
		set @i = @i+1
		end
	set @j = @j+1
	end
END
GO

CREATE PROCEDURE LAS_PELOTAS.consultarMillas (@dni numeric(18,0))
AS BEGIN
create table #tablaMillas(
Fecha datetime,
Motivo varchar(255),
Millas int
)
insert into #tablaMillas 
select bc.FECHA_COMPRA as Fecha, 'Pasaje' as Motivo, bc.millas as Millas
from LAS_PELOTAS.clientes c
join LAS_PELOTAS.pasajes p on c.ID=p.CLIENTE_ID 
join LAS_PELOTAS.boletos_de_compra bc on p.BOLETO_COMPRA_ID=bc.ID 
where bc.ID NOT IN (select BOLETO_COMPRA_ID from LAS_PELOTAS.cancelaciones) and
p.INVALIDO=0 AND
bc.INVALIDO=0 AND
bc.FECHA_COMPRA between DATEADD(YYYY, -1, CURRENT_TIMESTAMP) and CURRENT_TIMESTAMP
and c.DNI = @dni

insert into #tablaMillas 
select bc.FECHA_COMPRA as Fecha, 'Paquete' as Motivo, bc.millas as Millas
from LAS_PELOTAS.clientes c  
join LAS_PELOTAS.boletos_de_compra bc on bc.CLIENTE_ID=c.ID
join LAS_PELOTAS.paquetes p on bc.ID = p.BOLETO_COMPRA_ID
where bc.ID NOT IN (select BOLETO_COMPRA_ID from LAS_PELOTAS.cancelaciones) and
p.INVALIDO=0 AND
bc.INVALIDO=0 AND
bc.FECHA_COMPRA between DATEADD(YYYY, -1, CURRENT_TIMESTAMP) and CURRENT_TIMESTAMP
and c.DNI = @dni

insert into #tablaMillas 
select cj.FECHA_CANJE as Fecha, 'Canje por '+CONVERT(varchar(10), cj.CANTIDAD)+' unidades de '+LOWER(p.NOMBRE) as Motivo, 
-p.MILLAS_REQUERIDAS*cj.CANTIDAD as Millas
from LAS_PELOTAS.clientes c
join LAS_PELOTAS.canjes cj on cj.CLIENTE_ID=c.ID
join LAS_PELOTAS.productos p on p.ID = cj.PRODUCTO_ID
where cj.FECHA_CANJE between DATEADD(YYYY, -1, CURRENT_TIMESTAMP) and CURRENT_TIMESTAMP
and c.DNI = @dni

select * from #tablaMillas
drop table #tablaMillas
END
GO

CREATE PROCEDURE LAS_PELOTAS.obtenerClienteConMillas (@dni numeric(18,0))
AS BEGIN
CREATE TABLE #Result (
  FECHA_COMPRA datetime,
  Motivo varchar(255),
  Millas int
)
INSERT INTO #Result EXEC LAS_PELOTAS.consultarMillas @dni

SELECT c.ID, c.NOMBRE as Nombre, c.APELLIDO as Apellido, c.DNI as Dni, c.FECHA_NACIMIENTO as 'Fecha de Nacimiento', SUM(r.Millas) as Millas
FROM #Result r
join LAS_PELOTAS.clientes c on c.DNI = @dni
group by c.ID, c.NOMBRE, c.APELLIDO, c.DNI, c.FECHA_NACIMIENTO
DROP TABLE #Result
END
GO

CREATE PROCEDURE LAS_PELOTAS.altaCanje (@idCliente int, @idProducto int, @cantidad int)
AS BEGIN
INSERT INTO LAS_PELOTAS.canjes (CLIENTE_ID, PRODUCTO_ID, CANTIDAD, FECHA_CANJE)
VALUES (@idCliente, @idProducto, @cantidad, CURRENT_TIMESTAMP)
UPDATE LAS_PELOTAS.productos
SET STOCK = STOCK - @cantidad
where ID = @idProducto
END
GO

CREATE PROCEDURE LAS_PELOTAS.altaTarjeta (@idCliente int, @nroTarjeta numeric(18,0), @idTipo int, @fechaVto varchar(255))
AS BEGIN
INSERT INTO LAS_PELOTAS.tarjetas_de_credito (Cliente_ID, NUMERO, TIPO_TARJETA_ID, FECHA_VTO)
VALUES (@idCliente, @nroTarjeta, @idTipo, convert(datetime, @fechaVto,109))
END
GO

CREATE PROCEDURE LAS_PELOTAS.bajaCiudad (@idCiudad int)
AS BEGIN
UPDATE LAS_PELOTAS.aeropuertos
SET BAJA = 1
WHERE CIUDAD_ID = @idCiudad

UPDATE LAS_PELOTAS.ciudades
SET BAJA = 1
WHERE ID = @idCiudad

SELECT r.ID Into #Temp FROM LAS_PELOTAS.rutas r, LAS_PELOTAS.aeropuertos a WHERE (r.ORIGEN_ID = a.ID and a.CIUDAD_ID = @idCiudad) or 
(r.DESTINO_ID = a.ID and a.CIUDAD_ID = @idCiudad)
Declare @idRuta int
	While (Select Count(*) From #Temp) > 0
	Begin
		Select Top 1 @idRuta = Id From #Temp
		EXEC LAS_PELOTAS.bajaRuta @id = @idRuta
		Delete #Temp Where Id = @idRuta
	End
END
GO

CREATE PROCEDURE LAS_PELOTAS.altaBoletoDeCompra (@precio numeric(18,2), @tipo nvarchar(255), @idCliente int, @idVuelo int)
AS BEGIN
INSERT INTO LAS_PELOTAS.boletos_de_compra (PRECIO_COMPRA, TIPO_COMPRA, CLIENTE_ID, VUELO_ID, FECHA_COMPRA, MILLAS)
VALUES (@precio, UPPER(@tipo), @idCliente, @idVuelo, CURRENT_TIMESTAMP, 0)
END
GO

CREATE PROCEDURE LAS_PELOTAS.altaPasaje (@idCliente int, @idButaca int, @idBoletoCompra int, @precio numeric(18,2))
AS BEGIN
DECLARE @codigo numeric(18,0)
select top 1 @codigo = CODIGO from LAS_PELOTAS.pasajes
order by CODIGO desc
INSERT INTO LAS_PELOTAS.pasajes (CLIENTE_ID, BUTACA_ID, BOLETO_COMPRA_ID, PRECIO, CODIGO, CANCELACION_ID)
VALUES (@idCliente, @idButaca, @idBoletoCompra, @precio, @codigo+1, NULL)
UPDATE LAS_PELOTAS.butacas_por_vuelo
SET ESTADO = 'COMPRADO'
WHERE BUTACA_ID = @idButaca AND VUELO_ID = (SELECT bc.VUELO_ID FROM LAS_PELOTAS.boletos_de_compra bc WHERE bc.ID = @idBoletoCompra)
END
GO

CREATE PROCEDURE LAS_PELOTAS.altaPaquete (@idBoletoCompra int, @kg numeric(18,2), @precio numeric(18,2))
AS BEGIN
DECLARE @codigo numeric(18,0)
select top 1 @codigo = CODIGO from LAS_PELOTAS.paquetes
order by CODIGO desc
INSERT INTO LAS_PELOTAS.paquetes (BOLETO_COMPRA_ID, KG, PRECIO, CODIGO, CANCELACION_ID)
VALUES (@idBoletoCompra, @kg, @precio, @codigo+1, NULL)
END
GO

-----------------------------------------------------------------------
-- TRIGGERS

IF OBJECT_ID('LAS_PELOTAS.insertVuelos') IS NOT NULL
BEGIN
   DROP TRIGGER LAS_PELOTAS.insertVuelos;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.insertBoletosCompra') IS NOT NULL
BEGIN
   DROP TRIGGER LAS_PELOTAS.insertBoletosCompra;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.insertPasajes') IS NOT NULL
BEGIN
   DROP TRIGGER LAS_PELOTAS.insertPasajes;
END;
GO

IF OBJECT_ID('LAS_PELOTAS.insertPaquetes') IS NOT NULL
BEGIN
   DROP TRIGGER LAS_PELOTAS.insertPaquetes;
END;
GO

CREATE TRIGGER LAS_PELOTAS.insertVuelos on LAS_PELOTAS.vuelos
AFTER INSERT
AS BEGIN TRANSACTION
update LAS_PELOTAS.vuelos
set INVALIDO= 1
where ID in (select i.ID from LAS_PELOTAS.vuelos v, inserted i
where v.id != i.id and v.AERONAVE_ID = i.AERONAVE_ID and (i.FECHA_SALIDA between v.FECHA_SALIDA and v.FECHA_LLEGADA_ESTIMADA
or i.FECHA_LLEGADA between v.FECHA_SALIDA and v.FECHA_LLEGADA_ESTIMADA 
or i.FECHA_LLEGADA_ESTIMADA between v.FECHA_SALIDA and v.FECHA_LLEGADA_ESTIMADA))
COMMIT
GO

CREATE TRIGGER LAS_PELOTAS.insertBoletosCompra on LAS_PELOTAS.boletos_de_compra
AFTER INSERT
AS BEGIN TRANSACTION
UPDATE LAS_PELOTAS.boletos_de_compra
SET INVALIDO = 1
WHERE VUELO_ID in (select v.ID from LAS_PELOTAS.vuelos v where v.INVALIDO = 1)
COMMIT
GO

CREATE TRIGGER LAS_PELOTAS.insertPasajes on LAS_PELOTAS.pasajes
AFTER INSERT
AS BEGIN TRANSACTION
UPDATE LAS_PELOTAS.pasajes
SET INVALIDO = 1
WHERE BOLETO_COMPRA_ID in (select bc.ID from LAS_PELOTAS.boletos_de_compra bc where bc.INVALIDO = 1)
COMMIT
GO

CREATE TRIGGER LAS_PELOTAS.insertPaquetes on LAS_PELOTAS.paquetes
AFTER INSERT
AS BEGIN TRANSACTION
UPDATE LAS_PELOTAS.paquetes
SET INVALIDO = 1
WHERE BOLETO_COMPRA_ID in (select bc.ID from LAS_PELOTAS.boletos_de_compra bc where bc.INVALIDO = 1)
COMMIT
GO

-- INSERTS: FUNCIONALIDADES ROLES USUARIOS PRODUCTOS TIPOS_DE_TARJETA

INSERT INTO LAS_PELOTAS.funcionalidades VALUES
('Consultar Millas'),
('Alta de Cliente'),
('Alta de Aeronave'),
('Alta de Tarjeta de Crédito'),
('Baja de Aeronave'),
('Baja de Ciudad'),
('Baja de Cliente'),
('Modificacion de Aeronave'),
('Modificacion de Cliente'),
('Realizar Canje'),
('Alta de Rol'),
('Baja de Rol'),
('Modificacion de Rol'),
('Alta de Ruta'),
('Baja de Ruta'),
('Modificacion de Ruta'),
('Comprar Pasaje/Encomienda'),
('Generar Viaje'),
('Registrar Llegadas'),
('Cancelar Compra'),
('Consultar Listado');

INSERT INTO LAS_PELOTAS.roles (nombre, activo) VALUES
('Administrador', 1),
('Cliente', 1);

INSERT INTO LAS_PELOTAS.usuarios  (USERNAME, PASSWORD, FECHA_CREACION, ULTIMA_MODIFICACION, INTENTOS_LOGIN, ACTIVO) VALUES 
('admin', 'e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7', GETDATE(), GETDATE(), 0, 1),
('guido', 'e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7', GETDATE(), GETDATE(), 0, 1),
('juan', 'e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7', GETDATE(), GETDATE(), 0, 1),
('adriano', 'e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7', GETDATE(), GETDATE(), 0, 1);

INSERT INTO LAS_PELOTAS.roles_por_usuario (ROL_ID, USUARIO_ID) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4);

INSERT INTO LAS_PELOTAS.productos (NOMBRE, MILLAS_REQUERIDAS, STOCK)
VALUES ('SABANAS', 50, 200),
('PS3',20000,5),
('TABLETA', 1500, 50),
('TV',10000,20),
('SILLA', 60, 100),
('MOTO', 15000, 10),
('HORNO', 500, 150);

INSERT INTO LAS_PELOTAS.tipos_tarjeta (NOMBRE, CUOTAS)
VALUES ('VISA', 6),
('AMEX', 3),
('MASTERCARD', 10),
('SOLRED', 5);

-- MIGRACION

INSERT INTO LAS_PELOTAS.fabricantes (NOMBRE)
SELECT DISTINCT Aeronave_Fabricante
FROM gd_esquema.Maestra
WHERE Aeronave_Fabricante IS NOT NULL

INSERT INTO LAS_PELOTAS.tipos_de_servicio (NOMBRE)
SELECT DISTINCT Tipo_Servicio
FROM gd_esquema.Maestra
WHERE Tipo_Servicio IS NOT NULL
update LAS_PELOTAS.tipos_de_servicio
set porcentaje= 0.05
where id=3
update LAS_PELOTAS.tipos_de_servicio
set porcentaje= 0.1
where id=2
update LAS_PELOTAS.tipos_de_servicio
set porcentaje= 0.15
where id=1

INSERT INTO LAS_PELOTAS.ciudades (NOMBRE)
(SELECT DISTINCT Ruta_Ciudad_Origen
FROM gd_esquema.Maestra
WHERE Ruta_Ciudad_Origen IS NOT NULL
UNION
SELECT DISTINCT Ruta_Ciudad_Destino
FROM gd_esquema.Maestra
WHERE Ruta_Ciudad_Destino IS NOT NULL)

INSERT INTO LAS_PELOTAS.aeropuertos (CIUDAD_ID, NOMBRE)
(SELECT ID, NOMBRE
FROM LAS_PELOTAS.ciudades)

INSERT INTO LAS_PELOTAS.clientes (DNI, NOMBRE, APELLIDO, FECHA_NACIMIENTO, MAIL, TELEFONO, DIRECCION, ROL_ID)
select m.Cli_Dni, SUBSTRING(UPPER (m.Cli_Nombre), 1, 1) + SUBSTRING (LOWER (m.Cli_Nombre), 2,LEN(m.Cli_Nombre)), 
SUBSTRING(UPPER (m.Cli_Apellido), 1, 1) + SUBSTRING (LOWER (m.Cli_Apellido), 2,LEN(m.Cli_Apellido)), m.Cli_Fecha_Nac, 
LAS_PELOTAS.corrigeMail(m.Cli_Mail), m.Cli_Telefono, m.Cli_Dir, r.ID
from GD2C2015.gd_esquema.Maestra m, LAS_PELOTAS.roles r
where r.NOMBRE = 'Cliente'
group by m.Cli_Dni, m.Cli_Nombre, m.Cli_Apellido, m.Cli_Fecha_Nac, m.Cli_Mail, m.Cli_Telefono, m.Cli_Dir, r.ID;

INSERT INTO LAS_PELOTAS.aeronaves (MATRICULA, MODELO, KG_DISPONIBLES, FABRICANTE_ID, TIPO_SERVICIO_ID, FECHA_ALTA, CANT_BUTACAS)
SELECT UPPER(m.Aeronave_Matricula), UPPER(m.Aeronave_Modelo), m.Aeronave_KG_Disponibles, f.ID, ts.ID, CURRENT_TIMESTAMP, m.Butaca_Nro+1
FROM GD2C2015.gd_esquema.Maestra m, LAS_PELOTAS.fabricantes f, LAS_PELOTAS.tipos_de_servicio ts
where f.NOMBRE = m.Aeronave_Fabricante and ts.NOMBRE = m.Tipo_Servicio 
and m.Butaca_Nro = (select max(Butaca_Nro) from [GD2C2015].[gd_esquema].[Maestra] j where m.Aeronave_Matricula = j.Aeronave_Matricula)
group by m.Aeronave_Matricula, m.Aeronave_Modelo, m.Aeronave_KG_Disponibles, f.ID, ts.ID, m.Butaca_Nro

INSERT INTO LAS_PELOTAS.butacas (NUMERO, TIPO, PISO, AERONAVE_ID)
SELECT M.Butaca_Nro, UPPER(M.Butaca_Tipo), M.Butaca_Piso, A.ID
FROM LAS_PELOTAS.aeronaves A, GD2C2015.gd_esquema.Maestra M
WHERE A.MATRICULA = M.Aeronave_Matricula and Butaca_Piso != 0
GROUP BY M.Butaca_Nro, M.Butaca_Tipo, M.Butaca_Piso, A.ID

-- Tomamos como rutas distintas a las que tienen mismo codigo pero distinto origen o tipo_servicio
SELECT DISTINCT [Ruta_Codigo], [Ruta_Precio_BaseKG], [Ruta_Precio_BasePasaje], [Ruta_Ciudad_Origen], [Ruta_Ciudad_Destino], [Tipo_Servicio]
INTO #rutas_temporales
FROM [GD2C2015].[gd_esquema].[Maestra]

INSERT INTO LAS_PELOTAS.rutas (CODIGO, PRECIO_BASE_KG, PRECIO_BASE_PASAJE, ORIGEN_ID, DESTINO_ID, TIPO_SERVICIO_ID)
SELECT r.Ruta_Codigo, r.Ruta_Precio_BaseKG, r2.Ruta_Precio_BasePasaje, o.ID, d.ID, ts.ID
FROM #rutas_temporales r, #rutas_temporales r2, LAS_PELOTAS.aeropuertos o, LAS_PELOTAS.aeropuertos d, LAS_PELOTAS.tipos_de_servicio ts
WHERE d.NOMBRE = r.Ruta_Ciudad_Destino AND o.NOMBRE = r.Ruta_Ciudad_Origen AND ts.NOMBRE = r.Tipo_Servicio
AND r.Ruta_Precio_BasePasaje = 0 AND r2.Ruta_Precio_BaseKG = 0 AND r.Ruta_Codigo = r2.Ruta_Codigo
AND r.Ruta_Ciudad_Destino = r2.Ruta_Ciudad_Destino AND r.Ruta_Ciudad_Origen = r2.Ruta_Ciudad_Origen
AND r.Tipo_Servicio = r2.Tipo_Servicio
DROP TABLE #rutas_temporales

INSERT INTO LAS_PELOTAS.vuelos (FECHA_SALIDA, FECHA_LLEGADA_ESTIMADA, FECHA_LLEGADA, AERONAVE_ID, RUTA_ID)
SELECT m.[FechaSalida], m.[Fecha_LLegada_Estimada], m.[FechaLLegada], a.ID, r.ID
FROM [GD2C2015].[gd_esquema].[Maestra] m, LAS_PELOTAS.aeronaves a, LAS_PELOTAS.rutas r, LAS_PELOTAS.aeropuertos p1, LAS_PELOTAS.aeropuertos p2
WHERE m.[Ruta_Codigo] = r.CODIGO AND m.[Ruta_Ciudad_Origen] = p1.NOMBRE AND p1.ID = r.ORIGEN_ID AND m.[Ruta_Ciudad_Destino] = p2.NOMBRE 
AND p2.ID = r.DESTINO_ID AND a.MATRICULA = m.[Aeronave_Matricula]
GROUP BY m.[FechaSalida], m.[Fecha_LLegada_Estimada], m.[FechaLLegada], a.ID, r.ID

EXEC LAS_PELOTAS.migracionButacasPorVuelo

--(Despues se actualiza el precio y las millas de los boletos de compra)
insert into LAS_PELOTAS.boletos_de_compra (CLIENTE_ID, FECHA_COMPRA, MILLAS, PRECIO_COMPRA, TIPO_COMPRA, VUELO_ID)
SELECT distinct C.ID as cliente, CASE WHEN Paquete_Codigo != 0 THEN Paquete_FechaCompra ELSE Pasaje_FechaCompra END AS FechaCompra, 0 as Millas, 0 as Precio, 'EFECTIVO' as tipoCompra, v.ID as vuelo
FROM GD2C2015.gd_esquema.Maestra M
join LAS_PELOTAS.clientes C on C.APELLIDO = SUBSTRING(UPPER (m.Cli_Apellido), 1, 1) + SUBSTRING (LOWER (m.Cli_Apellido), 2,LEN(m.Cli_Apellido))
and C.NOMBRE = SUBSTRING(UPPER (m.Cli_Nombre), 1, 1) + SUBSTRING (LOWER (m.Cli_Nombre), 2,LEN(m.Cli_Nombre))
and C.DNI = M.Cli_Dni
join LAS_PELOTAS.aeronaves a on m.Aeronave_Matricula = a.MATRICULA
join LAS_PELOTAS.vuelos v on v.AERONAVE_ID = a.ID and v.RUTA_ID = 
	(SELECT r.id from LAS_PELOTAS.rutas r 
	join LAS_PELOTAS.aeropuertos p1 on m.[Ruta_Ciudad_Origen] = p1.NOMBRE AND p1.ID = r.ORIGEN_ID
	join LAS_PELOTAS.aeropuertos p2 on m.[Ruta_Ciudad_Destino] = p2.NOMBRE AND p2.ID = r.DESTINO_ID
	where m.[Ruta_Codigo] = r.CODIGO and m.FechaSalida = v.FECHA_SALIDA and m.Fecha_LLegada_Estimada = v.FECHA_LLEGADA_ESTIMADA and
	m.FechaLLegada = v.FECHA_LLEGADA)

INSERT INTO LAS_PELOTAS.pasajes (CODIGO, CLIENTE_ID, BUTACA_ID, CANCELACION_ID, BOLETO_COMPRA_ID, PRECIO)
SELECT M.Pasaje_Codigo, C.ID, B.ID, NULL, bc.ID, M.Pasaje_Precio FROM GD2C2015.gd_esquema.Maestra M
join LAS_PELOTAS.clientes C on C.APELLIDO = SUBSTRING(UPPER (m.Cli_Apellido), 1, 1) + SUBSTRING (LOWER (m.Cli_Apellido), 2,LEN(m.Cli_Apellido))
and C.NOMBRE = SUBSTRING(UPPER (m.Cli_Nombre), 1, 1) + SUBSTRING (LOWER (m.Cli_Nombre), 2,LEN(m.Cli_Nombre))
and C.DNI = M.Cli_Dni
join LAS_PELOTAS.aeronaves A on M.Aeronave_Matricula = A.MATRICULA
join LAS_PELOTAS.butacas B on B.NUMERO = M.Butaca_Nro and A.ID = B.AERONAVE_ID
join LAS_PELOTAS.boletos_de_compra bc on m.Pasaje_FechaCompra = bc.FECHA_COMPRA and bc.CLIENTE_ID = c.ID
join LAS_PELOTAS.vuelos v on v.AERONAVE_ID = a.ID and v.RUTA_ID = 
	(SELECT r.id from LAS_PELOTAS.rutas r 
	join LAS_PELOTAS.aeropuertos p1 on m.[Ruta_Ciudad_Origen] = p1.NOMBRE AND p1.ID = r.ORIGEN_ID
	join LAS_PELOTAS.aeropuertos p2 on m.[Ruta_Ciudad_Destino] = p2.NOMBRE AND p2.ID = r.DESTINO_ID
	where m.[Ruta_Codigo] = r.CODIGO and m.FechaSalida = v.FECHA_SALIDA and m.Fecha_LLegada_Estimada = v.FECHA_LLEGADA_ESTIMADA and
	m.FechaLLegada = v.FECHA_LLEGADA) and v.ID=bc.VUELO_ID 
where M.Pasaje_Codigo != 0

INSERT INTO LAS_PELOTAS.paquetes (CODIGO, KG, BOLETO_COMPRA_ID, CANCELACION_ID, PRECIO)
SELECT M.Paquete_Codigo, M.Paquete_KG, bc.ID, NULL, M.Paquete_Precio FROM GD2C2015.gd_esquema.Maestra M
join LAS_PELOTAS.clientes C on C.APELLIDO = SUBSTRING(UPPER (m.Cli_Apellido), 1, 1) + SUBSTRING (LOWER (m.Cli_Apellido), 2,LEN(m.Cli_Apellido))
and C.NOMBRE = SUBSTRING(UPPER (m.Cli_Nombre), 1, 1) + SUBSTRING (LOWER (m.Cli_Nombre), 2,LEN(m.Cli_Nombre))
and C.DNI = M.Cli_Dni
join LAS_PELOTAS.boletos_de_compra bc on m.Paquete_FechaCompra = bc.FECHA_COMPRA and bc.CLIENTE_ID = c.ID
join LAS_PELOTAS.aeronaves A on M.Aeronave_Matricula = A.MATRICULA
join LAS_PELOTAS.vuelos v on v.AERONAVE_ID = a.ID and v.RUTA_ID = 
	(SELECT r.id from LAS_PELOTAS.rutas r 
	join LAS_PELOTAS.aeropuertos p1 on m.[Ruta_Ciudad_Origen] = p1.NOMBRE AND p1.ID = r.ORIGEN_ID
	join LAS_PELOTAS.aeropuertos p2 on m.[Ruta_Ciudad_Destino] = p2.NOMBRE AND p2.ID = r.DESTINO_ID
	where m.[Ruta_Codigo] = r.CODIGO and m.FechaSalida = v.FECHA_SALIDA and m.Fecha_LLegada_Estimada = v.FECHA_LLEGADA_ESTIMADA and
	m.FechaLLegada = v.FECHA_LLEGADA) and v.ID=bc.VUELO_ID 
where M.Paquete_Codigo != 0

update LAS_PELOTAS.boletos_de_compra 
set PRECIO_COMPRA= LAS_PELOTAS.precioTotal(id)
update LAS_PELOTAS.boletos_de_compra 
set millas= FLOOR(PRECIO_COMPRA/10)

EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Consultar Millas';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Alta de Cliente';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Alta de Aeronave';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Alta de Tarjeta de Crédito';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Baja de Aeronave';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Baja de Ciudad';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Baja de Cliente';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Modificacion de Aeronave';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Modificacion de Cliente';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Realizar Canje';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Alta de Rol';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Baja de Rol';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Modificacion de Rol';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Alta de Ruta';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Baja de Ruta';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Modificacion de Ruta';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Comprar Pasaje/Encomienda';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Generar Viaje';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Registrar Llegadas';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Consultar Listado';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Administrador', @func ='Cancelar Compra';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Cliente', @func ='Comprar Pasaje/Encomienda';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Cliente', @func ='Consultar Millas';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Cliente', @func ='Realizar Canje';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Cliente', @func ='Alta de Tarjeta de Crédito';
EXEC LAS_PELOTAS.addFuncionalidad @rol='Cliente', @func ='Cancelar Compra'


