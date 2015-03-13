unit NetOpen;

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
  Dialogs, StdCtrls,PlayList;

type
  TNet_OpenDLG = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Net_OpenDLG: TNet_OpenDLG;

implementation

{$R *.dfm}

uses ListUpdateFRM;

procedure TNet_OpenDLG.Button1Click(Sender: TObject);
var
  i, ind: integer;
  Pl: Boolean;
begin
  if (Edit1.Text='') or (Edit1.Text='http://') then
    exit;

  ind := Play_List.Main_PlayList.Count;
  begin
    application.ProcessMessages;
    Play_List.Open_(Edit1.Text, pl);
  end;
  List_Update.Close;
  if Play_List.NewItemIndex = -1 then
    Play_List.NewItemIndex := ind;
  Play_List.Main_PlayList.ItemIndex := Play_List.NewItemIndex;
  Play_List.ImgTrackBar1.Max := Play_List.Main_PlayList.MaxScroll;
  Play_List.ImgTrackBar1.Position := Play_List.Main_PlayList.PosScroll;
  close;
end;

end.
