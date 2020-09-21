object FormClient: TFormClient
  Left = 0
  Top = 0
  Caption = #23458#25143#31471
  ClientHeight = 315
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 107
    Width = 22
    Height = 13
    Caption = 'IP'#65306
  end
  object Label2: TLabel
    Left = 96
    Top = 51
    Width = 48
    Height = 13
    Caption = #31471#21475#21495#65306
  end
  object ButtonConnection: TButton
    Left = 400
    Top = 95
    Width = 75
    Height = 25
    Caption = #36830#25509#26381#21153#22120
    TabOrder = 0
    OnClick = ButtonConnectionClick
  end
  object EditPort: TEdit
    Left = 176
    Top = 48
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '8080'
  end
  object EditAddr: TEdit
    Left = 176
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object MemoMsg: TMemo
    Left = 0
    Top = 218
    Width = 577
    Height = 103
    TabOrder = 3
  end
end
