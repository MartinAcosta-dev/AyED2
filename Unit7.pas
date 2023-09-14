unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls;

type
  TForm_Reporte = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel_NroComprobante: TQRLabel;
    QRLabel_TipoComprobante: TQRLabel;
    QRShape1: TQRShape;
    QRLabel5: TQRLabel;
    QRLabel_ClaveCliente: TQRLabel;
    QRLabel_6: TQRLabel;
    QRLabel_NombreCliente: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel_Fecha: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel_DNICliente: TQRLabel;
    QRShape2: TQRShape;
    QRBand3: TQRBand;
    GroupHeaderBand1: TQRBand;
    QRLabel11: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel12: TQRLabel;
    QRShape3: TQRShape;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel_Subtotal: TQRLabel;
    QRLabel_Descuento: TQRLabel;
    QRLabel_Gravado: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel_IVA: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel_TotalFacturado: TQRLabel;
    QRLabel21: TQRLabel;
    QRLabel_FormaDePago: TQRLabel;
    QRLabel23: TQRLabel;
    QRShape4: TQRShape;
    QRBand4: TQRBand;
    QRLabel_codArt: TQRLabel;
    QRLabel_Detalle: TQRLabel;
    QRLabel_cant: TQRLabel;
    QRLabel_uni: TQRLabel;
    QRLabel_total: TQRLabel;
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Reporte: TForm_Reporte;
  posArticulos: integer;

implementation

uses Unit6;

{$R *.dfm}

procedure TForm_Reporte.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  posArticulos  := 1;
end;

procedure TForm_Reporte.QuickRep1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData := (  posArticulos < Form_Facturacion.StringGrid1.RowCount);
  if MoreData then
  begin
    QRLabel_codArt.Caption := Form_Facturacion.StringGrid1.Cells [0, posArticulos];
    QRLabel_Detalle.Caption    := Form_Facturacion.StringGrid1.Cells  [1, posArticulos];
    QRLabel_cant.Caption := Form_Facturacion.StringGrid1.Cells  [2, posArticulos];
    QRLabel_uni.Caption      := Form_Facturacion.StringGrid1.Cells  [3, posArticulos];
    QRLabel_total.Caption        := Form_Facturacion.StringGrid1.Cells  [4, posArticulos];

    // Proximo elemento de la grilla
    posArticulos := Succ (posArticulos)  ;

  end;
end;



end.
