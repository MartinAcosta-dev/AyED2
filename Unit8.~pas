unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls;

type
  TForm_Reporte_Articulos = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRLabel_CodArtheader: TQRLabel;
    QRLabel_Descheader: TQRLabel;
    QRLabel_Stockheader: TQRLabel;
    QRLabel_Costoheader: TQRLabel;
    QRLabel_Unitarioheader: TQRLabel;
    QRShape1: TQRShape;
    QRLabel_Fecha: TQRLabel;
    QRShape2: TQRShape;
    QRLabel_codArt: TQRLabel;
    QRLabel_Desc: TQRLabel;
    QRLabel_stock: TQRLabel;
    QRLabel_Costo: TQRLabel;
    QRLabel_unitario: TQRLabel;
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Reporte_Articulos: TForm_Reporte_Articulos;
  posArticulos: longint;

implementation

uses Unit4;

{$R *.dfm}

procedure TForm_Reporte_Articulos.QuickRep1BeforePrint(
  Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  posArticulos  := 1;
end;

procedure TForm_Reporte_Articulos.QuickRep1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData := (  posArticulos < Form_Articulos.StringGrid1.RowCount);
  if MoreData then
  begin
    QRLabel_codArt.Caption  := Form_Articulos.StringGrid1.Cells [0, posArticulos];
    QRLabel_Desc.Caption    := Form_Articulos.StringGrid1.Cells [2, posArticulos];
    QRLabel_stock.Caption   := Form_Articulos.StringGrid1.Cells [5, posArticulos];
    QRLabel_Costo.Caption   := Form_Articulos.StringGrid1.Cells [3, posArticulos];
    QRLabel_Unitario.Caption:= Form_Articulos.StringGrid1.Cells [4, posArticulos];

    // Proximo elemento de la grilla
    posArticulos := Succ (posArticulos)  ;

  end;
end;

end.
