object VKtag_Info: TVKtag_Info
  Left = 332
  Top = 137
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'VK tag'
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
  object PageControl1: TPageControl
    Left = 8
    Top = 40
    Width = 353
    Height = 265
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'TAG'
      object TitleLabel: TLabel
        Left = 8
        Top = 16
        Width = 23
        Height = 13
        Caption = 'Title:'
      end
      object ArtistLabel: TLabel
        Left = 8
        Top = 48
        Width = 26
        Height = 13
        Caption = 'Artist:'
      end
      object AlbumLabel: TLabel
        Left = 8
        Top = 80
        Width = 32
        Height = 13
        Caption = 'Album:'
      end
      object YearLabel: TLabel
        Left = 48
        Top = 112
        Width = 25
        Height = 13
        Caption = 'Year:'
      end
      object GenreLabel: TLabel
        Left = 168
        Top = 112
        Width = 32
        Height = 13
        Caption = 'Genre:'
      end
      object CommentLabel: TLabel
        Left = 8
        Top = 152
        Width = 47
        Height = 13
        Caption = 'Comment:'
      end
      object TitleEdit: TEdit
        Left = 48
        Top = 8
        Width = 273
        Height = 21
        MaxLength = 30
        ReadOnly = True
        TabOrder = 0
      end
      object ArtistEdit: TEdit
        Left = 48
        Top = 40
        Width = 273
        Height = 21
        MaxLength = 30
        ReadOnly = True
        TabOrder = 1
      end
      object AlbumEdit: TEdit
        Left = 48
        Top = 72
        Width = 273
        Height = 21
        MaxLength = 30
        ReadOnly = True
        TabOrder = 2
      end
      object YearEdit: TEdit
        Left = 80
        Top = 104
        Width = 73
        Height = 21
        MaxLength = 4
        ReadOnly = True
        TabOrder = 3
      end
      object Memo1: TMemo
        Left = 64
        Top = 144
        Width = 257
        Height = 89
        ReadOnly = True
        TabOrder = 4
      end
      object EditGenre: TEdit
        Left = 208
        Top = 104
        Width = 113
        Height = 21
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 5
      end
    end
    object Text: TTabSheet
      Caption = 'Text'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo2: TMemo
        Left = 8
        Top = 8
        Width = 329
        Height = 225
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WantTabs = True
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'File info'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ChannelModeLabel: TLabel
        Left = 8
        Top = 76
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Uploader ID:'
        Layout = tlCenter
      end
      object DurationLabel: TLabel
        Left = 8
        Top = 108
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Duration:'
        Layout = tlCenter
      end
      object SampleRateLabel: TLabel
        Left = 8
        Top = 140
        Width = 65
        Height = 17
        AutoSize = False
        Caption = 'Sample rate:'
        Layout = tlCenter
      end
      object BitRateLabel: TLabel
        Left = 8
        Top = 172
        Width = 65
        Height = 17
        AutoSize = False
        Caption = 'Bit rate:'
        Layout = tlCenter
      end
      object Label1: TLabel
        Left = 8
        Top = 44
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Owner ID:'
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 8
        Top = 12
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Audio ID:'
        Layout = tlCenter
      end
      object DurationText: TEdit
        Left = 104
        Top = 106
        Width = 225
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
      object SampleRateText: TEdit
        Left = 104
        Top = 138
        Width = 225
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
      object BitRateText: TEdit
        Left = 104
        Top = 170
        Width = 225
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 2
      end
      object Edit2: TEdit
        Left = 104
        Top = 74
        Width = 225
        Height = 21
        Cursor = crHandPoint
        TabStop = False
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        OnDblClick = Edit1DblClick
      end
      object Edit1: TEdit
        Left = 104
        Top = 42
        Width = 225
        Height = 21
        Cursor = crHandPoint
        TabStop = False
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        OnDblClick = Edit1DblClick
      end
      object Edit3: TEdit
        Left = 104
        Top = 10
        Width = 225
        Height = 21
        TabStop = False
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 5
      end
    end
  end
end
