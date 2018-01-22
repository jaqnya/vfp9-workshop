DEFINE CLASS ValidadorBase AS CUSTOM
    * Propiedades.
    PROTECTED nCodigo
    PROTECTED cNombre
    PROTECTED lVigente

    PROTECTED cErrorCodigo
    PROTECTED cErrorNombre
    PROTECTED cErrorVigente

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS toRepositorio, tnCodigo, tcNombre, tlVigente

        WITH THIS
            .nCodigo = 0
            .cNombre = ''
            .lVigente = .F.
        ENDWITH

        WITH THIS
            .cErrorCodigo = .ValidarCodigo(toRepositorio, tnCodigo)
            .cErrorNombre = .ValidarNombre(toRepositorio, tcNombre)
            .cErrorVigente = .ValidarVigente(tlVigente)
        ENDWITH
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarCodigo
        LPARAMETERS toRepositorio, tnCodigo

        IF VARTYPE(tnCodigo) <> 'N' THEN
            RETURN 'Código: Debe ser de tipo numérico.'
        ENDIF

        IF !BETWEEN(tnCodigo, 1, 65535) THEN
            RETURN 'Código: Debe ser un valor entre 1 y 65535.'
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

        IF LEN(tcNombre) > 50 THEN
            RETURN 'Nombre: Debe ser como máximo de 50 caracteres.'
        ENDIF

        IF toRepositorio.NombreExiste(tcNombre) THEN
            RETURN 'Nombre: Ya existe.'
        ENDIF

        THIS.cNombre = ALLTRIM(UPPER(tcNombre))

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarVigente
        LPARAMETERS tlVigente

        IF VARTYPE(tlVigente) <> 'L' THEN
            RETURN 'Vigente: Debe ser de tipo lógico.'
        ENDIF

        THIS.lVigente = tlVigente

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerCodigo
        RETURN THIS.nCodigo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerNombre
        RETURN THIS.cNombre
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerVigente
        RETURN THIS.lVigente
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerErrorCodigo
        RETURN THIS.cErrorCodigo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerErrorNombre
        RETURN THIS.cErrorNombre
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerErrorVigente
        RETURN THIS.cErrorVigente
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
            EMPTY(THIS.cErrorVigente) THEN
            llRegistroValido = .T.
        ENDIF

        RETURN llRegistroValido
    ENDFUNC
ENDDEFINE