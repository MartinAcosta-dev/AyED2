unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Menus, Grids, Buttons, LO_ABB, LO_DobleEnlace,
  LO_Datos_Clientes, LO_Datos_Articulos, ComCtrls, LO_Datos_Comprobantes, LO_Datos_Detalles,
  LO_Cola, LO_Pila, LO_Datos_Asientos;

type
  TForm_Facturacion = class(TForm)
    Image1: TImage;
    Button1: TButton;
    StringGrid1: TStringGrid;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label5: TLabel;
    Edit3: TEdit;
    BitBtn4: TBitBtn;
    Memo1: TMemo;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    Label8: TLabel;
    Edit4: TEdit;
    Label12: TLabel;
    ComboBox3: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Label13: TLabel;
    Label_Neto: TLabel;
    Label14: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  
    procedure BitBtn2Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Facturacion: TForm_Facturacion;

implementation

uses Unit1, Unit7;

{$R *.dfm}

procedure TForm_Facturacion.Button1Click(Sender: TObject);
begin
  Form_MenuPrincipal.Show;
  Form_Facturacion.Close;

end;

function NormalizarCadena(cadena: string): string;
begin
  NormalizarCadena:= StringReplace(cadena,'$', '',[rfReplaceAll]);;
end;

procedure ActualizarNeto;
var
  i: Longint;
  total: String;
  neto: real;
begin
  neto:=0;



  for i:= 1 to  ( (Form_Facturacion.StringGrid1.RowCount) -1 ) do
  begin
     total:= Form_Facturacion.StringGrid1.Cells[4, i];
     total:= StringReplace(total, '$', '', [rfReplaceAll]);

     neto:= neto+StrToFloat(total);
  end;

  Form_Facturacion.Label_Neto.Caption:= FloatToStr(neto);
end;

procedure NombrarCeldas;
begin
  Form_Facturacion.StringGrid1.Cells[0,0]:= 'COD. ARTICULO';
  Form_Facturacion.StringGrid1.Cells[1,0]:= 'DETALLE';
  Form_Facturacion.StringGrid1.Cells[2,0]:= 'CANT.';
  Form_Facturacion.StringGrid1.Cells[3,0]:= 'PRECIO UNITARIO';
  Form_Facturacion.StringGrid1.Cells[4,0]:= 'TOTAL';

end;

procedure ActualizarClientesEnFacturacion;
var
  pos: integer;
  clave: String;
  RegistroIndiceCliente: LO_DobleEnlace.Tipo_Registro_indice;
begin
  //mostrar clientes en el combobox
  Form_Facturacion.ComboBox1.Items.Clear;

  pos:= LO_DobleEnlace.DobleEnlace_Primero(Unit1.ME_Clientes.Indice);

  while (pos <> LO_DobleEnlace.DobleEnlace_PosNula(Unit1.ME_Clientes.Indice)) do
  begin
    LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Clientes.Indice, pos, RegistroIndiceCliente);
    clave:= RegistroIndiceCliente.Clave;
    Form_Facturacion.ComboBox1.AddItem(clave, Form_Facturacion.ComboBox1);

    pos:= RegistroIndiceCliente.Sig;
  end;
end;

procedure TForm_Facturacion.FormCreate(Sender: TObject);
begin
  NombrarCeldas;
  Memo1.Text:='';
  Form_Facturacion.StringGrid1.RowCount:=1;
  Form_Facturacion.Edit1.MaxLength:= 4;
  Form_Facturacion.Edit4.MaxLength:= 3;
  Form_Facturacion.DateTimePicker1.Date:= now;
  

  ActualizarClientesEnFacturacion;

  
end;

procedure EliminarFila(Fila: Integer);
var
  i: Integer;
begin
  for i := Fila to Form_Facturacion.StringGrid1.RowCount - 1 do
    Form_Facturacion.StringGrid1.Rows[i].Assign(Form_Facturacion.StringGrid1.Rows[i + 1]);

  Form_Facturacion.StringGrid1.RowCount := Form_Facturacion.StringGrid1.RowCount - 1;
end;

procedure TForm_Facturacion.BitBtn2Click(Sender: TObject);
begin
  if Form_Facturacion.Label5.Caption = '' then Showmessage('Seleccione en la tabla una fila a eliminar')
  else
  begin
    if (Form_Facturacion.Label5.Caption = '0') then Showmessage('No se puede eliminar esa fila')
    else
    begin
      EliminarFila( StrToInt(Form_Facturacion.Label5.Caption));
      Form_Facturacion.Label5.Caption:='';


      //Vemos si el recuento de filas es = 1, si lo es entonces deshabilitamos la emision de fact.
      if Form_Facturacion.StringGrid1.RowCount = 1
      then
      begin
        Form_Facturacion.Label_Neto.Caption:='';
        Form_Facturacion.BitBtn4.Enabled:= false;
      end
      else
      ActualizarNeto;

    end
  end

end;

procedure TForm_Facturacion.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  Form_Facturacion.Label5.Caption:= IntToStr(ARow);
end;

procedure LimpiarTabla;
var
  i: integer;
begin
  for i:= 1 to (Form_Facturacion.StringGrid1.RowCount) do
    Form_Facturacion.StringGrid1.Rows[i].Clear;
end;

procedure TForm_Facturacion.BitBtn3Click(Sender: TObject);
begin
  LimpiarTabla;
  Form_Facturacion.StringGrid1.Cells[0,0]:= 'COD. ARTICULO';
  Form_Facturacion.StringGrid1.Cells[1,0]:= 'DETALLE';
  Form_Facturacion.StringGrid1.Cells[2,0]:= 'CANT.';
  Form_Facturacion.StringGrid1.Cells[3,0]:= 'PRECIO UNITARIO';
  Form_Facturacion.StringGrid1.Cells[4,0]:= 'TOTAL';
  Form_Facturacion.StringGrid1.RowCount:=1;

  Form_Facturacion.ComboBox1.Clear;
  Form_Facturacion.ComboBox2.Clear;
  Form_Facturacion.ComboBox2.AddItem('01', Form_Facturacion.ComboBox2);
  Form_Facturacion.ComboBox2.AddItem('02', Form_Facturacion.ComboBox2);
  Form_Facturacion.ComboBox2.AddItem('03', Form_Facturacion.ComboBox2);
  Form_Facturacion.ComboBox2.AddItem('50', Form_Facturacion.ComboBox2);

  Form_Facturacion.ComboBox3.Clear;
  Form_Facturacion.ComboBox3.AddItem('1: Contado', Form_Facturacion.ComboBox3 );
  Form_Facturacion.ComboBox3.AddItem('2: Cr�dito', Form_Facturacion.ComboBox3 );
  Form_Facturacion.Edit1.Clear;
  Form_Facturacion.Edit2.Clear;
  Form_Facturacion.Edit3.Clear;
  Form_Facturacion.Edit4.Clear;

  ActualizarClientesEnFacturacion;

end;

function VerStock(codArt ,cant: longint): boolean;
var
  bResultado: boolean;
  pos: LO_ABB.Tipo_posicion;
  nivel: LO_ABB.Tipo_Cantidad;
  RegistroDatosArticulo: LO_DAtos_Articulos.Tipo_Registro_Datos;
begin
  LO_ABB.Arbol_Buscar(Unit1.ME_Articulos.Arbol, codArt, pos, nivel);
  LO_Datos_Articulos.Datos_Capturar(Unit1.ME_Articulos.Datos,pos, RegistroDatosArticulo);

  if cant > RegistroDatosArticulo.stock then bResultado:= false
  else bResultado:= true;

  VerStock:= bResultado; 
end;

procedure AgregarRegistroATabla( codArticulo, detalle, cant, unitario, total: string);
var
  i: longint;
begin
       Form_Facturacion.StringGrid1.RowCount:= Form_Facturacion.StringGrid1.RowCount + 1;

        i:= Form_Facturacion.StringGrid1.RowCount-1;

        Form_Facturacion.StringGrid1.Cells[0,i]:= codArticulo;
        Form_Facturacion.StringGrid1.Cells[1,i]:= detalle;
        Form_Facturacion.StringGrid1.Cells[2,i]:= cant;
        Form_Facturacion.StringGrid1.Cells[3,i]:= unitario;
        Form_Facturacion.StringGrid1.Cells[4,i]:= total;

        Form_Facturacion.Edit1.Clear;
        Form_Facturacion.Edit1.SetFocus;
        Form_Facturacion.Memo1.Text:='';
        Form_Facturacion.Edit2.Clear;
        Form_Facturacion.Edit3.Clear;
        Form_Facturacion.Label11.Caption:='';

        ActualizarNeto;

        //Vemos si ya esta ingresado el descuento, el tipo comprobante y la forma de pago para habilitar la emision de fact.
        if (Form_Facturacion.Edit4.Text <> '') and  (Form_Facturacion.ComboBox2.Text <> '') and (Form_Facturacion.ComboBox3.Text <> '')
        then Form_Facturacion.BitBtn4.Enabled:= true;
end;


procedure TForm_Facturacion.BitBtn1Click(Sender: TObject);
var
  detalle, codArticulo, cant, total, unitario: string;
  n: integer;
  bEncontrado: boolean;
begin

  if (Form_Facturacion.ComboBox1.Text='') or (Form_Facturacion.Edit1.Text='') or
  (Form_Facturacion.Memo1.Text='') or (Form_Facturacion.Edit2.Text='') or
  (Form_Facturacion.Edit3.Text='') then showmessage('Por favor, complete todos los campos.')
  else
  begin
    codArticulo:= Form_Facturacion.Edit1.Text;
    cant:= Form_Facturacion.Edit3.Text;
    detalle:= Form_Facturacion.Memo1.Text;
    unitario:= '$'+Form_Facturacion.Edit2.Text;
    total:= '$'+Form_Facturacion.Label11.Caption;

    if ( Form_Facturacion.StringGrid1.RowCount <= 1 ) then
    begin
      if (VerStock( StrToInt(codArticulo), strToInt( cant) ) = false) then showmessage('No hay suficiente stock para esa cantidad')
      else
        AgregarRegistroATabla(codArticulo, detalle, cant, unitario, total);
    end
    else  //SINO... Si ya hay registros en la tabla...
    begin
      n:= 1;
      bEncontrado:= false;
      while (bEncontrado = false) and (n <> Form_facturacion.StringGrid1.RowCount) do
      begin
        if (codArticulo = Form_Facturacion.StringGrid1.Cells[0, n]) then
        begin
          bEncontrado:= true;

          cant:= IntToStr(strToInt(cant) + strToint(Form_Facturacion.StringGrid1.Cells[2, n] ));

          if (VerStock(StrToInt(codArticulo), StrToInt(cant)) = false) then showmessage ('No hay suficiente stock para esa cantidad')
          else
          begin //hay que editar la cantidad en el registro
            Form_Facturacion.StringGrid1.Cells[2,n]:= cant;
            Form_Facturacion.StringGrid1.Cells[4,n]:= '$'+FloatToStr(strtoint(cant) * strtoFloat(normalizarCadena(Form_Facturacion.StringGrid1.Cells[3,n])));
            ActualizarNeto;
            Showmessage('Se ha modificado la cantidad de un articulo.')
          end


        end
          else n:=n+1;
      end;//while

      if (n = Form_Facturacion.StringGrid1.RowCount) then //No encontro el registro, se debe insertar normalmente
        if (VerStock( StrToInt(codArticulo), strToInt( cant) ) = false) then showmessage('No hay suficiente stock para esa cantidad')
        else
          AgregarRegistroATabla(codArticulo, detalle, cant, unitario, total);

    end

  end//else completo todos los campos




end; //clickagregar

procedure ActualizarDatosReporte;
var
  claveCliente, nombreCliente, dniCliente, fecha, nroComp, tipoComp, subtotal,
  descuento, gravado, iva, totalFacturado, formaDePago: string ;
  pos: LO_DobleEnlace.Tipo_Posicion;
  posDatos: LO_Datos_Clientes.Tipo_Posicion;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatos: LO_Datos_Clientes.Tipo_Registro_Datos;

begin
  claveCliente:= Form_Facturacion.ComboBox1.Text;

  //BuscamosDatosDeCliente
  LO_DobleEnlace.DobleEnlace_Buscar(Unit1.ME_Clientes.Indice, claveCliente, pos);
  LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Clientes.Indice, pos, RegistroIndice);
  posDAtos:= RegistroIndice.Posicion;
  LO_Datos_Clientes.Datos_Capturar(Unit1.ME_clientes.Datos, posDatos, RegistroDatos);
  nombreCliente:= RegistroDatos.Nombre;
  dniCliente:= RegistroDatos.Dni;

  //Fecha
  fecha:= DateToStr(Form_Facturacion.DateTimePicker1.Date);

  //Comprobante
  nroComp:= IntToStr(LO_Cola.Cola_UltimoNroComprobante(Unit1.ME_VEntas.Comprobante.Cola)); //Ver ultimo en pila/cola

  tipoComp:= Form_Facturacion.ComboBox2.Text;
  if tipoComp='01' then tipoComp:='A'
    else if tipoComp='02' then tipoComp:='deb. A'
      else if tipoComp='03' then tipoComp:='cred. A'
        else if tipoComp ='50' then tipoComp := 'Recibo X' ;


  //Footer
  subtotal:= Form_Facturacion.Label_Neto.Caption;
  descuento:= Form_Facturacion.Edit4.Text;
  gravado:= FormatFloat('#.##', StrToFloat(subtotal) - ( StrToFloat(subtotal) * ( StrToInt(descuento) / 100 )  ) );
  iva:= FormatFloat('#.##', 0.21 * StrToFloat(gravado)   );
  totalFacturado:= FloatToStr(StrToFloat(gravado) + StrToFloat(iva));
  FormaDePago:= Form_Facturacion.ComboBox3.Text;

  Form_Reporte.QRLabel_ClaveCliente.Caption:= claveCliente;
  Form_Reporte.QRLabel_NombreCliente.Caption:=nombreCliente;
  Form_Reporte.QRLabel_DNICliente.Caption:= dniCliente;
  Form_Reporte.QRLabel_Fecha.Caption:= fecha;
  Form_Reporte.QRLabel_NroComprobante.Caption:= nroComp  ;
  Form_Reporte.QRLabel_TipoComprobante.Caption:= tipoComp ;
  Form_Reporte.QRLabel_Subtotal.Caption:= '$'+subtotal;
  Form_Reporte.QRLabel_Descuento.Caption:= descuento;
  form_Reporte.QRLabel_Gravado.Caption:= '$'+gravado;
  form_reporte.QRLabel_IVA.Caption:= '$'+iva;
  form_reporte.QRLabel_TotalFacturado.Caption:= '$'+totalFacturado;
  form_reporte.QRLabel_FormaDePago.Caption:= formaDePago[1];

end;

procedure ActualizarStockArticulos;
var
  i: longint;
  cCodArticulo, cCant: string;
  pos: LO_ABB.Tipo_Posicion;
  nivel: LO_ABB.Tipo_Cantidad;
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;
  RegistroDatosArticulo: LO_Datos_Articulos.Tipo_Registro_Datos;
  posDatos: longint;
begin
  i:= 1;

  while (i < Form_Facturacion.StringGrid1.RowCount) do
  begin
    cCodArticulo:= Form_Facturacion.StringGrid1.Cells[0, i];
    cCant:= Form_Facturacion.StringGrid1.Cells[2, i];

    LO_ABB.Arbol_Buscar(Unit1.ME_Articulos.Arbol, StrToInt(cCodArticulo), pos, nivel);
    LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol, pos, RegistroArbol);

    posDatos:= RegistroARbol.Posicion;

    LO_Datos_articulos.Datos_Capturar(Unit1.ME_Articulos.Datos, posDatos, RegistroDatosArticulo);

    RegistroDatosArticulo.stock:= RegistroDatosArticulo.stock - strToInt(cCant);

    LO_Datos_Articulos.Datos_Modificar(Unit1.ME_articulos.Datos, posDatos, RegistroDatosArticulo);

    i:=i+1;
  end;

end;

function ValidarFecha(cFecha, cTipoComp: string): boolean; //Se fija si la fecha ingresada no es mayor que el dia actual +1 y que no es menor a la fecha del ultimo comprobante del mismo tipo emitido
var
  bResultado: boolean;
  ultimaFechaEmitida: string;

  begin
  bResultado:= true;
  ultimafechaemitida:='-';

  if (Cola_Vacia(Unit1.ME_Ventas.Comprobante.cola) = true ) then bResultado:= true
  else
  if (StrToDate(cFecha) > now+1) then
  begin
    bResultado:= false;
    Showmessage('La fecha no puede ser mayor a la del dia de ma�ana.')

  end
  else
  begin

    if LO_Cola.UltimaFechaEmitida(Unit1.ME_Ventas.Comprobante.cola, cTipoComp) = '' then bResultado:=true
    else
      if StrToDate(cFecha) < StrToDate(LO_Cola.UltimaFechaEmitida(Unit1.ME_ventas.Comprobante.cola, cTipoComp)) then
      begin
        bResultado:= false;
        showmessage('La fecha ingresada es menor a de la ultima factura del mismo tipo emitida. Debe ser mayor o igual a: '+(LO_Cola.UltimaFechaEmitida(Unit1.ME_ventas.Comprobante.cola, cTipoComp)));
      end
      else
      bResultado:=true;


    
  end;




  ValidarFecha:= bResultado;
end;


function AutorizarFactura( claveCliente: string): boolean; //A COMPLETAR se fija si el cliente esta autorizado a hacer mas movimientos
var
  bResultado: boolean;
  suma: real;
  pilaAux: LO_DobleEnlace.Tipo_Indice;
  RegistroPila: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatosAsiento: LO_Datos_Asientos.Tipo_Registro_Datos;
  posDatos: longint;
begin
  suma:=0;
  bResultado:=true;
  LO_Pila.Pila_Crear(pilaAux, Unit1.sRuta, 'pilaTemp');
  LO_Pila.Pila_Abrir(pilaAux);

  if LO_Pila.Pila_Vacia(Unit1.ME_CuentasCorrientes.Pila) = true then bResultado:=true
  else
  begin
  //Recorrer pila y sumar importes del cliente , si da 0 entonces puede copmrar, sino no
    while Pila_Vacia(Unit1.ME_CuentasCorrientes.Pila) = false do
    begin
      Pila_Tope(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);

      if (RegistroPila.Clave = claveCliente) then
      begin
        posDatos:= RegistroPila.Posicion;
        LO_Datos_Asientos.Datos_Capturar(Unit1.ME_CuentasCorrientes.Datos, posDatos, RegistroDatosAsiento);

        suma:= suma + RegistroDatosAsiento.importe;
      end;

      Pila_Apilar(pilaAux, RegistroPila);
      Pila_Desapilar(Unit1.ME_CuentasCorrientes.Pila);

    end;//while

    //Volvemos a pasar los elementos a la original
    while (Pila_Vacia(pilaAux) = false) do
    begin
      Pila_Tope(pilaAux, RegistroPila);
      Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);
      Pila_Desapilar(pilaAux);
    end;//while

    if suma = 0 then bResultado:= true else bResultado:=false;

  end;

  Pila_Destruir(pilaAux);

  AutorizarFactura:= bResultado;
end;

procedure TForm_Facturacion.BitBtn4Click(Sender: TObject);    //Click en EMITIR FACTURA
var
  RegistroPila, RegistroCola: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatosComprobante: LO_Datos_Comprobantes.Tipo_Registro_Datos;
  RegistroDatosDetalle: LO_Datos_Detalles.Tipo_Registro_Datos;
  codCliente, cPrecioUnitario, cFecha, cTipoComprobante: string;
  i, posDatos, codFactura, nroComprobante: longint;
  RegistroAsiento: LO_Datos_Asientos.Tipo_Registro_Datos;
  nNeto, nGravado, nIVA, nTotal: real;
  nDescuento: integer;
begin
  codCliente:= Form_Facturacion.ComboBox1.Text;
  cFecha:= dateToStr(Form_Facturacion.DateTimePicker1.date);
  cTipoComprobante:= Form_Facturacion.ComboBox2.Text;

    if ( ValidarFecha(cFecha, cTipoComprobante) = true ) then
    begin
      //Cargar factura...

      //Num. de comprobante y cod factura siempre seran iguales. El codigo de la factura se�ala la vinculacion del comprobante con el o los detalles.
      nroComprobante:= LO_Cola.Cola_UltimoNroComprobante(Unit1.Me_Ventas.Comprobante.Cola) + 1;
      codFactura:= LO_Cola.Cola_UltimoNroComprobante(Unit1.Me_Ventas.Comprobante.Cola) + 1;

      //Comprobante
      RegistroDatosComprobante.codFactura:= IntToStr(codFactura);
      RegistroDatosComprobante.codCliente:= codCliente;
      RegistroDatosComprobante.fecha:= DateToStr(Form_Facturacion.DateTimePicker1.date);
      RegistroDatosComprobante.tipoComprobante:= Form_Facturacion.ComboBox2.Text;
      RegistroDatosComprobante.nroComprobante:= nroComprobante;
      RegistroDatosComprobante.neto:= StrToFloat(Form_Facturacion.Label_Neto.Caption);
      RegistroDatosComprobante.descuento:= StrToInt(Form_Facturacion.Edit4.Text);
      RegistroDatosComprobante.gravado:= RegistroDatosComprobante.neto - (RegistroDatosComprobante.descuento/100 * RegistroDatosComprobante.neto);
      RegistroDatosComprobante.IVA:= 0.21 * (RegistroDatosComprobante.gravado);
      RegistroDatosComprobante.total:= RegistroDatosComprobante.gravado + RegistroDatosComprobante.IVA;
      RegistroDatosComprobante.borrado:= false;

      posDatos:= FileSize(ME_Ventas.Comprobante.Datos.D);

      RegistroCola.Clave:= IntToStr(codFactura);
      RegistroCola.Posicion:= posDatos;

      LO_Datos_Comprobantes.Datos_Insertar(Unit1.ME_Ventas.Comprobante.Datos, RegistroDatosComprobante);
      LO_Cola.Cola_EncolarConFecha(Unit1.ME_Ventas.Comprobante.Cola, RegistroCola,RegistroDatosComprobante.tipoComprobante, RegistroDatosComprobante.fecha );

      //DETALLE (UN REGISTRO POR CADA UNO DE LOS REGISTROS DEL STRINGGRID)

      for i:= 1 to (Form_Facturacion.StringGrid1.RowCount - 1 ) do
      begin

        cPrecioUnitario:= NormalizarCadena(Form_Facturacion.StringGrid1.Cells[3, i]);
        RegistroDatosDetalle.codFactura:= IntToStr(codFactura);
        RegistroDatosDetalle.codArticulo:= strToInt(Form_Facturacion.StringGrid1.Cells[0, i]);
        RegistroDatosDetalle.descripcion:= Form_Facturacion.StringGrid1.Cells[1, i];
        RegistroDatosDetalle.cant:= StrToInt(Form_Facturacion.StringGrid1.Cells[2, i]);
        RegistroDatosDetalle.precioUnitario:= StrToFloat(cPrecioUnitario);
        RegistroDatosDetalle.Borrado:=false;

        posDatos:= FileSize(Unit1.ME_Ventas.Detalle.Datos.D);

        RegistroPila.Clave:= IntToStr(codFactura);
        RegistroPila.Posicion:= posDatos;

        LO_Datos_Detalles.Datos_Insertar(Unit1.ME_Ventas.Detalle.Datos, RegistroDatosDetalle);
        Lo_Pila.Pila_Apilar(Unit1.ME_Ventas.Detalle.Pila, RegistroPila);
      end; //for detalle

      //Asiento en Cta Corriente

      nNeto:= StrToFloat(Form_Facturacion.Label_Neto.Caption);
      nDescuento:= StrToInt(Form_Facturacion.Edit4.Text);
      nGravado:= nNeto - ( ( nDescuento / 100 ) * nNeto );
      nIVA:= 0.21 * nGravado;
      nTotal:= nGravado + nIVA;

      if (Form_Facturacion.ComboBox3.Text = '1: Contado') then
      begin
        RegistroAsiento.CodCliente:= codCliente;
        RegistroAsiento.nroComprobante:=nroComprobante;
        RegistroAsiento.fecha:= DateToStr(Form_Facturacion.DateTimePicker1.date);
        RegistroAsiento.importe:= 0 - nTotal;

        posDatos:= FileSize(Unit1.ME_CuentasCorrientes.Datos.D) ;

        RegistroPila.Clave:= codCliente;
        RegistroPila.Posicion:= posDatos;

        LO_Datos_Asientos.Datos_Insertar(Unit1.ME_CuentasCorrientes.Datos, RegistroAsiento);
        LO_Pila.Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);  //CARGAMOS EL DEBE

        RegistroAsiento.CodCliente:= codCliente;
        RegistroAsiento.nroComprobante:=nroComprobante;
        RegistroAsiento.fecha:= DateToStr(Form_Facturacion.DateTimePicker1.date);
        RegistroAsiento.importe:= nTotal;

        posDatos:= FileSize(Unit1.ME_CuentasCorrientes.Datos.D);

        RegistroPila.Clave:= codCliente;
        RegistroPila.Posicion:= posDatos;

        LO_Datos_Asientos.Datos_Insertar(Unit1.ME_CuentasCorrientes.Datos, RegistroAsiento);
        LO_Pila.Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila); //CARGAMOS EL HABER

      end
      else
      begin
        //Cargamos solo el DEBE
        RegistroAsiento.CodCliente:= codCliente;
        RegistroAsiento.nroComprobante:=nroComprobante;
        RegistroAsiento.fecha:= DateToStr(Form_Facturacion.DateTimePicker1.date);
        RegistroAsiento.importe:= 0 - nTotal;

        posDatos:= FileSize(Unit1.ME_CuentasCorrientes.Datos.D) ;

        RegistroPila.Clave:= codCliente;
        RegistroPila.Posicion:= posDatos;

        LO_Datos_Asientos.Datos_Insertar(Unit1.ME_CuentasCorrientes.Datos, RegistroAsiento);
        LO_Pila.Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);  //CARGAMOS EL DEBE

      end;

      //Actualizar stock de articulos

      ActualizarStockArticulos;


      //Preparar reporte

      ActualizarDatosReporte;

      //Presentar listado.

      Form_Reporte.QuickRep1.Preview;

      Showmessage('Se ha guardado registro de factura.');


    end; //end if fecha

end;

procedure LimpiarCampos;
begin
  Form_Facturacion.Memo1.Clear;
  Form_Facturacion.Edit2.Clear;

  Form_Facturacion.Edit3.Clear;
  Form_Facturacion.Edit3.Enabled:=false;
  Form_Facturacion.Label11.Caption:= '';

end;

procedure TForm_Facturacion.Edit1Change(Sender: TObject);
var
  s: string;
  n: longint;
  pos: LO_ABB.Tipo_Posicion;
  nivel: LO_ABB.Tipo_Cantidad;
  RegistroArbol: LO_ABB.Tipo_Registro_Indice;

  RegistroDatos: LO_Datos_Articulos.Tipo_Registro_Datos;
  posDatos: LO_Datos_Articulos.Tipo_Posicion;

begin
  s:= Form_Facturacion.Edit1.Text;

  if Length(s) <> 4 then LimpiarCampos
  else
  begin
    if TryStrToInt(s, n) = false then showmessage('Ingrese un codigo de articulo valido. Formato "1111" ')
    else
    begin
      if (LO_ABB.Arbol_Buscar(Unit1.ME_Articulos.Arbol,StrToInt(s), pos, nivel) = true) then
       begin
        LO_ABB.Arbol_Capturar(Unit1.ME_Articulos.Arbol, pos, RegistroArbol);
        posDatos:= RegistroArbol.Posicion;

        LO_Datos_Articulos.Datos_Capturar(Unit1.ME_Articulos.Datos, posDatos, RegistroDatos);

        Form_Facturacion.Memo1.Text:= registroDatos.Descripcion;
        Form_Facturacion.Edit2.Text:= FloatToStr(RegistroDatos.PrecioUnitario);
        Form_Facturacion.Edit3.Enabled:=true;
        Form_Facturacion.Edit3.SetFocus;
      
      end
    end
  end
end;

procedure TForm_Facturacion.Edit3Change(Sender: TObject);
var
  s: String;
  n: integer;
begin
  s:= Form_Facturacion.Edit3.Text;

  if s='0' then Form_Facturacion.Edit3.Text:='';

  if (s = '') then Form_Facturacion.Label11.Caption:=''
  else
  begin
    if (TryStrToInt(s , n) = false) then
    begin
           showmessage('Ingrese cantidad valida');
           Form_Facturacion.Edit3.Text:='';
    end

    else
    begin
      Form_Facturacion.Label11.Caption:= FloatToStr( n * StrToFloat(Form_Facturacion.Edit2.Text) ) ;
    end
  end


end;

procedure TForm_Facturacion.ComboBox2Change(Sender: TObject);
begin

  if  (Form_Facturacion.ComboBox2.Text = '') then Form_Facturacion.BitBtn4.Enabled:= false;

  if (Form_Facturacion.StringGrid1.RowCount > 1) and (Form_Facturacion.Edit4.Text <> '') and
    (Form_Facturacion.ComboBox2.Text <> '') and (Form_Facturacion.ComboBox3.Text <> '')
   then
  begin
    Form_Facturacion.BitBtn4.Enabled:= true;
  end
  else
    Form_Facturacion.BitBtn4.Enabled:= false;
end;

procedure TForm_Facturacion.Edit4Change(Sender: TObject);
var
  s:String;
  n: longint;
begin
  s:= Form_Facturacion.Edit4.Text;

  if (s = '') then  Form_Facturacion.BitBtn4.Enabled:= false;

  if (TryStrToInt(s,n)) then
  begin
    if (Form_Facturacion.StringGrid1.RowCount > 1) and (Form_Facturacion.ComboBox2.Text <> '') and
    (Form_Facturacion.ComboBox3.Text <> '') and (Form_Facturacion.Edit4.Text <> '')
    then
      Form_Facturacion.BitBtn4.Enabled:= true
    else
      Form_Facturacion.BitBtn4.Enabled:= false;
    end
  
end;

procedure TForm_Facturacion.ComboBox3Change(Sender: TObject);
begin

if  (Form_Facturacion.ComboBox3.Text = '') then Form_Facturacion.BitBtn4.Enabled:= false;

  if (Form_Facturacion.StringGrid1.RowCount > 1) and (Form_Facturacion.Edit4.Text <> '') and
    (Form_Facturacion.ComboBox2.Text <> '') and (Form_Facturacion.ComboBox3.Text <> '')
   then
  begin
    Form_Facturacion.BitBtn4.Enabled:= true;
  end
  else
    Form_Facturacion.BitBtn4.Enabled:= false;
end;

end.
