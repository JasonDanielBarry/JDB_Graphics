unit Graphic2DTest;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, system.UITypes, system.Math, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, vcl.Styles, vcl.Themes, Vcl.StdCtrls,

  GeometryTypes,
  GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
  Direct2DLTEntityCanvasClass,
  Direct2DXYEntityCanvasClass,
  GraphicEntityTypes,
  GraphicArrowClass,
  Graphic2DListClass,
  CustomComponentPanelClass,
  Graphic2DComponent
  ;

type
  TForm1 = class(TForm)
    JDBGraphic2D1: TJDBGraphic2D;
    PanelTop: TPanel;
    LabelSelectGraphic: TLabel;
    ComboBox1: TComboBox;
    procedure JDBGraphic2D1UpdateGraphics(  ASender             : TObject;
                                            var AGraphic2DList  : TGraphic2DList );
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JDBGraphic2D1PostGraphicDraw(const AWidth, AHeight: Integer; const AD2DCanvas: TDirect2DLTEntityCanvas);
  private
    var
        graphicIndex : integer;

    //different graphics
        procedure BlueBoxGraphic(var graphicsListInOut : TGraphic2DList);
        procedure XYGraphs(var graphicsListInOut : TGraphic2DList);
        procedure FinPlateGraphic(var graphicsListInOut : TGraphic2DList);
        procedure SoilNailWallGraphic(var graphicsListInOut : TGraphic2DList);
        procedure BendingBeamSection(var graphicsListInOut : TGraphic2DList);
  public
    { Public declarations }
        constructor create(AOwner: TComponent); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

    //different graphics
        procedure TForm1.BlueBoxGraphic(var graphicsListInOut : TGraphic2DList);
            var
                i               : integer;
                x, y            : double;
                point1, point2  : TGeomPoint;
                line            : TGeomLine;
                polyline        : TGeomPolyLine;
                polygon         : TGeomPolygon;
            begin
                //polygon
                    graphicsListInOut.setCurrentDrawingLayer('Polygon Layer');

                    polygon := TGeomPolygon.create();

                    polygon.addVertex(10, 10);
                    polygon.addVertex(50, 10);
                    polygon.addVertex(100, 40);
                    polygon.addVertex(100, 70);
                    polygon.addVertex(50, 100);
                    polygon.addVertex(10, 100);

                    polygon.rotate(45);

                    polygon.setCentroidPoint(50, 100);

                    graphicsListInOut.addPolygon( polygon, True, 9, TColors.Aqua, TColors.Darkred, TPenStyle.psDashDot );

                    FreeAndNil( polygon );

                    graphicsListInOut.addText(50, 100, 'This is a polygon' + sLineBreak + 'rotated 45'#176, True, 9, 45, EScaleType.scCanvas, THorzRectAlign.Center, TVertRectAlign.Center );

                //line 1
                    graphicsListInOut.setCurrentDrawingLayer('Line Layer');

                     point1 := TGeomPoint.create(-5, -5);
                     point2 := TGeomPoint.create(115, 115);

                     line := TGeomLine.create(point1, point2);

                     graphicsListInOut.addLine(line, 4, TColors.Black);

                    graphicsListInOut.addText(115, 115, 'This is a line');

                //polyline
                    graphicsListInOut.setCurrentDrawingLayer('Polyline Layer');

                    polyline := TGeomPolyLine.create();

                    const NUM_POINTS : integer = 3000;

                    for i := 0 to NUM_POINTS do
                        begin
                            x := -100 + ((300 - 10) / NUM_POINTS) * i;
                            y := 5 * sin(x - 10);

                            polyline.addVertex(x, y);
                        end;

                    polyline.setCentroidPoint( line.calculateCentroidPoint() );

                    polyline.rotate(30);

                    polyline.scale( 1.25 );

                    graphicsListInOut.addPolyline(polyline, 3, TColors.Blue);

                    FreeAndNil( line );

                    graphicsListInOut.addText( polyline.boundingBox().xMax, polyline.boundingBox().yMax, 'This is a polyline' + sLineBreak + 'rotated 30'#176 );

                    FreeAndNil( polyline );

                //rectangle
                    graphicsListInOut.setCurrentDrawingLayer('Rectangle');

                    graphicsListInOut.addRectangle( 50, 75, 250, 10,
                                                    True, 4, 10, 30,
                                                    EScaleType.scDrawing,
                                                    THorzRectAlign.Left, TVertRectAlign.Bottom,
                                                    TColors.Burlywood, TColors.Darkblue, TPenStyle.psDash );

                    graphicsListInOut.addText(250, 10, 'This is a round rectangle', False, 9, 30);

                //ellipse
                    graphicsListInOut.setCurrentDrawingLayer('Ellipse');

                    graphicsListInOut.addEllipse(100, 50, -100, 50, True, 6, 45, EScaleType.scDrawing, THorzRectAlign.Center, TVertRectAlign.Center, Tcolors.Lightseagreen);

                    graphicsListInOut.addText(-100, 50, 'This is an ellipse', False, 9, 45, EScaleType.scCanvas, THorzRectAlign.Center, TVertRectAlign.Center);

                //text
                    graphicsListInOut.setCurrentDrawingLayer('Text Layer 1');

                    graphicsListInOut.addText(0, -30, 'This is a short' + sLineBreak + 'sentence of' + sLineBreak + '4 lines' + sLineBreak + 'at (0, -30)');

                    graphicsListInOut.addText(  100, -30, 'This is a short' + sLineBreak + 'sentence of' + sLineBreak + '4 lines' + sLineBreak + 'at (100, -30)',
                                                False, 9, 0, EScaleType.scCanvas,
                                                THorzRectAlign.Center, TVertRectAlign.Center                                );

                    graphicsListInOut.addText(  200, -30, 'This is a short' + sLineBreak + 'sentence of' + sLineBreak + '4 lines' + sLineBreak + 'at (200, -30)',
                                                False, 9, 0, EScaleType.scCanvas,
                                                THorzRectAlign.Right, TVertRectAlign.Bottom                                 );

                    graphicsListInOut.addText(150, -50, 'This is a short' + sLineBreak + 'sentence of' + sLineBreak + '3 lines');

                //vertical boundary test
                    graphicsListInOut.setCurrentDrawingLayer('Text Layer 2');

                    graphicsListInOut.addText(  200, 250,
                                                'This is a short' + sLineBreak + 'sentence of' + sLineBreak + '4 lines using' + sLineBreak + 'drawing scale',
                                                False,
                                                18,
                                                35,
                                                EScaleType.scDrawing,
                                                THorzRectAlign.Left,
                                                TVertRectAlign.Top,
                                                Tcolors.Darkred,
                                                [TFontStyle.fsBold, TFontStyle.fsItalic, TFontStyle.fsUnderline] );

                    graphicsListInOut.setCurrentDrawingLayer('Text Layer 3');

                    graphicsListInOut.addText(  -350, -100,
                                                'This is a short sentence of 1 lines drawing scale',
                                                False,
                                                18,
                                                60,
                                                EScaleType.scDrawing,
                                                THorzRectAlign.Left,
                                                TVertRectAlign.Bottom,
                                                Tcolors.Darkred,
                                                [TFontStyle.fsBold, TFontStyle.fsItalic, TFontStyle.fsUnderline] );

                //arrow
                    graphicsListInOut.setCurrentDrawingLayer('Arrow Layer');

                    var arrowOriginPoint : TGeomPoint := TGeomPoint.create( -50, 150 );

                    for var angle : double in [0, 30, 60, 90, 120, 150, 180] do
                        graphicsListInOut.addArrow( 25, angle, arrowOriginPoint );

                //arrow group
                    graphicsListInOut.setCurrentDrawingLayer('Arrow Group Layer');

                    polyline := TGeomPolyLine.create();

                    polyline.addVertex( -200, 0 );
                    polyline.addVertex( -200, 100 );
                    polyline.addVertex( -100, 200 );
                    polyline.addVertex( 0, 200 );

                    graphicsListInOut.addArrowGroup( 25, polyline, EArrowOrigin.aoHead );

                    FreeAndNil( polyline );

                //arc
                    graphicsListInOut.setCurrentDrawingLayer('Arc Layer');

                    graphicsListInOut.addArc( -100, -125, 50, 25, 90, -135, True, 5, 0, TColors.Red );

                    graphicsListInOut.addArc( 0, -125, 20, 20, 45, 360-45, True, 5, 0, TColors.Yellow );
                    graphicsListInOut.addEllipse( 8, 8, 0, -114, True, 1 ,0, EScaleType.scDrawing );


                    graphicsListInOut.addArc( 100, -125, 50, 50, 0, -90, False, 5 );
                    graphicsListInOut.addArc( 100, -125, 50, 50, 350, -10 );

                //dimension line
                    graphicsListInOut.setCurrentDrawingLayer('Dimension line');

                    line := TGeomLine.create();

                    line.setStartPoint( -300, -100 );
                    line.setEndPoint( -100, -300 );

                    graphicsListInOut.addDimensionLine( line );

                    graphicsListInOut.addDimensionLine( line, 25 );

                    graphicsListInOut.addDimensionLine( line, -25, 'Dimension line', TColors.Darkred );

                    line.setStartPoint( -100, -300 );
                    line.setEndPoint( -300, -300 );

                    graphicsListInOut.addDimensionLine( line );

                    line.setStartPoint( -300, -300 );
                    line.setEndPoint( -300, -100 );

                    graphicsListInOut.addDimensionLine( line );

                    FreeAndNil( line );
            end;

        procedure TForm1.XYGraphs(var graphicsListInOut : TGraphic2DList);
            const
                X_MAX = 500;
                Y_MAX = 250;
            var
                x, y        : double;
                polyLine    : TGeomPolyLine;
            begin
                graphicsListInOut.setCurrentDrawingLayer('XY - Axes');

                //x-axis
                    graphicsListInOut.addText( X_MAX, 10, 'X', False, 15 );

                    graphicsListInOut.addArrow( X_MAX, 0, TGeomPoint.create(0, 0) );

                //y-axis
                    graphicsListInOut.addText( 10, Y_MAX, 'Y', False, 15 );

                    graphicsListInOut.addArrow( Y_MAX, 90, TGeomPoint.create(0, 0) );

                //quadratic curve
                    graphicsListInOut.setCurrentDrawingLayer('Quadratic curve');

                    polyLine := TGeomPolyLine.create();

                    x := 0;
                    y := 0;

                    while (x < X_MAX) do
                        begin
                            y := ( 250 / power(500, 2) ) * power(x, 2);

                            polyLine.addVertex(x, y);

                            x := x + 0.5;
                        end;

                    graphicsListInOut.addPolyline(polyLine, 3, TColors.Blueviolet);

                    graphicsListInOut.addText( x, y, 'y = x'#178 );

                    FreeAndNil( polyLine );

                //Trig curve
                    graphicsListInOut.setCurrentDrawingLayer('Trig curve');

                    polyLine := TGeomPolyLine.create();

                    x := 0;

                    while (x < X_MAX) do
                        begin
                            y := ( 250 / power(500, 2) ) * power(x, 2) + 15 * sin(x / 5);

                            polyLine.addVertex(x, y);

                            x := x + 0.2;
                        end;

                    graphicsListInOut.addPolyline(polyLine, 3, TColors.Green, TPenStyle.psDash);

                    graphicsListInOut.addText( x, y, 'y = sin(x) + x'#178 );

                    FreeAndNil( polyLine );
            end;

    procedure TForm1.FinPlateGraphic(var graphicsListInOut : TGraphic2DList);
        var
            i, j    : integer;
            line    : TGeomLine;
            polygon : TGeomPolygon;
        function
            _creatBoltPolygon(const centreX, centreY : double) : TGeomPolygon;
                var
                    r, h        : double;
                    polygonOut  : TGeomPolygon;
                begin
                    r := 10;
                    h := (2/sqrt(3)) * r;

                    polygonOut := TGeomPolygon.create();

                    polygonOut.addVertex( h, 0 );
                    polygonOut.addVertex( h/2, r );
                    polygonOut.addVertex( -h/2, r );
                    polygonOut.addVertex( -h, 0 );
                    polygonOut.addVertex( -h/2, -r );
                    polygonOut.addVertex( h/2, -r );

                    polygonOut.shift( centreX, centreY );

                    result := polygonOut;
                end;
        begin
            //members
                //beam
                    graphicsListInOut.setCurrentDrawingLayer('Beam');

                    graphicsListInOut.addRectangle( 300, 500, 250 + 50, 300, True, 1, 0, 0, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Bottom, TColors.Lightgreen );

                    //flanges
                        //bottom
                            line := TGeomLine.create();
                            line.setStartPoint(0, 15);
                            line.setEndPoint(300, 15);

                            line.shift(250 + 50, 300);

                            graphicsListInOut.addLine( line, 1 );

                        //top
                            line := TGeomLine.create();
                            line.setStartPoint(0, 500 - 15);
                            line.setEndPoint(300, 500 - 15);

                            line.shift(250 + 50, 300);

                            graphicsListInOut.addLine( line, 1 );

                            FreeAndNil( line );

                //column
                    graphicsListInOut.setCurrentDrawingLayer('Column');

                    graphicsListInOut.addRectangle( 250, 1000, 0, 0, True, 1, 0, 0, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Bottom, TColors.Cornflowerblue );

                    //flanges
                        //left
                            line := TGeomLine.create();
                            line.setStartPoint(15, 0);
                            line.setEndPoint(15, 1000);

                            graphicsListInOut.addLine( line, 1 );

                            FreeAndNil( line );

                        //right
                            line := TGeomLine.create();
                            line.setStartPoint(250 - 15, 0);
                            line.setEndPoint(250 - 15, 1000);

                            graphicsListInOut.addLine( line, 1 );

                            FreeAndNil( line );

                //plate
                    graphicsListInOut.setCurrentDrawingLayer('Plate');

                    graphicsListInOut.addRectangle( 250, 350, 250, 400, True, 1, 0, 0, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Bottom, TColors.Yellow );

            //weld
                graphicsListInOut.setCurrentDrawingLayer('Weld');

                polygon := TGeomPolygon.create();

                polygon.setVertices( [0, 8, 8, 0], [-8, 0, 350, 350 + 8] );

                polygon.shift(250, 400);

                graphicsListInOut.addPolygon( polygon, True, 1, TColors.Blue, TColors.Black );

                FreeAndNil( polygon );

            //bolts
                graphicsListInOut.setCurrentDrawingLayer('Bolts');

                for i := 0 to 5 do
                    for j := 0 to 2 do
                        begin
                            var centreX, centreY : double;

                            centreX := 100 + 50 * j;
                            centreY := 50 + i * 50;

                            polygon := _creatBoltPolygon( centreX, centreY );

                            polygon.shift(250, 400);

                            graphicsListInOut.addPolygon( polygon, True, 2, TColors.Lightseagreen, TColors.Black );

                            FreeAndNil( polygon );

                            graphicsListInOut.addEllipse(14, 14, centreX + 250, centreY + 400, False, 1);
                        end;
        end;

    procedure TForm1.SoilNailWallGraphic(var graphicsListInOut: TGraphic2DList);
        var
            line    : TGeomLine;
            polygon : TGeomPolygon;
        begin
            graphicsListInOut.setCurrentDrawingLayer('Soil');

            polygon := TGeomPolygon.create();

            polygon.addVertex(-2, -3);
            polygon.addVertex(30, -3);
            polygon.addVertex(30, 15);
            polygon.addVertex(0, 15);
            polygon.addVertex(0, 0);
            polygon.addVertex(-2, 0);

            graphicsListInOut.addPolygon( polygon, True, 2, TColors.Lightgreen );

            FreeAndNil( polygon );

            graphicsListInOut.setCurrentDrawingLayer('Failure Wedge');

            polygon := TGeomPolygon.create();

            polygon.addVertex(0, 0);
            polygon.addVertex(20, 15);
            polygon.addVertex(0, 15);

            graphicsListInOut.addPolygon( polygon, True, 2, TColors.Orangered );

            FreeAndNil( polygon );



            graphicsListInOut.setCurrentDrawingLayer('Load');

            line := TGeomLine.create();

            line.setStartPoint(0, 15.15);
            line.setEndPoint(20, 15.15);

            graphicsListInOut.addArrowGroup( 1.5, line, EArrowOrigin.aoHead );

            FreeAndNil( line );



            graphicsListInOut.setCurrentDrawingLayer('Soil Nails');

            begin
                var y : double;

                y := 15 - 1.0;

                while (y > 1.0) do
                    begin
                        graphicsListInOut.addRectangle( 20, 0.2, 0, y, True, 0, 0, -10, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Center, TColors.Grey );
                        graphicsListInOut.addRectangle( 20, 0.025, 0, y, True, 0, 0, -10, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Center, TColors.Darkblue );

                        y := y - 1.5;
                    end;
            end;

            graphicsListInOut.setCurrentDrawingLayer('Wall');

            polygon := TGeomPolygon.create();

            polygon.addVertex(0, 0);
            polygon.addVertex(0, 15);
            polygon.addVertex(-0.35, 15);
            polygon.addVertex(-0.35, 0);

            graphicsListInOut.addPolygon( polygon, True, 2, TColors.Yellow );

            FreeAndNil( polygon );
        end;

    procedure TForm1.BendingBeamSection(var graphicsListInOut : TGraphic2DList);
        var
            line : TGeomLine;
        begin
            //concrete
                graphicsListInOut.setCurrentDrawingLayer('Concrete');

                graphicsListInOut.addRectangle( 450, 450, -450, 0, True, 2, 0, 0, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Bottom, TColors.Lightgreen );

            //rebar
                graphicsListInOut.setCurrentDrawingLayer('Rebar');

                graphicsListInOut.addRectangle( 500, 16, -450, 75-8, True, 2, 0, 0, EScaleType.scDrawing, THorzRectAlign.Left, TVertRectAlign.Bottom, TColors.Dodgerblue );

            //compressing stress
                graphicsListInOut.setCurrentDrawingLayer('Compression Stress');

                line := TGeomLine.create();

                line.setStartPoint( 5, 450 );
                line.setEndPoint( 5, 275 );

                graphicsListInOut.addArrowGroup( 33, line, EArrowOrigin.aoHead );

                FreeAndNil( line );

            //rebar force
                graphicsListInOut.setCurrentDrawingLayer('Tension Force');

                graphicsListInOut.addArrow( 200, 0, TGeomPoint.create( 55, 75 ) );
        end;

    constructor TForm1.create(AOwner: TComponent);
        begin
            inherited create(nil);

            ComboBox1.ItemIndex := 0;
        end;

    procedure TForm1.ComboBox1Change(Sender: TObject);
        begin
            self.LockDrawing();

            graphicIndex := ComboBox1.ItemIndex;

            JDBGraphic2D1.updateGraphics();
            JDBGraphic2D1.zoomAll();

            self.Refresh();

            self.UnlockDrawing();
        end;

    procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
        begin
            Action := TCloseAction.caFree;
        end;

    procedure TForm1.FormShow(Sender: TObject);
        begin
            JDBGraphic2D1.updateGraphics();
            JDBGraphic2D1.zoomAll();
        end;

    procedure TForm1.JDBGraphic2D1PostGraphicDraw(const AWidth, AHeight: Integer; const AD2DCanvas: TDirect2DLTEntityCanvas);
        var
            drawingHeading : string;
        begin
            case ( graphicIndex ) of
                0:
                    drawingHeading := 'All Graphic Entities';
                1:
                    begin
                        drawingHeading := 'Graph Y vs X';

                        AD2DCanvas.setPenLineProperties( 2, clBlack );
                        AD2DCanvas.setBrushFillProperties( True, AD2DCanvas.BackgroundColour );

                        AD2DCanvas.drawLTRectangleF( True, True, 175, 75, 0, 0, PointF(AWidth - 5, 75), THorzRectAlign.Right, TVertRectAlign.Top );

                        var arrPoints : TArray<TPointF>;

                        SetLength( arrPoints, 2 );

                        //legend
                            AD2DCanvas.setFontTextProperties( 11, clWindowText, [TFontStyle.fsUnderline] );

                            AD2DCanvas.printLTTextF( 'Legend', PointF(AWidth - 175, 75+12.5), False, THorzRectAlign.Left, TVertRectAlign.Center );

                            AD2DCanvas.Font.Style := [];

                        //x^2
                            arrPoints[0] := PointF(AWidth - 100, 75 + 3*12.5);
                            arrPoints[1] := PointF(AWidth -  25, 75 + 3*12.5);

                            AD2DCanvas.setPenLineProperties( 3, TColors.Blueviolet );

                            AD2DCanvas.drawLTLineF( arrPoints );

                            AD2DCanvas.printLTTextF( 'x'#178, PointF(AWidth - 175, 75+3*12.5), False, THorzRectAlign.Left, TVertRectAlign.Center );

                        //trig curve
                            arrPoints[0] := PointF(AWidth - 100, 75 + 5*12.5);
                            arrPoints[1] := PointF(AWidth -  25, 75 + 5*12.5);

                            AD2DCanvas.setPenLineProperties( 3, TColors.Green,TPenStyle.psDash );

                            AD2DCanvas.drawLTLineF( arrPoints );

                            AD2DCanvas.Font.Size := 11;

                            AD2DCanvas.printLTTextF( 'sin(x) + x'#178, PointF(AWidth - 175, 75+5*12.5), False, THorzRectAlign.Left, TVertRectAlign.Center );
                    end;
                2:
                    drawingHeading := 'Fin Plate Diagram';
                3:
                    drawingHeading := 'Soil Nail Wall Layout';
                4:
                    drawingHeading := 'Bending Beam Section';
            end;

            AD2DCanvas.setFontTextProperties( 11, clBlack, [TFontStyle.fsBold, TFontStyle.fsUnderline] );
            AD2DCanvas.printLTTextF( drawingHeading, PointF(5, 5), True );
        end;

    procedure TForm1.JDBGraphic2D1UpdateGraphics(   ASender             : TObject;
                                                    var AGraphic2DList  : TGraphic2DList );
        begin
            case ( graphicIndex ) of
                0:
                    BlueBoxGraphic( AGraphic2DList );
                1:
                    XYGraphs( AGraphic2DList );
                2:
                    FinPlateGraphic( AGraphic2DList );
                3:
                    SoilNailWallGraphic( AGraphic2DList );
                4:
                    BendingBeamSection( AGraphic2DList );
            end;
        end;

end.

