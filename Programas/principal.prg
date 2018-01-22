SET DELETED ON
SET DATE BRITISH
SET CENTURY ON
SET EXACT ON

goConexion = NEWOBJECT('Conexion', 'Conexion.prg')

IF VARTYPE(goConexion) <> 'O' THEN
   MESSAGEBOX([El objeto 'goConexion' no existe.], 0+16, 'Aviso')
   CANCEL
ENDIF

IF !goConexion.AbrirConexion() THEN
   MESSAGEBOX('No se pudo conectar al servidor.', 0+16, 'Conexión fallida')
   CANCEL
ENDIF

toRepositorioMarca = NEWOBJECT('RepositorioMarca', 'RepositorioMarca.prg')



