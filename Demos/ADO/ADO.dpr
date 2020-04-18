program ADO;

uses
  Forms,
  Main in 'Main.pas' {fMain},
  Requests in 'Requests.pas' {fRequests};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
