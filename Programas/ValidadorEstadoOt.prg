DEFINE CLASS ValidadorEstadoOt AS ValidadorBase OF ValidadorBase.prg
    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarCodigo
        LPARAMETERS toRepositorio, tnCodigo

        IF VARTYPE(tnCodigo) <> 'N' THEN
            RETURN 'C�digo: Debe ser de tipo num�rico.'
        ENDIF

        IF !BETWEEN(tnCodigo, 1, 999) THEN
            RETURN 'C�digo: Debe ser un valor entre 1 y 999.'
        ENDIF

        IF toRepositorio.CodigoExiste(tnCodigo) THEN
            RETURN 'C�digo: Ya existe.'
        ENDIF

        THIS.nCodigo = tnCodigo

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarNombre
        LPARAMETERS toRepositorio, tcNombre

        IF VARTYPE(tcNombre) <> 'C' THEN
            RETURN 'Nombre: Debe ser de tipo texto.'
        ENDIF

        IF EMPTY(tcNombre) THEN
            RETURN 'Nombre: No puede quedar en blanco.'
        ENDIF

        IF LEN(tcNombre) < 3 THEN
            RETURN 'Nombre: Debe ser como m�nimo de 3 caracteres.'
        ENDIF

        IF LEN(tcNombre) > 30 THEN
            RETURN 'Nombre: Debe ser como m�ximo de 30 caracteres.'
        ENDIF

        IF toRepositorio.NombreExiste(tcNombre) THEN
            RETURN 'Nombre: Ya existe.'
        ENDIF

        THIS.cNombre = ALLTRIM(UPPER(tcNombre))

        RETURN ''
    ENDFUNC
ENDDEFINE