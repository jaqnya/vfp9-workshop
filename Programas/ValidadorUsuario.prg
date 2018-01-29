DEFINE CLASS ValidadorUsuario AS ValidadorBase OF ValidadorBase.prg
    * Propiedades.
    PROTECTED cClave
    PROTECTED cErrorClave

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS toRepositorio, tnCodigo, tcNombre, tcClave, tlVigente

        WITH THIS
            .nCodigo = 0
            .cNombre = ''
            .cClave = ''
            .lVigente = .F.
        ENDWITH

        WITH THIS
            .cErrorCodigo = .ValidarCodigo(toRepositorio, tnCodigo)
            .cErrorNombre = .ValidarNombre(toRepositorio, tcNombre)
            .cErrorClave = .ValidarClave(tcClave)
            .cErrorVigente = .ValidarVigente(tlVigente)
        ENDWITH
    ENDFUNC
    
    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarCodigo
        LPARAMETERS toRepositorio, tnCodigo

        IF VARTYPE(tnCodigo) <> 'N' THEN
            RETURN 'Código: Debe ser de tipo numérico.'
        ENDIF

        IF !BETWEEN(tnCodigo, 1, 9999) THEN
            RETURN 'Código: Debe ser un valor entre 1 y 9999.'
        ENDIF

        IF toRepositorio.CodigoExiste(tnCodigo) THEN
            RETURN 'Código: Ya existe.'
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
            RETURN 'Nombre: Debe ser como mínimo de 3 caracteres.'
        ENDIF

        IF LEN(tcNombre) > 30 THEN
            RETURN 'Nombre: Debe ser como máximo de 30 caracteres.'
        ENDIF

        IF toRepositorio.NombreExiste(tcNombre) THEN
            RETURN 'Nombre: Ya existe.'
        ENDIF

        THIS.cNombre = ALLTRIM(UPPER(tcNombre))

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarClave
        LPARAMETERS tcClave

        IF VARTYPE(tcClave) <> 'C' THEN
            RETURN 'Clave: Debe ser de tipo texto.'
        ENDIF

        IF EMPTY(tcClave) THEN
            RETURN 'Clave: No puede quedar en blanco.'
        ENDIF

        IF LEN(tcClave) < 6 THEN
            RETURN 'Clave: Debe ser como mínimo de 6 caracteres.'
        ENDIF

        IF LEN(tcclave) > 15 THEN
            RETURN 'Clave: Debe ser como máximo de 15 caracteres.'
        ENDIF

        THIS.cClave = ALLTRIM(tcClave)

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerClave
        RETURN THIS.cClave
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerErrorClave
        RETURN THIS.cErrorClave
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerError
        LOCAL lcError
        lcError = THIS.cErrorCodigo

        IF !EMPTY(THIS.cErrorNombre) THEN
            IF !EMPTY(lcError) THEN
                lcError = lcError + CHR(13)
            ENDIF
            lcError = lcError + THIS.cErrorNombre
        ENDIF

        IF !EMPTY(THIS.cErrorClave) THEN
            IF !EMPTY(lcError) THEN
                lcError = lcError + CHR(13)
            ENDIF
            lcError = lcError + THIS.cErrorClave
        ENDIF

        IF !EMPTY(THIS.cErrorVigente) THEN
            IF !EMPTY(lcError) THEN
                lcError = lcError + CHR(13)
            ENDIF
            lcError = lcError + THIS.cErrorVigente
        ENDIF

        IF !EMPTY(lcError) THEN
           lcError = 'No se puede validar el registro actual, porque: ' + CHR(13) + CHR(13) + lcError
        ENDIF

        RETURN lcError
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION RegistroValido
        llRegistroValido = .F.

        IF EMPTY(THIS.cErrorCodigo) AND ;
            EMPTY(THIS.cErrorNombre) AND ;
            EMPTY(THIS.cErrorClave) AND ;
            EMPTY(THIS.cErrorVigente) THEN
            llRegistroValido = .T.
        ENDIF

        RETURN llRegistroValido
    ENDFUNC
ENDDEFINE