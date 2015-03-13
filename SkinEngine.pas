unit SkinEngine;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, dialogs, Classes,
  Graphics, MyUtils, iniFiles, imgGraphicHint,Controls;

type
  TLSC = function(SkinName: String): Boolean;
TCompParams=Record
Normal_V:Boolean;
Normal_X:integer;
Normal_Y:integer;
Normal_W:integer;
Normal_H:integer;
Mini_V:Boolean;
Mini_X:integer;
Mini_Y:integer;
Mini_W:integer;
Mini_H:integer;
end;

  TSkinHeader = Record
    SkinName: string[255];
    SkinAuthor: string[255];
    MainFormParams:array[1..16] of TCompParams;
    sze: array [1..25] of Int64;
  end;

function LoadSkin(Name: String; CallBack: TLSC): Boolean;
function GetResizedBitmap2Point(Width, Height: Integer): TBitMap;
Procedure SetCompparams(OBJ:TControl;Params:TCompParams;mode:integer);
var
  MainImg, Over, SliderM, SliderO, VolM, VolO, Play_B,
  Pause_B, mini, ListM, ListO, EQMain,
  EQOver, EQSlM, EQSLO, ListScroll, ListScrollSel, Listitemsel,
  listitemPlay, ListImgNR, ListImgSl, ListImgPL,HintBg: TBitMap;
  FontTNR, FontTSL, FontTPL, FontDNR, FontDSL, FontDPL
  , FontBtr, FontTm, FontMtm, FontRs: TFont;
  CurSkinHDR:TSkinHeader;
  SkinList:TStringList;

implementation

var
  lTop, lDown, rTop, rDown, TopCnt,
  dwnCnt, finalDRW: TBitMap;

Procedure SetCompparams(OBJ:TControl;Params:TCompParams;mode:integer);
Begin
If mode=1 then
begin
With Params do
begin
OBJ.Visible:=Normal_V;
OBJ.Left:=Normal_X;
OBJ.Top:=Normal_Y;
OBJ.Width:=Normal_W;
OBJ.Height:=Normal_H;
end;
end
else
If mode=2 then
Begin
With Params do
begin
OBJ.Visible:=Mini_V;
if not Mini_V then
exit;
if Mini_X>-1 then
OBJ.Left:=Mini_X;
if Mini_Y>-1 then
OBJ.Top:=Mini_Y;
if Mini_W>-1 then
OBJ.Width:=Mini_W;
if Mini_H>-1 then
OBJ.Height:=Mini_H;
end;
end;
end;
//////////////////////////////////////////////
Function Skin_ReadBitMapFile(F:TFileStream; si:int64;img:TBitMap):boolean;
var
F1:TMemoryStream;
begin
result:=false;
try
F1:=TMemoryStream.Create;
F1.CopyFrom(F, Si);
F1.Position:=0;
Img.LoadFromStream(F1);
F1.Free;
Result:=true;
except
end;
end;

Function Skin_extractFile(F:TFileStream;si:int64;FilName:string):string;
var
F1:TMemoryStream;
begin
F1:=TMemoryStream.Create;
F1.CopyFrom(F, Si);
F1.Position:=0;
Try
F1.SaveToFile(FilName);
except
begin
F1.Free;
exit;
end;
end;
F1.Free;
Result:=FilName;
end;

Function Skin_ReadIniFile(F:TFileStream;si:int64;IniFile:TMemIniFile):boolean;
var
F1:TMemoryStream;
List : TStringList;
begin
result:=false;
List := TStringList.Create;
F1:=TMemoryStream.Create;
F1.CopyFrom(F, Si);
F1.Position:=0;
Try
List.LoadFromStream(F1);
IniFile.SetStrings(List);
finally
begin
F1.Free;
List.Free;
end;
end;
Result:=True;
end;

procedure LoadFontParams(key, Pref: String; Font: TFont; confFile: TmeminiFile);
var
  StyleStr: String;
begin
  font.Style := [];
  if not assigned(ConfFile) then
    exit;
  Font.Name := ConfFile.ReadString(key, Pref + 'FontN', 'MS Sans Serif');
  Font.Size := ConfFile.ReadInteger(key, Pref + 'FontS', 8);
  Font.Color := ConfFile.ReadInteger(key, Pref + 'FontC', $000000);
  StyleStr := ConfFile.ReadString(key, Pref + 'FontF', '');
  if Pos('fsBold', StyleStr) <> 0 then
    font.Style := font.Style + [fsBold];
  if Pos('fsItalic', StyleStr) <> 0 then
    font.Style := font.Style + [fsItalic];
  if Pos('fsUnderline', StyleStr) <> 0 then
    font.Style := font.Style + [fsUnderline];
  if Pos('fsStrikeOut', StyleStr) <> 0 then
    font.Style := font.Style + [fsStrikeOut];
end;

function LoadFont2PlayList(F:TFileStream;si:int64): Boolean;
var
  Config: TMemIniFile;
begin
  Result := False;
  Config := TMemIniFile.Create('Memini_.ini');
  Skin_ReadIniFile(F,si,Config);
  LoadFontParams('list', 'TNR', FontTNR, Config);
  LoadFontParams('list', 'TSL', FontTSL, Config);
  LoadFontParams('list', 'TPL', FontTPL, Config);
  LoadFontParams('list', 'DNR', FontDNR, Config);
  LoadFontParams('list', 'DSL', FontDSL, Config);
  LoadFontParams('list', 'DPL', FontDPL, Config);
  Result := True;
  Config.Free;
end;


function LoadFont2Main(F:TFileStream;si:int64): Boolean;
var
  Config: TMemIniFile;
begin
  Result := False;
  Config := TMemIniFile.Create('Memini.ini');
  Skin_ReadIniFile(F,si,Config);
  LoadFontParams('main', 'Tm', FontTm, Config);
  LoadFontParams('main', 'Bt', FontBtr, Config);
  LoadFontParams('main', 'Mtm', FontMtm, Config);
  LoadFontParams('main', 'Rs', FontRs, Config);
  LoadFontParams('main', 'Hnt', imgGraphicHint.HintFont, Config);
  Result := True;
  Config.Free;
end;

procedure mainBitMap2Resize;
var
  PRect, CRect: TRect;
begin
  lTop.Width := ((ListM.Width - 101) div 2) - 10;
  lTop.Height := (ListM.Height div 2) - 10;
  CRect := Bounds(0, 0, lTop.Width, lTop.Height);
  Prect := Bounds(0, 0, lTop.Width, lTop.Height);
  lTop.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  rTop.Width := ((ListM.Width - 101) div 2) - 10;
  rTop.Height := (ListM.Height div 2) - 10;
  CRect := Bounds(ListM.Width - rTop.Width, 0, rTop.Width, rTop.Height);
  Prect := Bounds(0, 0, rTop.Width, rTop.Height);
  rTop.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  lDown.Width := ((ListM.Width - 101) div 2) - 10;
  lDown.Height := (ListM.Height div 2) - 10;
  CRect := Bounds(0, ListM.Height - lDown.Height, lDown.Width, lDown.Height);
  Prect := Bounds(0, 0, lDown.Width, lDown.Height);
  lDown.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  rDown.Width := ((ListM.Width - 101) div 2) - 10;
  rDown.Height := (ListM.Height div 2) - 10;
  CRect := Bounds(ListM.Width - rDown.Width, ListM.Height - rDown.Height, rTop.Width, rTop.Height);
  Prect := Bounds(0, 0, rDown.Width, rDown.Height);
  rDown.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  TopCnt.Width := 101;
  TopCNT.Height := (ListM.Height div 2) - 10;
  CRect := Bounds(lTop.Width + 10, 0, TopCNT.Width, TopCNT.Height);
  Prect := Bounds(0, 0, TopCNT.Width, TopCNT.Height);
  TopCNT.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  DwnCnt.Width := 101;
  DwnCnt.Height := (ListM.Height div 2) - 10;
  CRect := Bounds(lDown.Width + 10, ListM.Height - DwnCnt.Height, DwnCnt.Width, DwnCnt.Height);
  Prect := Bounds(0, 0, DwnCnt.Width, DwnCnt.Height);
  DwnCnt.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  {end of static create}
end;

function LoadSkin(Name: String; CallBack: TLSC): Boolean;
  var
  fs:TFileStream;
  sk: TSkinHeader;
begin
  Result := False;
  if not Fileexists(Name) then
  exit;
  try
  FS:=TFileStream.Create(Name, fmOpenRead);
 except
 begin
  FS.Free;
 exit;
 end;
 end;
  FS.ReadBuffer(sk, SizeOF(sk));
   result:=true;
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[1],MainImg);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[2],Over);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[3],Mini);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[4],SliderM);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[5],SliderO);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[6],VolM);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[7],VolO);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[8],Pause_B);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[9],Play_B);
  result:=Result and LoadFont2Main(FS,sk.sze[10]);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[11],ListM);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[12],ListO);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[13],ListScroll);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[14],ListScrollSel);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[15],Listitemsel);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[16],listitemPlay);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[17],ListImgNR);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[18],ListImgSL);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[19],ListImgPL);
  result:=Result and LoadFont2PlayList(FS,sk.sze[20]);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[21],EQMain);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[22],EQOver);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[23],EQSLM);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[24],EQSLO);
  result:=Result and Skin_ReadBitMapFile(FS,sk.sze[25],HintBg);
FS.Free;
if result then
begin
CurSkinHDR:=sk;
imgGraphicHint.LoadHintBmp(HintBg);
mainBitMap2Resize;
Result := (Result and CallBack(skinPath));
end;
end;

function GetResizedBitmap2Point(Width, Height: Integer): TBitMap;
var
  PRect, CRect: TRect;
begin
  FinalDRW.Width := Width;
  FinalDRW.Height := Height;
  FinalDRW.Canvas.Draw(0, 0, Ltop);
  FinalDRW.Canvas.Draw(Width - rTop.Width, 0, rtop);
  FinalDRW.Canvas.Draw(0, Height - lDown.Height, ldown);
  FinalDRW.Canvas.Draw(Width - rDown.Width, Height - rDown.Height, rdown);
  FinalDRW.Canvas.Draw(((Width - 101) div 2), 0, TopCnt);
  FinalDRW.Canvas.Draw(((Width - 101) div 2), Height - lDown.Height, DwnCnt);
  {End of Static Paint}
  
  {dynamic Paint}
  pRect := Bounds(lTop.Width, 0, (((Width - 101) div 2) - LTop.Width), (ListM.Height div 2) - 10);
  crect := Bounds(lTop.Width, 0, 10, (ListM.Height div 2) - 10);
  FinalDRW.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  pRect := Bounds(lTop.Width + 10 + TopCnt.Width, 0, (Width - rTop.Width) - (lTop.Width + 10 + TopCnt.Width), (ListM.Height div 2) - 10);
  crect := Bounds(lTop.Width + 10 + TopCnt.Width, 0, 10, (ListM.Height div 2) - 10);
  FinalDRW.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  pRect := Bounds(ldown.Width, Height - lDown.Height, (((Width - 101) div 2) - LDown.Width), (ListM.Height div 2) - 10);
  crect := Bounds(ldown.Width, (ListM.Height - lDown.Height), 10, (ListM.Height div 2) - 10);
  FinalDRW.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
                                              { }
  pRect := Bounds(((Width - 101) div 2) + DWNCnt.Width, Height - lDown.Height, (Width - RDown.Width) - (((Width - 101) div 2) + DWNCnt.Width), (ListM.Height div 2) - 10);
  crect := Bounds(ldown.Width + 10 + DWNCnt.Width, (ListM.Height - lDown.Height), 10, (ListM.Height div 2) - 10);
  FinalDRW.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  
  
  pRect := Bounds(0, LTop.Height, ((ListM.Width - 101) div 2), (Height - ldown.Height) - lTop.Height);
  crect := Bounds(0, LTop.Height, ((ListM.Width - 101) div 2), (ListM.Height div 2) - LDown.Height + 10);
  FinalDRW.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  
  pRect := Bounds(Width - rTop.Width - 10, RTop.Height, ((ListM.Width - 101) div 2), (Height - rdown.Height) - rTop.Height);
  crect := Bounds(lTop.Width + 10 + TopCnt.Width + 1, rTop.Height, ((ListM.Width - 101) div 2), (ListM.Height div 2) - LDown.Height + 10);
  FinalDRW.Canvas.CopyRect(pRect, ListM.Canvas, cRect);
  Result := FinalDRW
end;

initialization
  begin
    SkinList:=TStringList.Create;
    MainImg := TBitMap.Create;
    Over := TBitMap.Create;
    SliderM := TBitMap.Create;
    SliderO := TBitMap.Create;
    Play_B := TBitMap.Create;
    Pause_B := TBitMap.Create;
    mini := TBitMap.Create;
    ListM := TBitMap.Create;
    ListO := TBitMap.Create;
    EQMain := TBitMap.Create;
    EQOver := TBitMap.Create;
    lTop := TBitMap.Create;
    lDown := TBitMap.Create;
    rTop := TBitMap.Create;
    rDown := TBitMap.Create;
    TopCnt := TBitMap.Create;
    dwnCnt := TBitMap.Create;
    finalDRW := TBitMap.Create;
    ListScroll := TBitMap.Create;
    ListScrollSel := TBitMap.Create;
    Listitemsel := TBitMap.Create;
    listitemPlay := TBitMap.Create;
    ListImgNR := TBitMap.Create;
    ListImgSl := TBitMap.Create;
    ListImgPL := TBitMap.Create;
    VolM := TBitMap.Create;
    VolO := TBitMap.Create;
    EQSlM := TBitMap.Create;
    EQSLO := TBitMap.Create;
    FontTNR := TFont.Create;
    FontTSL := TFont.Create;
    FontTPL := TFont.Create;
    FontDNR := TFont.Create;
    FontDSL := TFont.Create;
    FontDPL := TFont.Create;
    FontBtr := TFont.Create;
    FontTm := TFont.Create;
    FontMtm := TFont.Create;
    FontRs := TFont.Create;
    HintBg:= TBitMap.Create;
  end;


finalization
  begin
    MainImg.Free;
    Over.Free;
    SliderM.Free;
    SliderO.Free;
    Play_B.Free;
    Pause_B.Free;
    mini.Free;
    ListM.Free;
    ListO.Free;
    EQMain.Free;
    EQOver.Free;
    lTop.Free;
    lDown.Free;
    rTop.Free;
    rDown.Free;
    TopCnt.Free;
    dwnCnt.Free;
    finalDRW.Free;
    ListScroll.Free;
    ListScrollSel.Free;
    Listitemsel.Free;
    listitemPlay.Free;
    ListImgNR.Free;
    ListImgSl.Free;
    ListImgPL.Free;
    FontTNR.Free;
    FontTSL.Free;
    FontTPL.Free;
    FontDNR.Free;
    FontDSL.Free;
    FontDPL.Free;
    FontBtr.Free;
    FontTm.Free;
    FontMtm.Free;
    FontRs.Free;
    VolM.Free;
    VolO.Free;
    EQSlM.Free;
    EQSLO.Free;
    HintBg.Free;
    SkinList.Clear;
  end;

end.