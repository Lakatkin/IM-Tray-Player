unit VKtag_BOX;

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
  Dialogs, StdCtrls, ComCtrls,Sound_engine,ImgPlayList,Shellapi,VK_Methods;

type
  TVKtag_Info = class(TForm)
    Label10: TLabel;
    Edit6: TEdit;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TitleLabel: TLabel;
    ArtistLabel: TLabel;
    AlbumLabel: TLabel;
    YearLabel: TLabel;
    GenreLabel: TLabel;
    TitleEdit: TEdit;
    ArtistEdit: TEdit;
    AlbumEdit: TEdit;
    YearEdit: TEdit;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    CommentLabel: TLabel;
    EditGenre: TEdit;
    ChannelModeLabel: TLabel;
    DurationLabel: TLabel;
    DurationText: TEdit;
    SampleRateLabel: TLabel;
    SampleRateText: TEdit;
    BitRateLabel: TLabel;
    BitRateText: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Text: TTabSheet;
    Memo2: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent;data:pTrackData);
    { Public declarations }
  end;

var
  VKtag_Info: TVKtag_Info;

implementation

{$R *.dfm}

constructor TVKtag_Info.Create(AOwner: TComponent;data:pTrackData);
Begin
inherited Create(AOwner);
Edit6.Text:=data^.OrigName;
edit3.Text:=data^.aid;
if Pos('-',data^.owner_id)=0 then
edit1.Text:='http://vk.com/id'+data^.owner_id
else
edit1.Text:='http://vk.com/club'+Copy(data^.owner_id,2,length(data^.owner_id));
if (pos('null',data^.Uploader_id)>0) then
edit2.Text:='http://vk.com'
else
begin
if Pos('-',data^.Uploader_id)=0 then
edit2.Text:='http://vk.com/id'+data^.Uploader_id
else
edit2.Text:='http://vk.com/club'+Copy(data^.Uploader_id,2,length(data^.Uploader_id));
end;
if ModuleHandle.CanCallAPI then
Memo2.Lines.Text:=VK_Methods.getLyrics(data^.lyrics_id);
With Sound_Engine.GetExtendedTag(data^.filename) do
Begin
TitleEdit.Text:= title;
AlbumEdit.Text:=album;
ArtistEdit.Text:=artist;
YearEdit.Text:=year;
EditGenre.Text:=gener;
self.Memo1.Lines.Text:=comment;
SampleRateText.Text := IntToStr(SampleRate) + ' hz';
DurationText.Text := IntToStr(Time) + ' sec.';
BitRateText.Text := IntToStr(BitRate) + ' kbit';


end;


end;

procedure TVKtag_Info.Button3Click(Sender: TObject);
begin
Close;
end;

procedure TVKtag_Info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

procedure TVKtag_Info.Edit1DblClick(Sender: TObject);
begin
Shellexecute(Handle,'open',pchar((Sender as TEdit).Text),nil,nil,sw_sHOW);
end;

end.
