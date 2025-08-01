program JDB_Graphics;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  ColourMethods in 'Source\ColourMethods.pas',
  GraphicDrawerAxisConversionInterfaceClass in 'Source\GraphicDrawer\GraphicDrawerAxisConversionInterfaceClass.pas',
  GraphicDrawerBaseClass in 'Source\GraphicDrawer\GraphicDrawerBaseClass.pas',
  GraphicDrawerDirect2DClass in 'Source\GraphicDrawer\GraphicDrawerDirect2DClass.pas',
  GraphicDrawerLayersClass in 'Source\GraphicDrawer\GraphicDrawerLayersClass.pas',
  GraphicEntityListBaseClass in 'Source\GraphicDrawer\GraphicEntityListBaseClass.pas',
  LayerGraphicEntityMapClass in 'Source\GraphicDrawer\LayerGraphicEntityMapClass.pas',
  GraphicDrawer2DPaintBoxClass in 'Source\GraphicDrawer\GraphicDrawer2DPaintBoxClass.pas',
  Direct2DLTEntityCanvasClass in 'Source\CustomDirect2DCanvas\Direct2DLTEntityCanvasClass.pas',
  Direct2DDrawingEntityMethods in 'Source\CustomDirect2DCanvas\Direct2DDrawingEntityMethods.pas',
  Direct2DXYEntityCanvasClass in 'Source\CustomDirect2DCanvas\Direct2DXYEntityCanvasClass.pas',
  GraphicGeometryClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityGeometryClasses\GraphicGeometryClass.pas',
  GraphicLineClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityGeometryClasses\GraphicLineClass.pas',
  GraphicPolygonClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityGeometryClasses\GraphicPolygonClass.pas',
  GraphicPolylineClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityGeometryClasses\GraphicPolylineClass.pas',
  GraphicArcClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityShapeClasses\GraphicArcClass.pas',
  GraphicEllipseClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityShapeClasses\GraphicEllipseClass.pas',
  GraphicRectangleClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityShapeClasses\GraphicRectangleClass.pas',
  GraphicShapeClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityShapeClasses\GraphicShapeClass.pas',
  GraphicTextClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityShapeClasses\GraphicTextClass.pas',
  GraphicEntityFoundationalClass in 'Source\GraphicEntityClasses\GraphicEntityFoundationalClasses\GraphicEntityFoundationalClass.pas',
  GraphicArrowClass in 'Source\GraphicEntityClasses\GraphicEntityGroupClasses\GraphicArrowClass.pas',
  GraphicArrowGroupClass in 'Source\GraphicEntityClasses\GraphicEntityGroupClasses\GraphicArrowGroupClass.pas',
  GraphicDimensionClass in 'Source\GraphicEntityClasses\GraphicEntityGroupClasses\GraphicDimensionClass.pas',
  GraphicEntityGroupClass in 'Source\GraphicEntityClasses\GraphicEntityGroupClasses\GraphicEntityGroupClass.pas',
  GraphicGridClass in 'Source\GraphicEntityClasses\GraphicEntityPlottingClasses\GraphicGridClass.pas',
  GraphicGridSettingsRecord in 'Source\GraphicEntityClasses\GraphicEntityPlottingClasses\GraphicGridSettingsRecord.pas',
  GraphicLinePlotClass in 'Source\GraphicEntityClasses\GraphicEntityPlottingClasses\GraphicLinePlotClass.pas',
  GraphicMousePointTrackerClass in 'Source\GraphicEntityClasses\GraphicEntityPlottingClasses\GraphicMousePointTrackerClass.pas',
  GraphicScatterPlotClass in 'Source\GraphicEntityClasses\GraphicEntityPlottingClasses\GraphicScatterPlotClass.pas',
  GraphicEntityBaseClass in 'Source\GraphicEntityClasses\GraphicEntityBaseClass.pas',
  GraphicEntityTypes in 'Source\GraphicEntityClasses\GraphicEntityTypes.pas',
  GraphicDrawerTypes in 'Source\GraphicDrawer\GraphicDrawerTypes.pas',
  Direct2DCustomCanvasClass in 'Source\CustomDirect2DCanvas\Direct2DCustomCanvasClass.pas';

{ keep comment here to protect the following conditional from being removed by the IDE when adding a unit }
{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
