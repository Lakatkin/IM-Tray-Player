unit imgGraphicHint;

//////////////////////////////////////////
//                                      //
//     IMTrayPlayer Component LIB.      //
//        Graphics Hint For             //
//     IM Skin Engine V 0.99 beta       //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Dialogs, Variants, Classes, Controls, Forms, Messages, Graphics, Sysutils,
  ExtCtrls, MyUtils;

type
  TImgGraphicHintWindow = class(THintWindow)
  private 
    FActivating: Boolean;
    BMP_: TBitMap;
    procedure BMP2Hint(Bmp: TBitMap);
    procedure SetAlpha(Val: Integer; Handle: HWND);
  public 
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    constructor Create(AOwner: TComponent); override;
  protected 
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  
  end;

procedure LoadHintBmp(Bmp:TbitMap);

var
  HintAlphaBlend: Boolean;
  HintAlphaBlendvalue: integer;
  HintFont: TFont;

implementation

var
  HintBitMap: TBitmap;

procedure LoadHintBmp(Bmp:TbitMap);
begin
  if not assigned(HintBitMap) then
    HintBitMap := TBitmap.Create;
  try
    HintBitMap.Assign(Bmp);
  except
    HintBitMap. Free;
  end;
end;

procedure TImgGraphicHintWindow.SetAlpha(Val: Integer; Handle: HWND);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TOOLWINDOW);
  SetLayeredWindowAttributes(Handle, 0, Val, LWA_ALPHA);
end;


procedure TImgGraphicHintWindow.BMP2Hint(Bmp: TBitMap);
var
  Crect, Prect: Trect;
  LpW, RpW: Integer;
begin
  Bmp_.Width := Width;
  Bmp_.Height := Height;
  LPW := Trunc(Bmp.Width / 2) - 4;
  RPW := Trunc(Bmp.Width / 2);
  CRect := Bounds(0, 0, LPW, Bmp.Height);
  Prect := Crect;
  Bmp_.Canvas.CopyRect(prect, Bmp.Canvas, crect);
  CRect := Bounds(LPW + 4, 0, RPW, Bmp.Height);
  Prect := Bounds(Bmp_.Width - RPW, 0, RPW, Bmp.Height);
  Bmp_.Canvas.CopyRect(prect, Bmp.Canvas, crect);
  CRect := Bounds(LPW, 0, 4, Bmp.Height);
  Prect := Bounds(LPW, 0, Bmp_.Width - RPW - LPW, Bmp.Height);
  Bmp_.Canvas.CopyRect(prect, Bmp.Canvas, crect);
end;

constructor TImgGraphicHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BMP_ := TBitMap.Create;
end;

procedure TImgGraphicHintWindow.Paint;
var
  R: TRect;
begin
  if assigned(HintBitMap) then
  begin
    R := ClientRect;
    Canvas.Brush.Style := bsClear;
    Canvas.Draw(0, 0, BMP_);
    Canvas.Font := HintFont;
    Canvas.TextOut(5, (R.Bottom div 2) - (Canvas.Textheight(Caption) div 2),
        Caption);
  end
  else
    inherited;
end;

procedure TImgGraphicHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  Rgn: HRGN;
begin
  if assigned(HintBitMap) then
  begin
    FActivating := True;
    try
      Caption := AHint;
      UpdateBoundsRect(Rect);
      if Rect.Top + Height > Screen.DesktopHeight then
        Rect.Top := Screen.DesktopHeight - Height;
      if Rect.Left + Width > Screen.DesktopWidth then
        Rect.Left := Screen.DesktopWidth - Width;
      if Rect.Left < Screen.DesktopLeft then
        Rect.Left := Screen.DesktopLeft;
      if Rect.Bottom < Screen.DesktopTop then
        Rect.Bottom := Screen.DesktopTop;
      Self.Height :=  HintBitMap.Height;
      if self.Width < HintBitMap.Width then
        self.Width := HintBitMap.Width
      else
        self.Width := self.Width + 2;
      BMP2Hint( HintBitMap);
      rgn :=  CreateRgnFromBitmap(bmp_, bmp_.Canvas.Pixels[0, 0]);
      
      SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_SHOWWINDOW or SWP_NOACTIVATE);
      Invalidate;
      SetWindowRgn(Handle, rgn, True);
      if HintAlphaBlend then
        SetAlpha(HintAlphaBlendvalue, handle)
      else
        SetAlpha(255, handle)
    finally
      FActivating := False;
    end;
  end
  else
    inherited;
end;

procedure TImgGraphicHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with params do
  begin
    style := Ws_POPUP or WS_DISABLED;
    if checkWin32version(5, 1) then
      WindowClass.style := WindowClass.style and not CS_DROPSHADOW;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.hbrBackground := 0;
    
  end;
end;

initialization
  HintFont := TFont.Create;

finalization
  HintFont.Free;
end.