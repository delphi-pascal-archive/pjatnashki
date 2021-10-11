unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus,ShellApi, StdCtrls, ExtCtrls, XPMan;

type
  TForm1 = class(TForm)
    MyForm: TImage;
    Pole: TImage;
    Close1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N7: TMenuItem;
    XPManifest1: TXPManifest;
    N8: TMenuItem;
    N9: TMenuItem;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure MyFormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Close1Click(Sender: TObject);
    procedure RandomPos;
    procedure FindEmptyPos;
    procedure Win;
    procedure MyClick(Sender: TObject);
    procedure Close1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Close1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    function YourResult(YR:integer):string;
    function GetRecord(FileName:string):string;
    procedure N4Click(Sender: TObject);
    procedure FindDirectory;
    procedure StyleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
Form1: TForm1;
MX: integer;
MY: integer;
ListPos:TstringList;
ListResult:TStringList;
XEmpty,YEmpty:integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
k:integer;
begin
ListPos:=TstringList.Create;
MyForm.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\Default\Form.bmp');
Pole.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\Default\Pole.bmp');
Close1.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\Default\Close.bmp');
image2.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\Default\Close2.bmp');
Image3.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\Default\Sphere.bmp');
//Создание Imag'ов--------------------
for k:=1 to 15 do begin
with TImage.Create(self) do begin
name:='Shape'+inttostr(k);
Left := k*40+165;
Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\Default\'+inttostr(k)+'.bmp');
autosize:=true;
OnClick:=MyClick;
Parent := Form1;
application.ProcessMessages;
end;
end;
//--------------------------------------
RandomPos;
end;

procedure TForm1.MyFormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if Shift<>[ssLeft] then
begin
MX:=X;
MY:=Y;
end else
begin
Left:=Left+X-MX;
Top:=Top+Y-MY;
end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.RandomPos;
var
i,k:integer;
f,count:integer;
x,y:integer;
Label Return;
begin
randomize;
listPos.Add('-1');
listPos.Add('-1');
count:=0;
//---------Ищем Imag'ы------------------------------
for i:=0 to componentcount-1 do begin
if (Components[i] is TImage) and (TImage(Components[i]).Width=40) and (TImage(Components[i]).Height=40) then begin
Return:
x:=(random(4))*40+5;
y:=(random(4))*40+26;
f:=0;
//----------Сравниваем позиции-----------------------
for k:=0 to listPos.Count-1 do begin
application.ProcessMessages;
if (k mod 2=0) and (x=strtoint(listpos.Strings[k])) and (y=strtoint(listPos.Strings[k+1]))  then begin
f:=1;
end;
end;
//--------------------------------------------------
if f=0 then begin
count:=count+1;
ListPos.Add(inttostr(x));
ListPos.Add(inttostr(y));
TImage(Components[i]).Left:=x;
TImage(Components[i]).Top:=y;
application.ProcessMessages;
end else goto return;
//--------------------------------------------------
if count=15 then begin
ListPos.Delete(0);
ListPos.Delete(0);
findEmptyPos;
exit;
end;
//--------------------------------------------------
end;
end;
end;

procedure TForm1.MyClick(Sender: TObject);
var
i:integer;
d:integer;
begin
if ((Sender as TImage).Left-40=XEmpty) and ((Sender as TImage).Top=YEmpty) then begin
d:=(Sender as TImage).Left;
XEmpty:=(Sender as TImage).Left;
for i:=1 to 10 do begin
application.ProcessMessages;
sleep(10);
d:=d-4;
(Sender as TImage).Left:=d;
application.ProcessMessages;
end;
label2.Caption:=inttostr(strtoint(label2.Caption)+1);
Win;
exit;
end;
if ((Sender as TImage).Left=XEmpty) and ((Sender as TImage).Top-40=YEmpty) then begin
d:=(Sender as TImage).top;
YEmpty:=(Sender as TImage).top;
for i:=1 to 10 do begin
application.ProcessMessages;
sleep(10);
d:=d-4;
(Sender as TImage).top:=d;
application.ProcessMessages;
end;
label2.Caption:=inttostr(strtoint(label2.Caption)+1);
Win;
exit;
end;
if ((Sender as TImage).Left+40=XEmpty) and ((Sender as TImage).Top=YEmpty) then begin
d:=(Sender as TImage).Left;
XEmpty:=(Sender as TImage).Left;
for i:=1 to 10 do begin
application.ProcessMessages;
sleep(10);
d:=d+4;
(Sender as TImage).Left:=d;
application.ProcessMessages;
end;
label2.Caption:=inttostr(strtoint(label2.Caption)+1);
Win;
exit;
end;
if ((Sender as TImage).Left=XEmpty) and ((Sender as TImage).Top+40=YEmpty) then begin
d:=(Sender as TImage).top;
YEmpty:=(Sender as TImage).top;
for i:=1 to 10 do begin
application.ProcessMessages;
sleep(10);
d:=d+4;
(Sender as TImage).top:=d;
application.ProcessMessages;
end;
label2.Caption:=inttostr(strtoint(label2.Caption)+1);
Win;
exit;
end;
end;

procedure TForm1.FindEmptyPos;
var
x,y,i:integer;
dx,dy:integer;
f:integer;
begin
for y:=0 to 3 do begin
for x:=0 to 3 do begin
dx:=x*40+5;
dy:=y*40+26;
f:=0;
application.ProcessMessages;
for i:=0 to ListPos.Count-1 do begin
if i mod 2=0 then begin
if (strtoint(ListPos.Strings[i])=dx) and (strtoint(ListPos.Strings[i+1])=dy) then begin
f:=1
end;
end;
end;
if f=0 then begin
XEmpty:=dx;
YEmpty:=dy;
end;
end;
end;
end;

procedure TForm1.Close1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Close1.Picture:=Image2.Picture;
end;

procedure TForm1.Close1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Close1.Picture:=Image1.Picture;
end;

procedure TForm1.Image3Click(Sender: TObject);
var
pos:TPoint;
begin
GetCursorPos(Pos);
listbox1.Clear;
popupmenu1.Items.Items[3].Clear;
FindDirectory;
popupmenu1.Popup(pos.x,pos.y);
end;

procedure TForm1.N5Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
listpos.Free;
ListPos:=TstringList.Create;
listResult.Free;
ListResult:=TstringList.Create;
label2.Caption:='0';
randomPos;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
showmessage('Автор программы Бышин Артем'+#13#10+
            '       Версия программы 1.0');
end;

procedure TForm1.Win;
var
i:integer;
s:integer;

begin
s:=0;
for i:=0 to componentcount-1 do begin
if (Components[i] is TImage) and (TImage(Components[i]).Width=40) and (TImage(Components[i]).Height=40) then begin

if (TImage(Components[i]).Name='Shape1') and (TImage(Components[i]).Left=5) and (TImage(Components[i]).Top=26) then s:=s+1;
if (TImage(Components[i]).Name='Shape2') and (TImage(Components[i]).Left=45) and (TImage(Components[i]).Top=26) then s:=s+1;
if (TImage(Components[i]).Name='Shape3') and (TImage(Components[i]).Left=85) and (TImage(Components[i]).Top=26) then s:=s+1;
if (TImage(Components[i]).Name='Shape4') and (TImage(Components[i]).Left=125) and (TImage(Components[i]).Top=26) then s:=s+1;

if (TImage(Components[i]).Name='Shape5') and (TImage(Components[i]).Left=5) and (TImage(Components[i]).Top=66) then s:=s+1;
if (TImage(Components[i]).Name='Shape6') and (TImage(Components[i]).Left=45) and (TImage(Components[i]).Top=66) then s:=s+1;
if (TImage(Components[i]).Name='Shape7') and (TImage(Components[i]).Left=85) and (TImage(Components[i]).Top=66) then s:=s+1;
if (TImage(Components[i]).Name='Shape8') and (TImage(Components[i]).Left=125) and (TImage(Components[i]).Top=66) then s:=s+1;

if (TImage(Components[i]).Name='Shape9') and (TImage(Components[i]).Left=5) and (TImage(Components[i]).Top=106) then s:=s+1;
if (TImage(Components[i]).Name='Shape10') and (TImage(Components[i]).Left=45) and (TImage(Components[i]).Top=106) then s:=s+1;
if (TImage(Components[i]).Name='Shape11') and (TImage(Components[i]).Left=85) and (TImage(Components[i]).Top=106) then s:=s+1;
if (TImage(Components[i]).Name='Shape12') and (TImage(Components[i]).Left=125) and (TImage(Components[i]).Top=106) then s:=s+1;

if (TImage(Components[i]).Name='Shape13') and (TImage(Components[i]).Left=5) and (TImage(Components[i]).Top=146) then s:=s+1;
if (TImage(Components[i]).Name='Shape14') and (TImage(Components[i]).Left=45) and (TImage(Components[i]).Top=146) then s:=s+1;
if (TImage(Components[i]).Name='Shape15') and (TImage(Components[i]).Left=85) and (TImage(Components[i]).Top=146) then s:=s+1;
end;
end;
if s=15 then begin
messagebox(form1.Handle,'Поздравляю! Вы выиграли!','Пятнашки',0);
messagebox(form1.Handle,PansiChar('Вы сделали ходов: '+label2.Caption+#13#10+'Ваш результат: '+YourResult(strtoint(label2.Caption))),'Пятнашки',0);
//------------------------------
ListResult:=TStringList.Create;
ListResult.LoadFromFile(ExtractFilePath(ParamStr(0))+'Records.txt');
ListResult.Add(label2.Caption);
ListResult.SaveToFile(ExtractFilePath(ParamStr(0))+'Records.txt');
ListResult.free;
//------------------------------
ListPos.Free;
ListPos:=TstringList.Create;
label2.Caption:='0';
randomPos;
//------------------------------
end;
end;

function TForm1.YourResult(YR:integer):string;
begin
if YR>=600                then Result:='Полная жопа';
if (YR>=450) and (YR<=599)then Result:='Дерьмо';
if (YR>=400) and (YR<=449)then Result:='Отстой';
if (YR>=350) and (YR<=399)then Result:='Очень плохо';
if (YR>=300) and (YR<=349)then Result:='Плохо';
if (YR>=250) and (YR<=299)then Result:='Удовлетворительно';
if (YR>=200) and (YR<=249)then Result:='Нормально';
if (YR>=150) and (YR<=199)then Result:='Хорошо';
if (YR>=100) and (YR<=149)then Result:='Очень хорошо';
if YR<=99                 then Result:='Круто';
end;

function TForm1.GetRecord(FileName:string):string;
var
ListRecord:TStringList;
i:integer;
Max:integer;
begin
Max:=99999;
ListRecord:=TStringList.Create;
ListRecord.LoadFromFile(FileName);
for i:=0 to ListRecord.Count-1 do begin
if length(ListRecord.Strings[i])<>0 then begin
if Max>strtoint(ListRecord.Strings[i]) then begin
Max:=strtoint(ListRecord.Strings[i]);
end;
end;
end;
result:=inttostr(Max);
ListRecord.Free;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
MessageBox(form1.Handle,PansiChar('Результат рекорда: '+GetRecord(ExtractFilePath(ParamStr(0))+'Records.txt')),'Record',0);
end;

procedure TForm1.FindDirectory;
var
DirInfo: TSearchRec;
r : Integer;
items:TMenuItem;
begin
r := FindFirst(ExtractFilePath(ParamStr(0))+'Themes\*.*', FaAnyFile, DirInfo);
while r = 0 do begin
if ((dirinfo.Attr and faDirectory)=faDirectory) and
   (dirinfo.Name<>'.') and (dirinfo.Name<>'..') then begin
items:=TMenuItem.Create(PopupMenu1);
items.Caption:=dirinfo.Name;
popupmenu1.Items.Items[3].Add(items);
listbox1.Items.Add(dirinfo.Name);
items.OnClick:=StyleClick;
end;
r := FindNext(DirInfo);
application.ProcessMessages;
end;
SysUtils.FindClose(DirInfo);
end;

procedure TForm1.StyleClick(Sender: TObject);
var
i:integer;
begin
MyForm.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\'+Listbox1.Items.Strings[(Sender as TMenuItem).menuIndex]+'\Form.bmp');
Pole.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\'+Listbox1.Items.Strings[(Sender as TMenuItem).menuIndex]+'\Pole.bmp');
Close1.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\'+Listbox1.Items.Strings[(Sender as TMenuItem).menuIndex]+'\Close.bmp');
image2.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\'+Listbox1.Items.Strings[(Sender as TMenuItem).menuIndex]+'\Close2.bmp');
Image3.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\'+Listbox1.Items.Strings[(Sender as TMenuItem).menuIndex]+'\Sphere.bmp');
for i:=0 to ComponentCount-1 do begin
if (Components[i] is Timage) and (Timage(Components[i]).Height=40) and (Timage(Components[i]).Width=40) then begin
Timage(Components[i]).Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Themes\'+Listbox1.Items.Strings[(Sender as TMenuItem).menuIndex]+'\'+copy(Timage(Components[i]).Name,6,2)+'.bmp');
end;
end;
application.ProcessMessages;
end;
end.
