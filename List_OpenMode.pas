unit List_OpenMode;

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
  Dialogs, StdCtrls, ExtCtrls,MyUtils;

type
  TList_Open = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  List_Open: TList_Open;

implementation

{$R *.dfm}

procedure TList_Open.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TList_Open.FormShow(Sender: TObject);
begin
RadioGroup1.ItemIndex:=1;
MyUtils.SetStayTop(Handle,left, top, Width, Height,true);
end;

end.
