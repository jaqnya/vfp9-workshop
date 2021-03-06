CLEAR
CLEAR ALL
CLOSE ALL

poConexion = NEWOBJECT('Conexion', 'Conexion.prg')

LOCAL lnCodigo, lcNombre, lnMarca, llVigente
lnCodigo = 2000
lcNombre = 'NUEVO MODELO 2000'
lnMarca = 3
llVigente = .T.


loRepositorio = NEWOBJECT('RepositorioModelo', 'RepositorioModelo.prg')

IF VARTYPE(loRepositorio) = 'O' THEN
    loValidador = NEWOBJECT('ValidadorModelo', 'ValidadorModelo.prg', NULL, ;
                      loRepositorio, ;
                      lnCodigo, ;
                      lcNombre, ;
                      lnMarca, ;
                      llVigente ;
                  )

    IF VARTYPE(loValidador) = 'O' THEN
        IF loValidador.RegistroValido() THEN
            loModelo = NEWOBJECT('Modelo', 'Modelo.prg', NULL, ;
                           loValidador.ObtenerCodigo(), ;
                           loValidador.ObtenerNombre(), ;
                           loValidador.ObtenerMarca(), ;
                           loValidador.ObtenerVigente() ;
                       )

            IF VARTYPE(loModelo) = 'O' THEN
                IF loRepositorio.Agregar(loModelo) THEN
                    MESSAGEBOX('El registro ha sido agregado correctamente.', 0+64, 'Aviso', 5000)
                    ? loValidador.ObtenerCodigo()
                    ? loValidador.ObtenerNombre()
                    ? loValidador.ObtenerMarca()
                    ? loValidador.ObtenerVigente()
                ENDIF
            ELSE
                MESSAGEBOX('No se pudo crear el objeto modelo.', 0+16, 'Aviso')
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