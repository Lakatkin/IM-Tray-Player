object Options_BOX: TOptions_BOX
  Left = 492
  Top = 139
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 297
  ClientWidth = 393
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
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 381
    Height = 253
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1057#1080#1089#1090#1077#1084#1085#1099#1077
      object GroupBox4: TGroupBox
        Left = 8
        Top = 0
        Width = 353
        Height = 97
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1080#1085#1080#1094#1080#1072#1083#1080#1079#1072#1094#1080#1080
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 104
          Height = 13
          Caption = #1059#1089#1090#1088#1086#1081#1089#1090#1074#1086' '#1074#1099#1074#1086#1076#1072':'
        end
        object Label10: TLabel
          Left = 232
          Top = 16
          Width = 79
          Height = 13
          Caption = #1056#1072#1079#1084#1077#1088' '#1073#1091#1092#1077#1088#1072
        end
        object Label11: TLabel
          Left = 296
          Top = 34
          Width = 17
          Height = 13
          Caption = #1084#1089'.'
        end
        object ComboBox1: TComboBox
          Left = 8
          Top = 32
          Width = 201
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = ComboBox1Change
        end
        object CheckBox3: TCheckBox
          Left = 8
          Top = 64
          Width = 193
          Height = 17
          Caption = #1048#1079#1084#1077#1085#1103#1090#1100' '#1075#1088#1086#1084#1082#1086#1089#1090#1100' '#1074'  '#1089#1080#1089#1090#1077#1084#1077
          TabOrder = 1
          OnClick = CheckBox3Click
        end
        object SpinEdit8: TSpinEdit
          Left = 224
          Top = 32
          Width = 65
          Height = 22
          MaxLength = 100
          MaxValue = 5000
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = SpinEdit8Change
        end
      end
      object CheckBox4: TCheckBox
        Left = 8
        Top = 112
        Width = 153
        Height = 17
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1072#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1091' '
        TabOrder = 1
        OnClick = CheckBox4Click
      end
      object RadioGroup1: TRadioGroup
        Left = 168
        Top = 104
        Width = 193
        Height = 105
        Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1087#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' "'#1079#1072#1082#1088#1099#1090#1100'"'
        Items.Strings = (
          #1057#1074#1077#1088#1085#1091#1090#1100' '#1080' '#1086#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1086#1089#1087#1088'.'
          #1057#1074#1077#1088#1085#1091#1090#1100
          #1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077)
        TabOrder = 2
      end
      object CheckBox5: TCheckBox
        Left = 8
        Top = 144
        Width = 137
        Height = 17
        Caption = #1042#1086#1079#1086#1073#1085#1086#1074#1083#1103#1090#1100' '#1074#1086#1089#1087#1088'.'
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1088#1086#1074#1086#1076#1085#1080#1082
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 8
        Top = 0
        Width = 201
        Height = 217
        Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1092#1072#1081#1083#1099
        TabOrder = 0
        object CheckListBox1: TCheckListBox
          Left = 8
          Top = 16
          Width = 185
          Height = 193
          OnClickCheck = CheckListBox1ClickCheck
          ItemHeight = 13
          Items.Strings = (
            'mp1'
            'mp2'
            'mp3'
            'mp4'
            'ogg'
            'aiff'
            'wma'
            'MO3'
            'IT'
            'XM'
            'S3M'
            'MTM'
            'MOD'
            'UMX'
            'MID'
            'MIDI'
            'RMI'
            'KAR'
            'wav'
            'ape'
            'flac'
            'alac'
            'aac'
            'm4a'
            'cda'
            'impl'
            'cue'
            'm3u')
          TabOrder = 0
        end
      end
      object CheckBox1: TCheckBox
        Left = 216
        Top = 48
        Width = 105
        Height = 17
        Caption = #1053#1072#1095#1080#1085#1072#1090#1100' '#1074#1086#1089#1087#1088'.'
        TabOrder = 1
      end
      object CheckBox2: TCheckBox
        Left = 216
        Top = 72
        Width = 145
        Height = 17
        Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1072#1089#1089#1086#1094#1080#1072#1094#1080#1080
        TabOrder = 2
      end
      object Button3: TButton
        Left = 224
        Top = 168
        Width = 113
        Height = 25
        Caption = #1059#1073#1088#1072#1090#1100' '#1074#1089#1077
        TabOrder = 3
        OnClick = Button4Click
      end
      object Button4: TButton
        Left = 224
        Top = 128
        Width = 113
        Height = 25
        Caption = #1047#1072#1076#1077#1081#1089#1090#1074#1086#1074#1072#1090#1100' '#1074#1089#1077
        TabOrder = 4
        OnClick = Button4Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1042#1085#1077#1096#1085#1080#1081' '#1074#1080#1076
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 0
        Top = 144
        Width = 193
        Height = 65
        Caption = #1041#1077#1075#1091#1097#1072#1103' '#1089#1090#1088#1086#1082#1072
        TabOrder = 0
        object Label7: TLabel
          Left = 8
          Top = 44
          Width = 115
          Height = 13
          Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1084#1080#1085#1080' '#1089#1090#1088#1086#1082#1080
        end
        object Label6: TLabel
          Left = 8
          Top = 22
          Width = 89
          Height = 13
          Caption = #1057#1082#1086#1088#1086#1089#1090#1100'  '#1089#1090#1088#1086#1082#1080
        end
        object SpinEdit2: TSpinEdit
          Left = 144
          Top = 40
          Width = 41
          Height = 22
          MaxValue = 42
          MinValue = 8
          TabOrder = 0
          Value = 8
          OnChange = SpinEdit2Change
        end
        object SpinEdit1: TSpinEdit
          Left = 144
          Top = 16
          Width = 41
          Height = 22
          MaxValue = 50
          MinValue = 6
          TabOrder = 1
          Value = 6
          OnChange = SpinEdit1Change
        end
      end
      object GroupBox6: TGroupBox
        Left = 0
        Top = 0
        Width = 193
        Height = 144
        Caption = #1043#1083#1072#1074#1085#1086#1077' '#1086#1082#1085#1086
        TabOrder = 1
        object Label2: TLabel
          Left = 8
          Top = 32
          Width = 125
          Height = 13
          Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1095#1077#1088#1077#1079' ('#1052#1057'.)'
        end
        object Label3: TLabel
          Left = 8
          Top = 118
          Width = 28
          Height = 13
          Caption = #1057#1082#1080#1085':'
        end
        object Label4: TLabel
          Left = 40
          Top = 118
          Width = 50
          Height = 13
          Caption = 'Skin name'
        end
        object CheckBox8: TCheckBox
          Left = 8
          Top = 58
          Width = 97
          Height = 17
          Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
          TabOrder = 0
          OnClick = CheckBox8Click
        end
        object SpinEdit3: TSpinEdit
          Left = 144
          Top = 60
          Width = 41
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 1
          Value = 1
          OnChange = SpinEdit3Change
        end
        object CheckBox7: TCheckBox
          Left = 8
          Top = 12
          Width = 169
          Height = 17
          Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1089#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100
          TabOrder = 2
          OnClick = CheckBox7Click
        end
        object SpinEdit6: TSpinEdit
          Left = 144
          Top = 88
          Width = 41
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 1
          OnChange = SpinEdit6Change
        end
        object CheckBox18: TCheckBox
          Left = 8
          Top = 90
          Width = 121
          Height = 17
          Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100' '#1084#1080#1085#1080
          TabOrder = 4
          OnClick = CheckBox18Click
        end
        object SpinEdit9: TSpinEdit
          Left = 136
          Top = 32
          Width = 49
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 1500
          OnChange = SpinEdit9Change
        end
        object Button7: TButton
          Left = 128
          Top = 119
          Width = 57
          Height = 17
          Caption = #1054#1073#1079#1086#1088
          TabOrder = 6
          OnClick = Button7Click
        end
      end
      object GroupBox7: TGroupBox
        Left = 200
        Top = 0
        Width = 161
        Height = 65
        Caption = #1047#1082#1074#1072#1083#1072#1081#1079#1077#1088
        TabOrder = 2
        object CheckBox9: TCheckBox
          Left = 8
          Top = 14
          Width = 145
          Height = 17
          Caption = #1053#1077' '#1074#1099#1093#1086#1076#1080#1090#1100' '#1079#1072' '#1075#1088#1072#1085#1080#1094#1099
          TabOrder = 0
        end
        object CheckBox10: TCheckBox
          Left = 8
          Top = 40
          Width = 97
          Height = 17
          Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
          TabOrder = 1
          OnClick = CheckBox10Click
        end
        object SpinEdit7: TSpinEdit
          Left = 112
          Top = 32
          Width = 41
          Height = 22
          MaxLength = 100
          MaxValue = 100
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = SpinEdit7Change
        end
      end
      object GroupBox9: TGroupBox
        Left = 200
        Top = 66
        Width = 161
        Height = 77
        Caption = #1057#1087#1080#1089#1086#1082
        TabOrder = 3
        object CheckBox13: TCheckBox
          Left = 8
          Top = 14
          Width = 145
          Height = 17
          Caption = #1053#1077' '#1074#1099#1093#1086#1076#1080#1090#1100' '#1079#1072' '#1075#1088#1072#1085#1080#1094#1099
          TabOrder = 0
        end
        object CheckBox14: TCheckBox
          Left = 8
          Top = 34
          Width = 97
          Height = 17
          Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
          TabOrder = 1
          OnClick = CheckBox14Click
        end
        object SpinEdit4: TSpinEdit
          Left = 112
          Top = 32
          Width = 41
          Height = 22
          MaxLength = 100
          MaxValue = 100
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = SpinEdit4Change
        end
        object CheckBox21: TCheckBox
          Left = 8
          Top = 54
          Width = 145
          Height = 17
          Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1076#1089#1082#1072#1079#1082#1091' '
          TabOrder = 3
        end
      end
      object GroupBox8: TGroupBox
        Left = 200
        Top = 144
        Width = 161
        Height = 65
        Caption = #1042#1089#1087#1083#1099#1074#1072#1102#1097#1080#1077' '#1087#1086#1076#1089#1082#1072#1079#1082#1080
        TabOrder = 4
        object CheckBox11: TCheckBox
          Left = 8
          Top = 14
          Width = 145
          Height = 17
          Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1080#1079' '#1089#1082#1080#1085#1072
          TabOrder = 0
          OnClick = CheckBox11Click
        end
        object CheckBox12: TCheckBox
          Left = 8
          Top = 40
          Width = 97
          Height = 17
          Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
          TabOrder = 1
          OnClick = CheckBox12Click
        end
        object SpinEdit5: TSpinEdit
          Left = 112
          Top = 32
          Width = 41
          Height = 22
          MaxLength = 100
          MaxValue = 100
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = SpinEdit5Change
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1057#1087#1080#1089#1086#1082
      ImageIndex = 3
      object GroupBox10: TGroupBox
        Left = 8
        Top = 0
        Width = 161
        Height = 86
        Caption = #1042#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1077
        TabOrder = 0
        object RadioButton1: TRadioButton
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #1057#1074#1077#1088#1093#1091' '#1074#1085#1080#1079
          TabOrder = 0
          OnClick = RadioButton1Click
        end
        object RadioButton2: TRadioButton
          Left = 8
          Top = 40
          Width = 97
          Height = 17
          Caption = #1057#1085#1080#1079#1091' '#1074#1074#1077#1088#1093
          TabOrder = 1
          OnClick = RadioButton1Click
        end
        object CheckBox15: TCheckBox
          Left = 8
          Top = 60
          Width = 137
          Height = 17
          Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1080#1079#1073#1088#1072#1085#1085#1099#1077
          TabOrder = 2
        end
      end
      object RadioGroup2: TRadioGroup
        Left = 8
        Top = 88
        Width = 161
        Height = 81
        Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1092#1072#1081#1083#1072
        Items.Strings = (
          #1042' '#1085#1072#1095#1072#1083#1086' '#1089#1087#1080#1089#1082#1072
          #1042' '#1082#1086#1085#1077#1094' '#1089#1087#1080#1089#1082#1072' '
          #1058#1077#1082#1091#1097#1072#1103' '#1087#1086#1079#1080#1094#1080#1103)
        TabOrder = 1
      end
      object RadioGroup3: TRadioGroup
        Left = 176
        Top = 0
        Width = 185
        Height = 89
        Caption = #1054#1090#1082#1088#1099#1090#1080#1077' '#1055#1083#1077#1081#1083#1080#1089#1090#1072
        Items.Strings = (
          #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1074' '#1090#1077#1082#1091#1097#1080#1081' '
          #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1074#1084#1077#1089#1090#1086' '#1090#1077#1082#1091#1097#1077#1075#1086
          #1076#1086#1073#1072#1074#1083#1103#1090#1100' '#1082#1072#1082' '#1085#1086#1074#1099#1081' ')
        TabOrder = 2
      end
      object CheckBox16: TCheckBox
        Left = 184
        Top = 92
        Width = 161
        Height = 25
        Caption = #1063#1080#1090#1072#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1080#1079' '#1090#1077#1075#1086#1074
        TabOrder = 3
      end
      object CheckBox17: TCheckBox
        Left = 184
        Top = 115
        Width = 161
        Height = 17
        Caption = #1063#1080#1090#1072#1090#1100' '#1090#1077#1075#1080' '#1076#1083#1103' CUE'
        TabOrder = 4
      end
      object CheckBox19: TCheckBox
        Left = 184
        Top = 136
        Width = 137
        Height = 17
        Caption = #1063#1080#1090#1072#1090#1100' '#1090#1077#1075#1080' '#1076#1083#1103' VK '
        TabOrder = 5
      end
      object CheckBox20: TCheckBox
        Left = 184
        Top = 157
        Width = 169
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1085#1091#1084#1080#1088#1072#1094#1080#1103
        TabOrder = 6
        OnClick = CheckBox20Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1052#1086#1076#1091#1083#1100' VK'
      ImageIndex = 4
      object Label5: TLabel
        Left = 8
        Top = 40
        Width = 34
        Height = 13
        Caption = #1051#1086#1075#1080#1085':'
      end
      object Label8: TLabel
        Left = 8
        Top = 64
        Width = 41
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100':'
      end
      object Label12: TLabel
        Left = 6
        Top = 170
        Width = 102
        Height = 13
        Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1092#1072#1081#1083#1099' '#1074':'
      end
      object CheckBox22: TCheckBox
        Left = 8
        Top = 120
        Width = 225
        Height = 17
        Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1087#1077#1089#1077#1085' '#1074' '#1073#1077#1075#1091#1097#1077#1081' '#1089#1090#1088#1086#1082#1077
        TabOrder = 0
      end
      object CheckBox23: TCheckBox
        Left = 8
        Top = 144
        Width = 233
        Height = 17
        Caption = #1058#1088#1072#1085#1089#1083#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1089#1085#1080' '#1074' '#1089#1090#1072#1090#1091#1089' '
        TabOrder = 1
        OnClick = CheckBox23Click
      end
      object CheckBox24: TCheckBox
        Left = 8
        Top = 96
        Width = 233
        Height = 17
        Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1052#1086#1080' '#1072#1091#1076#1080#1086#1079#1072#1087#1080#1089#1080' '
        TabOrder = 2
      end
      object Button6: TButton
        Left = 248
        Top = 96
        Width = 75
        Height = 25
        Caption = #1042#1093#1086#1076
        Enabled = False
        TabOrder = 3
        OnClick = Button6Click
      end
      object CheckBox25: TCheckBox
        Left = 8
        Top = 8
        Width = 153
        Height = 17
        Caption = #1042#1079#1072#1080#1084#1086#1076#1077#1081#1089#1090#1074#1086#1074#1072#1090#1100' '#1089' VK'
        TabOrder = 4
        OnClick = CheckBox25Click
      end
      object Edit1: TEdit
        Left = 56
        Top = 32
        Width = 257
        Height = 21
        TabOrder = 5
        OnKeyPress = Edit1KeyPress
      end
      object Edit2: TEdit
        Left = 56
        Top = 64
        Width = 257
        Height = 21
        TabOrder = 6
        OnKeyPress = Edit1KeyPress
      end
      object Edit4: TEdit
        Left = 8
        Top = 188
        Width = 265
        Height = 21
        ReadOnly = True
        TabOrder = 7
      end
      object Button2: TButton
        Left = 280
        Top = 190
        Width = 57
        Height = 17
        Caption = #1054#1073#1079#1086#1088
        TabOrder = 8
        OnClick = Button2Click
      end
    end
  end
  object Button1: TButton
    Left = 312
    Top = 266
    Width = 67
    Height = 23
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button8: TButton
    Left = 224
    Top = 266
    Width = 65
    Height = 23
    Caption = #1057#1073#1088#1086#1089#1080#1090#1100
    TabOrder = 2
    OnClick = Button8Click
  end
end
