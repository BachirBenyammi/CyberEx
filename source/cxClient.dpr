program cxClient;

uses
  Forms,
  Windows,
  UClient in 'UClient.pas' {FrmClient},
  UOptCli in 'UOptCli.pas' {Options};

{$R *.res}

begin
//SetLastError(NO_ERROR);
//CreateMutex (nil, False,'BenBacClient');
//if GetLastError<>ERROR_ALREADY_EXISTS then begin
  Application.Initialize;
  Application.CreateForm(TFrmClient, FrmClient);
  Application.Run
//  end else showwindow(findwindow('TFrmClient',nil),sw_show);
end.


