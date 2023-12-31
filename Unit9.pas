unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, LO_DobleEnlace, LO_ABB, LO_Datos_Articulos,
  LO_Datos_Rubros, LO_Indice, LO_Pila, LO_Cola, LO_Datos_Asientos, LO_Datos_Detalles;

type
  TForm_Listados = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Listados: TForm_Listados;

implementation

uses Unit1, Unit4, Unit10;

{$R *.dfm}

procedure TForm_Listados.Button1Click(Sender: TObject);
begin
  Form_Listados.ListBox1.Clear;
  Form_Listados.Close;
  Form_MenuPrincipal.show;
end;


procedure RecorrerArbolInORden(ME_Articulos: Unit1.Tipo_ME_Articulos; posNodo: integer; claveRubro: String; minOp, max: longint);
var
  RegistroArbol: LO_ABB.Tipo_REgistro_Indice;
  RegistroDatosArticulo: LO_Datos_Articulos.Tipo_Registro_Datos;
  numAReponer, posDatos: longint;
begin
  if (posNodo <> -1) then
  begin
    LO_ABB.Arbol_Capturar(ME_Articulos.Arbol, posNodo, RegistroArbol);
    
    RecorrerArbolInORden(ME_Articulos, RegistroArbol.HijoIzq, claveRubro, minOP, max);
    
    posDatos:= RegistroArbol.Posicion;
    LO_Datos_articulos.Datos_Capturar(ME_Articulos.Datos, posDAtos, RegistroDatosArticulo);

    if RegistroDatosArticulo.ClaveRubro = claveRubro then
    begin
      if RegistroDatosArticulo.stock < minOP then
      begin
        //LISTAR
        numAReponer:= max - RegistroDatosArticulo.stock;
        Form_Listados.ListBox1.AddItem('Articulo: '+IntToStr(RegistroDatosArticulo.Clave)+'. Num. a reponer: '+intToStr(numAReponer), Form_Listados.ListBox1 );

      end;
    end;

    RecorrerArbolInORden(ME_Articulos, RegistroARbol.HijoDer, claveRubro, minOP, max)
  end
end;

procedure ListarArticulosConFaltaDeStock;
var
  pos: LO_DobleEnlace.Tipo_Posicion;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatosRubro: LO_Datos_Rubros.Tipo_Registro_Datos;
  posRaiz: LO_ABB.Tipo_Posicion;
begin
  pos:= LO_DobleEnlace.DobleEnlace_Primero(Unit1.ME_Rubros.Indice);
  posRaiz:= LO_ABB.Arbol_Raiz(Unit1.ME_Articulos.Arbol);

  Form_Listados.ListBox1.Clear;

  while pos <> LO_DobleEnlace.DobleEnlace_PosNula(Unit1.ME_Rubros.Indice) do
  begin
    LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Rubros.Indice, pos, RegistroIndice);
    LO_Datos_Rubros.Datos_Capturar(Unit1.ME_Rubros.Datos, RegistroIndice.Posicion, RegistroDatosRubro);
    Form_Listados.ListBox1.AddItem('Rubro '+RegistroIndice.Clave+':', Form_Listados.ListBox1);
    Form_Listados.ListBox1.AddItem('', Form_Listados.ListBox1);

    RecorrerArbolInOrden(Unit1.ME_Articulos, posRaiz, RegistroIndice.Clave, RegistroDatosRubro.minimoOperativo, RegistroDatosRubro.maximoAReponer);
    Form_Listados.ListBox1.AddItem('--------------------------------------------------', Form_Listados.ListBox1);
    pos:= RegistroIndice.Sig;
  end; //While
  
end;

procedure ListarRanking;
var
  suma, claveArt, i, posDatos, posIndice: integer;
  IndiceAux: LO_Indice.Tipo_Indice;
  pilaAuxDet: LO_DobleEnlace.Tipo_Indice;
  RegistroPilaDetalle: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroIndice: LO_Indice.Tipo_Registro_Indice;
  RegistroDatosDetalle: LO_Datos_Detalles.Tipo_Registro_Datos;
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;
  RegistroDatosArticulo: LO_Datos_Articulos.Tipo_Registro_Datos;
  nivel: LO_ABB.Tipo_Cantidad;
  posArbol: longint;
begin
   LO_Indice.Indice_Crear(IndiceAux, Unit1.sRuta, 'IndiceTemp');
   Lo_Indice.Indice_Abrir(IndiceAux);

   LO_Pila.Pila_Crear(pilaAuxDet, unit1.sRuta, 'pilaAuxDetTemp');
   LO_Pila.Pila_Abrir(pilaAuxDet);

   if LO_ABB.Arbol_Vacio(Unit1.ME_Articulos.Arbol) = false then
   begin
    for i:= 1 to (Form_Articulos.StringGrid1.RowCount-1) do
    begin
      suma:=0;
      claveArt:= StrToInt(Form_Articulos.StringGrid1.cells[0, i]);

        while (LO_Pila.Pila_Vacia(Unit1.ME_Ventas.Detalle.pila)=false) do
        begin
          Pila_Tope(Unit1.ME_Ventas.Detalle.Pila, RegistroPilaDetalle);

            posDatos:= registroPilaDetalle.Posicion;

            LO_Datos_Detalles.Datos_Capturar(ME_Ventas.Detalle.Datos, posDatos, registroDatosDetalle);

            if (RegistroDatosDetalle.codArticulo = claveArt) then  suma:= suma + RegistroDatosDetalle.cant;


          Pila_Desapilar(Unit1.ME_Ventas.Detalle.Pila);
          Pila_Apilar(pilaAuxDet, RegistroPilaDetalle);
        end;//end pilaDet

        //Volvemos a dejar como estaba la pilaDet
        while (Pila_Vacia(pilaAuxDet)=false) do
        begin
          Pila_Tope(pilaAuxDet, RegistroPilaDetalle);
          Pila_Apilar(Unit1.ME_Ventas.Detalle.Pila, RegistroPilaDetalle);
          Pila_Desapilar(pilaAuxDet);
        end;


      //Insertamos en un indice auxiliar para luego listarlo descendentemente
      LO_Indice.Indice_Buscar(IndiceAux, suma, posIndice);
      RegistroIndice.Clave:= suma;
      RegistroIndice.Puntero:= claveArt;
      LO_Indice.Indice_Insertar(IndiceAux, posIndice, RegistroIndice);

    end;


    for i:= LO_Indice.Indice_Ultimo(IndiceAux) downto LO_Indice.Indice_Primero(IndiceAux) do   //Recorremos descendentemente para listar el ranking desde los mas vendidos a los menos vendidos
    begin
       LO_indice.Indice_Capturar(indiceAux, i, RegistroIndice);

       LO_ABB.Arbol_Buscar(Unit1.ME_Articulos.Arbol, RegistroIndice.Puntero, posArbol, nivel);
       LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol, posArbol, RegistroArbol);
       posDatos:= RegistroArbol.Posicion;
       LO_Datos_articulos.Datos_Capturar(Unit1.ME_Articulos.Datos, posDatos, RegistroDatosArticulo);

       Form_Listados.ListBox1.AddItem('Cod. Articulo: '+IntToStr(RegistroIndice.Puntero), Form_Listados.ListBox1);
       Form_Listados.ListBox1.AddItem('Clave Rubro: '+RegistroDatosArticulo.ClaveRubro , Form_Listados.ListBox1);
       Form_Listados.ListBox1.AddItem('Descripcion: '+RegistroDatosARticulo.Descripcion, Form_Listados.ListBox1);
       Form_Listados.ListBox1.AddItem('Cantidad vendida: '+intToStr(RegistroIndice.Clave), Form_Listados.ListBox1);
       Form_Listados.ListBox1.AddItem('----------------------------------', Form_Listados.ListBox1);

     end;

   end;
   

   LO_Indice.Indice_Destruir(indiceAux);
   LO_Pila.Pila_Destruir(pilaAuxDet);
end;

procedure TForm_Listados.ComboBox1Change(Sender: TObject);
var
  s:String;
begin
  s:= Form_Listados.ComboBox1.Text;

  if s='Reposici�n de articulos' then
  begin
    Form_Listados.ListBox1.Clear;
    ListarArticulosConFaltaDeStock;
  end else
  if s='Ranking de Articulos' then
  begin
    Form_Listados.ListBox1.Clear;
    Form_Listados.ListBox1.AddItem('Ranking de articulos m�s vendidos: ', Form_Listados.ListBox1);
    Form_Listados.ListBox1.AddItem('------------------------------------------------------------------------', Form_Listados.ListBox1);
    ListarRanking;
  end else
  if s='Cuentas Corrientes...' then
  begin
    Form_ListadosCC.show;
  end

end;

end.
