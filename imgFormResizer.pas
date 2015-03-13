unit imgFormResizer;

//////////////////////////////////////////
//                                      //
//     IMTrayPlayer Component LIB.      //
//         Form Resizer For             //
//     IM Skin Engine V 0.99 beta       //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, dialogs, Messages, SysUtils, Variants, Classes, Graphics, Controls, ExtCtrls, forms;

type
  TimgFormResizer = class(TPaintBox)
  private 
    FMinWidth: integer;
    FMinHeight: integer;
    FResize: TNotifyEvent;
    isResizing: boolean;
    oldPos: TPoint;
    WRect: TRect;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
          X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); override;
  
    { Private declarations }
  protected 
    { Protected declarations }
  public 
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    { Public declarations }
  published
  Property MinHeight:integer read FMinHeight write FMinHeight default 150;
  Property MinWidth:Integer read FMinWidth write FMinWidth default 150;
  Property OnResizeEnd:TNotifyEvent read FResize write FResize;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TimgFormResizer]);
end;

constructor  TimgFormResizer.Create(AOwner: TComponent);
begin
  inherited;
  isResizing := False;
  FMinHeight := 150;
  FMinWidth := 150;
  self.Width := 30;
  self.Height := 30;
end;

destructor TimgFormResizer.Destroy;
begin
  inherited;
end;

procedure TimgFormResizer.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  dx, dy: integer;

begin
  if isResizing then
  begin
    DrawFocusRect(GetDC(0), WRect); //стираем предыдущую рамку
    dx := Mouse.CursorPos.X - oldPos.X;
    dy := Mouse.CursorPos.Y - oldPos.Y;
    if (WRect.Right - WRect.Left + dx > MinWidth) and (WRect.Right + dx <
      Screen.Width) then
      WRect.Right := WRect.Right + dx;
    if (WRect.Bottom - WRect.Top + dy > MinHeight) and (WRect.Bottom + dy <
      Screen.Height) then
      WRect.Bottom := WRect.Bottom + dy;
    oldPos := Mouse.CursorPos;
    DrawFocusRect(GetDC(0), WRect);
  end;
  inherited;
end;

procedure TimgFormResizer.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isResizing := true;
  oldPos := Mouse.CursorPos;
  GetWindowRect(self.Parent.Handle, WRect); //получаем прямоугольник окна
  DrawFocusRect(GetDC(0), WRect); //АПИ функция, рисующая рамку
  inherited;
end;

procedure TimgFormResizer.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if isResizing then
  begin
    DrawFocusRect(GetDC(0), WRect);
    self.Parent.BoundsRect := WRect;
    if Assigned(FResize) then
      FResize(self);
  end;
  isResizing := false;
  inherited;
end;


end.