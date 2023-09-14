unit LO_Cola;

Interface

Uses SysUtils, LO_DobleEnlace;

function Cola_Crear  ( var Cola:Tipo_Indice; ruta, nombre: Tipo_Cadena ) :boolean;
procedure Cola_Abrir ( var Cola	:Tipo_Indice );
procedure Cola_Cerrar ( var Cola: Tipo_Indice );
procedure Cola_Decolar ( var Cola: Tipo_Indice );
procedure Cola_Encolar ( var Cola:Tipo_Indice; RegistroIndice: Tipo_Registro_Indice );
Procedure Cola_EncolarConFecha ( var Cola:Tipo_Indice; RegistroIndice:Tipo_Registro_Indice; TipoComprobante, fecha: String );
procedure Cola_Frente ( var Cola:Tipo_Indice;  var  RegistroIndice: Tipo_Registro_Indice);
Function Cola_Vacia  ( var Cola:Tipo_Indice ): boolean;
Function Cola_PosNula  ( var Cola:Tipo_Indice): Tipo_Posicion ;
Function Cola_ClaveNula  ( var Cola:Tipo_Indice): Tipo_Clave ;
procedure Cola_Tope (var Cola: Tipo_Indice; var RegistroIndice: Tipo_Registro_Indice);
procedure Cola_Destruir(var Cola: Tipo_Indice);

function UltimaFechaEmitida(var Cola: Tipo_Indice; tipoComprobante: string): string;
function Cola_UltimoNroComprobante(var Cola:Tipo_Indice): integer;

Implementation

function Cola_Crear  ( var Cola:Tipo_Indice; ruta, nombre: Tipo_Cadena ) :boolean;
begin
	Cola_Crear:= LO_DobleEnlace.DobleEnlace_Crear ( Cola, ruta, nombre );
end;

//--------------------------------------------------------------

procedure Cola_Abrir ( var Cola	:Tipo_Indice );
begin
	LO_DobleEnlace.DobleEnlace_Abrir ( Cola );
end;

//--------------------------------------------------------------

Procedure Cola_Cerrar ( var Cola: Tipo_Indice );
begin
	LO_DobleEnlace.DobleEnlace_Cerrar ( Cola );
End;

//--------------------------------------------------------------

Procedure Cola_Decolar ( var Cola: Tipo_Indice );
begin
	LO_DobleEnlace.DobleEnlace_Eliminar ( Cola, LO_DobleEnlace.DobleEnlace_Primero(Cola) );
End;

//------------------------------------------------------------------------------

Procedure Cola_Encolar ( var Cola:Tipo_Indice; RegistroIndice:Tipo_Registro_Indice );
begin
	LO_DobleEnlace.DobleEnlace_Insertar ( Cola, -1  , RegistroIndice ) ; //Insertar de doble enlace inserta al final si pasas la posicion nula
End;

//------------------------------------------------------------------------------

Procedure Cola_EncolarConFecha ( var Cola:Tipo_Indice; RegistroIndice:Tipo_Registro_Indice; TipoComprobante, fecha: String );
var
  RegistroControl: Tipo_Registro_Control;
begin
	LO_DobleEnlace.DobleEnlace_Insertar ( Cola, -1  , RegistroIndice ) ; //Insertar de doble enlace inserta al final si pasas la posicion nula

  Seek(Cola.C, 0);
  Read(Cola.C, RegistroControl);

  RegistroControl.UltimoNroComprobante:= RegistroControl.UltimoNroComprobante + 1;

  if (TipoComprobante = '01') then
  begin
    RegistroControl.UltimaFechaEmitida01:= fecha;
  end else
    if (TipoComprobante = '02') then
    begin
      RegistroControl.UltimaFechaEmitida02:= fecha;
    end else
      if (TipoComprobante = '03') then
      begin
        RegistroControl.UltimaFechaEmitida03:= fecha;
      end else
        if (TipoComprobante = '50') then
        begin
          RegistroControl.UltimaFechaEmitida50:= fecha;
        end ;

  Seek(Cola.C, 0);
  Write(Cola.C, RegistroControl);
End;

//------------------------------------------------------------------------------

Procedure Cola_Frente ( var Cola:Tipo_Indice;  var  RegistroIndice: Tipo_Registro_Indice);
begin
	LO_DobleEnlace.DobleEnlace_Capturar ( Cola, LO_DobleEnlace.DobleEnlace_Primero(Cola) , RegistroIndice );
End;

//--------------------------------------------------------------

Function Cola_Vacia  ( var Cola:Tipo_Indice ): boolean;
begin
	Cola_Vacia :=  LO_DobleEnlace.DobleEnlace_Vacio ( Cola ) ;
end;

//-------------------------------------------------------------

Function Cola_PosNula  ( var Cola:Tipo_Indice): Tipo_Posicion ;
begin
	Cola_PosNula := LO_DobleEnlace.DobleEnlace_PosNula ( Cola );
end;

//------------------------------------------------------------

Function Cola_ClaveNula  ( var Cola:Tipo_Indice): Tipo_Clave ;
begin
	Cola_ClaveNula := LO_DobleEnlace.DobleEnlace_ClaveNula( Cola);
End;

//------------------------------------------------------------

procedure Cola_Tope (var Cola: Tipo_Indice; var RegistroIndice: Tipo_Registro_Indice);
begin
  LO_DobleEnlace.DobleEnlace_Capturar ( Cola,  LO_DobleEnlace.DobleEnlace_Ultimo (Cola), RegistroIndice);
end;

procedure Cola_Destruir(var Cola: Tipo_Indice);
begin
  close(cola.C);
  close(Cola.I);
  Erase(Cola.C);
  Erase(Cola.I);
end ;

//------------------------------------------------------------------------------

function UltimaFechaEmitida(var Cola: Tipo_Indice; tipoComprobante: string): string;
var
  RegistroControl: Tipo_Registro_Control;
begin
  Seek(Cola.C, 0);
  Read(Cola.C, REgistroControl);

  if tipoComprobante = '01' then UltimaFechaEmitida := RegistroControl.UltimaFechaEmitida01
  else
  if tipoComprobante = '02' then UltimaFechaEmitida := RegistroControl.UltimaFechaEmitida02
  else
  if tipoComprobante = '03' then UltimaFechaEmitida := RegistroControl.UltimaFechaEmitida03
  else
  if tipoComprobante = '50' then UltimaFechaEmitida := RegistroControl.UltimaFechaEmitida50

end;

//------------------------------------------------------------------------------

function Cola_UltimoNroComprobante(var Cola:Tipo_Indice): integer;
var
  RegistroControl: Tipo_Registro_control;
begin
    Seek(Cola.C, 0);
    Read(Cola.C, RegistroControl);

    Cola_UltimoNroComprobante:= RegistroControl.UltimoNroComprobante;
end;


end.















