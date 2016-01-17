unit UClient;
//SetWindowRgn(handle,CreateRectRgn(0,0,Width,Height),true);
//SetWindowRgn(handle,CreateRoundRectRgn(0,0,Width,Height,40,40),true);

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ShlObj,
     Dialogs, ScktComp, StdCtrls, Buttons, FileCtrl, shellapi, ExtCtrls, inifiles;

type
  TFrmClient = class(TForm)
    Client1: TClientSocket;
    Client2: TClientSocket;
    CB: TCheckBox;
    ListFiles: TFileListBox;
    Lab_DateTime: TLabel;
    Lab_Count: TLabel;
    Timer: TTimer;
    TimerApp: TTimer;
    BtnOpt: TSpeedButton;
    BtnSendText: TSpeedButton;
    BtnClose: TSpeedButton;
    procedure CBClick(Sender: TObject);
    procedure Client1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOptClick(Sender: TObject);
    procedure Client1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Client1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Client1Disconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure BtnSendTextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TimerAppTimer(Sender: TObject);
Public
    Function GetFromIni:boolean;
    procedure UpDateList(StrFile:String);
    procedure ShowOpt;
    procedure Capture;
    procedure SendS(Str:TStream);
    procedure SendT(Str:string);
    procedure Ordre(C:byte);
    Procedure Detect(var InFile:string);
    Procedure WMHotkey(Var msg:TWMHotkey);message WM_HOTKEY;
    function Connect:boolean;
  end;

var FrmClient: TFrmClient;
    path,IP:string;
    FP,SP:integer;
    AppAcceptList:TStringList;

implementation

uses BenMagic ,UOptCli;

{$R *.dfm}

function TFrmClient.Connect:boolean;
begin
 result:=Client1.Active;
 if result=false then
  ShowMessage('You are not connected !!');
end;

procedure TFrmClient.SendT(Str:string);
begin
 if Connect then
  Client1.Socket.SendText(Str)
end;

procedure TFrmClient.SendS(Str:TStream);
begin
 if Connect then
  Client2.Socket.SendStream(Str)
end;

procedure TFrmClient.WMHotkey(Var msg:TWMHotkey);
Begin
 if msg.HotKey=1 then
  if visible then
   visible:=false
    else visible:=true
end;

procedure TFrmClient.ShowOpt;
begin
 options:=TOptions.Create(application);
 try
  options.Showmodal
 finally
  options.Free
 end
end;

function TFrmClient.GetFromIni:boolean;
 var ini:tinifile;
     i:integer;
begin
 path:=DetSlash(Extractfilepath(application.exename))+'options.ini';
 AppAcceptList:=TStringList.Create;
 ini:=tinifile.Create(path);
 FP:=2222;
 SP:=4444;
 IP:=GetLocalIp;
 with ini do
  begin
   ReadSection('NotAllowProg',AppAcceptList);
   Fp:=ReadInteger('Client','FP',FP);
   Sp:=ReadInteger('Client','SP',SP);
   Ip:=ReadString('Client','IP',IP);
   result:=fileexists(path)and SectionExists('Client')and not(Fp=SP)and IsValidIp(Ip);free
  end;
 with AppAcceptList do
  if count>0 then
   begin
    for i:=0 to count-1 do
     Strings[i]:=Uppercase(extractfilename(Strings[i]));
    for i:=0 to count-1 do
     if Strings[i]='EXPLORER.EXE'then
      delete(i);
    TimerApp.Enabled := true;
   end;
end;

procedure TFrmClient.capture;
 var image:tbitmap;
     FileBmp,FileJpg:string;
begin
 fileBmp:=GetTemDir+'~Tmp.bmp';
 fileJpg:=GetTemDir+'~Tmp.jpg';
 image:=tbitmap.Create;
 try
  CaptureScreen(image);
  image.SaveToFile(FileBmp);
  benmagic.BmpToJpg(FileBmp,FileJpg,100);
 finally
  image.Free
 end;
 if Connect then
  SendT('PICT!'+inttostr(getfilesize(FileJpg)));
 if Connect then
  SendS(TFileStream.Create(FileJpg,fmopenRead));
 deletefile(FileBmp);deletefile(FileJpg);
end;

procedure TFrmClient.Ordre(C:byte);
begin
 case C of
 1:Restart;
 2:ShutDown;
 3:RunScreenSaver;
 4:Standby;
 5:capture;
 6:EmbtyRecycleBin;
 7:DeleteFolder(GetTemDir);
 8:if Connect then
    SendT('GENE!'+GetAppRun.Text);
 9:LogOff;
 end
end;

Procedure TFrmClient.detect(var InFile:string);
begin
 if(InFile[1]='[')and(InFile[length(InFile)]=']')then
  InFile:=copy(InFile,2,length(InFile)-2);
end;

procedure TFrmClient.CBClick(Sender: TObject);
begin
 client1.Active:=cb.Checked;
 Client2.Active:=cb.Checked;
end;

procedure TFrmClient.UpDateList(StrFile:String);
 var Str:TStringList;
     i:byte;
     ini:TIniFile;
     path:string;
begin
 TimerApp.Enabled := False;
 path:=DetSlash(Extractfilepath(application.exename))+'options.ini';
 ini:=tinifile.Create(path);
 Str:=TStringList.create;
 try
  Str.Text:=StrFile;
  AppAcceptList.Clear;
  AppAcceptList.AddStrings(Str)
 finally
  Str.Free;
 end;
 ini.EraseSection('NotAllowProg');
 if AppAcceptList.Count>0 then
  for i:=0 to AppAcceptList.count-1 do
   Ini.WriteString('NotAllowProg',AppAcceptList[i],inttostr(i));
 ini.Free;
 TimerApp.Enabled := AppAcceptList.Count>0
end;

procedure TFrmClient.Client1Read(Sender: TObject;Socket: TCustomWinSocket);
 var Command,InFile,strFile:string;
     Strings:TStringList;
     k:integer;
 label str;
begin   
 Command:=Socket.ReceiveText; 
 str:strFile:=Copy(Command,6,Length(Command)-5);
 if pos('ORDR!',Command)=1 then
  ordre(strtoint(strfile))
  else if pos('TEXT!',Command)=1 then
   Showmessage('Server :'+StrFile)
  else if pos('EXEC!',Command)=1 then
   shellexecute(handle,'open',pchar(ListFiles.Items[strtoint(StrFile)]),nil,nil,sw_show)
  else if pos('DELE!',Command)=1 then
   begin
    StrFile:=copy(Command,pos('ô',Command)+1,length(Command));
    Command:='LIST!'+copy(Command,6,Pos('ô',Command)-6);
    InFile:=ListFiles.Items[strtoint(StrFile)];
    detect(InFile);
    SndFileToRecycleBin(InFile);
    ListFiles.Update;
    goto str
   end
  else if pos('CLOS!',Command)=1 then
   begin
    Getprocesslist;
    KillApp(StrFile);
    Command:='ORDR!8';
    goto str
   end
  else if pos('COPY!',Command)=1 then
   begin
    if Connect then
     begin 
      SendT('FILE!'+inttostr(getfilesize(StrFile)));
      SendS(TFileStream.Create(StrFile,fmopenRead))
     end;
   end
  else if pos('RUNE!',Command)=1 then
   ShellExecute(0,'open',pchar(StrFile),nil,nil,sw_show)
  else if pos('APLI!',Command)=1 then
   begin
    if Connect then
     SendT('APLI!'+AppAcceptList.Text)
   end
  else if pos('ENAB!',Command)=1 then
   EnabledInput(true)
  else if pos('DISA!',Command)=1 then
   EnabledInput(false)
  else if pos('UPLI!',Command)=1 then
   UpDateList(StrFile)
  else if pos('ADLI!',Command)=1 then
   begin
    TimerApp.Enabled := false;
    AppAcceptList.Add(StrFile);
    TimerApp.Enabled := true;
   end
  else if Pos('DRVE!',Command)=1 then
   begin
    Strings:=TStringList.Create;
    for k:=0 to 25 do
     begin
      InFile:=(Char(k+ord('A'))+':\');
      if GetDriveType(pChar(InFile))<>1 then
       Strings.Add(InFile)
     end;
    ListFiles.Directory := 'c:\';
    if Connect then
     SendT('DRVE!'+Strings.Text+'ô'+inttostr(ListFiles.Items.Count));
     SendS(TStringstream.Create(ListFiles.Items.Text));
    Strings.Free;
   end
  else if Pos('LIST!',Command)=1 then
   begin
    ListFiles.Directory:=strFile;
    if Connect then
     begin
      SendT('LIST!'+inttostr(ListFiles.Items.Count));
      SendS(TStringstream.Create(ListFiles.Items.Text))
     end;
   end
end;

procedure TFrmClient.TimerTimer(Sender: TObject);
begin
 lab_DateTime.Caption:=FormatDateTime('dddd, mmmm d, yyyy  hh:mm:ss ',Now);
 lab_Count.Caption:=GetTime;
 if(cb.Checked)and not(client1.Active)then
  begin
   client1.Open;
   client2.Open
  end;
end;

procedure TFrmClient.FormCreate(Sender: TObject);
begin
 RegisterHotkey(Handle,1,Mod_Control+Mod_Alt+Mod_Shift,ord('C'));
 if not GetFromIni then
  ShowOpt;
 Client1.port:=Fp;
 Client2.port:=Sp;
 Client1.Address:=Ip;
 Client2.address:=Ip;
end;

procedure TFrmClient.BtnOptClick(Sender: TObject);
begin
 showOpt
end;

procedure TFrmClient.Client1Error(Sender: TObject;Socket: TCustomWinSocket;
          ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 ErrorCode:=0
end;

procedure TFrmClient.Client1Connect(Sender: TObject; Socket: TCustomWinSocket);
begin
 caption:='CyberEx Client Connected !!'
end;

procedure TFrmClient.Client1Disconnect(Sender: TObject;Socket: TCustomWinSocket);
begin
 caption:='CyberEx Client Disconnected !!'
end;

procedure TFrmClient.BtnSendTextClick(Sender: TObject);
 var Msg:string;
begin
 if Connect then
  if Inputquery('Send a message','Your message ',Msg)then
   SendT('TEXT!'+Client1.Socket.LocalHost+':'+Msg);
end;

procedure TFrmClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 UnRegisterHotkey(Handle,1);
 AppAcceptList.Free;
 Client1.Close;
 client2.Close
end;

procedure TFrmClient.BtnCloseClick(Sender: TObject);
begin
close
end;

procedure TFrmClient.FormMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
ReleaseCapture;Perform(WM_SYSCOMMAND,$F012,0)
end;

procedure TFrmClient.TimerAppTimer(Sender: TObject);
 var i:byte;
begin
 If AppAcceptList.Count>0 then exit;
 TimerApp.Enabled:=false;
 getprocesslist;
  for i:=0 to AppAcceptList.count-1 do
   if AppList.IndexOf(AppAcceptList.Strings[i])<>-1 then
    killApp(AppAcceptList.Strings[i]);
  TimerApp.Enabled:=true;
end;

end.



