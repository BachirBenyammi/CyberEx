unit UOptCli;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms, BenMagic,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin,inifiles,WinSock, ComCtrls;

type
  TOptions = class(TForm)
    BtnOk: TBitBtn;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    EditFp: TSpinEdit;
    EditSp: TSpinEdit;
    Label3: TLabel;
    FPort: TSpinEdit;
    SPort: TSpinEdit;
    TPort: TSpinEdit;
    EPort: TSpinEdit;
    Panel2: TPanel;
    GetUsers: TButton;
    ListV: TListView;
    procedure BtnOkClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function SetToIni:boolean;
    function GetFromIni:boolean;
    procedure GetUsersClick(Sender: TObject);
    procedure ListVClick(Sender: TObject);
  end;

var Options:TOptions;

implementation

uses UClient;

{$R *.dfm}

function TOptions.GetFromIni:boolean;
 var ini:tinifile;
     i:byte;
     IpAdr:string;
begin
 with FrmClient do
  with ini do
   begin
    ini:=tinifile.Create(path);
    EditFP.Value:=ReadInteger('Client','FP',FP);
    EditSP.Value:=ReadInteger('Client','SP',SP);
    IPAdr:=ReadString('Client','IP',IP);
    i:=Pos('.',IPAdr);
    FPort.Value:=strtoint(Copy(IPAdr,1,i-1));
    Delete(IPAdr,1,i);
    i:=Pos('.',IPAdr);
    SPort.Value:=strtoint(Copy(IPAdr,1,i-1));
    Delete(IPAdr,1,i);
    i:=Pos('.',IPAdr);
    TPort.Value:=strtoint(Copy(IPAdr,1,i-1));
    Delete(IPAdr,1,i);
    EPort.Value:=strtoint(IPAdr);
    result:=fileexists(path)and SectionExists('Client')and not(Fp=SP);
    free
   end
end;

function TOptions.SetToIni:boolean;
 var
  ini:tinifile;
  IpAdr:string;
begin result:=false;
 if EditFp.Value=EditSp.Value then
  begin
   Showmessage('Ports should not be the same !!');
   exit
  end;
 with FrmClient do
  with ini do
  begin
   ini:=tinifile.Create(path);
   writeInteger('Client','FP',EditFP.Value);
   WriteInteger('Client','SP',EditSP.Value);
   IpAdr:=inttostr(FPort.Value)+'.'+inttostr(SPort.Value)
    +'.'+inttostr(TPort.Value)+'.'+inttostr(EPort.Value);
   WriteString('Client','IP',IpAdr);
   free;
   Fp:=EditFp.Value;
   Sp:=EditSp.Value;
   Ip:=IpAdr
  end;
 result:=true;
end;

procedure TOptions.BtnOkClick(Sender: TObject);
begin
 if SetToIni then
  begin
   if FrmClient.Client1.Port<>0 then
    ShowMessage('You should restart '+Application.Title+' to apply changes !!');
  close
 end
end;

procedure TOptions.FormPaint(Sender: TObject);
begin
 GetFromIni;
end;

procedure TOptions.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if not GetFromIni then
  CanClose:=false
end;

procedure TOptions.GetUsersClick(Sender: TObject);
 var
  i:byte;
  StrHost,StrIp:TStringList;
begin
 ListV.Items.Clear;
 StrHost:=TStringList.Create;
 try
  StrIP:=TStringList.Create;
  try
   GetHosts(StrHost);GetIpAddresses(StrIp);
   if StrHost.count>0 then
    for I := 0 to StrHost.Count-1 do
     with ListV.Items.Add do
      begin
       Caption:=StrHost.Strings[I];
       SubItems.Add(StrIp.Strings[I])
      end;
  finally
   StrIp.Free
  end
  finally
   StrHost.free
  end;
  if ListV.Items.Count>1 then
   panel2.Visible:=not panel2.Visible
  else
   ShowMessage('No users found, Make sure that your are connected !!')
end;

procedure TOptions.ListVClick(Sender: TObject);
 var
  IPadr:string;
  i:byte;
begin
 if listV.Items.Count>0 then
  begin
   IPAdr:=trim(ListV.Selected.SubItems.Text);
   i:=Pos('.',IPAdr);
   FPort.Value:=strtoint(Copy(IPAdr,1,i-1));
   Delete(IPAdr,1,i);
   i:=Pos('.',IPAdr);
   SPort.Value:=strtoint(Copy(IPAdr,1,i-1));
   Delete(IPAdr,1,i);
   i:=Pos('.',IPAdr);
   TPort.Value:=strtoint(Copy(IPAdr,1,i-1));
   Delete(IPAdr,1,i);
   EPort.Value:=strtoint(IPAdr)
  end;
end;

end.




