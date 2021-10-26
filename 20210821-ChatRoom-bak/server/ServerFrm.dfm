object FormServer: TFormServer
  Left = 0
  Top = 0
  Caption = #26381#21153#22120#31471
  ClientHeight = 519
  ClientWidth = 833
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 525
    Top = 0
    Height = 398
    Align = alRight
    ExplicitLeft = 0
    ExplicitTop = -6
    ExplicitHeight = 401
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 398
    Width = 833
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 401
  end
  object Panel1: TPanel
    Left = 0
    Top = 401
    Width = 833
    Height = 118
    Align = alBottom
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 520
      Top = 1
      Height = 116
      Align = alRight
      ExplicitLeft = 480
      ExplicitTop = 56
      ExplicitHeight = 100
    end
    object MemoContent: TMemo
      Left = 1
      Top = 1
      Width = 519
      Height = 116
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object GroupBox2: TGroupBox
      Left = 523
      Top = 1
      Width = 309
      Height = 116
      Align = alRight
      TabOrder = 1
      object Button1: TButton
        Left = 90
        Top = 48
        Width = 135
        Height = 25
        Caption = #21457#36865
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 528
    Top = 0
    Width = 305
    Height = 398
    Align = alRight
    TabOrder = 1
    object MemoLog: TMemo
      Left = 1
      Top = 1
      Width = 303
      Height = 254
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 255
      Width = 303
      Height = 142
      Align = alBottom
      TabOrder = 1
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
      object ButtonStart: TButton
        Left = 23
        Top = 101
        Width = 75
        Height = 25
        Caption = #21551#21160#26381#21153#22120
        TabOrder = 2
        OnClick = ButtonStartClick
      end
    end
  end
  object MemoRecord: TMemo
    Left = 0
    Top = 0
    Width = 525
    Height = 398
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 2
  end
end
