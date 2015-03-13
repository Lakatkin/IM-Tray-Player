unit TagReader;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, MyUtils,
  dialogs, Sound_Engine,ImgPlayList,Forms, bass_EX_tag, TAG_BOX;


function Get_Tag2List(File_: String;CurFile:boolean): Sound_Engine.TBaseInfo;
Procedure ShowTagDLG(Data:PtrackData);
Function ShowTagDLGFromFile(fl:string):HWND;

implementation

uses VKtag_BOX,CUE_BOX;
var
Whandle:HWND;

function Get_Tag2List(File_: String;CurFile:boolean): TBaseInfo;
var
fn: string;
  idTag: TBassTag;
begin
Fn:=MyUtils.GetFileName(File_);
 idTag:= TBassTag.Create;
  if Pos('://', File_) = 0 then
  begin
    if not fileexists(File_) then
      exit;
  end;
  idTag.LoadFile(File_);
if idtag.Loaded then
      begin
 if Pchar(idtag.tag.Artist) <> '' then
      Result.Name := idtag.tag.Artist
    else
      Result.Name  := Copy(fn, 0, Pos('-', fn) - 1);
    if Pchar(Result.Name)  = '' then
      Result.Name  := 'Неизвестный артист ';
    Result.Name  := Result.Name  + '- ';
    if Pchar(idtag.tag.Title) <> '' then
      Result.Name  := Result.Name  + idtag.tag.Title
    else
      Result.Name  := Result.Name  + Copy(fn, Pos('-', fn) + 1, Length(fn));
 result.BitRate:= idtag.tag.Bitrate;
 result.SampleRate:=idtag.tag.SampleRate;
 result.Time:=Round(idtag.tag.Duration);
end
else
result:=Sound_Engine.Get_Tegdata(File_);
 idTag.Free;
 end;


Function ShowTagDLGFromFile(fl:string):HWND;
Begin
    Audio_Info:= TAudio_Info.Create(Application,fl);
    if not Audio_Info.error then
    begin
    Audio_Info.Show;
    result:=Audio_Info.Handle;
    end
    else
    Audio_Info.Free;
End;


Procedure ShowTagDLG(Data:PtrackData);
Begin
if (GetWindow(Whandle,GW_OWNER)<>0)  then
exit;
If Data^.CUEFlag and Data^.OneFile then
begin
CUE_Info:=TCUE_Info.Create(Application,Data);
CUE_Info.ShowModal;
end
else
If Data^.VKFlag then
Begin
VKtag_Info:=TVKtag_Info.Create(Application,Data);
VKtag_Info.Show;
Whandle:=VKTag_Info.Handle;
end
else
if Pos('://',Data^.filename) <> 0 then
begin
ShowMessage('Internet Stream From: '+data^.filename);
end
else
Begin
Whandle:=ShowTagDLGFromFile(Data^.filename);
Data^.InfoUpdt:=True;
end;

end;




end.