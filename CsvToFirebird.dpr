program CsvToFirebird;

uses
  Vcl.Forms,
  Views.Main in 'src\views\Views.Main.pas' {ViewMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewMain, ViewMain);
  Application.Run;
end.
