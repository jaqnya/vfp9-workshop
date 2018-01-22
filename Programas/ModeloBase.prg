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

        * inicio { validación de parámetro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El parámetro 'tnCodigo' debe ser de tipo numérico.], 0+16, THIS.Name + '.CambiarCodigo()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        THIS.nCodigo = tnCodigo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerNombre
        RETURN THIS.cNombre
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarNombre
        LPARAMETERS tcNombre

        * inicio { validación de parámetro }
        IF VARTYPE(tcNombre) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcNombre' debe ser de tipo texto.], 0+16, THIS.Name + '.CambiarNombre()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        THIS.cNombre = tcNombre
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerVigente
        RETURN THIS.lVigente
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarVigente
        LPARAMETERS tlVigente

        * inicio { validación de parámetro }
        IF VARTYPE(tlVigente) <> 'L' THEN
            MESSAGEBOX([El parámetro 'tlVigente' debe ser de tipo lógico.], 0+16, THIS.Name + '.CambiarVigente()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        THIS.lVigente = tlVigente
    ENDFUNC
ENDDEFINE