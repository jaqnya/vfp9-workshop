*
* obtener_nombre_formulario.prg
*
* Derecho de autor (c) 2000-2018 por José Acuña. Todos los derechos reservados.
* Acosta Ñu Nº 143
* Tres Bocas, Villa Elisa, Paraguay
* Teléfono: 021 943125 / Móvil: 0985 943522 ó 0961 512679
* Email: jaqnya@gmail.com
*
* Descripción:
* Captura el texto de la excepción SQL y la muestra en un cuadro de mensaje de error.
*
* Historial:
* Enero 27, 2018    José Acuña    Creación del programa
*
FUNCTION obtener_nombre_formulario
    LPARAMETERS tcFormulario

    * inicio { validación de parámetro }
    IF VARTYPE(tcFormulario) <> 'C' THEN
        MESSAGEBOX([El parámetro 'tcFormulario' debe ser de tipo texto.], 0+16, 'obtener_nombre_formulario()')
        RETURN ''
    ENDIF

    IF EMPTY(tcFormulario) THEN
        MESSAGEBOX([El parámetro 'tcFormulario' no puede quedar en blanco.], 0+16, 'obtener_nombre_formulario()')
        RETURN ''
    ENDIF
    * fin { validación de parámetro }

    LOCAL lcFormulario
    lcFormulario = ALLTRIM(LOWER(tcFormulario))

    DO CASE
    CASE lcFormulario = 'frmbuscarmarca'
        lcFormulario = 'FrmBuscarMarca'
    CASE lcFormulario = 'frmmarca'
        lcFormulario = 'FrmMarca'
    ENDCASE

    RETURN lcFormulario
ENDFUNC