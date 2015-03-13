object Audio_Info: TAudio_Info
  Left = 203
  Top = 30
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Audio tag '
  ClientHeight = 353
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
    Top = 312
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 184
    Top = 312
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 40
    Width = 353
    Height = 265
    ActivePage = TabSheet2
    TabOrder = 3
    object TabSheet2: TTabSheet
      Caption = 'Tag'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 12
        Width = 25
        Height = 17
        AutoSize = False
        Caption = 'Title:'
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 8
        Top = 36
        Width = 25
        Height = 17
        AutoSize = False
        Caption = 'Artist:'
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 60
        Width = 33
        Height = 17
        AutoSize = False
        Caption = 'Album:'
        Layout = tlCenter
      end
      object Label4: TLabel
        Left = 8
        Top = 84
        Width = 33
        Height = 17
        AutoSize = False
        Caption = 'Track:'
        Layout = tlCenter
      end
      object Label5: TLabel
        Left = 96
        Top = 84
        Width = 33
        Height = 17
        AutoSize = False
        Caption = 'Year:'
        Layout = tlCenter
      end
      object Label6: TLabel
        Left = 192
        Top = 84
        Width = 41
        Height = 17
        AutoSize = False
        Caption = 'Genre:'
        Layout = tlCenter
      end
      object Label9: TLabel
        Left = 8
        Top = 160
        Width = 47
        Height = 13
        Caption = 'Comment:'
      end
      object ComposerLabel: TLabel
        Left = 8
        Top = 107
        Width = 50
        Height = 17
        AutoSize = False
        Caption = 'Composer:'
        Layout = tlCenter
      end
      object Edit1: TEdit
        Left = 48
        Top = 8
        Width = 273
        Height = 21
        Ctl3D = True
        MaxLength = 250
        ParentCtl3D = False
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 48
        Top = 32
        Width = 273
        Height = 21
        Ctl3D = True
        MaxLength = 250
        ParentCtl3D = False
        TabOrder = 1
      end
      object Edit3: TEdit
        Left = 48
        Top = 56
        Width = 273
        Height = 21
        Ctl3D = True
        MaxLength = 250
        ParentCtl3D = False
        TabOrder = 2
      end
      object Edit4: TEdit
        Left = 48
        Top = 80
        Width = 41
        Height = 21
        Ctl3D = True
        MaxLength = 250
        ParentCtl3D = False
        TabOrder = 3
      end
      object Edit5: TEdit
        Left = 128
        Top = 80
        Width = 49
        Height = 21
        Ctl3D = True
        MaxLength = 250
        ParentCtl3D = False
        TabOrder = 4
      end
      object Memo2: TMemo
        Left = 61
        Top = 134
        Width = 260
        Height = 103
        TabOrder = 5
      end
      object ComboBox1: TComboBox
        Left = 232
        Top = 83
        Width = 89
        Height = 21
        TabOrder = 6
      end
      object ComposerEdit: TEdit
        Left = 61
        Top = 108
        Width = 260
        Height = 21
        Ctl3D = True
        MaxLength = 250
        ParentCtl3D = False
        TabOrder = 7
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Cover'
      ImageIndex = 3
      object Image1: TImage
        Left = 3
        Top = 3
        Width = 339
        Height = 206
        Proportional = True
        Stretch = True
      end
      object Button1: TButton
        Left = 3
        Top = 215
        Width = 104
        Height = 19
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1073#1083#1086#1078#1082#1091
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button4: TButton
        Left = 125
        Top = 215
        Width = 83
        Height = 19
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 227
        Top = 215
        Width = 104
        Height = 19
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1086#1073#1083#1086#1078#1082#1091
        TabOrder = 2
        OnClick = Button5Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'File info'
      ImageIndex = 2
      object FileSizeLabel: TLabel
        Left = 3
        Top = 14
        Width = 80
        Height = 17
        AutoSize = False
        Caption = 'File size:'
        Layout = tlCenter
      end
      object SampleRateLabel: TLabel
        Left = 3
        Top = 69
        Width = 80
        Height = 17
        AutoSize = False
        Caption = 'Sample rate:'
        Layout = tlCenter
      end
      object EncoderLabel: TLabel
        Left = 3
        Top = 150
        Width = 73
        Height = 17
        AutoSize = False
        Caption = 'Encoder:'
        Layout = tlCenter
      end
      object DurationLabel: TLabel
        Left = 3
        Top = 123
        Width = 80
        Height = 17
        AutoSize = False
        Caption = 'Duration:'
        Layout = tlCenter
      end
      object ChannelModeLabel: TLabel
        Left = 3
        Top = 96
        Width = 80
        Height = 17
        AutoSize = False
        Caption = 'Ch mode:'
        Layout = tlCenter
      end
      object BitRateLabel: TLabel
        Left = 3
        Top = 42
        Width = 80
        Height = 17
        AutoSize = False
        Caption = 'Bit rate:'
        Layout = tlCenter
      end
      object FileSizeText: TEdit
        Left = 80
        Top = 15
        Width = 249
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
      object SampleRateText: TEdit
        Left = 81
        Top = 69
        Width = 248
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
      object EncoderText: TEdit
        Left = 81
        Top = 150
        Width = 248
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 2
      end
      object DurationText: TEdit
        Left = 80
        Top = 123
        Width = 249
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 3
      end
      object ChannelModeText: TEdit
        Left = 81
        Top = 96
        Width = 248
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 4
      end
      object BitRateText: TEdit
        Left = 81
        Top = 42
        Width = 248
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 5
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 38
    Top = 314
  end
  object SavePictureDialog1: TSavePictureDialog
    Left = 120
    Top = 310
  end
end
