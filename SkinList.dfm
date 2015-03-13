object Skin_List: TSkin_List
  Left = 790
  Top = 159
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1089#1082#1080#1085#1072
  ClientHeight = 283
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 201
    Height = 225
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 40
    Top = 248
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 128
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button2Click
  end
end
