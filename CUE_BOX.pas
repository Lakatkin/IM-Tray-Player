unit CUE_BOX;

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
  Dialogs, StdCtrls, ComCtrls,ImgPlayList,TagReader;

type
  TCUE_Info = class(TForm)
    Label10: TLabel;
    Edit6: TEdit;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent;data:pTrackData);
    { Public declarations }
  end;

var
  CUE_Info: TCUE_Info;

implementation

{$R *.dfm}

constructor TCUE_Info.Create(AOwner: TComponent;data:pTrackData);
Begin
inherited Create(AOwner);
Edit6.Text:=data^.OrigName;
Edit2.Text:=data^.filename;
Edit1.Text:=Copy(data^.OrigName,0,Pos('-',data^.OrigName)-1);
Edit3.Text:=Copy(data^.OrigName,Pos('-',data^.OrigName)+1,Length(data^.OrigName));
end;

procedure TCUE_Info.Button3Click(Sender: TObject);
begin
Close;
end;

procedure TCUE_Info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

procedure TCUE_Info.Button1Click(Sender: TObject);
begin
ShowTagDLGFromFile(Edit2.Text);
end;

end.
