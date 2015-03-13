object DL_DLG: TDL_DLG
  Left = 323
  Top = 179
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' 0%'
  ClientHeight = 145
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 16
    Top = 114
    Width = 58
    Height = 13
    Caption = #1047#1072#1075#1088#1091#1078#1077#1085#1086':'
  end
  object Label7: TLabel
    Left = 80
    Top = 114
    Width = 30
    Height = 13
    Caption = '0 '#1080#1079' 0'
  end
  object Button1: TButton
    Left = 344
    Top = 112
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 417
    Height = 105
    Caption = #1047#1072#1082#1072#1095#1082#1072' '#1092#1072#1081#1083#1072' :'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 48
      Height = 13
      Caption = #1058#1077#1082#1091#1097#1080#1081':'
    end
    object Label3: TLabel
      Left = 8
      Top = 60
      Width = 33
      Height = 13
      Caption = #1042#1089#1077#1075#1086':'
    end
    object Label4: TLabel
      Left = 384
      Top = 32
      Width = 14
      Height = 13
      Caption = '0%'
    end
    object Label5: TLabel
      Left = 384
      Top = 60
      Width = 14
      Height = 13
      Caption = '0%'
    end
    object Label10: TLabel
      Left = 64
      Top = 80
      Width = 51
      Height = 13
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
    end
    object Label11: TLabel
      Left = 120
      Top = 80
      Width = 32
      Height = 13
      Caption = '0 kbps'
    end
    object Label1: TLabel
      Left = 237
      Top = 80
      Width = 90
      Height = 13
      Caption = #1055#1088#1086#1096#1083#1086' '#1074#1088#1077#1084#1077#1085#1080':'
    end
    object Label6: TLabel
      Left = 331
      Top = 80
      Width = 46
      Height = 13
      AutoSize = False
      Caption = '00:00:00'
    end
    object ProgressBar1: TProgressBar
      Left = 64
      Top = 28
      Width = 313
      Height = 17
      TabOrder = 0
    end
    object ProgressBar2: TProgressBar
      Left = 64
      Top = 56
      Width = 313
      Height = 17
      TabOrder = 1
    end
  end
  object Button2: TButton
    Left = 232
    Top = 112
    Width = 91
    Height = 25
    Caption = #1055#1088#1080#1086#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 200
    Top = 152
  end
end
