unit Sound_Engine;

//////////////////////////////////////////
//                                      //
//     IMTrayPlayer Component LIB.      //
//         Bass Sound ENGINE            //
//           For ImPlayer beta          //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Dynamic_Bass, Dynamic_BASSWMA, Dynamic_bassmidi,
  Dynamic_basscd, Dynamic_bass_ape, Dynamic_bass_alac,
  Dynamic_bassflac,Dynamic_BASS_AAC,Dynamic_tags, dialogs, MyUtils;


type
  TCueStruct = Record
    File_: String;
    Length: Integer;
    Index01: double;
    OneFile: boolean;
  end;

  TBaseInfo = Record
    Name: String;
    BitRate: Integer;
    SampleRate: Integer;
    Time: Integer;
  end;

  TExtTag=record
  title:string;
  artist:string;
  album:string;
  year:string;
  gener:string;
  comment:string;
  BitRate: Integer;
  SampleRate: Integer;
  Time: Integer;
  end;



function Loading_dll(Path: string): boolean;
procedure GetDeviceList(var List: TStringList);
function SetOutDevice(num, freq: integer; Handle: HWND): Boolean;
procedure SetBufsize(val: Integer);
function OpenFile(fileName: String): Boolean;
function OpenCue(Cuedat: TCueStruct): Boolean;
function OpenNetRadio(URL: String): Boolean;
procedure Play;
procedure Pause(P: Boolean);
procedure Stop(clear: boolean);
function GetLength: Integer;
function GetBitRate: Integer;
function GetFreq: Integer;
function GetCh: Integer;
function GetPosition: Integer;
function  GetdlLength: QWord;
function  GetdlPos: QWord;
procedure SetVolume(Vol: Integer; GlobalVolume: Boolean);
procedure SetPosition(Pos: Integer);
function IsPlayend: Boolean;
{Procedure GetCDList(List:TStringList;Format:String);
Procedure SetCDTrackNum(num:Integer);  }
procedure SetEQ(run: boolean);
procedure SetEQval(num, val: Integer);
function Get_Tegdata(filename: string): TBaseInfo;
Function GetExtendedTag(filename: string):TExtTag;
function Get_CurentTegdata(ReadIDtag:boolean;DefTitle:String): TBaseInfo;
const
  CompresFileExt = '*.mp1;*.mp2;*.mp3;*.ogg;*.aiff;*.wma;*.mp4;';
  MusicFileExt = '*.mo3;*.it;*.xm;*.s3m;*.mtm;*.mod;*.umx;';
  MIDIFileExt = '*.mid;*.midi;*.rim;*.kar;';
  LossLessFileExt = '*.wav;*.ape;*.flac;*.alac;*.aac;*.m4a;';
  AudioCDFileExt = '*.cda;';
  supportFiles = CompresFileExt + MusicFileExt + MIDIFileExt + LossLessFileExt + AudioCDFileExt;


implementation

var
  oFile: string;
  Stream: DWord;
  CurCUE: TCueStruct;
  IsCUEopen: Boolean;
  MUSICFlag: Boolean;
  FromNet: boolean;
  BassChannelInfo: BASS_CHANNELINFO;
  EQ_Ef: BASS_DX8_PARAMEQ;
  EQ_HFX: array[1..10] of HFX;
  EQ_FRQ : array[1..10] of float =
  (80, 170, 310, 600, 1000, 3000, 6000, 10000, 12000, 16000);
  EQ_BW:array[1..10] of float =(4, 4, 4, 4, 5, 6, 5, 4, 3, 4);
  EQ_Val:array[1..10] of FLOAT;
  UseEQ:boolean;
  CurVol: Integer;
  GV: boolean;

function Loading_dll(Path: string): boolean;
begin
  result := True;
  Result := Result and dynamic_Bass.Load_BASSDLL(Path + 'bass.dll');
  Result := Result and dynamic_BassWma.Load_BASSWMADLL(Path + 'basswma.dll');
  Result := Result and dynamic_BassCD.Load_BASSCDDLL(Path + 'basscd.dll');
  Result := Result and dynamic_BassMidi.Load_BASSMIDIDLL(Path + 'bassmidi.dll');
  Result := Result and dynamic_Bassflac.Load_BASSFLACDLL(Path + 'bassflac.dll');
  Result := Result and dynamic_Bass_ape.Load_BASSAPEDLL(Path + 'bass_ape.dll');
  Result := Result and dynamic_Bass_alac.Load_BASSALACDLL(Path + 'bass_alac.dll');
    Result := Result and dynamic_Bass_aac.Load_BASSAACDLL(Path + 'bass_aac.dll');
  Result := Result and dynamic_Tags.Load_BASSTAGSDLL(Path + 'tags.dll');
  Dynamic_Bass.BASS_SetConfigPtr(BASS_CONFIG_NET_AGENT,PAnsichar(AnsiString('Mozilla/5.0')));
end;

procedure GetDeviceList(var List: TStringList);
var
  i: Integer;
  ADeviceInfo: BASS_DEVICEINFO;
begin
  List := TStringList.Create;
  i := 1;
  while BASS_GetDeviceInfo(I, ADeviceInfo) do
  begin
    List.Add(ADeviceInfo.name);
    i := i + 1;
  end;
end;

function SetOutDevice(num, freq: integer; Handle: HWND): Boolean;
begin
  BASS_Free;
  Result := BASS_Init(num, freq, BASS_DEVICE_CPSPEAKERS, Handle, nil);
  BASS_Start;
end;

procedure SetBufsize(val: Integer);
begin
  if Val > 5000 then
    Val := 5000;
  if Val < 1 then
    Val := 1;
  BASS_SetConfig(BASS_CONFIG_BUFFER, val);
end;

procedure Open_stream(fileName: String; var data: DWord; Flag: DWORD; var MUSICFlag: boolean);
begin
  if LowerCase(Copy(FileName, 1, 7)) = 'http://' then
  begin
    data := BASS_StreamCreateURL(Pansichar(ansistring(FileName)), 0, Flag, nil, 0);
    FromNet := true;
  end
  else
  begin
    if not Fileexists(fileName) then
      exit;
    data := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, Flag or BASS_UNICODE);
    if data = 0 then
      data := BASS_WMA_StreamCreateFile(FALSE, PChar(FileName), 0, 0, Flag or BASS_UNICODE);
    if data = 0 then
      data := BASS_MIDI_StreamCreateFile(FALSE, PChar(FileName), 0, 0, Flag or BASS_UNICODE,0);
    if data = 0 then
      data := BASS_CD_StreamCreateFile( PChar(FileName), BASS_SAMPLE_FX or Flag or BASS_UNICODE);
    if data = 0 then
      data := BASS_APE_StreamCreateFile(FALSE, PChar(FileName), 0, 0, Flag or BASS_UNICODE);
    if data = 0 then
      data := BASS_FLAC_StreamCreateFile(FALSE, PChar(FileName), 0, 0, Flag or BASS_UNICODE or BASS_UNICODE);
    if data = 0 then
      data := BASS_ALAC_StreamCreateFile(FALSE, PChar(FileName), 0, 0, Flag or BASS_UNICODE);
    if data = 0 then
    data := BASS_AAC_StreamCreateFile(FALSE, PChar(FileName), 0, 0, Flag or BASS_UNICODE);
    if data = 0 then
    begin
      data := BASS_MusicLoad(FALSE, PChar(FileName), 0, 0, BASS_MUSIC_RAMP or BASS_MUSIC_PRESCAN or Flag or BASS_UNICODE, 44100);
      MUSICFlag := True;
    end;
    FromNet := false;
  end;
end;

Function GetStreamBitRate(Stream:Dword):integer;
var
  FloatLen: FLOAT;
  Length: Int64;
  len: DWORD;
begin
  Length:= 0;
  Length:= BASS_ChannelGetLength(Stream, BASS_POS_BYTE);
FloatLen:= BASS_ChannelBytes2Seconds(Stream, Length);
len:=BASS_StreamGetFilePosition(Stream, BASS_FILEPOS_END);
Result:= Round(len / (125 * FloatLen) );
if MUSICFlag then
result:=round(result/1000);
end;

Function GetInfoFromstream(data: DWord;GetIDTeg:boolean;Fn:string):TbaseInfo;
var
  Art,Titl:string;
  ChannelInfo: BASS_CHANNELINFO;
begin
Fn:=GetFileName(Fn);
BASS_ChannelGetInfo(data, ChannelInfo);
Result.BitRate :=GetStreamBitRate(data);
Result.Time := round(BASS_ChannelBytes2Seconds(data, BASS_ChannelGetLength(data, BASS_POS_BYTE)));
Result.SampleRate := ChannelInfo.freq;
if not MusicFlag then
begin
If GetIDTeg then
Begin
Art:= string(TAGS_Read(data, '%ARTI'));
Titl:=string(TAGS_Read(data, '%TITL'));
 if Art <> '' then
      Result.Name := Art
    else
      Result.Name := Copy(fn, 0, Pos('-', fn) - 1);
    if Result.Name = '' then
      Result.Name := 'Неизвестный артист ';
    Result.Name :=Result.Name + '- ';
    if Titl <> '' then
      Result.Name := Result.Name + Titl
    else
      Result.Name := Result.Name + Copy(fn, Pos('-', fn) + 1, Length(fn));
 if length(Pchar(Result.Name))=0 then
 Result.Name :=fn;
  end;
  end
  else
   Result.Name :=fn;
end;


function OpenFile(fileName: String): Boolean;
var
  CV: Float;
begin

  Result := False;
  IsCUEopen := False;
  if Stream <> 0 then
    BASS_ChannelGetAttribute(Stream, BASS_ATTRIB_VOL, CV);
  Stop(true);
  MUSICFlag := False;
    oFile := FileName;
  Open_stream(filename, Stream, 0, MUSICFlag);
  BASS_ChannelGetInfo(Stream, BassChannelInfo);
  if Stream <> 0 then
  begin
    Result := TRUE;
    if UseEQ then
      SetEQ(true);
    SetVolume(CurVol, GV);
  end;
end;

function OpenCue(Cuedat: TCueStruct): Boolean;
begin
  if (Cuedat.File_ <> CurCUE.File_) or ((not Cuedat.OneFile) or (not CurCue.OneFile) ) then
  begin
    Result := OpenFile(Cuedat.File_);
    if not Result then
      exit;
  end;
  if stream = 0 then
  begin
    Result := False;
    exit;
  end;
  if Cuedat.OneFile then
  begin
    BASS_ChannelPause(Stream);
    IsCUEopen := True;
    BASS_ChannelSetPosition(Stream, BASS_ChannelSeconds2Bytes
    (Stream, Cuedat.Index01), BASS_POS_BYTE);
    result := true;
  end;
  CurCue := CueDat;
  
end;

function OpenNetRadio(URL: String): Boolean;
begin
  ////MUST DO
end;

procedure Play;
begin
  Bass_ChannelPlay(Stream, False);
end;

procedure Pause(P: Boolean);
begin
  if p then
    BASS_ChannelPause(Stream)
  else
    Bass_ChannelPlay(Stream, False);
end;

procedure Stop(clear: boolean);
begin
  if not IsCUEopen then
  begin
    Bass_ChannelStop(Stream);
    if clear then
    begin
      BASS_StreamFree(Stream);
      if MUSICFlag then
        BASS_MusicFree(Stream);
      Stream := 0;
    end
    else
      SetPosition(0);
    CurCue.Length := 0;
    CurCue.Index01 := 0;
    CurCue.OneFile := False;
  end
  else
  begin
    BASS_ChannelPause(Stream);
    BASS_ChannelSetPosition(Stream, BASS_ChannelSeconds2Bytes
    (Stream, CurCue.Index01), BASS_POS_BYTE);
    CurCue.OneFile := False;
  end;
end;

function GetLength: Integer;
begin
  if IsCUEopen then
    Result := CurCue.Length
  else
    Result := round(BASS_ChannelBytes2Seconds(Stream, BASS_ChannelGetLength(Stream, BASS_POS_BYTE)));
end;

function GetBitRate: Integer;
begin
result:=GetStreamBitRate(stream);
end;

function GetFreq: Integer;
begin
  Result := BassChannelInfo.freq;
end;

function getCh: Integer;
begin
  Result := BassChannelInfo.chans;
end;

function GetPosition: Integer;
begin
  Result := round(BASS_ChannelBytes2Seconds(Stream, BASS_ChannelGetPosition(Stream, BASS_POS_BYTE)));
  if IsCUEopen then
    Result := Round((Result) - CurCue.Index01);
end;

function  GetdlLength: QWord;
begin
  Result := BASS_StreamGetFilePosition(Stream, BASS_FILEPOS_END);
end;

function  GetdlPos: QWord;
begin
  if FromNet then
    result := BASS_StreamGetFilePosition(Stream, BASS_FILEPOS_DOWNLOAD)
  else
    result := BASS_StreamGetFilePosition(Stream, BASS_FILEPOS_END);
end;


procedure SetVolume(Vol: Integer; GlobalVolume: Boolean);
begin
  CurVol := vol;
  if GlobalVolume then
  begin
    BASS_SetVolume(vol / 100);
    GV := True;
    if Stream <> 0 then
      BASS_ChannelSetAttribute(Stream, BASS_ATTRIB_VOL, 1);
  end
  else
  begin
    BASS_ChannelSetAttribute(Stream, BASS_ATTRIB_VOL, VOL / 100);
    GV := false;
  end;
end;

procedure SetPosition(Pos: Integer);
begin
  if IsCUEopen then
    Pos := Round((Pos + CurCue.Index01));
  BASS_ChannelSetPosition(Stream, BASS_ChannelSeconds2Bytes
    (Stream, Pos), BASS_POS_BYTE);
  
end;

function isPlayEnd: Boolean;
begin
  Result := False;
  if IsCUEopen then
  begin
    if (GetPosition >= GetLength) then
      Result := True;
  end
  else
  if BASS_ChannelGetLength(Stream, BASS_POS_BYTE) = BASS_ChannelGetPosition(Stream, BASS_POS_BYTE) then
    Result := True;
end;


procedure SetEQ(run: boolean);
var
  i: Integer;
begin
  if run then
  begin
    for i := 1 to 10 do
    begin
      EQ_HFX[i] := BASS_ChannelSetFX(Stream, BASS_FX_DX8_PARAMEQ, 1);
      EQ_Ef.fgain := EQ_Val[i];
      EQ_Ef.fCenter := EQ_FRQ[i];
      EQ_Ef.fBandwidth := EQ_BW[i];
      BASS_FXSetParameters(EQ_HFX[i], @EQ_Ef);
       end;
    UseEQ := True;
  end
  else
  begin
    for i := 1 to 10 do
    begin
      BASS_ChannelRemoveFX(Stream, EQ_HFX[i]);
      EQ_HFX[i] := 0;
    end;
    UseEQ := False;
  end;
  
end;

procedure SetEQval(num, val: Integer);
begin
  if (UseEQ) and (Stream <> 0) then
  begin
    BASS_FXGetParameters(EQ_HFX[num], @EQ_Ef);
    EQ_Ef.fgain := val - 15;
    BASS_FXSetParameters(EQ_HFX[num], @EQ_Ef);
  end;
  EQ_Val[num] := val - 15;
end;


function Get_Tegdata(filename: string): TBaseInfo;
var
  data: DWord;
  MUSICFlag: boolean;
begin
  Open_stream(filename, data, 0, MUSICFlag);
if Pos('://', filename) = 0 then
Begin
  Result:=GetInfoFromstream(data,false,filename);
  result.Name := GetFileName(filename);
  end
  else
  Result:=GetInfoFromstream(data,True,filename);
  BASS_StreamFree(data);
  if MUSICFlag then
  BASS_MusicFree(data);
end;

Function GetExtendedTag(filename: string):TExtTag;
var
  tmpstream: Dword;
  Format: String;
  TMPBassChannelInfo: BASS_CHANNELINFO;

begin
Format := ansilowercase(extractfileext(filename));
 Open_stream(filename, tmpstream, BASS_STREAM_DECODE, MUSICFlag);

  BASS_ChannelGetInfo(tmpstream, TMPBassChannelInfo);
  Result.title := string(TAGS_Read(tmpstream, '%TITL'));
  Result.artist := string(TAGS_Read(tmpstream, '%ARTI'));
  result.Album := string(TAGS_Read(tmpstream, '%ALBM'));
  Result.gener:=  string(TAGS_Read(tmpstream, '%GNRE'));
  Result.year :=  string(TAGS_Read(tmpstream, '%YEAR'));
   Result.comment :=  string(TAGS_Read(tmpstream, '%CMNT'));
  Result.BitRate :=GetStreamBitRate(tmpstream);
  Result.Time := round(BASS_ChannelBytes2Seconds(tmpstream, BASS_ChannelGetLength(tmpstream, BASS_POS_BYTE)));
  Result.SampleRate := TMPBassChannelInfo.freq;
    BASS_StreamFree(tmpstream);
  if MUSICFlag then
  BASS_MusicFree(tmpstream);
  tmpstream := 0;
end;

function Get_CurentTegdata(ReadIDtag:boolean;DefTitle:String): TBaseInfo;
Begin
Result:=GetInfoFromstream(stream,ReadIDtag,DefTitle);
end;


initialization
  FillChar(EQ_Val, 10, 0);

finalization
  BASS_Free;

end.