object FormServer: TFormServer
  Left = 0
  Top = 0
  Caption = #26381#21153#22120#31471
  ClientHeight = 470
  ClientWidth = 777
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
  object MemoContent: TMemo
    Left = 0
    Top = 364
    Width = 510
    Height = 98
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ButtonStart: TButton
    Left = 577
    Top = 311
    Width = 75
    Height = 25
    Caption = #21551#21160#26381#21153#22120
    TabOrder = 1
    OnClick = ButtonStartClick
  end
  object MemoRecord: TMemo
    Left = 0
    Top = 0
    Width = 505
    Height = 353
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object MemoLog: TMemo
    Left = 511
    Top = 0
    Width = 257
    Height = 169
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 511
    Top = 175
    Width = 258
    Height = 106
    TabOrder = 4
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 58
      Height = 13
      Caption = #26381#21153#22120'IP'#65306
    end
    object Label2: TLabel
      Left = 24
      Top = 72
      Width = 84
      Height = 13
      Caption = #26381#21153#22120#31471#21475#21495#65306
    end
    object EditAddr: TEdit
      Left = 112
      Top = 32
      Width = 137
      Height = 21
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditPort: TEdit
      Left = 114
      Top = 67
      Width = 133
      Height = 21
      TabOrder = 1
      Text = '10086'
    end
  end
  object ButtonSend: TButton
    Left = 577
    Top = 392
    Width = 75
    Height = 25
    Caption = #21457#36865
    TabOrder = 5
  end
end
