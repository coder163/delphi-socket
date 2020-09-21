object FormServer: TFormServer
  Left = 0
  Top = 0
  Caption = #26381#21153#22120#31471
  ClientHeight = 362
  ClientWidth = 420
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
  object Memo1: TMemo
    Left = 0
    Top = 263
    Width = 417
    Height = 98
    TabOrder = 0
  end
  object ButtonStart: TButton
    Left = 337
    Top = 232
    Width = 75
    Height = 25
    Caption = #21551#21160#26381#21153#22120
    TabOrder = 1
    OnClick = ButtonStartClick
  end
end
