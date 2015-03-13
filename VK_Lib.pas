unit VK_Lib;

//////////////////////////////////////////
//                                      //
//           ImPlayer beta              //
//      author: Lakatkin Misha          //
//      (lakatkin1993@mail.ru)          //
//                                      //
//////////////////////////////////////////

interface

uses
 Windows, Messages, SysUtils, Variants, Classes,ImgFriendsList;

Procedure VL_ReadFromFile(fl:String);
Procedure VL_Save2File(fl:String);
Procedure VL_AddItem(item:PUser);
Procedure VL_ReWriteItem(ind:integer;item:PUser);
Function VL_GetItem(itm:Integer):PUser;
Function VL_GetCount:Integer;
Procedure VL_DelItem(ind:Integer);

implementation

var
lst:TList;

Function StrToItem(S:String):PUser;
Begin
LowerCase(s);
New(Result);
With Result^ do
Begin
uid:=Copy(S,Pos('<',s)+1,Pos(';',s)-2);
Name:=Copy(S,Pos(';',s)+1,Pos('>',s)-Length(uid)-3);
Photo:='';
end;
end;

Procedure VL_AddItem(item:PUser);
Begin
Lst.Add(Item);
end;
Procedure VL_ReWriteItem(ind:integer;item:PUser);
begin
dispose(lst[ind]);
lst[ind]:=item;
end;

Function VL_GetItem(itm:Integer):PUser;
Begin
if (itm <lst.Count) then
Result:=Puser(lst[itm]);
end;

Function ItemTostr(Itm:PUser):String;
Begin
Result:='<'+itm^.uid+';'+itm^.Name+'>';
end;

Procedure VL_ReadFromFile(fl:String);
var
  s: String;
  f: TStringList;
  i:integer;
begin

  if not fileexists(fl) then
    exit;
  f:=TStringList.Create;
  f.LoadFromFile(fl);
  s := '';
  i:=0;
    while (i<=f.Count-1) do
    begin
       s:=f[i];
      VL_AddItem(StrToItem(s));
      i:=i+1;
      end;
      f.Free;

end;

Procedure VL_Save2File(fl:String);
var
f: TStringList;
i:integer;
begin
  f:=TStringList.Create;
  for I :=1 to lst.Count - 1 do
    begin
      f.Add(ItemTostr(VL_GetItem(i)))
    end;
        try
    f.SaveToFile(fl,TEncoding.Unicode);
  except

  end;
    f.Free;
end;

Procedure VL_DelItem(ind:Integer);
Begin
Dispose(VL_GetItem(ind));
lst.Delete(ind);
end;

Function VL_GetCount:Integer;
begin
Result:=lst.Count;
end;

Initialization
lst:=TList.Create;

Finalization
lst.Free;

end.
 