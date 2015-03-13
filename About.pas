unit About;

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
  Dialogs, StdCtrls,Shellapi, ExtCtrls,MyUtils;

type
  TAbout_DLG = class(TForm)
    Button1: TButton;
    Bevel1: TBevel;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label8: TLabel;
    Label18: TLabel;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label17Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About_DLG: TAbout_DLG;

implementation


{$R *.dfm}

procedure TAbout_DLG.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TAbout_DLG.Button2Click(Sender: TObject);
begin
Shellexecute(Handle,'open',pchar(MyUtils.SelfPath+'HotKeys.txt'),nil,nil,SW_SHOW);
end;

procedure TAbout_DLG.Label8Click(Sender: TObject);
begin
Shellexecute(Handle,'open',pchar((sender as TLabel).caption),nil,nil,SW_SHOW);
end;

procedure TAbout_DLG.Label17Click(Sender: TObject);
begin
Shellexecute(Handle,'open','mailto:IMTrayPlayerSP@Mail.ru',nil,nil,SW_SHOWNORMAL);
end;

end.
