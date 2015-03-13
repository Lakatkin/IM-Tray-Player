unit ImgButton;

//////////////////////////////////////////
//                                      //
//     IMTrayPlayer Component LIB.      //
//        Graphics Button For           //
//     IM Skin Engine V 0.99 beta       //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ExtCtrls;

type
  TImgButton = class(TPaintBox)
  private 
    CRect, PRect: TRect;
    FMain: TBitMap;
    FOver: TBitMap;
    Fselected: TBitMap;
    FExtBtn: TBitMap;
    FClick: TBitMap;
    FMove: TBitMap;
    FDown: TBitMap;
    MouseLeaved: boolean;
    MouseClicked: boolean;
    FCheckBox: Boolean;
    FChecked: Boolean;
    FDownNeedFree:boolean;
    procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
    procedure   Loaded;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
       X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    Procedure SetMain(const Value:TBitMap);
    Procedure SetOver(const Value:TBitMap);
    Procedure SetSelected(const Value:TBitMap);
    Procedure SetExtBtn(const Value:TBitMap);
    Function IsBitmapAssing(Var Bmp:TBitMap):Boolean;
    procedure   paint;override;
      { Private declarations }
  protected 
  
    { Protected declarations }
  
  public 
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Click(fake: boolean);
    { Public declarations }
    
      published
    property Main: TBitMap read FMain write setMain;
    property Over: TBitMap read Fover write SetOver;
    property ExternalButton: TBitMap read FExtBtn write SetExtBtn;
    property Selected: TBitMap read FSelected write SetSelected;
    property UseAsCheckBox: boolean read FCheckBox write FCheckBox;
    property Checked: Boolean read Fchecked write Fchecked;
    Property DOWN:Boolean read  MouseClicked default false;
  end;

procedure Register;

implementation



procedure Register;
begin
  RegisterComponents('Samples', [TImgButton]);
end;

{ TVRSIWebButton }

function TImgButton.IsBitmapAssing(var Bmp: TBitMap): Boolean;
begin
  Result := (bmp.Width <> 0) and (bmp.Height <> 0);
end;

constructor TImgButton.Create;
begin
  inherited Create(AOwner);
  FMain := TBitMap.Create;
  FOver := TBitMap.Create;
  Fselected := TBitMap.Create;
  FExtBtn := TBitMap.Create;
  FClick := TBitMap.Create;
  FMove := TBitMap.Create;
  FDown := TBitMap.Create;
  Self.Height := 45;
  Self.Width := 60;
  MouseLeaved := false;
  MouseClicked := false;
  FDownNeedFree:=false;
end;

destructor TImgButton.Destroy;
begin
  FMain.Free;
  FOver.Free;
  Fselected.Free;
  FClick.Free;
  FMove.Free;
  if FDownNeedFree then
  FDown.Free;
  inherited Destroy;
end;


procedure TImgButton.SetMain(const  Value: TBitMap);
begin
  FMain.Assign(Value);
  cRect := Bounds(Left, Top, Width, Height);
  pRect := Bounds(0, 0, Width, Height);
  FClick.Width := Width;
  FClick.Height := Height;
  FClick.Canvas.CopyRect(pRect, FMain.Canvas, cRect);
end;


procedure TImgButton.SetOver(const  Value: TBitMap);
begin
  FOver.Assign(Value);
  cRect := Bounds(Left, Top, Width, Height);
  pRect := Bounds(0, 0, Width, Height);
  FMove.Width := Width;
  FMove.Height := Height;
  FMove.Canvas.CopyRect(pRect, FOver.Canvas, cRect);
end;

procedure TImgButton.SetSelected(const  Value: TBitMap);
begin
  FSelected.Assign(Value);
  FDownNeedFree:=true;
  cRect := Bounds(Left, Top, Width, Height);
  pRect := Bounds(0, 0, Width, Height);
  FDown.Width := Width;
  FDown.Height := Height;
  FDown.Canvas.CopyRect(pRect, FSelected.Canvas, cRect);
end;

procedure TImgButton.SetExtBtn(const Value: TBitMap);
begin
  FExtBtn.Assign(Value);
  pRect := Bounds(0, 0, Width, Height);
  cRect := Bounds(0, 0, Width, Height);
  FClick.Width := Width;
  FClick.Height := Height;
  FClick.Canvas.CopyRect(pRect, FExtBtn.Canvas, cRect);
  Paint;
  if FExtBtn.Width >= (Self.Width * 2) then
  begin
    cRect := Bounds(Width, 0, Width, Height);
    FMove.Width := Width;
    FMove.Height := Height;
    FMove.Canvas.CopyRect(pRect, FExtBtn.Canvas, cRect);
  end;
  if FExtBtn.Width >= (Self.Width * 3) then
  begin
  FDownNeedFree:=true;
    cRect := Bounds(Width * 2, 0, Width, Height);
    FDown.Width := Width;
    FDown.Height := Height;
    FDown.Canvas.CopyRect(pRect, FExtBtn.Canvas, cRect);
  end;
  self.Repaint;
end;

procedure TImgButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
if self.Visible then
  MouseLeaved := false;
  inherited MouseMove(Shift, x, y);
  if self.Visible then
begin
  if not IsBitmapAssing(FMove) or (MouseClicked)  then
    exit;
  Canvas.Draw(0, 0, FDown);
  if Fchecked and  FcheckBox then
    exit;
  Canvas.Draw(0, 0, FMove);
  end;
end;

procedure TImgButton.CMMouseLeave(var Msg: TMessage);
begin
if self.Visible then
begin
  MouseLeaved := true;
  if (not IsBitmapAssing(FClick)) then
    exit;
  Canvas.Draw(0, 0, FDown);
  if Fchecked and FcheckBox then
    exit;
  Canvas.Draw(0, 0, FClick);
  end;
  end;

procedure TImgButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
if self.Visible then
begin
  if not MouseLeaved  then
  begin
    if FcheckBox then
      Canvas.Draw(0, 0, FClick)
    else
      Canvas.Draw(0, 0, FDown);
  end
  else
    Canvas.Draw(0, 0, FClick);
  MouseClicked := true;
  end;
  inherited MouseDown(Button, Shift, x, y);
end;

procedure TImgButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
    inherited MouseUp(Button, Shift, x, y);
  if not checked then
    checked := True
  else
    checked := false;
   if self.Visible then
   begin
  if  MouseLeaved and IsBitmapAssing(FMove)  then
    Canvas.Draw(0, 0, FMove)
  else
    Canvas.Draw(0, 0, FClick);
  MouseClicked := false;
  if Fchecked and  FcheckBox then
    Canvas.Draw(0, 0, FDown);
    end;
end;

procedure TImgButton.Paint;
begin
  inherited Paint;
  if (not IsBitmapAssing(FDown))  then
  begin
    FDown.Free;
    if FcheckBox then
      FDown:=FMove
    else
      FDown:=FClick;
  end;
  if Fchecked and  FcheckBox then
    Canvas.Draw(0, 0, FDown)
  else
    Canvas.Draw(0, 0, FClick);   {  }
  
end;

procedure  TImgButton.Loaded;
begin
  inherited;
end;

procedure TImgButton.Click(fake: boolean);
begin
  if not fake then
    inherited Click;
  Mousedown(mbLeft, [ssLeft], 0, 0);
  MouseMove([ssLeft], 0, 0);
  Mouseup(mbLeft, [ssLeft], 0, 0);
end;

end.