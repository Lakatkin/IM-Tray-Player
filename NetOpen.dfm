object Net_OpenDLG: TNet_OpenDLG
  Left = 368
  Top = 98
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' URL '#1089#1089#1099#1083#1082#1091
  ClientHeight = 75
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 2
    Width = 457
    Height = 65
    Caption = 'URL'
    TabOrder = 0
    object Button1: TButton
      Left = 359
      Top = 22
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 345
      Height = 21
      TabOrder = 1
      Text = 'http//:'
    end
  end
end
