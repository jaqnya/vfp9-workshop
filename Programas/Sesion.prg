DEFINE CLASS Sesion AS CUSTOM
    * Propiedades.
    PROTECTED cRuta
    PROTECTED oUsuario

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION Init
        IF !THIS.ObtenerRuta() THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ObtenerRuta
        IF !FILE('config' + '.dat') THEN
            MESSAGEBOX([El archivo de datos 'config.dat' no existe.], 0+16, THIS.Name + '.ObtenerRuta()')
            RETURN .F.
        ENDIF

        IF !USED('config') THEN
            TRY
                USE config.dat IN 0 AGAIN ORDER 0 SHARED

                SELECT config
                THIS.cRuta = ADDBS(ALLTRIM(ruta))
                USE
            CATCH
                MESSAGEBOX([No se pudo acceder al archivo 'config.dat', vuelva a intentarlo más tarde.], 0+16, THIS.Name + '.ObtenerRuta()')
            ENDTRY
        ENDIF

        RETURN IIF(VARTYPE(THIS.cRuta) <> 'C' OR EMPTY(THIS.cRuta), .F., .T.)
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION AbrirTablas
        IF VARTYPE(THIS.cRuta) <> 'C' OR EMPTY(THIS.cRuta) THEN
            MESSAGEBOX('La ruta de acceso no es válida.', 0+16, THIS.Name + '.AbrirTablas()')
            RETURN .F.
        ENDIF

        IF !FILE(THIS.cRuta + 'usuarios.dbf') THEN
            MESSAGEBOX([El archivo de datos 'usuarios.dbf' no existe.], 0+16, THIS.Name + '.AbrirTablas()')
            RETURN .F.
        ENDIF

        IF !FILE(THIS.cRuta + 'usuarios.cdx') THEN
            MESSAGEBOX([El archivo de índice 'usuarios.cdx' no existe.], 0+16, THIS.Name + '.AbrirTablas()')
            RETURN .F.
        ENDIF

        IF !USED('usuarios') THEN
            TRY
                USE (THIS.cRuta + 'usuarios') IN 0 AGAIN ORDER 0 SHARED
            CATCH
                MESSAGEBOX([No se pudo acceder al archivo 'usuarios.dbf', vuelva a intentarlo más tarde.], 0+16, THIS.Name + '.AbrirTablas()')
                RETURN .F.
            ENDTRY
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION CerrarTablas
        IF USED('usuarios') THEN
            SELECT usuarios
            USE
        ENDIF
    ENDFUNC
ENDDEFINE