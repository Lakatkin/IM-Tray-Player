object DL_AudioGroup: TDL_AudioGroup
  Left = 382
  Top = 174
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1057#1082#1072#1095#1072#1090#1100' '#1075#1088#1091#1087#1087#1091' '#1092#1072#1081#1083#1086#1074' '
  ClientHeight = 146
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 65
    Height = 13
    Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1074':'
  end
  object GroupBox1: TGroupBox
    Left = 184
    Top = 8
    Width = 145
    Height = 57
    Caption = #1057#1082#1072#1095#1072#1090#1100
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 10
      Height = 13
      Caption = #1057' '
    end
    object Label2: TLabel
      Left = 72
      Top = 24
      Width = 17
      Height = 13
      Caption = #1055#1086' '
    end
    object Edit1: TEdit
      Left = 24
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '1'
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 96
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '10000'
      OnKeyPress = Edit1KeyPress
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 169
    Height = 57
    Caption = #1048#1084#1077#1085#1072' '#1092#1072#1081#1083#1086#1074
    ItemIndex = 0
    Items.Strings = (
      #1055#1086' '#1085#1072#1079#1074#1072#1085#1080#1102' '#1079#1072#1087#1080#1089#1080' '#1042#1050
      #1057#1086#1074#1087#1072#1076#1072#1102#1090' '#1089' id '#1079#1072#1087#1080#1089#1080' '#1042#1050)
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 8
    Top = 88
    Width = 233
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object Button1: TButton
    Left = 248
    Top = 88
    Width = 75
    Height = 17
    Caption = #1054#1073#1079#1086#1088
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 112
    Width = 107
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091
    TabOrder = 4
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 118
    Width = 161
    Height = 17
    Caption = #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1082' '#1080#1084#1077#1085#1080' '#1085#1086#1084#1077#1088' '
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
end
