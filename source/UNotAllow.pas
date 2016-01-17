unit UNotAllow;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, benmagic, Buttons, ComCtrls;

type
  TFrmNon = class(TForm)
    Panel1: TPanel;
    NotAllowList: TListBox;
    EditSelected: TEdit;
    BtnAdd: TButton;
    BtnDel: TButton;
    BtnOK: TButton;
    BtnClear: TButton;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure NotAllowListClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
 end;

var FrmNon: TFrmNon;

implementation

uses UServer;

{$R *.dfm}

procedure TFrmNon.BtnAddClick(Sender: TObject);
begin
 If EditSelected.Text='EXPLORER.EXE'then
  begin
   ShowMessage('Windows Can not work properlly without EXPLORER.EXE');
   Exit
  end;
 if ExtractFileName(EditSelected.Text)<>EditSelected.Text then
  begin
   ShowMessage('File name only (ex: CALC.EXE, REGEDIT.EXE, IEXPLORE.EXE');
   Exit
  end;
 with NotAllowList.Items do
  if IndexOf(EditSelected.Text)=-1 then
   begin
    Add(editSelected.Text);
    EditSelected.Clear;
   end
end;

procedure TFrmNon.BtnDelClick(Sender: TObject);
begin
 with NotAllowList do
  if ItemIndex<>-1 then
   Items.Delete(itemindex);
end;

procedure TFrmNon.NotAllowListClick(Sender: TObject);
begin
 with NotAllowList do
  if itemindex<>-1 then
   EditSelected.Text:=Items[itemindex]
end;

procedure TFrmNon.BtnOKClick(Sender: TObject);
begin
 with FrmServer do
  with NotAllowList do
   if IsCompCon then
    begin
     Send('UPLI!'+Items.Text);
     FrmNon.close
    end
end;

procedure TFrmNon.BtnClearClick(Sender: TObject);
begin
NotAllowList.Clear;
end;

end.
