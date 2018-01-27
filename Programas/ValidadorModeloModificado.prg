DEFINE CLASS ValidadorModeloModificado AS ValidadorModelo OF ValidadorModelo.prg
    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarCodigo
        LPARAMETERS toRepositorio, tnCodigo

        IF VARTYPE(tnCodigo) <> 'N' THEN
            RETURN 'Código: Debe ser de tipo numérico.'
        ENDIF

        IF !BETWEEN(tnCodigo, 1, 9999) THEN
            RETURN 'Código: Debe ser un valor entre 1 y 9999.'
        ENDIF

        IF !toRepositorio.CodigoExiste(tnCodigo) THEN
            RETURN 'Código: No existe.'
        ENDIF

        THIS.nCodigo = tnCodigo

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarNombre
        LPARAMETERS toRepositorio, tcNombre

        IF THIS.nCodigo <= 0 THEN
            RETURN 'Nombre: El código debe ser válido.'
        ENDIF

        IF VARTYPE(tcNombre) <> 'C' THEN
            RETURN 'Nombre: Debe ser de tipo texto.'
        ENDIF

        IF EMPTY(tcNombre) THEN
            RETURN 'Nombre: No puede quedar en blanco.'
        ENDIF

        IF LEN(tcNombre) < 3 THEN
            RETURN 'Nombre: Debe ser como mínimo de 3 caracteres.'
        ENDIF

        IF LEN(tcNombre) > 30 THEN
            RETURN 'Nombre: Debe ser como máximo de 30 caracteres.'
        ENDIF

        LOCAL loModelo
        loModelo = toRepositorio.ObtenerPorNombre(tcNombre)

        IF VARTYPE(loModelo) = 'O' THEN    && si encuentra un registro.
            IF loModelo.ObtenerCodigo() <> THIS.nCodigo THEN
                RETURN 'Nombre: Ya existe.'
            ENDIF
        ENDIF

        THIS.cNombre = ALLTRIM(UPPER(tcNombre))

        RETURN ''
    ENDFUNC
ENDDEFINE