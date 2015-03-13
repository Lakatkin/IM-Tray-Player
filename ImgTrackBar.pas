unit ImgTrackBar;
//////////////////////////////////////////
//                                      //
//     VKTrayPlayer Component LIB.      //
//       Graphics TrackBar For          //
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
  TImgTrackBarOrientation = (trHorizontal, trVertical);
  TImgTrackBar = class(TPaintBox)
  private 
    CRect, PRect: TRect;
    FOrientation: TImgTrackBarOrientation;
    FProgress_: Integer;
    FProg2Pos: Boolean;
    FBackProgress: Boolean;{
    FMmUse:Boolean;}
    FPosition: Integer;
    FMax: Integer;
    FMin: Integer;
    FBKMax: Integer;
    FBKMin: Integer;
    FSLW: Integer;
    FSLH: Integer;
    FBack: TBitMap;
    CMP: Integer;
    FSPSSl: Integer;
    FRunLayNR: TBitMap;
    FRunLayDW: TBitMap;
    FRunLayMV: TBitMap;
    FMain: TBitMap;
    FOver: TBitMap;
    FTMP: TBitMap;
    FClick: Integer;
    FDW: Boolean;
    FMSLS: Boolean;
    
    {   procedure CMMouseEnter(var Msg:TMessage); message CM_MOUSEENTER;
       procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
    } procedure SetOrientation(Value: TImgTrackBarOrientation);
    procedure SetPosition(Index: integer; const Value: Integer);
    procedure SetProgress_(Index: integer; const Value: Integer);
    procedure SetMain(const Value: TBitMap);
    procedure SetOver(const Value: TBitMap);
    procedure SetRunLayNR(const Value: TBitMap);
    procedure SetRunLayDW(const Value: TBitMap);
    procedure SetRunLayMV(const Value: TBitMap);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
       X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
  
  protected 
  
  public 
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
     {   Published declarations }
    Property ManualSliderSize:Boolean Read FMSLS Write FMSLS default false;
    Property Prog2Pos:Boolean Read FProg2Pos Write FProg2Pos default false;
    property Orientation: TImgTrackBarOrientation read FOrientation write SetOrientation default trHorizontal;
    property BackProgress: Boolean read FBackProgress write FBackProgress default false;
    {property slidermoveIMGUse:Boolean read FMmUse write FMmUse default False;
    }property Max: Integer read  FMax write FMAX default 1;
    property Min: Integer read  FMin write FMIN default 1;
    property MaxProg: Integer read  FBKMax write FBKMax default 1;
    property MinProg: Integer read  FBKMin write FBKMin default 1;
    property Progress_: Integer index 1 read  FProgress_ write SetProgress_  default 1;
    property Position: Integer index 1 read  FPosition write SetPosition default 1;
    Property Main:TBitMap Read FMain Write setMain;
    Property Over:TBitMap Read Fover Write SetOver;
    Property SliderNR:TBitMap read FRunLayNR write SetRunLayNR;
    Property SliderDW:TBitMap read FRunLayDW write SetRunLayDW;
    Property SliderMV:TBitMap read FRunLayMV write SetRunLayMV;
    Property SliderWidth:Integer read FSLW Write FSLW default 0;
    Property SliderHeight:Integer read FSLH Write FSLH default 0;
    Property DOWN:Boolean read FDW default false;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TImgTrackBar]);
end;

constructor TImgTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBack := TBitMap.Create;
  FRunLayNR := TBitMap.Create;
  FRunLayDW := TBitMap.Create;
  FRunLayMV := TBitMap.Create;
  FMain := TBitMap.Create;
  FOver := TBitMap.Create;
  FTMP := TBitMap.Create;
  FClick := 1;
  FDW := False;
  Prog2Pos := False;
  Self.Height := 15;
  Self.Width := 60;
  {
  FMmUse:=False;}
  
end;

destructor  TImgTrackBar.Destroy;
begin
  
  FBack.Free;
  FRunLayNR.Free;
  FRunLayDW.Free;
  FRunLayMV.Free;
  FMain.Free;
  FOver.Free;
  FTMP.Free;
  inherited Destroy;
end;

procedure TImgTrackBar.Paint;
begin
  inherited Paint;
  FBack.Width := Self.Width;
  FBack.Height := Self.Height;
  cRect := Bounds(Left, Top,
Width, Height);
  pRect := Bounds(0, 0, Self.Width, Self.Height);
  SetPosition(1, FPOSITION);
  
end;

procedure TImgTrackBar.SetProgress_(Index: integer; const Value: Integer);
var
  Pos, CP: Integer;
  PRect_, CRect_: Trect;
begin
  FPRogress_ := Value;
  if not self.Visible then
    exit;
  FBack.Canvas.CopyRect(pRect, FMain.Canvas, cRect);
  Canvas.Draw(0, 0, FBack);
  if (Prog2Pos) and (FBackProgress )  then
  begin
    if Fmax = 0 then
      FMax := 100;
    Pos := Trunc(FPosition * 100 / FMAX);
  end
  else
  begin
    if FBKmax = 0 then
      FBKMax := 100;
    Pos := Trunc(FProgress_ * 100 / FBKMAX);
  end;
  if FOrientation = trVertical then
    Pos := FBKmax - Pos;
  if Pos > 100 then
  begin
    if FOrientation = trVertical then
      CP := Height
    else
      CP := Width;
  end
    else
  if Pos < 1 then
    CP := 0
    else
  begin
    if FOrientation = trVertical then
      CP := trunc((Height / 100 * pos))
    else
      CP := trunc(Width / 100 * pos);
  end;
  if FOrientation = trVertical then
  begin
    Crect_ := Bounds(Left, Top + (Height - cp), Width, cp);
    PRect_ := Bounds(0, Height - cp, Width, CP);
  end
    else
  begin
    Crect_ := Bounds(Left, Top, cp, Height);
    PRect_ := Bounds(0, 0, CP, Height);
  end;
  FBack.Canvas.CopyRect(pRect_, FOver.Canvas, cRect_);
  if Index = 1 then
    SetPosition(2, FPosition);
  
end;

procedure TImgTrackBar.SetPosition(Index: integer; const Value: Integer);
var
  PRect_, CRect_: Trect;
  Pos, VPos, CP: Integer;
begin
  FPosition := Value;
  if not self.Visible then
    exit;
  if Index <> 2 then
  begin
    if FBackProgress  then
      SetProgress_(2, FProgress_)
    else
      SetProgress_(2, FBKMAX);
    if (FProg2Pos) and (FBackProgress ) then
      SetProgress_(2, FPosition);
  end;
  if Fmax = 0 then
    FMax := 1;
  if FOrientation = trVertical then
    VPos := Fmax - FPosition
  else
    VPos := FPosition;
  Pos := Trunc(VPos * 100 / FMAX);
  case FClick of
    1: FTmp.Assign(FRunLayNR);
    2: FTmp.Assign(FRunLayMV);
    3: FTmp.Assign(FRunLayDW);
  end;
  if Pos > 100 then
  begin
    if FOrientation = trVertical then
      CP := trunc((Self.Height)) - 1
    else
      CP := trunc((Self.Width - FSLW)) - 1;
  end
    else
  if Pos <= 1 then
  begin
    if FOrientation = trVertical then
      CP := trunc((FSLH))
    else
      CP := 0;
  end
    else
  begin
    if FOrientation = trVertical then
      CP := trunc(FSLH + (Self.Height - FSLH) / 100 * (Pos))
    else
      CP := trunc((Self.Width - FSLW) / 100 * (Pos));
  end;
  if FOrientation = trVertical then
    Crect_ := Bounds(0, 0, FTMP.Width, FTMP.Height)
  else
    Crect_ := Bounds(0, 0, FTMP.Width, FTMP.Height);
  if FOrientation = trVertical then
    PRect_ := Bounds( Trunc(FSLW / 2), Self.Height - CP , FSLW, FSLH)
  else
    PRect_ := Bounds(CP + 1, Trunc(FSLH / 2), FSLW, FSLH);
  FBack.Canvas.CopyRect(Prect_, FTMP.Canvas, Crect_);
  Self.Canvas.Draw(0, 0, FBack);
  if self.Visible = false then
  begin
    self.Visible := true;
    self.Visible := false;
  end;
end;

procedure TImgTrackBar.SetOrientation(Value: TImgTrackBarOrientation);
var
  t: integer;
begin
  if FOrientation = Value then
    exit;
  
  FOrientation := Value;
  
end;

procedure TImgTrackBar.SetMain(const  Value: TBitMap);
begin
  FMain.Assign(Value);
end;

procedure TImgTrackBar.SetOver(const Value: TBitMap);
begin
  FOver.Assign(Value);
end;



procedure TImgTrackBar.SetRunLayNR(const  Value: TBitMap);
begin
  FRunLayNR.Assign(Value);
  if not FMSLS  then
  begin
    SliderWidth := FRunLayNR.Width;
    SliderHeight := FRunLayNR.Height;
  end;
end;

procedure TImgTrackBar.SetRunLayDW(const  Value: TBitMap);
begin
  FRunLayDW.Assign(Value);
end;

procedure TImgTrackBar.SetRunLayMV(const  Value: TBitMap);
begin
  FRunLayMV.Assign(Value);
end;

procedure TImgTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  FClick := 3;
  FDW := True;
  if FOrientation = trVertical then
  begin
    CMP := round((y) / Self.Height * FMAX);{
    FSPSSl:=round(((FSLW)/Height )* FMAX);    }
  end
     else
  begin
    CMP := round((x) / Self.Width * FMAX);
    { FSPSSl:=round(((FSLW)/Width )* FMAX);   }
  end;{  }
  if CMP > FMAX then
    CMP := FMAX;
  if CMP < 0 then
    CMP := 0;
  Position := CMP;
  inherited MouseDown(Button, Shift, x, y);
end;

procedure TImgTrackBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FOrientation = trVertical then
  begin
    CMP := round((y) / Self.Height * FMAX);{
    FSPSSl:=round(((FSLW)/Height )* FMAX);    }
  end
     else
  begin
    CMP := round((x) / Self.Width * FMAX);
    { FSPSSl:=round(((FSLW)/Width )* FMAX);   }
  end;{  }
  if CMP > FMAX then
    CMP := FMAX;
  if CMP < 0 then
    CMP := 0;
  if FDW then
  begin
    FCLick := 3;
    Position := CMP;
  end;
  inherited MouseMove(Shift, x, y);
end;

procedure TImgTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  FClick := 1;
  FDW := False;
  if FOrientation = trVertical then
  begin
    CMP := round((y) / Self.Height * FMAX);{
    FSPSSl:=round(((FSLW)/Height )* FMAX);    }
  end
     else
  begin
    CMP := round((x) / Self.Width * FMAX);
    { FSPSSl:=round(((FSLW)/Width )* FMAX);   }
  end;{  }
  if CMP > FMAX then
    CMP := FMAX;
  if CMP < 0 then
    CMP := 0;
  Position := CMP;
  inherited MouseUp(Button, Shift, x, y);
end;
       {
procedure TImgTrackBar.CMMouseEnter(var Msg:TMessage);
Begin
If not FMmUse then
exit;
if (CMP>=FPosition) and (CMP<=(FPosition+FSPSSl)) then
Begin
FClick := 2;
SetPosition(1,FPOSITION);
end;
end;

procedure TImgTrackBar.CMMouseLeave(var Msg:TMessage);
Begin

FClick := 1;
SetPosition(1,FPOSITION);
end;   }

end.