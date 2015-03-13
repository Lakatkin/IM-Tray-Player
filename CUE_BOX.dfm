object CUE_Info: TCUE_Info
  Left = 392
  Top = 266
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CUE tag'
  ClientHeight = 259
  ClientWidth = 372
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
  object Label10: TLabel
    Left = 8
    Top = 8
    Width = 19
    Height = 13
    Caption = 'File:'
  end
  object Edit6: TEdit
    Left = 32
    Top = 8
    Width = 329
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object Button3: TButton
    Left = 280
    Top = 224
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button3Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 40
    Width = 353
    Height = 169
    ActivePage = TabSheet3
    TabOrder = 2
    object TabSheet3: TTabSheet
      Caption = 'File info'
      ImageIndex = 2
      object Label1: TLabel
        Left = 8
        Top = 44
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Title:'
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 8
        Top = 12
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Artist:'
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 76
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Read from:'
        Layout = tlCenter
      end
      object Edit2: TEdit
        Left = 104
        Top = 72
        Width = 225
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object Button1: TButton
        Left = 168
        Top = 104
        Width = 163
        Height = 25
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1092#1072#1081#1083#1077' '#1086#1073#1088#1072#1079#1077' '
        TabOrder = 1
        OnClick = Button1Click
      end
      object Edit1: TEdit
        Left = 104
        Top = 8
        Width = 225
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object Edit3: TEdit
        Left = 104
        Top = 40
        Width = 225
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
    end
  end
end
