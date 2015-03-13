unit Main;
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
  Dialogs, StdCtrls, ImgRunString, ImgTrackBar, ExtCtrls, MyUtils, ImgButton, skinengine,
  XPMan, ConfigManger,Sound_engine,CoolTrayIcon,Menus,ImgPlayList, ImgList, TagReader,
  VKAPI_types,VK_Methods,VK_Lib,StrUtils, DragDrop, DropTarget, DragDropFile;

type
  TplayerStatus = (Play, Pause, Stop);

  TOpenThread = class(TThread)
  private
  Procedure SetFirstInfo;
  procedure SetLastInfo;
  Procedure UpdateLink;
  protected
    procedure Execute; override;
  public
    Item: pTrackdata;
    pause: boolean;
    Startpos: integer;
    OpOk: boolean;
    EndOpen: boolean;
    Rstr:string;
  end;

  TMain_Window = class(TForm)
    ImgTrackBar1: TImgTrackBar;
    ImgTrackBar2: TImgTrackBar;
    ImgRunString1: TImgRunString;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    Timer3: TTimer;
    N1: TMenuItem;
    N2: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    ImgButton8: TImgButton;
    ImgButton7: TImgButton;
    ImgButton6: TImgButton;
    ImgButton5: TImgButton;
    ImgButton1: TImgButton;
    ImgButton3: TImgButton;
    ImgButton4: TImgButton;
    ImgButton2: TImgButton;
    ImageList1: TImageList;
    ImgButton9: TImgButton;
    ImgButton10: TImgButton;
    Timer4: TTimer;
    N3: TMenuItem;
    XPManifest1: TXPManifest;
    N4: TMenuItem;
    DropFileTarget1: TDropFileTarget;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButton6Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgButton7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgButton5Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ImgButton7Click(Sender: TObject);
    procedure ImgTrackBar2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure ImgTrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgTrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButton3Click(Sender: TObject);
    procedure ImgButton4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImgButton1Click(Sender: TObject);
    procedure ImgButton2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButton8MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImgButton9Click(Sender: TObject);
    procedure ImgButton10Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    BackBMP: TBitMap;
    GlobalMousePress: Boolean;
    OldPos: Integer;
    MsInFrm: Boolean;
    Trlen: integer;
    Dllen: integer;
    NoPause: boolean;
    Wait: boolean;
    openThread: TOpenThread;
    CtrlPress: boolean;
    BR_Position:integer;
    BR_Curitem:integer;
    BR_Pause:boolean;
    procedure WndProc(var Message: TMessage); override;
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure setPlButton(st: TplayerStatus);
    Procedure _Close;
    Procedure GetGlobalDat(var Msg: TWMCopyData);  message WM_COPYDATA;
    Procedure ShowWND(var Msg: TMessage);  message WM_WNDUPDATE;
    { Private declarations }
  public
    CurList:TimgPlayList;
    alphaNorm: Integer;
    alphaMini: Integer;
    FrmMode: Integer;
    RunPlay: Boolean;
    TimeCountDown: boolean;
    Status: TplayerStatus;
    TrPos: Integer;
    VK_Status:string;
    isInitVk:boolean;
    procedure SetMinMax(mode: Integer);
    procedure DoStop;
    Procedure Open2Play(Item:pTrackData;startpos:integer=0;pause:boolean=false);
    Procedure breakPlay;
    Procedure resumPlay;
     {Call back for external unit poroc}
    function CallBackSkinLoad(s: String): Boolean;
    { Public declarations }
  end;

var
  Main_Window: TMain_Window;

implementation

uses
  PlayList, EQ, OptionsBox, ListUpdateFRM, VK_audio, About;

{$R *.dfm}

procedure TOpenThread.Execute;
var
  Cue: TCueStruct;
  i:integer;
    Text:TStringList;
    TextStr:String;
begin
  EndOpen := False;
  OpOk := false;
      If not Assigned(item) then
    exit;
    Synchronize(SetFirstInfo);
  if Item^.CUEFlag then
  begin
    Cue.File_ := Item^.filename;
    Cue.Length := Item^.time;
    Cue.Index01 := Round(CueTime2MiliSeconds(item^.Index01) / 1000);
    Cue.OneFile := Item^.OneFile;
    OpOk := Sound_Engine.OpenCue(Cue);
    if OpOk and (Item^.InfoUpdt)  then
    begin
      with Sound_Engine.Get_CurentTegdata(true,Item^.Name) do
      begin
if not (Cue.OneFile)  then
      begin
      if Options_BOX.CheckBox17.Checked then
        Item^.Name :=Pchar(Name);
        Item^.time := Time;
        end;
        Item^.Freq := SampleRate;
        Item^.BitRate := BitRate;
        Item^.InfoUpdt := False;

      end;
  end;
  end;


  if Item^.VKFlag then
  begin
OpOk := Sound_Engine.OpenFile(Item^.filename);
if (not OpOk) and Options_Box.CheckBox25.Checked then
Begin
Synchronize(UpdateLink);
OpOk := Sound_Engine.OpenFile(Item^.filename);
end;
    if OpOk and (Item^.InfoUpdt) then
    begin
      with Sound_Engine.Get_CurentTegdata(true,Item^.Name) do
      begin
      if Name<>'- ' then
     if (Options_Box.CheckBox16.Checked) and
     (Options_Box.CheckBox19.Checked) then
        Item^.Name :=Pchar(Name);
        Item^.time := Time;
        Item^.Freq := SampleRate;
        Item^.BitRate := BitRate;
        Item^.InfoUpdt := False;
      end;
      end;
  end;
  if not (Item^.VkFlag or Item^.CueFlag) then
  begin
    OpOk := Sound_Engine.OpenFile(Item^.filename);
    if OpOk and (Item^.InfoUpdt) then
    begin
    if Pos('://', Item^.filename) = 0 then
    begin
      with TagReader.Get_Tag2List(Item^.filename,true) do
      begin
           if Options_Box.CheckBox16.Checked then
          Item^.Name :=Pchar(Name);
        Item^.time := Time;
        Item^.Freq := SampleRate;
        Item^.BitRate := BitRate;
        Item^.InfoUpdt := False;
      end;
      end
      else
      begin
        with Sound_Engine.Get_CurentTegdata(true,Item^.Name) do
      begin
      if Name<>'- ' then
     if Options_Box.CheckBox16.Checked then
          Item^.Name :=Pchar(Name);
        Item^.time := Time;
        Item^.Freq := SampleRate;
        Item^.BitRate := BitRate;
        Item^.InfoUpdt := False;
      end;
      end;
    end;
  end;
    Rstr:='';
  if   ModuleHandle.CanCallAPI  then
  begin
        If Options_Box.CheckBox23.Checked and
 Options_Box.CheckBox25.Checked then
  Begin
  if Main_Window.VK_Status='<none>' then
  Main_Window.VK_Status:=VK_Methods.GetStatus(Widestring(Ansistring(ModuleHandle.GetCurUserID)));
VK_Methods.SetStatus('',Item);
  end;
    If (Item^.VKFlag) and Options_Box.CheckBox22.Checked and
Options_Box.CheckBox25.Checked then
  Begin
    Text:=TStringList.Create;
    Text.Text:=VK_Methods.getLyrics(Item^.lyrics_id);
    If Text.Count>0 then
    begin
    For i:=0 to Text.Count-1 do
    TextStr:=TextStr+' '+Text[i];
    Text.Free;
    Rstr:=Item^.Name+' ['+TextStr+']';
    end
    else
    Rstr:=Item^.Name;
    end;
    end;
  EndOpen := True;
  if OpOk then
  Synchronize(SetLastInfo);
end;

Procedure TOpenThread.UpdateLink;
Begin
Main_Window.Timer4.Enabled:=false;
if not ModuleHandle.CanCallAPI then
begin
if ModuleHandle.Log_In=0 then
begin
  List_Update.Show;
VK_Methods.UpdateAudioLinks(Main_Window.CurList);
  List_Update.Close;
  end;
  end
  else
  begin
  List_Update.Show;
VK_Methods.UpdateAudioLinks(Main_Window.CurList);
  List_Update.Close;
  end;
  Main_Window.Timer4.Enabled:=true;
end;

procedure TOpenThread.SetFirstInfo;
begin
Play_List.Main_PlayList.Repaint; {
Play_List.Enabled:=False;
Main_Window.Enabled:=False;
VK_Mus.Enabled:=False;          }
end;



procedure TOpenThread.SetLastInfo;
var
  bps: Integer;
begin
if not Terminated then
  begin
  if OpOk then
  begin
  EQ_BOX.UpduteEQ;
    bps := Sound_Engine.GetBitRate;
    if bps >= 1000 then
      Main_Window.Label5.Caption := FormatFloat('0.0', bps / 1000) + ' mbps'
    else
      Main_Window.Label5.Caption := Inttostr(bps) + ' kbps';
    Main_Window.Trlen := Sound_Engine.GetLength; {
    If Play_List.ImgPlayList1.AddNum then
    ImgRunstring1.Text:=Inttostr(Play_List.ImgPlayList1.PlayedIndex+1)+'.'+Item^.Name
    else }
    if  Rstr<>'' then
      Main_Window.ImgRunstring1.Text :=Rstr
else
    Main_Window.ImgRunstring1.Text := Item^.Name;
    Main_Window.Timer3.Enabled := True;
    Main_Window.ImgTrackBar1.Enabled := True;
    Main_Window.RunPlay := True;
    Main_Window.Status := Play;
    Main_Window.setPlButton(Main_Window.status);
    Main_Window.CoolTrayIcon1.IconIndex := 1;
    if startPos <> 0 then
    begin
      Main_Window.ImgTrackBar1.Position := StartPos;
      Main_Window.ImgTrackBar1MouseUp(nil, mbLeft, [ssLeft], 0, 0);
    end;
    if pause then
    begin
      if Main_Window.status = play then
        Main_Window.ImgButton1.Click(false);
    end
    else
      Sound_Engine.Play;
  end
  else
  begin
    Main_Window.DoStop;
    OpOk := False;
  end;
  end;
                      {
  VK_Mus.Enabled:=True;
  Play_List.Enabled:=True;
Main_Window.Enabled:=True;     }
  Main_Window.CurList.Repaint;
  Main_Window.Timer4.Enabled:=false;
end;

///////////////////TMain_Window//////////////////

//////Loading ExternFiles////////

Procedure TMain_Window.ShowWND(var Msg: TMessage);
begin
if CoolTrayIcon1.IconVisible=false then
exit;
CoolTrayIcon1Click(CoolTrayIcon1);
end;

Procedure TMain_Window.GetGlobalDat(var Msg: TWMCopyData);{   }
var
  Str:string;

 var
ind: Integer;
begin
Str:=MyUtils.NumsToStr(pansichar(Msg.CopyDataStruct^.lpData));
if CoolTrayIcon1.IconVisible=false then
Play_List.CdataList.Add(Str)
else
begin
  List_Update.Show;  { }
  With Play_List do
  begin
  ind := Main_PlayList.Count;
 if (FileGetAttr(Str) = fadirectory) or
    (extractFileext(Str) = '') then
    begin
      OpenFolder(Str+ '\' );
    end
    else
    begin
      application.ProcessMessages;
      Open_(Str, true);
    end;
  List_Update.Close;
    if Main_PlayList.Count>ind then
  begin
  if NewItemIndex = -1 then
    NewItemIndex := ind;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
if Options_Box.CheckBox1.Checked then
ImgPlayList1DblClick(self);
 end;
 end;
   end;
end;


procedure TMain_Window.WndProc(var Message: TMessage);

begin
  if (Message.Msg = CM_MOUSEENTER ) and (Options_Box.CheckBox7.Checked) then
  begin
    Timer1.Enabled := false;
  end;
  inherited;
end;

procedure TMain_Window.WMMoving(var Msg: TWMMoving);
var
  workArea: TRect;
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

procedure TMain_Window.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
  inherited;
_Close;
end;


function  TMain_Window.CallBackSkinLoad(s: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  with main_Window do
  begin
    Width := MainIMG.Width;
    Height := MainIMG.Height;
    BackBMP := MainIMG;
    SetMinMax(FrmMode);
    for i := 1 to 2 do
    begin
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).Main := MainIMG;
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).Over := Over;
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).SliderNR := SliderM;
      (FindComponent('ImgTrackBar' + Inttostr(i)) as TImgTrackBar).SliderDW := SliderO;
    end;
    ImgTrackBar2.SliderNR := VolM;
    ImgTrackBar2.SliderDW := VolO;
    for i := 2 to 10 do
    begin
      (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Main := MainIMG;
      (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Over := Over;
    end;
    ImgRunString1.Font := FontRs;
    Label1.Font := FontTm;
    Label3.Font := FontMtm;
    Label5.Font := FontBtr;
    Self.setPlButton(Status);
    Result := True;
  end;
end;

procedure TMain_Window.SetMinMax(mode: Integer);
var
  i, Ow: Integer;
begin
  if Mode = 1 then
  begin
    AlphaBlend := Options_Box.CheckBox8.Checked;
    IMGRunString1.Interval := Options_BOX.SpinEdit1.Value;
    Main_Window.AlphaBlendValue := alphaNorm;
    Main_Window.Width := MainIMG.Width;
    Main_Window.Height := MainIMG.Height;
    BackBMP := MainIMG;
    Main_Window.Left := OldPos;
  end
  else
  if Mode = 2 then
  begin
    IMGRunString1.Interval := Options_BOX.SpinEdit2.Value;
    Ow := Main_Window.Width;
    Main_Window.Width := mini.Width;
    Main_Window.Height := mini.Height;
    AlphaBlend := Options_BOX.CheckBox18.Checked;
    Main_Window.AlphaBlendValue := alphaMini;
    BackBMP := MINI;
    if (Main_Window.Left) > (Screen.WorkAreaWidth - (Main_Window.Left + ow)) then
      Main_Window.Left := Main_Window.Left + (ow - Main_Window.Width);
    
  end;

    for i := 1 to 10 do
    begin
      SetCompparams(FindComponent('ImgButton' + Inttostr(i)) as TimgButton,CurSkinHdr.MainFormParams[i],mode);
    end;
    SetCompparams(ImgTrackBar1,CurSkinHdr.MainFormParams[11],mode);
     SetCompparams(ImgTrackBar2,CurSkinHdr.MainFormParams[12],mode);
     SetCompparams(Label5,CurSkinHdr.MainFormParams[13],mode);
     SetCompparams(Label3,CurSkinHdr.MainFormParams[14],mode);
     SetCompparams(Label1,CurSkinHdr.MainFormParams[15],mode);
     SetCompparams(ImgRunString1,CurSkinHdr.MainFormParams[16],mode);
    ImgRunString1.Color:=BackBMP.Canvas.Pixels[ImgRunString1.Left,ImgRunString1.Top];
  {ImgRunString1.Main:=BackBMP; }
   TransparentColor := True;
   TransparentColorValue := BackBMP.Canvas.Pixels[0, 0];
  Canvas.Draw(0, 0, BackBMP);
  ImgButton1.Repaint;
  Self.Repaint;
  ImgRunString1.Repaint;
end;

procedure TMain_Window.FormCreate(Sender: TObject);
begin
  VK_Status:='<none>'; {}
  DoubleBuffered:=true;
  ImgRunString1.Run := True;
  Status := stop;
  FrmMode := 1;
  Application.Title := AppName;
  Caption := AppName;
  ImgRunString1.Text := AppName;
  Self.CoolTrayIcon1.Hint :=AppName;
  CtrlPress := false;
end;

procedure TMain_Window.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if frmmode = 2 then
    exit;
  GlobalMousePress := True;
  Screen.Cursor := crSizeall;
  ReleaseCapture;
  Main_Window.perform(WM_SysCommand, $f012, 0);
  Screen.Cursor := crDefault;
  OldPos := left;
  GlobalMousePress := False;
end;

procedure TMain_Window.ImgButton6Click(Sender: TObject);
begin
  case Options_Box.RadioGroup1.itemindex of
    0:
      begin
        DoStop;
        ShowWindow(Handle, SW_Hide);
        if ImgButton8.Checked then
          ShowWindow(EQ_BOX.Handle, SW_Hide);
        if ImgButton2.Checked then
          ShowWindow(Play_List.Handle, SW_Hide);
      end;
    1:
      begin
        ShowWindow(Handle, SW_Hide);
        if ImgButton8.Checked then
          ShowWindow(EQ_BOX.Handle, SW_Hide);
        if ImgButton2.Checked then
          ShowWindow(Play_List.Handle, SW_Hide);
      end;
    2: Close;
  end;
end;

procedure TMain_Window.FormPaint(Sender: TObject);
begin
Canvas.Draw(0, 0, BackBMP);
end;

procedure TMain_Window.Timer1Timer(Sender: TObject);
begin
  FrmMode := 2;
  setMinMax(FrmMode);
  timer1.Enabled := False;
end;

procedure TMain_Window.FormShow(Sender: TObject);
begin
{SendMessage(Application.MainForm.ClientHandle, WM_SETREDRAW, 0, 0);
}OldPos := Left;
CoolTrayIcon1.IconVisible:=true;

end;

procedure TMain_Window.ImgButton7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetStayTop(Handle, left, top, width, height,not imgButton7.Checked);
end;

procedure TMain_Window.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if( X > Label3.Left) and (FrmMode = 2) and (not MsInFrm) and (Options_Box.CheckBox7.Checked) and (not ImgButton9.Checked) then
  begin
    MsInFrm := True;
    FrmMode := 1;
    setMinMax(FrmMode);
  end;
end;

procedure TMain_Window.ImgButton5Click(Sender: TObject);
begin
  if ImgButton5.Checked then
  begin
    ImgButton5.Hint := 'Повторять один [вкл]';
  end
  else
  begin
    ImgButton5.Hint := 'Повторять один [выкл]';
  end;
end;

procedure TMain_Window.FormClose(Sender: TObject; var Action: TCloseAction);
begin
_Close;
end;

Procedure  TMain_Window._Close;
Begin
  SaveSettings;
  Play_List.Main_PlayList.IMPL_Save(MyUtils.SelfPath + 'CurList.impl',Play_List.Main_PlayList.ListHeader, IMPL);
   if VK_Lib.VL_GetCount>1 then
  VK_Lib.VL_Save2File(PlayListPath+'VK_Lib.Vlb');
    Play_List.DropFileTarget1.Unregister(Play_List);
    DropFileTarget1.Unregister(SELF);
  Timer3.Enabled:=false;
  Sound_Engine.Stop(true);
  if ModuleHandle.CanCallAPI and Options_Box.CheckBox23.Checked and Options_Box.CheckBox25.Checked then
  VK_Methods.SetStatus(VK_Status);
  end;

procedure TMain_Window.Label1Click(Sender: TObject);
begin
  if TimeCountDown then
  begin
    TimeCountDown := false;
    Label1.Hint := 'Прошло времени';
    Label3.Hint := 'Прошло времени';
  end
  else
  begin
    TimeCountDown := True;
    Label1.Hint := 'Осталось времени';
    Label3.Hint := 'Осталось времени';
  end;
end;

procedure TMain_Window.Timer2Timer(Sender: TObject);
var
  CurPos: TPoint;
begin{ }
  TrimWorkingSet; 
  if  ((not GlobalMousePress)  and (not ImgTrackBar1.DOWN) and (not ImgTrackBar2.DOWN) and (not IMGRunString1.DOWN ))and (not ImgButton9.Checked)   then
  begin
    Windows.GetCursorPos(CurPos);
    Windows.ScreenToClient(Self.Handle, CurPos);
    if not PtInRect(Self.ClientRect, CurPos) then
    begin
      MsInFrm := False;
      if (FrmMode = 1) then
      begin
        Timer1.Enabled := True;
      end;
    end;
  end;
end;

procedure TMain_Window.ImgButton7Click(Sender: TObject);
begin
  if ImgButton7.Checked then
    ImgButton7.Hint := 'Поверх  всех [вкл]'
  else
    ImgButton7.Hint := 'Поверх всех [выкл]';
end;

procedure TMain_Window.ImgTrackBar2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if  ImgTrackBar2.DOWN then
    Sound_Engine.SetVolume(ImgTrackBar2.Position, Options_Box.CheckBox3.Checked);
  
end;

procedure TMain_Window.CoolTrayIcon1Click(Sender: TObject);
begin
  SetForeGroundWindow(Handle);
  ShowWindow(Handle, SW_Show);
  if ImgButton8.Checked then
    ShowWindow(EQ_BOX.Handle, SW_Show);
  if ImgButton2.Checked then
    ShowWindow(Play_List.Handle, SW_Show);
end;

procedure TMain_Window.N12Click(Sender: TObject);
begin
  Close;
end;


/////////////////Functions & procedures For Player//////////////////////

procedure TMain_Window.DoStop;
begin
  Status := stop;
  setPlButton(status);
  ImgRunString1.Text := AppName;
  label5.Caption := 'n/a kbps';
  label3.Caption := '[00:00 / 00:00]';
  label1.Caption := '[00:00]';
  Timer3.Enabled := false;
  ImgTrackBar1.Enabled := False;
  ImgTrackBar1.Position := 0;
  ImgTrackBar1.Progress_ := 0;
  Sound_Engine.Stop(False);
  RunPlay := False;
  Wait := false;
end;

procedure TMain_Window.Open2Play(Item: PtrackData; startpos: integer; pause: boolean);
begin
      If not Assigned(item) then
    exit;
  if assigned(openThread) then
  begin
{  if not  openThread.EndOpen then
While not openThread.EndOpen do
Begin
Sleep(1);
application.ProcessMessages;
end;
   }
    openThread.Free;
    openThread := nil;
  end;
  DoStop;
  ImgRunstring1.Text := 'Загрузка...';
  openThread := TOpenThread.Create(True);
  openThread.Priority := tpNormal;
  openThread.Item := Item;
  openThread.pause := Pause;
  openThread.Startpos := startpos;
  openThread.Resume;
  Timer4.Enabled:=true;
  /////
end;

procedure TMain_Window.Timer3Timer(Sender: TObject);
var
  FormatSTR: String;
begin
  if Trlen < 3600 then
    FormatSTR := 'nn:ss'
  else
    FormatSTR := 'hnn:ss';
  if not TimeCountDown then
    Label1.Caption := '[' + FormatDateTime(FormatSTR, GetPosition / (24 * 60 * 60)) + ']'
  else
    Label1.Caption := '[' + FormatDateTime(FormatSTR, (TrLen - GetPosition) / (24 * 60 * 60)) + ']';
  Label3.Caption := '[' + FormatDateTime(FormatSTR, TrLen / (24 * 60 * 60)) +
  '/ ' + Copy(Label1.Caption, 2, Length(Label1.Caption) - 1);
  if TrLen > 0 then
  begin
  if ImgTrackbar1.Progress_ <100 then
    ImgTrackbar1.Progress_ := Round((Getdlpos * 100) / GetdlLength);
    if (ImgTrackbar1.Position > ImgTrackbar1.Progress_) and (ImgTrackbar1.Position > 1) then
    begin
      Wait := true;
      TrPos := ImgTrackbar1.Position;
      Sound_Engine.pause(True);
      exit;
    end
    else
    if (ImgTrackbar1.Progress_ > ImgTrackbar1.Position) and
    Wait and (status = play) then
    begin
      Sound_Engine.pause(False);
      SetPosition(Round((ImgTrackBar1.Position * TrLen) / 100));
      Wait := false;
      exit;
    end;
    TrPos := Round((GetPosition * 100) / TrLen);
    if not Wait then
    if TrPos<> ImgTrackbar1.Position then
      ImgTrackbar1.Position := TrPos;
  end;
  if Sound_Engine.IsPlayend then
  begin
    
    dostop;
    if CurList.Count <=0 then
    exit;
    if ImgButton5.Checked then
      Open2Play(CurList.DataItems[CurList.PlayedIndex])
    else
    if not Play_List.ImgButton6.Checked then
    begin
      if Play_List.ImgButton4.Checked then
        ImgButton3.OnClick(ImgButton3)
      else
        ImgButton3.OnClick(nil);
    end
      else
    begin
      if Options_Box.CheckBox15.Checked then
        CurList.PlayedIndex := CurList.RandomIncBest(CurList.count - 1, 10)
      else
        CurList.PlayedIndex := Random(CurList.count - 1);
      Open2Play(CurList.DataItems[CurList.PlayedIndex])
    end;
    CurList.ItemIndex :=CurList.PlayedIndex;
    Play_List.ImgPlayList1Click(nil);
  end;
end;

procedure TMain_Window.ImgTrackBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Timer3.Enabled := False;
end;

procedure TMain_Window.ImgTrackBar1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetPosition(Round((ImgTrackBar1.Position * TrLen) / 100));
  Timer3.Enabled := True;
end;

procedure TMain_Window.setPlButton(st: TplayerStatus);
begin
  if (st = pause) or (st = stop) then
  begin
    ImgButton1.ExternalButton := Play_B;
    ImgButton1.Hint := 'Начать воспроизведение';
    if st = pause then
      CoolTrayIcon1.IconIndex := 2
    else
      CoolTrayIcon1.IconIndex := 0;
  end
  else
  begin
    ImgButton1.ExternalButton := Pause_B;
    ImgButton1.Hint := 'Приостановить воспроизведение';
    CoolTrayIcon1.IconIndex := 1;
  end;
end;


procedure TMain_Window.ImgButton1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if NoPause then
    exit;
  if (status = stop) and (CurList.Count < 1)  then
  begin
    Play_List.N2Click(nil);
    Play_List.ImgPlayList1DblClick(self);
    exit;
  end;
  
  if status = play then
  begin
  try
    Sound_Engine.pause(True);
    status := pause;
  finally

  end;
  end
  else
  if status = pause then
  begin
  try
    Sound_Engine.pause(False);
    status := Play;
  finally

  end;
  end;
  self.setPlButton(status);
end;

procedure TMain_Window.ImgButton3Click(Sender: TObject);
begin
  if CurList.PlayedIndex + 1 > CurList.Count - 1 then
  begin
    if (Sender = nil) then
      exit
    else
      CurList.PlayedIndex := 0;
  end
  else
 CurList.PlayedIndex := CurList.PlayedIndex + 1;
  if CurList.Count > 0 then
  begin
    Open2Play(CurList.DataItems[CurList.PlayedIndex]);
    CurList.ItemIndex := CurList.PlayedIndex;
    Play_List.ImgPlayList1Click(nil);
  end;
  {}
end;

procedure TMain_Window.ImgButton4Click(Sender: TObject);
begin
  if CurList.PlayedIndex - 1 < 0 then
  begin
    if (Sender = nil) then
      exit
    else
      CurList.PlayedIndex  := CurList.Count - 1;
  end
  else
   CurList.PlayedIndex  := CurList.PlayedIndex  - 1;
  if CurList.Count > 0 then
  begin
    Open2Play(CurList.DataItems[CurList.PlayedIndex]);
    CurList.ItemIndex :=CurList.PlayedIndex;
    Play_List.ImgPlayList1Click(nil);
  end;
end;

procedure TMain_Window.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (key <> 17) then
    CtrlPress := true;
  
  case key of
    37:
      begin
        key := 0;
        if CtrlPress then
        begin
          ImgTrackBar1MouseDown(nil, mbLeft, shift, 0, 0);
          ImgTrackBar1.Position := ImgTrackBar1.Position - 1;
          ImgTrackBar1MouseUP(nil, mbLeft, shift, 0, 0);
        end
        else
          ImgButton4.Click(false);
      end;
    39:
      begin
        key := 0;
        if CtrlPress then
        begin
          ImgTrackBar1MouseDown(nil, mbLeft, shift, 0, 0);
          ImgTrackBar1.Position := ImgTrackBar1.Position + 1;
          ImgTrackBar1MouseUP(nil, mbLeft, shift, 0, 0);
        end
        else
          ImgButton3.Click(false);
      end;
    32:
      begin
        key := 0;
        if not (status = stop) then
          ImgButton1.Click(false);
      end;
    38:
      begin
        if CtrlPress then
        begin
           key := 0;
          ImgTrackBar2.Position := ImgTrackBar2.Position + 1;
          SetVolume(ImgTrackBar2.Position - 1, Options_Box.CheckBox3.Checked);
        end;
      end;
    40:
      begin
        if CtrlPress then
        begin
           key := 0;
          ImgTrackBar2.Position := ImgTrackBar2.Position - 1;
          SetVolume(ImgTrackBar2.Position - 1, Options_Box.CheckBox3.Checked);
        end;
      end;
    13:
      begin
              key := 0;
        if (sender = CurList) then
        begin
          Play_List.ImgPlayList1DblClick(self);
          exit;
        end;
        if status = stop then
        begin
          self.setPlButton(status);
          Self.ImgButton1.Click(false);
        end;
      end;
    46:
      begin
               key := 0;
        if (sender = CurList) then
          Play_List.N4Click(nil);
      end;
  end;                     {
  ShowMessage(inttostr(key)); }

end;

procedure TMain_Window.ImgButton1Click(Sender: TObject);
begin
  if (CurList.Count - 1) < CurList.PlayedIndex then
    CurList.PlayedIndex := 0;
  if (status = stop) and (CurList.Count > 0)  then
  begin
    if CurList.PlayedIndex = -1 then
      CurList.PlayedIndex := 0;
    CurList.ItemIndex := CurList.PlayedIndex;
    Play_List.ImgPlayList1DblClick(self);
    NoPause := True;
  end
  else
    NoPause := False;
end;

procedure TMain_Window.ImgButton2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if  ImgButton2.Checked then
  begin
    ImgButton2.Hint := 'Показать список';
    Play_List.Close;
  end
  else
  begin
    ImgButton2.Hint := 'Скрыть список';
    Play_List.Show;
  end;
end;

procedure TMain_Window.ImgButton8MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if  ImgButton8.Checked then
  begin
    ImgButton8.Hint := 'Показать эквалайзер';
    EQ_BOX.Close;
  end
  else
  begin
    ImgButton8.Hint := 'Скрыть эквалайзер';
    EQ_BOX.Show;
  end;
end;

procedure TMain_Window.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 17 then
    exit;
  CtrlPress := false;
end;

procedure TMain_Window.ImgButton9Click(Sender: TObject);
begin
  if ImgButton9.Checked then
    ImgButton9.Hint := 'Закрепить состояние [вкл]'
  else
    ImgButton9.Hint := 'Закрепить состояние [выкл]';
end;

procedure TMain_Window.ImgButton10Click(Sender: TObject);
begin
DoStop;
end;

procedure TMain_Window.Timer4Timer(Sender: TObject);
begin
openThread.SetLastInfo;
Windows.TerminateThread(openThread.Handle,0);
openThread.Free;
openThread:=nil;
end;



procedure TMain_Window.N4Click(Sender: TObject);
begin
  main_Window.ImgButton2.Click(false);
end;

procedure TMain_Window.N13Click(Sender: TObject);
begin
  main_Window.ImgButton8.Click(false);
end;

procedure TMain_Window.N1Click(Sender: TObject);
begin
About_DLG.Show;
end;

Procedure TMain_Window.breakPlay;
begin
BR_Position:=ImgTrackBar1.Position;
BR_Curitem:=CurList.PlayedIndex;
if Status=play then
BR_Pause:=false
else
BR_Pause:=true;
Dostop;
Sound_Engine.Stop(True);
end;

Procedure TMain_Window.resumPlay;
begin
Open2Play(CurList.DataItems[BR_Curitem],BR_Position,BR_Pause);

end;
end.
