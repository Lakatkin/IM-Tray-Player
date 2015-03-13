{
  BASSFLAC 2.4 Delphi unit
  Copyright (c) 2004-2008 Un4seen Developments Ltd.

  See the BASSFLAC.CHM file for more detailed documentation
}

unit Dynamic_BassFLAC;

interface

uses Windows, Dynamic_Bass;

const
  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_FLAC        = $10900;
  BASS_CTYPE_STREAM_FLAC_OGG    = $10901;

Var
BASS_FLAC_StreamCreateFile:function(mem:BOOL; f:Pointer; offset,length:QWORD; flags:DWORD): HSTREAM; stdcall;
BASS_FLAC_StreamCreateURL:function(URL:PChar; offset:DWORD; flags:DWORD; proc:DOWNLOADPROC; user:Pointer): HSTREAM; stdcall;
BASS_FLAC_StreamCreateFileUser:function(system,flags:DWORD; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM; stdcall;

function Load_BASSFLACDLL(const dllfilename : string) : boolean;
procedure Unload_BASSFLACDLL;

var BASSFLAC_Handle : Thandle = 0;
implementation

function Load_BASSFLACDLL(const dllfilename : string) : boolean;
var
   oldmode : integer;
begin
   if BASSFLAC_Handle <> 0 then // is it already there ?
      result := true
   else begin {go & load the dll}
   oldmode := SetErrorMode($8001);
   BASSFLAC_Handle := LoadLibrary(pchar(dllfilename));  // obtain the handle we want
   SetErrorMode(oldmode);
   if BASSFLAC_Handle <> 0 then
       begin
@BASS_FLAC_StreamCreateFile:=GetProcAddress(BASSFLAC_Handle,'BASS_FLAC_StreamCreateFile');
@BASS_FLAC_StreamCreateURL:=GetProcAddress(BASSFLAC_Handle,'BASS_FLAC_StreamCreateURL');
@BASS_FLAC_StreamCreateFileUser:=GetProcAddress(BASSFLAC_Handle,'BASS_FLAC_StreamCreateFileUser');
If (@BASS_FLAC_StreamCreateFile = nil) or
(@BASS_FLAC_StreamCreateURL= nil) or
(@BASS_FLAC_StreamCreateFileUser = nil) then
      begin
      FreeLibrary(BASSFLAC_Handle);
      BASSFLAC_Handle := 0;
       end;
     end;
     result := (BASSFLAC_Handle <> 0);
   end;
end;

procedure Unload_BASSFLACDLL;
Begin
if BASSFLAC_Handle  <> 0 then
FreeLibrary(BASSFLAC_Handle);
BASSFLAC_Handle := 0;
end;

end.
