unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Buttons, LO_DobleEnlace, LO_Datos_Rubros,
  Grids, LO_ABB, LO_Datos_Articulos;

type
  TForm_Rubros = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    StringGrid1: TStringGrid;
    BitBtn4: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Rubros: TForm_Rubros;

implementation

uses Unit1, Unit4;

{$R *.dfm}

procedure LimpiarAbmRubros;
begin
  Form_Rubros.Edit1.Clear;
  Form_Rubros.Edit2.Clear;
  Form_Rubros.Edit3.Clear;
  Form_Rubros.Edit4.Clear;
end;

procedure LimpiarTablaRubros;
var
  i: longint;
begin
  for i:= 1 to Form_Rubros.StringGrid1.RowCount  do
  begin
    Form_Rubros.StringGrid1.Rows[i].Clear;
  end;

end;

procedure ContarArticulos( var ME_Articulos: unit1.Tipo_ME_Articulos; posNodo: LO_ABB.Tipo_posicion; claveRubro:string; Var Suma: Longint);
var
  RegistroNodo: LO_ABB.Tipo_Registro_Indice;
  posDatos: longint;
  RegistroDatosArticulo: LO_Datos_Articulos.Tipo_Registro_Datos;
begin

  if (posNodo <> LO_ABB.Arbol_PosNula(ME_Articulos.Arbol)) then
  begin
    LO_ABB.Arbol_Capturar(ME_Articulos.Arbol, posNodo, RegistroNodo);
    posDatos:= RegistroNodo.Posicion;
    LO_Datos_Articulos.Datos_Capturar(ME_Articulos.Datos, posDatos, RegistroDatosArticulo);

    if (claveRubro = RegistroDatosArticulo.ClaveRubro) then suma:=suma+1;

    ContarArticulos(ME_Articulos, RegistroNodo.HijoIzq, claveRubro, suma);
    ContarArticulos(ME_Articulos, RegistroNodo.HijoDer, claveRubro, suma);

  end
end;

function CantArticulosEnRubro(clave: String): longint;
var
  suma: Longint;
  posRaiz: LO_ABB.Tipo_Posicion;
begin

  posRaiz:=LO_ABB.Arbol_Raiz(Unit1.ME_Articulos.Arbol) ;

  suma:=0;

  ContarArticulos(Unit1.ME_Articulos, posRaiz, clave, suma);

  CantArticulosEnRubro:= suma;

end;

procedure ListarRubros;
var
  RegistroDatosRubro: LO_Datos_Rubros.Tipo_Registro_Datos;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;

  posicion, posDatos: LO_DobleEnlace.Tipo_Posicion;

  i: longint;
begin
  LimpiarTablaRubros;
  Form_Rubros.StringGrid1.Cells[0,0]:= 'Cód.';
  Form_Rubros.StringGrid1.Cells[1,0]:= 'Nombre';
  Form_Rubros.StringGrid1.Cells[2,0]:= 'Min. OP.';
  Form_Rubros.StringGrid1.Cells[3,0]:= 'Max. a Reponer';
  Form_Rubros.StringGrid1.Cells[4,0]:= 'Cant. de articulos';


  Form_Rubros.StringGrid1.RowCount:=1;
  i:= 1;


  posicion:= LO_DobleEnlace.DobleEnlace_Primero(Unit1.ME_Rubros.Indice);
  while posicion <> LO_DobleEnlace.DobleEnlace_PosNula(Unit1.ME_Rubros.Indice) do
  begin
    LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Rubros.Indice, posicion, RegistroIndice);

    posDatos:= RegistroIndice.Posicion;

    LO_Datos_Rubros.Datos_Capturar(Unit1.ME_Rubros.Datos, posDatos, RegistroDatosRubro);

    Form_Rubros.StringGrid1.RowCount:= Form_Rubros.StringGrid1.RowCount + 1;
    Form_Rubros.StringGrid1.Cells[0, i]:= RegistroDatosRubro.Clave;
    Form_Rubros.StringGrid1.Cells[1, i]:= RegistroDatosRubro.Nombre;
    Form_Rubros.StringGrid1.Cells[2, i]:= IntToStr(RegistroDatosRubro.minimoOperativo);
    Form_Rubros.StringGrid1.Cells[3, i]:= IntToStr(RegistroDatosRubro.maximoAReponer);
    Form_Rubros.StringGrid1.Cells[4, i]:= IntToStr(CantArticulosEnRubro(RegistroDatosRubro.Clave));

    i:=i+1;
    posicion:= RegistroIndice.Sig;
  end;


end;  //End ListarRubros

function VerificarMinMax(sMinimo, sMaximo: string): boolean;
var
  bResultado: boolean;
  letra: string;
  n,m: integer;
begin
  bResultado:= true;

  if TryStrToInt(sMinimo, n) = false then bResultado:=false ;
  if TryStrToInt(sMaximo, m) = false then bResultado:= false;


  if (bResultado = true) then
  begin
    if n>m then
    begin
      bResultado:=false;
      showmessage('El minimo operativo no puede ser mayor al máximo a reponer.')
    end;
  end else showmessage('Verifique el minimo y el máximo, deben ser numeros enteros.');

  VerificarMinMax:= bResultado;
end;

function VerificarClave(Clave: string):boolean;
var
  bResultado: boolean;
begin
  bResultado:= false;
  
  if ( Clave[1] >= '0' ) and (Clave[1] <= '9') then
  begin
    if ( Clave[2] >= '0') and ( Clave[2] <= '9') then
      if ( Clave[3] >= '0' ) and ( Clave[3] <= '9' ) then bResultado:=true
  end;
  VerificarClave:= bResultado;
end;

function CapturarDatos(Clave: string): boolean;
var
  Pos: LO_DobleEnlace.Tipo_Posicion;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  posDatos: LO_Datos_Rubros.Tipo_Posicion;
  RegistroDatos: LO_Datos_Rubros.Tipo_Registro_Datos;
  bResultado: boolean;
begin
  bResultado:= false;

  if (Lo_DobleEnlace.DobleEnlace_Buscar_Mejorada(Unit1.Me_Rubros.Indice, clave, pos)=true) then
  begin
    LO_DobleEnlace.DobleEnlace_Capturar(Unit1.Me_Rubros.Indice,pos, RegistroIndice);
    posDatos:= RegistroIndice.Posicion;

    LO_Datos_Rubros.Datos_Capturar(Unit1.ME_Rubros.Datos, posDatos, RegistroDatos);

    Form_Rubros.Edit2.Text:= RegistroDatos.Nombre;
    Form_Rubros.Edit3.Text:= IntToStr(RegistroDatos.minimoOperativo);
    Form_Rubros.Edit4.Text:= IntToStr(RegistroDatos.maximoAReponer);


    Form_Rubros.BitBtn1.Enabled:=false;
    Form_Rubros.BitBtn2.Enabled:=true;
    Form_Rubros.BitBtn3.Enabled:=true;

    bResultado:=true;
  end;
  
  CapturarDatos:=bResultado;
end;

procedure TForm_Rubros.Button1Click(Sender: TObject);
begin
  Form_Rubros.Close;
  Form_MenuPrincipal.show;
end;

procedure TForm_Rubros.FormCreate(Sender: TObject);
begin
  ListarRubros;
  edit1.MaxLength:=3;
  edit2.MaxLength:=40;


end;

procedure TForm_Rubros.Edit1Change(Sender: TObject);
var
  Clave: string;
begin
  clave:= edit1.Text;

  if Length(Clave) = 1 then
  begin
    if (Clave <'0') or (Clave >'9') then Form_Rubros.Edit1.Clear;
  end;

  if (Length(Clave) <> 3) then
  begin
    Form_Rubros.BitBtn1.Enabled:=false;
    Form_Rubros.BitBtn2.Enabled:=false;
    Form_Rubros.BitBtn3.Enabled:=False;

    Form_Rubros.Edit2.Clear;
    Form_Rubros.Edit3.Clear;
    Form_Rubros.Edit4.Clear;
  end;

  if (Length(Clave) = 3) then
  begin

    if (VerificarClave(Clave) = true) then
    begin

      if CapturarDatos(Clave) = false then Form_Rubros.BitBtn1.Enabled:=true;

    end else Showmessage('Se ha ingresado una clave incorrecta. (El formato debe ser "123") ');
  end;
  
end;

procedure ActualizarRubrosEnArticulos(clave: String);

begin
    Form_Articulos.ComboBox1.AddItem(clave, Form_Articulos.ComboBox1);
    Form_Articulos.ComboBox2.AddItem(clave, Form_Articulos.ComboBox2);
end;

procedure TForm_Rubros.BitBtn1Click(Sender: TObject);
var
  RegistroDatos: LO_Datos_Rubros.Tipo_Registro_Datos;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  clave: LO_Datos_Rubros.Tipo_Clave;
  nombre: LO_Datos_Rubros.Tipo_Nombre;
  sMinimo, sMaximo: string;
  pos: LO_DobleEnlace.Tipo_Posicion;
  posDatos: integer;
  
begin
  clave:= Form_Rubros.Edit1.Text;
  nombre:= Form_Rubros.Edit2.Text;
  sMinimo:= Form_Rubros.Edit3.Text;
  sMaximo:= Form_Rubros.Edit4.Text;

  if (nombre='') or (sMinimo='') or (sMaximo='') then showmessage('Por favor, ingrese todos los campos')
  else
  begin
    if ((VerificarMinMax(sMinimo, sMaximo)) = true) then 

    begin
      RegistroDatos.Clave:=clave;
      RegistroDatos.Nombre:=nombre;
      RegistroDatos.minimoOperativo:=StrToInt(sMinimo);
      RegistroDatos.maximoAReponer:= StrToInt(sMaximo);

      posDatos:= FileSize(Unit1.ME_Rubros.Datos.D);
      RegistroIndice.Clave:=clave;
      RegistroIndice.Posicion:= posDatos;

      if (LO_DobleEnlace.DobleEnlace_Buscar_Mejorada(Unit1.ME_Rubros.Indice, clave, pos) = false ) then
      begin

        LO_Datos_Rubros.Datos_Insertar(Unit1.Me_Rubros.Datos, RegistroDatos);
        LO_DobleEnlace.DobleEnlace_Insertar(Unit1.Me_Rubros.Indice, pos, RegistroIndice );

        Showmessage('Se ha insertado el rubro.');

        ActualizarRubrosEnArticulos(RegistroIndice.Clave);
        LimpiarAbmRubros;
        ListarRubros;
      end
      //SINO NO PODRA INSERTARLO PORQUE EL BOTON INSERTAR SE DESHABILITARÄ


    end
  end

end;

function AutorizarEliminacionRubro(clave: string): boolean;
var
  bResultado: boolean;
begin

  if CantArticulosEnRubro(clave) = 0 then bResultado:= true else bResultado:= false;

  AutorizarEliminacionRubro:= bResultado;
end;


procedure TForm_Rubros.BitBtn2Click(Sender: TObject);
var
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  clave: LO_Datos_Rubros.Tipo_Clave;
  pos: LO_DobleEnlace.Tipo_Posicion;
  posDatos: integer;
begin
  clave:= Form_Rubros.Edit1.Text;

  if (LO_DobleEnlace.DobleEnlace_Buscar_Mejorada(Unit1.ME_Rubros.Indice, clave, pos) = true ) then
  begin
    LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Rubros.Indice, pos, RegistroIndice);
    posDatos:= RegistroIndice.Posicion;

    if Dialogs.MessageDlg('¿Está seguro que desea eliminar este rubro?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
    begin
      if (AutorizarEliminacionRubro(clave) = true) then
      begin
        LO_Datos_Rubros.Datos_Eliminar(Unit1.ME_Rubros.Datos, posDatos);
        LO_DobleEnlace.DobleEnlace_Eliminar(Unit1.ME_Rubros.Indice, pos);

        Showmessage('Se ha eliminado un rubro.');

        LimpiarAbmRubros;
        ListarRubros;
      end
      else
        showmessage('No se puede eliminar este rubro. Tiene artículos asociados');
    end;


  end;
 

end;

procedure TForm_Rubros.BitBtn3Click(Sender: TObject);
var
  RegistroDatos: LO_Datos_Rubros.Tipo_Registro_Datos;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  clave: LO_Datos_Rubros.Tipo_Clave;
  nombre: LO_Datos_Rubros.Tipo_Nombre;
  pos: LO_DobleEnlace.Tipo_Posicion;
  posDatos: integer;
  sMinimo, sMaximo: String;
begin
  clave:= Form_Rubros.Edit1.Text;
  nombre:= Form_Rubros.Edit2.Text;
  sMinimo:= Form_Rubros.Edit3.Text;
  sMaximo:= Form_Rubros.Edit4.Text;

  if (nombre='') or (sMinimo='') or (sMaximo='') then showmessage('Por favor, ingrese todos los campos')
  else
  begin
    if (VerificarMinMax(sMinimo,sMaximo) = false) then showmessage('Verificar minimo operativo y maximo a reponer. (Deben ser numeros enteros)')
    else
    begin
       RegistroDatos.Clave:=clave;
       RegistroDatos.Nombre:=nombre;
       RegistroDatos.minimoOperativo:= StrToInt(sMinimo);
       RegistroDatos.maximoAReponer:= StrToInt(sMaximo);

       if (LO_DobleEnlace.DobleEnlace_Buscar_Mejorada(Unit1.ME_Rubros.Indice, clave, pos) = true ) then
       begin
          LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Rubros.Indice, pos, RegistroIndice);

          posDatos:= RegistroIndice.Posicion;

          LO_Datos_Rubros.Datos_Modificar(Unit1.ME_Rubros.Datos, posDatos, RegistroDatos);

          Showmessage('Se ha modificado el rubro.');

          LimpiarABMRubros;
          ListarRubros;
      end
    end

  end

end;

procedure TForm_Rubros.BitBtn4Click(Sender: TObject);
begin
  ListarRubros;
end;

end.
