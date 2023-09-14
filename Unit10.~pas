unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, LO_Datos_Clientes, LO_DobleEnlace,
  LO_Datos_Asientos, LO_Pila, LO_Cola, LO_Datos_Comprobantes;

type
  TForm_ListadosCC = class(TForm)
    Image1: TImage;
    Button1: TButton;
    StringGrid1: TStringGrid;
    StringGrid_CCCliente: TStringGrid;
    ComboBox1: TComboBox;
    StringGrid_ResumenCC: TStringGrid;
    StringGrid_Comprobantes: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label_SumaTotal: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_ListadosCC: TForm_ListadosCC;

implementation

{$R *.dfm}

uses
  Unit1;

procedure TForm_ListadosCC.Button1Click(Sender: TObject);
begin
  Form_ListadosCC.Close;
end;

procedure LimpiarTablaClientes;
var
  i: longint;
begin
  for i:= 1 to Form_ListadosCC.StringGrid1.RowCount  do
  begin
    Form_ListadosCC.StringGrid1.Rows[i].Clear;
  end;

end;

procedure ListarClientes;
var
  RegistroDatos: LO_Datos_Clientes.Tipo_Registro_Datos;
  RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  posicion, posDatos: LO_DobleEnlace.Tipo_Posicion;
  i: longint;
begin
  LimpiarTablaClientes;
  Form_ListadosCC.StringGrid1.Cells[0,0]:= 'Cód.';
  Form_ListadosCC.StringGrid1.Cells[1,0]:= 'Nombre';
  Form_ListadosCC.StringGrid1.Cells[2,0]:= 'DNI';
  Form_ListadosCC.StringGrid1.RowCount:= 1;
  
  posicion:= LO_DobleEnlace.DobleEnlace_Primero(Unit1.ME_Clientes.Indice);

  i:= 1;

  while (posicion <> LO_DobleEnlace.DobleEnlace_PosNula(Unit1.ME_Clientes.Indice)) do
  begin
    Form_ListadosCC.StringGrid1.RowCount:= Form_ListadosCC.StringGrid1.RowCount + 1;

    Lo_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Clientes.Indice, posicion, RegistroIndice);
    posDatos:= registroIndice.Posicion;
    LO_Datos_Clientes.Datos_Capturar(Unit1.ME_clientes.Datos, posDatos, RegistroDatos);

    Form_ListadosCC.StringGrid1.Cells[0, i]:= RegistroDatos.Clave;
    Form_ListadosCC.StringGrid1.Cells[1, i]:= RegistroDatos.Nombre;
    Form_ListadosCC.StringGrid1.Cells[2, i]:= RegistroDatos.Dni;

    i:=i+1;
    posicion:= RegistroIndice.Sig;
  end;//while


end;  //End ListarClientes


procedure TForm_ListadosCC.FormCreate(Sender: TObject);
begin
  ListarClientes;
end;

procedure ListarComprobantesPorCliente(claveCliente : string);
var
  pilaAuxCC, colaAuxComp: LO_DobleEnlace.Tipo_Indice;
  RegistroPila, RegistroCola: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatosAsiento: LO_Datos_Asientos.Tipo_Registro_Datos;
  RegistroDatosComprobante: LO_Datos_Comprobantes.Tipo_Registro_Datos;
  posDatos, i, nroComprobante, nroComprobanteAUX: longint;
  sumaTotal:real;
  bCorte: boolean;

begin
  Pila_Crear(pilaAuxCC, Unit1.sRuta, 'pilaTemp');
  Pila_Abrir(pilaAuxCC);
  Cola_Crear(colaAuxComp, unit1.sRuta, 'colaTemp');
  Cola_Abrir(colaAuxComp);

  Form_ListadosCC.StringGrid_Comprobantes.Cells[0,0]:='CLAVE';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[1,0]:='FECHA';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[2,0]:='TIPO';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[3,0]:='NRO.';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[4,0]:='NETO';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[5,0]:='DESCUENTO';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[6,0]:='GRAVADO';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[7,0]:='IVA';
  Form_ListadosCC.StringGrid_Comprobantes.Cells[8,0]:='TOTAL';

  Form_ListadosCC.StringGrid_Comprobantes.RowCount:=1;
  i:=1;
  sumaTotal:=0;

  
  while (Pila_Vacia(Unit1.ME_CuentasCorrientes.Pila) = false) do
  begin
    Pila_Tope(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);
    bCorte:=false;
    
    if (RegistroPila.Clave = claveCliente) then
    begin
      posDatos:= registroPila.Posicion;
      LO_Datos_Asientos.Datos_Capturar(Unit1.ME_CuentasCorrientes.Datos, posDatos, RegistroDatosASiento);
      nroComprobante:= RegistroDatosAsiento.nroComprobante;

      while (Cola_Vacia(Unit1.ME_Ventas.Comprobante.Cola) = false) and (bCorte = false) do
      begin
        Cola_Frente(Unit1.ME_Ventas.Comprobante.Cola, RegistroCola);

        if (RegistroCola.Clave = intToStr(nroComprobante)) then
        begin
          bCorte:=True;
          posDatos:= RegistroCOla.Posicion;
          LO_Datos_Comprobantes.Datos_Capturar(Unit1.ME_Ventas.Comprobante.Datos, posDatos, RegistroDatosComprobante);

          if RegistroDatosAsiento.importe < 0 then
          begin
              //Listar Reg
              Form_ListadosCC.StringGrid_Comprobantes.RowCount:= Form_ListadosCC.StringGrid_Comprobantes.RowCount + 1;

              Form_ListadosCC.StringGrid_Comprobantes.Cells[0,i]:= claveCliente;
              Form_ListadosCC.StringGrid_Comprobantes.Cells[1,i]:= RegistroDatosComprobante.fecha;
              Form_ListadosCC.StringGrid_Comprobantes.Cells[2,i]:= registroDatosComprobante.tipoComprobante;
              Form_ListadosCC.StringGrid_Comprobantes.Cells[3, i]:= intToStr(nroComprobante);
              Form_ListadosCC.StringGrid_Comprobantes.Cells[4, i]:= '$ '+FormatFloat('#.##', RegistroDatosComprobante.neto);
              Form_ListadosCC.StringGrid_Comprobantes.Cells[5, i]:= '% '+IntToStr(RegistroDatosComprobante.descuento);
              Form_ListadosCC.StringGrid_Comprobantes.Cells[6, i]:= '$ '+FormatFloat('#.##', RegistroDatosComprobante.gravado);
              Form_ListadosCC.StringGrid_Comprobantes.Cells[7, i]:= '$ '+FormatFloat('#.##', RegistroDatosComprobante.IVA);
              Form_ListadosCC.StringGrid_Comprobantes.Cells[8, i]:= '$ '+FormatFloat('#.##', RegistroDatosComprobante.total);
              sumaTotal:= sumaTotal + RegistroDatosComprobante.total;
              i:=i+1;
            end


        end;//endif

        Cola_Encolar(colaAuxComp, RegistroCola);
        Cola_Decolar(unit1.ME_Ventas.Comprobante.Cola);
      end;//while colaComp

      //Volvemos a dejar la colaCompr como estaba
      while (Cola_Vacia(colaAuxComp) = false) do
      begin
        Cola_Frente(colaAuxComp, REgistroCola);
        Cola_Encolar(Unit1.ME_Ventas.Comprobante.Cola, RegistroCola);
        Cola_Decolar(colaAuxComp);
      end;

    end;//End if CCclave = codCliente


    Pila_Desapilar(Unit1.ME_CuentasCorrientes.Pila);
    Pila_Apilar(pilaAuxCC, RegistroPila);
  end;//pilaCC

  //Volvemos a dejar la pila como estaba
  while (Pila_Vacia(pilaAuxCC) = false) do
  begin
    Pila_Tope(pilaAuxCC, RegistroPila);
    Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);
    Pila_Desapilar(pilaAuxCC);
  end;

  Form_ListadosCC.Label_SumaTotal.Caption:= FormatFloat('#.##', sumaTotal);

  Pila_Destruir(pilaAuxCC);
  Cola_Destruir(colaAuxComp);
end;

procedure ListarResumenCC;
var
  pilaAuxCC: LO_DobleEnlace.Tipo_Indice;
  RegistroPila, RegistroIndice: LO_DobleEnlace.Tipo_Registro_Indice;
  RegistroDatosAsiento: LO_Datos_Asientos.Tipo_Registro_Datos;
  pos, posDatos, i: Longint;
  suma: real;
  RegistroDatosCliente: LO_Datos_Clientes.Tipo_Registro_Datos;
  nombreCliente: string;
begin
  LO_Pila.Pila_Crear(pilaAuxCC, unit1.sRuta, 'pilaTemp');
  LO_Pila.Pila_Abrir(pilaAuxCC);

  pos:= LO_DobleEnlace.DobleEnlace_Primero(Unit1.ME_Clientes.Indice);
  Form_ListadosCC.StringGrid_ResumenCC.Cells[0,0]:='CLAVE';
  Form_ListadosCC.StringGrid_ResumenCC.Cells[1,0]:='CLIENTE';
  Form_ListadosCC.StringGrid_ResumenCC.Cells[2,0]:='SUMA DE IMPORTES';
  Form_ListadosCC.StringGrid_ResumenCC.RowCount:=1;
  i:=1;


  if (LO_DobleEnlace.DobleEnlace_Vacio(Unit1.ME_Clientes.Indice) = false) then
  begin
    while pos <> LO_DobleEnlace.DobleEnlace_PosNula(Unit1.ME_Clientes.Indice) do
    begin
      suma:=0;
      DobleEnlace_Capturar(Unit1.ME_Clientes.Indice, pos, RegistroIndice);
      posDatos:= RegistroIndice.Posicion;
      LO_Datos_Clientes.Datos_Capturar(Unit1.ME_Clientes.Datos, posDatos, RegistroDatosCliente);
      nombreCliente:= RegistroDatosCliente.nombre;


      while (Pila_Vacia(Unit1.ME_CuentasCorrientes.Pila) = false) do
      begin
        Pila_Tope(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);

        if (RegistroPila.Clave = RegistroIndice.Clave) then
        begin
          posDatos:= RegistroPila.Posicion;
          LO_Datos_Asientos.Datos_Capturar(Unit1.ME_CuentasCorrientes.Datos, posDatos, RegistroDatosAsiento);
          if (RegistroDatosAsiento.importe > 0) then suma:= suma + RegistroDatosAsiento.importe;
        end;

        Pila_Apilar(pilaAuxCC, REgistroPila);
        Pila_Desapilar(Unit1.ME_CuentasCorrientes.Pila);
      end;//pila CC

      //Volvemos a dejar la pilaCC como estaba
      while Pila_Vacia(pilaAuxCC) = false do
      begin
        Pila_Tope(pilaAuxCC, RegistroPila);
        Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);
        Pila_Desapilar(pilaAuxCC);
      end;

      Form_listadosCC.StringGrid_ResumenCC.RowCount:= Form_ListadosCC.StringGrid_ResumenCC.RowCount + 1;
      Form_ListadosCC.StringGrid_ResumenCC.Cells[0, i]:= RegistroIndice.Clave;
      Form_ListadosCC.StringGrid_ResumenCC.Cells[1, i]:= nombreCliente;
      Form_ListadosCC.StringGrid_ResumenCC.Cells[2,i]:= '$ '+( FormatFloat('#.##', suma) );
      i:=i+1;

     pos:= RegistroIndice.Sig;
    end;//while

  end;

  LO_Pila.Pila_Destruir(pilaAuxCC);
end;

procedure ListarCCDeCliente(clave: string);
var
  PilaAuxCC, ColaAuxComp: LO_DobleEnlace.Tipo_Indice;
  RegistroPila, RegistroCola, RegistroCliente: LO_DobleEnlace.Tipo_Registro_indice;
  RegistroDatosCliente: LO_Datos_Clientes.Tipo_Registro_Datos;
  RegistroDatosAsiento: LO_Datos_Asientos.Tipo_Registro_Datos;
  RegistroDatosComprobante: LO_Datos_Comprobantes.Tipo_REgistro_Datos;
  posDatos, pos, nroComprobante, i: longint;

  nombreCliente, fecha, tipoComprobante, importe: string;
begin
  LO_Pila.Pila_Crear(pilaAuxCC, unit1.sRuta, 'pilaTemp');
  LO_Pila.Pila_Abrir(pilaAuxCC);
  LO_Cola.Cola_Crear(ColaAuxComp, unit1.sRuta, 'colaTemp');
  LO_Cola.Cola_Abrir(ColaAuxComp);

  LO_DobleEnlace.DobleEnlace_Buscar(Unit1.ME_Clientes.Indice, clave, pos);
  LO_DobleEnlace.DobleEnlace_Capturar(Unit1.ME_Clientes.Indice, pos, RegistroCliente);
  posDatos:= RegistroCliente.Posicion;
  LO_Datos_Clientes.Datos_Capturar(Unit1.ME_Clientes.Datos, posDatos, RegistroDatosCliente);

  Form_ListadosCC.StringGrid_CCCliente.RowCount:= 1;
  

  Form_ListadosCC.StringGrid_CCCliente.Cells[0,0]:='CLAVE';
  Form_ListadosCC.StringGrid_CCCliente.Cells[1,0]:='NOMBRE CLIENTE';
  Form_ListadosCC.StringGrid_CCCliente.Cells[2,0]:='FECHA';
  Form_ListadosCC.StringGrid_CCCliente.Cells[3,0]:='TIPO COMP.';
  Form_ListadosCC.StringGrid_CCCliente.Cells[4,0]:='NRO. COMP.';
  Form_ListadosCC.StringGrid_CCCliente.Cells[5,0]:='IMPORTE';


  nombreCliente:= RegistroDatosCliente.Nombre;

  while Pila_Vacia(Unit1.ME_CuentasCorrientes.Pila) = false do
  begin
    Pila_Tope(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);

    if (RegistroPila.Clave = clave) then
    begin
      posDatos:= RegistroPila.Posicion;
      LO_Datos_Asientos.Datos_Capturar(Unit1.ME_CuentasCorrientes.Datos, posDatos, RegistroDatosAsiento);

      nroComprobante:= RegistroDatosAsiento.nroComprobante;

      while (Cola_Vacia(Unit1.ME_Ventas.Comprobante.Cola) = false) {and (RegistroDatosAsiento.importe > 0) }do
      begin
        Cola_Frente(Unit1.ME_Ventas.Comprobante.Cola, RegistroCola);

        if ( IntToSTr(nroComprobante) = RegistroCola.Clave ) then
        begin
          posDatos:= REgistroCOla.Posicion;
          LO_Datos_Comprobantes.Datos_Capturar(Unit1.ME_Ventas.Comprobante.Datos, posDatos, RegistroDatosComprobante);

          fecha:= registroDatosComprobante.fecha;
          tipoComprobante:= RegistroDatosComprobante.tipoComprobante;
          Importe:= FormatFloat('#.##',RegistroDatosAsiento.importe);



          Form_ListadosCC.StringGrid_CCCliente.RowCount:= Form_ListadosCC.StringGrid_CCCliente.RowCount + 1;

          for i:= Form_ListadosCC.StringGrid_CCCliente.RowCount - 1 downto 1 do
          begin
            Form_ListadosCC.StringGrid_CCCliente.Rows[i+1].Assign(Form_ListadosCC.StringGrid_CCCliente.Rows[i]);
          end;

          Form_ListadosCC.StringGrid_CCCliente.Cells[0,1]:= clave;
          Form_ListadosCC.StringGrid_CCCliente.Cells[1,1]:= nombreCliente;
          Form_ListadosCC.StringGrid_CCCliente.Cells[2,1]:= fecha;
          Form_ListadosCC.StringGrid_CCCliente.Cells[3,1]:= tipoComprobante;
          Form_ListadosCC.StringGrid_CCCliente.Cells[4,1]:= IntToStr(NroComprobante);
          Form_ListadosCC.StringGrid_CCCliente.Cells[5,1]:= '$ '+importe;

        end;


        Cola_Encolar(colaAuxComp, RegistroCola);
        Cola_Decolar(Unit1.ME_Ventas.Comprobante.Cola);
      end;//ColaComp

    end;

    //Dejamos cola como estaba
    while Cola_Vacia(ColaAuxComp) = false do
    begin
      Cola_Frente(colaAuxComp, RegistroCola);
      Cola_Encolar(Unit1.ME_Ventas.Comprobante.Cola, RegistroCola);
      Cola_Decolar(colaAuxComp);
    end;


    Pila_Apilar(PilaAuxCC, RegistroPila);
    Pila_Desapilar(Unit1.ME_CuentasCorrientes.Pila);
  end; //PilaCC

  //Dejamos pila CC como estaba
  while (Pila_Vacia(pilaAuxCC)=false) do
  begin
    Pila_Tope(pilaAuxCC, RegistroPila);
    Pila_Apilar(Unit1.ME_CuentasCorrientes.Pila, RegistroPila);
    Pila_Desapilar(pilaAuxCC);
  end;

  LO_Pila.Pila_Destruir(pilaAuxCC);
  LO_Cola.Cola_Destruir(ColaAuxComp);
end;

procedure TForm_ListadosCC.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (Form_ListadosCC.ComboBox1.Text ='Cta. Corriente de un Cliente') and (aRow <> 0)  then
  begin
    ListarCCDeCliente(Form_ListadosCC.StringGrid1.Cells[0, aRow]);
  end else
  if (Form_ListadosCC.ComboBox1.Text = 'Comprobantes de un Cliente') and (aRow <> 0) then
  begin
    ListarComprobantesPorCliente(Form_ListadosCC.StringGrid1.Cells[0, aRow]);
  end
end;

procedure TForm_ListadosCC.ComboBox1Change(Sender: TObject);
var
  s: String;
begin
  s:= Form_ListadosCC.ComboBox1.Text;

  if s='Cta. Corriente de un Cliente' then
  begin
    Form_listadosCC.Label1.Visible:=true;
    Form_ListadosCC.StringGrid_CCCliente.Visible:=true;
    Form_ListadosCC.StringGrid_ResumenCC.Visible:= false;
    Form_ListadosCC.StringGrid_Comprobantes.Visible:=false;
    Form_listadoscc.Label2.Visible:=false;
    Form_listadoscc.Label_SumaTotal.Visible:=false;
    ListarClientes;
  end else
  if s= 'Resumen Cuentas Corrientes' then
  begin
    Form_listadosCC.Label1.Visible:=false;
    Form_ListadosCC.StringGrid_CCCliente.Visible:=false;
    Form_ListadosCC.StringGrid_ResumenCC.Visible:= true;
    Form_ListadosCC.StringGrid_Comprobantes.Visible:=false;
    Form_listadoscc.Label2.Visible:=false;
    Form_listadoscc.Label_SumaTotal.Visible:=false;

    ListarResumenCC;
  end else
  if s= 'Comprobantes de un Cliente'  then
  begin
    Form_listadosCC.Label1.Visible:=true;
    Form_ListadosCC.StringGrid_CCCliente.Visible:=false;
    Form_ListadosCC.StringGrid_ResumenCC.Visible:= false;
    Form_ListadosCC.StringGrid_Comprobantes.Visible:=true;
    Form_listadoscc.Label2.Visible:=true;
    Form_listadoscc.Label_SumaTotal.Visible:=true;
    ListarClientes;
  end

end;

end.
