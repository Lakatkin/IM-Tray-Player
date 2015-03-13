program VK_Player_Demo;

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  dialogs,
  Main in 'Main.pas' {Main_Window},
  MyUtils in 'MyUtils.pas',
  SkinEngine in 'SkinEngine.pas',
  PlayList in 'PlayList.pas' {Play_List},
  EQ in 'EQ.pas' {EQ_BOX},
  ConfigManger in 'ConfigManger.pas',
  NetOpen in 'NetOpen.pas' {Net_OpenDLG},
  ListUpdateFRM in 'ListUpdateFRM.pas' {List_Update},
  OptionsBox in 'OptionsBox.pas' {Options_BOX},
  ListTag in 'ListTag.pas' {List_TEG},
  SkinList in 'SkinList.pas' {Skin_List},
  TagReader in 'TagReader.pas',
  List_OpenMode in 'List_OpenMode.pas' {List_Open},
  VK_audio in 'VK_audio.pas' {VK_MUS},
  AudioGroup_DL in 'AudioGroup_DL.pas' {DL_AudioGroup},
  DL_adapt in 'DL_adapt.pas',
  About in 'About.pas' {About_DLG},
  TAG_BOX in 'TAG_BOX.pas' {Audio_Info};

{$R *.res}

var
 i:integer;
 s:ansiString;
  cd: TCopyDataStruct;
  isWait:Boolean;

Procedure Timer_;
  Begin
  if isWait then
Windows.TerminateProcess(Windows.GetCurrentProcess,0)
  else
  KillTimer(Application.Handle, 1);
  end;

  function Init_Mutex(mid: string): boolean;
  var
    mut: thandle;
begin
  mut := CreateMutex(nil, false, pchar(mid));
  result := not((mut = 0) or (GetLastError = ERROR_ALREADY_EXISTS));
end;

begin
SetTimer(Application.Handle, 1, 2000, @Timer_);
if not Init_Mutex('hgkjbfjknbg894') then
begin      {      }
if (ParamCount>0) then
Begin
While FindWindow('TMain_Window',nil)=0 do
begin
Application.ProcessMessages;
isWait:=True;
end;
isWait:=false;
for i:= 1 to paramcount do
Begin
     ZeroMemory(@CD, SizeOf(TCopyDataStruct));
 s:=MyUtils.StrToNums(Paramstr(i));
cd.cbData := Length(s)+1;
cd.lpData := PansiChar(s);
SendMessage(FindWindow('TMain_Window',nil), WM_COPYDATA, 0, Integer(@cd));
end;
end;
SendMessage(FindWindow('TMain_Window',nil),WM_WNDUPDATE, 0,0);
Windows.TerminateProcess(Windows.GetCurrentProcess,0);
end
else
begin
Application.Initialize;
  Application.CreateForm(TMain_Window, Main_Window);
  Application.CreateForm(TPlay_List, Play_List);
  Application.CreateForm(TVK_MUS, VK_MUS);
  Application.CreateForm(TEQ_BOX, EQ_BOX);
  Application.CreateForm(TNet_OpenDLG, Net_OpenDLG);
  Application.CreateForm(TList_Update, List_Update);
  Application.CreateForm(TList_TEG, List_TEG);
  Application.CreateForm(TSkin_List, Skin_List);
  Application.CreateForm(TList_Open, List_Open);
  Application.CreateForm(TOptions_BOX, Options_BOX);
  Application.CreateForm(TAbout_DLG, About_DLG);
  Application.CreateForm(TAudio_Info, Audio_Info);
  Application.Run;
  end;
end.
