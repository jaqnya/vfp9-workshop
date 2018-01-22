DEFINE CLASS ValidadorModelo AS ValidadorBase OF ValidadorBase.prg
    * Propiedades.
    PROTECTED nMarca
    PROTECTED cErrorMarca

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS toRepositorio, tnCodigo, tcNombre, tnMarca, tlVigente

        WITH THIS
            .nCodigo = 0
            .cNombre = ''
            .nMarca = 0
            .lVigente = .F.
        ENDWITH

        WITH THIS
            .cErrorCodigo = .ValidarCodigo(toRepositorio, tnCodigo)
            .cErrorNombre = .ValidarNombre(toRepositorio, tcNombre)
            .cErrorMarca = .ValidarMarca(tnMarca)
            .cErrorVigente = .ValidarVigente(tlVigente)
        ENDWITH
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ValidarMarca
        LPARAMETERS tnMarca

        IF VARTYPE(tnMarca) <> 'N' THEN
            RETURN 'Marca: Debe ser de tipo numérico.'
        ENDIF

        IF !BETWEEN(tnMarca, 1, 65535) THEN
            RETURN 'Marca: Debe ser un valor entre 1 y 65535.'
        ENDIF

        LOCAL loRepositorioMarcaOt, loMarca
        loRepositorioMarcaOt = NEWOBJECT('RepositorioMarcaOt', 'RepositorioMarcaOt.prg')

        IF VARTYPE(loRepositorioMarcaOt) = 'O' THEN
            loMarca = loRepositorioMarcaOt.ObtenerPorCodigo(tnMarca)

            IF VARTYPE(loMarca) <> 'O' THEN
                RETURN 'Marca: No existe.'
            ENDIF
        ELSE
            RETURN 'Marca: Repositorio inválido.'
        ENDIF

        THIS.nMarca = tnMarca

        RETURN ''
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerMarca
        RETURN THIS.nMarca
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerErrorMarca
        RETURN THIS.cErrorMarca
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

        IF !EMPTY(THIS.cErrorMarca) THEN
            IF !EMPTY(lcError) THEN
                lcError = lcError + CHR(13)
            ENDIF
            lcError = lcError + THIS.cErrorMarca
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
            EMPTY(THIS.cErrorMarca) AND ;
            EMPTY(THIS.cErrorVigente) THEN
            llRegistroValido = .T.
        ENDIF

        RETURN llRegistroValido
    ENDFUNC
ENDDEFINE