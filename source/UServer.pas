unit UServer;


interface                                         

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
     ScktComp, ExtCtrls, ShellAPI, JPEG, FileCtrl, inifiles, ActnList, ComCtrls, CheckLst,
     Menus, BenMagic, Buttons;

Const MaxComp=15;

type  TCase=(CaFile,CaPict,CaText,CaNone);
  TFrmServer = class(TForm)
    Server1: TServerSocket;
    Server2: TServerSocket;
    Timer: TTimer;
    ActionList: TActionList;
    CmdLogOff: TAction;
    CmdRes: TAction;
    CmdSht: TAction;
    CmdScrSav: TAction;
    CmdStadBy: TAction;
    CmdCap: TAction;
    CmdRecBin: TAction;
    CmdClrTmp: TAction;
    CmdSndMsg: TAction;
    CmdGen: TAction;
    CmdRun: TAction;
    CmdBws: TAction;
    CmdOpt: TAction;
    PnlStatus: TPanel;
    Bar: TProgressBar;
    ListIps: TCheckListBox;
    CmdAppList: TAction;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    MFile: TMenuItem;
    MEdit: TMenuItem;
    MHelp: TMenuItem;
    MAbout: TMenuItem;
    MClose: TMenuItem;
    procedure Server1ClientRead(Sender: TObject;Socket: TCustomWinSocket);
    procedure Server2ClientRead(Sender: TObject;Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CmdLogOffExecute(Sender: TObject);
    procedure CmdResExecute(Sender: TObject);
    procedure CmdShtExecute(Sender: TObject);
    procedure CmdScrSavExecute(Sender: TObject);
    procedure CmdStadByExecute(Sender: TObject);
    procedure CmdCapExecute(Sender: TObject);
    procedure CmdRecBinExecute(Sender: TObject);
    procedure CmdClrTmpExecute(Sender: TObject);
    procedure CmdSndMsgExecute(Sender: TObject);
    procedure CmdGenExecute(Sender: TObject);
    procedure CmdRunExecute(Sender: TObject);
    procedure CmdBwsExecute(Sender: TObject);
    procedure CmdOptExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListIpsClick(Sender: TObject);
    procedure ListIpsClickCheck(Sender: TObject);
    procedure CmdAppListExecute(Sender: TObject);
    procedure ListIpsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Server1ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MCloseClick(Sender: TObject);
    procedure MAboutClick(Sender: TObject);
Public
    PMenu:TPopupMenu;
    cas:TCase;
    path,FName:string;
    FP,SP,FSize:integer;
    FStream:TFileStream;
    SStream:TStringStream;
    MStream:TMemoryStream;
    ListConnect:TStrings;
    ClientStatus:array[0..MaxComp-1] of TShape;
    Function GetFromIni:boolean;
    function IsCompCon:boolean;
    function IsCompCount:boolean;
    function IsCompWork(i:word):boolean;
    function IsCompExt(i:word):boolean;
    procedure Send(Str:String);
    procedure UpDateList;
    procedure UpDateSatus;
    procedure DisplayHint(Sender: TObject);
    Procedure WMHotkey(Var msg:TWMHotkey);message WM_HOTKEY;
  end;

var FrmServer:TFrmServer;


implementation

uses UShowPic, UApp, UBrws, UOptSer, UNotAllow;

{$R *.dfm}

procedure TFrmServer.DisplayHint(Sender: TObject);
begin
 StatusBar.SimpleText:=getLongHint(Application.Hint)
end;

procedure TFrmServer.UpDateList;
 var i:byte;
begin
 ListConnect.Clear;
 if server1.Active then
  with server1.Socket do
   if ActiveConnections<=0 then
    listConnect.Clear
     else
      for i:=0 to ActiveConnections-1 do
       listConnect.add(Connections[i].RemoteAddress);
 if ListConnect.Text<>ListIps.Items.Text then
  ListIps.Items:=ListConnect;
end;

procedure TfrmServer.UpDateSatus;
 var i:byte;
begin
 for i:=0 to MaxComp-1 do
  If IsCompExt(i) then
   begin
    if IsCompWork(i)then
     begin
      ClientStatus[i].Brush.Color:=cllime;
      if ClientStatus[i].Visible then
       ClientStatus[i].Visible:=false
      else
       ClientStatus[i].Visible:=true;
     end
    else
     begin
      ClientStatus[i].Brush.Color:=clRed;
      ClientStatus[i].Visible:=true
      end;
   end
    else
     ClientStatus[i].Visible:=false;
end;

procedure TFrmServer.WMHotkey(Var msg:TWMHotkey);
Begin
 if msg.HotKey=1 then
  if visible then
   visible:=false
    else visible:=true
end;

Function TFrmServer.GetFromIni:boolean;
 var ini:tinifile;
begin
 path:=DetSlash(Extractfilepath(application.exename))+'options.ini';
 ini:=tinifile.Create(path);
 FP:=2222;
 SP:=4444;
 with ini do
  begin
   Fp:=ReadInteger('Server','FP',FP);
   ReadInteger('Server','SP',SP);
   result:=fileexists(path)and SectionExists('Server')and not(Fp=Sp);free
 end
end;

function TFrmServer.IsCompCon:boolean;
begin
 result:=ListConnect.IndexOf(PnlStatus.caption)<>-1;
 if result=false then
  if IsCompCount then
   ShowMessage('The selected client is not connected !!')
    else ShowMessage('Clients are not connected !!')
end;

function TFrmServer.IsCompWork(i:word):boolean;
begin
 result := ListIps.Checked[i]
end;

function TFrmServer.IsCompCount:boolean;
begin
 result:= ListIps.Items.Count>0;
end;

function TFrmServer.IsCompExt(i:word):boolean;
begin
 result:= ListIps.Items.count-1>=i
end;

procedure TFrmServer.Send(Str:String);
begin
 Server1.Socket.Connections[ListConnect.IndexOf(PnlStatus.Caption)].SendText(Str)
end;

procedure TFrmServer.Server1ClientRead(Sender: TObject;Socket: TCustomWinSocket);
 var SndText,Command:string;
     Str:TStringList;
begin
 SndText:=socket.ReceiveText;
 Command:=copy(Sndtext,1,5);
 Delete(SndText,1,5);
 if Command='DRVE!'then
  with FrmBrw do
   begin
    Cas := CaText;
    FSize := strtoint(copy(Sndtext,pos('ô',Sndtext)+1,length(Sndtext)));
    FrmBrw := TFrmBrw.Create(Application);
    try
      EditDir.Items.Text:=copy(Sndtext,0,pos('ô',Sndtext)-1);
      EditDir.ItemIndex := EditDir.Items.IndexOf('C:\');
      SStream:=tstringstream.Create(ListFiles.Items.Text);
      ShowModal;
    finally
      free;
    end;
   end
 else if(Command='APLI!')then
  with FrmNon do
   begin
    FrmNon:=TFrmNon.Create(Application);
    try
     Str:=TstringList.Create;
     try
      Str.Text:=SndText;
      NotAllowList.Items.AddStrings(Str);
     finally
      Str.Free
     end;
     ShowModal;
    finally
     Free
    end;
   end
  else if(Command='TEXT!')then
   Showmessage(SndText)
  else if(Command='GENE!')then
   with FrmGen do
    begin
     Str:=TstringList.Create;
     try
      Str.Text:=SndText;
      ListV.Clear;
      ListV.Items.AddStrings(Str)
     finally
      Str.Free
     end;
    end
 else FSize:=strtoint(SndText);
 if(Command='LIST!')then
  begin
   Cas:=CaText;
   SStream:=tstringstream.Create(FrmBrw.ListFiles.Items.Text)
  end
 else if(Command='PICT!')then
  begin
   Cas:=CaPict;
   Mstream:=TMemoryStream.Create
  end
 else if(Command='FILE!')then
  begin
   Cas:=CaFile;
   FStream:=TFileStream.Create(FName,fmCREATE or fmOPENWRITE and fmsharedenywrite)
  end;
 Bar.Max:=FSize;
 Bar.Min:=0
end;

procedure TFrmServer.Server2ClientRead(Sender: TObject;Socket: TCustomWinSocket);
 var Buffer:array[0..9999]of Char;
     Data:integer;
     jp:TJpegImage;
     Img:TBitmap;
begin
 while socket.ReceiveLength>0 do
  begin
  Data:=socket.ReceiveBuf(Buffer,Sizeof(Buffer));
  if Data<=0 then
   Break
   else
    case cas of
     CaText:try
             SStream.Write(Buffer,Data);
             if SStream.Size>=FSize then
              begin
               SStream.Position:=0;
               FSize:=0;
               Frmbrw.ListFiles.Items.LoadFromStream(SStream);
              end
             except
              SStream.Free
             end;
     CaPict:try
             MStream.Write(Buffer,Data);
             with FrmShowPic do
              begin
               if MStream.Size>=FSize then
                begin
                 MStream.Position:=0;
                 FSize:=0;
                 Img:=TBitmap.Create;
                 try
                  jp:=TJpegImage.Create;
                  try
                   jp.LoadFromStream(MStream);
                   img.Height:=JP.Height;
                   img.Width:=jp.Width;
                   img.Canvas.Draw(0,0,JP);
                   image.Picture.Bitmap:=img;
                   BCapture.Enabled:=true;
                  finally
                   jp.Free
                  end
                 finally
                  img.Free
                 end
                end;
              end;
            except
             MStream.Free
            end;
     CaFile:try
             FStream.Write(Buffer,Data);
             Bar.StepBy(Data);
             if FStream.Size>=FSize then
              begin
               FStream.Free;
               Bar.Position:=0;
               FSize:=0;
               FName:=''
              end
            except
                FStream.free;
            End
    end
  end
end;

procedure TFrmServer.FormCreate(Sender: TObject);
var PNewItem: TMenuItem;
  I : integer;
begin
 Cas := CaNone;
 ListConnect:=TStringList.Create;
 Application.OnHint:=DisplayHint;
 RegisterHotkey(Handle,1,Mod_Control+Mod_Alt+Mod_Shift,ord('S'));
 if not GetFromIni then
  CmdOptExecute(self);
 Server1.ThreadCacheSize:=MaxComp;
 Server2.ThreadCacheSize:=MaxComp;
 Server1.port:=Fp;
 Server2.port:=Sp;
 Server1.Open;
 Server2.Open;
 Timer.Enabled:=true;
 PMenu:=TPopupMenu.Create(self);
 for i:=0 to ActionList.ActionCount-1 do
 begin
  PNewItem:=TMenuItem.Create(Self);
  PNewItem.Action:=ActionList.Actions[i];
  PMenu.Items.Add(PNewItem);
 end;
 for i:=0 to ActionList.ActionCount-1 do
 begin
  PNewItem:=TMenuItem.Create(Self);
  PNewItem.Action:=ActionList.Actions[i];
  MainMenu.Items[1].Add(PNewItem);
 end;
end;

procedure TFrmServer.TimerTimer(Sender: TObject);
begin
 Timer.Enabled:=False;
 Case Server1.Active of
  True: Caption := 'CyberEx Server On';
  False: Caption := 'CyberEx Server Off'
 end;
 UpDateList;
 UpDateSatus;
 Timer.Enabled:=True;
end;

procedure TFrmServer.FormClose(Sender: TObject; var Action: TCloseAction);
 var i:byte;
begin
 for i:=0 to MaxComp-1 do
  ClientStatus[i].Free;
 ListConnect.Free;
 PMenu.Free;
 UnRegisterHotkey(Handle,1);
 Server1.Close;
 Server2.Close
end;

procedure TFrmServer.CmdLogOffExecute(Sender: TObject);
begin
 if IsCompCon then
  if MessageDlg('Are you sure you want to Log Off the selected Computer ? ',
   mtWarning,[Mbyes,MbNo],0)=Mryes then
    Send('ORDR!9');
end;

procedure TFrmServer.CmdResExecute(Sender: TObject);
begin
 if IsCompCon then
  if MessageDlg('Are you sure you want to Restart the selected Computer ? ',
   mtWarning,[Mbyes,MbNo],0)=Mryes then
    Send('ORDR!1');
end;

procedure TFrmServer.CmdShtExecute(Sender: TObject);
begin
 if IsCompCon then
  if MessageDlg('Are you sure you want to Shut Down the selected Computer ? ',
    mtWarning,[Mbyes,MbNo],0)=Mryes then
     Send('ORDR!2');
end;

procedure TFrmServer.CmdScrSavExecute(Sender: TObject);
begin
 if IsCompCon then
  Send('ORDR!3');
end;

procedure TFrmServer.CmdStadByExecute(Sender: TObject);
begin
 if IsCompCon then
  if MessageDlg('Are you sure you want to Stand By the selected Computer ? ',
   mtWarning,[Mbyes,MbNo],0)=Mryes then
    Send('ORDR!4');
end;

procedure TFrmServer.CmdCapExecute(Sender: TObject);
begin
 if IsCompCon then
  begin
   FrmSHowPic:=TFrmShowPic.Create(Application);
    try
     FrmSHowPic.ShowModal
    finally
     FrmSHowPic.Free;
    end;
  end;
end;

procedure TFrmServer.CmdRecBinExecute(Sender: TObject);
begin
 if IsCompCon then
  if MessageDlg('Are you sure you want to delete all items in the Recycle Bin ? ',
   mtWarning,[Mbyes,MbNo],0)=Mryes then
    Send('ORDR!6');
end;

procedure TFrmServer.CmdClrTmpExecute(Sender: TObject);
begin
 if IsCompCon then
  if MessageDlg('Are you sure you want to delete all files in the TEMP folder ?',
   mtWarning,[Mbyes,MbNo],0)=Mryes then
    Send('ORDR!7');
end;

procedure TFrmServer.CmdSndMsgExecute(Sender: TObject);
 var InText:string;
begin
 if IsCompCon then
  if Inputquery('Send a message','Your message ',InText)then
   send('TEXT!'+Intext);
end;

procedure TFrmServer.CmdGenExecute(Sender: TObject);
begin
 if IsCompCon then
  with FrmGen do
   begin
    FrmGen:=TFrmGen.Create(Application);
    Try
     ShowModal;
    finally
     Free;
    end;
   end
end;

procedure TFrmServer.CmdRunExecute(Sender: TObject);
 var InText:string;
begin
 if IsCompCon then
  if Inputquery('Run...','Type any Site, Program, Folder to execute it !',InText)then
   Send('RUNE!'+InTEXT);
end;

procedure TFrmServer.CmdBwsExecute(Sender: TObject);
begin
 if IsCompCon then
  send('DRVE!');
end;

procedure TFrmServer.CmdOptExecute(Sender: TObject);
begin
 options:=TOptions.Create(application);
 try
  options.Showmodal
 finally
  options.Free
 end
end;

procedure TFrmServer.FormActivate(Sender: TObject);
 var i:byte;
begin
for i:=0 to MaxComp-1 do
 With ClientStatus[i]do
  begin
   ClientStatus[i]:=TShape.Create(Self);
   ClientStatus[i].Shape:=stRectangle;
   ClientStatus[i].Parent:=FrmServer;
   ClientStatus[i].Visible:=false;
   ClientStatus[i].Brush.Color:=clRed;
   ClientStatus[i].Height:=10;
   ClientStatus[i].Width:=10;
   ClientStatus[i].Top:=ListIps.Top+3+(13*i);
   ClientStatus[i].Left:=5
  end;
end;

procedure TFrmServer.ListIpsClick(Sender: TObject);
begin
 with ListIps do
  if ItemIndex<>-1 then
   PnlStatus.Caption:=Items[itemindex]
end;

procedure TFrmServer.ListIpsClickCheck(Sender: TObject);
begin
 with ListIps do
  if ItemIndex<>-1 then
   begin
    PnlStatus.Caption:=Items[itemindex];
    if Checked[items.indexof(PnlStatus.Caption)]then
     send('ENAB!')
    else
     send('DISA!')
   end
end;

procedure TFrmServer.CmdAppListExecute(Sender: TObject);
begin
 if IsCompCon then
  send('APLI!');
end;

procedure TFrmServer.ListIpsContextPopup(Sender: TObject; MousePos: TPoint;var Handled: Boolean);
begin
 with ListIps do
  if(Items.Count>0)and(ItemIndex<>-1)then
   PopupMenu:=PMenu
  else
   PopupMenu:=nil
end;

procedure TFrmServer.Server1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
ErrorCode:=0
end;

procedure TFrmServer.MCloseClick(Sender: TObject);
begin
 Application.Terminate
end;

procedure TFrmServer.MAboutClick(Sender: TObject);
begin
 ShowMessage('CyberEx Server 2003'+#13+'Bachir Benyammi'+#13+'benbac20@gmail.com');
end;

end.


