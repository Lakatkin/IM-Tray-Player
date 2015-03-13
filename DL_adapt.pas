unit DL_adapt;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////


interface

uses
Windows, Messages, SysUtils, Variants, Classes,MyUtils,forms,
Dialogs,StdCtrls,strUtils, ImgPlayList,Dl_WND,DL_Core;


Procedure DL_File(url,FileName:string; Wait,Enabled:boolean);
Procedure DL_FullList(List:TimgPlayList;From,_to:integer;dir:string;NameMode:integer;_addnum:boolean); //1-By name 2-by id

var
TotalDlHandle:HWND;
implementation


Procedure DL_File(url,FileName:string; Wait,Enabled:boolean);
Var
Form:TDL_DLG;
begin
Form:=TDL_DLG.Create(application);
Form.AddToList(url,FileName);
Form.Enabled:=Enabled;
Form.Show;
if not Wait then
exit;
While Form.DLEnd=false do
begin
Sleep(1);
application.ProcessMessages;
end;
end;

Procedure DL_FullList(List:TimgPlayList;From,_to:integer;dir:string;NameMode:integer;_addnum:boolean); //1-By name 2-by id
Var
i:integer;
num:integer;
_Num:string;
name:String;
Form:TDL_DLG;
item:pTrackData;
ext:string;
begin      {  }
Form:=TDL_DLG.Create(application);
num:=0;
For i:=From to _to do
begin
num:=num+1;
item:=List.DataItems[i];
If NameMode=1 then
begin
name:=item^.OrigName;
if _addnum    then
_Num:=AddNum2Name(num,(_to-From))
else
_Num:='';
end
else
If NameMode=2 then
begin
name:=item^.aid;
_Num:='';
end;
ext:=LowerCase('.mp3');
Form.AddToList(item^.filename,FilenameCut(dir+_Num+FileNameStd(name),MAX_PATH-10)+ext);
end;
Form.Show;
TotalDlHandle:=Form.Handle;
end;


end.
