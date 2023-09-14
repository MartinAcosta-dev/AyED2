unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, jpeg, ExtCtrls, LO_Datos_Clientes, LO_DobleEnlace,
  LO_Datos_Rubros, LO_ABB, LO_Datos_Articulos, FileCtrl, LO_Cola, LO_Pila, LO_Datos_Comprobantes,
  LO_Datos_Detalles, LO_Indice, LO_Datos_Asientos;

type
  TForm_MenuPrincipal = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button6: TButton;
    DirectoryListBox1: TDirectoryListBox;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Tipo_ME_Clientes = Record
                      Indice: LO_DobleEnlace.Tipo_Indice;
                      Datos: LO_Datos_Clientes.Tipo_Datos;
                     end;
                    
  Tipo_ME_Rubros = record
                     Indice: LO_DobleEnlace.Tipo_Indice;
                     Datos: LO_Datos_Rubros.Tipo_Datos;
                   end;

  Tipo_Me_Articulos = record
                        Arbol: LO_ABB.Tipo_Arbol;
                        Datos: LO_Datos_Articulos.Tipo_Datos;
                      end;

  Tipo_Comprobante = record
                       Cola: LO_DobleEnlace.Tipo_Indice;
                       Datos: LO_Datos_Comprobantes.Tipo_Datos;
                     end;

  Tipo_Detalle = record
                   Pila: LO_DobleEnlace.Tipo_Indice;
                   Datos: LO_Datos_Detalles.Tipo_Datos;
                 end;

  Tipo_ME_Ventas = record
                    Comprobante: Tipo_Comprobante;
                    Detalle: Tipo_Detalle;
                   end;

  Tipo_ME_CuentasCorrientes = record
                                Pila: LO_DobleEnlace.Tipo_Indice;
                                Datos: LO_Datos_Asientos.Tipo_Datos;
                              end;

var
  Form_MenuPrincipal: TForm_MenuPrincipal;
  ME_Clientes: Tipo_ME_Clientes;
  ME_Rubros: Tipo_ME_Rubros;
  ME_Articulos: Tipo_ME_Articulos;
  ME_Ventas: Tipo_ME_Ventas;
  ME_CuentasCorrientes: Tipo_ME_CuentasCorrientes;

  sRuta, sNombreDatos, sNombreIndice, sNombreRubros, sNombreArticulos,
  sNombreComprobantes, sNombreDetalles, sNombreCuentasCorrientes: string;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit9;

{$R *.dfm}

function VerificarPorcentaje (palabra: string): boolean;
var
  bResultado: boolean;
  letra: string;
  n: integer;
begin
  bResultado:= true;

  for n:= 1 to (Length(palabra)) do
  begin
    letra := palabra[n];
    if (letra<'0') or (letra>'9') then bResultado:=false;
  end;

  VerificarPorcentaje:= bResultado;
end;


procedure TForm_MenuPrincipal.FormCreate(Sender: TObject);
var
  sNiveles, sTolerancia: string;
begin

  sRuta:= Form_MenuPrincipal.DirectoryListBox1.Directory + '\Archivos';
  //Nombres Clientes
  sNombreDatos:='Datos';
  sNombreIndice:='Clientes';
  //Nombre Rubros
  sNombreRubros:='Rubros';
  //Nombre Articulos
  sNombreArticulos:= 'Articulos';
  //Nombre Ventas
  sNombreComprobantes:= 'Comprobantes';
  sNombreDetalles:= 'Detalles';
  //Nombre cuentas corrientes
  sNombreCuentasCorrientes:= 'Asientos';


  //Archivos de Clientes
  LO_Datos_Clientes.Datos_Crear(Me_Clientes.Datos, sRuta, sNombreDatos);
  LO_DobleEnlace.DobleEnlace_Crear(ME_Clientes.Indice, sRuta, sNombreIndice);
  LO_Datos_Clientes.Datos_Abrir(ME_Clientes.Datos);
  LO_DobleEnlace.DobleEnlace_Abrir(ME_Clientes.Indice);

  //Archivos de Rubros
  LO_Datos_Rubros.Datos_Crear(Me_Rubros.Datos, sRuta, sNombreRubros);
  LO_DobleEnlace.DobleEnlace_Crear(ME_Rubros.Indice, sRuta, sNombreRubros);
  LO_Datos_Rubros.Datos_Abrir(ME_Rubros.Datos);
  LO_DobleEnlace.DobleEnlace_Abrir(ME_Rubros.Indice);

  //Archivo Articulos
  //Antes de crear hay que ver si ya estan creados
  //Si ya estan creados simplemente se abren
  //Si no estan creados se deben crear a partir de los porcentajes ingresados por el usuario
  LO_Datos_Articulos.Datos_Crear(ME_Articulos.Datos, sRuta, sNombreArticulos);
  LO_Datos_Articulos.Datos_Abrir(ME_Articulos.Datos);
  
  if (LO_ABB.Arbol_Creado(ME_Articulos.Arbol, sRuta, sNombreArticulos) = true) then
  begin
    LO_ABB.Arbol_Abrir(ME_Articulos.Arbol);
  end
  else
  begin
    Showmessage('A continuación deberá definir los porcentajes de tolerancia a desequilibrio y niveles a controlar en balanceo.');

    repeat
    if InputQuery('Porcentajes de Árbol.','Ingrese el porcentaje de niveles a tener en cuenta al momento de determinar equilibrio.', sNiveles) = false
    then showmessage('El usuario canceló la operacion y este programa deberia cerrarse')
    until VerificarPorcentaje(sNiveles) = true;

    repeat
    if InputQuery('Porcentajes de Árbol.','Ingrese el porcentaje de tolerancia a desbalanceo de niveles.', sTolerancia) = false
    then showmessage('El usuario canceló la operacion y este programa deberia cerrarse')
    until VerificarPorcentaje(sTolerancia) = true;

    LO_ABB.Arbol_Crear(ME_Articulos.Arbol, sRuta, sNombreArticulos, StrToInt(sTolerancia), StrToInt(sNiveles));
    LO_ABB.Arbol_Abrir(ME_Articulos.Arbol);
    

    showmessage('Se han creado los archivos del ABB. Si desea cambiar los valores en un futuro dirigase al menu mantenimiento.');
    
  end;

  //Archivo Ventas
  //Cola
  LO_Datos_Comprobantes.Datos_Crear(ME_Ventas.Comprobante.Datos, sRuta, sNombreComprobantes);
  LO_Cola.Cola_Crear(ME_Ventas.Comprobante.Cola, sRuta, sNombreComprobantes);

  LO_Datos_Comprobantes.Datos_Abrir(Me_Ventas.Comprobante.Datos);
  LO_Cola.Cola_Abrir(ME_Ventas.Comprobante.Cola);
  //Pila
  LO_Datos_Detalles.Datos_Crear(ME_Ventas.Detalle.Datos, sRuta, sNombreDetalles);
  LO_Pila.Pila_Crear(ME_Ventas.Detalle.Pila, sRuta, sNombreDetalles);

  LO_Datos_Detalles.Datos_Abrir(Me_Ventas.Detalle.Datos);
  LO_Pila.Pila_Abrir(ME_Ventas.Detalle.Pila);

  //Archivo Cuentas Corrientes
  LO_Datos_Asientos.Datos_Crear(ME_CuentasCorrientes.Datos, sRuta, sNombreCuentasCorrientes);
  LO_Pila.Pila_Crear(ME_CuentasCorrientes.Pila, sRuta, sNombreCuentasCorrientes);

  LO_Datos_Asientos.Datos_Abrir(ME_CuentasCorrientes.Datos);
  LO_Pila.Pila_Abrir(ME_CuentasCorrientes.Pila);


end;

procedure TForm_MenuPrincipal.BitBtn1Click(Sender: TObject);
begin
  //Cerrar clientes
  LO_Datos_Clientes.Datos_Cerrar(ME_Clientes.Datos);
  LO_DobleEnlace.DobleEnlace_Cerrar(Me_Clientes.Indice);

  //Cerrar rubros
  Lo_Datos_Rubros.Datos_Cerrar(ME_Rubros.Datos);
  LO_DobleEnlace.DobleEnlace_Cerrar(ME_Rubros.Indice);

  //Cerrar articulos
  LO_Datos_Articulos.Datos_Cerrar(ME_Articulos.Datos);
  LO_ABB.Arbol_Cerrar(ME_Articulos.Arbol);

  //Cerrar ventas
  LO_Datos_Comprobantes.Datos_Cerrar(ME_Ventas.Comprobante.Datos);
  LO_Cola.Cola_Cerrar(ME_Ventas.Comprobante.Cola);

  LO_Datos_Detalles.Datos_Cerrar(ME_Ventas.Detalle.Datos);
  LO_Pila.Pila_Cerrar(ME_Ventas.Detalle.Pila);

  //Cerrar CuentasCorrientes
  LO_Datos_Asientos.Datos_Cerrar(ME_CuentasCorrientes.Datos);
  LO_Pila.Pila_Cerrar(ME_CuentasCorrientes.Pila);

end;

procedure TForm_MenuPrincipal.Button1Click(Sender: TObject);
begin
  Form_MenuPrincipal.Hide;
  Form_Clientes.Show;
end;

procedure TForm_MenuPrincipal.Button2Click(Sender: TObject);
begin
  Form_MenuPrincipal.Hide;
  Form_Rubros.show;
end;

procedure TForm_MenuPrincipal.Button3Click(Sender: TObject);
begin
  Form_MenuPrincipal.Hide;
  Form_Articulos.Show;
  
end;

procedure TForm_MenuPrincipal.Button6Click(Sender: TObject);
begin
  Form_MenuPrincipal.Hide;
  Form_Mantenimiento.Show;
end;

procedure TForm_MenuPrincipal.Button4Click(Sender: TObject);
begin
  Form_Facturacion.Show;
  Form_MenuPrincipal.Hide;
end;

procedure TForm_MenuPrincipal.Button5Click(Sender: TObject);
begin
  Form_Listados.show;
end;

end.
