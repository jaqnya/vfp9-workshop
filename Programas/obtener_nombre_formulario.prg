*
* obtener_nombre_formulario.prg
*
* Derecho de autor (c) 2000-2018 por Jos� Acu�a. Todos los derechos reservados.
* Acosta �u N� 143
* Tres Bocas, Villa Elisa, Paraguay
* Tel�fono: 021 943125 / M�vil: 0985 943522 � 0961 512679
* Email: jaqnya@gmail.com
*
* Descripci�n:
* Captura el texto de la excepci�n SQL y la muestra en un cuadro de mensaje de error.
*
* Historial:
* Enero 27, 2018    Jos� Acu�a    Creaci�n del programa
*
FUNCTION obtener_nombre_formulario
    LPARAMETERS tcFormulario

    * inicio { validaci�n de par�metro }
    IF VARTYPE(tcFormulario) <> 'C' THEN
        MESSAGEBOX([El par�metro 'tcFormulario' debe ser de tipo texto.], 0+16, 'obtener_nombre_formulario()')
        RETURN ''
    ENDIF

    IF EMPTY(tcFormulario) THEN
        MESSAGEBOX([El par�metro 'tcFormulario' no puede quedar en blanco.], 0+16, 'obtener_nombre_formulario()')
        RETURN ''
    ENDIF
    * fin { validaci�n de par�metro }

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