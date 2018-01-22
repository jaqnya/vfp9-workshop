DEFINE CLASS Modelo AS ModeloBase OF ModeloBase.prg
    * Propiedad.
    PROTECTED nMarca

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS tnCodigo, tcNombre, tnMarca, tlVigente

        IF !THIS.CambiarCodigo(tnCodigo) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarNombre(tcNombre) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarMarca(tnMarca) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarVigente(tlVigente) THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerMarca
        RETURN THIS.nMarca
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarMarca
        LPARAMETERS tnMarca

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tnMarca) <> 'N' THEN
            MESSAGEBOX([El par�metro 'tnMarca' debe ser de tipo num�rico.], 0+16, THIS.Name + '.CambiarMarca()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        THIS.nMarca = tnMarca
    ENDFUNC
ENDDEFINE

*!*	CREATE TABLE modelo ( ;
*!*	    codigo N(4), ;
*!*	    nombre C(30), ;
*!*	    marca N(4), ;
*!*	    vigente L(1) ;
*!*	)

*!*	INDEX ON codigo TAG 'indice1'
*!*	INDEX on nombre TAG 'indice2'