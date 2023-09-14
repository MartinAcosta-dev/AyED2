object Form_Mantenimiento: TForm_Mantenimiento
  Left = 222
  Top = 137
  Width = 877
  Height = 494
  Caption = 'Menu Mantenimiento'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 811
    Top = 336
    Width = 3
    Height = 13
  end
  object Label7: TLabel
    Left = 720
    Top = 312
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 576
    Top = 208
    Width = 177
    Height = 18
    Caption = 'El '#225'rbol esta balanceado! :)'
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object Label2: TLabel
    Left = 576
    Top = 240
    Width = 185
    Height = 18
    Caption = 'El '#225'rbol est'#225' desbalanceado.'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object Label3: TLabel
    Left = 576
    Top = 264
    Width = 168
    Height = 18
    Caption = 'Se recomienda balancear.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label5: TLabel
    Left = 576
    Top = 312
    Width = 137
    Height = 14
    Caption = 'Porcentaje de tolerancia:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 576
    Top = 336
    Width = 225
    Height = 14
    Caption = 'Porcentaje de niveles tenidos en cuenta:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 40
    Top = 432
    Width = 225
    Height = 14
    Caption = '(Hijo izquierdo arriba, Hijo derecho abajo)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label9: TLabel
    Left = 744
    Top = 312
    Width = 11
    Height = 13
    Caption = '%'
  end
  object Label10: TLabel
    Left = 832
    Top = 336
    Width = 11
    Height = 13
    Caption = '%'
  end
  object TreeView1: TTreeView
    Left = 32
    Top = 200
    Width = 257
    Height = 225
    Indent = 19
    TabOrder = 0
  end
  object RadioButton1: TRadioButton
    Left = 32
    Top = 32
    Width = 177
    Height = 17
    Cursor = crHandPoint
    Caption = 'Doble enlace'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 32
    Top = 72
    Width = 113
    Height = 17
    Cursor = crHandPoint
    Caption = 'Pilas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = RadioButton2Click
  end
  object RadioButton3: TRadioButton
    Left = 32
    Top = 112
    Width = 113
    Height = 17
    Cursor = crHandPoint
    Caption = 'Colas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = RadioButton3Click
  end
  object RadioButton4: TRadioButton
    Left = 32
    Top = 152
    Width = 209
    Height = 17
    Cursor = crHandPoint
    Caption = 'ABB (Arbol Binario de B'#250'squeda)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = RadioButton4Click
  end
  object Button2: TButton
    Left = 248
    Top = 32
    Width = 185
    Height = 25
    Caption = 'ELIMINAR ARCHIVOS DE CLIENTES'
    TabOrder = 5
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 448
    Top = 32
    Width = 185
    Height = 25
    Caption = 'ELIMINAR ARCHIVOS DE RUBROS'
    TabOrder = 6
    Visible = False
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 304
    Top = 200
    Width = 257
    Height = 225
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 7
  end
  object Button4: TButton
    Left = 248
    Top = 72
    Width = 185
    Height = 25
    Caption = 'ELIMINAR PILAS'
    TabOrder = 8
    Visible = False
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 248
    Top = 112
    Width = 185
    Height = 25
    Caption = 'ELIMINAR COLAS'
    TabOrder = 9
    Visible = False
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 248
    Top = 144
    Width = 185
    Height = 25
    Caption = 'REBALANCEAR '#193'RBOL'
    Enabled = False
    TabOrder = 10
    Visible = False
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 448
    Top = 144
    Width = 169
    Height = 25
    Caption = 'CAMBIAR PORCENTAJES'
    TabOrder = 11
    Visible = False
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 632
    Top = 144
    Width = 185
    Height = 25
    Caption = 'ELIMINAR ARCHIVOS DE ARTICULOS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    Visible = False
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 664
    Top = 376
    Width = 89
    Height = 49
    Caption = 'VOLVER'
    TabOrder = 13
    OnClick = Button9Click
  end
end
