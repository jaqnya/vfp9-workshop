DEFINE CLASS RepositorioUsuario AS RepositorioBase OF RepositorioBase.prg
    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        WITH THIS
            .cNombreTabla = 'usuarios'
            .cNombreModelo = 'Usuario'
        ENDWITH

        IF !RepositorioBase::Init() THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerTodos
        LPARAMETERS tcCursor, tcOrdenarPor, tcCondicionFiltro

        * inicio { validaci�n de par�metros }
        IF VARTYPE(tcCursor) <> 'C' THEN
            MESSAGEBOX([El par�metro 'tcCursor' debe ser de tipo texto.], 0+16, THIS.Name + '.ObtenerTodos()')
            RETURN .F.
        ENDIF

        IF EMPTY(tcCursor) THEN
            MESSAGEBOX([El par�metro 'tcCursor' no puede quedar en blanco.], 0+16, THIS.Name + '.ObtenerTodos()')
            RETURN .F.
        ENDIF

        IF VARTYPE(tcOrdenarPor) <> 'C' OR tcOrdenarPor <> 'codigo' THEN
            tcOrdenarPor = 'nombre'
        ENDIF

        IF VARTYPE(tcCondicionFiltro) <> 'C' THEN
            tcCondicionFiltro = NULL
        ENDIF
        * fin { validaci�n de par�metros }

        LOCAL llExito, lcSql
        llExito = .F.

        lcSql = 'SELECT codigo, nombre, clave, vigente FROM ' + ALLTRIM(THIS.cNombreTabla) + ' ORDER BY ' + ALLTRIM(tcOrdenarPor)

        IF !ISNULL(tcCondicionFiltro) THEN
            lcSql = lcSql + ' WHERE ' + tcCondicionFiltro
        ENDIF

        lcSql = lcSql + ' INTO CURSOR ' + tcCursor

        TRY
            &lcSql
            llExito = .T.
        CATCH TO loException
            MESSAGEBOX('ErrorNo: ' + ALLTRIM(STR(loException.ErrorNo)) + CHR(13) + ;
                       'LineNo: ' + ALLTRIM(STR(loException.LineNo)) + CHR(13) + ;
                       'Message: ' + ALLTRIM(loException.Message) + CHR(13) + ;
                       'Procedure: ' + ALLTRIM(loException.Procedure) + CHR(13) + ;
                       'Details: ' + ALLTRIM(loException.Details) + CHR(13) + ;
                       'StackLevel: ' + ALLTRIM(STR(loException.StackLevel)) + CHR(13) + ;
                       'LineContents: ' + ALLTRIM(loException.LineContents), 0+16, 'An error has occurred!')
        ENDTRY

        RETURN llExito
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION Agregar
        LPARAMETERS toUsuario

        * inicio { validaci�n de par�metro }
        IF VARTYPE(toUsuario) <> 'O' THEN
            MESSAGEBOX([El par�metro 'toUsuario' debe ser de tipo objeto.], 0+16, THIS.Name + '.Agregar()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        LOCAL llRegistroAgregado
        llRegistroAgregado = .F.

        PRIVATE pnCodigo, pcNombre, pcClave, plVigente
        pnCodigo = toUsuario.ObtenerCodigo()
        pcNombre = toUsuario.ObtenerNombre()
        pcClave = toUsuario.ObtenerClave()
        plVigente = toUsuario.ObtenerVigente()

        TRY
            INSERT INTO (THIS.cNombreTabla) (codigo, nombre, clave, vigente) ;
                VALUES (pnCodigo, pcNombre, pcClave, plVigente)

            llRegistroAgregado = .T.
        CATCH TO loException
            MESSAGEBOX('ErrorNo: ' + ALLTRIM(STR(loException.ErrorNo)) + CHR(13) + ;
                       'LineNo: ' + ALLTRIM(STR(loException.LineNo)) + CHR(13) + ;
                       'Message: ' + ALLTRIM(loException.Message) + CHR(13) + ;
                       'Procedure: ' + ALLTRIM(loException.Procedure) + CHR(13) + ;
                       'Details: ' + ALLTRIM(loException.Details) + CHR(13) + ;
                       'StackLevel: ' + ALLTRIM(STR(loException.StackLevel)) + CHR(13) + ;
                       'LineContents: ' + ALLTRIM(loException.LineContents), 0+16, 'An error has occurred!')
        ENDTRY

        RETURN llRegistroAgregado
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION Modificar
        LPARAMETERS toUsuario

        * inicio { validaci�n de par�metro }
        IF VARTYPE(toUsuario) <> 'O' THEN
            MESSAGEBOX([El par�metro 'toUsuario' debe ser de tipo objeto.], 0+16, THIS.Name + '.Modificar()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        LOCAL llRegistroModificado
        llRegistroModificado = .F.

        PRIVATE pnCodigo, pcNombre, pcClave, plVigente
        pnCodigo = toUsuario.ObtenerCodigo()
        pcNombre = toUsuario.ObtenerNombre()
        pcClave = toUsuario.ObtenerClave()
        plVigente = toUsuario.ObtenerVigente()

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice1'    && codigo.
            IF SEEK(pnCodigo) THEN
                REPLACE nombre WITH pcNombre, ;
                        clave WITH pcClave, ;
                        vigente WITH plVigente
                llRegistroModificado = .T.
            ENDIF
        CATCH TO loException
            MESSAGEBOX('ErrorNo: ' + ALLTRIM(STR(loException.ErrorNo)) + CHR(13) + ;
                       'LineNo: ' + ALLTRIM(STR(loException.LineNo)) + CHR(13) + ;
                       'Message: ' + ALLTRIM(loException.Message) + CHR(13) + ;
                       'Procedure: ' + ALLTRIM(loException.Procedure) + CHR(13) + ;
                       'Details: ' + ALLTRIM(loException.Details) + CHR(13) + ;
                       'StackLevel: ' + ALLTRIM(STR(loException.StackLevel)) + CHR(13) + ;
                       'LineContents: ' + ALLTRIM(loException.LineContents), 0+16, 'An error has occurred!')
        ENDTRY

        RETURN llRegistroModificado
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION Borrar
        LPARAMETERS tnCodigo

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El par�metro 'tnCodigo' debe ser de tipo num�rico.], 0+16, THIS.Name + '.Borrar()')
            RETURN .F.
        ENDIF
        * fin { validaci�n de par�metro }

        LOCAL llRegistroBorrado, llEstaRelacionado
        llRegistroBorrado = .F.
        llEstaRelacionado = .T.

        TRY
            * --- {inicio} Permisos de usuarios ------------------------------*/
            SELECT usercfg
            SET ORDER TO TAG 'indice1'    && STR(usuario, 4) + prgname.
            LOCATE FOR usuario = tnCodigo
            IF !FOUND() THEN
                llEstaRelacionado = .F.
            ENDIF
            * --- {fin} Permisos de usuarios ---------------------------------*/

            IF !llEstaRelacionado THEN
                SELECT (THIS.cNombreTabla)
                SET ORDER TO TAG 'indice1'    && codigo.
                IF SEEK(tnCodigo) THEN
                    DELETE
                    llRegistroBorrado = .T.
                ENDIF
            ENDIF
        CATCH TO loException
            MESSAGEBOX('ErrorNo: ' + ALLTRIM(STR(loException.ErrorNo)) + CHR(13) + ;
                       'LineNo: ' + ALLTRIM(STR(loException.LineNo)) + CHR(13) + ;
                       'Message: ' + ALLTRIM(loException.Message) + CHR(13) + ;
                       'Procedure: ' + ALLTRIM(loException.Procedure) + CHR(13) + ;
                       'Details: ' + ALLTRIM(loException.Details) + CHR(13) + ;
                       'StackLevel: ' + ALLTRIM(STR(loException.StackLevel)) + CHR(13) + ;
                       'LineContents: ' + ALLTRIM(loException.LineContents), 0+16, 'An error has occurred!')
        ENDTRY

        RETURN llRegistroBorrado
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerPorCodigo
        LPARAMETERS tnCodigo

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El par�metro 'tnCodigo' debe ser de tipo num�rico.], 0+16, THIS.Name + '.ObtenerPorCodigo()')
            RETURN NULL
        ENDIF
        * fin { validaci�n de par�metro }

        LOCAL loUsuario
        loUsuario = NULL

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice1'    && codigo.
            IF SEEK(tnCodigo) THEN
                loUsuario = NEWOBJECT(THIS.cNombreModelo, THIS.cNombreModelo + '.prg', NULL, ;
                               codigo, ;
                               nombre, ;
                               clave, ;
                               vigente ;
                           )
            ENDIF
        CATCH TO loException
            MESSAGEBOX('ErrorNo: ' + ALLTRIM(STR(loException.ErrorNo)) + CHR(13) + ;
                       'LineNo: ' + ALLTRIM(STR(loException.LineNo)) + CHR(13) + ;
                       'Message: ' + ALLTRIM(loException.Message) + CHR(13) + ;
                       'Procedure: ' + ALLTRIM(loException.Procedure) + CHR(13) + ;
                       'Details: ' + ALLTRIM(loException.Details) + CHR(13) + ;
                       'StackLevel: ' + ALLTRIM(STR(loException.StackLevel)) + CHR(13) + ;
                       'LineContents: ' + ALLTRIM(loException.LineContents), 0+16, 'An error has occurred!')
        ENDTRY

        RETURN loUsuario
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerPorNombre
        LPARAMETERS tcNombre

        * inicio { validaci�n de par�metro }
        IF VARTYPE(tcNombre) <> 'C' THEN
            MESSAGEBOX([El par�metro 'tcNombre' debe ser de tipo texto.], 0+16, THIS.Name + '.ObtenerPorNombre()')
            RETURN NULL
        ENDIF
        * fin { validaci�n de par�metro }

        LOCAL loUsuario
        loUsuario = NULL

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice2'    && nombre.
            IF SEEK(ALLTRIM(UPPER(tcNombre))) THEN
                loUsuario = NEWOBJECT(THIS.cNombreModelo, THIS.cNombreModelo + '.prg', NULL, ;
                               codigo, ;
                               nombre, ;
                               clave, ;
                               vigente ;
                           )
            ENDIF
        CATCH TO loException
            MESSAGEBOX('ErrorNo: ' + ALLTRIM(STR(loException.ErrorNo)) + CHR(13) + ;
                       'LineNo: ' + ALLTRIM(STR(loException.LineNo)) + CHR(13) + ;
                       'Message: ' + ALLTRIM(loException.Message) + CHR(13) + ;
                       'Procedure: ' + ALLTRIM(loException.Procedure) + CHR(13) + ;
                       'Details: ' + ALLTRIM(loException.Details) + CHR(13) + ;
                       'StackLevel: ' + ALLTRIM(STR(loException.StackLevel)) + CHR(13) + ;
                       'LineContents: ' + ALLTRIM(loException.LineContents), 0+16, 'An error has occurred!')
        ENDTRY

        RETURN loUsuario
    ENDFUNC
ENDDEFINE