program ProjectClient;

uses
  Vcl.Forms,
  ClientFrm in 'ClientFrm.pas' {FormClient};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormClient, FormClient);
  Application.Run;
end.
