unit UShowPic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, Buttons, ExtCtrls,printers, jpeg,Clipbrd, ComCtrls, StdCtrls;

type
  TFrmShowPic = class(TForm)
    Panel1: TPanel;
    BSave: TSpeedButton;
    BPrint: TSpeedButton;
    SB: TScrollBox;
    Image: TImage;
    SPD: TSavePictureDialog;
    BCapture: TSpeedButton;
    BClear: TSpeedButton;
    BCopy: TSpeedButton;
    procedure BSaveClick(Sender: TObject);
    procedure BPrintClick(Sender: TObject);
    procedure BCaptureClick(Sender: TObject);
    procedure BClearClick(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var FrmShowPic: TFrmShowPic;

implementation

uses UServer;

{$R *.DFM}

procedure TFrmShowPic.BSaveClick(Sender: TObject);
begin
 SPD.DefaultExt:=GraphicExtension(TBitmap);
 if spd.Execute then
  image.Picture.SaveToFile(spd.filename)
end;

procedure TFrmShowPic.BPrintClick(Sender: TObject);
begin
 with printer do
  begin
   BeginDoc;
   Canvas.TextOut(10,10,'This page is Generated by CyberEx Server 2003 !!');
   Canvas.Draw((PageWidth-image.Width)div 2,(PageHeight-image.Height)div 2,image.Picture.Graphic);
   EndDoc
  end
end;

procedure TFrmShowPic.BCaptureClick(Sender: TObject);
begin
 if FrmServer.IsCompCon then
  frmServer.Send('ORDR!5');
 BCapture.Enabled:=false
end;

procedure TFrmShowPic.BClearClick(Sender: TObject);
begin
 image.Picture:=nil
end;

procedure TFrmShowPic.BCopyClick(Sender: TObject);
begin
 Clipboard.Assign(Image.Picture)
end;

procedure TFrmShowPic.FormCreate(Sender: TObject);
begin
 With FrmServer do
  if IsCompCon then
   Send('ORDR!5');
end;

end.


