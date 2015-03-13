unit ImgPlayList;
//////////////////////////////////////////
//                                      //
//     IMTrayPlayer Component LIB.      //
//       Graphics PlayList For          //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Forms, Messages, SysUtils, Variants, Classes, dialogs, Graphics,
  StdCtrls, controls,MyUtils;

type
  TPlayListFormat = (IMPL, M3U);
  TserchIn = (InList, InAdd);
  TScrollUpdt = procedure(ScrollPos: Integer)of object;

  ///Listheader
  TimPlayList = record
    Name: String;///InCue Comment/InVK NameOfOwner
    Artist: String;//InVK n/a
    Year: String; ///InCue n/a
    Label_: String; ///InCue Disc ID//InVK n/a
    Album: String; /// InCue Title//InVK albumName
    Genre: String; ///InCue n/a//InVK n/a
    Tracks: String;
  end;
  PTrackData = ^TTrackData;
  //ItemRecord
  TTrackData = record
    Name: String; //��������
    filename: String;//������ ����
    OrigName: string; //������������ ��� ��� �����
    time: Integer;   //�����������������
    Format: String; //������
    BitRate: Integer;//�������
    Freq: Integer;  // ������� ����.
    InBest: Boolean; // ��������� ����
    InfoUpdt: Boolean;// �� ��������� ���
    VKFlag: Boolean;//���. ����. VK
    CUEFlag: Boolean;//���. ����. CUE
    // VKDATA
    aid: String; ///id �������
    owner_id: String; ///id ���������
    Uploader_id: String; ///id ��������� �����
    lyrics_id: string; ///id ������ �����
    //CUEDATA
    Index01: String;
    Index00: String;
    OneFile: boolean;
  end;
  
   //PlayList Visual Info
  TTrackInfo = record
    Name: String;
    time: String;
    Format: String;
    BitRate: String;
    Freq: String;
  end;
  

  TImgPlayList = class(TListBox)
  private 
    FSelFontT, FNoSelFontT, FPlFontT, FSelFontD,
    FNoSelFontD, FPlFontD: TFont;
    FItemSel, FItemPL, FImgNR, FImgSL, FImgPL: TBitMap;
    FInfoList: TList;
    FVKList: TList;
    FBestList: TList;
    FPlayed: Integer;
    FListViewWndProc: TWndMethod;
    iCount: Integer;
    FScrollUpdate: TScrollUpdt;
    FSCRPosition: Integer;
    FStartingPoint: TPoint;
    FMouseIn: Boolean;
    FaddNum: Boolean;
    FhasCUE: boolean;
    RandCount: integer;
    FShowScroll:boolean;
    NoDClickL:boolean;
    FListCl:TnotifyEvent;
    procedure ItemPoint(canv: TCanvas; Bmp1, Gliph: TBitMap; Rect: TRect; heigth: integer);
    function BeautyStr(s: string; iLength: integer; Font: TFont): string;
    function ListData2Info(data: TTrackData): TTrackInfo;
    procedure TextOut2List(Font1, Font2: TFont;
 Canv: TCanvas; Rect: TRect; Info: TTrackInfo;
 imgW, TotalW, heigth, Num: Integer);
    procedure SetItemSel(const Value: TBitMap);
    procedure SetItemPL(const Value: TBitMap);
    procedure SetImgSL(const Value: TBitMap);
    procedure SetImgNR(const Value: TBitMap);
    procedure SetImgPL(const Value: TBitMap);
    procedure SetSelFontT(const Value: TFont);
    procedure SetNotSelFontT(const Value: TFont);
    procedure SetPLFontT(const Value: TFont);
    procedure SetSelFontD(const Value: TFont);
    procedure SetNotSelFontD(const Value: TFont);
    procedure SetPLFontD(const Value: TFont);
    procedure ListViewWndProc(var Msg: TMessage);
    procedure ResetItem(Index: Integer; Item: pTrackData);
    function FGetScrollInfo(index: integer): Integer;
    procedure SetScrollPos_(Value: Integer);
    function GetScrPos: Integer;
    function FGetItemsInRect: Integer;
    ///////////////////////////////////////////////////////////////
    function Get_ImPlItem(str: String): TTrackData;
    function ImPlItem2Str(data: TTrackData): String;
    function ImPlHeader2Str(data: TimPlayList): String;
    function ExtractFromTeg(var s: string; tag: String): String;
    function StrFiltr(s: String): String;
   ///////////////////////////////////////////////////////////////
  protected 
    procedure DrawItem(Index: Integer;
    Rect: TRect; State: TOwnerDrawState); override;
     { Protected declarations }
  public
     ListHeader:TimPlayList;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure AddItem_(Item: pTrackData);
    procedure DelItem_(ItemIndex_: Integer);
    function  GetItem_(Index: Integer): pTrackData;
    function  IMPL_GetHeader(filename: String): TimPlayList;
    procedure IMPL_Load(Filename: String; New: Boolean);
    function  IMPL_Save(Filename: String; Header: TimPlayList; Format: TPlayListFormat): Boolean;
    function  CUE_GetHeader(filename: String): TimPlayList;
    procedure CUE_Load(Filename: String; New: Boolean);
    procedure Clear; override;
    procedure MoveItem(CurIndex, NewIndex: Integer);
    procedure FastSerch(str: String; NewSerch: Boolean; Param: TserchIn);
    procedure DelAllUnclSel(ItemIndex: Integer);
    function CheckFileInList(f: String): boolean;
    procedure RegenList;
    procedure AddBest(ItemIndex: Integer);
    function RandomIncBest(i, rang: Integer): Integer;
    Procedure FillHeader(var ListHeader:TimPlayList);
    property DataItems[Index: Integer]: pTrackData read  GetItem_ write ResetItem; default;
    property VKLIST: TList read  FVKLIST write FVKLIST;
    Property ItemsInRectCount:integer read FGetItemsInRect;
    Property HasCUE:boolean read FHasCUE;
   published
     { Published declarations }
     Property PlayedIndex:integer read FPlayed Write FPlayed default -1;
     Property SelectItemBMP:TBitMap Read FItemSel Write SetItemSel;
     Property PlayItemBMP:TBitMap Read FItemPL Write SetItemPL;
     Property ItemImageNormBMP:TBitMap Read FImgNR Write SetImgNR;
     Property ItemImageSelectBMP:TBitMap Read FImgSL Write SetImgSL;
     Property ItemImagePlayBMP:TBitMap Read FImgPL Write SetImgPL;
     Property NormalItemTopFont:TFont Read FNoSelFontT  Write SetNotSelFontT;
     Property SelectItemTopFont:TFont Read FSelFontT  Write SetSelFontT;
     Property PlayItemTopFont:TFont Read FPLFontT  Write SetPLFontT;
     Property NormalItemDownFont:TFont Read FNoSelFontD  Write SetNotSelFontD;
     Property SelectItemDownFont:TFont Read FSelFontD  Write SetSelFontD;
     Property PlayItemDownFont:TFont Read FPLFontD  Write SetPLFontD;
     Property onUpdateScroll:TScrollUpdt read FScrollUpdate write FScrollUpdate;
     property onListClear:TnotifyEvent read FListCl  Write  FListCl;
     Property MaxScroll:Integer index 1 read FGetScrollinfo;
     Property MinScroll:Integer index 2 read FGetScrollinfo;
     Property PosScroll:Integer read GetScrPos  Write SetScrollPos_;
     Property AddNum:boolean read FAddNum Write FAddNum;
     Property ShowScroll:boolean read FShowScroll write FShowScroll;
   end;

procedure Register;
function CueTime2MiliSeconds(Time: String): Integer;
Function CopyItem(Item:PTrackData):PTrackData;

implementation

uses Sound_Engine;

procedure Register;
begin
  RegisterComponents('Samples', [TImgPlayList]);
end;

function CueTime2MiliSeconds(Time: String): Integer;
var
  Min, sec, msec: String;
  
  function getint(var s: string): string;
  begin
    Result := Copy(s, 1, Pos(':', s) - 1);
    Delete(s, 1, Pos(':', s));
  end;

begin
  Time := Time + ':';
  min := getint(time);
  sec := getint(time);
  msec := getint(time);
  Result := ((strToint(min) * 60000) +
 (strToint(sec) * 1000)) + (strToint(msec) * 10);
end;

Function CopyItem(Item:PTrackData):PTrackData;
Begin
New(Result);
With Item^ do
begin
Result^.Name:=Name;
Result^.filename:=filename;
Result^.OrigName:=OrigName;
Result^.time:=time;
Result^.Format:=Format;
Result^.BitRate:=BitRate;
Result^.Freq:=Freq;
Result^.InBest:=InBest;
Result^.InfoUpdt:=InfoUpdt;
Result^.VKFlag:=VKFlag;
Result^.CUEFlag:=CUEFlag;
Result^.aid:=aid;
Result^.owner_id:=owner_id;
Result^.Uploader_id:=Uploader_id;
Result^.lyrics_id:=lyrics_id;
Result^.Index01:=Index01;
Result^.Index00:=Index00;
Result^.OneFile:=OneFile;
end;
end;

procedure TImgPlayList.ListViewWndProc(var Msg: TMessage);
var
i : SmallInt;
param: integer;
begin
if not self.ShowScroll then
begin
 case Msg.Msg of
  WM_MOUSEWHEEL : // ��������� ��������� ��������� ���������
   begin
    i:= HiWord(Msg.WParam);
    //�������� ����������� ���������, � ����������� �� ����������� �������� �������� ����
    if i > 0 then
     param:= SB_LINEUP
    else
     param:= SB_LINEDOWN;

    Msg.WParam:= SendMessage(Handle,WM_VSCROLL,param,0); //��������� �� ���� ������
    sleep(30); // �������� ����� ����������
    Msg.WParam:= SendMessage(Handle,WM_VSCROLL,param,0); //��������� ��� �� ���� ������
   end; // WM_MOUSEWHEEL
   end;
end;
  if (Icount > 1) and (not FShowScroll) then
  begin
    ShowScrollBar(Self.Handle, SB_HORZ, False);
    ShowScrollBar(Self.Handle, SB_VERT, False);
  end;
  FListViewWndProc(Msg);
end;


function TImgPlayList.BeautyStr(s: string; iLength: integer; Font: TFont): string;
var
  bm: TBitmap;
  sResult: string;
  iStrLen: integer;
  bAdd: boolean;
begin
  Result := s;
  if Trim(s) = '' then
    exit;
  bAdd := false;
  sResult := s;
  bm := TBitmap.Create;
  bm.Width := iLength;
  bm.Height := 100;
  bm.Canvas.Font.Assign(Font);
  iStrLen := bm.Canvas.TextWidth(sResult);
  while iStrLen > iLength do
  begin
    if Length(sResult) < 4 then
      break;
    Delete(sResult, Length(sResult) - 2, 3);
    bAdd := true;
    iStrLen := bm.Canvas.TextWidth(sResult);
  end;
  if (iStrLen <= iLength) and bAdd then
    sResult := sResult + '...';
  bm.Free;
  Result := sResult;
end;

procedure TImgPlayList.ItemPoint(canv: TCanvas; Bmp1, Gliph: TBitMap; Rect: TRect; heigth: integer);
var
  Source, Dest: TRect;
begin
  with Canv do
  begin
    SetRect(Source, 0, 0, 2, heigth);
    SetRect(Dest, 0, Rect.Top, 2, Rect.Bottom);
    CopyRect(Dest, Gliph.Canvas, Source);
    SetRect(Source, 3, 0, 18, heigth);
    SetRect(Dest, 2, Rect.Top, Rect.Right - 2, Rect.Bottom);
    CopyRect(Dest, Gliph.Canvas, Source);
    SetRect(Source, 18, 0, 20, heigth);
    SetRect(Dest, Rect.Right - 2, Rect.Top, Rect.Right, Rect.Bottom);
    CopyRect(Dest, Gliph.Canvas, Source);
    SetBkMode(Handle, TRANSPARENT);
    Draw(Rect.Left, Rect.Top, Bmp1);

  end;
end;

procedure TImgPlayList.TextOut2List(Font1, Font2: TFont;
Canv: TCanvas; Rect: TRect; Info: TTrackInfo;
imgW, TotalW, heigth, num: Integer);
var
  WidthTime, LengthName: Integer;
  CutName: String;
begin
  with Canv do
  begin
    Font.Assign(Font1);
    if FaddNum then
      Info.Name := inttostr(num) + '.' + Info.Name;
    LengthName := TextWidth(Info.Name);
    WidthTime := TextWidth(Info.time);
    if FShowScroll then
    totalW:=totalW-18;
    if  LengthName > (totalW - (WidthTime + ImgW + 15)) then
      CutName := BeautyStr(info.Name, (totalW - (WidthTime + ImgW + 15)), font)
    else
      CutName := Info.Name;
    TextOut(Rect.Left + ImgW, Rect.Top, CutName);
    TextOut(TotalW - (WidthTime ), Rect.Top, Info.Time );
    Font.Assign(Font2);
    TextOut(Rect.Left + ImgW, Rect.Top + (heigth div 2), '.::' + Info.Format + '::. ' + Info.Freq + ' KHz ' + Info.BitRate + ' Kbps');
  end;
end;

function TImgPlayList.ListData2Info(data: TTrackData): TTrackInfo;
var
  FormatSTR: String;
begin
  Result.Name := data.Name;
  Result.Format := data.Format;
  if data.time < 3600 then
    FormatSTR := 'nn:ss '
  else
    FormatSTR := 'hh:nn:ss';
  Result.time := FormatDateTime(FormatSTR, data.time / (24 * 60 * 60));
  if data.BitRate = 0 then
    Result.BitRate := 'n/a'
  else
    Result.BitRate := InttoStr(data.BitRate);
  if data.Freq = 0 then
    Result.Freq := 'n/a'
  else
    Result.Freq := sysUtils.FloatToStr(data.Freq / 1000);
end;

constructor TImgPlayList.Create;
begin
inherited Create(AOwner);
  FSelFontT := TFont.Create;
  FNoSelFontT := TFont.Create;
  FPLFontT := TFont.Create;
  FSelFontD := TFont.Create;
  FNoSelFontD := TFont.Create;
  FPLFontD := TFont.Create;
  FItemSel := TBitMap.Create;
  FItemPL := TBitMap.Create;
  FImgNR := TBitMap.Create;
  FImgSL := TBitMap.Create;
  FImgPL := TBitMap.Create;
  FInfoList := TList.Create;
  FVKList := TList.Create;
  FBestList := TList.Create;
  BorderStyle := bsNone;
  FPlayed := -1;
  iCount := -1;
  Self.Style := lbOwnerDrawFixed;
  FListViewWndProc := Self.WindowProc;
  Self.WindowProc := ListViewWndProc;
  FHasCUE := false;
  RandCount := 0;
  FillHeader(ListHeader);
end;

destructor TImgPlayList.Destroy;
begin
  FSelFontT.Free;
  FNoSelFontT.Free;
  FPLFontT.Free;
  FSelFontD.Free;
  FNoSelFontD.Free;
  FPLFontD.Free;
  FItemSel.Free;
  FItemPL.Free;
  FImgNR.Free;
  FImgSL.Free;
  FImgPL.Free;
  FInfoList.Free;
  FVKList.Free;
  FBestList.Free;
  inherited Destroy;
end;


////////////////////////////////////////////////////////////////////////////////
procedure TImgPlayList.SetItemSel(const Value: TBitMap);
begin
  FItemSel.Assign(Value);
end;

procedure TImgPlayList.SetItemPL(const Value: TBitMap);
begin
  FItempl.Assign(Value);
end;

procedure TImgPlayList.SetImgSL(const Value: TBitMap);
begin
  FImgSL.Assign(Value);
end;

procedure TImgPlayList.SetImgNR(const Value: TBitMap);
begin
  FImgNR.Assign(Value);
end;

procedure TImgPlayList.SetImgPL(const Value: TBitMap);
begin
  FImgPL.Assign(Value);
end;

procedure TImgPlayList.SetSelFontT(const Value: TFont);
begin
  FSelFontT.Assign(Value);
end;

procedure TImgPlayList.SetNotSelFontT(const Value: TFont);
begin
  FNoSelFontT.Assign(Value);
end;

procedure TImgPlayList.SetPLFontT(const Value: TFont);
begin
  FPLFontT.Assign(Value);
end;

procedure TImgPlayList.SetSelFontD(const Value: TFont);
begin
  FSelFontD.Assign(Value);
end;

procedure TImgPlayList.SetNotSelFontD(const Value: TFont);
begin
  FNoSelFontD.Assign(Value);
end;

procedure TImgPlayList.SetPLFontD(const Value: TFont);
begin
  FPLFontD.Assign(Value);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TImgPlayList.AddItem_(Item: pTrackData);
begin
  if (not FHasCUE) and item^.CUEFlag then
    FHasCUE := true;
  if Item^.VKFlag then
    FVKList.Add(Item);
    FInfoList.Add(Item);
  if Item^.InBest then
    FBestList.Add(Item);  { }
  self.Items.Add('_');
  ICount := FInfoList.Count;
  ListHeader.Tracks:=Inttostr(FInfoList.Count);
end;

procedure TImgPlayList.ResetItem(Index: Integer; Item: pTrackData);
begin
  FInfoList[Index] := Item;
  self.Items[Index] := Item^.Name;
end;

procedure TImgPlayList.DelItem_(ItemIndex_: Integer);
var
  p: pTrackData;
begin
  if (self.Count <= 0) or (ItemIndex_ < 0) then
    exit;       {         }
  Self.Items.Delete(ItemIndex_);
  if (PlayedIndex>-1) and (PlayedIndex<Count) then
  p := FinfoList[PlayedIndex];
  if Ttrackdata(FInfoList[ItemIndex_]^).VKFlag then
    FVKList.Delete(FVkList.IndexOf(FInfoList[ItemIndex_]));
 if Ttrackdata(FInfoList[ItemIndex_]^).InBest then
    FBestList.Delete(FBestList.IndexOf(FInfoList[ItemIndex_]));
  dispose(FInfoList[ItemIndex_]);
  FInfoList.Delete(ItemIndex_);
    if (PlayedIndex>-1) and (PlayedIndex<Count) then
    begin
  if ItemIndex_ = PlayedIndex then
    PlayedIndex := ItemIndex_ - 1
  else
    PlayedIndex := FinfoList.IndexOf(p);
    end;
  if Count=0 then
  Clear;
  
end;

procedure TImgPlayList.DelAllUnclSel(ItemIndex: Integer);
var
  TmpDat: pTrackdata;
  TMPStr: String;
begin
  if (self.Count <= 0) or (ItemIndex < 0) then
    exit;
  TmpDat := Self.DataItems[ItemIndex];
  inherited Clear;
  FInfoList.Clear;
  if not Tmpdat^.CUEFlag then
    FHasCUE := False;
  AddItem_(TmpDat);
  TmpDat := nil;
  if ItemIndex = PlayedIndex then
    PlayedIndex := 0
  else
    PlayedIndex := -1;
  self.ItemIndex := 0;
end;

function  TImgPlayList.GetItem_(Index: Integer): pTrackData;
begin
  if (index < 0) or (Self.Count < 1) or (Index > self.Count - 1) then
    exit;
  Result := PTrackData(FInfoList[Index]);
end;

procedure TImgPlayList.Clear;
var
  i: integer;
begin
  inherited;
 if  assigned(FListCl) then
   FListCl(self);
  for i := 0 to FinFolist.Count - 1 do
    Dispose(finfoList[i]);
  FInfoList.Clear;
  FVKList.Clear;
  FBestList.Clear;
  PlayedIndex := -1;
  FHasCUE := False;
  FillHeader(ListHeader);
end;

procedure TImgPlayList.MoveItem(CurIndex, NewIndex: Integer);
var
  Cp: pTrackdata;
begin
  try
    cp := self.DataItems[PlayedIndex];
    Items.Move(CurIndex, NewIndex);
    FInfoList.Move(CurIndex, NewIndex);
    PlayedIndex := FInfoList.IndexOf(cp);
    repaint;
  except
end;
end;


procedure TImgPlayList.DrawItem(Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
begin
try
inherited;
  Self.ItemHeight := FItemSel.Height;
  if (odSelected in State)  then
begin
    ItemPoint(Canvas, FImgSL, FItemSel, rect, self.ItemHeight);
    TextOut2List(FSelFontT, FSelFontD, Canvas, rect, ListData2Info(Self.GetItem_(Index)^), FImgNR.Width, Width, ItemHeight, Index + 1);
  end
  else
  begin
    with Canvas do
    begin
      Brush.Color := Self.Color;
      FillRect(Rect);
      Draw(Rect.Left, Rect.Top, FImgNR);
      TextOut2List(FnoSelFontT, FnoSelFontD, Canvas, rect,
      ListData2Info(Self.GetItem_(Index)^), FImgNR.Width, Width, ItemHeight, Index + 1);
    end;
  end;
  if (Index = FPlayed) and (FPlayed <> -1) then
  begin
    ItemPoint(Canvas, FImgPL, FItemPL, rect,ItemHeight);
    TextOut2List(FPLFontT, FPLFontD, Canvas, rect, ListData2Info(Self.GetItem_(Index)^), FImgNR.Width, Width, ItemHeight, Index + 1);
  end;
  if assigned(FScrollUpdate) and (not FShowScroll) then
    FScrollUpdate(GetScrollPos(Handle, SB_VERT));
    except on EAccessViolation do
    end;

end;

function TImgPlayList.GetScrPos: Integer;
begin
  result := GetScrollPos(Handle, SB_VERT);
end;

function TImgPlayList.FGetScrollInfo(index: integer): Integer;
begin
  case index of
    1: Result := Self.Count - ((Self.Height div self.FItemSel.Height));
    2: Result := 0;
  end; 
end;

function TImgPlayList.FGetItemsInRect: Integer;
begin
  Result := Round(self.Height / Self.ItemHeight);
end;

procedure TImgPlayList.SetScrollPos_(Value: Integer );
var
  FOldPos, i: Integer;
  ScrMessage: TWMVScroll;
  Message_: Integer;
begin
  FOldPos := FSCRPosition;
  FSCRPosition := Value;
  if FOldPos = FSCRPosition then
    exit;
  if FSCRPosition = 1 then
    Message_ := SB_TOP
  else
    Message_ := SB_THUMBTRACK;
  SetScrollPos(Handle, SB_VERT, FSCRPosition, true);
  ScrMessage.Msg := WM_VScroll;
  ScrMessage.Pos := GetScrollPos(Handle, SB_VERT);
  ScrMessage.ScrollCode := Message_;
  self.Dispatch(ScrMessage);
end;

function TImgPlayList.ExtractFromTeg(var s: string; tag: String): String;
var
  ps, pe, pt, len: integer;
  Stg: String;
begin
  tag := LowerCase(tag);
  Stg := LowerCase(s);
  ps := 0;
  Pe := 0;
  len := 0;
  pt := 0;
  ps := Pos(tag, Stg);
  if ps <> 0 then
  begin
    pe := Pos('*', Stg);
    if pe = 0 then
      pe := Pos('}', Stg);
    if pe = 0 then
      pe := Pos('>', Stg);
    if pe = 0 then
    begin
      result := '';
      exit;
    end;
    Pt := Ps + Length(tag);
    len := pe - pt;
    Result := Copy(s, pt, len);
    Delete(s, ps, (pe - ps) + 1);
  end
  else
    Result := '';
end;

function  TImgPlayList.StrFiltr(s: String): String;
const
  Ch: array[1..5] of char = ('*', '<', '>', '{', '}');

var
  i, j: Integer;
begin
  for i := 1 to length(s) do
  begin
    for j := 1 to 5 do
      if s[i] = ch[j] then
        s[i] := '_';
  end;
  Result := s;
end;

function TImgPlayList.Get_ImPlItem(Str: String): TTrackData;
begin
  Result.filename := ExtractFromTeg(str, 'File=');
  Result.Name := ExtractFromTeg(str, 'Name=');
  result.OrigName:=ExtractFromTeg(str, 'OrgName=');
  try
    Result.time := StrToint(ExtractFromTeg(str, 'Time='));
  except
    Result. time := 0;
  end;
  Result.Format := ExtractFromTeg(str, 'Format=');
  try
    Result.BitRate := StrToint(ExtractFromTeg(str, 'BitRate='));
  except
    Result. BitRate := 0;
  end;
  try
    Result.Freq := StrToint(ExtractFromTeg(str, 'Freq='));
  except
    Result. Freq := 0;
  end;
  if ExtractFromTeg(str, 'BestFlag=') = '1' then
    Result.InBest := true
  else
    Result.InBest := False;
  if ExtractFromTeg(str, 'UpdateFlag=') = '1' then
    Result.InfoUpdt := true
  else
    Result.InfoUpdt := False;
  if ExtractFromTeg(str, 'VKFlag=') = '1' then
  begin
    Result.VKFlag := True;
    Result.aid := ExtractFromTeg(str, 'aid=');
    Result.owner_id := ExtractFromTeg(str, 'owner_id=');
    Result.Uploader_id := ExtractFromTeg(str, 'Uploader_id=');
    Result.lyrics_id := ExtractFromTeg(str, 'lyrics_id=');
  end
  else
    Result.VKFlag := False;
  if ExtractFromTeg(str, 'CUEFlag=') = '1' then
  begin
    Result.CUEFlag := True;
    if ExtractFromTeg(str, 'OneFile=') = '1' then
      Result.OneFile := true
    else
      Result.OneFile := False;
    Result.Index01 := ExtractFromTeg(str, 'Index01=');
    Result.Index00 := ExtractFromTeg(str, 'Index00=');
  end
  else
    Result.CUEFlag := False;
end;

function TImgPlayList.ImPlHeader2Str(data: TimPlayList): String;
begin
  result := 'ImPlayListHeader{' + 'Name=' + StrFiltr(data.Name) + '*Artist=' + StrFiltr(data.Artist) + '*Year=' + StrFiltr(data.Year) +
  '*Label=' + StrFiltr(data.Label_) + '*Album=' + StrFiltr(data.Album) + '*Genre=' + StrFiltr(data.Genre) + '*Tracks=' + (data.Tracks) + '}';
end;

function TImgPlayList.ImPlItem2Str(data: TTrackData): String;
begin
  result := '<File=' + data.filename + '*Name=' + StrFiltr(data.Name) + '*OrgName=' + StrFiltr(data.OrigName) +'*Time=' + Inttostr(data.time) +
  '*Format=' + data.Format + '*BitRate=' + Inttostr(data.BitRate) + '*Freq=' + Inttostr(data.Freq);
  if data.InBest then
    result := result + '*BestFlag=1'
  else
    result := result + '*BestFlag=0';
  if data.InfoUpdt then
    result := result + '*UpdateFlag=1'
  else
    result := result + '*UpdateFlag=0';
  if data.VkFlag then
  begin
    result := result + '*VKFlag=1' + '*aid=' + data.aid + '*owner_id=' + data.owner_id +
    '*Uploader_id=' + data.Uploader_id + '*lyrics_id=' + data.lyrics_id;
  end
  else
    result := result + '*VKFlag=0';
  if data.CUEFlag then
  begin
    result := result + '*CUEFlag=1';
    if  data.OneFile then
      result := result + '*OneFile=1'
    else
      result := result + '*OneFile=0';
    result := result + '*Index01=' + data.Index01 + '*Index00=' + data.Index00 + '>';
  end
  else
    result := result + '*CUEFlag=0>';
end;

function TImgPlayList.IMPL_GetHeader(filename: String): TimPlayList;
var
  f: TStringList;
  s, stg,val: string;
  i:integer;
begin
  self.FillHeader(result);
  if not fileexists(filename) then
    exit;
     f:=TStringList.Create;
  f.LoadFromFile(FileName);
  s := '';
  i:=0;
  while (Pos('implaylistheader', stg) = 0)  and (i<=f.Count-1)  do
  begin
    s:=f[i];
    stg := LowerCase(s);
    i:=i+1;
  end;
  val:= ExtractFromTeg(s, 'Name=');
  if val<>''then
  Result.Name:=val;
    val:= ExtractFromTeg(s, 'Artist=');
  if val<>''then
  Result.Artist:=val;
    val:= ExtractFromTeg(s, 'Year=');
  if val<>''then
  Result.Year := val;
    val:=   ExtractFromTeg(s, 'Label=');
    if val<>''then
  Result.Label_ := val;
    val:= ExtractFromTeg(s, 'Album=');
  if val<>''then
   Result.Album :=val;
    val:=ExtractFromTeg(s, 'Genre=');
  if val<>''then
   Result.Genre:=val;
   Val:=ExtractFromTeg(s, 'Tracks=');
    if val<>''then
 Result.Tracks := val;
 f.Free;
end;

procedure TImgPlayList.AddBest(ItemIndex: Integer);
begin
  if self.DataItems[ItemIndex]^.InBest then
    FBestList.Add(DataItems[ItemIndex])
  else
    FBestList.Delete(FBestList.IndexOf(DataItems[ItemIndex]));
end;

procedure TImgPlayList.IMPL_Load(Filename: String; New: Boolean);
var
  s, Stg: String;
  f: TStringList;
  NItemdat: PTrackData;
  i:integer;
begin
  if ansistring(Lowercase(extractFileext(Filename))) = '.cue' then
  begin
    Self.CUE_Load(Filename, New);
    exit;
  end;
  if New then
  begin
    self.PlayedIndex := -1;
    Self.Clear;
  end;
  if not fileexists(FileName) then
    exit;
  f:=TStringList.Create;
  f.LoadFromFile(FileName);
  s := '';
  i:=0;
  while (Pos('tracklist', s) = 0) and  (i<=f.Count-1) do
  begin
    s:=f[i];
    s := LowerCase(s);
    i:=i+1;
  end;
  if (Pos('tracklist', s) <> 0) then
  begin
  ListHeader:=IMPL_GetHeader(FileName);
    while (i<=f.Count-1) do
    begin
     s:=f[i];
      stg := LowerCase(s);
      Application.ProcessMessages;
      if Pos('file', stg) <> 0 then
      begin
        System.New(NItemdat);
        with Get_ImPlItem(s) do
        begin
          Nitemdat^.Name := Name;
          Nitemdat^.filename := filename;
          Nitemdat^.OrigName := OrigName;
          Nitemdat^.time := time;
          Nitemdat^.Format := Format;
          Nitemdat^.BitRate := BitRate;
          Nitemdat^.Freq := Freq;
          Nitemdat^.InBest := InBest;
          Nitemdat^.aid := aid;
          Nitemdat^.owner_id := owner_id;
          Nitemdat^.Uploader_id := Uploader_id;
          Nitemdat^.lyrics_id := lyrics_id;
          NItemdat^.CUEFlag := CUEFlag;
          NItemdat^.VKFlag := VKFlag;
          NItemdat^.InfoUpdt := InfoUpdt;
          NItemdat^.Index01 := Index01;
          NItemdat^.Index00 := Index00;
          NItemdat^.OneFile := OneFile;
        end;
        self.AddItem_(Nitemdat);
      end;
   i:=i+1;
    end;
  end
  else
  if ansilowercase(ExtractFileExt(FileName)) = '.m3u' then
  begin
    i:=0;
   while (i<=f.Count-1) do
    begin
       s:=f[i];
      s := trim(s);
      Application.ProcessMessages;
      if uppercase(copy(s, 0, 7)) = '#EXTINF' then
      begin
        System.New(NItemdat);
        try
          NItemdat^.time := strToint(Copy(s, Pos(':', s) + 1, (Pos(',', s) - (Pos(':', s) + 1))));
        except
          NItemdat. time := 0;
        end;
        NItemdat^.Name := Copy(s, Pos(',', s) + 1, Length(s));
        NItemdat^.BitRate := 0;
        NItemdat^.Freq := 0;
        NItemdat^.InBest := False;
        NItemdat^.CUEFlag := False;
        NItemdat^.VKFlag := False;
        NItemdat^.InfoUpdt := True;
      end
      else
      if not assigned(NItemdat) then
      begin
        System.New(NItemdat);
        NItemdat^.time := 0;
        NItemdat^.BitRate := 0;
        NItemdat^.Freq := 0;
        NItemdat^.InBest := False;
        NItemdat^.CUEFlag := False;
        NItemdat^.VKFlag := False;
        NItemdat^.InfoUpdt := True;
      end;
      if uppercase(copy(s, 0, 1)) <> '#' then
      begin
        if (ansilowercase(Copy(s, 2, 2)) = ':\') or (ansilowercase(Copy(s, 1, 7)) = 'http://') then
          NItemdat^.filename := s
        else
          NItemdat^.filename := (ExtractFilePath(FileName) + s);
        if NItemdat^.Name = '' then
          NItemdat^.Name := ExtractFileNameEX(s);
          NItemdat^.OrigName:=NItemdat^.Name;

        NItemdat^.Format := UpperCase(Copy(ExtractFileEXT(s), 2, Length(s)));
        Self.AddItem_(NItemdat);
        NItemdat := nil;
      end;
             i:=i+1;
    end;
  end;
 f.Free;
end;


function  TImgPlayList.IMPL_Save(Filename: String; Header: TimPlayList; Format: TPlayListFormat): Boolean;
var
f: TStringList;
  I: Integer;
  CurItem: PTrackData;
begin
  f:=TStringList.Create;
if Format = IMPL then
  begin
    f.Add(ImPlHeader2Str(Header));
    f.Add('Tracklist{');
    for I := 0 to Self.Count - 1 do
    begin
      Application.ProcessMessages;
      CurItem := self[i];
      f.Add(Self.ImPlItem2Str(CurItem^))
    end;
    f.Add('}');
  end;
  if Format = M3U then
  begin
    f.Add('#EXTM3U');
    for I := 0 To Self.Count - 1 Do
    begin
      CurItem := self[i];
      f.Add('#EXTINF:' + Inttostr(CurItem^.time) + ',' + CurItem^.Name);
      f.Add(CurItem.filename);
    end;
  end;
    try
    f.SaveToFile(Filename,TEncoding.Unicode);
  except

  end;
  f.Free;
  result := true;
end;

function  TImgPlayList.CUE_GetHeader(filename: String): TimPlayList;
var
f: TStringList;
  ps: Integer;
  s: string;
  i:integer;
begin
FillHeader(Result);
  f:=TStringList.Create;
  f.LoadFromFile(FileName);
 i:=0;
   while (i<=f.Count-1) do
    begin
       s:=f[i];
    {Read CUE Header}
    {ps := Pos('REM DISCID', s);
    if ps <> 0 then
      result.Label_ := Copy(s, Pos('REM DISCID', s) + Length('REM DISCID '), Length(s) - Length('REM DISCID'));
  }ps := Pos('REM GENRE', s);
    if ps <> 0 then
    result.Genre:= Copy(s, Pos('REM GENRE', s) + Length('REM GENRE '), Length(s) - Length('REM GENRE'));
    ps := Pos('REM DATE', s);
    if ps <> 0 then
    result.Year:= Copy(s, Pos('REM DATE', s) + Length('REM DATE '), Length(s) - Length('REM DATE'));
    Ps := Pos('REM COMMENT', s);
    if ps <> 0 then
    begin
      delete(s, 1, Pos('"', s));
      result.Label_ :=Copy(s, 1, Pos('"', s) - 1);
    end;
    Ps := Pos('PERFORMER', s);
    if ps <> 0 then
    begin
      delete(s, 1, Pos('"', s));
      result.Artist := Copy(s, 1, Pos('"', s) - 1);
    end;
    Ps := Pos('TITLE', s);
    if ps <> 0 then
    begin
      delete(s, 1, Pos('"', s));
      result.Album := Copy(s, 1, Pos('"', s) - 1);
    end;

    if pos('TRACK', s) <> 0 then
      break;
      i:=i+1;
  end;
    Result.Name:=Result.Artist+'- '+Result.Album;
  f.Free;
end;

procedure TImgPlayList.CUE_Load(Filename: String; New: Boolean);
var
f: TStringList;
  s: String;
  title, artist, time, time_, File_T, File_O: String;
  endHeader, isname, isartist, isTime, OneFile: Boolean;
  ps, CueListCount: Integer;
  StartaddItem, i: Integer;
  NItemdat: PTrackData;
begin
  f:=TStringList.Create;
  f.LoadFromFile(FileName);
  if new then
  begin
  self.PlayedIndex:=-1;
    Self.Clear;
    ListHeader:=CUE_GetHeader(FileName);
  end;
  CueListCount := 0;
  isname := False;
  isartist := False;
  istime := False;
  File_T := '';
  File_O := '';
  OneFile := True;
  i:=0;
  while (Pos('FILE', s) = 0) and (i<=f.Count-1)  do
  begin
    s:=f[i];
    i:=i+1;
  end;
  if FInfoList.Count > 0 then
    StartaddItem := FInfoList.Count - 1
  else
    StartaddItem := 0;
  delete(s, 1, Pos('"', s));
  File_O := ExtractFilePath(fileName) + Copy(s, 1, Pos('"', s) - 1);
  OneFile := True;
   while (i<=f.Count-1) do
  begin
        s:=f[i];
    Application.ProcessMessages;
    Ps := Pos('PERFORMER', s);
    if ps <> 0 then
    begin
      delete(s, 1, Pos('"', s));
      artist := Copy(s, 1, Pos('"', s) - 1);
      isartist := True;
    end;
    Ps := Pos('TITLE', s);
    if ps <> 0 then
    begin
      delete(s, 1, Pos('"', s));
      TITLE := Copy(s, 1, Pos('"', s) - 1);
      isname := True;
    end;
    ps := Pos('INDEX 01', s);
    if ps <> 0 then
    begin
      Time := Copy(s, Pos('INDEX 01', s) + Length('INDEX 01 '), Length(s) - Length('INDEX 01'));
      isTime := True;
    end;
    ps := Pos('INDEX 00', s);
    if ps <> 0 then
    begin
      Time_ := Copy(s, Pos('INDEX 00', s) + Length('INDEX 00 '), Length(s) - Length('INDEX 00'));
    end;
    if FILE_T = '' then
      FILE_T := FILE_O;
    Ps := Pos('FILE', s);
    if ps <> 0 then
    begin
      delete(s, 1, Pos('"', s));
      FILE_T := ExtractFilePath(fileName) + Copy(s, 1, Pos('"', s) - 1);
      OneFile := False;
    end; 
    if isartist and  isname and IsTime then
    begin
      System.New(NItemdat);
      if CUEListCount > 0 then
      begin
        pTrackData(FInfoList[FInfoList.Count - 1])^.time := Round((CueTime2MiliSeconds(Time) -
        CueTime2MiliSeconds(pTrackData(FInfoList[FInfoList.Count - 1])^.Index01)) / 1000);
      end;
      NItemdat^.filename := File_T;
      NItemdat^.Name := artist + '-' + title;
      NItemdat^.OrigName :=NItemdat^.Name; 
      NItemdat^.Format := UpperCase(Copy(ExtractFileEXT(File_T), 2, Length(File_T)));
      NItemdat^.BitRate := 0;
      NItemdat^.Freq := 0;
      NItemdat^.InBest := False;
      NItemdat^.CUEFlag := True;
      NItemdat^.VKFlag := False;
      NItemdat^.InfoUpdt := True;
      NItemdat^.Index01 := Time;
      NItemdat^.Index00 := Time_;
      NItemdat^.OneFile := OneFile;
      Self.AddItem_(NItemdat);
      isartist := False;
      isname := False;
      IsTime := False;
      File_T := '';
      CueListCount := CueListCount + 1;
      NItemdat := nil;
    end;
        i:=i+1;
  end;
  if not OneFile then
  begin
    for i := StartaddItem to FInfoList.Count - 1 do
    begin
      pTrackData(FInfoList[i])^.OneFile := OneFile;
      pTrackData(FInfoList[i])^.OrigName:=SysUtils.ExtractFileName(pTrackData(FInfoList[i])^.filename);
    end;
  end;
  if OneFile then
    pTrackData(FInfoList[FInfoList.Count - 1])^.time := Get_Tegdata(pTrackData(FInfoList[FInfoList.Count - 1])^.filename).Time -
      Round(CueTime2MiliSeconds( pTrackData(FInfoList[FInfoList.Count - 1])^.Index01) / 1000)
      else
      pTrackData(FInfoList[FInfoList.Count - 1])^.time:=0;

  f.Free;
end;

procedure TImgPlayList.FastSerch(str: String; NewSerch: Boolean; Param: TserchIn);
var
  i, n, num: Integer;
  st: String;
begin
  if str = '' then
  begin
    self.ItemIndex := 0;
    exit;
  end;
  num := self.ItemIndex;
  if NewSerch then
    n := 0
  else
    n := Num + 1;
  str := ansilowercase(str);
  for i := n to self.Count - 1 do
  begin
    if param = Inlist then
    begin
      if (Pos(str, ansilowercase(self.dataitems[i]^.Name)) <> 0) or
       (Pos(str, ansilowercase(self.dataitems[i]^.OrigName)) <> 0) then
      begin
        self.ItemIndex := i;
        self.Click;
        Break;
      end;
    end
    else
    if param = Inadd then
    begin
      if Pos(str, ansilowercase(self.dataitems[i]^.filename)) <> 0 then
      begin
        self.ItemIndex := i;
        Break;
      end;
    end;
  end;
end;

procedure TImgPlayList.Regenlist;
var
  ti: pTrackData;
  i, rn, cr: Integer;
begin
  inherited Clear;
  for i := 0 to FInfoList.Count - 1 do
  begin
    if i <> FPlayed then
    begin
      repeat
        rn := Random((FInfoList.Count - 1));
      until
      rn <> FPlayed;
      application.ProcessMessages;
      ti := PTrackData(FInfoList[rn]);
      FInfoList[rn] := FInfoList[i];
      FInfoList[i] := ti;
    end;
    Self.Items.Add('');
  end;
end;

Procedure TImgPlayList.FillHeader(var ListHeader:TimPlayList);
begin
ListHeader.Name:='��� ��������';
ListHeader.Artist:='VA';
ListHeader.Year:=Inttostr(CurrentYear);
ListHeader.Album:='n/a';
ListHeader.Genre:='n/a';
ListHeader.Tracks:='n/a';
ListHeader.Label_:='n/a';
end;
function TImgPlayList.RandomIncBest(i, rang: Integer): Integer;
begin
  RandCount := RandCount + 1;
  randomize;
  Result := Random(i);
  if RandCount >= rang then
  begin
    RandCount := 0;
    if FBestList.Count > 0 then
      result := FinfoList.IndexOf(self.FBestList[random(FBestList.Count - 1)]);
  end;
end;

function TImgPlayList.CheckFileInList(f: String): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to FInfoList.Count - 1 do
  begin
    if LowerCase(Self.DataItems[i]^.filename) = LowerCase(f) then
    begin
      Result := true;
      break;
    end;
  end;
end;




end.
