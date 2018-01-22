/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
 *                          BASE DE DATOS (DATABASE)                          *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
DROP DATABASE gestion;

CREATE DATABASE IF NOT EXISTS gestion
    DEFAULT CHARACTER SET utf8
    DEFAULT COLLATE utf8_general_ci;

USE gestion;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
 *                              TABLAS (TABLES)                               *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
CREATE TABLE familia (
    codigo SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    p1 NUMERIC(6,2) NULL DEFAULT NULL,
    p2 NUMERIC(6,2) NULL DEFAULT NULL,
    p3 NUMERIC(6,2) NULL DEFAULT NULL,
    p4 NUMERIC(6,2) NULL DEFAULT NULL,
    p5 NUMERIC(6,2) NULL DEFAULT NULL,
    vigente TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE familia
    ADD CONSTRAINT pk_familia_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_familia_nombre
        UNIQUE KEY (nombre),
    ADD CONSTRAINT chk_familia_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_familia_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_familia_p1
        CHECK (p1 IS NULL OR p1 > 0),
    ADD CONSTRAINT chk_familia_p2
        CHECK (p2 IS NULL OR p2 > 0),
    ADD CONSTRAINT chk_familia_p3
        CHECK (p3 IS NULL OR p3 > 0),
    ADD CONSTRAINT chk_familia_p4
        CHECK (p4 IS NULL OR p4 > 0),
    ADD CONSTRAINT chk_familia_p5
        CHECK (p5 IS NULL OR p5 > 0),
    ADD CONSTRAINT chk_familia_vigente
        CHECK (vigente IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE rubro (
    codigo SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    vigente TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE rubro
    ADD CONSTRAINT pk_rubro_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_rubro_nombre
        UNIQUE KEY (nombre),
    ADD CONSTRAINT chk_rubro_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_rubro_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_rubro_vigente
        CHECK (vigente IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE subrubro (
    codigo SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    vigente TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE subrubro
    ADD CONSTRAINT pk_subrubro_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_subrubro_nombre
        UNIQUE KEY (nombre),
    ADD CONSTRAINT chk_subrubro_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_subrubro_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_subrubro_vigente
        CHECK (vigente IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE marca (
    codigo SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    vigente TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE marca
    ADD CONSTRAINT pk_marca_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_marca_nombre
        UNIQUE KEY (nombre),
    ADD CONSTRAINT chk_marca_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_marca_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_marca_vigente
        CHECK (vigente IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE marca_ot (
    codigo SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    vigente TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE marca_ot
    ADD CONSTRAINT pk_marca_ot_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_marca_ot_nombre
        UNIQUE KEY (nombre),
    ADD CONSTRAINT chk_marca_ot_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_marca_ot_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_marca_ot_vigente
        CHECK (vigente IN (0, 1));


/* -------------------------------------------------------------------------- */
CREATE TABLE unidad (
    codigo SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    vigente TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE unidad
    ADD CONSTRAINT pk_unidad_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_unidad_nombre
        UNIQUE KEY (nombre),
    ADD CONSTRAINT chk_unidad_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_unidad_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_unidad_vigente
        CHECK (vigente IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE cabecob (
    tiporeci TINYINT UNSIGNED NOT NULL,
    nroreci MEDIUMINT UNSIGNED NOT NULL,
    fechareci DATE NULL DEFAULT NULL,
    id_local SMALLINT UNSIGNED NULL DEFAULT NULL,
    moneda SMALLINT UNSIGNED NULL DEFAULT NULL,
    tipocambio NUMERIC(9,2) NULL DEFAULT NULL,
    factura CHAR(1) NULL DEFAULT NULL,
    cliente MEDIUMINT UNSIGNED NULL DEFAULT NULL,
    cobrador SMALLINT UNSIGNED NULL DEFAULT NULL,
    comision NUMERIC(6,2) NULL DEFAULT NULL,
    monto_cobr NUMERIC(12,2) NULL DEFAULT NULL,
    fechaanu DATE NULL DEFAULT NULL,
    anulado TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE cabecob
    ADD CONSTRAINT pk_cabecob_numero
        PRIMARY KEY (tiporeci, nroreci);

/* -------------------------------------------------------------------------- */
CREATE TABLE detacob (
    tiporeci TINYINT UNSIGNED NOT NULL,
    nroreci MEDIUMINT UNSIGNED NOT NULL,
    tipodocu TINYINT UNSIGNED NOT NULL,
    nrodocu MEDIUMINT UNSIGNED NOT NULL,
    nrocuota TINYINT UNSIGNED NOT NULL,
    fechadocu DATE NOT NULL,
    monto NUMERIC(12,2) NOT NULL,
    id_local SMALLINT UNSIGNED NULL DEFAULT NULL
) ENGINE=InnoDB;

ALTER TABLE detacob
    ADD CONSTRAINT fk_detacob_numero
        FOREIGN KEY (tiporeci, nroreci) REFERENCES cabecob (tiporeci, nroreci)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT;

/* -------------------------------------------------------------------------- */
CREATE TABLE cabevent (
    tipodocu TINYINT UNSIGNED NOT NULL,
    nrodocu MEDIUMINT UNSIGNED NOT NULL,
    lstprecio TINYINT UNSIGNED NULL DEFAULT NULL,
    fechadocu DATE NULL DEFAULT NULL,
    horadocu CHAR(8) NULL DEFAULT NULL,
    serie CHAR(1) NULL DEFAULT NULL,
    nroot MEDIUMINT UNSIGNED NULL DEFAULT NULL,
    moneda SMALLINT UNSIGNED NULL DEFAULT NULL,
    tipocambio NUMERIC(9,2) NULL DEFAULT NULL,
    qty_cuotas TINYINT UNSIGNED NULL DEFAULT NULL,
    id_plazo SMALLINT UNSIGNED NULL DEFAULT NULL,
    nroremi MEDIUMINT UNSIGNED NULL DEFAULT NULL,
    fecharemi DATE NULL DEFAULT NULL,
    cliente MEDIUMINT UNSIGNED NULL DEFAULT NULL,
    vendedor SMALLINT UNSIGNED NULL DEFAULT NULL,
    comision_1 NUMERIC(6,2) NULL DEFAULT NULL,
    comision_2 NUMERIC(6,2) NULL DEFAULT NULL,
    comision_3 NUMERIC(6,2) NULL DEFAULT NULL,
    porcdesc NUMERIC(8,4) NULL DEFAULT NULL,
    importdesc NUMERIC(12,2) NULL DEFAULT NULL,
    descuento NUMERIC(8,4) NULL DEFAULT NULL,
    impreso TINYINT UNSIGNED NULL DEFAULT NULL,
    fechaanu DATE NULL DEFAULT NULL,
    anulado TINYINT UNSIGNED NOT NULL DEFAULT 0,
    monto_fact NUMERIC(12,2) NULL DEFAULT NULL,
    monto_cobr NUMERIC(12,2) NULL DEFAULT NULL,
    monto_ndeb NUMERIC(12,2) NULL DEFAULT NULL,
    monto_ncre NUMERIC(12,2) NULL DEFAULT NULL,
    consignaci TINYINT UNSIGNED NULL DEFAULT NULL,
    id_local SMALLINT UNSIGNED NULL DEFAULT NULL
) ENGINE=InnoDB;

ALTER TABLE cabevent
    ADD CONSTRAINT pk_cabevent_numero
        PRIMARY KEY (tipodocu, nrodocu);

/* -------------------------------------------------------------------------- */
CREATE TABLE detavent (
    tipodocu TINYINT UNSIGNED NOT NULL,
    nrodocu MEDIUMINT UNSIGNED NOT NULL,
    articulo VARCHAR(15) NOT NULL,
    cantidad NUMERIC(9,2) NOT NULL,
    precio NUMERIC(13,4) NOT NULL,
    pdescuento NUMERIC(7,4) NULL DEFAULT NULL,
    impuesto TINYINT UNSIGNED NOT NULL DEFAULT 0,
    pimpuesto NUMERIC(6,2) NULL DEFAULT NULL,
    mecanico SMALLINT UNSIGNED NULL DEFAULT NULL,
    comision_m NUMERIC(6,2) NULL DEFAULT NULL,
    descr_trab VARCHAR(40) NULL DEFAULT NULL,
    id_local SMALLINT UNSIGNED NULL DEFAULT NULL
) ENGINE=InnoDB;

ALTER TABLE detavent
    ADD CONSTRAINT fk_detavent_numero
        FOREIGN KEY (tipodocu, nrodocu) REFERENCES cabevent (tipodocu, nrodocu)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT;
