CLEAR
CLEAR ALL
CLOSE ALL

poConexion = NEWOBJECT('Conexion', 'Conexion.prg')

LOCAL lnCodigo
lnCodigo = 2000


loRepositorio = NEWOBJECT('RepositorioModelo', 'RepositorioModelo.prg')

IF VARTYPE(loRepositorio) = 'O' THEN
    IF loRepositorio.Borrar(lnCodigo) THEN
        MESSAGEBOX('El registro ha sido eliminado correctamente.', 0+64, 'Aviso', 5000)
    ELSE
        MESSAGEBOX('El registro no pudo ser eliminado.', 0+16, 'Denegado', 5000)
    ENDIF
ENDIF