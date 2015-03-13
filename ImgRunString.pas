unit ImgRunString;

//////////////////////////////////////////
//                                      //
//     IMTrayPlayer Component LIB.      //
//       Graphics RunString For         //
//     IM Skin Engine V 0.99 beta       //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ExtCtrls, StdCtrls;

type
  TImgRunString = class(TPanel)
  private 
    CRect, PRect: TRect;
    FMain: TBitMap;
    FBack: TBitMap;
    FText: String;
    FInterval: integer;
    FStep: Integer;
    FRun: Boolean;
    Timer1: Ttimer;
    xd1, yd1: Integer;
    bm:TBitMap;
    FClP: Integer;
    FMoveByMouse: boolean;
    FMouseClicked: boolean;
    OsVer: TOSVersionInfo;
    isOldOs:boolean;
  LBL: TLabel;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
       X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure SetMain(const Value: TBitMap);
    procedure SetInterval(Value: Integer);
    procedure SetRun(Value: Boolean);
    procedure TimerProc1(Sender: TObject);
    procedure SetText(Value: String);
    function IsBitmapAssing(var Bmp: TBitMap): Boolean;
    procedure DrawStr(xd, yd: Integer);
      procedure LBLDWN(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure LBLUP(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure LBLMV(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
  { Private declarations }
  protected 
    { Protected declarations }
  public 
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Loaded; override;
    procedure   Resize; override;
    Procedure _Update;
    procedure Paint; override;
    { Public declarations}
  published
  Property Text:String Read FText Write SetText;
  Property Main:TBitMap Read FMain Write setMain;
  Property Interval:Integer Read FInterval Write SetInterval default 30;
  Property Run:Boolean Read FRun Write   SetRun default false;
  Property Step: Integer Read FStep Write FStep;
  Property DOWN:Boolean read  FMouseClicked default false;
  Property MoveByMouse:boolean read FMoveByMouse write FMoveByMouse default false;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TImgRunString]);
end;

function TImgRunString.IsBitmapAssing(var Bmp: TBitMap): Boolean;
begin
  Result := (bmp.Width <> 0) and (bmp.Height <> 0);
end;

constructor TImgRunString.Create;
begin
  inherited Create(AOwner);
  OsVer.dwOSVersionInfoSize := SizeOf(OsVer);
  GetVersionEx(OsVer);
 if OsVer.dwMajorVersion>=6 then
   isOldOs:=false;
   if isOldOs then
   begin
 LBL := TLabel.Create(self);
  LBL.ShowAccelChar:=False;
  LBL.Color:=self.Color;
  Lbl.AutoSize:=true;
  LBL.OnMouseDown := LBLDWN;
  LBL.OnMouseUp := LBLUP;
  LBL.OnMouseMove := LBLMV;
  Self.InsertControl(LBL);
   end
   else
   begin
  bm:=TBitMap.Create;
  bm.Width:=self.Width;
  bm.Height:=self.Height;
   end;
  Self.BevelOuter:=bvNone;
  FMain := TBitMap.Create;
  FBack := TBitMap.Create;
  Timer1 := TTimer.Create(Self);
  Timer1.Interval := 30;
  Timer1.Enabled := False;
  Timer1.OnTimer := TimerProc1;
  Self.Height := 10;
  Self.Width := 300;
  FBack.Width := Width+4;
  FBack.Height := Height+4;
  Fstep := 1;
end;


destructor TImgRunString.Destroy;
begin
  FMain.Free;
  FBack.Free;
  Timer1.Free;
  if isOldOs then
  LBL.Free
  else
  Bm.Free;
  inherited Destroy;
end;


procedure TImgRunString.SetMain(const  Value: TBitMap);
begin
  FMain.Assign(Value);
  cRect := Bounds(Left, Top, Width, Height);
  pRect := Bounds(0, 0, Width, Height);
  FBack.Canvas.CopyRect(pRect, FMain.Canvas, cRect);
end;



procedure TImgRunString.SetInterval(Value: Integer);
begin
  FInterval := Value;
  Timer1.Interval := Value;
end;

procedure TImgRunString.SetRun(Value: Boolean);
begin
  FRun := Value;
  Timer1.Enabled := FRun;
end;

procedure TImgRunString.SetText(Value: String);
begin
  if   FText = Value then
    exit;
      FText := Value;
      if IsOldOs then
        LBL.Caption := FText;
  xd1 := Self.Width;
  yd1 :=0;
  DrawStr(xd1, yd1);
end;

procedure TImgRunString.DrawStr(xd, yd: Integer);
begin
if IsOldOs then
begin
  if LBL.Left = xd then
    exit;
  LBL.Left := xd;
  LBL.Top := yd;
end
else
begin
  bm.Canvas.Brush.Color:=self.Color;
    bm.Canvas.Polygon([Point(0, 0), Point(bm.Width, 0),
                               Point(bm.Width, bm.Height), Point(0, bm.Height)]);

  bm.Canvas.TextRect(rect(0,0,bm.Width,bm.Height),xd,yd,FText);
  Canvas.Draw(0,0,bm);
end;
end;


procedure TImgRunString.TimerProc1(Sender: TObject);
begin
  if Canvas.TextWidth(FText) < (self.Width - 5) then
  begin
    Xd1 := 5;
    yd1 := 0;
  end
  else
  begin
    Xd1 := Xd1 - FStep;
    yd1 := 0;
    if xd1 < -Canvas.TextWidth(FText) then
    begin
      xd1 := Width;
    end;
  end;
  DrawStr(xd1, yd1);
end;

procedure  TImgRunString.Loaded;
begin
  inherited;
  xd1 := Self.Width;
  yd1 := 0;
  _Update;
  DrawStr(xd1, yd1);
end;

procedure TImgRunString.Resize;
begin
  inherited resize;
  xd1 := Self.Width;
  yd1 := 0;
  _Update;
  DrawStr(xd1, yd1);
    
end;

procedure TIMGRunstring.Paint;
begin
  inherited;
  if IsOldOs then
   exit;

{  if IsBitmapAssing(FMain) then
  begin

    Canvas.Draw(0, 0, FBack);
  end
  else
  begin  }
  Self.Canvas.Brush.Color:=self.Color;
    Canvas.Pen.Style := psClear;
    Self.Canvas.Polygon([Point(0, 0), Point(self.Width, 0),
                               Point(self.Width, self.Height), Point(0, self.Height)]);
 { end;   }
end;

procedure TIMGRunstring.MouseDown(Button: TMouseButton; Shift: TShiftState;
       X, Y: Integer);
begin
if isOldOs then
 begin
inherited;
exit;
  end;
if x>(Self.Canvas.TextWidth(Ftext)+xd1) then
begin
inherited;
exit;
  end;
  if FMovebymouse then
  begin
    FMouseClicked := True;
    FClP := x;
    Timer1.Enabled := False;

  end
  else
Inherited;
end;

procedure TIMGRunstring.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
if isOldOs then
 begin
inherited;
exit;
  end;
  if FMouseClicked and FMovebymouse then
  begin
    FMouseClicked := False;
    Sleep(500);
    Timer1.Enabled := True;
    
  end
   else
Inherited;
end;

procedure TIMGRunstring.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
if isOldOs then
 begin
inherited;
exit;
  end;
  if FMouseClicked and FMovebymouse then
  begin
    xd1 := ((x-FClP));
    if  xd1 > Width then
      xd1 := Width;
    Self.DrawStr(xd1,Yd1);
  end;
end;

procedure TIMGRunstring.LBLDWN(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMovebymouse then
  begin
    FMouseClicked := True;
    FClP := x;
    Timer1.Enabled := False;
  end
  else
  if assigned(Self.OnMouseDown) then
    Self.OnMouseDown(Sender, Button,
   Shift, X, Y);
end;

procedure TIMGRunstring.LBLUP(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMovebymouse then
  begin
    FMouseClicked := False;
    Sleep(500);
    Timer1.Enabled := True;

  end
   else
  if assigned(Self.OnMouseUp) then
    Self.OnMouseUp(Sender, Button,
   Shift, X, Y);
end;

procedure TIMGRunstring.LBLMV(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FMouseClicked and FMovebymouse then
  begin
    xd1 := xd1 + (x - fclp);
    if  xd1 > Width then
      xd1 := Width;
    LBL.Left := xd1;
  end;
end;

Procedure TIMGRunstring._Update;
begin
  if isOldOs then
 begin
  FBack.Canvas.Font.Assign(Font);
  Self.Canvas.Font.Assign(Font);
  LBL.Font.Assign(Font);
  If Self.Height<Canvas.TextHeight(FText) then
  Self.Height:=Canvas.TextHeight(FText);
  end
  else
  begin
  FBack.Canvas.Font.Assign(Font);
  Self.Canvas.Font.Assign(Font);
  bm.Canvas.Font.Assign(Font);
  If Self.Height<Canvas.TextHeight(FText) then
  Self.Height:=Canvas.TextHeight(FText);
        bm.Width:=Width;
  bm.Height:=self.Height;
  end;
end;

end.