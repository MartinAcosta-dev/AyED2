unit LO_Datos_Detalles;

interface

  uses
    SysUtils;

  type
    Tipo_Clave =  String [255];
    Tipo_Posicion = LongInt;
    Tipo_Cadena = String [255];
    Tipo_Cantidad = longint;
    Tipo_Precio = real;
  
    Tipo_Registro_Datos = record
                          codFactura: Tipo_Clave;
                          codArticulo: Longint;
                          descripcion: Tipo_Cadena;
                          cant: Tipo_Cantidad;
                          precioUnitario: Tipo_Precio;
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
  procedure Datos_Destruir(var ME: Tipo_Datos; ruta, nombre: Tipo_Cadena);

implementation

  function Datos_Crear(var ME: Tipo_Datos; sRuta, sNombre: string): boolean;
   var
    sArchivoDatos: Tipo_cadena;
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
    Seek(Me.D, pos);
    Write(Me.D, RegistroDatos);
  end;//DatosCapturar

  procedure Datos_Destruir(var ME: Tipo_Datos; ruta, nombre: Tipo_Cadena);
  var
    cArchivoDatos: String;
  begin
    cArchivoDatos:= Ruta+'\'+Nombre+'.dat';
    Close(Me.D);
    Erase(Me.D);
  end; //DatosDestruir

end.
