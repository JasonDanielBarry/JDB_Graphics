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
  DrawingAxisConversionAspectRatioClass in 'Source\AxisConversion\DrawingAxisConversionAspectRatioClass.pas',
  DrawingAxisConversionBaseClass in 'Source\AxisConversion\DrawingAxisConversionBaseClass.pas',
  DrawingAxisConversionCalculationsClass in 'Source\AxisConversion\DrawingAxisConversionCalculationsClass.pas',
  DrawingAxisConversionClass in 'Source\AxisConversion\DrawingAxisConversionClass.pas',
  DrawingAxisConversionMouseControlClass in 'Source\AxisConversion\DrawingAxisConversionMouseControlClass.pas',
  DrawingAxisConversionPanningClass in 'Source\AxisConversion\DrawingAxisConversionPanningClass.pas',
  DrawingAxisConversionZoomingClass in 'Source\AxisConversion\DrawingAxisConversionZoomingClass.pas',
  GraphicDrawerAxisConversionInterfaceClass in 'Source\GraphicDrawer\GraphicDrawerAxisConversionInterfaceClass.pas',
  GraphicDrawerBaseClass in 'Source\GraphicDrawer\GraphicDrawerBaseClass.pas',
  GraphicDrawerDirect2DClass in 'Source\GraphicDrawer\GraphicDrawerDirect2DClass.pas',
  GraphicDrawerLayersClass in 'Source\GraphicDrawer\GraphicDrawerLayersClass.pas',
  GraphicObjectListBaseClass in 'Source\GraphicDrawer\GraphicObjectListBaseClass.pas',
  LayerGraphicObjectMapClass in 'Source\GraphicDrawer\LayerGraphicObjectMapClass.pas',
  GraphicDrawingTypes in 'Source\GraphicDrawingClasses\GraphicDrawingTypes.pas',
  GraphicObjectBaseClass in 'Source\GraphicDrawingClasses\GraphicObjectBaseClass.pas',
  GraphicArcClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicArcClass.pas',
  GraphicEllipseClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicEllipseClass.pas',
  GraphicGeometryClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicGeometryClass.pas',
  GraphicLineClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicLineClass.pas',
  GraphicPolygonClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicPolygonClass.pas',
  GraphicPolylineClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicPolylineClass.pas',
  GraphicRectangleClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicRectangleClass.pas',
  GraphicTextClass in 'Source\GraphicDrawingClasses\GraphicObjectFoundationalShapeClasses\GraphicTextClass.pas',
  GraphicArrowClass in 'Source\GraphicDrawingClasses\GraphicObjectGroupClasses\GraphicArrowClass.pas',
  GraphicArrowGroupClass in 'Source\GraphicDrawingClasses\GraphicObjectGroupClasses\GraphicArrowGroupClass.pas',
  GraphicObjectGroupClass in 'Source\GraphicDrawingClasses\GraphicObjectGroupClasses\GraphicObjectGroupClass.pas',
  GraphicGridClass in 'Source\GraphicDrawingClasses\GraphicObjectPlottingClasses\GraphicGridClass.pas',
  GraphicMousePointTrackerClass in 'Source\GraphicDrawingClasses\GraphicObjectPlottingClasses\GraphicMousePointTrackerClass.pas',
  GraphicScatterPlotClass in 'Source\GraphicDrawingClasses\GraphicObjectPlottingClasses\GraphicScatterPlotClass.pas',
  GraphicDrawer2DPaintBoxClass in 'Source\GraphicDrawer\GraphicDrawer2DPaintBoxClass.pas',
  GraphicLinePlotClass in 'Source\GraphicDrawingClasses\GraphicObjectPlottingClasses\GraphicLinePlotClass.pas',
  GraphicGridSettingsRecord in 'Source\GraphicDrawingClasses\GraphicObjectPlottingClasses\GraphicGridSettingsRecord.pas',
  GraphicDimensionClass in 'Source\GraphicDrawingClasses\GraphicObjectGroupClasses\GraphicDimensionClass.pas';

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
