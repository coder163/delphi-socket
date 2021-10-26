object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 374
  ClientWidth = 615
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
  object Memo1: TMemo
    Left = 8
    Top = 0
    Width = 385
    Height = 217
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 8
    Top = 246
    Width = 385
    Height = 120
    TabOrder = 1
  end
  object BtnConnection: TButton
    Left = 438
    Top = 269
    Width = 75
    Height = 25
    Caption = #36830#25509
    TabOrder = 2
    OnClick = BtnConnectionClick
  end
  object BtnSend: TButton
    Left = 438
    Top = 326
    Width = 75
    Height = 25
    Caption = #21457#36865
    TabOrder = 3
    OnClick = BtnSendClick
  end
  object Memo3: TMemo
    Left = 399
    Top = 0
    Width = 208
    Height = 217
    Lines.Strings = (
      'Memo3')
    TabOrder = 4
  end
end
