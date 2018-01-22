DEFINE CLASS Marca AS ModeloBase OF ModeloBase.prg
ENDDEFINE

*!*	CREATE TABLE marca ( ;
*!*	    codigo N(3), ;
*!*	    nombre C(30), ;
*!*	    vigente L(1) ;
*!*	)

*!*	INDEX ON codigo TAG 'indice1'
*!*	INDEX on nombre TAG 'indice2'