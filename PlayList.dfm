object Play_List: TPlay_List
  Left = 514
  Top = 144
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'PlayList'
  ClientHeight = 341
  ClientWidth = 225
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgFormResizer1: TimgFormResizer
    Left = 203
    Top = 275
    Width = 15
    Height = 15
    Cursor = crSizeNWSE
    OnResizeEnd = imgFormResizer1ResizeEnd
  end
  object ImgButton7: TImgButton
    Left = 196
    Top = 6
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1047#1072#1082#1088#1099#1090#1100
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton7Click
    UseAsCheckBox = False
    Checked = False
  end
  object ImgButton6: TImgButton
    Left = 142
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1057#1083#1091#1095#1072#1081#1085#1099#1081' '#1074#1099#1073#1086#1088' ['#1074#1082#1083']'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton6Click
    UseAsCheckBox = True
    Checked = False
  end
  object ImgButton5: TImgButton
    Left = 125
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1042' '#1080#1079#1073#1088#1072#1085#1085#1086#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton5Click
    UseAsCheckBox = True
    Checked = False
  end
  object ImgButton4: TImgButton
    Left = 108
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1055#1086#1074#1090#1086#1088#1103#1090#1100' '#1074#1089#1077' ['#1074#1082#1083']'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton4Click
    UseAsCheckBox = True
    Checked = False
  end
  object ImgButton3: TImgButton
    Left = 91
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton3Click
    UseAsCheckBox = False
    Checked = False
  end
  object ImgButton2: TImgButton
    Left = 74
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton2Click
    UseAsCheckBox = False
    Checked = False
  end
  object ImgButton1: TImgButton
    Left = 57
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1089#1087#1080#1089#1086#1082
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton1Click
    UseAsCheckBox = False
    Checked = False
  end
  object ImgTrackBar1: TImgTrackBar
    Left = 202
    Top = 64
    Width = 12
    Height = 185
    Cursor = crHandPoint
    OnMouseDown = ImgTrackBar1MouseDown
    OnMouseMove = ImgTrackBar1MouseMove
    OnMouseUp = ImgTrackBar1MouseUp
    Orientation = trVertical
    Max = 100
    Min = 0
    MaxProg = 100
    MinProg = 0
    Progress_ = 100
    Position = 100
  end
  object ImgButton8: TImgButton
    Left = 9
    Top = 262
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Hint = #1057#1087#1080#1089#1086#1082
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ImgButton8Click
    UseAsCheckBox = False
    Checked = False
  end
  object Edit1: TEdit
    Left = 32
    Top = 34
    Width = 172
    Height = 16
    Hint = #1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clScrollBar
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = #1055#1086#1080#1089#1082
    OnClick = Edit1Click
    OnKeyDown = Edit1KeyDown
    OnKeyUp = Edit1KeyUp
  end
  object Main_PlayList: TImgPlayList
    Left = 13
    Top = 64
    Width = 188
    Height = 185
    Style = lbOwnerDrawFixed
    BorderStyle = bsNone
    Color = clScrollBar
    ItemHeight = 13
    TabOrder = 1
    OnClick = ImgPlayList1Click
    OnContextPopup = ImgPlayList1ContextPopup
    OnDblClick = ImgPlayList1DblClick
    OnMouseDown = ImgPlayList1MouseDown
    OnMouseMove = ImgPlayList1MouseMove
    OnMouseUp = ImgPlayList1MouseUp
    NormalItemTopFont.Charset = DEFAULT_CHARSET
    NormalItemTopFont.Color = clWindowText
    NormalItemTopFont.Height = -11
    NormalItemTopFont.Name = 'MS Sans Serif'
    NormalItemTopFont.Style = []
    SelectItemTopFont.Charset = DEFAULT_CHARSET
    SelectItemTopFont.Color = clWindowText
    SelectItemTopFont.Height = -11
    SelectItemTopFont.Name = 'MS Sans Serif'
    SelectItemTopFont.Style = []
    PlayItemTopFont.Charset = DEFAULT_CHARSET
    PlayItemTopFont.Color = clWindowText
    PlayItemTopFont.Height = -11
    PlayItemTopFont.Name = 'MS Sans Serif'
    PlayItemTopFont.Style = []
    NormalItemDownFont.Charset = DEFAULT_CHARSET
    NormalItemDownFont.Color = clWindowText
    NormalItemDownFont.Height = -11
    NormalItemDownFont.Name = 'MS Sans Serif'
    NormalItemDownFont.Style = []
    SelectItemDownFont.Charset = DEFAULT_CHARSET
    SelectItemDownFont.Color = clWindowText
    SelectItemDownFont.Height = -11
    SelectItemDownFont.Name = 'MS Sans Serif'
    SelectItemDownFont.Style = []
    PlayItemDownFont.Charset = DEFAULT_CHARSET
    PlayItemDownFont.Color = clWindowText
    PlayItemDownFont.Height = -11
    PlayItemDownFont.Name = 'MS Sans Serif'
    PlayItemDownFont.Style = []
    onUpdateScroll = ImgPlayList1UpdateScroll
    PosScroll = 0
    AddNum = False
    ShowScroll = False
  end
  object DropFileSource1: TDropFileSource
    DragTypes = [dtCopy]
    OnDrop = DropFileSource1Drop
    ImageIndex = 0
    Left = 3
    Top = 320
  end
  object PopupMenu2: TPopupMenu
    MenuAnimation = [maLeftToRight]
    OwnerDraw = True
    Left = 96
    Top = 320
    object N3: TMenuItem
      Caption = #1042#1089#1077
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1077#1085#1099#1081
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #1054#1089#1090#1072#1083#1100#1085#1099#1077
      OnClick = N5Click
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 64
    Top = 320
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 288
    object N2: TMenuItem
      Caption = #1060#1072#1081#1083
      OnClick = N2Click
    end
    object N1: TMenuItem
      Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103
      OnClick = N1Click
    end
    object VK1: TMenuItem
      Caption = 'VK'
      OnClick = VK1Click
    end
    object N6: TMenuItem
      Caption = 'URL'
      OnClick = N6Click
    end
  end
  object PopupMenu3: TPopupMenu
    Top = 288
    object N7: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1090#1077#1082#1091#1097#1077#1084#1091
      OnClick = N7Click
    end
    object N8: TMenuItem
      Caption = #1042#1084#1077#1089#1090#1086' '#1090#1077#1082#1091#1097#1077#1075#1086
      OnClick = N8Click
    end
    object N14: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N14Click
    end
  end
  object DropFileTarget1: TDropFileTarget
    DragTypes = [dtLink]
    GetDataOnEnter = True
    OnDrop = DropFileTarget1Drop
    ShowImage = False
    OptimizedMove = True
    Left = 32
    Top = 320
  end
  object PopupMenu4: TPopupMenu
    Left = 32
    Top = 288
    object N9: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = N9Click
    end
    object N10: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1089#1087#1080#1089#1082#1072
      OnClick = N11Click
    end
    object N12: TMenuItem
      Caption = #1055#1077#1088#1077#1084#1077#1096#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = N12Click
    end
    object N13: TMenuItem
      Caption = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072
      object VK2: TMenuItem
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' VK'
      end
      object N16: TMenuItem
        Caption = #1052#1086#1080' '#1089#1087#1080#1089#1082#1080
      end
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = #1053#1086#1074#1099#1081' '#1089#1087#1080#1089#1086#1082
    Filter = 'IM PlayList|*.impl*|M3U PlayList|*.m3u*'
    Options = [ofHideReadOnly, ofPathMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 160
    Top = 288
  end
  object OpenDialog2: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 128
    Top = 288
  end
  object PopupMenu5: TPopupMenu
    Left = 96
    Top = 288
    object N15: TMenuItem
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      OnClick = N15Click
    end
    object N22: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = N2Click
    end
    object N19: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N4Click
    end
    object e1: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1086#1089#1090#1072#1083#1100#1085#1099#1077
      OnClick = N5Click
    end
    object N21: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnClick = N3Click
    end
    object N20: TMenuItem
      Caption = #1055#1077#1088#1077#1084#1077#1096#1072#1090#1100
      OnClick = N12Click
    end
    object N17: TMenuItem
      Caption = #1057#1082#1072#1095#1072#1090#1100' '
      OnClick = N17Click
    end
    object N18: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1072#1091#1076#1080#1086#1079#1072#1087#1080#1089#1080' '#1042#1050' '
      OnClick = N18Click
    end
    object N24: TMenuItem
      Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1089#1087#1080#1089#1082#1072
      OnClick = N11Click
    end
    object N23: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1090#1086#1090' '#1089#1087#1080#1089#1086#1082' '#1074' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1091
      OnClick = N23Click
    end
  end
  object SaveDialog2: TSaveDialog
    Left = 128
    Top = 320
  end
end
