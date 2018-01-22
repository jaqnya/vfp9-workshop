/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
 *               PROCEDIMIENTOS ALMACENADOS (STORED PROCEDURES)               *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *

/* -------------------------------------------------------------------------- *
 * PA para obtener un código nuevo para la tabla 'marca'.                     *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS pa_marca_codigo_nuevo $$

CREATE FUNCTION pa_marca_codigo_nuevo()
    RETURNS SMALLINT UNSIGNED
BEGIN
    DECLARE v_codigo SMALLINT UNSIGNED DEFAULT 1;

    loop_label: LOOP
        IF NOT EXISTS(SELECT * FROM marca WHERE codigo = v_codigo) THEN
            LEAVE loop_label;
        ELSE
            SET v_codigo = v_codigo + 1;
        END IF;
    END LOOP;

    RETURN v_codigo;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * PA para averiguar si existe un código en la tabla 'marca'.                 *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS pa_marca_codigo_existe $$

CREATE FUNCTION pa_marca_codigo_existe(p_codigo SMALLINT UNSIGNED)
    RETURNS TINYINT UNSIGNED
BEGIN
    DECLARE v_codigo TINYINT UNSIGNED DEFAULT 0;

    SELECT
        COUNT(codigo)
    FROM
        marca
    WHERE
        codigo = p_codigo
    INTO
        v_codigo;

    RETURN v_codigo;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * PA para averiguar si existe un nombre en la tabla 'marca'.                 *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS pa_marca_nombre_existe $$

CREATE FUNCTION pa_marca_nombre_existe(p_nombre VARCHAR(50))
    RETURNS TINYINT UNSIGNED
BEGIN
    DECLARE v_nombre TINYINT UNSIGNED DEFAULT 0;

    SELECT
        COUNT(nombre)
    FROM
        marca
    WHERE
        UPPER(nombre) LIKE UPPER(p_nombre)
    INTO
        v_nombre;

    RETURN v_nombre;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * PA para obtener todos los registros de la tabla 'marca'.                   *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP PROCEDURE IF EXISTS pa_marca_obtener_todos $$

CREATE PROCEDURE pa_marca_obtener_todos()
BEGIN
    SELECT * FROM marca ORDER BY nombre;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * PA para agregar registros en la tabla 'marca'.                             *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS pa_marca_agregar $$

CREATE FUNCTION pa_marca_agregar(p_codigo SMALLINT UNSIGNED,
                                 p_nombre VARCHAR(50),
                                 p_vigente TINYINT)
    RETURNS VARCHAR(100)
BEGIN
    IF p_codigo IS NULL THEN
        RETURN 'Código: No puede ser nulo.';
    END IF;

    IF p_nombre IS NULL THEN
        RETURN 'Nombre: No puede ser nulo.';
    END IF;

    IF p_vigente IS NULL THEN
        RETURN 'Vigente: No puede ser nulo.';
    END IF;

    IF p_codigo <= 0 THEN
        SELECT pa_marca_codigo_nuevo() INTO p_codigo;
    END IF;

    IF p_codigo <= 0 THEN
        RETURN 'Código: Debe ser mayor que cero.';
    END IF;

    IF p_nombre = '' THEN
        RETURN 'Nombre: No puede quedar en blanco.';
    END IF;

    IF p_vigente NOT IN (0, 1) THEN
        RETURN 'Vigente: Debe ser 0 ó 1.';
    END IF;

/*
    IF EXISTS(SELECT * FROM marca WHERE codigo = p_codigo) THEN
        RETURN 'Código: Ya existe.';
    END IF;
*/

    IF (SELECT pa_marca_codigo_existe(p_codigo)) THEN
        RETURN 'Código: Ya existe.';
    END IF;

/*
    IF EXISTS(SELECT * FROM marca WHERE UPPER(nombre) LIKE UPPER(p_nombre)) THEN
        RETURN 'Nombre: Ya existe.';
    END IF;
*/

    IF (SELECT pa_marca_nombre_existe(p_nombre)) THEN
        RETURN 'Nombre: Ya existe.';
    END IF;

    INSERT INTO marca (codigo, nombre, vigente)
        VALUES (p_codigo, p_nombre, p_vigente);

    RETURN NULL;
END $$

DELIMITER ;

/* -------------------------------------------------------------------------- *
 * PA para modificar registros en la tabla 'marca'.                           *
 * -------------------------------------------------------------------------- */
DELIMITER $$

DROP FUNCTION IF EXISTS pa_marca_modificar $$

CREATE FUNCTION pa_marca_modificar(p_codigo SMALLINT UNSIGNED,
                                   p_nombre VARCHAR(50),
                                   p_vigente TINYINT)
    RETURNS VARCHAR(100)
BEGIN
    DECLARE v_nombre VARCHAR(50);
    DECLARE v_vigente TINYINT UNSIGNED;

    IF p_codigo IS NULL THEN
        RETURN 'Código: No puede ser nulo.';
    END IF;

    IF p_nombre IS NULL THEN
        RETURN 'Nombre: No puede ser nulo.';
    END IF;

    IF p_vigente IS NULL THEN
        RETURN 'Vigente: No puede ser nulo.';
    END IF;

    IF p_codigo <= 0 THEN
        RETURN 'Código: Debe ser mayor que cero.';
    END IF;

    IF p_nombre = '' THEN
        RETURN 'Nombre: No puede quedar en blanco.';
    END IF;

    IF p_vigente NOT IN (0, 1) THEN
        RETURN 'Vigente: Debe ser 0 ó 1.';
    END IF;

    IF NOT (SELECT pa_marca_codigo_existe(p_codigo)) THEN
        RETURN 'Código: No existe.';
    END IF;

    IF EXISTS(SELECT * FROM marca WHERE UPPER(nombre) LIKE UPPER(p_nombre) AND codigo <> p_codigo) THEN
        RETURN 'Nombre: Ya existe.';
    END IF;

    SELECT
        nombre,
        vigente
    FROM
        marca
    WHERE
        codigo = p_codigo
    INTO
        v_nombre,
        v_vigente;

    IF v_nombre = p_nombre AND v_vigente = p_vigente THEN
        RETURN NULL;
    END IF;

    UPDATE
        marca
    SET
        nombre = p_nombre,
        vigente = p_vigente
    WHERE
        codigo = p_codigo;

    RETURN NULL;
END $$

DELIMITER ;


* OTRA FORMA DE HACER*

  /* -------------------------------------------------------------------------- *
   * PA para agregar registros en la tabla 'marca'.                             *
   * -------------------------------------------------------------------------- */
  DELIMITER $$
  
  DROP PROCEDURE IF EXISTS pa_marca_agregar $$
  
  CREATE PROCEDURE pa_marca_agregar(IN p_codigo SMALLINT UNSIGNED,
                                    IN p_nombre VARCHAR(50),
                                    IN p_vigente TINYINT)
  BEGIN
      IF p_codigo IS NULL THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Código: No puede ser nulo.│';
      END IF;
  
      IF p_nombre IS NULL THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Nombre: No puede ser nulo.│';
      END IF;
  
      IF p_vigente IS NULL THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Vigente: No puede ser nulo.│';
      END IF;
  
      IF p_codigo <= 0 THEN
          SELECT pa_marca_codigo_nuevo() INTO p_codigo;
      END IF;
  
      IF p_codigo <= 0 THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Código: Debe ser mayor que cero.│';
      END IF;
  
      IF p_nombre = '' THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Nombre: No puede quedar en blanco.│';
      END IF;
  
      IF p_vigente NOT IN (0, 1) THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Vigente: Debe ser 0 ó 1.│';
      END IF;
  
  /*
      IF EXISTS(SELECT * FROM marca WHERE codigo = p_codigo) THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Código: Ya existe.';
      END IF;
  */
  
      IF (SELECT pa_marca_codigo_existe(p_codigo)) THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Código: Ya existe.│';
      END IF;
  
  /*
      IF EXISTS(SELECT * FROM marca WHERE UPPER(nombre) LIKE UPPER(p_nombre)) THEN
          RETURN 'Nombre: Ya existe.';
      END IF;
  */
  
      IF (SELECT pa_marca_nombre_existe(p_nombre)) THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '│Nombre: Ya existe.│';
      END IF;
  
      INSERT INTO marca (codigo, nombre, vigente)
          VALUES (p_codigo, p_nombre, p_vigente);
  END $$
  
  DELIMITER ;
