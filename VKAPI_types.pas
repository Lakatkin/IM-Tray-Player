unit VKAPI_types;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
Windows, Messages, SysUtils, Variants, Classes,ActiveX;


type
PVKAPI=^TVKAPI;
TVKAPI=record
//////////Init Functions/////////////
Init:Function(Module:LongWord;Handle:HWND;Autorize:boolean):boolean;
Free:Procedure;
SetLogin:Procedure(login:Pchar);
setPass:Procedure(pass:Pchar);
ShowAuthDLG:Procedure(modal:boolean);
Log_In:Function:integer;  //0-all ok, -1 login or pass error, -2 get token error -3 no connect
Log_Out:Function:Boolean;
CanCallAPI:Function:boolean;
VK_MethodCall:Function(METHOD_NAME,PARAMETERS:PChar):IStream;
GetCurUserID:Function:PChar;
end;

var
Init_VK_API:Function:PVKAPI; stdcall;

function Load_VKAPIDLL(const dllfilename : string) : boolean;
procedure Unload_VKAPIDLL;

var VKAPI_Handle : Thandle = 0;
implementation

function Load_VKAPIDLL(const dllfilename : string) : boolean;
var
   oldmode : integer;
begin
   if VKAPI_Handle <> 0 then // is it already there ?
      result := true
   else begin {go & load the dll}
   oldmode := SetErrorMode($8001);
   VKAPI_Handle := LoadLibrary(pchar(dllfilename));  // obtain the handle we want
   SetErrorMode(oldmode);
   if VKAPI_Handle <> 0 then
   begin
   @Init_VK_API:=GetProcAddress(VKAPI_Handle,'InitAPI');
   if Init_VK_API=nil then
    begin
      FreeLibrary(VKAPI_Handle);
      VKAPI_Handle := 0;
       end;
       end;
       end;
result := (VKAPI_Handle <> 0);
end;

procedure Unload_VKAPIDLL;
Begin
if VKAPI_Handle  <> 0 then
FreeLibrary(VKAPI_Handle);
VKAPI_Handle := 0;
end;

end.
