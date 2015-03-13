unit AudioGroup_DL;

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
  Dialogs, StdCtrls,ImgPlayList, ExtCtrls,ConfigManger,MyUtils,DL_adapt;

type
  TDL_AudioGroup = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    Edit3: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    StartIndex:Integer;
    EndIndex:Integer;
    dlTo:string;
    AudioList:TImgPlayList;
  public
  constructor Create(AOwner: TComponent;  Audio_List:TImgPlayList);

    { Public declarations }
  end;

var
  DL_AudioGroup: TDL_AudioGroup;

implementation

{$R *.dfm}

procedure TDL_AudioGroup.Button1Click(Sender: TObject);
var
s:string;
begin
s:= DirDlg;
if s<>'' then
begin
DlTo:=s;
edit3.Text:=DlTo;
end;
end;

constructor TDL_AudioGroup.Create(AOwner: TComponent;Audio_List:TImgPlayList);
begin
inherited Create(AOwner);
if Audio_List=nil then
exit;
AudioList:=Audio_List;
dlTo:=ConfigManger.dlPath;
Edit3.Text :=dlTo;
Edit1.Text:='1';
Edit2.Text:=inttostr(AudioList.Count);
RadioGroup1.ItemIndex:=0;
end;

procedure TDL_AudioGroup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action := caFree;
end;

procedure TDL_AudioGroup.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in['0'..'9',decimalseparator,#8]) then key:=#0;
end;

procedure TDL_AudioGroup.Button2Click(Sender: TObject);
begin
StartIndex :=StrToint(edit1.Text)-1;
EndIndex   :=StrToint(edit2.Text)-1;
if (StartIndex<0) or (StartIndex >AudioList.Count-1) then
StartIndex:=0;
if (EndIndex<0) or (EndIndex >AudioList.Count-1) then
EndIndex:=AudioList.Count-1;
dlTo:=dlTo+AudioList.ListHeader.Name+'\';
  if not directoryexists(dlTo) then
    CreateDirectory(Pchar(dlTo), nil);
    Dl_adapt.DL_FullList(AudioList,StartIndex,EndIndex,DlTo,RadioGroup1.ItemIndex+1,self.CheckBox1.Checked);
    Close;
end;

end.
