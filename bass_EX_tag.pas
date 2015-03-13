unit bass_EX_tag;

// BassSimple TAG v1.7.1
// http://jqbook.narod.ru/delphi/***
// alexpac26@yandex.ru Тольятти 2012
{

Для работы требуется
- AudioGenie3.pas
- AudioGenie3.dll

}

interface

uses SysUtils, Classes, AudioGenie3, Graphics, Dialogs, JPEG {$IFDEF UNICODE}, PngImage {$ENDIF};

type
  TBassTagStruct = record
    Album: WideString;
    Artist: WideString;
    BitRate: integer;
    ChannelMode: WideString;
    Channels: Integer;
    Comment: WideString;
    Composer: WideString;
    Encoder:WideString;
    Copyright:WideString;
    Duration: integer;
    FileSize: integer;
    Genre: WideString;
    SampleRate: integer;
    Title: WideString;
    Track: WideString;
    Year: string[4];
    Total_frames:integer;
  end;

  TBassTag = class(AudioGenie3.TAudioGenie3)
  public
      LastFile: string;
      Loaded: boolean;
      TagExists: boolean;
      FileFormat: TAudioFormatID;
      tag: TBassTagStruct;
      procedure SavePictureByImage(imgGraphic: TGraphic);
      procedure SavePictureByFile(fileImage: string; asLink: boolean = false);
      function PictureSupport:boolean;
      function AUDIOPictureExtract(var img: TMemorystream):string;
      function getPicture(bitmap: TBitMap):boolean;
      procedure LoadFile(filename:string);
      procedure SaveToFile;
      procedure RemoveTags;
      constructor Create; virtual;
  end;

function BassTagValide(tag: TBassTagStruct):boolean;
function BassPictureMimeValide(mime: string):boolean;

var
  Genres: TStringList;

const

{$IFDEF UNICODE}
BassTagOpenDialogImages='Images|*.jpeg;*.jpg;*.png';
{$ELSE}
BassTagOpenDialogImages='Images|*.jpeg;*.jpg';
{$ENDIF}

implementation

function BassPictureMimeValide(mime: string):boolean;
begin
  result:=(pos('jpeg',mime)>0) or (pos('jpg',mime)>0) {$IFDEF UNICODE} or (pos('png',mime)>0) {$ENDIF};
end;

function BassTagValide(tag: TBassTagStruct):boolean;
begin
  // измените исходный код функции для проверки тегов под ваши задачи
  result:= (trim(tag.Title)<>'') and (trim(tag.Artist)<>'');
end;

{ TBassTag }

function TBassTag.AUDIOPictureExtract(var img: TMemorystream): string;
var size: integer;
begin
  result:='none';
  if Loaded and (FileFormat in [MPEG,FLAC,WMA]) and ((ID3V2ExistsW) or (TagExists)) then begin
     img:=TMemorystream.Create;
     // mp3
     if FileFormat=MPEG then begin
        result:=lowerCase(ID3V2GetPictureMimeW(1));
        size:=ID3V2GetPictureSizeW(1);
        if (size>0) and BassPictureMimeValide(result) then begin
          img.SetSize(size);
          ID3V2GetPictureArrayW(img.Memory,size,1);
        end else begin
          img.Free;
          result:='none';
        end;
     // FLAC
     end else if FileFormat=FLAC then begin
        result:=lowerCase(FLACGetPictureMimeW(1));
        size:=FLACGetPictureSizeW(1);
        if (size>0) and BassPictureMimeValide(result) then begin
          img.SetSize(size);
          FLACGetPictureArrayW(img.Memory,size,1);
        end else begin
          img.Free;
          result:='none';
        end;
     // WMA
     end else if FileFormat=WMA then begin
        result:=lowerCase(WMAGetPictureMimeW(1));
        size:=WMAGetPictureSizeW(1);
        if (size>0) and BassPictureMimeValide(result) then begin
          img.SetSize(size);
          WMAGetPictureArrayW(img.Memory,size,1);
        end else begin
          img.Free;
          result:='none';
        end;
     end;
  end;
end;

constructor TBassTag.Create;
begin
  TAudioGenie3(self).create;
  Loaded:=false;
  TagExists:=false;
  FileFormat:=UNKNOWN;
end;

function TBassTag.getPicture(bitmap: TBitMap): boolean;
var
  m: string;
  img: TMemorystream;
  j: TJPEGImage;
  {$IFDEF UNICODE}
  p: TPngImage;
  {$ENDIF}
begin
    result:=false;
    m:=AUDIOPictureExtract(img);
    if BassPictureMimeValide(m) then begin
      if (pos('jpeg',m)>0) or (pos('jpg',m)>0) then begin
         // jpeg
        j:=TJPEGImage.Create;
        try
          j.LoadFromStream(img);
          j.DIBNeeded;
          Bitmap.Assign(j);
          result:=true;
        finally
          img.free;
          j.Free;
        end;
        exit;
      end
      {$IFDEF UNICODE}
      else if pos('png',m)>0 then begin
        // png
        p:=TPngImage.Create;
        try
          p.LoadFromStream(img);
          Bitmap.Assign(p);
          result:=true;
        finally
          img.free;
          p.Free;
        end;
        exit;
      end
      {$ENDIF}
      else img.free;
   end; // end if valide
end;

procedure TBassTag.LoadFile(filename: string);
begin
  LastFile:=filename;
  Loaded:=false;
  TagExists:=false;
  FileFormat:=self.AUDIOAnalyzeFileW(filename);
  if integer(FileFormat) <> 0 then begin
    Loaded:=true;
    // верный формат
    tag.BitRate:=self.AUDIOBitrateW;
    tag.Album:=self.AUDIOAlbumW;
    tag.Artist:=self.AUDIOArtistW;
    tag.Comment:=self.AUDIOCommentW;
    tag.Composer:=self.AUDIOComposerW;
    tag.Duration:=round(self.AUDIODurationW);
    tag.FileSize:=self.AUDIOFileSizeW;
    tag.Genre:=self.AUDIOGenreW;
    tag.SampleRate:=self.AUDIOSampleRateW;
    tag.Title:=self.AUDIOTitleW;
    tag.Track:=self.AUDIOTrackW;
    tag.Year:=self.AUDIOYearW;
    tag.Encoder:=Self.MPEGEncoderW;
    tag.Channels:=self.AUDIOChannelsW;
    tag.ChannelMode:=self.AUDIOChannelModeW;
    TagExists:=BassTagValide(Tag);
  end;
end;

function TBassTag.PictureSupport: boolean;
begin
  result:= Loaded and (FileFormat in [MPEG,FLAC,WMA]);
end;

procedure TBassTag.RemoveTags;
begin
  if Loaded then begin
    case FileFormat of
      MPEG: begin
        if ID3V2ExistsW then ID3V2RemoveTagW;
        if ID3V1ExistsW then ID3V1RemoveTagW;
      end;
      OGGVORBIS: begin
        OGGRemoveTagW;
      end;
      else if APEExistsW then APERemoveTagW else if LYRICSExistsW then LYRICSRemoveTagW;
    end;
  end;
end;

procedure TBassTag.SavePictureByFile(fileImage: string; asLink: boolean);
var t: TPictureLink;
begin
  if not PictureSupport then exit;
  if FileExists(fileImage) then begin
     if asLink then t:=AS_FILENAME else t:=AS_PICTURE;
     case FileFormat of
       MPEG: begin ID3V2AddPictureFileW(fileImage, '', OTHER,t); ID3V2SaveChangesToFileW(LastFile); end;
       FLAC: begin FLACAddPictureFileW(fileImage, '', OTHER,t); FLACSaveChangesToFileW(LastFile);  end;
       WMA: begin  WMAAddPictureFileW(fileImage, '', OTHER,1); WMASaveChangesToFileW(LastFile); end;
     end;
  end;
end;

procedure TBassTag.SavePictureByImage(imgGraphic: TGraphic);
var img: TMemoryStream;
begin
  if not PictureSupport then exit;
  img:=TMemoryStream.Create;
  imgGraphic.SaveToStream(img);
   begin
     case FileFormat of
       MPEG: begin ID3V2AddPictureArrayW(img.Memory, img.Size,'', OTHER); ID3V2SaveChangesToFileW(LastFile); end;
       FLAC: begin FLACAddPictureArrayW(img.Memory, img.Size,'', OTHER); FLACSaveChangesToFileW(LastFile);  end;
       WMA: begin  WMAAddPictureArrayW(img.Memory, img.Size,'', OTHER,1); WMASaveChangesToFileW(LastFile); end;
     end;
  end;
  img.Free;
end;

procedure TBassTag.SaveToFile;
begin
  if not Loaded then exit;
  if not FileExists(self.LastFile) then exit;
  with tag do begin
    AUDIOAlbumW := Album;
    AUDIOArtistW := Artist;
    AUDIOCommentW := Comment;
    AUDIOComposerW  := Composer;
    AUDIOGenreW := Genre;
    AUDIOTitleW := Title;
    AUDIOTrackW := Track;
    AUDIOYearW  := Year;
    AUDIOSaveChangesToFileW(LastFile);
  end;
end;

initialization
Genres := TStringList.Create;
Genres.CaseSensitive := False;

  Genres.Add('Blues');
  Genres.Add('Classic Rock');
  Genres.Add('Country');
  Genres.Add('Dance');
  Genres.Add('Disco');
  Genres.Add('Funk');
  Genres.Add('Grunge');
  Genres.Add('Hip-Hop');
  Genres.Add('Jazz');
  Genres.Add('Metal');
  Genres.Add('New Age');
  Genres.Add('Oldies');
  Genres.Add('Other');
  Genres.Add('Pop');
  Genres.Add('R&B');
  Genres.Add('Rap');
  Genres.Add('Reggae');
  Genres.Add('Rock');
  Genres.Add('Techno');
  Genres.Add('Industrial');
  Genres.Add('Alternative');
  Genres.Add('Ska');
  Genres.Add('Death Metal');
  Genres.Add('Pranks');
  Genres.Add('Soundtrack');
  Genres.Add('Euro-Techno');
  Genres.Add('Ambient');
  Genres.Add('Trip-Hop');
  Genres.Add('Vocal');
  Genres.Add('Jazz+Funk');
  Genres.Add('Fusion');
  Genres.Add('Trance');
  Genres.Add('Classical');
  Genres.Add('Instrumental');
  Genres.Add('Acid');
  Genres.Add('House');
  Genres.Add('Game');
  Genres.Add('Sound Clip');
  Genres.Add('Gospel');
  Genres.Add('Noise');
  Genres.Add('AlternRock');
  Genres.Add('Bass');
  Genres.Add('Soul');
  Genres.Add('Punk');
  Genres.Add('Space');
  Genres.Add('Meditative');
  Genres.Add('Instrumental Pop');
  Genres.Add('Instrumental Rock');
  Genres.Add('Ethnic');
  Genres.Add('Gothic');
  Genres.Add('Darkwave');
  Genres.Add('Techno-Industrial');
  Genres.Add('Electronic');
  Genres.Add('Pop-Folk');
  Genres.Add('Eurodance');
  Genres.Add('Dream');
  Genres.Add('Southern Rock');
  Genres.Add('Comedy');
  Genres.Add('Cult');
  Genres.Add('Gangsta');
  Genres.Add('Top 40');
  Genres.Add('Christian Rap');
  Genres.Add('Pop/Funk');
  Genres.Add('Jungle');
  Genres.Add('Native American');
  Genres.Add('Cabaret');
  Genres.Add('New Wave');
  Genres.Add('Psychadelic');
  Genres.Add('Rave');
  Genres.Add('Showtunes');
  Genres.Add('Trailer');
  Genres.Add('Lo-Fi');
  Genres.Add('Tribal');
  Genres.Add('Acid Punk');
  Genres.Add('Acid Jazz');
  Genres.Add('Polka');
  Genres.Add('Retro');
  Genres.Add('Musical');
  Genres.Add('Rock & Roll');
  Genres.Add('Hard Rock');

  // WinAmp-genres
  Genres.Add('Folk');
  Genres.Add('Folk-Rock');
  Genres.Add('National Folk');
  Genres.Add('Swing');
  Genres.Add('Fast Fusion');
  Genres.Add('Bebob');
  Genres.Add('Latin');
  Genres.Add('Revival');
  Genres.Add('Celtic');
  Genres.Add('Bluegrass');
  Genres.Add('Avantgarde');
  Genres.Add('Gothic Rock');
  Genres.Add('Progessive Rock');
  Genres.Add('Psychedelic Rock');
  Genres.Add('Symphonic Rock');
  Genres.Add('Slow Rock');
  Genres.Add('Big Band');
  Genres.Add('Chorus');
  Genres.Add('Easy Listening');
  Genres.Add('Acoustic');
  Genres.Add('Humour');
  Genres.Add('Speech');
  Genres.Add('Chanson');
  Genres.Add('Opera');
  Genres.Add('Chamber Music');
  Genres.Add('Sonata');
  Genres.Add('Symphony');
  Genres.Add('Booty Bass');
  Genres.Add('Primus');
  Genres.Add('Porn Groove');
  Genres.Add('Satire');
  Genres.Add('Slow Jam');
  Genres.Add('Club');
  Genres.Add('Tango');
  Genres.Add('Samba');
  Genres.Add('Folklore');
  Genres.Add('Ballad');
  Genres.Add('Power Ballad');
  Genres.Add('Rhythmic Soul');
  Genres.Add('Freestyle');
  Genres.Add('Duet');
  Genres.Add('Punk Rock');
  Genres.Add('Drum Solo');
  Genres.Add('A capella');
  Genres.Add('Euro-House');
  Genres.Add('Dance Hall');
  // some more genres, source: http://www.steffen-hanske.de/mp3_genre.htm
  Genres.Add('Goa');
  Genres.Add('Drum & Bass');
  Genres.Add('Club-House');
  Genres.Add('Hardcore');
  Genres.Add('Terror');
  Genres.Add('Indie');
  Genres.Add('BritPop');
  Genres.Add('Negerunk');
  Genres.Add('Polsk Punk');
  Genres.Add('Beat');
  Genres.Add('Christian Gangsta Rap');
  Genres.Add('Heavy Metal');
  Genres.Add('Black Metal');
  Genres.Add('Crossover');
  Genres.Add('Contemporary Christian');
  Genres.Add('Christian Rock');
  Genres.Add('Merengue');
  Genres.Add('Salsa');
  Genres.Add('Trash Metal');
  Genres.Add('Anime');
  Genres.Add('JPop');
  Genres.Add('Synthpop');

end.
