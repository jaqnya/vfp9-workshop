DEFINE CLASS RepositorioMarca AS RepositorioBase OF RepositorioBase.prg
    */ ---------------------------------------------------------------------- */
    FUNCTION Init
        WITH THIS
            .cNombreTabla = 'marcas1'
            .cNombreModelo = 'Marca'
        ENDWITH

        IF !RepositorioBase::Init() THEN
            RETURN .F.
        ENDIF
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
            * --- {inicio} Artículos -----------------------------------------*/
            SELECT maesprod
            SET ORDER TO TAG 'indice5'    && marca.
            IF !SEEK(tnCodigo) THEN
                llEstaRelacionado = .F.
            ENDIF
            * --- {fin} Artículos --------------------------------------------*/

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
ENDDEFINE