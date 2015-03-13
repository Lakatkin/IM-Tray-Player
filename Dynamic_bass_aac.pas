Unit Dynamic_BASS_AAC;

interface

uses windows, Dynamic_Bass;

const
  // Additional BASS_SetConfig options
  BASS_CONFIG_MP4_VIDEO = $10700; // play the audio from MP4 videos
  BASS_CONFIG_AAC_MP4 = $10701; // support MP4 in BASS_AAC_StreamCreateXXX functions (no need for BASS_MP4_StreamCreateXXX)

  // Additional tags available from BASS_StreamGetTags
  BASS_TAG_MP4        = 7; // MP4/iTunes metadata

  BASS_AAC_STEREO = $400000; // downmatrix to stereo

  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_AAC        = $10b00; // AAC
  BASS_CTYPE_STREAM_MP4        = $10b01; // MP4




var
BASS_AAC_StreamCreateFile :function(mem:BOOL; f:Pointer; offset,length:QWORD; flags:DWORD): HSTREAM;       stdcall;
BASS_AAC_StreamCreateURL:function(URL:PChar; offset:DWORD; flags:DWORD; proc:DOWNLOADPROC; user:Pointer): HSTREAM;    stdcall;
BASS_AAC_StreamCreateFileUser:function (system,flags:DWORD; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM;   stdcall;
BASS_MP4_StreamCreateFile:function (mem:BOOL; f:Pointer; offset,length:QWORD; flags:DWORD): HSTREAM;            stdcall;
BASS_MP4_StreamCreateFileUser:function (system,flags:DWORD; var procs:BASS_FILEPROCS; user:Pointer): HSTREAM;    stdcall;

function Load_BASSAACDLL(const dllfilename : string) : boolean;
procedure Unload_BASSAACDLL;

var BASSAAC_Handle : Thandle = 0;
implementation

function Load_BASSAACDLL(const dllfilename : string) : boolean;
var
   oldmode : integer;
begin
   if BASSAAC_Handle <> 0 then // is it already there ?
      result := true
   else begin {go & load the dll}
   oldmode := SetErrorMode($8001);
   BASSAAC_Handle := LoadLibrary(pchar(dllfilename));  // obtain the handle we want
   SetErrorMode(oldmode);
   if BASSAAC_Handle <> 0 then
       begin
@BASS_AAC_StreamCreateFile:=GetProcAddress(BASSAAC_Handle,'BASS_AAC_StreamCreateFile');
@BASS_AAC_StreamCreateURL:=GetProcAddress(BASSAAC_Handle,'BASS_AAC_StreamCreateURL');
BASS_AAC_StreamCreateFileUser:=GetProcAddress(BASSAAC_Handle,'BASS_AAC_StreamCreateFileUser');
BASS_MP4_StreamCreateFile:=GetProcAddress(BASSAAC_Handle,'BASS_MP4_StreamCreateFile');
BASS_MP4_StreamCreateFileUser:=GetProcAddress(BASSAAC_Handle,'BASS_MP4_StreamCreateFileUser');

If (@BASS_AAC_StreamCreateFile = nil) or
(@BASS_AAC_StreamCreateURL= nil) or
(@BASS_AAC_StreamCreateFileUser = nil) or
(@BASS_MP4_StreamCreateFile= nil) or
(@BASS_MP4_StreamCreateFileUser= nil)  then
      begin
      FreeLibrary(BASSAAC_Handle);
      BASSAAC_Handle := 0;
       end;
     end;
     result := (BASSAAC_Handle <> 0);
   end;
end;

procedure Unload_BASSAACDLL;
Begin
if BASSAAC_Handle  <> 0 then
FreeLibrary(BASSAAC_Handle);
BASSAAC_Handle := 0;
end;

end.