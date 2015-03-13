object List_Update: TList_Update
  Left = 355
  Top = 265
  AlphaBlend = True
  AlphaBlendValue = 160
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'List_Update'
  ClientHeight = 65
  ClientWidth = 124
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
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 88
    Top = 24
  end
end
