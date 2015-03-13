object List_Open: TList_Open
  Left = 421
  Top = 328
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1054#1090#1082#1088#1099#1090#1080#1077' '#1089#1087#1080#1089#1082#1072
  ClientHeight = 72
  ClientWidth = 222
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
  object RadioGroup1: TRadioGroup
    Left = 2
    Top = 4
    Width = 217
    Height = 61
    Caption = #1063#1090#1086' '#1089#1076#1077#1083#1072#1090#1100' ?'
    ItemIndex = 1
    Items.Strings = (
      #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1090#1077#1082#1091#1097#1077#1084#1091
      #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081)
    TabOrder = 0
  end
  object Button1: TButton
    Left = 136
    Top = 40
    Width = 67
    Height = 17
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
end
