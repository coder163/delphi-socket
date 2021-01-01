object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Package'#24037#20855#20989#25968#27979#35797
  ClientHeight = 287
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonStartServer: TButton
    Left = 56
    Top = 48
    Width = 75
    Height = 25
    Caption = #21551#21160#26381#21153#22120
    TabOrder = 0
    OnClick = ButtonStartServerClick
  end
  object ButtonStartClient: TButton
    Left = 344
    Top = 48
    Width = 75
    Height = 25
    Caption = #36830#25509#26381#21153#22120
    TabOrder = 1
    OnClick = ButtonStartClientClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 268
    Width = 505
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
end
