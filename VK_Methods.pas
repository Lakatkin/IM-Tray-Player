unit VK_Methods;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
Windows, Messages, SysUtils, Variants, Classes,uLkJSON,MyUtils,forms,
Dialogs,VKAPI_types, StdCtrls,strUtils, ImgPlayList,ImgFriendsList,ActiveX;

type
TAudiosearchOpt=record
auto_complete:boolean;
sort_type:Integer;
Onlylyrics:boolean;
end;

////////audio//////////////
Procedure GetAudioList(UserInfo:PUser;List:TImgPlayList;New:boolean);
Procedure UpdateAudioLinks(List:TImgPlayList);
Procedure searchAudioList(title:String;Options:TAudiosearchOpt;List:TImgPlayList;New:boolean);
Procedure GetPopAudioList(OnlyEng:boolean;Gener:Integer;List:TImgPlayList;New:boolean);
Procedure GetRecomAudioList(random:boolean;UserInfo:PUser;Track:PTrackData;List:TImgPlayList;New:boolean);
Function getLyrics(LyricsID:String):String;
Function AddAudio(AudioID,OwnerID:String):boolean;
Function DelAudio(AudioID,OwnerID:String):boolean;
//////////Users Functions/////////////
Procedure GetFriendsShortInfoList(List:TImgFriendsList);
Function Get_UserShortInfo(UserID:String;NeedPhoto:boolean):pUser;
//////////Status Functions/////////////
Function GetStatus(UserID:String):String;
Procedure SetStatus(text:String;CurAudio:PTrackData=nil);
//////////Groups Functions/////////////
Procedure GetGruupShortInfoList(List:TImgFriendsList);
Function Get_GruupShortInfo(UserID:String;NeedPhoto:boolean):pUser;

{}

var
ModuleHandle:TVKAPI;

implementation


///////////////////VK_Methods Utils///////////////

Function GetUploaderId(filename:string):String;
Var
i:integer;
begin
i:=Pos('.com',filename);
if i=0 then
i:=Pos('.ru',filename);
if i=0 then
i:=Pos('.me',filename);
delete(filename,1,i);
delete(filename,1,Pos('/',filename));
Result:=Copy(filename,Pos('u',filename)+1,Pos('/',filename)-2);
if Length(result)<4 then
result:='_null';
end;

Function Get_ShortUserInfoFromJs(js:TlkJSONobject;NeedPhoto:boolean):pUser;
Var
Ph:string;
Begin
result:=nil;
New(Result);
With result^ do
begin
uid:=inttostr(Js.getInt('id'));
Name:=Js.getString('first_name');
Name:=Name+' '+Js.getString('last_name');
if NeedPhoto then
begin
Ph:=Js.getString('photo');
If not Fileexists(CachePath+ExtractFileNameEX(Ph)) then
begin
if GetInetFile(Ph,CachePath+ExtractFileNameEX(Ph))then
Photo:=CachePath+ExtractFileNameEX(Ph);
end
else
Photo:=CachePath+ExtractFileNameEX(Ph);
end
else
Photo:='';
end;
end;

Function Get_ShortGroupInfoFromJs(js:TlkJSONobject;NeedPhoto:boolean):pUser;
Var
Ph:string;
Begin
result:=nil;
New(Result);
With result^ do
begin
uid:='-'+inttostr(Js.getInt('id'));
Name:=Js.getString('name');
if NeedPhoto then
begin
Ph:=Js.getString('photo_50');
If not Fileexists(CachePath+ExtractFileNameEX(Ph)) then
begin
if GetInetFile(Ph,CachePath+ExtractFileNameEX(Ph))then
Photo:=CachePath+ExtractFileNameEX(Ph);
end
else
Photo:=CachePath+ExtractFileNameEX(Ph);
end
else
Photo:='';
end;
end;


Function Get_ImPlElementFromJs(js:TlkJSONobject):PTrackData;
var
s:PChar;
Begin
result:=nil;
New(Result);
With result^ do
begin
VKFlag:=True;
CUEFlag:=False;
InBest:=False;
InfoUpdt:=True;
BitRate:=0;
Freq:=0;
Name:=Js.getString('artist')+'- '+Js.getString('title');
OrigName:=Name;
filename:=Js.getString('url');
time:=Js.getInt('duration');
Format:=UpperCase(Copy(ExtractFileEXT(filename), 2,3));
aid:=Inttostr(Js.getInt('id'));
owner_id:=Inttostr(Js.getInt('owner_id'));
Uploader_id:=GetUploaderId(filename);
lyrics_id:=Inttostr(Js.getInt('lyrics_id'));
end;
end;

Function Deltegs(s:String):String;
Begin
While Pos('amp;',s)<>0 do
begin
If Pos('amp;',s)<>0 then
delete(s,Pos('amp;',s),4);
end;
Result:=s;
end;


Function Get_Req(stream:IStream):String;
var
Ls:TStringList;
tmp:TExternStream;
begin
Ls:=TStringList.Create;
tmp:=TExternStream.Create(stream);
tmp.Position:=0;
Ls.LoadFromStream(tmp);
Result:=(UTF8ToString(Ls.Text));
Result:=Deltegs(Result);
Ls.Free;
end;


////////////////Relise/////////////////

///////////////Audio///////////////////
Procedure GetAudioList(UserInfo:PUser;List:TImgPlayList;New:boolean);
var
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
id,uid:string;
s:string;
i:integer;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
 try
 id:='owner_id=';
 uid:= UserInfo^.uid;
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.get')),Pchar((id+uid+'&need_user=1'))));
if s='' then
exit;
if new then
begin
List.Clear;
List.FillHeader(List.ListHeader);
List.ListHeader.Name:='Музыка из VK ('+UserInfo^.Name+')';
List.ListHeader.Album:=UserInfo^.Name+' Музыка из VK';
end;

js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
if Js.Field['response']<>nil then
ChildJs := Js.Field['response'].Field['items'];
if ChildJs<>nil then
begin
For i:=1 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
application.ProcessMessages;
list.AddItem_(Get_ImPlElementFromJs(TmpJs as TlkJSONobject));
end;
List.ListHeader.Tracks:=Inttostr(List.Count);
end;
Js.Free;
finally
end;
end;

Procedure UpdateAudioLinks(List:TImgPlayList);
var
IdList,s:string;
i,offs,cnt:integer;
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
deleted:integer;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
offs:=0;
While offs<List.VKLIST.Count-1 do
begin
IdList:='';
if (offs+200) < (List.VKLIST.Count-1) then
cnt:=200
else
cnt:=(List.VKLIST.Count-1)-offs;
For i:=offs to (offs+cnt) do
begin
IdList:=IdList+pTrackData(List.VKLIST[i])^.owner_id+'_'+pTrackData(List.VKLIST[i])^.aid+',';
end;
delete(IdList,Length(IdList),1);
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.getById')),Pchar(('audios='+IdList))));
deleted:=0;
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
begin
For i:=0 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
if PTrackData(List.VKLIST[i+offs+deleted])^.aid<>Inttostr((TmpJs as TlkJSONobject).getInt('aid')) then
deleted:=deleted+1;
PTrackData(List.VKLIST[i+offs+deleted])^.filename:=((TmpJs as TlkJSONobject).getString('url'));
application.ProcessMessages;
end;
end;
js.Free;
finally
end;
offs:=offs+cnt;
end;
end;

Procedure searchAudioList(title:String;Options:TAudiosearchOpt;List:TImgPlayList;New:boolean);
var
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
s:string;
i:integer;
autoCmp,sort,lyrics:string;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
if new then
begin
List.Clear;
end;
if Options.auto_complete then
autoCmp:='&auto_complete=1'
else
autoCmp:='';
if Options.Onlylyrics then
lyrics:='&lyrics=1'
else
lyrics:='';
sort:='&sort='+Inttostr(Options.sort_type);
List.FillHeader(List.ListHeader);
List.ListHeader.Album:='Результат поиска по запросу: '+title;
List.ListHeader.Name:='Поиск по запросу '+title;
title:=AnsiToUtf8(UrlEncode(AnsiToUtf8(ansistring(title))));
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.search')),Pchar(('q='+title+autoCmp+sort+lyrics+'&count=300'))));
if s='' then
exit;
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
if Js.Field['response']<>nil then
ChildJs := Js.Field['response'].Field['items'];
if ChildJs<>nil then
begin
For i:=1 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
list.AddItem_(Get_ImPlElementFromJs(TmpJs as TlkJSONobject));
application.ProcessMessages;
end;
List.ListHeader.Tracks:=Inttostr(List.Count);
end;
Js.Free;
finally
end;
end;


Procedure GetPopAudioList(OnlyEng:boolean;Gener:Integer;List:TImgPlayList;New:boolean);
var
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
s:String;
eng:String;
gen:String;
i:integer;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
if new then
begin
List.Clear;
end;
if (Gener>0) and (Gener<=22) then
gen:='&genre_id='+IntTostr(Gener)
else
gen:='';
if OnlyEng then
eng:='&only_eng=1'
else
eng:='';
List.FillHeader(List.ListHeader);
List.ListHeader.Album:='Популярное ';
List.ListHeader.Name:='Популярное ';
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.getPopular')),Pchar(('count=300'+gen+eng))));
if s='' then
exit;
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
if Js.Field['response']<>nil then
ChildJs := Js.Field['response'].Field['items'];
if ChildJs<>nil then
begin
For i:=1 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
list.AddItem_(Get_ImPlElementFromJs(TmpJs as TlkJSONobject));
application.ProcessMessages;
end;
List.ListHeader.Tracks:=Inttostr(List.Count);
end;
Js.Free;
finally
end;
end;

Procedure GetRecomAudioList(random:boolean;UserInfo:PUser;Track:PTrackData;List:TImgPlayList;New:boolean);
var
Rnd,aud,user:string;
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
s:String;
i:Integer;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
if new then
begin
List.Clear;
end;
if Track<>nil then
aud:='&target_audio='+Track^.owner_id+'_'+Track^.aid
else
aud:='';
if UserInfo<>nil then
user:='&user_id='+UserInfo^.uid
else
user:='';
if random then
Rnd:='&shuffle=1'
else
Rnd:='&shuffle=0';
List.FillHeader(List.ListHeader);
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.getRecommendations')),Pchar(('count=300'+aud+user+rnd))));
if s='' then
exit;
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
if Js.Field['response']<>nil then
ChildJs := Js.Field['response'].Field['items'];
if ChildJs<>nil then
begin
For i:=1 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
list.AddItem_(Get_ImPlElementFromJs(TmpJs as TlkJSONobject));
application.ProcessMessages;
end;
List.ListHeader.Tracks:=Inttostr(List.Count);
end;
Js.Free;
finally
end;
end;

Function getLyrics(LyricsID:String):String;
var
js:TlkJSONobject;
ChildJs:TlkJSONbase;
s:string;
begin
Result:='';
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.getLyrics')),Pchar(('lyrics_id='+LyricsID))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
begin
result:=((ChildJs  as TlkJSONobject)).getString('text');
end;
Js.Free;
finally
end;
end;

Function AddAudio(AudioID,OwnerID:String):boolean;
var
js:TlkJSONobject;
ChildJs:TlkJSONbase;
s:string;
begin
Result:=False;
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.add')),Pchar(('audio_id='+AudioID+'&owner_id='+OwnerID))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
Result:=true
else
Result:=False;
js.Free;
finally
end;
end;

Function DelAudio(AudioID,OwnerID:String):boolean;
var
js:TlkJSONobject;
ChildJs:TlkJSONbase;
s:string;
begin
Result:=False;
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.delete')),Pchar(('audio_id='+AudioID+'&owner_id='+OwnerID))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
Result:=true
else
Result:=False;
js.Free;
finally
end;
end;

////////////////////end of Audio/////////////////////

//////////Users Functions/////////////

Procedure AddUser2List(s:string;List:TImgFriendsList);
var
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
i:Integer;
begin
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
if Js.Field['response']<>nil then
ChildJs := Js.Field['response'].Field['items'];
if ChildJs<>nil then
begin
For i:=0 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
List.AddItem_(Get_ShortUserInfoFromJs((TmpJs as TlkJSONobject),true));
application.ProcessMessages;
end;
end;
js.Free;
end;

Procedure GetFriendsShortInfoList(List:TImgFriendsList);
var
s:String;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
List.Clear;
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar((('users.get'))),Pchar(Pansichar(('user_ids='+WideString(ansiString(ModuleHandle.GetCurUserID))+'&fields=uid,first_name,last_name,photo&order=hints')))));
if s='' then
exit;
AddUser2List(s,List);
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('friends.get')),Pchar(('user_id='+WideString((ModuleHandle.GetCurUserID))+'&fields=uid,first_name,last_name,photo&order=hints'))));
if s='' then
exit;
application.ProcessMessages;
AddUser2List(s,List);
end;

Function Get_UserShortInfo(UserID:String;NeedPhoto:boolean):pUser;
var
s:String;
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
begin
Result:=nil;
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('users.get')),Pchar(('user_ids='+UserID+'&fields=uid,first_name,last_name,photo'))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
begin
TmpJs:=ChildJs.Child[0];
Result:=Get_ShortUserInfoFromJs(TmpJs as TlkJSONobject,NeedPhoto);
 end;
end;

//////////End of Users/////////////

//////////Groups Functions/////////////
Procedure AddGroup2List(s:string;List:TImgFriendsList);
var
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
i:Integer;
begin
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
if Js.Field['response']<>nil then
ChildJs := Js.Field['response'].Field['items'];
if ChildJs<>nil then
begin
For i:=0 to ChildJs.Count-1 do
begin
TmpJs:=ChildJs.Child[i];
List.AddItem_(Get_ShortGroupInfoFromJs((TmpJs as TlkJSONobject),true));
application.ProcessMessages;
end;
end;
js.Free;
end;

Procedure GetGruupShortInfoList(List:TImgFriendsList);
var
s:String;
begin
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
List.Clear;
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('groups.get')),Pchar(('user_id='+WideString((ModuleHandle.GetCurUserID))+'&extended=1'))));
if s='' then
exit;
application.ProcessMessages;
AddGroup2List(s,List);
end;

Function Get_GruupShortInfo(UserID:String;NeedPhoto:boolean):pUser;
var
s:String;
js:TlkJSONobject;
ChildJs,TmpJs:TlkJSONbase;
begin
Result:=nil;
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('groups.getById')),Pchar(('group_ids='+WideString((UserID))))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
begin
TmpJs:=ChildJs.Child[0];
Result:=Get_ShortGroupInfoFromJs(TmpJs as TlkJSONobject,NeedPhoto);
 end;

end;

//////////Status Functions/////////////
Function GetStatus(UserID:String):String;
var
js:TlkJSONobject;
ChildJs:TlkJSONbase;
s:string;
begin
Result:='';
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('status.get')),Pchar(('user_id='+UserID))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
if ChildJs<>nil then
result:=((ChildJs  as TlkJSONobject)).getString('text');
js.Free;
finally
end;
end;

Procedure SetStatus(text:String;CurAudio:PTrackData);
var
js:TlkJSONobject;
ChildJs:TlkJSONbase;
s,Aud_id,status:string;
begin
ChildJs:=nil;
If not ModuleHandle.CanCallAPI then
begin
ShowMessage('Вызов api функции не возможен');
exit;
end;
if CurAudio<> nil then
begin
If CurAudio^.VKFlag then
Begin
Aud_id:= CurAudio^.owner_id+'_'+CurAudio^.aid;
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.setBroadcast')),Pchar(('audio='+Aud_id))));
if s='' then
exit;
js := TlkJSONobject.Create;
js := TlkJSON.ParseText(s) as TlkJSONobject;
ChildJs := Js.Field['response'];
end;
if ChildJs=nil then
begin
status:=CurAudio^.Name;
Status:=WideString(UrlEncode(AnsiToUtf8(AnsiString(status))));
try
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('status.set')),Pchar(('text='+status))));
if s='' then
exit;
finally
end;
end;
Js.Free;
end
else
Begin
s:=Get_Req(ModuleHandle.VK_MethodCall(Pchar(('audio.setBroadcast')),Pchar((''))));
text:=WideString(UrlEncode(AnsiToUtf8(AnsiString(text))));
Get_Req(ModuleHandle.VK_MethodCall(Pchar(('status.set')),Pchar(('text='+text))));
end;
end;

//////////End of Status/////////////

end.
