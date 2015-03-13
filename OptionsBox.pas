unit OptionsBox;

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
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, CheckLst, Spin,
  skinEngine, MyUtils, ConfigManger, imgGraphicHint,
  Sound_Engine,VKAPI_types,VK_Methods,VK_Lib,strUtils, Menus,TagReader;

type
  TOptions_BOX = class(TForm)
    PageControl1: TPageControl;
    Button1: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    CheckListBox1: TCheckListBox;
    CheckBox1: TCheckBox;
    GroupBox4: TGroupBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    RadioGroup1: TRadioGroup;
    CheckBox5: TCheckBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    GroupBox9: TGroupBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    GroupBox8: TGroupBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    Button8: TButton;
    GroupBox10: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox15: TCheckBox;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    CheckBox7: TCheckBox;
    SpinEdit6: TSpinEdit;
    CheckBox18: TCheckBox;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox2: TCheckBox;
    Label7: TLabel;
    Label6: TLabel;
    SpinEdit2: TSpinEdit;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    SpinEdit9: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    Button6: TButton;
    CheckBox25: TCheckBox;
    Label5: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label12: TLabel;
    Edit4: TEdit;
    Button2: TButton;
    Button7: TButton;
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit6Change(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox18Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure SpinEdit7Change(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure SpinEdit5Change(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpinEdit8Change(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure CheckBox20Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpinEdit9Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox23Click(Sender: TObject);
    procedure CheckBox25Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private 
    { Private declarations }
    Function CheckAssociate:boolean;
    Procedure AssociateByInd(Ind:Integer);
    Procedure UnAssociateByInd(Ind:Integer);


  public
 procedure LoadSkinByNum(num:Integer);
 procedure  LoadSkinE(Sender: TObject);
    { Public declarations }
  end;

var
  Options_BOX: TOptions_BOX;

implementation

uses
  Main, EQ, PlayList, ListUpdateFRM, SkinList;

{$R *.dfm}

var
  DevList: TStringList;

Function TOptions_BOX.CheckAssociate:boolean;
var
i:integer;
begin
result:=true;  {
If not IsFileAssociate('eqs',AppName+' Equalizer') then
FileAssociate('eqs',AppName+' Equalizer',IconsPath+'Equalizer.ico');
If not IsFileAssociate('imsk',AppName+' Skin') then
begin
FileAssociate('imsk',AppName+' Skin',IconsPath+'Skins.ico');
end;   }
For i:=0 to 21 do
Begin
CheckListBox1.Checked[i]:=IsFileAssociate(CheckListBox1.Items[i],AppName+' File');
Result:=Result and CheckListBox1.Checked[i];
end;
For i:=22 to 24 do
Begin
CheckListBox1.Checked[i]:=IsFileAssociate(CheckListBox1.Items[i],AppName+' List');
Result:=Result and CheckListBox1.Checked[i];
end;
end;

Procedure TOptions_BOX.AssociateByInd(Ind:Integer);
Begin
Case ind of
0..21:MyUtils.FileAssociate(CheckListBox1.Items[Ind],AppName+' File',IconsPath+'AudioFile.ico');
22..24:MyUtils.FileAssociate(CheckListBox1.Items[Ind],AppName+' List',IconsPath+'List.ico')
end;
 end;

Procedure TOptions_BOX.UnAssociateByInd(Ind:Integer);
Begin
Case ind of
0..21:
MyUtils.FileUnAssociate(CheckListBox1.Items[Ind],AppName+' File');
22..24:
MyUtils.FileUnAssociate(CheckListBox1.Items[Ind],AppName+' List');
end;
end;

procedure TOptions_BOX.LoadSkinByNum(num:Integer);
var
PLW,PLH:Integer;
Begin
PLW:=Play_List.Width;
PLH:=Play_List.Height;
Main_Window.FrmMode:=1;
  CurStin:=SkinEngine.SkinList[Num];
  if not LoadSkin(CurStin,@CallBackSkinLoad) then
  begin
   MessageBoxex(Application.Handle, 'Skin not found or skin files are corrupt' + #13 + 'Application will load standart skin', AppName, MB_OK or MB_ICONWarning, 0);
   Main_Window.FrmMode:=1;
  CurStin:=SkinPath+'Default.imsk' ;
  LoadSkin(CurStin,@CallBackSkinLoad);
  end;
  if Main_Window.Left > (Screen.WorkAreaWidth - Main_Window.Width) then
    Main_Window.Left := Screen.WorkAreaWidth - Main_Window.Width;
 if Main_Window.Top > (Screen.WorkAreaHeight - Main_Window.Height) then
  Main_Window.Top := Screen.WorkAreaHeight - Main_Window.Height;
Play_List.Width:=PLW;
Play_List.Height:=PLH;
Play_List.imgFormResizer1ResizeEnd(nil);
         Play_List.Invalidate;
         Main_Window.Invalidate;
         EQ_BOX.TransparentColor := True;
          EQ_BOX.TransparentColorValue := EQMain.Canvas.Pixels[0, 0];{}
          EQ_BOX.Repaint;
          EQ_BOX.Invalidate;
         Label4.Caption:=SkinEngine.CurSkinHDR.SkinName;
   end;

 procedure  TOptions_BOX.LoadSkinE(Sender: TObject);
 begin
LoadSkinByNum(Main_Window.N3.IndexOf((Sender as TMenuItem)));
end;

procedure TOptions_BOX.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Text = '' then
    exit;
  if Main_Window.FrmMode = 1 then
    Main_Window.ImgRunString1.Interval := SpinEdit1.Value;
end;

procedure TOptions_BOX.SpinEdit2Change(Sender: TObject);
begin
  if SpinEdit2.Text = '' then
    exit;
  if Main_Window.FrmMode = 2 then
    Main_Window.ImgRunString1.Interval := SpinEdit2.Value;
  
end;

procedure TOptions_BOX.SpinEdit3Change(Sender: TObject);
begin
  if SpinEdit3.Text = '' then
    exit;
  Main_Window.alphaNorm := 60 + Trunc((SpinEdit3.Value * 255) / 132);
  if Main_Window.FrmMode = 1 then
    Main_Window.AlphaBlendValue := Main_Window.alphaNorm;
  
end;

procedure TOptions_BOX.SpinEdit6Change(Sender: TObject);
begin
  if SpinEdit6.Text = '' then
    exit;
  Main_Window.alphaMini := 60 + trunc((SpinEdit6.Value * 255) / 132);
  if Main_Window.FrmMode = 2 then
    Main_Window.AlphaBlendValue := Main_Window.alphaMini;
end;

procedure TOptions_BOX.CheckBox8Click(Sender: TObject);
begin
  if Main_Window.FrmMode = 1 then
    Main_Window.AlphaBlend := CheckBox8.Checked;
  SpinEdit3.Enabled := CheckBox8.Checked;
end;

procedure TOptions_BOX.CheckBox18Click(Sender: TObject);
begin
  if Main_Window.FrmMode = 2 then
    Main_Window.AlphaBlend := CheckBox18.Checked;
  SpinEdit6.Enabled := CheckBox18.Checked;
end;

procedure TOptions_BOX.CheckBox7Click(Sender: TObject);
begin
  SpinEdit9.Enabled := CheckBox7.Checked;
  if (Main_Window.FrmMode = 2) and (not Options_Box.CheckBox7.Checked) then
  begin
    Main_Window.FrmMode := 1;
    Main_Window.SetMinMax(Main_Window.FrmMode);
  end;
  Main_Window.Timer1.Enabled := Options_Box.CheckBox7.Checked;
  Main_Window.Timer2.Enabled := Options_Box.CheckBox7.Checked;
end;

procedure TOptions_BOX.FormCreate(Sender: TObject);
Var
FromVK:boolean;
i:integer;
begin
GetSkin;
For i:=0 to  Skin_List.ListBox1.Count-1 do
CreatNewMenuItem(Main_Window.N3,LoadSkinE,nil,Skin_List.ListBox1.Items[i]);
FromVK:=false;
SendMessage(edit2.Handle, EM_SETPASSWORDCHAR, Ord('*'), 0);
 if not LoadSkin(CurStin,@CallBackSkinLoad) then
 begin
 CurStin:=SkinPath+'Default.imsk' ;
  if not LoadSkin(CurStin,@CallBackSkinLoad) then
  begin
    MessageBoxex(Application.Handle, 'Skin not found or skin files are corrupt' + #13 + 'Application will load standart skin', AppName, MB_OK or MB_ICONWarning, 0);
    MessageBoxex(Application.Handle, 'Critical error at application loading' + #13 + 'Please reinstall this program', AppName, MB_OK or MB_ICONERROR, 0);
    Windows.TerminateProcess(Windows.GetCurrentProcess,0);
  end;
  end;
  Label4.Caption:=SkinEngine.CurSkinHDR.SkinName;
  if not Sound_Engine.Loading_dll(ModulesPath + 'Bass Engine\') then
  begin
    MessageBoxex(Application.Handle, 'Critical error at application loading' + #13 + 'Please reinstall this program', AppName, MB_OK or MB_ICONERROR, 0);
  Windows.TerminateProcess(Windows.GetCurrentProcess,0);
  end;
  If (Not Load_VKAPIDLL(ModulesPath + '\VK_API.dll'))  then
    begin
    MessageBoxex(Application.Handle, 'Critical error at application loading' + #13 + 'Please reinstall this program', AppName, MB_OK or MB_ICONERROR, 0);
  Windows.TerminateProcess(Windows.GetCurrentProcess,0);
  end;
  ModuleHandle:=Init_VK_API^;
  DevList := TStringList.Create;
  Sound_Engine.GetDeviceList(DevList);
    ComboBox1.Items.Assign(DevList);
  DevList.Free;
  /////Set Assoc////////
  if (not CheckAssociate) and (CheckBox2.Checked) then
  begin
  Case MessageBox(Handle, 'Некоторые файлы не ассоциированы с ' +appName+ #13 + 'Исправить это ?', 'WARNING',MB_ICONQUESTION	or MB_YESNOCANCEL )  of
     IDYES:
     Button4Click(Button4);
     IDNO:
       CheckBox2.Checked:=False;
       IDCANCEL:
       end;
  end;
   //////Load Settings,Load Options, Init VK,Load PlayList //////
   try
   ShowWindow(Application.Handle, SW_HIDE);
     Init_vk;
  List_Update.Position := poScreenCenter;
  List_Update.Show;
      except on EAccessViolation do
        Windows.TerminateProcess(Windows.GetCurrentProcess,0);
    end;
  if ModuleHandle.CanCallAPI and CheckBox24.Checked then
  begin
  GetAudioList(VK_Lib.VL_GetItem(0),Play_List.Main_PlayList,True);
  if  Play_List.Main_PlayList.Count>0 then
  FromVK:=True;
  end
  else
  Play_List.Main_PlayList.IMPL_Load(MyUtils.SelfPath + 'CurList.impl', true);
  List_Update.Close;
  List_Update.Position := poDesigned;
  LoadSettings;
  LoadConfig;
  if not FromVK and (((paramcount<=0)or (Play_List.CdataList.Count<0))  or (not checkBox1.Checked)) then
  LoadPlaing;
  ////////ParamStr data
    if paramcount >= 1 then
  begin
Play_List.OpenFromParamStr;
end;
Play_List.OpenFromCdataList;  {
Play_List.UpdateListInfo(0);   }
end;

procedure TOptions_BOX.CheckBox10Click(Sender: TObject);
begin
  
  EQ_BOX.AlphaBlend := CheckBox10.Checked;
  SpinEdit7.Enabled := CheckBox10.Checked;
end;

procedure TOptions_BOX.SpinEdit7Change(Sender: TObject);
begin
  if SpinEdit7.Text = '' then
    exit;
  EQ_BOX.AlphaBlendValue := 60 + trunc((SpinEdit7.Value * 255) / 132);
end;

procedure TOptions_BOX.CheckBox14Click(Sender: TObject);
begin
  Play_List.AlphaBlend := CheckBox14.Checked;
  SpinEdit4.Enabled := CheckBox14.Checked;
end;

procedure TOptions_BOX.SpinEdit4Change(Sender: TObject);
begin
  if SpinEdit4.Text = '' then
    exit;
  Play_List.AlphaBlendValue := 60 + trunc((SpinEdit4.Value * 255) / 132);
end;

procedure TOptions_BOX.CheckBox11Click(Sender: TObject);
begin
  if CheckBox11.Checked then
    HintWindowClass := TImgGraphicHintWindow
  else
    HintWindowClass := THintWindow;
  SpinEdit5Change(nil);
  CheckBox12Click(nil);
end;

procedure TOptions_BOX.SpinEdit5Change(Sender: TObject);
begin
  if SpinEdit5.Text = '' then
    exit;
  HintAlphaBlendValue := 60 + trunc((SpinEdit5.Value * 255) / 132);
end;

procedure TOptions_BOX.CheckBox12Click(Sender: TObject);
begin
  HintAlphaBlend := CheckBox12.Checked;
  SpinEdit5.Enabled := CheckBox12.Checked;
end;

procedure TOptions_BOX.ComboBox1Change(Sender: TObject);

begin
If sender<>nil then
begin
MessageBoxex(Handle, 'Изменения вступят в силилу при следующим запуске', AppName, MB_OK or MB_ICONInformation, 0);
    exit;
end;
  if not SetOutDevice(ComboBox1.ItemIndex + 1, 44100, Main_Window.Handle) then
  begin
    MessageBoxex(Handle, 'Error initialization output devise', AppName, MB_OK or MB_ICONWarning, 0);
    exit;
  end;
end;

procedure TOptions_BOX.SpinEdit8Change(Sender: TObject);
var
  Vl: Integer;
begin
  if SpinEdit8.Text = '' then
    exit;
  try
    Vl := StrToint(SpinEdit8.Text);
  except
    exit;
  end;
  Sound_Engine.SetBufsize(Vl);
end;

procedure TOptions_BOX.CheckBox3Click(Sender: TObject);
begin
  Sound_Engine.SetVolume(Main_Window.ImgTrackBar2.Position, Options_Box.CheckBox3.Checked);
end;

procedure TOptions_BOX.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
  begin
    if not IsAutoRun(appName, application.ExeName) then
      SetAutoRun(appName, application.ExeName);
  end
  else
    delAutoRun(appName);
end;

procedure TOptions_BOX.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked then
  begin
    Main_Window.ImgButton3.OnClick := Main_Window.ImgButton3Click;
    Main_Window.ImgButton4.OnClick := Main_Window.ImgButton4Click;
  end
  else
  if RadioButton2.Checked then
  begin
    Main_Window.ImgButton3.OnClick := Main_Window.ImgButton4Click;
    Main_Window.ImgButton4.OnClick := Main_Window.ImgButton3Click;
  end;
end;

procedure TOptions_BOX.CheckBox20Click(Sender: TObject);
begin
  Play_List.Main_PlayList.AddNum := CheckBox20.Checked;
  Play_List.Main_PlayList.Repaint;
end;

procedure TOptions_BOX.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TOptions_BOX.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveConfig;
end;

procedure TOptions_BOX.SpinEdit9Change(Sender: TObject);
var
  Vl: Integer;
begin
  if SpinEdit9.Text = '' then
    exit;
  try
    Vl := StrToint(SpinEdit9.Text);
  except
    exit; 
  end;
  Main_Window.Timer1.Interval := vl;
end;

procedure TOptions_BOX.FormDestroy(Sender: TObject);
begin
  ModuleHandle.Free;
Unload_VKAPIDLL;
end;

procedure TOptions_BOX.Button6Click(Sender: TObject);
begin
button6.Enabled:=False;
if sender<>nil then
begin
ModuleHandle.SetLogin(Pchar((edit1.text)));
ModuleHandle.setPass(Pchar((edit2.text)));
end;
{Case ModuleHandle.Log_In of
-1:
begin
MessageBox(Application.Handle, 'Не верный логи или пароль', AppName,MB_ICONQUESTION	or MB_OK );
if sender=nil then
begin
ModuleHandle.ShowAuthDLG(True);
end;
end;
-2:
MessageBox(Application.Handle, 'Ошибка доступа', AppName,MB_ICONQUESTION	or MB_OK );
-3:
MessageBox(Application.Handle, 'Отсутствует интернет соединение', AppName,MB_ICONQUESTION	or MB_OK );
0:
begin }
if ModuleHandle.CanCallAPI  then
Main_Window.VK_Status:=VK_Methods.GetStatus(Widestring(Ansistring(ModuleHandle.GetCurUserID)))
else
Main_Window.VK_Status:='<none>';
if (Play_List.VK2.Count<=0) and Options_Box.CheckBox25.Checked then
begin
Play_List.UpdateVKBL;
{end;
end;  }
end;
button6.Enabled:=true;
 end;
 
procedure TOptions_BOX.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
If key=#13 then
begin
key:=#0;
Button6Click(Button6);
end;
end;

procedure TOptions_BOX.CheckBox23Click(Sender: TObject);
begin
If (sender<> nil) and (Main_Window.VK_Status<>'<none>')then
if ModuleHandle.CanCallAPI and (not Options_Box.CheckBox23.Checked) and Options_Box.CheckBox25.Checked then
  VK_Methods.SetStatus(Main_Window.VK_Status)
  else

end;

procedure TOptions_BOX.CheckBox25Click(Sender: TObject);
begin
if  Options_Box.CheckBox25.Checked then
begin
if not Main_Window.isInitVk then
begin
Main_Window.isInitVk:=ModuleHandle.Init(hinstance,application.handle,false);
end;
button6.Enabled:=true;
//Options_Box.Edit1.Text:=Widestring(ModuleHandle.GetLogin);
//Options_Box.Edit2.Text:=ReverseString(Widestring(ModuleHandle.HidePass(ModuleHandle.GetPass)));
end
else
begin
button6.Enabled:=false;
Options_Box.Edit1.Text:='';
Options_Box.Edit2.Text:='';
end;
end;

procedure TOptions_BOX.Button2Click(Sender: TObject);
var
s:string;
begin
s:= DirDlg;
if s<>'' then
begin
DlPath:=s;
edit4.Text:=DlPath;
end;
end;

procedure TOptions_BOX.Button7Click(Sender: TObject);
begin
Skin_List.Show;
end;

procedure TOptions_BOX.CheckListBox1ClickCheck(Sender: TObject);
begin
If CheckListBox1.Checked[CheckListBox1.ItemIndex] then
begin
Self.AssociateByInd(CheckListBox1.ItemIndex);
end
else
Self.UnAssociateByInd(CheckListBox1.ItemIndex);
end;

procedure TOptions_BOX.Button4Click(Sender: TObject);
var
i:Integer;
begin
For i:=0 to CheckListBox1.Count-1 do
begin
if sender=Button4 then
CheckListBox1.Checked[i]:=true
else
if sender=Button3 then
CheckListBox1.Checked[i]:=false;
CheckListBox1.ItemIndex:=i;
CheckListBox1ClickCheck(CheckListBox1);
end;
end;

procedure TOptions_BOX.Button8Click(Sender: TObject);
begin
ResetConfig;
end;

end.
