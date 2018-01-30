CLEAR
CLEAR ALL
CLOSE ALL

LOCAL loSesion1, lnUsuario1, lcClave1, loSesion2, lnUsuario2, lcClave2
lnUsuario1 = 100
lcClave1 = 'CLAVE FALSA'

lnUsuario2 = 100
lcClave2 = 'AYA'

loSesion1 = NEWOBJECT('Sesion', 'Sesion.prg', NULL, ;
                lnUsuario1, ;
                lcClave1 ;
            )

loSesion2 = NEWOBJECT('Sesion', 'Sesion.prg', NULL, ;
                lnUsuario2, ;
                lcClave2 ;
            )

IF VARTYPE(loSesion1) = 'O' THEN
    MESSAGEBOX('El usuario 1 ha iniciado sesión.' + CHR(13) + ;
               'Codigo: ' + ALLTRIM(STR(loSesion1.ObtenerCodigo())) + CHR(13) + ;
               'Nombre: ' + ALLTRIM(loSesion1.ObtenerNombre()), 0+64, 'Aviso')
ELSE
    MESSAGEBOX('El usuario 1 no pudo iniciar sesión.', 0+16, 'Aviso')
ENDIF

IF VARTYPE(loSesion2) = 'O' THEN
    MESSAGEBOX('El usuario 2 ha iniciado sesión.' + CHR(13) + ;
               'Codigo: ' + ALLTRIM(STR(loSesion2.ObtenerCodigo())) + CHR(13) + ;
               'Nombre: ' + ALLTRIM(loSesion2.ObtenerNombre()), 0+64, 'Aviso')
ELSE
    MESSAGEBOX('El usuario 2 no pudo iniciar sesión.', 0+16, 'Aviso')
ENDIF
