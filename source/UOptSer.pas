unit UOptSer;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, inifiles, BenMagic;

const Port_Msg='Ports shouldn''t be the same !!';

type
  TOptions = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    EditFp: TSpinEdit;
    EditSp: TSpinEdit;
    BtnOk: TBitBtn;
    EditIp: TEdit;
    procedure BtnOkClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function SetToIni:boolean;function GetFromIni:boolean;
  end;

var Options:TOptions;

implementation

uses UServer;

{$R *.dfm}

Function TOptions.GetFromIni:boolean;
 var ini:tinifile;
begin
 EditIp.Text:=GetLocalIP;
 with FrmServer do
  with ini do
   begin
    ini:=tinifile.Create(path);
    EditFP.Value:=ReadInteger('Server','FP',FP);
    EditSP.Value:=ReadInteger('Server','SP',SP);
    result:=not(Fp=Sp)and fileExists(path)and SectionExists('Server');
    free
   end
end;

function TOptions.SetToIni:boolean;
 var ini:tinifile;
begin
 with FrmServer do
  with ini do
   begin
    Fp:=EditFp.Value;
    Sp:=EditSp.Value;
    result:=false;
    if Fp=Sp then
     begin
      Showmessage('Ports shouldn''t be the same !!');
      exit
     end;
    ini:=tinifile.Create(path);
    writeInteger('Server','FP',FP);
    WriteInteger('Server','SP',SP);
    WriteString('Server','IP',EditIp.Text);
    free
   end;
 result:=true
end;

procedure TOptions.BtnOkClick(Sender: TObject);
begin
 if SetToIni then
  close
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

end.

