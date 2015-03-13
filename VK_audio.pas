unit VK_audio;

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
  Dialogs, StdCtrls, ImgPlayList, ImgFriendsList,VKAPI_types,VK_Methods,VK_Lib,
  Menus,MyUtils,DL_adapt,TagReader, Vcl.ComCtrls;

type
         TLists_Update= class(TThread)
         private
        procedure UpdateVKList;
        Procedure UpdateGroupList;
        Procedure PostUpdateVKList;
        Procedure PostUpdateGroupList;
         protected
             procedure Execute; override;
           end;

  TVK_MUS = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    GroupBox2: TGroupBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox2: TCheckBox;
    Button6: TButton;
    GroupBox3: TGroupBox;
    ImgPlayList1: TImgPlayList;
    ComboBox1: TComboBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PopupMenu2: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PopupMenu3: TPopupMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    SaveDialog1: TSaveDialog;
    PopupMenu5: TPopupMenu;
    N15: TMenuItem;
    N22: TMenuItem;
    N19: TMenuItem;
    N21: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ImgFriendsList1: TImgFriendsList;
    ImgFriendsList2: TImgFriendsList;
    Edit2: TEdit;
    Edit3: TEdit;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Button7: TButton;
    ComboBox2: TComboBox;
    CheckBox3: TCheckBox;
    GroupBox5: TGroupBox;
    ComboBox3: TComboBox;
    Label3: TLabel;
    Button8: TButton;
    CheckBox4: TCheckBox;
    N11: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ImgPlayList1Click(Sender: TObject);
    procedure ImgFriendsList1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure ImgPlayList1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImgPlayList1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure ImgPlayList1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Edit3KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PageControl1Change(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    { Private declarations }
    GroupLoad:boolean;
    MListLoad:boolean;
   procedure UpdateLists;
  public
    { Public declarations }
  end;

var
  VK_MUS: TVK_MUS;

implementation

uses Main, ListUpdateFRM, PlayList, AudioGroup_DL, OptionsBox;

{$R *.dfm}

var
CurUser:PUser;
CurPl:Integer;
CurUid:String;

procedure TLists_Update.UpdateVKList;
begin
With VK_MUS do
begin
if ModuleHandle.CanCallAPI then
begin
Main_Window.CurList:=ImgPlayList1;
GetFriendsShortInfoList(ImgFriendsList1);
end;
end;
end;

Procedure TLists_Update.PostUpdateVKList;
begin
With VK_MUS do
begin
MListLoad:=true;
ComboBox1.ItemIndex:=0;
If (imgPlayList1.Count=0) and (ImgFriendsList1.Count>0) then
begin
ImgFriendsList1.ItemIndex:=0;
ImgFriendsList1Click(ImgFriendsList1);
end;
end;
end;


Procedure  TLists_Update.UpdateGroupList;
begin
With VK_MUS do
begin
GroupLoad:=true;
if ModuleHandle.CanCallAPI then
begin
Main_Window.CurList:=ImgPlayList1;
GetGruupShortInfoList(ImgFriendsList2);
end;
end;
end;

Procedure TLists_Update.PostUpdateGroupList;
begin
With VK_MUS do
begin
VK_MUS.GroupLoad:=true;
ComboBox1.ItemIndex:=0;
If (imgPlayList1.Count=0) and (ImgFriendsList2.Count>0) then
begin
ImgFriendsList2.ItemIndex:=0;
end;
end;
end;

procedure TLists_Update.Execute;
begin
if (VK_MUS.PageControl1.TabIndex=1) and (not VK_MUS.GroupLoad) then
begin
Synchronize(self.UpdateGroupList);
Synchronize(PostUpdateGroupList);
end
else
if (VK_MUS.PageControl1.TabIndex=0) and (not VK_MUS.MlistLoad) then
begin
Synchronize(self.UpdateVKList);
Synchronize(PostUpdateVKList);
end;


{if GroupLoad then
exit;
UpdateGroupList;
}
end;



procedure TVK_MUS.FormShow(Sender: TObject);
begin
UpdateLists;
Play_List.VK1.Enabled:=True;
Main_window.N14.Enabled:=True;
end;

procedure TVK_MUS.ImgPlayList1Click(Sender: TObject);
begin
If (ImgPlayList1.ItemIndex<0) or (ImgPlayList1.ItemIndex>ImgPlayList1.Count-1) then
exit;
if Main_Window.CurList<>self.ImgPlayList1 then
Main_Window.CurList:=Self.ImgPlayList1;
If ImgPlayList1.DataItems[ImgPlayList1.ItemIndex]^.owner_id<>Widestring(Ansistring(ModuleHandle.GetCurUserID)) then
Begin
Button3.Enabled:=false;
N1.Enabled:=true;
end
else
begin
Button3.Enabled:=true;
N1.Enabled:=False;
end;
end;

procedure TVK_MUS.ImgFriendsList1Click(Sender: TObject);
begin
If ((Sender as TImgFriendsList).ItemIndex<0) and ((Sender as TImgFriendsList).ItemIndex>(Sender as TImgFriendsList).Count-1) then
exit;
CurPl:=ImgPlayList1.PlayedIndex;
  List_Update.Position := poScreenCenter;
  If sender<>nil then
  List_Update.Show;
  CurUser:=(Sender as TImgFriendsList).DataItems[(Sender as TImgFriendsList).itemIndex];
GetAudioList(CurUser,ImgPlayList1,true);
 If sender<>nil then
  List_Update.Close;
  If CurUser^.uid=CurUid then
  ImgPlayList1.PlayedIndex:=CurPl
  else
    CurUid:=CurUser^.uid;
  List_Update.Position := poDesigned;
  GroupBox3.Caption:='В списке '+Inttostr(ImgPlayList1.Count)+' аудиозаписей';
  if ImgPlayList1.Count>0 then
  begin
 ImgPlayList1.ItemIndex:=0;
ImgPlayList1Click(nil);
  end;
  end;

procedure TVK_MUS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if (Main_Window.CurList<>Play_List.Main_PlayList) and
(ImgPlayList1.PlayedIndex=-1) then
 Main_Window.CurList:=Play_List.Main_PlayList;
GroupLoad:=false;
MlistLoad:=false;
end;

procedure TVK_MUS.FormCreate(Sender: TObject);
begin
ImgPlayList1.OnDblClick:=Play_List.ImgPlayList1DblClick;
ImgPlayList1.OnMouseDown:=Play_List.ImgPlayList1MouseDown;
ImgPlayList1.OnMouseMove:=Play_List.ImgPlayList1MouseMove;
ImgPlayList1.OnMouseUp:=Play_List.ImgPlayList1MouseUp;
ImgPlayList1.ShowScroll:=True;
end;

procedure TVK_MUS.Edit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 32 then
    exit;
  if (key = 13) then
    ImgFriendsList1.FastSerch(edit2.Text, false)
  else
  ImgFriendsList1.FastSerch(edit2.Text, True);
end;

procedure TVK_MUS.Edit3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 32 then
    exit;
  if (key = 13) then
    ImgFriendsList2.FastSerch(edit3.Text, false)
  else
  ImgFriendsList2.FastSerch(edit3.Text, True);
end;

procedure TVK_MUS.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 32 then
    exit;
  if (key = 13) then
    ImgPlayList1.FastSerch(edit1.Text, false,Inlist)
  else
    ImgPlayList1.FastSerch(edit1.Text, True,Inlist);
end;

procedure TVK_MUS.Button1Click(Sender: TObject);
Var
opt:TAudiosearchOpt;
begin
try
List_Update.Position := poScreenCenter;
  List_Update.Show;
opt.auto_complete:=CheckBox1.Checked;
opt.Onlylyrics:=CheckBox2.Checked;
opt.sort_type:=ComboBox1.ItemIndex;
searchAudioList(Edit1.Text,opt,ImgPlayList1,True);
GroupBox3.Caption:='Найдено '+Inttostr(ImgPlayList1.Count)+' аудиозаписей';
finally
CurUid:='';
List_Update.Close;
List_Update.Position := poDesigned;
end;
end;

procedure TVK_MUS.Button2Click(Sender: TObject);
var
  P: TPoint;
begin
  P.X := Button2.Left;
  P.Y := Button2.Top;
  P := ClientToScreen(P);
  PopupMenu1.Popup(P.X, P.Y);
end;

procedure TVK_MUS.Button5Click(Sender: TObject);
var
  P: TPoint;
begin
  If (CurUid='') or (CurUid=Widestring(Ansistring(ModuleHandle.GetCurUserID))) or
  (ImgPlayList1.Count<=0)  then
  N3.Enabled:=False
  else
    N3.Enabled:=True;

  P.X := Button5.Left;
  P.Y := Button5.Top;
  P := ClientToScreen(P);
  PopupMenu2.Popup(P.X, P.Y);
end;

procedure TVK_MUS.Button4Click(Sender: TObject);
var
  P: TPoint;
begin
n6.Enabled:=(GetWindow(DL_adapt.TotalDlHandle,GW_OWNER)=0);
  P.X := Button4.Left;
  P.Y := Button4.Top;
  P := ClientToScreen(P);
  PopupMenu3.Popup(P.X, P.Y);
end;

procedure TVK_MUS.N1Click(Sender: TObject);
var
d:pTrackData;
begin
If (ImgPlayList1.ItemIndex<0) or (ImgPlayList1.ItemIndex>ImgPlayList1.Count-1) then
exit;
d:=ImgPlayList1.DataItems[ImgPlayList1.ItemIndex];
If AddAudio(d^.aid,d^.owner_id) then
ShowMessage('Аудиозапись добавлена')
else
ShowMessage('Ошибка при добавлении');
d:=nil;
end;

procedure TVK_MUS.Button3Click(Sender: TObject);
var
d:pTrackData;
ind:integer;
begin
ind:=ImgPlayList1.ItemIndex;
If (ImgPlayList1.ItemIndex<0) and (ImgPlayList1.ItemIndex>ImgPlayList1.Count-1) then
exit;
if MessageBox(Handle, 'Аудиозапись будет удалена из списка Вконтакте!' + #13 + 'Вы уверенны ?', 'WARNING',MB_ICONWARNING	or MB_YESNO)=IDNO then
exit;
d:=ImgPlayList1.DataItems[ind];
If DelAudio(d^.aid,d^.owner_id) then
begin
ShowMessage('Аудиозапись удалина') ;
ImgPlayList1.DelItem_(ind);
end
else
ShowMessage('Ошибка при удалении') ;
d:=nil;
end;

procedure TVK_MUS.N2Click(Sender: TObject);
begin
If (ImgPlayList1.ItemIndex<0) or (ImgPlayList1.ItemIndex>ImgPlayList1.Count-1) then
exit;
Play_List.Add_Item(CopyItem(ImgPlayList1.DataItems[ImgPlayList1.ItemIndex]));
Play_List.ImgTrackBar1.Max := Play_List.Main_PlayList.MaxScroll;
Play_List.ImgTrackBar1.Position := Play_List.Main_PlayList.PosScroll;
end;

procedure TVK_MUS.N4Click(Sender: TObject);
begin
  List_Update.Show;
Play_List.Main_PlayList.ItemIndex:=Play_List.Main_PlayList.Count-1;
GetAudioList(CurUser,Play_List.Main_PlayList,False);
Play_List.Main_PlayList.ItemIndex:=Play_List.Main_PlayList.ItemIndex+1;
List_Update.Close;
Play_List.ImgTrackBar1.Max := Play_List.Main_PlayList.MaxScroll;
Play_List.ImgTrackBar1.Position := Play_List.Main_PlayList.PosScroll;
end;

procedure TVK_MUS.N5Click(Sender: TObject);
begin
List_Update.Show;
GetAudioList(CurUser,Play_List.Main_PlayList,true);
Play_List.Main_PlayList.ItemIndex:=0;
List_Update.Close;
Play_List.ImgTrackBar1.Max := Play_List.Main_PlayList.MaxScroll;
Play_List.ImgTrackBar1.Position := Play_List.Main_PlayList.PosScroll;

end;

procedure TVK_MUS.N3Click(Sender: TObject);
var
uid:string;
begin
With Play_List do
begin
if (VK2.Count<=0) and Options_Box.CheckBox25.Checked then
begin
UpdateVKBL;
end;
end;
 uid:= CurUid;
 if Pos('-',CurUid)<>0 then
begin
  uid:=Copy(CurUid,2,Length(CurUid));
VL_AddItem(Get_GruupShortInfo(uid,false));
  end
  else
VL_AddItem(Get_UserShortInfo(uid,false));
With Play_List do
CreatNewMenuItem(VK2,nil,PopupMenu3.Items,VL_GetItem(VL_GetCount-1)^.Name);

end;

procedure TVK_MUS.ImgPlayList1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key=80) and (ssCtrl in Shift ) and n1.Enabled then
begin
N1Click(nil);
key:=0;
end;
if key=80 then
N2Click(nil);
if (key=46) and (ssCtrl in Shift ) and Button3.Enabled then
Button3Click(nil);

if (key=46) then
key:=0;
Main_Window.FormKeyDown(Sender,key,Shift);
end;

procedure TVK_MUS.ImgPlayList1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Main_Window.FormKeyUp(Sender,key,Shift);
end;

procedure TVK_MUS.Button6Click(Sender: TObject);
var
id:string ;
begin
if InputQuery('аудиозаписи по id','Введите id пользователя ВК для получения его аудиозаписей',id) then
begin
if (ModuleHandle.CanCallAPI) and (id<>'') then
begin
  CurUser:=VK_Methods.Get_UserShortInfo(id,false);
  if CurUser=nil then
  exit;
CurPl:=ImgPlayList1.PlayedIndex;
  List_Update.Position := poScreenCenter;
  List_Update.Show;
VK_Methods.GetAudioList(CurUser,ImgPlayList1,true);
List_Update.Close;
  If CurUser^.uid=CurUid then
  ImgPlayList1.PlayedIndex:=CurPl
  else
    CurUid:=CurUser^.uid;
  List_Update.Position := poDesigned;
  GroupBox3.Caption:='В списке '+Inttostr(ImgPlayList1.Count)+' аудиозаписей';
  if ImgPlayList1.Count>0 then
  begin
 ImgPlayList1.ItemIndex:=0;
ImgPlayList1Click(nil);
  end;
end;
end;
end;

procedure TVK_MUS.Button7Click(Sender: TObject);
var
genid:integer;
begin
try
genId:=combobox2.ItemIndex;
if combobox2.ItemIndex>19 then
genId:=combobox2.ItemIndex+1;
List_Update.Position := poScreenCenter;
  List_Update.Show;
GetPopAudioList(CheckBox3.Checked,genId,ImgPlayList1,True);
GroupBox3.Caption:='Популярные аудиозаписи ('+Inttostr(ImgPlayList1.Count)+')';
finally
CurUid:='';
List_Update.Close;
List_Update.Position := poDesigned;
end;
end;

procedure TVK_MUS.Button8Click(Sender: TObject);
begin
try
List_Update.Position := poScreenCenter;
  List_Update.Show;
GetRecomAudioList(checkBox4.Checked,self.ImgFriendsList1.DataItems[combobox3.ItemIndex],nil,ImgPlayList1,True);
GroupBox3.Caption:='Рекомендации для '+ImgFriendsList1.DataItems[combobox3.ItemIndex]^.Name+ ' ('+Inttostr(ImgPlayList1.Count)+')';
finally
CurUid:='';
List_Update.Close;
List_Update.Position := poDesigned;
end;
end;

procedure TVK_MUS.N7Click(Sender: TObject);
var
ind:integer;
begin
ind:=ImgPlayList1.ItemIndex;
If (ImgPlayList1.ItemIndex<0) and (ImgPlayList1.ItemIndex>ImgPlayList1.Count-1) then
exit;
Play_List.DLItem(ImgPlayList1.DataItems[ind]);
end;

procedure TVK_MUS.N6Click(Sender: TObject);
var
Form:TDL_AudioGroup;
begin
Form:=TDL_AudioGroup.Create(application,ImgPlayList1);
Form.ShowModal;
end;

procedure TVK_MUS.N8Click(Sender: TObject);
var
ext:string;
begin
savedialog1.FileName:=FileNameStd(ImgPlayList1.ListHeader.Name);
  if not savedialog1.Execute then
    exit;
  case savedialog1.FilterIndex of
    1:
   begin
   if Lowercase(ExtractFileext(saveDialog1.FileName))='.impl' then
ext:=''
else
ext:='.impl';
ImgPlayList1.IMPL_Save(Savedialog1.FileName + ext,ImgPlayList1.ListHeader, IMPL);
end;
    2:
      begin
        if Lowercase(ExtractFileext(saveDialog1.FileName))='.m3u' then
ext:=''
else
ext:='.m3u';
          ImgPlayList1.IMPL_Save(Savedialog1.FileName + ext,ImgPlayList1.ListHeader, M3U);
       end;
      end;
end;

procedure TVK_MUS.PageControl1Change(Sender: TObject);
begin
UpdateLists;
end;

procedure TVK_MUS.TabSheet3Show(Sender: TObject);
var
i:integer;
begin
Combobox3.Clear;
for I := 0 to ImgFriendsList1.Count-1 do
Combobox3.Items.Add(ImgFriendsList1[i].Name);
if Combobox3.Items.Count>0 then
Combobox3.ItemIndex:=0;

end;

procedure TVK_MUS.N11Click(Sender: TObject);
var
d:pTrackData;
begin
If (ImgPlayList1.ItemIndex<0) or (ImgPlayList1.ItemIndex>ImgPlayList1.Count-1) then
exit;
d:=ImgPlayList1.DataItems[ImgPlayList1.ItemIndex];
try
List_Update.Position := poScreenCenter;
  List_Update.Show;
GetRecomAudioList(false,nil,d,ImgPlayList1,True);
GroupBox3.Caption:='Аудиозаписи похожие на: '+d^.Name+ ' ('+Inttostr(ImgPlayList1.Count)+')';
finally
CurUid:='';
List_Update.Close;
List_Update.Position := poDesigned;
end;
end;

procedure TVK_MUS.N15Click(Sender: TObject);
begin
if (ImgPlayList1.ItemIndex < 0) or (ImgPlayList1.ItemIndex > ImgPlayList1.Count - 1) then
exit;
ShowTagDLG(ImgPlayList1.DataItems[ImgPlayList1.ItemIndex]);
end;

procedure TVK_MUS.ImgPlayList1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
 Var
  CurItem:PTrackData;
begin
 if (ImgPlayList1.ItemIndex < 0) or (ImgPlayList1.ItemIndex > ImgPlayList1.Count - 1) then
ImgPlayList1.PopupMenu:=nil
else
begin
CurItem:=ImgPlayList1.DataItems[ImgPlayList1.itemindex];
ImgPlayList1.PopupMenu:=PopupMenu5;
if CurItem^.owner_id= Widestring(Ansistring(ModuleHandle.GetCurUserID)) then
begin
N18.Visible:=False;
N19.Visible:=True;
end
else
begin
N19.Visible:=False;
N18.Visible:=True;
end;
  If (CurUid='') or (CurUid=Widestring(Ansistring(ModuleHandle.GetCurUserID))) or
  (ImgPlayList1.Count<=0)  then
  N10.Enabled:=False
  else
    N10.Enabled:=True;
  
end;
CurItem:=nil;


end;

   procedure TVK_MUS.UpdateLists;
   var
   Thr:TLists_Update;
   begin
   Thr:=TLists_Update.Create(true);
   Thr.FreeOnTerminate:=True;
   Thr.Priority := tpNormal;
   Thr.Resume;
   end;

end.
