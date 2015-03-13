unit TAG_BOX;

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
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Vcl.ExtDlgs,bass_EX_tag,
  Vcl.Imaging.JPEG,Vcl.Imaging.pngimage,Vcl.Imaging.GifImg;

type
  TAudio_Info = class(TForm)
    Edit6: TEdit;
    Button3: TButton;
    Button2: TButton;
    Label10: TLabel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Memo2: TMemo;
    TabSheet4: TTabSheet;
    Image1: TImage;
    TabSheet3: TTabSheet;
    FileSizeLabel: TLabel;
    SampleRateLabel: TLabel;
    EncoderLabel: TLabel;
    DurationLabel: TLabel;
    ChannelModeLabel: TLabel;
    BitRateLabel: TLabel;
    FileSizeText: TEdit;
    SampleRateText: TEdit;
    EncoderText: TEdit;
    DurationText: TEdit;
    ChannelModeText: TEdit;
    BitRateText: TEdit;
    Button1: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    SavePictureDialog1: TSavePictureDialog;
    ComboBox1: TComboBox;
    Button5: TButton;
    ComposerEdit: TEdit;
    ComposerLabel: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    idTag: TBassTag;
    NoImg:TBitMap;
    nullPicture:TBitMap;
    procedure OpenFile(filename: string);
    { Private declarations }
  public
  error:boolean;
  constructor Create(AOwner: TComponent;FileName:String);
    { Public declarations }
  end;

var
  Audio_Info: TAudio_Info;

implementation
{$R *.dfm}

uses Main;

procedure TAudio_Info.OpenFile(filename: string);
begin
 if not FileExists(filename) then
  exit;
 idTag.LoadFile(filename);
 if idtag.Loaded then
  begin
   with idtag.tag do
   begin
   error:=false;
     Edit3.Text:=Album;
     Edit2.Text:=Artist;
     Memo2.Text:=Comment;
     ComposerEdit.Text:=Composer;
     Combobox1.Text:=Genre;
     Edit1.Text:=Title;
     Edit4.Text:=Track;
     Edit5.Text:=Year;
     FileSizeText.Text:=IntTostr(FileSize)+ ' bytes';
     BitRateText.Text:=IntTostr(BitRate)+ ' kbit/s';
     SampleRateText.Text:=IntTostr(SampleRate)+ ' hz';
     ChannelModeText.Text:=ChannelMode;
     DurationText.Text:=IntTostr(Duration) + ' sec.';
     EncoderText.Text:=Encoder;
     ComposerEdit.Text:= Composer;
   end;
   idtag.getPicture(Image1.Picture.Bitmap);
 end
 else
 begin
   error:=true;
      ShowMessage('Неизвестный формат файла');
 end;

end;


constructor TAudio_Info.Create(AOwner: TComponent;FileName:String);
var
i:Integer;
Begin
inherited Create(AOwner);
 idTag:=TBassTag.Create;
 NoImg:=TBitMap.Create;
 nullPicture:=TBitMap.Create;
 nullPicture.Width:=0;
 nullPicture.Height:=0;
 NoImg.LoadFromResourceID(Hinstance,1000);
 OpenDialog1.Filter:=BassTagOpenDialogImages;
 SavePictureDialog1.Filter:='jpg|*.jpg';
 Combobox1.Items.AddStrings(Genres);
 Edit6.Text:=FileName;
  Image1.Picture.Assign(NoImg);
OpenFile(FileName);
 SavePictureDialog1.FileName:=idTag.tag.Album +'.jpg';
end;


procedure TAudio_Info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
idTag.Free;
Action := caFree;
end;

procedure TAudio_Info.Button1Click(Sender: TObject);
begin
  if idtag.PictureSupport and OpenDialog1.Execute  then
  begin
try
      idtag.SavePictureByFile(OpenDialog1.FileName);
      Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    except
      ShowMessage('Не поддерживаемый формат картинки');
    end;

  end;
end;

procedure TAudio_Info.Button2Click(Sender: TObject);
begin
if not IDtag.Loaded then
exit;
with IDtag.tag do
begin
  Album	:=	Edit3.Text;
  Artist	:=	Edit2.Text;
  Comment	:=	Memo2.Text;
  Genre	:=	Combobox1.Text;
  Title	:=	Edit1.Text;
  Track	:=	Edit4.Text;
  Year	:=	Edit5.Text;
end;
Main_Window.breakPlay;
  IDtag.SaveToFile;
Main_Window.resumPlay;
Image1.tag:=0;
end;

procedure TAudio_Info.Button3Click(Sender: TObject);
begin
Close;
end;

procedure TAudio_Info.Button4Click(Sender: TObject);
var J: TJpegImage;
begin
  if idTag.PictureSupport then
  if SavePictureDialog1.Execute then begin
    if Image1.Picture.Graphic is TBitmap then begin
      J:=TJPEGImage.Create;
      j.Assign(Image1.Picture.Graphic);
      j.SaveToFile(SavePictureDialog1.FileName);
      j.Free;
    end else
      Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TAudio_Info.Button5Click(Sender: TObject);
begin
idtag.SavePictureByImage(nullPicture);
Image1.Picture.Assign(NoImg);
end;

end.
