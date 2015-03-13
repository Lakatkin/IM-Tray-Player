unit DL_Core;

interface
uses
  Classes, IdHTTP, IdComponent, Windows, SysUtils, Forms;


type
TTaskStatus = (tsReady, tsError, tsLoad, tsLoading, tsStoped);
TTask = class(TObject)
  public
    LinkToFile    : String;
    FileName      : String;
    Directory     : String;
    TotalSize     : Integer;
    LoadSize      : Integer;
    StartPosition : Integer;
    EndPosition   : Integer;
    LastModified  : TDateTime;
    TimeBegin     : TDateTime;
    TimeEnd       : TDateTime;
    TimeTotal     : TDateTime;
    ScheduleOn    : Boolean;
    Speed         : Integer;
    Status        : TTaskStatus;
    ErrorText     : String;
end;

TGetFileHttp = class(TThread)
  public
    Item   : Integer;
    Reload : Boolean;

    constructor Create(CreateSuspended : Boolean; P : Pointer);

  private
    Data      : TTask;
    Tick      : Integer;
    StartSize : Integer;
    HTTP      : TIdHTTP;

    procedure onWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
      procedure OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure OnWorkEnd(Sender: TObject; AWorkMode: TWorkMode);

  protected
    procedure Execute; override;
end;

TGetOptionsHttp = class(TThread)
  public
    constructor Create(CreateSuspended : Boolean; P : Pointer);

  private
    Data : TTask;

  protected
    procedure Execute; override;
end;


// Class TLoadOne //

TLoadOne = class(TThread)
  public
  ResumeLoad:boolean;
    constructor Create(CreateSuspended : Boolean; P : Pointer);
  private
    Data : TTask;
  protected
    procedure Execute; override;
end;

///////////////////////////////
function GetFreeSpace(Disk : String) : Int64;
function BytesToText(Bytes : Integer) : String;
function GetTimeStr(Secs : Integer) : String;
function GetFileSizeAPI(const FileName: string): Int64;

implementation
//////////////utils///////////

function GetFileSizeAPI(const FileName: string): Int64;
var
  FindData: TWin32FindData;
  hFind: THandle;

begin

  Result := -1;

  hFind := FindFirstFile( PChar(FileName), FindData );

  if hFind <> INVALID_HANDLE_VALUE then
  begin
    try

      Windows.FindClose(hFind);
      if ( FindData.dwFileAttributes 
           and 
           FILE_ATTRIBUTE_DIRECTORY) = 0 then
        Result := FindData.nFileSizeLow;

    except
      Result := -1;
    end;
  end;

end;


function GetFreeSpace(Disk : String) : Int64;
var
  TotalBytes     : Int64;
  TotalFreeBytes : PLargeInteger;
  FreeBytesCall  : Int64;

begin

  New(TotalFreeBytes);

  try

    GetDiskFreeSpaceEx(PChar(Disk), FreeBytesCall, TotalBytes, TotalFreeBytes);;
    Result := TotalFreeBytes^;

  finally

    Dispose(TotalFreeBytes);
    
  end;

end;

function BytesToText(Bytes : integer) : String;
begin

  if Bytes div 1000 < 1 then Result := IntToStr(Bytes) + ' байт';

  if Bytes div 1000 >= 1 then Result := FloatToStrF(Bytes/1000, ffNumber, 18, 1) + '  б';

  if Bytes div 1000 >= 1000 then Result := FloatToStrF(Bytes/1000000, ffNumber, 18, 1) + ' ћб';

end;

function GetTimeStr(Secs : Integer) : String;

  function LeadingZero(N:Integer) : String;
  begin

    if N < 10 then Result := '0' + IntToStr(N) else Result := IntToStr(N);
    
  end;

var
  Hours, Mins : Integer;

begin

  Hours := Secs div 3600;
  Secs  := Secs - Hours * 3600;
  Mins  := Secs div 60;
  Secs  := Secs - Mins * 60;

  Result := LeadingZero(Hours) + ':' + LeadingZero(Mins) + ':' + LeadingZero(Secs);

end;

/////////////Classes//////////////////

constructor TGetFileHttp.Create(CreateSuspended : Boolean; P : Pointer);
begin

  Data := P;

  inherited Create(CreateSuspended);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.Execute;
var
  FileStream : TFileStream;

begin

  HTTP := TIdHTTP.Create(nil);

  if FileExists(Data.Directory + '\' + Data.FileName) then
  begin
      if (data.LoadSize>0) or (GetFileSizeAPI(Data.Directory + '\' + Data.FileName)>=Data.TotalSize)  then
      begin
    FileStream := TFileStream.Create(Data.Directory + '\' + Data.FileName, fmOpenReadWrite);
    FileStream.Position := FileStream.Size;
     end
     else
      FileStream := TFileStream.Create(Data.Directory + '\' + Data.FileName, fmCreate);
  end else
  begin

    FileStream := TFileStream.Create(Data.Directory + '\' + Data.FileName, fmCreate);

  end;

  HTTP.OnWork := OnWork;
  HTTP.OnWorkBegin := OnWorkBegin;
  HTTP.OnWorkEnd := OnWorkEnd;

{  if Options.HTTPVersion = hvHttp10 then HTTP.ProtocolVersion := pv1_0
  else HTTP.ProtocolVersion := pv1_1;

  if (Options.HTTPProxy.UseProxy) and (LocalAddress(Data.LinkToFile) = False) then
  begin

    HTTP.ProxyParams.ProxyServer := Options.HTTPProxy.Host;
    HTTP.ProxyParams.ProxyPort := Options.HTTPProxy.Port;
    HTTP.ProxyParams.ProxyUsername := Options.HTTPProxy.UserName;
    HTTP.ProxyParams.ProxyPassword := Options.HTTPProxy.Password;

  end;
            
  if Data.UseSpecial then
  begin

    HTTP.Port := Data.Port;

    HTTP.Request.Username := Data.Login;
    HTTP.Request.Password := Data.Password;

  end;  }

  HTTP.Request.ContentRangeStart := Data.LoadSize;
  HTTP.Request.ContentRangeEnd := Data.TotalSize;

///  HTTP.HandleRedirects := Options.Redirect;

  StartSize := Data.LoadSize;
  If FileStream.Position>=Data.TotalSize then
  Begin
  Data.Status:=tserror;
  end;
  try

    HTTP.Get(Data.LinkToFile, FileStream);

  except

    on E : Exception do
    begin

      Data.Status := tsError;
     { Data.ErrorText := E.Message;

      MessageBox(Application.Handle, PChar('ќшибка при загрузке файла.' + #13#10 + E.Message), PChar('Error'), MB_OK or MB_ICONERROR);
      }
    end;

  end;
  
  HTTP.Free;
  FileStream.Free;
  
end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.onWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
      var
  TickCount : Integer;
  Count     : Integer;

begin

  if AWorkMode = wmRead then
  begin

    Data.LoadSize := StartSize + AWorkCount;

    TickCount := GetTickCount;
    Count := (TickCount - Tick) div 1000;

    if (Data.LoadSize > 0) and (Count > 0) then Data.Speed := Data.LoadSize div Count;

  end;

  if Data.Status = tsStoped then HTTP.Disconnect;
  
end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
      begin
  if Data.Status= tserror then
  begin
  HTTP.Disconnect;
  exit;
  end;
  Tick := GetTickCount;
  Data.TimeBegin := Now;
  Data.Status := tsLoading;

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.OnWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin

  Data.TimeEnd := Now;
  Data.TimeTotal := Data.TimeBegin - Data.TimeEnd;

  if Data.Status <> tsStoped then Data.Status := tsLoad;

end;

constructor TGetOptionsHttp.Create(CreateSuspended : Boolean; P : Pointer);
begin

  Data := P;

  inherited Create(CreateSuspended);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetOptionsHttp.Execute;
var
  HTTP : TIdHTTP;

begin

  HTTP := TIdHTTP.Create(nil);

{  if (Options.HTTPProxy.UseProxy) and (LocalAddress(Data.LinkToFile) = False) then
  begin

    HTTP.ProxyParams.ProxyServer := Options.HTTPProxy.Host;
    HTTP.ProxyParams.ProxyPort := Options.HTTPProxy.Port;
    HTTP.ProxyParams.ProxyUsername := Options.HTTPProxy.UserName;
    HTTP.ProxyParams.ProxyPassword := Options.HTTPProxy.Password;

  end;

  if Data.UseSpecial then
  begin

    HTTP.Port := Data.Port;
    HTTP.Request.Username := Data.Login;
    HTTP.Request.Password := Data.Password;

  end;

  HTTP.HandleRedirects := Options.Redirect;     
  if Options.HTTPVersion = hvHttp10 then HTTP.ProtocolVersion := pv1_0 else HTTP.ProtocolVersion := pv1_1;
   }

  try

    HTTP.Head(Data.LinkToFile);

    Data.Status := tsReady;
    Data.ErrorText := 'ќшибок нет';

    Data.TotalSize := HTTP.Response.ContentLength;
    Data.LastModified := HTTP.Response.LastModified;

  except

    on E : Exception do
    begin

      Data.Status := tsError;
      Data.ErrorText := E.Message;

      Data.TotalSize := 0;
      Data.LastModified := 0;
     {
      MessageBox(Application.Handle, PChar('ќшибка при загрузке файла.' + #13#10 + E.Message), PChar('Error'), MB_OK or MB_ICONERROR);
      }
    end;

  end;

  HTTP.Free;
      {
  fMain.RefreshTasks;
  }
end;


constructor TLoadOne.Create(CreateSuspended : Boolean; P : Pointer);
begin
 Data:=P;
 inherited Create(CreateSuspended);
end;

procedure TLoadOne.Execute;
var
 ThreadHttp: TGetFileHttp;
 ThreadHttpOpt: TGetOptionsHttp;

  begin
   ThreadHttpOpt:=TGetOptionsHttp.Create(True, Data);
   ThreadHttpOpt.Priority:=tpNormal;
   ThreadHttpOpt.Resume;
   ThreadHttpOpt.WaitFor;
   ThreadHttpOpt.Free;
   if Data.Status=tsError
   then Exit;
   if (Data.TotalSize<0) and not (ResumeLoad)
   then Exit;
   if Data.TotalSize>0
   then
    begin
     if Data.TotalSize>GetFreeSpace(Data.Directory)
     then Exit;
    end;
   ThreadHttp:=TGetFileHttp.Create(true, Data);
   ThreadHttp.Priority:=tpNormal;
   ThreadHttp.Resume;
   ThreadHttp.WaitFor;
   ThreadHttp.Free;
  end;


end.
 