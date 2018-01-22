DEFINE CLASS ModeloBase AS CUSTOM
    * Propiedades.
    PROTECTED nCodigo
    PROTECTED cNombre
    PROTECTED lVigente

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS tnCodigo, tcNombre, tlVigente

        IF !THIS.CambiarCodigo(tnCodigo) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarNombre(tcNombre) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarVigente(tlVigente) THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerCodigo
        RETURN THIS.nCodigo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarCodigo
        LPARAMETERS tnCodigo

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El par�metro 'tnCodigo' debe ser de tipo num�rico.], 0+16, THIS.Name + '.CambiarCodigo()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        THIS.nCodigo = tnCodigo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerNombre
        RETURN THIS.cNombre
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarNombre
        LPARAMETERS tcNombre

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tcNombre) <> 'C' THEN
            MESSAGEBOX([El par�metro 'tcNombre' debe ser de tipo texto.], 0+16, THIS.Name + '.CambiarNombre()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        THIS.cNombre = tcNombre
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerVigente
        RETURN THIS.lVigente
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarVigente
        LPARAMETERS tlVigente

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tlVigente) <> 'L' THEN
            MESSAGEBOX([El par�metro 'tlVigente' debe ser de tipo l�gico.], 0+16, THIS.Name + '.CambiarVigente()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        THIS.lVigente = tlVigente
    ENDFUNC
ENDDEFINE