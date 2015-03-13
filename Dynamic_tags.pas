{
Tags.dll written by Wraith, 2k5-2k6
Delphi Wrapper written by Chris Troesken 
}

unit Dynamic_tags;

interface

uses
  Windows;
var
TAGS_Read:function(handle: DWORD; const fmt: PAnsiChar): PAnsiChar; stdcall;
TAGS_GetLastErrorDesc:function: PAnsiChar; stdcall;
TAGS_GetVersion:function: DWORD; stdcall;


function Load_BASSTAGSDLL(const dllfilename : string) : boolean;
procedure Unload_BASSTAGSDLL;

var BASSTAGS_Handle : Thandle = 0;
implementation

function Load_BASSTAGSDLL(const dllfilename : string) : boolean;
var
   oldmode : integer;
begin
   if BASSTAGS_Handle <> 0 then // is it already there ?
      result := true
   else begin {go & load the dll}
   oldmode := SetErrorMode($8001);
   BASSTAGS_Handle := LoadLibrary(pchar(dllfilename));  // obtain the handle we want
   SetErrorMode(oldmode);
   if BASSTAGS_Handle <> 0 then
       begin
@TAGS_Read:=GetProcAddress(BASSTAGS_Handle,'TAGS_Read');
@TAGS_GetLastErrorDesc:=GetProcAddress(BASSTAGS_Handle,'TAGS_GetLastErrorDesc');
@TAGS_GetVersion:=GetProcAddress(BASSTAGS_Handle,'TAGS_GetVersion');
If (@TAGS_Read = nil) or
(@TAGS_GetLastErrorDesc = nil) or
(@TAGS_GetVersion = nil) then
      begin
      FreeLibrary(BASSTAGS_Handle);
      BASSTAGS_Handle := 0;
       end;
     end;
     result := (BASSTAGS_Handle<> 0);
   end;
end;

procedure Unload_BASSTAGSDLL;
Begin
if BASSTAGS_Handle  <> 0 then
FreeLibrary(BASSTAGS_Handle);
BASSTAGS_Handle := 0;
end;

end.
