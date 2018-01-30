DEFINE CLASS RepositorioBase AS CUSTOM
    * Propiedades.
    PROTECTED cNombreTabla
    PROTECTED cNombreModelo

    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        IF VARTYPE(THIS.cNombreTabla) <> 'C' OR EMPTY(THIS.cNombreTabla) THEN
            RETURN .F.
        ENDIF

        IF VARTYPE(THIS.cNombreModelo) <> 'C' OR EMPTY(THIS.cNombreModelo) THEN
            RETURN .F.
        ENDIF
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerTodos
        LPARAMETERS tcCursor, tcOrdenarPor, tcCondicionFiltro

        * inicio { validación de parámetros }
        IF VARTYPE(tcCursor) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcCursor' debe ser de tipo texto.], 0+16, THIS.Name + '.ObtenerTodos()')
            RETURN .F.
        ENDIF

        IF EMPTY(tcCursor) THEN
            MESSAGEBOX([El parámetro 'tcCursor' no puede quedar en blanco.], 0+16, THIS.Name + '.ObtenerTodos()')
            RETURN .F.
        ENDIF

        IF VARTYPE(tcOrdenarPor) <> 'C' OR tcOrdenarPor <> 'codigo' THEN
            tcOrdenarPor = 'nombre'
        ENDIF

        IF VARTYPE(tcCondicionFiltro) <> 'C' THEN
            tcCondicionFiltro = NULL
        ENDIF
        * fin { validación de parámetros }

        LOCAL llExito, lcSql
        llExito = .F.

        lcSql = 'SELECT codigo, nombre, vigente FROM ' + ALLTRIM(THIS.cNombreTabla) + ' ORDER BY ' + ALLTRIM(tcOrdenarPor)

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
    FUNCTION CodigoExiste
        LPARAMETERS tnCodigo

        * inicio { validación de parámetro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El parámetro 'tnCodigo' debe ser de tipo numérico.], 0+16, THIS.Name + '.CodigoExiste()')
            RETURN .T.
        ENDIF
        * fin { validación de parámetro }

        LOCAL llExisteCodigo
        llExisteCodigo = .T.

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice1'    && codigo.
            IF !SEEK(tnCodigo) THEN
                llExisteCodigo = .F.
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

        RETURN llExisteCodigo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION NombreExiste
        LPARAMETERS tcNombre

        * inicio { validación de parámetro }
        IF VARTYPE(tcNombre) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcNombre' debe ser de tipo texto.], 0+16, THIS.Name + '.NombreExiste()')
            RETURN .T.
        ENDIF
        * fin { validación de parámetro }

        LOCAL llNombreExiste
        llNombreExiste = .T.

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice2'    && nombre.
            IF !SEEK(ALLTRIM(UPPER(tcNombre))) THEN
                llNombreExiste = .F.
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

        RETURN llNombreExiste
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION Agregar
        LPARAMETERS toModelo

        * inicio { validación de parámetro }
        IF VARTYPE(toModelo) <> 'O' THEN
            MESSAGEBOX([El parámetro 'toModelo' debe ser de tipo objeto.], 0+16, THIS.Name + '.Agregar()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        LOCAL llRegistroAgregado
        llRegistroAgregado = .F.

        PRIVATE pnCodigo, pcNombre, plVigente
        pnCodigo = toModelo.ObtenerCodigo()
        pcNombre = toModelo.ObtenerNombre()
        plVigente = toModelo.ObtenerVigente()

        TRY
            INSERT INTO (THIS.cNombreTabla) (codigo, nombre, vigente) ;
                VALUES (pnCodigo, pcNombre, plVigente)

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
        LPARAMETERS toModelo

        * inicio { validación de parámetro }
        IF VARTYPE(toModelo) <> 'O' THEN
            MESSAGEBOX([El parámetro 'toModelo' debe ser de tipo objeto.], 0+16, THIS.Name + '.Modificar()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        LOCAL llRegistroModificado
        llRegistroModificado = .F.

        PRIVATE pnCodigo, pcNombre, plVigente
        pnCodigo = toModelo.ObtenerCodigo()
        pcNombre = toModelo.ObtenerNombre()
        plVigente = toModelo.ObtenerVigente()

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice1'    && codigo.
            IF SEEK(pnCodigo) THEN
                REPLACE nombre WITH pcNombre, ;
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

        * inicio { validación de parámetro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El parámetro 'tnCodigo' debe ser de tipo numérico.], 0+16, THIS.Name + '.Borrar()')
            RETURN .F.
        ENDIF
        * fin { validación de parámetro }

        LOCAL llRegistroBorrado, llEstaRelacionado
        llRegistroBorrado = .F.
        llEstaRelacionado = .T.

        TRY
*!*                * --- {inicio} Órdenes de Trabajo --------------------------------*/
*!*                SELECT ot
*!*                SET ORDER TO TAG 'indice1'    && serie + STR(nroot, 7).
*!*                LOCATE FOR marca = tnCodigo
*!*                IF !FOUND() THEN
*!*                    llEstaRelacionado = .F.
*!*                ENDIF
*!*                * --- {fin} Órdenes de Trabajo -----------------------------------*/

*!*                IF !llEstaRelacionado THEN
*!*                    SELECT marcas2
*!*                    SET ORDER TO TAG 'indice1'    && codigo.
*!*                    IF SEEK(tnCodigo) THEN
*!*                        DELETE
*!*                        llRegistroBorrado = .T.
*!*                    ENDIF
*!*                ENDIF
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

        * inicio { validación de parámetro }
        IF VARTYPE(tnCodigo) <> 'N' THEN
            MESSAGEBOX([El parámetro 'tnCodigo' debe ser de tipo numérico.], 0+16, THIS.Name + '.ObtenerPorCodigo()')
            RETURN NULL
        ENDIF
        * fin { validación de parámetro }

        LOCAL loModelo
        loModelo = NULL

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice1'    && codigo.
            IF SEEK(tnCodigo) THEN
                loModelo = NEWOBJECT(THIS.cNombreModelo, THIS.cNombreModelo + '.prg', NULL, ;
                               codigo, ;
                               nombre, ;
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

        RETURN loModelo
    ENDFUNC

    */ ---------------------------------------------------------------------- */
    FUNCTION ObtenerPorNombre
        LPARAMETERS tcNombre

        * inicio { validación de parámetro }
        IF VARTYPE(tcNombre) <> 'C' THEN
            MESSAGEBOX([El parámetro 'tcNombre' debe ser de tipo texto.], 0+16, THIS.Name + '.ObtenerPorNombre()')
            RETURN NULL
        ENDIF
        * fin { validación de parámetro }

        LOCAL loModelo
        loModelo = NULL

        TRY
            SELECT (THIS.cNombreTabla)
            SET ORDER TO TAG 'indice2'    && nombre.
            IF SEEK(ALLTRIM(UPPER(tcNombre))) THEN
                loModelo = NEWOBJECT(THIS.cNombreModelo, THIS.cNombreModelo + '.prg', NULL, ;
                               codigo, ;
                               nombre, ;
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

        RETURN loModelo
    ENDFUNC
ENDDEFINE
