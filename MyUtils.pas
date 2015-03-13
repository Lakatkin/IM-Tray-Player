unit MyUtils;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Registry, Shellapi, FileCtrl, ComObj, ShlObj,
  ActiveX,menus,JPEG,IdHTTP,pngimage,GifImg,forms,dialogs;

  type
  TMenuList=array of TMenuItem;

   type
  TExternStream = class(TStream)
  protected
    FSource : IStream;
    procedure SetSize(const NewSize: Int64); override;
  public
    constructor Create(Source : IStream);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
  end;

function SelfPath: String;
function SkinPath: String;
function IconsPath: String;
function EQstylesPath: String;
function ModulesPath: String;
function PlayListPath: String;
Function DlDefPath: String;
function CachePath: String;
function GetFileName(s: string): String;
function DirDlg: String;
function GetFileNamefromLink(LinkFileName: string): string;
procedure ReadFolder(Path,mask: String; Strings: TstringList);
procedure TrimWorkingSet;
procedure SetStayTop(handle: HWND; left, top, Width, Height: Integer; StayOnTop: Boolean);
procedure FileAssociate(const Ext, progName: string; Icon: string = ''; ProgPath: string = '');
procedure FileUnAssociate(const Ext, progName:string);
function IsFileAssociate(Ext: String; progName: String): Boolean;
procedure SetAutorun(aProgTitle, aCmdLine: string);
function IsAutorun(aProgTitle, aCmdLine: String): Boolean;
procedure DelAutoRun(aProgTitle: string);
function CreateRgnFromBitmap(rgnBitmap: TBitmap; TransColor: TColor): HRGN;
function  GetNewFileName(Path,name,ext: string): string;
Function FilenameCut(s:String;Lim:Integer):String;
Function FileNameStd(s:String):String;
function Get_TempPath: String;
function ExtractFileNameEX(const FileName: string): string;
procedure CreatNewMenuItem(Menu:TMenuItem;Event:TNotifyEvent;SubMenu:TMenuItem;Name: String);
function IMG2BMP(Fl: String): TBitMap;
function GetInetFile (const fileURL, FileName: String): boolean;
function GetInetFileSize (const fileURL: String): integer;
function UrlEncode(Str: ansistring): ansistring;
function GetSpecialPath(CSIDL: word): string;
Function AddNum2Name(cur,Count:Integer):String;
procedure GoToForeground(Handle:HWND);
Function StrToNums(s:String):AnsiString;
Function NumsToStr(s:ansiString):string;


const
  WM_WNDUPDATE = WM_USER+4;
  AppName = 'IM Tray Player beta';

implementation



constructor TExternStream.Create(Source: IStream);
begin
  inherited Create;
  FSource := Source;
end;

destructor TExternStream.Destroy;
begin
  inherited;
end;

function TExternStream.Read(var Buffer; Count: Integer): Longint;
begin
  if FSource.Read(@Buffer, Count, @Result) <> S_OK
  then
    Result := 0;
end;
 
function TExternStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  FSource.Seek(Offset, byte(Origin), Result);
end;

procedure TExternStream.SetSize(const NewSize: Int64);
begin

end;

function TExternStream.Write(const Buffer; Count: Integer): Longint;
begin

end;

const
  { Supported file extensions in LowerCase }
  EXT_GIF = '.gif';
  EXT_JPG = '.jpg';
  EXT_JPEG = '.jpeg';
  EXT_PNG = '.png';
  EXT_ICO = '.ico';
  EXT_BMP = '.bmp';
  EXT_WMF = '.wmf';
  EXT_EMP = '.emf';

function Get_TempPath: String;
var
  lng: DWORD;
  thePath: string;
begin
  SetLength(thePath, MAX_PATH) ;
  lng := GetTempPath(MAX_PATH, PChar(thePath)) ;
  SetLength(thePath, lng) ;
  result:= thePath;
end;

function SelfPath: String;
begin
  Result := ExtractFilePath(paramstr(0));
end;

function SkinPath: String;
begin
  Result := SelfPath + 'Skins\';
  if not directoryexists(Result) then
    CreateDirectory(Pchar(Result), nil);
end;

function IconsPath: String;
begin
  Result := SelfPath + 'Skins\Icons\';
  if not directoryexists(Result) then
    CreateDirectory(Pchar(Result), nil);
end;

function EQstylesPath: String;
begin
  Result := SelfPath + 'EQStyles\';
  if not directoryexists(Result) then
    CreateDirectory(Pchar(Result), nil);
end;


function CachePath: String;
begin
  Result := SelfPath + 'Cache\';
  if not directoryexists(Result) then
    CreateDirectory(Pchar(Result), nil);
end;

Function DlDefPath: String;
Begin
 Result := GetSpecialPath($0d)+ '\VK Music';
  if not directoryexists(Result) then
    CreateDirectory(Pchar(Result), nil);

end;

function PlayListPath: String;
begin
  Result := SelfPath + 'PlayLists\';
  if not directoryexists(Result) then
    CreateDirectory(Pchar(Result), nil);
end;

function ModulesPath: String;
begin
  Result := SelfPath + 'Modules\';
end;

function GetFileName(s: string): String;
begin
  Result := Copy(ExtractFilenameEx(s), 1, length(ExtractFilenameEx(s)) - Length(ExtractFileExt(s)));
end;

procedure TrimWorkingSet;
var
  MainHandle: THandle;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
    SetProcessWorkingSetSize(MainHandle, DWORD(-1), DWORD(-1));
    CloseHandle(MainHandle);
  end;
end;

procedure SetStayTop(handle: HWND; left, top, Width, Height: Integer; StayOnTop: Boolean);
begin
  if StayOnTop then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height,
    SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end
  else
  begin
    SetWindowPos(Handle, HWND_NOTOPMOST, Left, Top, Width, Height,
    SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure FileAssociate(const Ext, progName: string; Icon: string = ''; ProgPath: string = '');
var r: TRegistry;
begin
  r:=TRegistry.Create;
  r.RootKey:=HKEY_CURRENT_USER;
  r.OpenKey('Software\Classes\.'+UpperCase(Ext),true);
  r.WriteString('',progName);
  r.CloseKey;
  r.OpenKey('Software\Classes\'+progName+'\shell\open\command',true);
  if ProgPath='' then
     r.WriteString('','"'+ParamStr(0)+'" "%1"')
  else
     r.WriteString('','"'+ProgPath+'" "%1"');
  r.CloseKey;

  if Icon<>'' then begin
    r.OpenKey('Software\Classes\'+progName+'\DefaultIcon',true);
    r.WriteString('',Icon);
    r.CloseKey;
  end;
  r.Free;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

procedure FileUnAssociate(const Ext, progName:string);
var r: TRegistry;
begin
  r:=TRegistry.Create;
  r.RootKey:=HKEY_CURRENT_USER; {
  if r.OpenKey('Software\Classes\'+progName,false) then begin
    r.CloseKey;
    r.DeleteKey('Software\Classes\'+progName);    
  end;       }
  if r.OpenKey('Software\Classes\.'+UpperCase(Ext),false) and
     (r.ReadString('') = progName) then begin
     r.CloseKey;
     r.DeleteKey('Software\Classes\.'+UpperCase(Ext));
  end;
  r.Free;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

function IsFileAssociate(Ext: String; progName: String): Boolean;
var
  reg: TRegistry;
begin
try
result:=false;
  reg := TRegistry.Create;
  if reg.OpenKey('Software\Classes\'+progName,false) then begin
  reg.CloseKey;
  if (reg.OpenKey('Software\Classes\.'+UpperCase(Ext),false)) and
     (reg.ReadString('') = progName) then begin
       reg.CloseKey;
    result := True
    end;
    end;

    finally
  reg.CloseKey;
  reg.Free;
  end;
end;

procedure SetAutorun(aProgTitle, aCmdLine: string);
var
  hReg:  TRegistry;
begin
try
  hReg := TRegIniFile.Create;
  hReg.RootKey := HKEY_CURRENT_USER;
  hReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', false);
  hReg.WriteString(aProgTitle, aCmdLine);
  finally
  hReg.CloseKey;
  hReg.Free;
  end;
end;

function IsAutorun(aProgTitle, aCmdLine: string): Boolean;
var
  hReg: TRegistry;
begin
try
  Result := False;
  hReg := TRegIniFile.Create;
  hReg.RootKey := HKEY_CURRENT_USER;
  hReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', false);
  if hReg.ValueExists(aProgTitle) then
    Result := (Pos(ExtractFileName(aCmdLine), hReg.ReadString(aProgTitle)) <> 0);
  finally
  hReg.CloseKey;
  hReg.Free;
  end;
end;

procedure DelAutoRun(aProgTitle: string);
var
  hReg: TRegistry;
begin
try
  hReg := TRegIniFile.Create;
  hReg.RootKey := HKEY_CURRENT_USER;
  hReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', false);
  hReg.DeleteValue(aProgTitle);
    finally
  hReg.CloseKey;
  hReg.Free;
   end;

end;

function DirDlg: String;
var
  Root, dir: string;
  pwRoot: PWideChar;
begin
  Root := '';
  GetMem(pwRoot, (Length(Root) + 1) * 2);
  pwRoot := StringToWideChar(Root, pwRoot, MAX_PATH * 2);
  if not SelectDirectory('Выберите папку', pwRoot, Dir) or (Dir = '') Then
  begin
    Result := '';
    Exit;
  end
  else
    Result := Dir + '\';
end;

procedure ReadFolder(Path,mask: String; Strings: TstringList);
var
  SearchRec: TSearchRec;
  FindResult: Integer;
  ext:string;
begin
  FindResult := FindFirst(Path + '*.*', faAnyFile, SearchRec);
  while FindResult = 0 do
  begin
    // Если найден подкаталог, рекурсивно читаем его содержимое
    // Не забываем игнорировать подкаталоги '.' и '..'
    with SearchRec do
      if (Name <> '.') and (Name <> '..') then
      begin
ext := '*' + ansistring(Lowercase(extractFileext(Path + Name))) + ';';
      if (Pos(ext, mask) <> 0) then
        Strings.Add(Path + Name);
        if (Attr and faDirectory <> 0) then
          ReadFolder(Path + Name + '\',mask, Strings);
      end;
    FindResult := FindNext(SearchRec);
        application.ProcessMessages;
  end;
  FindClose(SearchRec);
end;

function GetFileNamefromLink(LinkFileName: string): string;
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  FileInfo: TWin32FINDDATA;
  WidePath: array[0..MAX_PATH] of WideChar;
  Buff: array[0..MAX_PATH] of Char;
begin
  Result := '';
  if (fileexists(Linkfilename) = false) then
    exit;
  MyObject := CreateComObject(CLSID_ShellLink);
  MyPFile := MyObject as IPersistFile;
  MySLink := MyObject as IShellLink;
  StringToWideChar(LinkFileName, WidePath, sizeof(WidePath));
  MyPFile.Load(WidePath, STGM_READ);
  MySLink.GetPath(Buff, Max_PATH, FileInfo, SLGP_UNCPRIORITY);
  Result := buff;
end;

function CreateRgnFromBitmap(rgnBitmap: TBitmap; TransColor: TColor): HRGN;
var
  i, j: Integer;
  i_width, i_height: Integer;
  i_left, i_right: Integer;
  rectRgn: HRGN;
begin
  Result := 0;
  i_width := rgnBitmap.Width;
  i_height := rgnBitmap.Height;
  for i := 0 to i_height - 1 do
  begin
    i_left := -1;
    for j := 0 to i_width - 1 do
    begin
      if i_left < 0 then
      begin
        if rgnBitmap.Canvas.Pixels[j, i] <> transColor then
          i_left := j;
      end
      else
      if rgnBitmap.Canvas.Pixels[j, i] = transColor then
      begin
        i_right := j;
        rectRgn := CreateRectRgn(i_left, i, i_right, i + 1);
        if Result = 0 then
          Result := rectRgn
        else
        begin
          CombineRgn(Result, Result, rectRgn, RGN_OR);
          DeleteObject(rectRgn);
        end;
        i_left := -1;
      end;
    end;
    if i_left >= 0 then
    begin
      rectRgn := CreateRectRgn(i_left, i, i_width, i + 1);
      if Result = 0 then
        Result := rectRgn
      else
      begin
        CombineRgn(Result, Result, rectRgn, RGN_OR);
        DeleteObject(rectRgn);
      end;
    end;
  end;
end;

function  GetNewFileName(Path,name,ext: string): string;
var
  num: integer;
begin
    Result := Path +name;
    if not fileexists(result+ext) then
    exit;
    while fileexists(result+ext) do
    begin
      num := num + 1;
    Result := Path +name+ '(' + inttostr(num)+')';
    end;

end;

Function FileNameStd(s:String):String;
Const
Ch:array[1..10] of char=('\','/',':','?','*','"','<','>','|',#10);
Var
j:Integer;
Begin
For j:=1 to 10 do
begin
while pos(ch[j],s)<>0 do
begin
insert(' ',s,pos(ch[j],s));
delete(s,pos(ch[j],s),1);
end;
end;
Result:=s;
end;

Function FilenameCut(s:String;Lim:Integer):String;
Begin
While Length(s)>lim do
delete(s,Length(s),1);
Result:=s;
end;

function ExtractFileNameEX(const FileName: string): string;
var
  I: Integer;
begin
if Pos('://', FileName) = 0 then
Result:=ExtractFileName(FileName)
else
begin
  I := LastDelimiter('/' + DriveDelim, FileName);
  if pos('?',FileName)>0 then
     Result := Copy(FileName, I + 1, pos('?',FileName)- I + 1)
     else
  Result := Copy(FileName, I + 1, MaxInt);
  end;
end;

Procedure _AddSubMenu(Menu1,Menu2:TMenuItem);
var
i:integer;
tmp:TMenuItem;
Begin
For i:=0 to Menu1.Count-1 do
begin
tmp:=TMenuItem.Create(menu2);
tmp.Caption:=Menu1[i].Caption;
tmp.OnClick:= Menu1[i].OnClick;
Menu2.Add(tmp);
tmp:=nil;
end;
end;

procedure CreatNewMenuItem(Menu:TMenuItem;Event:TNotifyEvent;SubMenu:TMenuItem;Name: String);
var
  it: TMenuItem;
begin
  it := TMenuItem.Create(Menu);
  if assigned(event) then
  it.OnClick := Event;
  it.Caption := Name;
  if SubMenu<>nil then
  _AddSubMenu(SubMenu,it);
  Menu.Add(it);
  it:=nil;
end;

function GraphicClassByExt(fileExtName: WideString): TGraphicClass;
begin
  if (fileExtName = EXT_GIF) then
    Result := TGIFImage
  else if (fileExtName = EXT_JPG) then
    Result := TJPEGImage
  else if (fileExtName = EXT_JPEG) then
    Result := TJPEGImage
  else if (fileExtName = EXT_PNG) then
    Result := TPNGObject
  else if (fileExtName = EXT_BMP) then
    Result := Graphics.TBitmap
  else if (fileExtName = EXT_ICO) then
    Result := TIcon // TIcon
  else if (fileExtName = EXT_WMF) then
    Result := TMetafile
  else if (fileExtName = EXT_EMP) then
    Result := TMetafile
  else
    Result := nil;
end;

function CreateGraphicByExt(fileExtName: WideString): TGraphic;
const
  SUnknownExtension = 'Unknown picture file extension (.%s)';
var
  Ext: string;
  GraphicClass: TGraphicClass;
begin
  GraphicClass := GraphicClassByExt(fileExtName);
  if GraphicClass = nil then
  begin
    Ext := fileExtName;
    Delete(Ext, 1, 1);

    raise EInvalidGraphic.CreateFmt(SUnknownExtension, [Ext]);
  end;

  Result := GraphicClass.Create;
end;

function IMG2BMP(Fl: String): TBitMap;
var
  Load_image_PIC: TGraphic;
  BMP: TBitMap;
begin
  Load_image_PIC:=CreateGraphicByExt(LowerCase(ExtractFileExt(fl)));
  BMP := TBitMap.Create;
  Load_image_PIC.LoadFromFile(Fl);
  BMP.Assign(Load_image_PIC);
  Result := BMP;
  Load_image_PIC.Free;
end;


function GetInetFile (const fileURL, FileName: String): boolean;
 Var
 Http:TIdHTTP;
 FileStream : TFileStream;
 s:string;
   begin
      Result:=False;
   try
  s:='http'+Copy(fileURL,Pos(':',fileURL),length(fileURL));
   FileStream := TFileStream.Create(FileName, fmCreate);
     HTTP := TIdHTTP.Create(nil);
     HTTP.Get(s,FileStream);
       except
      FileStream.Free;
      HTTP.Free;
      exit;
       end;
       Result:=true;
      HTTP.Free;
      FileStream.Free;
       end;

function GetInetFileSize (const fileURL:string): integer;
 Var
 Http:TIdHTTP;
begin
HTTP := TIdHTTP.Create(nil);
HTTP.Head(fileURL);
if HTTP.Response.HasContentLength then
result:=HTTP.Response.ContentLength
else
result:=0;
HTTP.Free;
end;

function UrlEncode(Str: ansistring): ansistring;

function CharToHex(Ch: ansiChar): Integer;
  asm
    and eax, 0FFh
    mov ah, al
    shr al, 4
    and ah, 00fh
    cmp al, 00ah
    jl @@10
    sub al, 00ah
    add al, 041h
    jmp @@20
@@10:
    add al, 030h
@@20:
    cmp ah, 00ah
    jl @@30
    sub ah, 00ah
    add ah, 041h
    jmp @@40
@@30:
    add ah, 030h
@@40:
    shl eax, 8
    mov al, '%'
  end;

var
  i, Len: Integer;
  Ch: ansiChar;
  N: Integer;
  P: PansiChar;
begin
  Result := '';
  Len := Length(Str);
  P := PansiChar(@N);
  for i := 1 to Len do
  begin
    Ch := Str[i];
    if Ch in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then
      Result := Result + Ch
    else
    begin
      if Ch = ' ' then
        Result := Result + '+'
      else
      begin
        N := CharToHex(Ch);
        Result := Result + P;
      end;
    end;
  end;
end;

function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
 SetLength(s, MAX_PATH);
 if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
 then s := GetSpecialPath(CSIDL_APPDATA);
 result := PChar(s);
end;

Function AddNum2Name(cur,Count:Integer):String;
Const
MaxNull:string='000000';
Var
LocMaxNull:String;
Begin
LocMaxNull:=Copy(MaxNull,1,Length(Inttostr(count))-1);

Result:=Copy(LocMaxNull,1,Length(Inttostr(count))-Length(Inttostr(Cur)))+Inttostr(Cur)+'_';
end;

procedure GoToForeground(Handle:HWND);
var
  Info: TAnimationInfo;
  Animation: Boolean;
begin
  // Проверяем, включена ли анимация для окон
  Info.cbSize := SizeOf(TAnimationInfo);
  Animation := SystemParametersInfo(SPI_GETANIMATION, SizeOf(Info), @Info, 0) and
    (Info.iMinAnimate <> 0);
  // Если включена, отключаем, чтобы не было ненужного мерцания
  if Animation then
  begin
    Info.iMinAnimate := 0;
    SystemParametersInfo(SPI_SETANIMATION, SizeOf(Info), @Info, 0);
  end;
  // Если приложение не минимизировано, минимизируем
  if not IsIconic(Handle) then
  SendMessage(Handle, WM_SYSCOMMAND, SC_Minimize, 1);

  // Восстанавливаем приложение. При этом оно автоматически выводится
  // на передний план
  SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 1);

  // Если анимация окон была включена, снова включаем её
  if Animation then
  begin
    Info.iMinAnimate := 1;
    SystemParametersInfo(SPI_SETANIMATION, SizeOf(Info), @Info, 0);
  end;
end;


Function StrToNums(s:String):AnsiString;
var
i,len:integer;
s2:ansistring;
begin
len:=length(s);
s2:=intTostr(len)+'%';
For i:=1 to len do
s2:=s2+Inttostr(ord(s[i]))+'%';
result:=s2;
end;

Function NumsToStr(s:ansiString):string;
var
i,len:integer;
s2:string;
st:ansistring;
Function Pars:ansiString;
Begin
Result:=Copy(st,1,Pos('%',st)-1);
delete(st,1,Pos('%',st));
end;
begin
st:=s;
len:=(strToint(Pars));
For i:=1 to len do
begin
s2:=s2+chr(strToint(Pars));
end;
result:=s2;
end;

end.