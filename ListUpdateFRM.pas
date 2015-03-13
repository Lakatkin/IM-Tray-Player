unit ListUpdateFRM;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,MyUtils;

type
  TList_Update = class(TForm)
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FirstStart:boolean;
  public
    { Public declarations }
  end;

var
  List_Update: TList_Update;
  BMP_:TBitMap;
i:Integer;


implementation

uses PlayList, Main, EQ, VK_audio;

{$R *.dfm}
{$R ResDat.res}

procedure TList_Update.FormShow(Sender: TObject);
begin
if FirstStart then
begin
ShowWindow(Application.Handle, SW_HIDE);
end;
Play_List.Enabled:=false;
Main_Window.Enabled:=false;
EQ_Box.Enabled:=false;
VK_Mus.Enabled:=false;
{if main_Window.ImgButton2.Checked then
begin
self.Position:=poDefault;
Self.Left:=Play_List.Left+(Play_List.Width div 2)-(self.Width div 2);
Self.Top:=Play_List.Top+(Play_List.Height div 2)-(self.Height div 2);
end
else
self.Position:=poScreenCenter;  }
BMP_.LoadFromResourceID(Hinstance,1);
self.Width:=BMP_.Width;
self.Height:=BMP_.Height;
I:=1;
Canvas.Draw(0,0,BMP_);
Timer1.Enabled:=true;
SetWindowRgn(Handle,CreateRgnFromBitmap(bmp_,bmp_.Canvas.Pixels[0,0]),true);
end;

procedure TList_Update.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Play_List.Enabled:=True;
Main_Window.Enabled:=True;
EQ_Box.Enabled:=True;
VK_Mus.Enabled:=True;
Timer1.Enabled:=False;
FirstStart:=False;
end;

procedure TList_Update.Timer1Timer(Sender: TObject);
begin
I:=I+1;
BMP_.LoadFromResourceID(Hinstance,I);
Canvas.Draw(0,0,BMP_);
If I=10 then
I:=0;
end;

procedure TList_Update.FormCreate(Sender: TObject);
begin
BMP_:=TBitMap.Create;
FirstStart:=True;
end;

procedure TList_Update.FormDestroy(Sender: TObject);
begin
bmp_.Free;
end;

end.
