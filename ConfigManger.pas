unit ConfigManger;

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
  Dialogs, StdCtrls, ExtCtrls, MyUtils, skinengine, IniFiles, ImgTrackBar,
  Sound_Engine;
{Function For Options & settings}
Procedure GetSkin;
procedure LoadSettings;
procedure SaveSettings;
procedure LoadPlaing;
procedure LoadConfig;
procedure SaveConfig;
Procedure Init_vk;
Procedure ResetConfig;


{Function For EQ Params save & load}
procedure LoadEQSettings(name: String);
procedure SaveEQSettings(name: String);

var
dlPath:String;
CurStin:String;

implementation

uses
  Main, PlayList, EQ, OptionsBox,SkinList;

var
  ConfigDat: TiniFile;

procedure LoadConfig;
var
  B: Boolean;
  S: String;
  i: Integer;
begin
  ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
  
  Options_Box.CheckBox7.Checked := ConfigDat.ReadBool('Options', 'AutoMin', True);
  Options_Box.CheckBox7Click(nil);
  Options_Box.SpinEdit1.Value := ConfigDat.ReadInteger('Options', 'RunstrSpeed1', 28);
  Options_Box.SpinEdit1Change(nil);
  Options_Box.SpinEdit2.Value := ConfigDat.ReadInteger('Options', 'RunstrSpeed2', 24);
  Options_Box.SpinEdit2Change(nil);
  Options_Box.CheckBox8.Checked := ConfigDat.ReadBool('Options', 'UseTranspMain1', true);
  Options_Box.CheckBox8Click(nil);
  Options_Box.SpinEdit3.Value := ConfigDat.ReadInteger('Options', 'TranspValMain1', 75);
  Options_Box.SpinEdit3Change(nil);
  Options_Box.CheckBox18.Checked := ConfigDat.ReadBool('Options', 'UseTranspMain2', true);
  Options_Box.CheckBox18Click(nil);
  Options_Box.SpinEdit6.Value := ConfigDat.ReadInteger('Options', 'TranspValMain2', 65);
  Options_Box.SpinEdit6Change(nil);
  Options_Box.CheckBox9.Checked := ConfigDat.ReadBool('Options', 'NoLeaveDeskEQ', true);
  Options_Box.CheckBox10.Checked := ConfigDat.ReadBool('Options', 'UseTranspEQ', true);
  Options_Box.CheckBox10Click(nil);
  Options_Box.SpinEdit7.Value := ConfigDat.ReadInteger('Options', 'TranspvalEQ', 84);
  Options_Box.SpinEdit7Change(nil);
  Options_Box.CheckBox13.Checked := ConfigDat.ReadBool('Options', 'NoLeaveDeskPl', true);
  Options_Box.CheckBox14.Checked := ConfigDat.ReadBool('Options', 'UseTranspPl', true);
  Options_Box.CheckBox14Click(nil);
  Options_Box.SpinEdit4.Value := ConfigDat.ReadInteger('Options', 'TranspvalPl', 92);
  Options_Box.SpinEdit4Change(nil);
  Options_Box.CheckBox12.Checked := ConfigDat.ReadBool('Options', 'UseTranspHint', true);
  Options_Box.SpinEdit5.Value := ConfigDat.ReadInteger('Options', 'TranspvalHint', 60);
  Options_Box.CheckBox11.Checked := ConfigDat.ReadBool('Options', 'UseSkinHint', true);
  Options_Box.CheckBox11Click(nil);
  Options_Box.ComboBox1.ItemIndex := ConfigDat.ReadInteger('Options', 'DevUse', 0);
  Options_Box.ComboBox1Change(nil);
  Options_Box.SpinEdit8.Value := ConfigDat.ReadInteger('Options', 'BufferSize', 2000);
  Options_Box.SpinEdit8Change(nil);
  Options_Box.SpinEdit9.Value := ConfigDat.ReadInteger('Options', 'MinimizeTime', 1500);
  Options_Box.SpinEdit9Change(nil);
  Options_Box.CheckBox3.Checked := ConfigDat.ReadBool('Options', 'CangeSysVol', False);
  Options_Box.CheckBox3Click(nil);
  Options_Box.CheckBox4.Checked := ConfigDat.ReadBool('Options', 'Autorun', False);
  Options_Box.CheckBox4Click(nil);
  Options_Box.RadioGroup1.itemindex := ConfigDat.ReadInteger('Options', 'CloseMode', 0);
  b := ConfigDat.ReadBool('Options', 'top2down', true);
  if b then
    Options_Box.RadioButton1.Checked := True
  else
    Options_Box.RadioButton2.Checked := True;
  Options_Box.RadioButton1Click(nil);
  Options_Box.RadioGroup2.itemindex := ConfigDat.ReadInteger('Options', 'FileAddMode', 1);
  Options_Box.RadioGroup3.itemindex := ConfigDat.ReadInteger('Options', 'PlayListAddMode', 1);
  Options_Box.CheckBox20.Checked := ConfigDat.ReadBool('Options', 'AddNum', True);
  Options_Box.CheckBox20Click(nil);
  Options_Box.CheckBox5.Checked := ConfigDat.ReadBool('Options', 'RunPlay', True);
  Options_Box.CheckBox21.Checked := ConfigDat.ReadBool('Options', 'ShowItemHint', True);
  Options_Box.CheckBox15.Checked := ConfigDat.readBool('Options', 'RandIncBest', True);
  Options_Box.CheckBox16.Checked := ConfigDat.readBool('Options', 'ReadFromTeg', True);
  Options_Box.CheckBox17.Checked := ConfigDat.readBool('Options', 'CueReadFromTeg', False);
  Options_Box.CheckBox19.Checked := ConfigDat.readBool('Options', 'VKReadFromTeg', False);
  Options_Box.CheckBox1.Checked := ConfigDat.readBool('Options', 'OpenFromParams', True);
  //Options_Box.CheckBox2.Checked := ConfigDat.readBool('Options', 'CheckExt', True);
  Options_Box.CheckBox23.Checked := ConfigDat.ReadBool('Options', 'TranslateName', False);
  Options_Box.CheckBox22.Checked := ConfigDat.ReadBool('Options', 'OutText', False);
  Options_Box.CheckBox24.Checked := ConfigDat.ReadBool('Options', 'DefVkLoad', False);
  dlPath:=ConfigDat.ReadString('Options','DlPath',DlDefPath)+'\';
    if not directoryexists(dlPath) then
  dlPath:= DlDefPath+'\';
  Options_Box.Edit4.Text:=dlPath;
  ConfigDat.Free;
end;


procedure LoadSettings;
var
  B: Boolean;
  i: Integer;
begin
  ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
  {PlayList Form params}
  i := Configdat.ReadInteger('PlayList', 'Width', ListM.Width);
  if i < ListM.Width then
    i := ListM.Width;
  Play_List.Width := i;
  i := Configdat.ReadInteger('PlayList', 'Height', ListM.Height);
  if i < ListM.Height then
    i := ListM.Height;
  Play_List.Height := i;
  Play_List.imgFormResizer1ResizeEnd(nil);
  i := Configdat.ReadInteger('PlayList', 'pos_x', Screen.WorkAreaWidth - Play_List.Width);
  if i > (Screen.WorkAreaWidth - Play_List.Width) then
    i := Screen.WorkAreaWidth - Play_List.Width;
  Play_List.Left := i;
  i := Configdat.ReadInteger('PlayList', 'pos_y', Screen.WorkAreaHeight - Main_Window.Height - Play_List.Height);
  if i > (Screen.WorkAreaHeight - Play_List.Height) then
    i := Screen.WorkAreaHeight - Play_List.Height;
  Play_List.Top := i;
  Play_List.Main_PlayList.ItemIndex := Configdat.ReadInteger('PlayList', 'Playind', 0);
  Play_List.Main_PlayList.PlayedIndex := Play_List.Main_PlayList.ItemIndex;
  Play_List.ImgPlayList1Click(nil);
  b := Configdat.readBool('PlayList', 'repeatAll', false);
  if b then
    Play_List.ImgButton4.Click(false);
  b := Configdat.readBool('PlayList', 'random', false);
  if b then
    Play_List.ImgButton6.Click(false);
  
  {Eq Form params}
  i := Configdat.ReadInteger('EQ', 'pos_x', Screen.WorkAreaWidth - EQ_Box.Width);
  if i > (Screen.WorkAreaWidth - EQ_Box.Width) then
    i := Screen.WorkAreaWidth - EQ_Box.Width;
  EQ_BOX.Left := i;
  i := Configdat.ReadInteger('EQ', 'pos_y', Screen.WorkAreaHeight - Main_Window.Height - EQ_Box.Height - Play_List.Height);
  if i > (Screen.WorkAreaHeight - EQ_Box.Height) then
    i := Screen.WorkAreaHeight - Play_List.Height;
  EQ_Box.Top := i;
  b := Configdat.readBool('EQ', 'EqStart', False);
  if b then
    EQ_Box.ImgButton2.Click(false);
  
  {Main Form params}
  i := Configdat.ReadInteger('Main', 'pos_x', Screen.WorkAreaWidth - Main_Window.Width);
  if i > (Screen.WorkAreaWidth - Main_Window.Width) then
    i := Screen.WorkAreaWidth - Main_Window.Width;
  Main_Window.Left := i;
  i := Configdat.ReadInteger('Main', 'pos_y', Screen.WorkAreaHeight - Main_Window.Height);
  if i > (Screen.WorkAreaHeight - Main_Window.Height) then
    i := Screen.WorkAreaHeight - Main_Window.Height;
  Main_Window.Top := i;
  Main_Window.ImgTrackBar2.Position := Configdat.ReadInteger('Main', 'volume', 50);
  b := Configdat.readBool('Main', 'repeatOne', false);
  if b then
    Main_Window.ImgButton5.Click(false);
  b := Configdat.readBool('Main', 'OpenPl', false);
  if b then
    Main_Window.ImgButton2.Click(false);
  b := Configdat.readBool('Main', 'OpenEQ', false);
  if b then
    Main_Window.ImgButton8.Click(false);
  b := Configdat.readBool('Main', 'StayOnTop', False);
  if b then
    Main_Window.ImgButton7.Click(false);
  Main_Window.TimeCountDown := Configdat.readBool('Main', 'CountDown', False);
  ConfigDat.Free;
  LoadEQSettings(SelfPath + GetFileName(paramstr(0)) + '.ini');
end;


procedure LoadPlaing;
var
  b: boolean;
begin
  ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
  Main_Window.RunPlay := Configdat.ReadBool('Main', 'setplay', True);
  if Main_Window.RunPlay then
    Main_Window.TrPos := Configdat.ReadInteger('Main', 'playpos', 0);
  if Main_Window.RunPlay and Options_Box.CheckBox5.Checked then
  begin
    Play_List.ImgPlayList1DblClick(nil);
    b := Configdat.readBool('Main', 'Pause', false);
    if (Play_List.Main_PlayList.PlayedIndex<Play_List.Main_PlayList.Count) and  (Play_List.Main_PlayList.PlayedIndex>-1) then
    Main_Window.Open2Play(Play_List.Main_PlayList.DataItems[Play_List.Main_PlayList.PlayedIndex], Main_Window.TrPos, b);
  end;
  ConfigDat.Free;
end;

Procedure GetSkin;
Begin
 ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
CurStin:=ConfigDat.ReadString('Main','Skin','');
Skin_List.UpdataSkinList;
Options_Box.CheckBox1.Checked := ConfigDat.readBool('Options', 'OpenFromParams', True);
Options_Box.CheckBox2.Checked := ConfigDat.readBool('Options', 'CheckExt', True);
ConfigDat.Free;
end;

Procedure Init_vk;
var
  b: boolean;
begin
  ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
  Options_Box.CheckBox25.Checked := ConfigDat.ReadBool('Options', 'VKLogin', True);
  Options_Box.CheckBox25Click(nil);
  if   Options_Box.CheckBox25.Checked  then
  Options_Box.Button6Click(nil);
    Options_Box.CheckBox23.Checked := ConfigDat.ReadBool('Options', 'TranslateName', False);
    Options_Box.CheckBox22.Checked := ConfigDat.ReadBool('Options', 'OutText', False);
    Options_Box.CheckBox24.Checked := ConfigDat.ReadBool('Options', 'DefVkLoad', False);
   ConfigDat.Free;
end;



procedure SaveSettings;
var
  B: Boolean;
  i: Integer;
begin
  ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
  {Main Form params}
  try
    Configdat.WriteInteger('Main', 'pos_x', Main_Window.Left);
  except
    exit; 
  end;
  Configdat.WriteInteger('Main', 'pos_y', Main_Window.Top);
  Configdat.WriteInteger('Main', 'volume', Main_Window.ImgTrackBar2.Position);
  Configdat.WriteBool('Main', 'setplay', Main_Window.RunPlay);
  Configdat.WriteInteger('Main', 'playpos', Main_Window.TrPos);
  Configdat.WriteBool('Main', 'repeatOne', Main_Window.ImgButton5.Checked);
  Configdat.WriteBool('Main', 'OpenPl', Main_Window.ImgButton2.Checked);
  Configdat.WriteBool('Main', 'OpenEQ', Main_Window.ImgButton8.Checked);
  Configdat.WriteBool('Main', 'StayOnTop', Main_Window.ImgButton7.Checked);
  Configdat.WriteBool('Main', 'CountDown', Main_Window.TimeCountDown);
  if Main_Window.status = pause then
    b := true
  else
    b := false;
  Configdat.WriteBool('Main', 'Pause', b);
  {PlayList Form params}
  Configdat.WriteInteger('PlayList', 'Width', play_List.Width);
  Configdat.WriteInteger('PlayList', 'Height', play_List.Height);
  Configdat.WriteInteger('PlayList', 'pos_x', Play_List.Left);
  Configdat.WriteInteger('PlayList', 'pos_y', Play_List.Top);
  Configdat.WriteInteger('PlayList', 'Playind', Play_List.Main_PlayList.PlayedIndex);
  Configdat.WriteBool('PlayList', 'repeatAll', Play_List.ImgButton4.Checked);
  Configdat.WriteBool('PlayList', 'random', Play_List.ImgButton6.Checked);
  {Eq Form params}
  Configdat.WriteInteger('EQ', 'pos_x', EQ_BOX.Left);
  Configdat.WriteInteger('EQ', 'pos_y', EQ_Box.Top);
  Configdat.WriteBool('EQ', 'EqStart', EQ_Box.ImgButton2.Checked);
  ConfigDat.WriteString('Main','Skin',CurStin);
  ConfigDat.WriteBool('Options', 'CheckExt',Options_Box.CheckBox2.Checked);
  ConfigDat.Free;
  SaveEQSettings(SelfPath + GetFileName(paramstr(0)) + '.ini');
end;

procedure SaveConfig;
var
  B: Boolean;
  i: Integer;
begin
  ConfigDat := TiniFile.Create(SelfPath + GetFileName(paramstr(0)) + '.ini');
  {Main Form params}
  try
    Configdat.WriteBool('Options', 'AutoMin', Options_Box.CheckBox7.Checked);
  except
    exit; 
  end;
  ConfigDat.WriteInteger('Options', 'RunstrSpeed1', Options_Box.SpinEdit1.Value);
  ConfigDat.WriteInteger('Options', 'RunstrSpeed2', Options_Box.SpinEdit2.Value);
  ConfigDat.WriteBool('Options', 'UseTranspMain1', Options_Box.CheckBox8.Checked);
  ConfigDat.WriteInteger('Options', 'TranspValMain1', Options_Box.SpinEdit3.Value);
  ConfigDat.WriteBool('Options', 'UseTranspMain2', Options_Box.CheckBox18.Checked);
  ConfigDat.WriteInteger('Options', 'TranspValMain2', Options_Box.SpinEdit6.Value);
  ConfigDat.WriteBool('Options', 'NoLeaveDeskEQ', Options_Box.CheckBox9.Checked);
  ConfigDat.WriteBool('Options', 'UseTranspEQ', Options_Box.CheckBox10.Checked);
  ConfigDat.WriteInteger('Options', 'TranspvalEQ', Options_Box.SpinEdit7.Value);
  ConfigDat.WriteBool('Options', 'NoLeaveDeskPl', Options_Box.CheckBox13.Checked);
  ConfigDat.WriteBool('Options', 'UseTranspPl', Options_Box.CheckBox14.Checked);
  ConfigDat.WriteInteger('Options', 'TranspvalPl', Options_Box.SpinEdit4.Value);
  ConfigDat.WriteBool('Options', 'UseTranspHint', Options_Box.CheckBox12.Checked);
  ConfigDat.WriteInteger('Options', 'TranspvalHint', Options_Box.SpinEdit5.Value);
  ConfigDat.WriteBool('Options', 'UseSkinHint', Options_Box.CheckBox11.Checked);
  ConfigDat.WriteInteger('Options', 'DevUse', Options_Box.ComboBox1.ItemIndex);
  ConfigDat.WriteInteger('Options', 'BufferSize', Options_Box.SpinEdit8.Value);
  ConfigDat.WriteInteger('Options', 'MinimizeTime', Options_Box.SpinEdit9.Value);
  ConfigDat.WriteBool('Options', 'Autorun', Options_Box.CheckBox4.Checked);
  ConfigDat.WriteBool('Options', 'CangeSysVol', Options_Box.CheckBox3.Checked);
  ConfigDat.WriteInteger('Options', 'CloseMode', Options_Box.RadioGroup1.itemindex);
  ConfigDat.WriteBool('Options', 'top2down', Options_Box.RadioButton1.Checked);
  ConfigDat.WriteInteger('Options', 'FileAddMode', Options_Box.RadioGroup2.itemindex);
  ConfigDat.WriteInteger('Options', 'PlayListAddMode', Options_Box.RadioGroup3.itemindex);
  ConfigDat.WriteBool('Options', 'AddNum', Options_Box.CheckBox20.Checked);
  ConfigDat.WriteBool('Options', 'RunPlay', Options_Box.CheckBox5.Checked);
  ConfigDat.WriteBool('Options', 'ShowItemHint', Options_Box.CheckBox21.Checked);
  ConfigDat.WriteBool('Options', 'RandIncBest', Options_Box.CheckBox15.Checked);
  ConfigDat.WriteBool('Options', 'VKLogin',Options_Box.CheckBox25.Checked);
  ConfigDat.WriteBool('Options', 'TranslateName',Options_Box.CheckBox23.Checked);
  ConfigDat.WriteBool('Options', 'OutText',Options_Box.CheckBox22.Checked);
  ConfigDat.WriteBool('Options', 'DefVkLoad', Options_Box.CheckBox24.Checked );
  ConfigDat.WriteBool('Options', 'ReadFromTeg', Options_Box.CheckBox16.Checked);
  ConfigDat.WriteBool('Options', 'CueReadFromTeg',Options_Box.CheckBox17.Checked);
  ConfigDat.WriteBool('Options', 'VKReadFromTeg',Options_Box.CheckBox19.Checked);
  ConfigDat.WriteBool('Options', 'OpenFromParams', Options_Box.CheckBox1.Checked);
  ConfigDat.Free;
end;


procedure LoadEQSettings(name: String);
var
  i: Integer;
  Sender: TObject;
begin
  ConfigDat := TiniFile.Create(name);
  for i := 1 to 10 do
  begin
    Sender := EQ_BOX.FindComponent('ImgTrackBar' + Inttostr(i));
    (Sender as TImgTrackBar).position := ConfigDat.ReadInteger('Eq_Pos', inttostr(i), 15);
    SetEQval((Sender as TImgTrackBar).Tag, ((Sender as TImgTrackBar).Max - (Sender as TImgTrackBar).Position));
  end;
  ConfigDat.Free;
end;

procedure SaveEQSettings(name: String);
var
  i: Integer;
  Sender: TObject;
begin
  ConfigDat := TiniFile.Create(name);
  for i := 1 to 10 do
  begin
    Sender := EQ_BOX.FindComponent('ImgTrackBar' + Inttostr(i));
    ConfigDat.WriteInteger('Eq_Pos', inttostr(i), (Sender as TImgTrackBar).Position);
  end;
  ConfigDat.Free;
end;

Procedure ResetConfig;
begin
deleteFile(SelfPath + GetFileName(paramstr(0)) + '.ini');
LoadConfig;
SaveConfig;
SaveSettings;

end;

end.