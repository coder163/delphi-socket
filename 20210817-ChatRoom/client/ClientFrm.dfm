object FormClient: TFormClient
  Left = 0
  Top = 0
  Caption = #23458#25143#31471
  ClientHeight = 474
  ClientWidth = 822
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
  object ButtonConnection: TButton
    Left = 648
    Top = 341
    Width = 75
    Height = 23
    Caption = #36830#25509#26381#21153#22120
    TabOrder = 0
    OnClick = ButtonConnectionClick
  end
  object MemoContent: TMemo
    Left = 0
    Top = 370
    Width = 561
    Height = 103
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object MemoRecord: TMemo
    Left = 0
    Top = 0
    Width = 561
    Height = 364
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 567
    Top = 216
    Width = 247
    Height = 105
    Caption = 'GroupBox1'
    TabOrder = 3
    object Label1: TLabel
      Left = 32
      Top = 37
      Width = 46
      Height = 13
      Caption = 'IP'#22320#22336#65306
    end
    object Label2: TLabel
      Left = 32
      Top = 72
      Width = 48
      Height = 13
      Caption = #31471#21475#21495#65306
    end
    object EditAddr: TEdit
      Left = 96
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditPort: TEdit
      Left = 96
      Top = 65
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '10086'
    end
  end
  object MemoLog: TMemo
    Left = 567
    Top = 0
    Width = 247
    Height = 210
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object ButtonSend: TButton
    Left = 648
    Top = 408
    Width = 75
    Height = 25
    Caption = #21457#36865
    TabOrder = 5
    OnClick = ButtonSendClick
  end
end
