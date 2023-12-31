unit LO_Indice;

interface

  uses
  SysUtils;

  const
  _Posicion_Nula = -1;
  _Clave_Nula = -1;

  type

  Tipo_Clave = Longint;
  Tipo_Cadena = String [255];
  Tipo_Posicion = LongInt;

  Tipo_Registro_Indice = record
                            Clave: Tipo_Clave;
                            Puntero: Tipo_Posicion;
                         end;

  Tipo_Archivo_Indice = file of Tipo_Registro_Indice;

  Tipo_Registro_Control = record
                            Ruta: Tipo_Cadena;
                            Nombre: Tipo_Cadena;
                            Ultimo: Tipo_Posicion;
                          end;

  Tipo_Archivo_Control = file of Tipo_Registro_Control;

  Tipo_Indice = record
	            C: Tipo_Archivo_Control;
                    I: Tipo_Archivo_Indice;
	          end;


  function Indice_Crear(var Indice: Tipo_Indice; sRuta, sNombre: String): boolean;     //Crea los archivos de Datos y Control y los asigna a la variable Clientes
  procedure Indice_Abrir(var Indice: Tipo_Indice);
  procedure Indice_Cerrar(var Indice: Tipo_Indice);
  function Indice_Buscar(var Indice: Tipo_Indice; Clave: Tipo_Clave; var Pos: Tipo_Posicion): Boolean;
  procedure Indice_Insertar(var Indice: Tipo_Indice; pos: Tipo_Posicion; RegistroIndice: Tipo_Registro_Indice);
  procedure Indice_Modificar(var Indice: Tipo_Indice; pos: Tipo_Posicion; RegistroIndice: Tipo_Registro_Indice);
  procedure Indice_Capturar(var Indice: Tipo_Indice; pos: Tipo_Posicion; var RegistroIndice: Tipo_Registro_Indice);
  procedure Indice_Eliminar(var Indice: Tipo_Indice; pos: Tipo_Posicion);
  function Indice_Primero (var Indice:Tipo_Indice): Tipo_Posicion;
  function Indice_Ultimo (var Indice:Tipo_Indice): Tipo_Posicion;
  function Indice_Proximo (var Indice:Tipo_Indice; pos: Tipo_Posicion): Tipo_Posicion;
  function Indice_Anterior (var Indice:Tipo_Indice; pos: Tipo_Posicion): Tipo_Posicion;
  function Indice_Vacio (var Indice:Tipo_Indice): boolean;
  procedure Indice_Destruir (var Indice: Tipo_Indice);
  function Indice_ClaveNula (var Indice: Tipo_Indice): longint;
  function Indice_PosNula (var Indice: Tipo_Indice): longint;

implementation

  function Indice_Crear(var Indice: Tipo_Indice; sRuta, sNombre: String): boolean;
  var
    sArchivoIndice, sArchivoControl: Tipo_cadena;
    RegistroControl : Tipo_Registro_Control;
    bHayError: boolean;
  begin
    sArchivoIndice:= sRuta+'\'+sNombre+'.ntx';
    sArchivoControl:= sRuta+'\'+sNombre+'.con';

    Assign(Indice.I, sArchivoIndice);     //Asignamos archivo de Indice
    Assign(Indice.C, sArchivoControl);     //Asignamos archivo de Control

    {$I-}

    Reset(Indice.I);
    bHayError:= IoResult <> 0;
    if bHayError then Rewrite(Indice.I);
    Close(Indice.I);

    //Ahora lo mismo para control e iniciarlo

    Reset(Indice.C);
    bHayError:= IoResult <> 0;
    if bHayError then
      begin
      
        Rewrite(Indice.C);
        RegistroControl.Ruta    := sRuta;
        RegistroControl.Nombre  := sNombre;
        RegistroControl.Ultimo:= _Posicion_Nula;

        Seek(Indice.C, 0);
        write(Indice.C,RegistroControl);

      end;
    Close(Indice.C);
    Indice_Crear:= bHayError;
    {$I+}
    
  end; //end Indice_Crear

  procedure Indice_Abrir(var Indice: Tipo_Indice);
  begin
    reset(Indice.I);
    reset(Indice.C);
  end;//end Indice_Abrir

  procedure Indice_Cerrar(var Indice: Tipo_Indice);
  begin
    close(Indice.I);
    close(Indice.C);
  end; //end Indice_Cerrar

  function Indice_Buscar(var Indice: Tipo_Indice; Clave: Tipo_Clave; var Pos: Tipo_Posicion): Boolean;
  var
    nInicio, nFin, nMedio: Tipo_Posicion;
    bEncontrado:boolean;
    RegistroIndice: Tipo_Registro_Indice;
    RegistroControl: Tipo_Registro_Control;
  begin
    bEncontrado:=false;
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);

    if RegistroControl.Ultimo = _Posicion_Nula then   //El indice est� vac�o
    begin
      Pos:= 0;
      Indice_Buscar:=false;
    end
    else
    begin
      nInicio:=0;
      nFin:=RegistroControl.Ultimo;

      while (bEncontrado=false) and (nInicio <= nFin) do
      begin
        nMedio := (nInicio + nFin) div 2;
        Seek(Indice.I, nMedio);
        Read(Indice.I, RegistroIndice);

        if Clave = RegistroIndice.Clave then
        begin
          bEncontrado:= true;
          pos:= nMedio;
        end
        else
        if Clave < RegistroIndice.Clave then
          nFin:= nMedio-1
        else
          nInicio:= nMedio+1;
      end;//While

      if bEncontrado = true then Indice_Buscar:= true
      else
      begin
        Indice_Buscar:= false;

        Seek(Indice.I, nMedio);
        Read(Indice.I, RegistroIndice);

        if RegistroIndice.Clave < Clave then nMedio:= nMedio + 1 ;

        pos:= nMedio;
      end;

    end;



  end;//End ME_Buscar

  procedure Indice_Insertar(var Indice: Tipo_Indice; pos: Tipo_Posicion; RegistroIndice: Tipo_Registro_Indice);
  var
    RegistroControl: Tipo_Registro_Control;
    RegistroIndiceNuevo, RegistroIndiceAux: Tipo_Registro_Indice;
    i: Tipo_Posicion;
  begin
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);
    if (RegistroControl.Ultimo < FileSize(Indice.I) - 1 ) then
    begin
      {Esto quiere decir que hay elementos dados de baja en el indice, entonces movemos el ultimo+1 al final fisico para poder insertar el nuevo elemento antes}
      Seek(Indice.I, RegistroControl.Ultimo+1);
      Read(Indice.I, RegistroIndiceAux);
      Seek(Indice.I, FileSize(Indice.I));
      Write(Indice.I, RegistroIndiceAux);
    end;//if

    {Ahora abrimos la estructura}
    if (RegistroControl.Ultimo = _Posicion_Nula) then
    begin
      Seek(Indice.I, 0);
      Write(Indice.I, RegistroIndice);
    end
    else
    begin
      For i:= RegistroControl.Ultimo downto pos do
      begin
       Seek(Indice.I, i);
       Read(Indice.I, RegistroIndiceNuevo);
       Seek(Indice.I, Succ(i));
       Write(Indice.I, RegistroIndiceNuevo);
      end;//for

      Seek(Indice.I, pos);
      Write(Indice.I, RegistroIndice);
      
    end ;


   RegistroControl.Ultimo:= Succ(RegistroControl.Ultimo);
   Seek(Indice.C, 0);
   Write(Indice.C, RegistroControl);

  end; //End Me_Insertar

  procedure Indice_Modificar(var Indice: Tipo_Indice; pos: Tipo_Posicion{posicion que devuelve el Indice_Buscar}; RegistroIndice: Tipo_Registro_Indice);
  begin
     Seek(Indice.I, pos);
     Write(Indice.I, RegistroIndice);
  end; //End ME_modificar

  procedure Indice_Capturar(var Indice: Tipo_Indice; pos: Tipo_Posicion; var RegistroIndice: Tipo_Registro_Indice);
  begin
       Seek(Indice.I, pos);
       Read(Indice.I, RegistroIndice);
  end; //End Indice_Capturar

  procedure Indice_Eliminar(var Indice: Tipo_Indice; pos: Tipo_Posicion);
  var
    RegistroIndice, RegistroIndiceAux: Tipo_Registro_Indice;
    RegistroControl: Tipo_Registro_Control;
    i: Tipo_Posicion;
  begin
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);
    
    Seek(Indice.I, pos);
    Read(Indice.I, RegistroIndiceAux); //Guardamos en un auxiliar el eleIndicento a borrar para luego guardarlo por delante del ultimo elemento logico (por si en un futuro se quiere recuperar)

    for i:= pos+1 to  RegistroControl.Ultimo do
    begin
       Seek(Indice.I, i);
       Read(Indice.I, RegistroIndice);

       Seek(Indice.I, Pred(i));
       Write(Indice.I, RegistroIndice);
    end;//for

    Seek(Indice.I, RegistroControl.Ultimo);
    Write(Indice.I, RegistroIndiceAux);

    RegistroControl.Ultimo:= Pred(RegistroControl.Ultimo);
    Seek(Indice.C,0);
    Write(Indice.C, RegistroControl);
  end; //End Indice_Eliminar

  function Indice_Primero (var Indice:Tipo_Indice): Tipo_Posicion;
  var
  RegistroControl: Tipo_Registro_Control;
  begin
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);
    if RegistroControl.Ultimo = _Posicion_Nula then
      Indice_Primero:=_Posicion_Nula
      else
        Indice_Primero:=0;
  end; //End Indice_Primero

  function Indice_Ultimo(var Indice:Tipo_Indice): Tipo_Posicion;
  var
  RegistroControl: Tipo_Registro_Control;
  begin
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);
    Indice_Ultimo:= RegistroControl.Ultimo;
  end; //Indice_Ultimo

  function Indice_Proximo (var Indice:Tipo_Indice; pos: Tipo_Posicion): Tipo_Posicion;
  var
  RegistroControl: Tipo_Registro_Control;
  begin
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);
    if pos=RegistroControl.Ultimo then
    Indice_Proximo:=_Posicion_Nula
    else
      Indice_Proximo:= Succ(pos);
  end;//End Indice_Proximo

  function Indice_Anterior (var Indice:Tipo_Indice; pos: Tipo_Posicion): Tipo_Posicion;
  var
  RegistroControl: Tipo_Registro_Control;
  begin
    Seek(Indice.C, 0);
    Read(Indice.C, RegistroControl);
    
    if pos = 0 then
      Indice_Anterior := _Posicion_Nula
      else
        Indice_Anterior := Pred(pos);

  end;//End Indice_Anterior

  function Indice_Vacio (var Indice:Tipo_Indice): boolean;
  var
    RegistroControl: Tipo_Registro_Control;
  begin
    Seek(Indice.C,0);
    Read(Indice.C, RegistroControl);

    if (RegistroControl.Ultimo = _Posicion_Nula) then
        Indice_Vacio := true
        else
        Indice_Vacio := false
        
  end;//END Indice_VACIO


  procedure Indice_Destruir (var Indice: Tipo_Indice);
  var
    cArchivoIndice, cArchivoControl: Tipo_Cadena;
    RegistroControl: Tipo_Registro_Control;
  begin

    Close(Indice.C);
    Close(Indice.I);

    Erase(Indice.C);
    Erase(Indice.I);

  end; //Indice_Destruir

//------------------------------------------------------------------------------

  function Indice_ClaveNula (var Indice: Tipo_Indice): longint;
  begin
    Indice_ClaveNula:= _Clave_Nula;
  end;

//------------------------------------------------------------------------------

  function Indice_PosNula (var Indice: Tipo_Indice): longint;
  begin
    Indice_PosNula:= _posicion_Nula;
  end;

end.
