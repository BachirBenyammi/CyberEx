program cxServer;

uses
  Forms,
  Windows,
  UServer in 'UServer.pas' {FrmServer},
  UShowPic in 'UShowPic.pas' {FrmShowPic},
  UApp in 'UApp.pas' {FrmGen},
  UBrws in 'UBrws.pas' {FrmBrw},
  UOptSer in 'UOptSer.pas' {Options},
  UNotAllow in 'UNotAllow.pas' {FrmNon};

{$R *.res}

begin
SetLastError(NO_ERROR);
CreateMutex (nil, False,'BenBacServer');
if GetLastError<>ERROR_ALREADY_EXISTS then begin
  Application.Initialize;
  Application.CreateForm(TFrmServer, FrmServer);
  Application.Run end
else showwindow(findwindow('TFrmServer',nil),sw_show);
end.

