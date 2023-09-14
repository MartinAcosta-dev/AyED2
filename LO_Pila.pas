Unit LO_Pila;

interface

uses SysUtils, LO_DobleEnlace;

function Pila_Crear ( var Pila: Tipo_Indice; sRuta, sNombre: Tipo_Cadena): boolean;
procedure Pila_Abrir ( var Pila: Tipo_Indice ) ;
procedure Pila_Cerrar ( Var Pila: Tipo_Indice );
procedure Pila_Apilar  (var Pila: Tipo_Indice ; RegistroIndice: Tipo_Registro_Indice ) ;
procedure Pila_Desapilar  ( Var Pila: Tipo_Indice );
procedure Pila_Tope ( var Pila: Tipo_Indice ; var RegistroIndice: Tipo_Registro_Indice );
function Pila_Vacia ( var Pila: Tipo_Indice ): boolean ;
function Pila_ClaveNula  ( var Pila:Tipo_Indice  ): string;
function Pila_PosNula  ( var Pila:Tipo_Indice  ): longint;
procedure Pila_Destruir  ( var Pila:Tipo_Indice  );

implementation

function Pila_Crear ( var Pila: Tipo_Indice ; sRuta, sNombre: Tipo_Cadena ): boolean;
begin

  LO_DobleEnlace.DobleEnlace_Crear(Pila, sRuta, sNombre);
	
End; //End Pila_Crear
//-----------------------------------------------------

Procedure Pila_Abrir ( var Pila: Tipo_Indice) ;
Begin
  LO_DobleEnlace.DobleEnlace_Abrir(Pila);
End;

//-----------------------------------------------------

Procedure Pila_Cerrar ( Var Pila: Tipo_Indice);
begin
  LO_DobleEnlace.DobleEnlace_Cerrar(Pila);
End;

//-----------------------------------------------------
Procedure Pila_Apilar  (var Pila: Tipo_Indice; RegistroIndice: Tipo_Registro_Indice ) ;
begin

  LO_DobleEnlace.DobleEnlace_Insertar(Pila, LO_DobleEnlace.DobleEnlace_Primero(Pila), RegistroIndice);

end;

//----------------------------------------------------
Procedure Pila_Desapilar  ( Var Pila: Tipo_Indice);
begin
  LO_DobleEnlace.DobleEnlace_Eliminar(Pila, LO_DobleEnlace.DobleEnlace_Primero(Pila) );
End;
//----------------------------------------------------
Procedure Pila_Tope ( var Pila: Tipo_Indice; var RegistroIndice: Tipo_Registro_Indice);
begin
	LO_DobleEnlace.DobleEnlace_Capturar(Pila, LO_DobleEnlace.DobleEnlace_Primero(Pila), RegistroIndice);
end;
//-----------------------------------------------------
Function Pila_Vacia ( var Pila: Tipo_Indice): boolean ;
begin
	Pila_Vacia:= LO_DobleEnlace.DobleEnlace_Vacio(Pila)
end;
//-----------------------------------------------------
function Pila_ClaveNula  ( var Pila:Tipo_Indice ): String;
begin
	Pila_ClaveNula:= LO_DobleEnlace.DobleEnlace_ClaveNula(Pila);
End;
//-------------------------------------------------------
function Pila_PosNula  ( var Pila: Tipo_Indice ): longint;
begin
	Pila_PosNula:= LO_DobleEnlace.DobleEnlace_PosNula(Pila);
End;
//-------------------------------------------------------

procedure Pila_Destruir (Var Pila: Tipo_Indice);
begin
	 LO_DobleEnlace.DobleEnlace_Destruir(Pila);
end;

end.