unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, LO_ABB, LO_DobleEnlace, LO_Datos_Rubros, LO_Datos_Articulos,
  jpeg, ExtCtrls, LO_Datos_Clientes, LO_Datos_Asientos, LO_Datos_Detalles, LO_Datos_Comprobantes,
  LO_Pila, LO_Cola;

type
  TForm_Mantenimiento = class(TForm)
    TreeView1: TTreeView;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure Button9Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Mantenimiento: TForm_Mantenimiento;

implementation

uses Unit1, Unit3, Unit4;

{$R *.dfm}

procedure TForm_Mantenimiento.Button9Click(Sender: TObject);
begin
  Form_Mantenimiento.RadioButton1.SetFocus;
  Form_MenuPrincipal.Show;
  Form_Mantenimiento.Close;
end;

procedure recorrerArbol(var Arbol: LO_ABB.Tipo_Arbol; posNodo: LO_ABB.Tipo_Posicion);
var
  RegistroNodo: LO_ABB.Tipo_Registro_Indice;
  node, nodeAux: TTreeNode;
begin
  if posNodo <> LO_ABB.Arbol_PosNula(Unit1.ME_Articulos.Arbol) then
  begin
    LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol, posNodo, RegistroNodo);
    
    node:= Form_Mantenimiento.TreeView1.Items.AddChild(Form_Mantenimiento.TreeView1.Selected, IntToStr(RegistroNodo.clave));
    nodeAux:=node;

    Form_Mantenimiento.TreeView1.Select(node);

    recorrerArbol(Arbol, RegistroNodo.HijoIzq);

    Form_Mantenimiento.TreeView1.Select(nodeAux);
    
    recorrerArbol(Arbol, RegistroNodo.HijoDer);
  end
end;

procedure DibujarArbol;
var
  posRaiz: LO_ABB.Tipo_Posicion;
begin
    posRaiz:= LO_Abb.Arbol_Raiz(Unit1.Me_Articulos.Arbol);
    Form_Mantenimiento.TreeView1.Items.Clear;
    recorrerArbol(Unit1.ME_Articulos.Arbol, posRaiz);
end;

procedure ListarNiveles;
var
  i: integer;
  RegistroNivel: LO_ABB.Tipo_Registro_Nivel;
begin
  Form_Mantenimiento.ListBox1.Clear;
  Form_Mantenimiento.ListBox1.AddItem('Niveles', Form_Mantenimiento.ListBox1);
  Form_Mantenimiento.ListBox1.AddItem('---------------------------------------------------', Form_Mantenimiento.ListBox1);

  if LO_ABB.Arbol_Vacio(Unit1.ME_Articulos.Arbol) then
  begin
    showmessage('No hay niveles que mostrar porque el arbol esta vacio.');
    Form_Mantenimiento.Label1.visible:= false;
  end
  else
  begin
    for i:= 0 to LO_Abb.Arbol_UltimoNivel(Unit1.ME_Articulos.Arbol) do
    begin
      LO_Abb.Arbol_CapturarNivel(Unit1.ME_Articulos.Arbol, i, RegistroNivel);
      Form_Mantenimiento.ListBox1.AddItem('Nivel '+IntToStr(i)+': '+ IntToStr(RegistroNivel.CantidadElementos)+' elementos.', Form_Mantenimiento.ListBox1);
    end;
  end
end;

procedure VerificarEquilibrio ;
begin
  if (LO_ABB.Arbol_Equilibrado(Unit1.Me_Articulos.Arbol) = false) then
    begin
      Form_Mantenimiento.Button6.Enabled:= true;
      Form_Mantenimiento.Label2.Show;
      Form_Mantenimiento.Label3.Show;
      Form_Mantenimiento.Label1.Hide;
    end
    else
    begin
      Form_Mantenimiento.Button6.Enabled:= false;
      Form_Mantenimiento.Label2.hide;
      Form_Mantenimiento.Label3.hide;
      Form_Mantenimiento.Label1.show;
    end;

  if (LO_ABB.Arbol_Vacio(Unit1.ME_Articulos.Arbol)) then Form_Mantenimiento.Label1.Hide;
end ;

procedure TForm_Mantenimiento.RadioButton4Click(Sender: TObject);
begin
  Form_Mantenimiento.Button2.Visible:= false;
  Form_Mantenimiento.Button3.Visible:= false;

  Form_Mantenimiento.Button4.Visible:= false;
  Form_Mantenimiento.Button5.Visible:= false;
  Form_Mantenimiento.Button6.Visible:= true;
  Form_Mantenimiento.Button7.Visible:= true;
  Form_Mantenimiento.Button8.Visible:= true;

  Form_Mantenimiento.Label4.Show;

  DibujarArbol;

  ListarNiveles;

  VerificarEquilibrio;
end;

procedure TForm_Mantenimiento.Button3Click(Sender: TObject);
begin
   if Dialogs.MessageDlg('¿Está seguro que desea eliminar los archivos de Rubros?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
    begin
      LO_Datos_Rubros.Datos_Destruir(Unit1.ME_Rubros.Datos, Unit1.sRuta, Unit1.sNombreRubros);
      LO_DobleEnlace.DobleEnlace_Destruir(Unit1.ME_Rubros.Indice);

      Showmessage('Se han eliminado todos los datos de Rubros.');


      Form_Articulos.ComboBox1.Items.Clear;

      LO_Datos_Rubros.Datos_Crear(Unit1.Me_Rubros.Datos, Unit1.sRuta, unit1.sNombreRubros);
      LO_DobleEnlace.DobleEnlace_Crear(Unit1.ME_Rubros.Indice, Unit1.sRuta, Unit1.sNombreRubros);

      LO_Datos_Rubros.Datos_Abrir(Unit1.Me_Rubros.Datos);
      LO_DobleEnlace.DobleEnlace_Abrir(Unit1.Me_Rubros.Indice);

    end;
end;

procedure TForm_Mantenimiento.RadioButton1Click(Sender: TObject);
begin
  Form_Mantenimiento.Button2.Visible:= true;
  Form_Mantenimiento.Button3.Visible:= true;

  Form_Mantenimiento.Button4.Visible:= false;
  Form_Mantenimiento.Button5.Visible:= false;
  Form_Mantenimiento.Button6.Visible:= false;
  Form_Mantenimiento.Button7.Visible:= false;
  Form_Mantenimiento.Button8.Visible:= false;

  Form_Mantenimiento.Label1.Hide;
  Form_Mantenimiento.Label2.Hide;
  Form_Mantenimiento.label3.Hide;


end;

procedure TForm_Mantenimiento.RadioButton2Click(Sender: TObject);
begin
  Form_Mantenimiento.Button2.Visible:= false;
  Form_Mantenimiento.Button3.Visible:= false;

  Form_Mantenimiento.Button4.Visible:= true;
  
  Form_Mantenimiento.Button5.Visible:= false;
  Form_Mantenimiento.Button6.Visible:= false;
  Form_Mantenimiento.Button7.Visible:= false;
  Form_Mantenimiento.Button8.Visible:= false;

  Form_Mantenimiento.Label1.Hide;
  Form_Mantenimiento.Label2.Hide;
  Form_Mantenimiento.label3.Hide;
end;

procedure TForm_Mantenimiento.RadioButton3Click(Sender: TObject);
begin
  Form_Mantenimiento.Button2.Visible:= false;
  Form_Mantenimiento.Button3.Visible:= false;

  Form_Mantenimiento.Button4.Visible:= false;
  Form_Mantenimiento.Button5.Visible:= true;
  Form_Mantenimiento.Button6.Visible:= false;
  Form_Mantenimiento.Button7.Visible:= false;
  Form_Mantenimiento.Button8.Visible:= false;

  Form_Mantenimiento.Label1.Hide;
  Form_Mantenimiento.Label2.Hide;
  Form_Mantenimiento.label3.Hide;
end;

procedure TForm_Mantenimiento.Button6Click(Sender: TObject);
begin
  if Dialogs.MessageDlg('¿Está seguro que desea rebalancear la estructura? Esto puede tardar mucho dependiendo de la cantidad de elementos.', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
    begin
      LO_ABB.Arbol_Rebalanceo(Unit1.Me_Articulos.Arbol, Unit1.sRuta, Unit1.sNombreArticulos);
      showmessage('Se ha balanceado con exito!');

      Form_Mantenimiento.RadioButton1.SetFocus;
      Form_Mantenimiento.RadioButton4.SetFocus;
    end;

end;

procedure MostrarPorcentaje;
var
  tolerancia, niveles: LO_ABB.Tipo_Porcentaje;
begin
  tolerancia:= LO_ABB.Arbol_PorcentajeTolerancia(Unit1.ME_Articulos.Arbol);
  niveles:= LO_ABB.Arbol_PorcentajeNiveles(Unit1.ME_Articulos.Arbol);

  Form_Mantenimiento.Label7.Caption:= IntToStr(tolerancia);
  Form_Mantenimiento.Label8.Caption:= IntToStr(niveles);
end;

procedure TForm_Mantenimiento.FormCreate(Sender: TObject);
begin
  MostrarPorcentaje;
end;

procedure TForm_Mantenimiento.Button8Click(Sender: TObject);
var
  tolerancia, niveles: LO_ABB.Tipo_Porcentaje;
begin
  if Dialogs.MessageDlg('¿Está seguro que desea eliminar los archivos de Articulos?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
    begin
      tolerancia:= LO_ABB.Arbol_PorcentajeTolerancia(Unit1.Me_Articulos.Arbol);
      niveles:= LO_ABB.Arbol_porcentajeNiveles(Unit1.Me_Articulos.Arbol);

      LO_Datos_Articulos.Datos_Destruir(Unit1.ME_Articulos.Datos);
      LO_ABB.Arbol_Destruir(Unit1.ME_Articulos.Arbol);

      Showmessage('Se han eliminado todos los datos de Articulos.');

      Form_Mantenimiento.TreeView1.Items.Clear;
      Form_Mantenimiento.ListBox1.Clear;

      Form_Mantenimiento.Label1.Hide;
      Form_Mantenimiento.Label2.Hide;
      Form_Mantenimiento.label3.Hide;

      LO_Datos_articulos.Datos_Crear(Unit1.ME_Articulos.Datos, Unit1.sRuta, Unit1.sNombreArticulos);
      LO_ABB.Arbol_Crear(Unit1.ME_Articulos.Arbol, Unit1.sRuta, Unit1.sNombreArticulos, tolerancia, niveles);

      LO_Datos_Articulos.Datos_Abrir(Unit1.ME_Articulos.Datos);
      LO_ABB.Arbol_Abrir(UNit1.ME_ARticulos.Arbol);
    end;

    
end;

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

procedure TForm_Mantenimiento.Button7Click(Sender: TObject);
var sNiveles, sTolerancia : string;
begin
    Showmessage('A continuación deberá definir los porcentajes de tolerancia a desequilibrio y niveles a controlar en balanceo.');

    repeat
    if InputQuery('Porcentajes de Árbol.','Ingrese el porcentaje de niveles a tener en cuenta al momento de determinar equilibrio.', sNiveles) = false
    then showmessage('El usuario canceló la operacion')
    until VerificarPorcentaje(sNiveles) = true;

    repeat
    if InputQuery('Porcentajes de Árbol.','Ingrese el porcentaje de tolerancia a desbalanceo de niveles.', sTolerancia) = false
    then showmessage('El usuario canceló la operacion')
    until VerificarPorcentaje(sTolerancia) = true;

    if (sNiveles <> '') then
    begin
      LO_ABB.Arbol_cambiarPorcentajeNiveles(Unit1.ME_Articulos.Arbol, StrToInt(sNiveles));
      Form_Mantenimiento.Label8.Caption:= sNiveles;

    end ;

    if (sTolerancia <> '') then
    begin
      LO_ABB.Arbol_CambiarPorcentajeTolerancia(Unit1.ME_Articulos.Arbol, StrToInt(sTolerancia));
      Form_Mantenimiento.Label7.Caption:= sTolerancia;
    end ;

    VerificarEquilibrio;

    Showmessage('Se han actualizado los porcentajes');
end;

procedure TForm_Mantenimiento.Button2Click(Sender: TObject);
begin
  if Dialogs.MessageDlg('¿Está seguro que desea eliminar los archivos de Clientes?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
     begin
     LO_Datos_Clientes.Datos_Destruir(Unit1.ME_Clientes.Datos, Unit1.sRuta, Unit1.sNombreDatos);
      LO_DobleEnlace.DobleEnlace_Destruir(Unit1.ME_Clientes.Indice);

      Showmessage('Se han eliminado todos los datos de Clientes.');


      Form_Articulos.ComboBox1.Items.Clear;

      LO_Datos_Clientes.Datos_Crear(Unit1.ME_Clientes.Datos, Unit1.sRuta, unit1.sNombreDatos);
      LO_DobleEnlace.DobleEnlace_Crear(Unit1.ME_Clientes.Indice, Unit1.sRuta, Unit1.sNombreIndice);

      LO_Datos_Clientes.Datos_Abrir(Unit1.ME_Clientes.Datos);
      LO_DobleEnlace.DobleEnlace_Abrir(Unit1.ME_Clientes.Indice);

    end;
end;

procedure TForm_Mantenimiento.Button4Click(Sender: TObject);
begin
  if Dialogs.MessageDlg('¿Está seguro que desea eliminar los archivos de Detalles y Cuentas Corrientes?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
    begin
      LO_Datos_Detalles.Datos_Destruir(Unit1.ME_Ventas.Detalle.Datos, Unit1.sRuta, Unit1.sNombreDetalles);
      LO_Pila.Pila_Destruir(Unit1.ME_Ventas.Detalle.Pila);

      LO_Datos_Asientos.Datos_Destruir(Unit1.ME_CuentasCOrrientes.Datos, Unit1.sRuta, unit1.sNombreCuentasCorrientes);
      LO_Pila.Pila_Destruir(Unit1.ME_CuentasCorrientes.Pila);

      Showmessage('Se han eliminado todos los datos de Detalles y Cuentas Corrientes.');

      


      LO_Datos_Detalles.Datos_Crear(Unit1.ME_Ventas.Detalle.Datos, Unit1.sRuta, unit1.sNombreDetalles);
      LO_Pila.Pila_Crear(Unit1.ME_Ventas.Detalle.Pila, Unit1.sRuta, unit1.sNombreDetalles);

      LO_Datos_Asientos.Datos_Crear(Unit1.ME_CuentasCorrientes.Datos, Unit1.sRuta, Unit1.sNombreCuentasCorrientes);
      LO_Pila.Pila_Crear(Unit1.ME_CuentasCorrientes.Pila, unit1.sRuta, Unit1.sNombreCuentasCorrientes);


      LO_Datos_Detalles.Datos_Abrir(Unit1.ME_Ventas.Detalle.Datos);
      LO_Pila.Pila_Abrir(Unit1.ME_Ventas.Detalle.Pila);

      LO_Datos_Asientos.Datos_Abrir(Unit1.ME_CuentasCorrientes.Datos);
      LO_Pila.Pila_Abrir(Unit1.ME_CuentasCorrientes.Pila);

    end;
end;

procedure TForm_Mantenimiento.Button5Click(Sender: TObject);
begin
 if Dialogs.MessageDlg('¿Está seguro que desea eliminar los archivos de Comprobantes?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
     begin
      LO_Datos_Comprobantes.Datos_Destruir(Unit1.ME_Ventas.Comprobante.Datos, Unit1.sRuta, Unit1.sNombreComprobantes);
      LO_Cola.Cola_Destruir(Unit1.ME_Ventas.Comprobante.Cola);

      Showmessage('Se han eliminado todos los datos de Comprobantes.');


      LO_Datos_Comprobantes.Datos_Crear(Unit1.ME_Ventas.Comprobante.Datos, Unit1.sRuta, unit1.sNombreComprobantes);
      LO_Cola.Cola_Crear(Unit1.ME_Ventas.Comprobante.Cola, Unit1.sRuta, Unit1.sNombreComprobantes);

      LO_Datos_Comprobantes.Datos_Abrir(Unit1.ME_Ventas.Comprobante.Datos);
      LO_Cola.Cola_Abrir(Unit1.ME_Ventas.Comprobante.Cola);

    end;
end;

end.



