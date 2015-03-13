unit DL_WND;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,DL_Core;

type
  TDL_DLG = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Button2: TButton;
    Timer1: TTimer;
    Label1: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    Data:TTask;
    DlList:TList;
    CurInd:Integer;
    TotalInProc:int64;
    TimeBegin:TDateTime;
  public
    { Public declarations }
        DLEnd:boolean;
       Procedure AddToList(Url,Name:string);
       Procedure StartDL(ind:integer);
  end;

var
  DL_DLG: TDL_DLG;

implementation

{$R *.dfm}

Procedure TDL_DLG.AddToList(Url,Name:string);
var
Data:TTask;
begin
 Data:=TTask.Create;
 Data.LinkToFile:=Trim(url);
 Data.FileName:=Trim(extractFileName(Name));
 Data.Directory:=Trim(extractFilePath(Name));
 Data.Status:=tsReady;
 Data.TotalSize:=0;
 Data.LoadSize:=0;
 Data.StartPosition:=0;
 Data.EndPosition:=0;
 Data.LastModified:=0;
 Data.TimeBegin:=0;
 Data.TimeEnd:=0;
 Data.TimeTotal:=0;
 Data.ErrorText:='';
 self.DlList.Add(Data);
end;

Procedure TDL_DLG.StartDL(ind:integer);
var
 LoadOne: TLoadOne;
begin
if (ind <0) or (ind>=DlList.Count)then
exit;
if Data<>self.dllist[ind] then
TotalInProc:=TotalInProc+ProgRessBar1.Position;
Data:=self.dllist[ind];
LoadOne:=TLoadOne.Create(true,Data);
LoadOne.FreeOnTerminate:=true;
LoadOne.Resume;
Timer1.Enabled:=true;
end;

procedure TDL_DLG.Timer1Timer(Sender: TObject);
var
 TimeRemind: Integer;
 TotalPos:Integer;
begin
if Data.TimeBegin<>0 then
 Label6.Caption := FormatDateTime('hh:mm:ss',TimeBegin - Now);
 if Data.TotalSize > 0 then
  begin
   Label7.Caption := BytesToText(Data.LoadSize) + ' из ' + BytesToText(Data.TotalSize);
   ProgressBar1.Min := 0;
   ProgressBar1.Max :=100;
   ProgressBar1.Position :=    Round(((Data.LoadSize))/( Data.TotalSize/100));
   Label4.Caption:=Inttostr(ProgressBar1.Position)+'%';

   end
  else
   begin
    ProgressBar1.Min := 0;
    ProgressBar1.Max := 8;
    if ProgressBar1.Position = 8 then
    ProgressBar1.Position := 0;
    Label7.Caption := BytesToText(Data.LoadSize);
  end;
 Label11.Caption := BytesToText(Data.Speed) + '/с';
 if  ProgressBar1.Position>0 then
  ProgressBar2.Position:=TotalInProc+ProgressBar1.Position;
  TotalPos:=Round((ProgressBar2.Position*100)/ProgressBar2.Max);
   Label5.Caption:=Inttostr(TotalPos)+'%';
  self.Caption:= 'Загрузка: '+ Inttostr(TotalPos)+'% ['+data.FileName+']';
 Label11.Caption := BytesToText(Data.Speed) + '/с';
  if (Data.Status = tsLoad) or (Data.Status = tsError) then
  Begin
  Timer1.Enabled := False;
  ProgressBar1.Position := ProgressBar1.Max;
  ProgressBar2.Position:=TotalInProc+ProgressBar1.Max;
  CurInd:=CurInd+1;
if (CurInd <0) or (CurInd>=DlList.Count)then
begin
ProgressBar2.Position:=ProgressBar2.Max;
TotalPos:=Round((ProgressBar2.Position*100)/ProgressBar2.Max);
   Label5.Caption:=Inttostr(TotalPos)+'%';
  self.Caption:= 'Загрузка: '+ Inttostr(TotalPos)+'% ('+data.FileName+')';
 Label11.Caption := BytesToText(Data.Speed) + '/с';
close;
DLEnd:=true;
end
else
begin

self.StartDL(CurInd);

end;
  end;
end;

procedure TDL_DLG.FormCreate(Sender: TObject);
begin
DlList:=TList.Create;
DLEnd:=false;
end;

procedure TDL_DLG.FormDestroy(Sender: TObject);
begin
DlList.Free;
end;

procedure TDL_DLG.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
 DLEnd:=true;
end;

procedure TDL_DLG.FormShow(Sender: TObject);
begin
ProgressBar2.Max:=100*DlList.Count;
TimeBegin:=now();
self.StartDL(0);
end;

procedure TDL_DLG.Button2Click(Sender: TObject);
begin
if button2.Tag=0 then
begin
if TTask(DlList[CurInd]).Status=tsLoading then
TTask(DlList[CurInd]).Status:=tsStoped;
timer1.Enabled:=false;
button2.Caption:='Возобновить';
button2.Tag:=1;
end
else
if button2.Tag=1 then
begin
if TTask(DlList[CurInd]).Status=tsStoped then
StartDL(CurInd);
timer1.Enabled:=true;
button2.Caption:='Приостановить';
button2.Tag:=0;
end;
end;

procedure TDL_DLG.Button1Click(Sender: TObject);
begin
if MessageBox(Handle, 'Идет загрузка.' + #13 + 'Вы действильно хотите завершить ее ?', 'WARNING',MB_ICONQUESTION	or MB_YESNO )=IDNO then
exit;
 if TTask(DlList[CurInd]).Status=tsLoading then
begin
Button2Click(nil);
deleteFile(TTask(DlList[CurInd]).Directory+'\'+TTask(DlList[CurInd]).FileName);
end;
close;
end;

end.
