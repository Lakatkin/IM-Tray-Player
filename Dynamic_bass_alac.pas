Unit Dynamic_BASS_ALAC;

interface

uses windows, Dynamic_bass;

const
  BASS_TAG_MP4        = 7;	// iTunes/MP4 metadata

  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_ALAC        = $10e00;



Var
BASS_ALAC_StreamCreateFile:function(mem:BOOL; f:Pointer; offset,length:QWORD; flags:DWORD): HSTREAM; stdcall;
BASS_ALAC_StreamCreateFileUser:function(system,flags:DWORD; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM; stdcall;

function Load_BASSALACDLL(const dllfilename : string) : boolean;
procedure Unload_BASSALACDLL;

var BASSALAC_Handle : Thandle = 0;
implementation

function Load_BASSALACDLL(const dllfilename : string) : boolean;
var
   oldmode : integer;
begin
   if BASSALAC_Handle <> 0 then // is it already there ?
      result := true
   else begin {go & load the dll}
   oldmode := SetErrorMode($8001);
   BASSALAC_Handle := LoadLibrary(pchar(dllfilename));  // obtain the handle we want
   SetErrorMode(oldmode);
   if BASSALAC_Handle <> 0 then
       begin
@BASS_ALAC_StreamCreateFile:=GetProcAddress(BASSALAC_Handle,'BASS_ALAC_StreamCreateFile');
@BASS_ALAC_StreamCreateFileUser:=GetProcAddress(BASSALAC_Handle,'BASS_ALAC_StreamCreateFileUser');
If (@BASS_ALAC_StreamCreateFile = nil) or
(@BASS_ALAC_StreamCreateFileUser = nil) then
      begin
      FreeLibrary(BASSALAC_Handle);
      BASSALAC_Handle := 0;
       end;
     end;
     result := (BASSALAC_Handle <> 0);
   end;
end;

procedure Unload_BASSALACDLL;
Begin
if BASSALAC_Handle  <> 0 then
FreeLibrary(BASSALAC_Handle);
BASSALAC_Handle := 0;
end;

end.