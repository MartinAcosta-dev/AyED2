program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form_MenuPrincipal},
  LO_Datos_Clientes in 'LO_Datos_Clientes.pas',
  LO_DobleEnlace in 'LO_DobleEnlace.pas',
  Unit2 in 'Unit2.pas' {Form_Clientes},
  Unit3 in 'Unit3.pas' {Form_Rubros},
  LO_Datos_Rubros in 'LO_Datos_Rubros.pas',
  LO_Datos_Articulos in 'LO_Datos_Articulos.pas',
  Unit4 in 'Unit4.pas' {Form_Articulos},
  LO_ABB in 'LO_ABB.pas',
  LO_Indice in 'LO_Indice.pas',
  Unit5 in 'Unit5.pas' {Form_Mantenimiento},
  Unit6 in 'Unit6.pas' {Form_Facturacion},
  LO_Datos_Comprobantes in 'LO_Datos_Comprobantes.pas',
  LO_Datos_Detalles in 'LO_Datos_Detalles.pas',
  LO_Cola in 'LO_Cola.pas',
  LO_Pila in 'LO_Pila.pas',
  Unit7 in 'Unit7.pas' {Form_Reporte},
  LO_Datos_Asientos in 'LO_Datos_Asientos.pas',
  Unit8 in 'Unit8.pas' {Form_Reporte_Articulos},
  Unit9 in 'Unit9.pas' {Form_Listados},
  Unit10 in 'Unit10.pas' {Form_ListadosCC};

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TForm_MenuPrincipal, Form_MenuPrincipal);
  Application.CreateForm(TForm_Clientes, Form_Clientes);
  Application.CreateForm(TForm_Rubros, Form_Rubros);
  Application.CreateForm(TForm_Articulos, Form_Articulos);
  Application.CreateForm(TForm_Mantenimiento, Form_Mantenimiento);
  Application.CreateForm(TForm_Facturacion, Form_Facturacion);
  Application.CreateForm(TForm_Reporte, Form_Reporte);
  Application.CreateForm(TForm_Reporte_Articulos, Form_Reporte_Articulos);
  Application.CreateForm(TForm_Listados, Form_Listados);
  Application.CreateForm(TForm_ListadosCC, Form_ListadosCC);
  Application.Run;
end.
