program TestJDBD2DCanvas;

uses
  Vcl.Forms,
  TestJDBD2DCanvasMainForm in 'Source\TestJDBD2DCanvasMainForm.pas' {JDB_D2D_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TJDB_D2D_Form, JDB_D2D_Form);
  Application.Run;
end.
