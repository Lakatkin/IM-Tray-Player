unit ImgFriendsList;


//////////////////////////////////////////
//                                      //
//          IMVKapi Component LIB.      //
//      Graphics VKUsersShortList For   //
//         For ImPlayer beta            //
//       author: Lakatkin Misha         //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows,Forms, Messages, SysUtils, Variants, Classes,
   Graphics, StdCtrls,controls,MyUtils;

type
pUser=^TUser;
TUser=record
uid:string;
Name:string;
photo:String;
end;


  TImgFriendsList = class(TListBox)
  private
    FSelFontT,FNoSelFontT:TFont;
    FItemSel:TBitMap;
    FInfoList:TList;
    FPlayed:Integer;
    FFphotoIMG:TBitMap;
   Procedure ItemPoint(canv:TCanvas;Bmp1,Gliph:TBitMap;Rect: TRect;heigth:integer);
   function BeautyStr(s: string; iLength: integer): string;
   Procedure TextOut2List(Font1:TFont;
Canv:TCanvas;Rect: TRect;Info:Tuser;
imgW,TotalW,heigth:Integer);
        Procedure SetItemSel(const Value:TBitMap);
        Procedure SetSelFontT(const Value:TFont);
        Procedure SetNotSelFontT(const Value:TFont);
       protected
    procedure DrawItem( Index: Integer;
    Rect: TRect; State: TOwnerDrawState); override;
     { Protected declarations }
     public
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    Procedure AddItem_(Item: pUser);
    Procedure DelItem_(ItemIndex: Integer);
    Function  GetItem_(Index: Integer):pUser;
    Procedure Clear; override;
    Procedure ResetItem(Index: Integer; Item: pUser);
    Property DataItems[Index: Integer]:pUser read  GetItem_ write ResetItem; default;
    procedure FastSerch(str: String; NewSerch: Boolean);
  published
    { Published declarations }
    Property SelectItemBMP:TBitMap Read FItemSel Write SetItemSel;
    Property NormalItemTopFont:TFont Read FNoSelFontT  Write SetNotSelFontT;
    Property SelectItemTopFont:TFont Read FSelFontT  Write SetSelFontT;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TImgFriendsList]);
end;

function TImgFriendsList.BeautyStr(s: string; iLength: integer): string;
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
  bm.Width := 100;
  bm.Height := 100;
  bm.Canvas.Font.Style := [fsBold];
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

Procedure TImgFriendsList.ItemPoint(canv:TCanvas;Bmp1,Gliph:TBitMap;Rect: TRect;heigth:integer);
Var
Source, Dest: TRect;
Begin
with Canv do
Begin
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

Procedure TImgFriendsList.TextOut2List(Font1:TFont;
Canv:TCanvas;Rect: TRect;Info:TUser;
imgW,TotalW,heigth:Integer);
var
LengthName:Integer;
CutName:String;
Begin
With Canv do
Begin
Font.Assign(Font1);
LengthName := Length(Info.Name);
totalW:=totalW-18;
If  LengthName> (totalW-ImgW-20) then
CutName:=BeautyStr(info.Name,(totalW-ImgW-20))
else
CutName:=Info.Name;
TextOut(Rect.Left + ImgW, Rect.Top+((heigth div 2)-Canvas.TextHeight(CutName)),CutName);
end;
end;

constructor TImgFriendsList.Create;
begin

  inherited Create(AOwner);
    FSelFontT:=TFont.Create;
    FNoSelFontT:=TFont.Create;
    FItemSel:=TBitMap.Create;
    FInfoList:=TList.Create;
    FFphotoIMG:=TBitMap.Create;
    BorderStyle:= bsNone;
    Self.Style:=lbOwnerDrawFixed;
end;

destructor TImgFriendsList.Destroy;
begin
    FSelFontT.Free;
    FNoSelFontT.Free;
    FItemSel.Free;
    FInfoList.Free;
    FFphotoIMG.Free;
inherited Destroy;
end;


////////////////////////////////////////////////////////////////////////////////
Procedure TImgFriendsList.SetItemSel(const Value:TBitMap);
        Begin
        FItemSel.Assign(Value);
        end;


Procedure TImgFriendsList.SetSelFontT(const Value:TFont);
        Begin
        FSelFontT.Assign(Value);
        end;

Procedure TImgFriendsList.SetNotSelFontT(const Value:TFont);
        Begin
        FNoSelFontT.Assign(Value);
        end;

////////////////////////////////////////////////////////////////////////////////
    Procedure TImgFriendsList.AddItem_(Item: pUser);
    Begin
    FInfoList.Add(Item);
        self.Items.Add('_');
    end;

    Procedure TImgFriendsList.ResetItem(Index: Integer; Item: pUser);
    Begin
    FInfoList[Index]:=Item;
        self.Items[Index]:='';
    end;

    Procedure TImgFriendsList.DelItem_(ItemIndex: Integer);
        Begin
        dispose(FInfoList[ItemIndex]);
        Self.Items.Delete(ItemIndex);
        FInfoList.Delete(ItemIndex);
        end;

    Function  TImgFriendsList.GetItem_(Index: Integer):pUser;
        Begin
        Result:=pUser(FInfoList[Index]);
    end;

    Procedure TImgFriendsList.Clear;
    Begin
        inherited;
    FInfoList.Clear;
 
    end;



procedure TImgFriendsList.DrawItem(Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
      var
      Crect,Prect:TRect;
      IMG:TBitMap;
      Begin
      try
      inherited;

       Rect.Top:=Rect.Top;
      IMG:=IMG2BMP(GetItem_(Index).photo);
      Prect:=Bounds(6,6,IMG.Width-6,IMG.Height-6);
      Crect:=Bounds(0,0,IMG.Width-6,IMG.Height-6);
    FFphotoIMG.Height:=IMG.Height-12;
    FFphotoIMG.Width:=IMG.Width-12;
FFphotoIMG.Canvas.CopyRect(Crect,IMG.Canvas,Prect);
Self.ItemHeight:=FItemSel.Height;
  if (odSelected in State)  then
begin
ItemPoint(Canvas,FFphotoIMG,FItemSel,rect,self.ItemHeight);
TextOut2List(FSelFontT,Canvas,rect,Self.GetItem_(Index)^,FFphotoIMG.Width,Width,ItemHeight);
end
  else
  begin
    with Canvas do
    begin
      Brush.Color := Self.Color;
      FillRect(Rect);
      Draw(Rect.Left, Rect.Top, FFphotoIMG);
      TextOut2List(FnoSelFontT,Canvas,rect,
      Self.GetItem_(Index)^,FFphotoIMG.Width,Width,ItemHeight);
     end;
     end;
    img.Free;
        except on EAccessViolation do
    end;
      end;

procedure TImgFriendsList.FastSerch(str: String; NewSerch: Boolean);
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
      if (Pos(str, ansilowercase(self.dataitems[i].Name)) <> 0) or
       (Pos(str, ansilowercase(self.dataitems[i].uid)) <> 0) then
      begin
        self.ItemIndex := i;

        Break;
      end;
end;
   end;
end.
