program ProjectServer;

uses
  Vcl.Forms,
  ServerFrm in 'ServerFrm.pas' {FormServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormServer, FormServer);
  Application.Run;
end.
