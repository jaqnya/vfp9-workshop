DEFINE CLASS Sesion AS CUSTOM
    * Propiedades.
    PROTECTED cRuta
    PROTECTED oUsuario

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        LPARAMETERS tnUsuario, tcClave

        * inicio { validación de parámetros }
        IF VARTYPE(tnUsuario) <> 'N' THEN
            MESSAGEBOX([El parámetro 'tnUsuario' debe ser de tipo numérico.], 0+16, THIS.Name + '.Init()')
            RETURN .F.
        ENDIF

        IF VARTYPE(tcClave) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcClave' debe ser de tipo texto.], 0+16, THIS.Name + '.Init()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetros }

        IF !THIS.ObtenerUsuario(tnUsuario, tcClave) THEN
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

    */ ---------------------------------------------------------------------- */
    PROTECTED FUNCTION ObtenerUsuario
        LPARAMETERS tnUsuario, tcClave

        * inicio { validación de parámetros }
        IF VARTYPE(tnUsuario) <> 'N' THEN
            MESSAGEBOX([El parámetro 'tnUsuario' debe ser de tipo numérico.], 0+16, THIS.Name + '.ObtenerUsuario()')
            RETURN .F.
        ENDIF

        IF VARTYPE(tcClave) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcClave' debe ser de tipo texto.], 0+16, THIS.Name + '.ObtenerUsuario()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetros }

        IF !THIS.ObtenerRuta() THEN
            RETURN .F.
        ENDIF

        IF !THIS.AbrirTablas() THEN
            RETURN .F.
        ENDIF

        LOCAL loUsuario, loRepositorio
        loUsuario = NULL
        loRepositorio = NEWOBJECT('RepositorioUsuario', 'RepositorioUsuario.prg')

        IF VARTYPE(loRepositorio) = 'O' THEN
            loUsuario = loRepositorio.ObtenerPorCodigo(tnUsuario)

            IF VARTYPE(loUsuario) = 'O' THEN    && si encuentra un registro.
                IF loUsuario.ObtenerClave() == LEFT(tcClave + SPACE(15), 15) THEN
                    THIS.oUsuario = loUsuario
                ENDIF
            ENDIF
        ELSE
            MESSAGEBOX([No se pudo crear el objeto: Repositorio de Usuarios.], 0+16, THIS.Name + '.ObtenerUsuario()')
        ENDIF

        THIS.CerrarTablas()

        RETURN IIF(VARTYPE(THIS.oUsuario) = 'O', .T., .F.)
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerCodigo
        RETURN IIF(VARTYPE(THIS.oUsuario) = 'O', THIS.oUsuario.ObtenerCodigo(), 0)
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerNombre
        RETURN IIF(VARTYPE(THIS.oUsuario) = 'O', THIS.oUsuario.ObtenerNombre(), '')
    ENDFUNC
ENDDEFINE