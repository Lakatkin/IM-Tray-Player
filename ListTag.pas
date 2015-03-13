unit ListTag;

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
  Dialogs, StdCtrls,ImgPlayList,ID3v1;

type
TopenParam=(LTG_Read,LTG_Write);
  TList_TEG = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit6: TEdit;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Edit5: TEdit;
    Label7: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  OpenParams:TopenParam;
  List_Header:TimPlayList;
  FileName:string;
      Function ShowModal:integer; override;
  end;

var
  List_TEG: TList_TEG;

implementation

{$R *.dfm}

 Function TList_TEG.ShowModal:integer;
var
enbl:boolean ;
i:integer;
begin
If OpenParams=LTG_Write then
enbl:=false
else
enbl:=true;
For i:=1 to 6 do
(FindComponent('edit'+Inttostr(i)) as Tedit).ReadOnly:=enbl;
ComboBox1.Enabled:=(not enbl);
edit1.Text:=List_Header.Name;
edit2.Text:=List_Header.Artist;
edit3.Text:=List_Header.Album;
edit4.Text:=List_Header.Label_;
edit6.Text:=List_Header.Year;
edit5.Text:=FileName;
ComboBox1.Text:=List_Header.Genre;
Label8.Caption:='Количество файлов: '+List_Header.Tracks;
Result:=Inherited ShowModal;
end;

procedure TList_TEG.FormCreate(Sender: TObject);
var
i:integer;
begin
For i:=0 to ID3v1.MAX_MUSIC_GENRES-1 do
ComboBox1.Items.Add(MusicGenre[i]);
end;

procedure TList_TEG.Button1Click(Sender: TObject);
begin
ModalResult:=1;
List_Header.Name:=edit1.Text;
List_Header.Artist:=edit2.Text;
List_Header.Album:=edit3.Text;
List_Header.Label_:=edit4.Text;
List_Header.Year:=edit6.Text;
FileName:=edit5.Text;
List_Header.Genre:=ComboBox1.Text;

end;

procedure TList_TEG.Button2Click(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

end.
