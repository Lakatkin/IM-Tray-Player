unit SkinList;

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
  Dialogs,skinEngine, StdCtrls,MyUtils,OptionsBox;

type
  TSkin_List = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
  Procedure UpdataSkinList;
    { Public declarations }
  end;

var
  Skin_List: TSkin_List;

implementation

{$R *.dfm}

  Procedure TSkin_List.UpdataSkinList;
  var
  i:integer;
  begin
  skinEngine.SkinList.Clear;
  self.ListBox1.Clear;
  ReadFolder(MyUtils.SkinPath,'*.imsk;',skinEngine.SkinList);
 for i:=0 to   skinEngine.SkinList.Count-1 do
 self.ListBox1.Items.Add(MyUtils.GetFileName(skinEngine.SkinList[i]));
  end;



procedure TSkin_List.FormShow(Sender: TObject);
begin
UpdataSkinList;
end;

procedure TSkin_List.Button1Click(Sender: TObject);
begin
If (ListBox1.ItemIndex<0) or (ListBox1.ItemIndex>ListBox1.Count-1) then
exit;
Options_Box.LoadSkinByNum(ListBox1.ItemIndex);
end;

procedure TSkin_List.Button2Click(Sender: TObject);
begin
Button1Click(sender);
Close;
end;

end.
