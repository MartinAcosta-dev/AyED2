unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Buttons, LO_DobleEnlace, LO_ABB, LO_Datos_Articulos,
  Grids, LO_Pila, LO_Datos_Detalles;

type
  TForm_Articulos = class(TForm)
    Button1: TButton;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Label5: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label7: TLabel;
    Edit4: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    StringGrid1: TStringGrid;
    Label8: TLabel;
    ComboBox2: TComboBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Articulos: TForm_Articulos;

implementation

uses Unit1, Unit5, Unit8, Unit6, Unit3;

{$R *.dfm}

procedure LimpiarTablaArticulos;
var
  i: longint;
begin
  for i:= 1 to Form_Articulos.StringGrid1.RowCount  do
  begin
    Form_Articulos.StringGrid1.Rows[i].Clear;
  end;
end;

procedure mostrarDatosArticulo(posNodo: LO_ABB.Tipo_Posicion);
var
  posDatos: LO_Datos_Articulos.Tipo_posicion;
  RegistroDatos: LO_Datos_Articulos.Tipo_Registro_Datos;
  clave, codRubro, desc, precioCosto, precioUnitario, stock: string;
  i: longint;
begin
  posDatos:= posNodo;

  LO_Datos_Articulos.Datos_Capturar(Unit1.Me_articulos.Datos, posDatos, RegistroDatos);
  clave:= IntToStr(RegistroDatos.Clave);
  codRubro:= RegistroDatos.ClaveRubro;
  desc:= RegistroDatos.Descripcion;
  precioCosto:= FloatToStr(RegistroDatos.PrecioCosto);
  precioUnitario:= FloatToStr(RegistroDatos.PrecioUnitario);
  stock:= IntToStr(RegistroDatos.stock);

  Form_Articulos.StringGrid1.RowCount:= Form_Articulos.StringGrid1.RowCount+1;
  i:= Form_Articulos.StringGrid1.RowCount-1;

  Form_articulos.StringGrid1.Cells[0,i]:= clave;
  Form_articulos.StringGrid1.Cells[1,i]:= codRubro;
  Form_articulos.StringGrid1.Cells[2,i]:= desc;
  Form_articulos.StringGrid1.Cells[3,i]:= '$ '+precioCosto;
  Form_articulos.StringGrid1.Cells[4,i]:= '$ '+precioUnitario;
  Form_articulos.StringGrid1.Cells[5,i]:= stock;
end;

procedure MostrarArbolInOrden(Arbol: LO_ABB.Tipo_Arbol; posNodo: integer);
var
  RegistroArbol: LO_ABB.Tipo_REgistro_Indice;
begin
  if (posNodo <> -1) then
  begin
    LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol, posNodo, RegistroArbol);
    
    MostrarArbolInOrden(Arbol, RegistroArbol.HijoIzq);

    mostrarDatosArticulo(RegistroArbol.Posicion);

    MostrarArbolInOrden(Arbol, RegistroARbol.HijoDer)
  end
end;

procedure ListarArticulos;
begin
  LimpiarTablaArticulos;


  Form_Articulos.StringGrid1.Cells[0,0]:= 'C�D.';
  Form_Articulos.StringGrid1.Cells[1,0]:= 'RUBRO';
  Form_Articulos.StringGrid1.Cells[2,0]:= 'DESCRIPCION';
  Form_Articulos.StringGrid1.Cells[3,0]:= 'PRECIO COSTO';
  Form_Articulos.StringGrid1.Cells[4,0]:= 'PRECIO U.';
  Form_Articulos.StringGrid1.Cells[5,0]:= 'STOCK';


  Form_articulos.StringGrid1.RowCount:=1;
  
  if (LO_ABB.Arbol_Vacio(Unit1.ME_Articulos.Arbol) = false) then
  MostrarArbolInOrden(Unit1.Me_Articulos.Arbol, LO_ABB.Arbol_Raiz(Unit1.ME_Articulos.Arbol));

end;

procedure TForm_Articulos.Button1Click(Sender: TObject);
begin
  Form_Articulos.Close;
  Form_MenuPrincipal.show;
end;

procedure CargarRubros; //Toma los elementos que hay actualmente en el archivo de rubros y llena el comboBox con las claves actuales
var
  pos: LO_DobleEnlace.Tipo_Posicion;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
begin
  if (LO_DobleEnlace.DobleEnlace_Vacio(Unit1.Me_Rubros.Indice) = false) then
  begin
    Form_Articulos.ComboBox1.Items.Clear;
    Form_Articulos.ComboBox2.Items.Clear;
    Form_Articulos.ComboBox2.AddItem('-- VER TODOS --', Form_Articulos.ComboBox2);
    pos:= LO_DobleEnlace.DobleEnlace_Primero(Unit1.Me_Rubros.Indice);
    
    while pos <> LO_DobleEnlace.DobleEnlace_PosNula(Unit1.Me_Rubros.Indice) do
    begin
      LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Rubros.Indice, pos, RegistroIndice);
      Form_Articulos.ComboBox1.AddItem(RegistroIndice.Clave, Form_Articulos.ComboBox1);
      Form_Articulos.ComboBox2.AddItem(RegistroIndice.Clave, Form_Articulos.ComboBox2);
      pos:= RegistroIndice.Sig;
    end
  end  
end;

procedure TForm_Articulos.FormCreate(Sender: TObject);
begin
  Form_Articulos.Memo1.Text:= '';
  Form_Articulos.Edit1.MaxLength:= 4;
  Form_Articulos.Memo1.MaxLength:= 80;


  ListarArticulos;
  CargarRubros;
end;


procedure TForm_Articulos.BitBtn1Click(Sender: TObject);
var
  numero: double;
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;
  RegistroDatos: LO_Datos_Articulos.Tipo_Registro_Datos;
  pos, posDatos: LO_ABB.Tipo_posicion;
  Nivel: LO_ABB.Tipo_Cantidad;
begin
  if (Form_Articulos.Edit1.Text='') or (Form_Articulos.ComboBox1.Text='') or (Form_Articulos.Memo1.Text='') or (Form_Articulos.Edit2.Text='') or (Form_Articulos.Edit3.Text='') or (Form_Articulos.Edit4.Text='') then
  begin
    showmessage('Por favor, ingrese todos los campos');
  end
  else
  begin
    if TryStrToFloat(Edit1.Text, numero) = false then  showmessage('No ha insertado una clave numerica (1000 .. 9999')
    else
      if (TryStrToFloat(Edit2.Text, numero) = false) or  (TryStrToFloat(Edit3.Text, numero) = false) or (TryStrToFloat(Edit4.Text, numero) = false) then showmessage('Verifique los precios y el stock.')
      else
      begin
        RegistroDatos.Clave:= StrToInt(Edit1.Text);
        RegistroDatos.ClaveRubro:= ComboBox1.Text;
        RegistroDatos.Descripcion:= Memo1.Text;
        RegistroDatos.PrecioCosto:= StrToFloat(Edit2.Text);
        RegistroDatos.PrecioUnitario:= StrToFloat(Edit3.Text);
        RegistroDatos.stock:= StrToInt(Edit4.Text);
        RegistroDatos.Borrado:= false;

        posDatos:= FileSize(Unit1.ME_Articulos.Datos.D);
        RegistroArbol.Clave:= StrToInt(Edit1.Text);
        RegistroArbol.Posicion:= posDatos;

        if (LO_ABB.Arbol_Buscar(Unit1.Me_Articulos.Arbol, RegistroArbol.Clave, pos, Nivel) = true) then showmessage('La clave ya existe')
        else
        begin
          LO_Datos_Articulos.Datos_Insertar(Unit1.ME_Articulos.Datos, RegistroDatos);
          LO_ABB.Arbol_Insertar(ME_Articulos.Arbol, pos, RegistroArbol, Nivel);

          showmessage('Se ha insertado un articulo.');

          Form_Mantenimiento.TreeView1.Items.Clear;
          Form_Mantenimiento.ListBox1.Clear;

          Form_Articulos.Edit1.Clear;
          Form_Articulos.ComboBox1.Clear;

   
          
          Form_Articulos.Memo1.Clear;
          Form_Articulos.Edit2.Clear;
          Form_Articulos.Edit3.Clear;
          Form_Articulos.Edit4.Clear;
          ListarArticulos;
        end

      end
  end
end;

procedure CapturarDatosArticulos(pos: integer);
var
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;
  posDatos: LO_Datos_Articulos.Tipo_Posicion;
  RegistroDatos: LO_Datos_Articulos.Tipo_Registro_Datos;
begin


  LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol ,pos, RegistroArbol);
  posDatos:= RegistroArbol.Posicion;

  LO_Datos_Articulos.Datos_Capturar(Unit1.ME_Articulos.Datos, posDatos, RegistroDatos);

  Form_Articulos.ComboBox1.Text:= RegistroDatos.ClaveRubro;
  Form_Articulos.Memo1.Text:= REgistroDatos.Descripcion;
  Form_Articulos.Edit2.Text:= FloatToStr(RegistroDatos.PrecioCosto);
  Form_Articulos.Edit3.Text:= FloatToStr(RegistroDatos.PrecioUnitario);
  Form_Articulos.Edit4.Text:= IntToStr(RegistroDatos.stock);



end;

procedure LimpiarAbmArticulos;
begin
    
    Form_Articulos.ComboBox1.Text:='';
    Form_Articulos.Memo1.Text:='';
    Form_Articulos.Edit2.Text:='';
    Form_Articulos.Edit3.Text:='';
    Form_Articulos.Edit4.Text:='';
end;

procedure TForm_Articulos.Edit1Change(Sender: TObject);
var
  sNumero: string;
  nNumero: integer;
  numero: double;
  pos: LO_ABB.Tipo_Posicion;
  nivel: LO_ABB.Tipo_Cantidad;
begin
  sNumero:= Form_Articulos.Edit1.Text;


  if  (Length(sNumero) = 1) and (sNumero = '0') then Form_Articulos.Edit1.clear;

  if (Length(sNumero) = 1) and ((sNumero < '1') or (sNumero > '9') ) then Form_Articulos.Edit1.Clear;



  if( Length(sNumero) = 4 ) and ( TryStrToFloat(sNumero,numero) ) then
  begin
    nNumero:= StrToInt(sNumero);
    if (LO_ABB.Arbol_Buscar(Unit1.Me_Articulos.Arbol, nNumero, pos, nivel) = false ) then
    begin
      Form_Articulos.BitBtn1.Enabled:= true;
      Form_Articulos.BitBtn2.Enabled:=false;
      Form_Articulos.BitBtn3.Enabled:=false;
    end
    else
    begin
      CapturarDatosArticulos(pos);
      Form_Articulos.BitBtn1.Enabled:= false;
      Form_Articulos.BitBtn2.Enabled:= true;
      Form_Articulos.BitBtn3.Enabled:= true;
    end
  end
  else
  begin
    Form_Articulos.BitBtn1.Enabled:=false;
    Form_Articulos.BitBtn2.Enabled:=false;
    Form_Articulos.BitBtn3.Enabled:=false;

    LimpiarAbmArticulos;
    CargarRubros;
  end
end;



procedure TForm_Articulos.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form_Articulos.ComboBox1.Text:='';
end;

procedure TForm_Articulos.ComboBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
  Form_Articulos.ComboBox1.Text:='';
end;

procedure TForm_Articulos.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form_Articulos.ComboBox1.Text:='';
end;

function VerificarEliminacionArticulo(clave: integer): boolean;
var
  bResultado, bCorte: boolean;
  RegistroPila: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatosDetalle: LO_Datos_Detalles.Tipo_Registro_Datos;
  pilaAuxDet: LO_DobleEnlace.Tipo_Indice;
  posDatos: longint;

begin
  Pila_Crear(PilaAuxDet, unit1.sRuta, 'pilaTempDet');
  Pila_Abrir(pilaAuxDet);
  bCorte:= false;
  
  while (Pila_Vacia(Unit1.ME_Ventas.Detalle.Pila) = false) and (bCorte=false) do
  begin
     Pila_Tope(Unit1.ME_Ventas.Detalle.Pila, RegistroPila);

     posDatos:= RegistroPila.Posicion;
     LO_Datos_Detalles.Datos_Capturar(Unit1.ME_Ventas.Detalle.Datos, posDatos, RegistroDatosDetalle);

     if clave = (RegistroDatosDetalle.codArticulo) then
     bCorte:= true;


     Pila_Apilar(pilaAuxDet, RegistroPila);
     Pila_Desapilar(Unit1.ME_Ventas.Detalle.Pila);
  end;

  if (bCorte = true) then
  bResultado:= false //No se deja eliminar
  else
  bResultado:= true; //Se deja eliminar

  //Volvemos a dejar la pila de detalles como estaba
  while (Pila_Vacia(pilaAuxDet) = false) do
  begin
    Pila_Tope(pilaAuxDet, RegistroPila);
    Pila_Apilar(Unit1.ME_Ventas.Detalle.Pila, RegistroPila);
    Pila_Desapilar(pilaAuxDet);
  end;



  Pila_Destruir(pilaAuxDet);
  VerificarEliminacionArticulo:= bResultado;
end;

procedure TForm_Articulos.BitBtn2Click(Sender: TObject);
var
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;
  clave: LO_Datos_Articulos.Tipo_Clave;
  pos: LO_ABB.Tipo_Posicion;
  nivel: LO_ABB.Tipo_Cantidad;
  posDatos: integer;
begin
  clave:= StrToInt ( Form_Articulos.Edit1.Text );

  if (LO_ABB.Arbol_Buscar(Unit1.ME_Articulos.Arbol, clave, pos, nivel) = true ) then
  begin
    LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol, pos, RegistroArbol);
    posDatos:= RegistroArbol.Posicion;

    if Dialogs.MessageDlg('�Est� seguro que desea eliminar este articulo?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
    begin
      if (VerificarEliminacionArticulo(clave) = true) then
      begin
        LO_Datos_Articulos.Datos_Eliminar(Unit1.ME_Articulos.Datos, posDatos);
        LO_ABB.Arbol_Eliminar(Unit1.ME_Articulos.Arbol, pos, nivel);

        Showmessage('Se ha eliminado un articulo.');

        LimpiarAbmArticulos;
        ListarArticulos;
      end else showmessage('No se puede eliminar el art�culo, tiene facturas asociadas');
    end;


  end;
 

end;

procedure TForm_Articulos.BitBtn3Click(Sender: TObject);
var
  clave, claveRubro, descripcion, precioCosto, precioUnitario, stock: string;
  nPrecioCosto, nPrecioUnitario : real;
  numero: double;
  nStock, numeroInt,nClave: integer;
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;
  RegistroDatos: LO_Datos_Articulos.Tipo_Registro_Datos;
  posDatos: LO_Datos_Articulos.Tipo_Posicion;
  pos: LO_ABB.Tipo_posicion;
  Nivel: LO_ABB.Tipo_Cantidad;

begin
  clave:= Form_Articulos.Edit1.Text;
  claveRubro:= Form_Articulos.ComboBox1.Text;
  descripcion:= Form_Articulos.Memo1.Text;
  precioCosto:= (Form_articulos.Edit2.Text);
  precioUnitario:= (Form_articulos.Edit3.Text);
  stock:= (Form_articulos.Edit4.Text);

  if (claveRubro = '') or (descripcion = '') or (precioCosto = '') or (precioUnitario = '') or (stock = '') then Showmessage('Por favor, complete todos los campos.')
  else
  begin
    if (TryStrToFloat(precioCosto, numero) = false) or  (TryStrToFloat(precioUnitario, numero) = false) or (TryStrToInt(stock, numeroInt) = false) then showmessage('Verifique los precios y el stock.')
    else
    begin
      nPrecioCosto:= StrToFloat(precioCosto);
      nPrecioUnitario:= StrToFloat(precioUnitario);
      nStock:= StrToInt(stock);
      nClave:= StrToInt(clave);

      LO_ABB.Arbol_Buscar(Unit1.Me_Articulos.Arbol, nClave, pos, nivel);

      LO_ABB.Arbol_Capturar(Unit1.Me_Articulos.Arbol, pos, RegistroArbol);

      posDatos:= RegistroArbol.Posicion;

      RegistroDatos.Clave:= nClave;
      RegistroDatos.ClaveRubro:= ClaveRubro;
      RegistroDatos.Descripcion:= Descripcion;
      RegistroDatos.PrecioCosto:= nPrecioCosto;
      RegistroDatos.PrecioUnitario:= nPrecioUnitario;
      RegistroDatos.stock:= nStock ;

      LO_Datos_Articulos.Datos_Modificar(Unit1.Me_Articulos.Datos, posDatos, RegistroDatos);

      showmessage('Se ha modificado el articulo!');

      ListarArticulos;
    end
  end
end;


procedure TForm_Articulos.Button2Click(Sender: TObject);
var
  fecha: string;
begin
  fecha:= DateToStr(now);

  Form_Reporte_Articulos.QRLabel_Fecha.caption:= fecha;

  Form_Reporte_Articulos.QuickRep1.Preview;
end;

procedure RecorrerArbol(var ME_Articulos: Unit1.Tipo_ME_Articulos; posNodo: LO_ABB.Tipo_Posicion; clave: string);
var
  RegistroNodo: LO_ABB.Tipo_registro_indice;
  RegistroDatosArticulo: LO_Datos_Articulos.Tipo_Registro_datos;
  posDatos, i: longint;
begin
  if (posNodo <> LO_ABB.Arbol_PosNula(ME_articulos.Arbol)) then
  begin
    LO_ABB.Arbol_Capturar(ME_Articulos.Arbol, posNodo, RegistroNodo);

    posDatos:= registroNodo.Posicion;

    LO_Datos_articulos.Datos_Capturar(ME_Articulos.Datos, posDatos, registroDatosArticulo);


    if (Clave = registroDatosArticulo.ClaveRubro) then
    begin
      Form_Articulos.StringGrid1.RowCount:= Form_Articulos.StringGrid1.RowCount + 1;
      i:= Form_Articulos.StringGrid1.RowCount-1;

      Form_Articulos.StringGrid1.Cells[0, i]:= IntToStr(RegistroDatosArticulo.Clave);
      Form_Articulos.StringGrid1.Cells[1, i]:= (RegistroDatosArticulo.ClaveRubro);
      Form_Articulos.StringGrid1.Cells[2, i]:= (RegistroDatosArticulo.Descripcion);
      Form_Articulos.StringGrid1.Cells[3, i]:= '$ '+FloatToStr(RegistroDatosArticulo.PrecioCosto);
      Form_Articulos.StringGrid1.Cells[4, i]:= '$ '+FloatToStr(RegistroDatosArticulo.PrecioUnitario);
      Form_Articulos.StringGrid1.Cells[5, i]:= intToStr(RegistroDatosArticulo.stock);
    end;

    RecorrerArbol(ME_Articulos, RegistroNodo.HijoIzq, clave);
    RecorrerArbol(ME_Articulos, RegistroNodo.HijoDer, clave);
  end;
end;


procedure ListarArticulosPorRubro(clave: String);
var
  posRaiz: LO_ABB.Tipo_Posicion;
begin
  posRaiz:= LO_ABB.Arbol_Raiz(Unit1.Me_Articulos.Arbol);

  LimpiarTablaArticulos;
  Form_articulos.StringGrid1.RowCount:=1;

  RecorrerArbol(Unit1.ME_Articulos, posRaiz, clave);
end;

procedure TForm_Articulos.ComboBox2Change(Sender: TObject);
var
  s: String;
begin
  s:= Form_Articulos.ComboBox2.Text;

  if s = '-- VER TODOS --' then ListarArticulos
  else
  ListarArticulosPorRubro(s);

end;

end.
