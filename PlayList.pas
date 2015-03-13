unit PlayList;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgButton, skinEngine, StdCtrls, imgFormResizer,
  ComCtrls, ImgPlayList, ImgTrackBar, DropSource, MyUtils, Menus, Sound_Engine,
  DropTarget, TagReader, ListTag,VK_Methods,VK_Lib,DL_adapt, DragDropFile,
  DragDrop;

type
TTagupgater= class(TThread)
private
UpdateCount:integer;
updateLim:integer;
item:PtrackData;
num:integer;
procedure preGetInfo;
procedure PostGetInfo;
Procedure UpdatePart;
protected
procedure Execute; override;
public
UpdateOffset:integer;
End;

  TPlay_List = class(TForm)
    imgFormResizer1: TimgFormResizer;
    ImgButton7: TImgButton;
    ImgButton6: TImgButton;
    ImgButton5: TImgButton;
    ImgButton4: TImgButton;
    ImgButton3: TImgButton;
    ImgButton2: TImgButton;
    ImgButton1: TImgButton;
    Edit1: TEdit;
    ImgTrackBar1: TImgTrackBar;
    DropFileSource1: TDropFileSource;
    PopupMenu2: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    OpenDialog1: TOpenDialog;
    ImgButton8: TImgButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N6: TMenuItem;
    VK1: TMenuItem;
    PopupMenu3: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    DropFileTarget1: TDropFileTarget;
    PopupMenu4: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    PopupMenu5: TPopupMenu;
    N15: TMenuItem;
    N14: TMenuItem;
    Main_PlayList: TImgPlayList;
    N16: TMenuItem;
    VK2: TMenuItem;
    SaveDialog2: TSaveDialog;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    e1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure ImgButton7Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgFormResizer1ResizeEnd(Sender: TObject);
    procedure ImgTrackBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgPlayList1UpdateScroll(ScrollPos: Integer);
    procedure ImgTrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButton3Click(Sender: TObject);
    procedure ImgButton1Click(Sender: TObject);
    procedure ImgPlayList1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgPlayList1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgPlayList1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DropFileSource1Drop(Sender: TObject; DragType: TDragType;
      var ContinueDrop: Boolean);
    procedure ImgButton2Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ImgButton5Click(Sender: TObject);
    procedure ImgButton4Click(Sender: TObject);
    procedure ImgButton6Click(Sender: TObject);
    procedure ImgPlayList1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      Point: TPoint; var Effect: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ImgTrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgPlayList1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImgButton8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure ImgPlayList1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure N6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure VK1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure SideListclick(Sender: TObject);
    Procedure OnListClear(Sender: TObject);
  private
    DropHTTP:boolean;
    DlLink,DlName:String;
    StartingPoint, DropPoint: TPoint;
    DropPosition, StartPosition: Integer;
    CopyItem: Integer;
    MoveItemDown: Boolean;
    dmain: TBitMap;
    LibList:TstringList;
    CurUpdateProc:TTagupgater;
    UpdateWorked:boolean;
    UpdatedCount:integer;
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure Add2Lib(FileName:string);
    { Private declarations }
  public  
    NewItemIndex: Integer;
      CdataList:TStringList;
    Procedure OpenFromParamStr();
    Procedure OpenFromCdataList();
    procedure Open_(file_: string; ReadPl: boolean);
    Procedure Add_Item(Item:pTrackData);
    procedure OpenFolder(path: String);
    Procedure DLItem(data:PTrackData);
    Procedure UpdateVKBL;
    procedure UpdateListInfo(offset:integer);
    {Call back for external unit poroc}
    function CallBackSkinLoad(s: String): Boolean;
    { Public declarations }
  end;

const
  PlayListFileExt = '*.impl;*.cue;*.m3u;';

var
  Play_List: TPlay_List;

implementation

uses
  Main, OptionsBox, ListUpdateFRM, List_OpenMode, NetOpen, VK_audio;

{$R *.dfm}

procedure TTagupgater.preGetInfo;
begin
with Play_List do
begin
Item:=Main_PlayList.DataItems[num];    {
N19.Enabled:=false;
N4.Enabled:=false;
N20.Enabled:=false;
N12.Enabled:=false;      }
end;
end;

procedure TTagupgater.PostGetInfo;
begin
with Play_List do
begin             {
N20.Enabled:=True;
N12.Enabled:=True;
N19.Enabled:=True;
N4.Enabled:=True;   }
end;
end;

Procedure TTagupgater.UpdatePart;
begin
Play_List.Main_PlayList.Repaint;
end;



procedure TTagupgater.Execute;
Var
i,strt,sz:integer;
begin
UpdateCount:=0;
updateLim:=Round(Play_List.Main_PlayList.Height/Play_List.Main_PlayList.ItemHeight);
Play_List.UpdateWorked:=true;
case Options_Box.RadioGroup2.ItemIndex of
0:strt:=self.UpdateOffset;
1:strt:=0;
2:strt:=self.UpdateOffset-1;
end;
for i:=strt  to Play_List.Main_PlayList.Count-1 do
begin
num:=i;
try
Synchronize(preGetInfo);
if (Item^.InfoUpdt)  then
begin
    if Item^.CUEFlag then
    begin
      with TagReader.Get_Tag2List(Item^.filename,False) do
      begin
if not Item^.OneFile  then
      begin
if Options_BOX.CheckBox17.Checked then
        Item^.Name :=Pchar(Name);
        Item^.time := Time;
        end;
        Item^.Freq := SampleRate;
        Item^.BitRate := BitRate;
        Item^.InfoUpdt := False;
end;
 end;
 if Item^.VKFlag then
  begin
  if Item^.BitRate=0 then
  begin
  sz:=GetInetFileSize(Item^.filename);
  if sz<>0 then
   Item^.BitRate:=Trunc((sz*8)/(1000*Item^.time));
   Item^.Freq:=44100;
  end
      else
sleep(100);
  end;

if not (Item^.VkFlag or Item^.CueFlag) then
begin
if Pos('://', Item^.filename) = 0 then
    begin
      with TagReader.Get_Tag2List(Item^.filename,False) do
      begin
           if Options_Box.CheckBox16.Checked then
          Item^.Name :=Pchar(Name);
        Item^.time := Time;
        Item^.Freq := SampleRate;
        Item^.BitRate := BitRate;
        Item^.InfoUpdt := False;
      end;
      end;
end;
Synchronize(PostGetInfo);
UpdateCount:=UpdateCount+1;
if (UpdateCount>=updateLim) or (i>= Play_List.Main_PlayList.Count-1) then
begin
UpdateCount:=0;
Synchronize(UpdatePart);
end;
Sleep(100);
end;
if Terminated then
begin
break;
end;
Play_List.UpdatedCount:=Play_List.UpdatedCount+1;
except

end;
 end;
Play_List.UpdateWorked:=False;
end;


procedure TPlay_List.WMMoving(var Msg: TWMMoving);
var
  workArea: TRect;
begin
  if Options_Box.CheckBox13.Checked then
  begin
    workArea := Screen.WorkareaRect;
    with Msg.DragRect^ do
    begin
      if Left < workArea.Left then
        OffsetRect(Msg.DragRect^, workArea.Left - Left, 0);
      if Top < workArea.Top then
        OffsetRect(Msg.DragRect^, 0, workArea.Top - Top);
      if Right > workArea.Right then
        OffsetRect(Msg.DragRect^, workArea.Right - Right, 0);
      if Bottom > workArea.Bottom then
        OffsetRect(Msg.DragRect^, 0, workArea.Bottom - Bottom);
    end;
  end;
  
end;

function TPlay_List.CallBackSkinLoad(s: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  with Play_List do
  begin
    Width := ListM.Width;
    Height := ListO.Height;
    imgFormResizer1.MinHeight := Height;
    imgFormResizer1.MinWidth := Width;
    ImgTrackBar1.SliderNR := ListScroll;
    ImgTrackBar1.SliderDW := ListScrollSel;
    Main_PlayList.Color := ListM.Canvas.Pixels[Main_PlayList.Left + 4, Main_PlayList.Top + 4];
    Main_PlayList.ItemImageNormBMP := ListImgNR;
    Main_PlayList.ItemImageSelectBMP := ListImgSl;
    Main_PlayList.ItemImagePlayBMP := ListImgPL;
    Main_PlayList.PlayItemBMP := listitemPlay;
    Main_PlayList.SelectItemBMP := Listitemsel;
    Main_PlayList.NormalItemTopFont := FontTNR;
    Main_PlayList.SelectItemTopFont := FontTSl;
    Main_PlayList.PlayItemTopFont := FontTPL;
    Main_PlayList.NormalItemDownFont := FontDNR;
    Main_PlayList.SelectItemDownFont := FontDSl;
    Main_PlayList.PlayItemDownFont := FontDPL;
    Edit1.Color := ListM.Canvas.Pixels[Edit1.Left + 4, Edit1.Top + 4];
       Play_List.imgFormResizer1ResizeEnd(nil);
    for i := 1 to 8 do
    begin
      (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Main := ListM;
      (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Over := ListO;
    end;
  end;
  Result := True;
end;

procedure TPlay_List.FormPaint(Sender: TObject);
begin
  Canvas.Draw(0, 0, dmain);
end;

procedure TPlay_List.ImgButton7Click(Sender: TObject);
begin
  main_Window.ImgButton2.Click(false);
end;

procedure TPlay_List.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if edit1.Text = '' then
    edit1.Text := 'Поиск';
  Screen.Cursor := crSizeall;
  ReleaseCapture;
  Play_List.perform(WM_SysCommand, $f012, 0);
  Screen.Cursor := crDefault;
end;

procedure TPlay_List.imgFormResizer1ResizeEnd(Sender: TObject);
var
  i, NewBTNL: Integer;
begin
  dmain := Skinengine.GetResizedBitmap2Point(Self.Width, self.Height);
  imgFormResizer1.Left := (Self.Width - (imgFormResizer1.Width ));
  imgFormResizer1.Top := (Self.Height - (imgFormResizer1.Height ));
  Main_PlayList.Width := self.Width - 35;
  Main_PlayList.Height := Self.Height - (105);
  ImgTrackBar1.Left := (Main_PlayList.Left + Main_PlayList.Width) + 1;
  ImgTrackBar1.Height := Main_PlayList.Height;
  edit1.Width := self.Width - 48;
  ImgButton7.Left := Self.Width - ImgButton7.Width - 10;  {
  Panel1.Width:=Self.Width-21-ImgButton7.Width; } /// Control for Multilist edition
  NewBTNL := ((Self.Width - 101) div 2);
  for i := 1 to 6 do
  begin
    (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Top := Self.Height - ImgButton1.Height - 14;
    (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Left := NewBTNL;
    NewBTNL := NewBTNL + (FindComponent('ImgButton' + Inttostr(i)) as TImgButton).Width + 3;
  end;
  ImgButton8.Top := Self.Height - ImgButton1.Height - 14;
  ImgTrackBar1.Main := DMain;
  Play_List.TransparentColor := True;
  Play_List.TransparentColorValue := ListM.Canvas.Pixels[0, 0];{}
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
  ImgTrackBar1.Repaint;
  Invalidate;
  Main_PlayList.Repaint;
end;

procedure TPlay_List.ImgTrackBar1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ImgTrackBar1.DOWN then
    Main_PlayList.PosScroll := ImgTrackBar1.Position;{}
end;

procedure TPlay_List.ImgPlayList1UpdateScroll(ScrollPos: Integer);
begin
  if not ImgTrackBar1.DOWN then
  begin
    
    ImgTrackBar1.Position := ScrollPos;   
  end;{}
  if self.UpdatedCount<Main_PlayList.Count-1 then
  Self.UpdateListInfo(UpdatedCount);
end;

procedure TPlay_List.ImgTrackBar1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Main_PlayList.PosScroll := ImgTrackBar1.Position;

end;

procedure TPlay_List.ImgButton3Click(Sender: TObject);
begin
  Options_BOX.show;

end;

procedure TPlay_List.ImgButton1Click(Sender: TObject);
var
  P: TPoint;
begin
if Main_Window.CurList<>Main_PlayList then
 Main_Window.CurList:=Self.Main_PlayList;
  P.X := ImgButton1.Left;
  P.Y := ImgButton1.Top;
  P := ClientToScreen(P);
  PopupMenu1.Popup(P.X, P.Y);
{}end;

procedure TPlay_List.ImgPlayList1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edit1.Text = '' then
    edit1.Text := 'Поиск';
  DropPoint.X := X;
  DropPoint.Y := Y;
  DropPosition := (Sender as TImgPlayList).ItemAtPos(DropPoint, True);
  StartingPoint.X := X;
  StartingPoint.Y := Y;
  StartPosition := (Sender as TImgPlayList).ItemAtPos(StartingPoint, True);
  MoveItemDown := True;
  CopyItem := (Sender as TImgPlayList).ItemIndex;
end;

procedure TPlay_List.ImgPlayList1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ItemPoint: TPoint;
  CurHint: string;
  curItem: integer;
begin
  if   MoveItemDown then
  begin
  if sender=Main_PlayList then
    DropFileTarget1.Dragtypes := [];
    DropPoint.X := X;
    DropPoint.Y := Y;
    if PtInRect((Sender as TImgPlayList).ClientRect, DropPoint) then
    begin
      DropPosition := (Sender as TImgPlayList).ItemAtPos(DropPoint, True);
      if (Screen.Cursor <> crDrag) and ((Sender as TImgPlayList).Count > 1) then
    end
    else
    begin
      if (((Sender as TImgPlayList).DataItems[CopyItem]^.CUEFlag) and (not (Sender as TImgPlayList).DataItems[CopyItem]^.OneFile)) or (not (Sender as TImgPlayList).DataItems[CopyItem]^.CUEFlag) then
      begin
      if (not ((Sender as TImgPlayList).DataItems[CopyItem]^.VKFlag)) then
begin
        DropHTTP:=false;
        DropFileSource1.Dragtypes:=[dtCopy];
        Main_PlayList.ItemIndex := CopyItem;
        DropFileSource1.Files.clear;
        DropFileSource1.Files.Add((Sender as TImgPlayList).DataItems[CopyItem]^.filename);

        end
        else
        begin
        DropHTTP:=true;
        DropFileSource1.Dragtypes:=[dtmove];
        Main_PlayList.ItemIndex := CopyItem;
        DropFileSource1.Files.clear;
        DlLink:=(Sender as TImgPlayList).DataItems[CopyItem]^.filename;
        DlName:=FilenameCut(Get_TempPath+FileNameStd((Sender as TImgPlayList).DataItems[CopyItem]^.OrigName),MAX_PATH-6)+'.mp3';
                DropFileSource1.Files.Add(DlName);
        end;
        DropFileSource1.execute;
        DropFileSource1.Files.clear;
      end;
    end;
  end;
  DropFileTarget1.Dragtypes := [dtLink];
  if (not MoveItemDown) and (Options_Box.CheckBox21.Checked) then
  begin
    ItemPoint.X := X;
    ItemPoint.Y := Y;
    CurItem := (Sender as TImgPlayList).ItemAtPos(ItemPoint, False);
    (Sender as TImgPlayList).ShowHint := False;
    if (CurItem > -1) and (CurItem < (Sender as TImgPlayList).Count) then
    begin
      (Sender as TImgPlayList).ShowHint := true;
      CurHint := Main_PlayList.Hint;
      (Sender as TImgPlayList).Hint := Inttostr(CurItem + 1) + '.' + ((Sender as TImgPlayList).DataItems[CurItem].Name);
      if ((Sender as TImgPlayList).Hint <> CurHint)  then
        Application.CancelHint;
    end;
  end
  else
    (Sender as TImgPlayList).ShowHint := False;
end;

procedure TPlay_List.ImgPlayList1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var
  Oflp: string;
  isd: Boolean;

begin

  if PtInRect((Sender as TImgPlayList).ClientRect, Point(x, y)) then
  begin
    if StartPosition <> DropPosition then
    begin
      if (Sender as TimgPlayList).ItemIndex = -1 then
        exit;
      with Sender as TimgPlayList do
      begin
        if DropPosition <= 0 then
          DropPosition := 0;
        if DropPosition > (Sender as TImgPlayList).Count - 1 then
          DropPosition := (Sender as TImgPlayList).Count - 1;
        if  (StartPosition <> DropPosition) and (Abs(DropPoint.Y - StartingPoint.Y) >= (Sender as TImgPlayList).ItemHeight div 2) then
        begin
          (Sender as TImgPlayList).MoveItem(StartPosition, DropPosition);
         (Sender as TImgPlayList).ItemIndex:=DropPosition;
        end;
      end;
    end;
  end
  else
    (Sender as TImgPlayList).Itemindex := CopyItem;
  MoveItemDown := False;
  DropHTTP :=False;
end;

procedure TPlay_List.DropFileSource1Drop(Sender: TObject;
  DragType: TDragType; var ContinueDrop: Boolean);
begin
  MoveItemDown := False;
  if DropHTTP then
  begin
  DL_adapt.DL_File(DLlink,DLname,true,true);
  DropHTTP:=false;
  end;
end;

procedure TPlay_List.ImgButton2Click(Sender: TObject);
var
  P: TPoint;
begin
  P.X := ImgButton2.Left;
  P.Y := ImgButton2.Top;
  P := ClientToScreen(P);
  PopupMenu2.Popup(P.X, P.Y);
end;

procedure TPlay_List.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 32 then
    exit;
  if (key = 13) then
    Main_PlayList.FastSerch(edit1.Text, false, InList)
  else
    Main_PlayList.FastSerch(edit1.Text, True, InList);
end;

procedure TPlay_List.N3Click(Sender: TObject);
begin
  Main_PlayList.Clear;
end;

procedure TPlay_List.N4Click(Sender: TObject);
begin
  Main_PlayList.DelItem_(Main_PlayList.itemindex);
  Self.UpdatedCount:=  Self.UpdatedCount-1;
end;

procedure TPlay_List.N5Click(Sender: TObject);
begin
  Main_PlayList.DelAllUnclSel(Main_PlayList.itemindex);
  Self.UpdatedCount:=1;
end;

procedure TPlay_List.ImgButton5Click(Sender: TObject);
begin
  if (Main_PlayList.ItemIndex < 0) or (Main_PlayList.ItemIndex > Main_PlayList.Count - 1) then
    exit;
  if not ImgButton5.Checked then
  begin
    Main_PlayList.DataItems[Main_PlayList.ItemIndex]^.InBest := True;
  end
  else
    Main_PlayList.DataItems[Main_PlayList.ItemIndex]^.InBest := False;
  Main_PlayList.AddBest(Main_PlayList.ItemIndex);
end;

procedure TPlay_List.ImgButton4Click(Sender: TObject);
begin
  if ImgButton4.Checked then
  begin
    ImgButton4.Hint := 'Повторять все [вкл]';
  end
  else
  begin
    ImgButton4.Hint := 'Повторять все [выкл]';
  end;
end;

procedure TPlay_List.ImgButton6Click(Sender: TObject);
begin
  if ImgButton6.Checked then
  begin
    ImgButton6.Hint := 'Случайный выбор [вкл]';
  end
  else
  begin
    ImgButton6.Hint := 'Случайный выбор [выкл]';
  end;
end;

procedure TPlay_List.ImgPlayList1DblClick(Sender: TObject);
begin
  if Main_Window.CurList.Count < 1 then
    exit;
  if  (Main_Window.CurList.itemindex < 0) or (Main_Window.CurList.itemindex > Main_Window.CurList.Count - 1) then
    Main_Window.CurList.itemindex := 0;
  if sender <> nil then
    Main_Window.Open2Play(Main_Window.CurList.DataItems[Main_Window.CurList.itemIndex]);
  Main_Window.CurList.PlayedIndex := Main_Window.CurList.itemIndex;
end;

procedure TPlay_List.FormCreate(Sender: TObject);
var
i:integer;
begin
Play_List.UpdateWorked:=false;
CurUpdateProc:=nil;
CdataList:=TStringList.Create;
Main_Window.CurList:=Main_PlayList;
  LibList:=TstringList.Create;
  ReadFolder(PlayListPath,'*.impl;',LibList);
for i:=0 to LibList.Count-1 do
CreatNewMenuItem(N16,nil,PopupMenu3.Items,GetFileName(LibList[i]));
Opendialog1.Filter := 'All playable files |' + supportFiles + PlayListFileExt + '|' +
  '(' + CompresFileExt + ')|' + CompresFileExt + '|' +
  '(' + LossLessFileExt + ')|' + LossLessFileExt + '|' +
  '(' + MusicFileExt + ')|' + MusicFileExt + '|' +
  '(' + MIDIFileExt + ')|' + MIDIFileExt + '|' +
  '(' + AudioCDFileExt + ')|' + AudioCDFileExt + '|' +
  '(' + PlayListFileExt + ')|' + PlayListFileExt + '|';
  Opendialog2.Filter := '(' + PlayListFileExt + ')|' + PlayListFileExt + '|';
  Main_PlayList.OnKeyDown := Main_Window.FormKeyDown;
  Main_PlayList.OnKeyUP := Main_Window.FormKeyUP;
  self.OnKeyDown := Main_Window.FormKeyDown;
  self.OnKeyUP := Main_Window.FormKeyUP;
  Main_PlayList.onListClear:=OnListClear;
  Play_List.DropFileTarget1.Register(self);
  Main_Window.DropFileTarget1.Register(Main_Window);
  Main_Window.DropFileTarget1.OnDrop:=DropFileTarget1Drop;
  Main_Window.N14.OnClick:=VK1Click;
    Main_Window.N2.OnClick:=ImgButton3Click;
end;

procedure TPlay_List.N2Click(Sender: TObject);
var
  i, ind: integer;
  Pl: Boolean;
begin
  if not Opendialog1.Execute then
    exit;
  List_Update.Show;
  ind := Main_PlayList.Count;
  if Opendialog1.Files.Count > 1 then
    pl := False
  else
    pl := True;
  for i := 0 to Opendialog1.Files.Count - 1 do
  begin
    application.ProcessMessages;
    Open_(Opendialog1.Files[i], pl);
  end;
  List_Update.Close;
  if NewItemIndex = -1 then
    NewItemIndex := ind;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
end;

Procedure TPlay_List.Add_Item(Item:pTrackData);
begin
       Main_PlayList.AddItem_(Item);
    case Options_Box.RadioGroup2.ItemIndex of
      0:
        begin
          Main_PlayList.MoveItem(Main_PlayList.Count - 1, 0);
          NewItemIndex := 0;
        end;
      1:
      NewItemIndex := -1;
      2:
        begin
          if (Main_PlayList.PlayedIndex <> -1) and (Main_PlayList.PlayedIndex + 1 <= Main_PlayList.Count - 1) then
          begin
            Main_PlayList.MoveItem(Main_PlayList.Count - 1, Main_PlayList.PlayedIndex + 1);
            NewItemIndex := Main_PlayList.PlayedIndex + 1;
          end;
        end;
    end;
end;

procedure TPlay_List.Open_(file_: string; ReadPl: boolean);
var
  ext: String;
  Newdat: PTrackData;
  Npos:integer;
begin
if Main_Window.CurList<>Main_PlayList then
 Main_Window.CurList:=Self.Main_PlayList;
  ext := '*' + ansistring(Lowercase(extractFileext(file_))) + ';';
  if ext = '*.lnk;' then
  begin
    file_ := GetFileNamefromLink(file_);
    ext := '*' + ansistring(Lowercase(extractFileext(file_))) + ';';
  end;
  if (Pos(ext, PlayListFileExt) <> 0) and (ReadPl) then
  begin
  Npos:=Main_PlayList.Count;
    try
      case Options_Box.RadioGroup3.ItemIndex of
        0:
          begin
            Main_PlayList.IMPL_Load(file_, false);
            NewItemIndex := -1;
          end;
        1:
          begin
            if  Main_PlayList.Count > 0 then
              List_Open.ShowModal
            else
              List_Open.RadioGroup1.ItemIndex := 1;
            
            case List_Open.RadioGroup1.ItemIndex of
              0:
                begin
                  Main_PlayList.IMPL_Load(file_, false);
                  NewItemIndex := -1;
                end;
              1:
                begin
                  Main_PlayList.IMPL_Load(file_, true);
                  Play_List.Main_PlayList.PlayedIndex := -1;
                end;
            end;
          end;
        2:
          begin
            if  Main_PlayList.Count > 0 then
              List_Open.ShowModal
            else
              List_Open.RadioGroup1.ItemIndex := 1;
            case List_Open.RadioGroup1.ItemIndex of
              0:
                begin
                  Main_PlayList.IMPL_Load(file_, false);
                  NewItemIndex := -1;
                end;
              1:
                begin
if  Main_PlayList.Count > 0 then
begin
List_Teg.OpenParams:=LTG_Write;
List_Teg.FileName:=Main_PlayList.ListHeader.Name;
List_Teg.List_Header:=Main_PlayList.ListHeader;
if List_Teg.ShowModal=1 then
self.Add2Lib(List_Teg.FileName);
end;
Main_PlayList.IMPL_Load(file_, true);
                  Play_List.Main_PlayList.PlayedIndex := -1;
                end;
            end;
          end;
      end;
   except
end;
  end
  else
  if (Pos(ext, supportFiles) <> 0) then
  begin
    New(Newdat);
    Newdat^.Name :=ExtractFileNameEX(GetFileName(File_));
    Newdat^.OrigName :=Newdat^.Name;
    Newdat^.filename := File_;
    Newdat^.time := 0;
    Newdat^.Format := UpperCase(Copy(ExtractFileEXT(File_), 2, Length(File_)));
    Newdat^.BitRate := 0;
    Newdat^.Freq := 0;
    Newdat^.InBest := False;
    Newdat^.VKFlag := False;
    Newdat^.InfoUpdt := True;
    Newdat^.CUEFlag := False;
    ADD_Item(Newdat);
        Newdat := nil;
  end;
UpdateListInfo(UpdatedCount);
end;

procedure TPlay_List.OpenFolder(path: String);
var
  fileList: TStringList;
  i: integer;
  ind: integer;
begin
  fileList := TStringList.Create;
  MyUtils.ReadFolder(path,supportFiles, FileList);
  ind := Main_PlayList.Count;
  for i := 0 to FileList.Count - 1 do
  begin
    application.ProcessMessages;
    Open_(FileList[i], false);
  end;
  if newItemIndex = -1 then
    NewItemIndex := ind;
  FileList.Clear;
  FileList.Free;
end;

procedure TPlay_List.Add2Lib(FileName:string);
var
fl:string;
begin
if fileexists(PlayListPath+FileNameStd(FileName)+'.impl') then
begin
if MessageBoxex(Application.Handle, 'Такой список уже существует.' + #13 + 'заменить его ?', AppName, MB_OKCANCEL or MB_ICONWarning, 0)=IDOK	then
Main_PlayList.IMPL_Save(FilenameCut(PlayListPath+FileNameStd(FileName),254)+'.impl',List_Teg.List_Header, IMPL);
end
else
begin
fl:= FilenameCut(PlayListPath+FileNameStd(FileName),254)+'.impl';
Main_PlayList.IMPL_Save(fl,List_Teg.List_Header, IMPL);
LibList.Add(fl);
CreatNewMenuItem(N16,nil,PopupMenu3.Items,GetFileName(fl));
end;
end;



procedure TPlay_List.N1Click(Sender: TObject);
var
  s: string;
begin
  S := DirDLG;
  if s = '' then
    exit;
  List_Update.Show;
  OpenFolder(s);
  List_Update.Close;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;


end;

procedure TPlay_List.DropFileTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
var
  i, ind: Integer;
  pl: boolean;
begin
  List_Update.Show;  { }
  ind := Main_PlayList.Count;
  if (Sender as TDropFileTarget).Files.Count > 1 then
    pl := False
  else
    pl := True;
  for i := 0 to (Sender as TDropFileTarget).Files.Count - 1 do
  begin
    if (FileGetAttr((Sender as TDropFileTarget).Files[i]) = fadirectory) or
    (extractFileext((Sender as TDropFileTarget).Files[i]) = '') then
    begin
      OpenFolder((Sender as TDropFileTarget).Files[i] + '\');
    end
    else
    begin
      application.ProcessMessages;
      Open_((Sender as TDropFileTarget).Files[i], pl);
    end;
  end;
  List_Update.Close;
    if Main_PlayList.Count>ind then
  begin
  if NewItemIndex = -1 then
    NewItemIndex := ind;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
   if  sender=Main_Window.DropFileTarget1 then
ImgPlayList1DblClick(self);
 end;
end;

procedure TPlay_List.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if edit1.Text = '' then
    edit1.Text := 'Поиск';
end;

procedure TPlay_List.FormShow(Sender: TObject);
begin
  Main_PlayList.SetFocus;
end;

procedure TPlay_List.ImgTrackBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edit1.Text = '' then
    edit1.Text := 'Поиск';
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
end;

procedure TPlay_List.ImgPlayList1Click(Sender: TObject);
begin
if (Main_Window.CurList<>Main_PlayList) and (Sender<>nil) then
Main_Window.CurList:=Main_PlayList;
  if (Main_PlayList.ItemIndex < 0) or (Main_PlayList.ItemIndex > Main_PlayList.Count - 1) then
    exit;
  if (not Main_PlayList.DataItems[Main_PlayList.ItemIndex]^.InBest) and ImgButton5.Checked  then
    ImgButton5.Click(true)
  else
  if (Main_PlayList.DataItems[Main_PlayList.ItemIndex]^.InBest) and (not ImgButton5.Checked)  then
    ImgButton5.Click(true);
end;

procedure TPlay_List.Edit1Click(Sender: TObject);
begin
  if edit1.Text = 'Поиск' then
    edit1.Text := '';
end;

procedure TPlay_List.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edit1.Text = 'Поиск' then
    edit1.Text := '';
end;

procedure TPlay_List.UpdateListInfo(offset:integer);

begin
if (CurUpdateProc<>nil) and Play_List.UpdateWorked then
exit;

CurUpdateProc:=TTagupgater.Create(true);
CurUpdateProc.FreeOnTerminate:=True;
CurUpdateProc.UpdateOffset:=offset;
CurUpdateProc.Priority := tpNormal;
CurUpdateProc.Resume;
end;

procedure TPlay_List.ImgButton8Click(Sender: TObject);
var
  P: TPoint;
begin
if Main_Window.CurList<>Main_PlayList then
 Main_Window.CurList:=Self.Main_PlayList;
if (VK2.Count<=0) and Options_Box.CheckBox25.Checked then
begin
UpdateVKBL;
end;
 if VK_Lib.VL_GetCount>0 then
begin
if VK_Lib.VL_GetItem(0)^.uid<>Widestring(Ansistring(ModuleHandle.GetCurUserID)) then
begin
If ModuleHandle.CanCallAPI then
Begin
VK_Lib.VL_ReWriteItem(0,Get_UserShortInfo(Widestring(Ansistring(ModuleHandle.GetCurUserID)),false));
VK2[0].Caption:=VK_Lib.VL_GetItem(0)^.name;
end;
end;
end;
  P.X := ImgButton8.Left;
  P.Y := ImgButton8.Top;
  P := ClientToScreen(P);
  PopupMenu4.Popup(P.X, P.Y);
end;

procedure TPlay_List.N9Click(Sender: TObject);
var
  ind: integer;
begin
  if not Opendialog2.Execute then
    exit;
  List_Update.Show;
  ind := Main_PlayList.Count;
  Open_(Opendialog2.Files[0], True);
  List_Update.Close;
  if NewItemIndex = -1 then
    NewItemIndex := ind;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
end;

procedure TPlay_List.N10Click(Sender: TObject);
var
ext:string;
begin
savedialog1.FileName:=FileNameStd(Main_PlayList.ListHeader.Name);
  if not savedialog1.Execute then
    exit;
  case savedialog1.FilterIndex of
    1:
   begin
List_Teg.OpenParams:=LTG_Write;
List_Teg.FileName:=ExtractFilename(saveDialog1.FileName);
if Lowercase(ExtractFileext(saveDialog1.FileName))='.impl' then
ext:=''
else
ext:='.impl';
List_Teg.List_Header:=Main_PlayList.ListHeader;
if List_Teg.ShowModal=1 then
Main_PlayList.IMPL_Save(FilenameCut(GetNewFileName(ExtractFilePath(saveDialog1.FileName),FileNameStd(List_Teg.FileName),'.impl'),254)+ext,List_Teg.List_Header, IMPL);
end;
    2:
      begin
        if Main_PlayList.HasCUE then
          MessageBoxex(Handle, 'Невозможно сохранить список в данном формате.', AppName, MB_OK or MB_ICONWarning, 0)
        else
        begin
        if Lowercase(ExtractFileext(saveDialog1.FileName))='.m3u' then
ext:=''
else
ext:='.m3u';
          Main_PlayList.IMPL_Save(Savedialog1.FileName + ext,Main_PlayList.ListHeader, M3U);
       end;
      end;
  end;
end;

procedure TPlay_List.N12Click(Sender: TObject);
begin
Main_PlayList.RegenList;
Main_PlayList.ItemIndex:=Main_PlayList.PlayedIndex;
end;

procedure TPlay_List.N11Click(Sender: TObject);
begin
List_Teg.OpenParams:=LTG_Write;
List_Teg.FileName:='текущий список';
List_Teg.List_Header:=Main_PlayList.ListHeader;
if List_Teg.ShowModal=1 then
Main_PlayList.ListHeader:=List_Teg.List_Header;
end;

Procedure  TPlay_List.UpdateVKBL;
Var
i:Integer;
begin
If ModuleHandle.CanCallAPI then
Begin
VL_AddItem(Get_UserShortInfo(Widestring(Ansistring(ModuleHandle.GetCurUserID)),false));
VL_ReadFromFile(PlayListPath+'VK_Lib.Vlb');
for i:=0 to VL_GetCount-1 do
With Play_List do
CreatNewMenuItem(VK2,nil,PopupMenu3.Items,VL_GetItem(i)^.Name);
end;
end;  

procedure TPlay_List.ImgPlayList1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
  Var
  CurItem:PTrackData;
begin
 if (Main_PlayList.ItemIndex < 0) or (Main_PlayList.ItemIndex > Main_PlayList.Count - 1) then
Main_PlayList.PopupMenu:=nil
else
begin
CurItem:=Main_PlayList.DataItems[Main_PlayList.itemindex];
Main_PlayList.PopupMenu:=PopupMenu5;
if CurItem^.VKFlag then
begin
N17.Enabled:=true;
N18.Enabled:=(ModuleHandle.CanCallAPI and (CurItem^.owner_id<>Widestring(Ansistring(ModuleHandle.GetCurUserID))));
end
else
begin
N17.Enabled:=False;
N18.Enabled:=False;
end ;
end;
CurItem:=nil;

end;

procedure TPlay_List.N6Click(Sender: TObject);
begin
Net_OpenDLG.showmodal;
end;

procedure TPlay_List.FormDestroy(Sender: TObject);
begin
LibList.Free;
CdataList.Free;
end;

procedure TPlay_List.N8Click(Sender: TObject);
begin
if  (Main_PlayList.Count>1) and (Options_Box.RadioGroup3.ItemIndex=2) and ((Sender as TMenuItem).Parent.Parent=n16) then
begin
List_Teg.OpenParams:=LTG_Write;
List_Teg.FileName:=Main_PlayList.ListHeader.Name;
List_Teg.List_Header:=Main_PlayList.ListHeader;
if List_Teg.ShowModal=1 then
self.Add2Lib(List_Teg.FileName);
end;
Main_PlayList.Clear;
List_Update.Show;
if (Sender as TMenuItem).Parent.Parent=n16 then
Main_PlayList.IMPL_Load(LibList[n16.IndexOf((Sender as TMenuItem).Parent)],True)
else
GetAudioList(VK_Lib.VL_GetItem(VK2.IndexOf((Sender as TMenuItem).Parent)),Main_PlayList,True);
 List_Update.Close;
  Main_PlayList.ItemIndex:=0;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
  Main_Window.CurList.OnDblClick(self);
UpdateListInfo(UpdatedCount);
end;

procedure TPlay_List.N7Click(Sender: TObject);
var
i:integer;
begin
List_Update.Show;
i:=Main_PlayList.Count;
if (Sender as TMenuItem).Parent.Parent=n16 then
Main_PlayList.IMPL_Load(LibList[n16.IndexOf((Sender as TMenuItem).Parent)],false)
else
GetAudioList(VK_Lib.VL_GetItem(VK2.IndexOf((Sender as TMenuItem).Parent)),Main_PlayList,False);
 List_Update.Close;
    if Main_PlayList.Count>i then
  begin
  Main_PlayList.ItemIndex:=i;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
  end;
UpdateListInfo(UpdatedCount);
end;

procedure TPlay_List.N14Click(Sender: TObject);
begin
if (Sender as TMenuItem).Parent.Parent=n16 then
begin
DeleteFile(LibList[n16.IndexOf((Sender as TMenuItem).Parent)]);
LibList.Delete(n16.IndexOf((Sender as TMenuItem).Parent));
n16.Remove((Sender as TMenuItem).Parent);
end
else
If VK2.IndexOf((Sender as TMenuItem).Parent)<>0 then
begin
VK_Lib.VL_DelItem(VK2.IndexOf((Sender as TMenuItem).Parent));
VK2.Remove((Sender as TMenuItem).Parent);
end
else
exit;
(Sender as TMenuItem).Parent.Free;
end;

procedure TPlay_List.VK1Click(Sender: TObject);
begin
if not Options_Box.CheckBox25.Checked then
exit;
If not ModuleHandle.CanCallAPI then
Begin
Case ModuleHandle.Log_In of
-1:
begin
ModuleHandle.ShowAuthDLG(True);
end;
-2:
MessageBox(Application.Handle, 'Ошибка доступа', AppName,MB_ICONQUESTION	or MB_OK );
-3:
MessageBox(Application.Handle, 'Отсутствует интернет соединение', AppName,MB_ICONQUESTION	or MB_OK );
0:
begin
(Sender as TMenuItem).Enabled:=False;
(Sender as TMenuItem).Enabled:=False;
VK_MUS.show;
end;
end;
end
else
begin
(Sender as TMenuItem).Enabled:=False;
VK_MUS.show;
end;
end;

procedure TPlay_List.FormClick(Sender: TObject);
begin
if Main_Window.CurList<>Main_PlayList then
 Main_Window.CurList:=Self.Main_PlayList;
end;

Procedure TPlay_List.DLItem(data:PTrackData);
var
Fl,Name,ext:String;
begin
Fl:=data^.filename;
ext:=LowerCase(copy(ExtractFileExt(Fl),0,pos('?',ExtractFileExt(Fl))-1));
SaveDialog2.Filter:='(' +ext  + ')|*'+ext+ '*|'  ;
Name:=FileNameStd(Data^.OrigName);
Savedialog2.FileName:=Name;
if not Savedialog2.Execute then
exit;
DL_adapt.DL_File(Fl,FilenameCut(ExtractFilePath(saveDialog2.FileName)+GetFileName(saveDialog2.FileName),MAX_PATH-10)+ext,False,true);
 end;


procedure TPlay_List.N17Click(Sender: TObject);
var
ind:integer;
begin
ind:=Main_PlayList.ItemIndex;
DLItem(Main_PlayList.DataItems[ind]);
end;

procedure TPlay_List.N18Click(Sender: TObject);
var
d:pTrackData;
begin
d:=Main_PlayList.DataItems[Main_PlayList.ItemIndex];
If AddAudio(d^.aid,d^.owner_id) then
begin
ShowMessage('Аудиозапись добавлена');
d^.owner_id:=Widestring(Ansistring(ModuleHandle.GetCurUserID));
end
else
ShowMessage('Ошибка при добавлении');
d:=nil;
end;

procedure TPlay_List.N15Click(Sender: TObject);
begin
if (Main_PlayList.ItemIndex < 0) or (Main_PlayList.ItemIndex > Main_PlayList.Count - 1) then
exit;
ShowTagDLG(Main_PlayList.DataItems[Main_PlayList.ItemIndex]);
end;

procedure TPlay_List.N23Click(Sender: TObject);
begin
if  Main_PlayList.Count > 0 then
begin
List_Teg.OpenParams:=LTG_Write;
List_Teg.FileName:=Main_PlayList.ListHeader.Name;
List_Teg.List_Header:=Main_PlayList.ListHeader;
if List_Teg.ShowModal=1 then
self.Add2Lib(List_Teg.FileName);
end;
end;

Procedure TPlay_List.OpenFromParamStr();
var
  i, ind: Integer;
  pl: boolean;
begin
  List_Update.Show;  { }
  ind := Main_PlayList.Count;
  if ParamCount > 1 then
    pl := False
  else
    pl := True;
  for i := 1 to ParamCount  do
  begin
    if (FileGetAttr(Paramstr(i)) = fadirectory) or
    (extractFileext(Paramstr(i)) = '') then
    begin
      OpenFolder(Paramstr(i) + '\');
    end
    else
    begin
      application.ProcessMessages;
        if (Pos(LowerCase(ExtractFileExt(Paramstr(i))), PlayListFileExt) <> 0) then
        N3Click(nil);
      Open_(Paramstr(i), pl);
    end;
  end;
  List_Update.Close;
    if Main_PlayList.Count>ind then
  begin
  if NewItemIndex = -1 then
    NewItemIndex := ind;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
if Options_Box.CheckBox1.Checked and (CdataList.Count<=0) then
ImgPlayList1DblClick(self);
 end;
end;

Procedure TPlay_List.OpenFromCdataList();
var
  i, ind: Integer;
  pl: boolean;
begin
  List_Update.Show;  { }
  ind := Main_PlayList.Count;
  if CdataList.Count > 1 then
    pl := False
  else
    pl := True;
  for i := 0 to CdataList.Count-1  do
  begin
    if (FileGetAttr(CdataList[i]) = fadirectory) or
    (extractFileext(CdataList[i]) = '') then
    begin
      OpenFolder(CdataList[i] + '\');
    end
    else
    begin
      application.ProcessMessages;
      if (Pos(LowerCase(ExtractFileExt(CdataList[i])), PlayListFileExt) <> 0) then
        N3Click(nil);
      Open_(CdataList[i], pl);
    end;
  end;
  List_Update.Close;
    if Main_PlayList.Count>ind then
  begin
  if NewItemIndex = -1 then
    NewItemIndex := ind;
  Main_PlayList.ItemIndex := NewItemIndex;
  ImgTrackBar1.Max := Main_PlayList.MaxScroll;
  ImgTrackBar1.Position := Main_PlayList.PosScroll;
if Options_Box.CheckBox1.Checked then
ImgPlayList1DblClick(self);
 end;
CdataList.Clear;
end;

procedure TPlay_List.SideListclick(Sender: TObject);
begin
if (sender as TimgPlayList).PlayedIndex=(sender as TimgPlayList).itemIndex then
 Main_Window.ImgButton1.Click(false)
 else
 (sender as TimgPlayList).OnDblClick(sender);

end;

Procedure TPlay_List.OnListClear(Sender: TObject);
begin
if (CurUpdateProc<>nil) and Play_List.UpdateWorked then
begin
CurUpdateProc.Terminate;
CurUpdateProc:=nil;
end;   {}
Main_PlayList.ItemIndex:=0;
Main_PlayList.PlayedIndex:=0;
NewItemIndex :=0;
self.UpdatedCount:=0;
end;

end.
