unit UBrws;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons, Menus, ActnList, ExtCtrls;

type
  TFrmBrw = class(TForm)
    SD: TSaveDialog;
    Command: TActionList;
    ExecuteAc: TAction;
    DeleteAc: TAction;
    CopyAc: TAction;
    Menu: TPopupMenu;
    Execute1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    Panel1: TPanel;
    EditDir: TComboBox;
    Ok: TSpeedButton;
    ListFiles: TFileListBox;
    Accept1: TMenuItem;
    procedure ListFilesDblClick(Sender: TObject);
    procedure ListFilesKeyPress(Sender: TObject; var Key: Char);
    procedure EditDirKeyPress(Sender: TObject; var Key: Char);
    procedure OkClick(Sender: TObject);
    procedure ExecuteAcExecute(Sender: TObject);
    procedure CopyAcExecute(Sender: TObject);
    procedure DeleteAcExecute(Sender: TObject);
    procedure Accept1Click(Sender: TObject);
    procedure ListFilesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  end;

var FrmBrw: TFrmBrw;

implementation

uses UServer, UNotAllow;

{$R *.DFM}

function detect(f:tfilelistbox):boolean;
 var path:string;
begin path:=f.Items[f.Itemindex];
 if(path[1]='[')and(path[length(path)]=']')then
  result:=true
 else
  result:=false;
end;

procedure TFrmBrw.ListFilesDblClick(Sender: TObject);
begin
 EditDir.Text:=ListFiles.Items[ListFiles.ItemIndex];
 if Detect(ListFiles)then
  OKClick(sender)
 else
  ExecuteAcExecute(Sender)
end;

procedure TFrmBrw.ListFilesKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  begin
   ListFilesDblClick(sender);
   key:=#0
  end;
end;

procedure TFrmBrw.EditDirKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  begin
   OKClick(sender);
   key:=#0
  end
end;

procedure TFrmBrw.OkClick(Sender: TObject);
begin
 if length(EditDir.Text)=0 then
  EditDir.Text := 'c:\';
 with FrmServer do
  if IsCompCon then
   Send('LIST!'+EditDir.Text);
end;

procedure TFrmBrw.ExecuteAcExecute(Sender: TObject);
begin
 if MessageDlg('Execute this file in the Client Computer ?',
  mtconfirmation,[Mbyes,MbCancel],0)=Mryes then
   with FrmServer do
    if IsCompCon then
     Send('EXEC!'+inttostr(listFiles.ItemIndex));
end;

procedure TFrmBrw.CopyAcExecute(Sender: TObject);
 var Ext,InFile:String;
begin
 InFile:=ExtractFilename(ListFiles.FileName);
 Sd.FileName:=InFile;
 Ext:=ExtractFileExt(Sd.FileName);
 Delete(Ext,1,1);
 Sd.Filter:=Ext+' Files(*.'+Ext+')|*.'+Ext+'|All Files (*.*)|*.*';
  if Sd.Execute then
   begin
    FrmServer.FName:=Sd.FileName;
    with FrmServer do
     if IsCompCon then
      send('COPY!'+InFile)
   end
end;

procedure TFrmBrw.DeleteAcExecute(Sender: TObject);
begin
 if MessageDlg('Are you sure you want to send '+
  ListFiles.Items[ListFiles.ItemIndex]+' to the becycle bin ? ',
   mtWarning,[Mbyes,MbNo],0)=Mryes then
    with FrmServer do
     if IsCompCon then
      Send('DELE!'+EditDir.Text+'ô'+inttostr(listFiles.ItemIndex));
end;

procedure TFrmBrw.Accept1Click(Sender: TObject);
begin
 with FrmServer do
  if IsCompCon then
   Send('ADLI!'+ExtractFileName(ListFIles.FileName));
end;

procedure TFrmBrw.ListFilesContextPopup(Sender: TObject; MousePos: TPoint;var Handled: Boolean);
begin
 with ListFiles do
  If ItemIndex=-1 then
   PopupMenu:=Nil
  else
   begin
    PopupMenu:=Menu;
    if(Items.Count>1)and(UpperCase(ExtractFileExt(FileName))='.EXE')then
     Accept1.Enabled:=true
    else
     Accept1.Enabled:=false;
   end;
end;

end.
