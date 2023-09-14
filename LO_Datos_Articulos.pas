unit LO_Datos_Articulos;

interface

  uses
    SysUtils;

  type
    Tipo_Clave = Longint; // 1000 .. 9999
    Tipo_Clave_Rubro = string [3];
    Tipo_Cadena = String [40];
    Tipo_Precio = real;
    Tipo_Posicion = LongInt;
  
    Tipo_Registro_Datos = record
                          Clave: Tipo_Clave;
			                    ClaveRubro: Tipo_Clave_Rubro;
                          Descripcion: Tipo_Cadena;
			                    PrecioCosto: Tipo_Precio;
			                    PrecioUnitario: Tipo_Precio;
		                      stock: longint;
                          Borrado: boolean;
                        end;

    Tipo_Archivo_Datos = file of Tipo_Registro_Datos;

    Tipo_Datos = record
                   D: Tipo_Archivo_Datos;
                 end;

  var
    Datos: Tipo_Datos;

  function Datos_Crear(var ME: Tipo_Datos; sRuta, sNombre: string): boolean;
  procedure Datos_Abrir(var ME: Tipo_Datos);
  procedure Datos_Cerrar(var ME: Tipo_Datos);
  procedure Datos_Insertar(var ME: Tipo_Datos; Reg: Tipo_Registro_Datos);
  procedure Datos_Modificar(var Me: Tipo_Datos; pos: Tipo_Posicion; Reg: Tipo_Registro_Datos);
  procedure Datos_Capturar(var Me: Tipo_Datos; pos: Tipo_Posicion; var Reg: Tipo_Registro_Datos);
  procedure Datos_Eliminar(var Me: Tipo_Datos; pos: Tipo_Posicion);
  procedure Datos_Destruir(var ME: Tipo_Datos);

implementation

  function Datos_Crear(var ME: Tipo_Datos; sRuta, sNombre: string): boolean;
   var
    sArchivoDatos: String;
    bHayError: boolean;
  begin
    sArchivoDatos:= sRuta+'\'+sNombre+'.dat';
    Assign(ME.D, sArchivoDatos);     //Asignamos archivo de Datos

    {$I-}
    Reset(Me.D);
    bHayError:= IoResult <> 0;
    if bHayError then Rewrite(Me.D);
    Close(Me.D);
    Datos_Crear:= bHayError;
    {$I+}
    
  end;//DatosCrear

  procedure Datos_Abrir(var ME: Tipo_Datos);
  begin
    reset(Me.D);
  end;//DatosAbrir

  procedure Datos_Cerrar(var ME: Tipo_Datos);
  begin
    close(Me.D);
  end;//DatosCerrar

  procedure Datos_Insertar(var ME: Tipo_Datos; Reg: Tipo_Registro_Datos);
  begin
    reg.Borrado:= false;
    Seek(Me.D, FileSize(Me.D));
    write(Me.D, reg);
  end;//DatosInsertar

  procedure Datos_Modificar(var Me: Tipo_Datos; pos: Tipo_Posicion; Reg: Tipo_Registro_Datos);
  begin
    reg.Borrado:= false;
    Seek(Me.D, pos);
    write(Me.D, reg);
  end;//DatosModificar

  procedure Datos_Capturar(var Me: Tipo_Datos; pos: Tipo_Posicion; var Reg: Tipo_Registro_Datos);
  begin
    Seek(Me.D, pos);
    Read(Me.D, Reg);
  end;//DatosCapturar

  procedure Datos_Eliminar(var Me: Tipo_Datos; pos: Tipo_Posicion);
  var
  RegistroDatos: Tipo_Registro_Datos;
  begin
    Seek(Me.D, pos);
    Read(Me.D, RegistroDatos);
    RegistroDatos.borrado:=true;

    Seek(ME.D, pos);
    Write(Me.D, RegistroDatos);
  end;//DatosCapturar

  procedure Datos_Destruir(var ME: Tipo_Datos);
  begin
    Close(Me.D);
    Erase(Me.D);
  end; //DatosDestruir

end.
