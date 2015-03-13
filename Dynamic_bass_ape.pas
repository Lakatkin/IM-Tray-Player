Unit Dynamic_BASS_APE;

interface

uses windows, Dynamic_bass;

const
  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_APE        = $10700;


Var
BASS_APE_StreamCreateFile:function(mem:BOOL; f:Pointer; offset,length:QWORD; flags:DWORD): HSTREAM; stdcall;
BASS_APE_StreamCreateFileUser:function(system,flags:DWORD; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM; stdcall;

function Load_BASSAPEDLL(const dllfilename : string) : boolean;
procedure Unload_BASSAPEDLL;

var BASSAPE_Handle : Thandle = 0;
implementation

function Load_BASSAPEDLL(const dllfilename : string) : boolean;
var
   oldmode : integer;
begin
   if BASSAPE_Handle <> 0 then // is it already there ?
      result := true
   else begin {go & load the dll}
   oldmode := SetErrorMode($8001);
   BASSAPE_Handle := LoadLibrary(pchar(dllfilename));  // obtain the handle we want
   SetErrorMode(oldmode);
   if BASSAPE_Handle <> 0 then
       begin
@BASS_APE_StreamCreateFile:=GetProcAddress(BASSAPE_Handle,'BASS_APE_StreamCreateFile');
@BASS_APE_StreamCreateFileUser:=GetProcAddress(BASSAPE_Handle,'BASS_APE_StreamCreateFileUser');
If (@BASS_APE_StreamCreateFile = nil) or
(@BASS_APE_StreamCreateFileUser = nil) then
      begin
      FreeLibrary(BASSAPE_Handle);
      BASSAPE_Handle := 0;
       end;
     end;
     result := (BASSAPE_Handle <> 0);
   end;
end;

procedure Unload_BASSAPEDLL;
Begin
if BASSAPE_Handle  <> 0 then
FreeLibrary(BASSAPE_Handle);
BASSAPE_Handle := 0;
end;

end.