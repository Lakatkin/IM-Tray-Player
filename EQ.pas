unit EQ;

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
  Dialogs, SkinEngine, ImgButton, ExtCtrls, ImgTrackBar, StdCtrls, ConfigManger,
  Sound_Engine, MyUtils, Menus;

type
  TEQ_BOX = class(TForm)
    ImgTrackBar11: TImgTrackBar;
    ImgTrackBar2: TImgTrackBar;
    ImgTrackBar3: TImgTrackBar;
    ImgTrackBar4: TImgTrackBar;
    ImgTrackBar5: TImgTrackBar;
    ImgTrackBar6: TImgTrackBar;
    ImgTrackBar7: TImgTrackBar;
    ImgTrackBar8: TImgTrackBar;
    ImgTrackBar9: TImgTrackBar;
    ImgTrackBar10: TImgTrackBar;
    ImgTrackBar1: TImgTrackBar;
    ImgButton1: TImgButton;
    ImgButton2: TImgButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    PopupMenu3: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    N4: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButton1Click(Sender: TObject);
    procedure ImgButton2Click(Sender: TObject);
    procedure ImgTrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private 
  procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
  Procedure UpdateEQList;
  Procedure EQLoad(Sender: TObject);
    { Private declarations }
  public 
    { Public declarations }
    Procedure UpduteEQ;
  end;

function CallBackSkinLoad(s: String): Boolean;

var
  EQ_BOX: TEQ_BOX;

implementation

uses
  Main, OptionsBox, PlayList;

{$R *.dfm}

var
EQMapList:TStringList;

procedure TEQ_BOX.WMMoving(var Msg: TWMMoving);
var
  workArea: TRect;
begin
  if Options_Box.CheckBox9.Checked then
  begin
    workArea := Screen.WorkareaRect;
    with Msg.DragRect^ do
    begin
      if Left < workArea.Left then
        OffsetRect(Msg.DragRect^, workArea.Left - Left, 0);
      if Top < workArea.Top then
        OffsetRect(Msg.DragRect^, 0, workArea.Top - Top);
      if Right > workArea.Right then
        OffsetRect(Msg.DragRect^, workArea.Right - Right, 0);
      if Bottom > workArea.Bottom then
        OffsetRect(Msg.DragRect^, 0, workArea.Bottom - Bottom);
    end;
  end;
end;

function CallBackSkinLoad(s: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  with EQ_BOX do
  begin
    Width := EQMain.Width;
    Height := EQOver.Height;
    for i := 1 to 11 do
    begin
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).Main := EQMain;
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).Over := EQOver; 
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).Orientation := trVertical;
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).SliderNR := EQSLM;
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).SliderDW := EQSLO; {}
    end;
    for i := 1 to 2 do
    begin
      (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Main := EQMain;
      (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Over := EQOver;
    end;
  end;
  Result := True;
  Result := (Result and Main_Window.CallBackSkinLoad(s) and
  Play_List.CallBackSkinLoad(s));
end;

procedure  TEQ_BOX.UpdateEQList;
Var
i:integer;
begin
ReadFolder(EQstylesPath,'*.eqs;',EQMapList);
for i:=0 to EQMapList.Count-1 do
CreatNewMenuItem(N1,EQLoad,PopupMenu3.Items,GetFileName(EQMapList[i]));

end;
procedure TEQ_BOX.EQLoad(Sender: TObject);
begin
EQMapList[n1.IndexOf((Sender as TMenuItem)) - 1];
end;

procedure TEQ_BOX.FormPaint(Sender: TObject);
begin
  Canvas.Draw(0, 0, EQMain);
end;

procedure TEQ_BOX.FormShow(Sender: TObject);
begin
  EQ_BOX.TransparentColor := True;
  EQ_BOX.TransparentColorValue := EQMain.Canvas.Pixels[0, 0];
end;

procedure TEQ_BOX.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crSizeall;
  ReleaseCapture;
  EQ_BOX.perform(WM_SysCommand, $f012, 0);
  Screen.Cursor := crDefault;
end;

procedure TEQ_BOX.ImgButton1Click(Sender: TObject);
begin
  main_Window.ImgButton8.Click(false);
end;

procedure TEQ_BOX.ImgButton2Click(Sender: TObject);
begin
  if ImgButton2.Checked then
  begin
    ImgButton2.Hint := 'Включить Эквалайзер';
    SetEQ(False);
  end
  else
  begin
    ImgButton2.Hint := 'Выключить Эквалайзер';
    SetEQ(True);
    Self.UpduteEQ;
  end;
end;

procedure TEQ_BOX.ImgTrackBar1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetEQval((Sender as TImgTrackBar).Tag, ((Sender as TImgTrackBar).Max - (Sender as TImgTrackBar).Position));
end;

Procedure TEQ_BOX.UpduteEQ;
var
i:integer;
Sender:TObject;
begin
For i:=1 to 10 do
begin
Sender := FindComponent('ImgTrackBar' + Inttostr(i));
SetEQval((Sender as TImgTrackBar).Tag, ((Sender as TImgTrackBar).Max - (Sender as TImgTrackBar).Position));
end;
end;

procedure TEQ_BOX.N2Click(Sender: TObject);
Var
s,File_,FileName:string;
begin
s:='Новый стиль';
if InputQuery('Создание нового стиля','Введите назания нового стиля',s) then
begin
FileName:=FilenameCut(GetNewFileName(EQstylesPath,FileNameStd(s),'.eqs'),254)+'.eqs';
SaveEQSettings(FileName);
EQMapList.Add(FileName);
CreatNewMenuItem(N1,EQLoad,PopupMenu3.Items,GetFileName(EQMapList[EQMapList.count-1]));
FileName:='';
end;
end;

procedure TEQ_BOX.FormCreate(Sender: TObject);
begin
EQMapList:=TStringList.Create;
UpdateEQList;
self.OnKeyDown := Main_Window.FormKeyDown;
self.OnKeyUP := Main_Window.FormKeyUP;
end;

procedure TEQ_BOX.FormDestroy(Sender: TObject);
begin
EQMapList.Free;
end;

procedure TEQ_BOX.N4Click(Sender: TObject);
begin
LoadEQSettings('');
end;

procedure TEQ_BOX.N7Click(Sender: TObject);
begin
LoadEQSettings(EQMapList[n1.IndexOf((Sender as TMenuItem).Parent) - 1]);
end;

procedure TEQ_BOX.N8Click(Sender: TObject);
begin
DeleteFile(EQMapList[n1.IndexOf((Sender as TMenuItem).Parent) - 1]);
EQMapList.Delete(n1.IndexOf((Sender as TMenuItem).Parent) - 1);
n1.Remove((Sender as TMenuItem).Parent);
(Sender as TMenuItem).Parent.Free;
end;

end.
