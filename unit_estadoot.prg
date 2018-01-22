CLEAR
CLEAR ALL
CLOSE ALL

poConexion = NEWOBJECT('Conexion', 'Conexion.prg')

LOCAL lnCodigo, lcNombre, llVigente
lnCodigo = 200
lcNombre = 'NUEVA ESTADO 2000'
llVigente = .T.


loRepositorio = NEWOBJECT('RepositorioEstadoOt', 'RepositorioEstadoOt.prg')

IF VARTYPE(loRepositorio) = 'O' THEN
    loValidador = NEWOBJECT('ValidadorEstadoOt', 'ValidadorEstadoOt.prg', NULL, ;
                      loRepositorio, ;
                      lnCodigo, ;
                      lcNombre, ;
                      llVigente ;
                  )

    IF VARTYPE(loValidador) = 'O' THEN
        IF loValidador.RegistroValido() THEN
            loEstadoOt = NEWOBJECT('EstadoOt', 'EstadoOt.prg', NULL, ;
                           loValidador.ObtenerCodigo(), ;
                           loValidador.ObtenerNombre(), ;
                           loValidador.ObtenerVigente() ;
                       )

            IF VARTYPE(loEstadoOt) = 'O' THEN
                IF loRepositorio.Agregar(loEstadoOt) THEN
                    MESSAGEBOX('El registro ha sido agregado correctamente.', 0+64, 'Aviso', 5000)
                    ? loValidador.ObtenerCodigo()
                    ? loValidador.ObtenerNombre()
                    ? loValidador.ObtenerVigente()
                ENDIF
            ELSE
                MESSAGEBOX('No se pudo crear el objeto EstadoOt.', 0+16, 'Aviso')
            ENDIF
        ELSE
            MESSAGEBOX(loValidador.ObtenerError(), 0+48, 'Aviso')
        ENDIF
    ELSE
        MESSAGEBOX('No se pudo crear el objeto validador.', 0+16, 'Aviso')
    ENDIF
ELSE
    MESSAGEBOX('No se pudo crear el objeto repositorio.', 0+16, 'Aviso')
ENDIF