unit UApp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, ExtCtrls;

type
  TFrmGen = class(TForm)
    Menu: TPopupMenu;
    BtnEnd: TMenuItem;
    Panel1: TPanel;
    BtnGen: TButton;
    BtnFinish: TButton;
    ListV: TListBox;
    procedure BtnGenClick(Sender: TObject);
    procedure BtnFinishClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private public end;

var FrmGen: TFrmGen;

implementation

uses UServer;

{$R *.DFM}

procedure TFrmGen.BtnGenClick(Sender: TObject);
begin
 with FrmServer do if IsCompCon then Send('ORDR!8');
end;

procedure TFrmGen.BtnFinishClick(Sender: TObject);
begin
 if listv.ItemIndex=-1 then
  begin
   ShowMessage('Select a programm first');
   exit
  end;
 if messagedlg('Are you sure you want to close this program ?',mtconfirmation,[mbyes,mbno],0)=mryes then
  with FrmServer do
   if IsCompCon then
    Send('CLOS!'+ListV.Items[listV.ItemIndex]);
end;

procedure TFrmGen.FormCreate(Sender: TObject);
begin
 with FrmServer do
  if IsCompCon then
   Send('ORDR!8')
end;

end.

