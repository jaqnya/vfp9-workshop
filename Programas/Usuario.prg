DEFINE CLASS Usuario AS ModeloBase OF ModeloBase.prg
    * Propiedad.
    PROTECTED cClave

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS tnCodigo, tcNombre, tcClave, tlVigente

        IF !THIS.CambiarCodigo(tnCodigo) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarNombre(tcNombre) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarClave(tcClave) THEN
            RETURN .F.
        ENDIF

        IF !THIS.CambiarVigente(tlVigente) THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerClave
        RETURN THIS.cClave
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CambiarClave
        LPARAMETERS tcClave

        * inicio { validación de parámetro }
        IF VARTYPE(tcClave) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcClave' debe ser de tipo texto.], 0+16, THIS.Name + '.CambiarClave()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        THIS.cClave = tcClave
    ENDFUNC
ENDDEFINE

*!*	CREATE TABLE usuario ( ;
*!*	    codigo N(4), ;
*!*	    nombre C(30), ;
*!*	    clave C(15), ;
*!*	    vigente L(1) ;
*!*	)

*!*	INDEX ON codigo TAG 'indice1'
*!*	INDEX ON nombre TAG 'indice2'