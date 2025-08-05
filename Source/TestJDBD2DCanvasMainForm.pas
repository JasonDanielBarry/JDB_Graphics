unit TestJDBD2DCanvasMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls,

  GeometryTypes, GeomBox, GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
  DrawingAxisConversionClass,
  Direct2DXYEntityCanvasClass;

type
  TJDB_D2D_Form = class(TForm)
    PaintBoxArcEntity: TPaintBox;
    GridPanel1: TGridPanel;
    PaintBoxEllipseEntity: TPaintBox;
    PaintBoxPathGeometry: TPaintBox;
    PaintBoxRectangle: TPaintBox;
    PageControl1: TPageControl;
    TabSheetLT: TTabSheet;
    TabSheetXY: TTabSheet;
    PaintBoxXY: TPaintBox;
    procedure PaintBoxArcEntityPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBoxEllipseEntityPaint(Sender: TObject);
    procedure PaintBoxPathGeometryPaint(Sender: TObject);
    procedure PaintBoxRectanglePaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PaintBoxXYPaint(Sender: TObject);
  private
    { Private declarations }
    var
        bitmap          : TBitmap;
        axisConverter   : TDrawingAxisConverter;
    procedure paintAllBoxes();
  public
    { Public declarations }
  end;

var
  JDB_D2D_Form: TJDB_D2D_Form;

implementation

{$R *.dfm}

procedure TJDB_D2D_Form.paintAllBoxes();
    begin
        PaintBoxArcEntity.Repaint();
        PaintBoxEllipseEntity.Repaint();
        PaintBoxPathGeometry.Repaint();
        PaintBoxRectangle.Repaint();
    end;

procedure TJDB_D2D_Form.FormClose(Sender: TObject; var Action: TCloseAction);
    begin
        FreeAndNil( bitmap );
        FreeAndNil( axisConverter );

        action := TCloseAction.caFree;
    end;

procedure TJDB_D2D_Form.FormCreate(Sender: TObject);
    begin
        bitmap := TBitmap.Create();
        axisConverter := TDrawingAxisConverter.create();

        paintAllBoxes();
    end;

procedure TJDB_D2D_Form.FormResize(Sender: TObject);
    begin
        paintAllBoxes();
    end;

procedure TJDB_D2D_Form.PaintBoxArcEntityPaint(Sender: TObject);
    var
        centrePoint : TPointF;
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYEntityCanvas;
    begin
        canvasRect := PaintBoxArcEntity.ClientRect;

        bitmap.SetSize( canvasRect.Width, canvasRect.Height );
        bitmap.canvas.Brush.Color := TDirect2DXYEntityCanvas.BackgroundColour;
        bitmap.canvas.FillRect( canvasRect );

        D2DCanvas := TDirect2DXYEntityCanvas.Create( bitmap );

        D2DCanvas.Brush.Color := TColors.Deepskyblue;

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        centrePoint := PointF( canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawLTArcF( True, True, 360 + 45, 315, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 1.2*canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawLTArcF( True, False, -360-45, 45, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 1.4*canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawLTArcF( False, True, -45, 45, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 3*canvasRect.Width/4, 3*canvasRect.Height/4 );
        D2DCanvas.drawLTArcF( True, True, 135, 225, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        D2DCanvas.printLTTextF( 'Arc Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        D2DCanvas.printLTTextF( 'Text Test', PointF( canvasRect.Width - 1, canvasRect.Height - 1 ), False, THorzRectAlign.Right, TVertRectAlign.Bottom );

        D2DCanvas.printLTTextF( 'Text Test', PointF( 1, 1 ), False );

        FreeAndNil( D2DCanvas );

        PaintBoxArcEntity.Canvas.Draw( 0, 0, bitmap );
    end;

procedure TJDB_D2D_Form.PaintBoxEllipseEntityPaint(Sender: TObject);
    var
        handlePoint : TPointF;
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYEntityCanvas;
    begin
        canvasRect  := PaintBoxEllipseEntity.ClientRect;

        bitmap.SetSize( canvasRect.Width, canvasRect.Height );
        bitmap.canvas.Brush.Color := TDirect2DXYEntityCanvas.BackgroundColour;
        bitmap.canvas.FillRect( canvasRect );

        D2DCanvas := TDirect2DXYEntityCanvas.Create( bitmap );

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;
        D2DCanvas.Font.Size := 12;

        //top left handle point
            D2DCanvas.Brush.Color := TColors.Greenyellow;
            handlePoint := PointF( 0, 0 );
            D2DCanvas.drawLTEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint, THorzRectAlign.Left, TVertRectAlign.Top );

        //bottom right handle point
            D2DCanvas.Brush.Color := TColors.Mediumblue;
            handlePoint := PointF( canvasRect.Width, canvasRect.Height );
            D2DCanvas.drawLTEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint, THorzRectAlign.Right, TVertRectAlign.Bottom );

        //centre handle point
            D2DCanvas.Brush.Color := TColors.Darkred;
            handlePoint := PointF( canvasRect.Width/2, canvasRect.Height/2 );
            D2DCanvas.rotateCanvasLT( 45, handlePoint );
            D2DCanvas.drawLTEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint );

        D2DCanvas.printLTTextF( 'Ellipse Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        D2DCanvas.printLTTextF( 'Text Test', PointF( canvasRect.Width/2, canvasRect.Height/2 ), True, THorzRectAlign.Center, TVertRectAlign.Center );

        FreeAndNil( D2DCanvas );

        PaintBoxEllipseEntity.Canvas.Draw( 0, 0, bitmap );
    end;

procedure TJDB_D2D_Form.PaintBoxPathGeometryPaint(Sender: TObject);
    var
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYEntityCanvas;
    begin
        canvasRect := PaintBoxPathGeometry.ClientRect;

        bitmap.SetSize( canvasRect.Width, canvasRect.Height );
        bitmap.canvas.Brush.Color := TDirect2DXYEntityCanvas.BackgroundColour;
        bitmap.canvas.FillRect( canvasRect );

        D2DCanvas := TDirect2DXYEntityCanvas.Create( bitmap );

        D2DCanvas.Pen.Width := 4;

        //line
            begin
                var startPoint, endPoint : TPointF;

                startPoint := PointF(0, 0);
                endPoint := PointF( canvasRect.Width/4, canvasRect.Height/4 );

                D2DCanvas.drawLTLineF( startPoint, endPoint );
            end;

        //polyline
            begin
                var arrPoints : TArray<TPointF>;

                arrPoints := [  PointF( 0, canvasRect.Height ),
                                PointF( (1/6)*canvasRect.Width, (3/4)*canvasRect.Height ),
                                PointF( (2/6)*canvasRect.Width, canvasRect.Height ),
                                PointF( (3/6)*canvasRect.Width, (3/4)*canvasRect.Height ),
                                PointF( (4/6)*canvasRect.Width, canvasRect.Height ),
                                PointF( (5/6)*canvasRect.Width, (3/4)*canvasRect.Height ),
                                PointF( (6/6)*canvasRect.Width, canvasRect.Height )         ];

                D2DCanvas.drawLTPolylineF( arrPoints );
            end;

        //polygon
            begin
                var arrPoints : TArray<TPointF>;

                arrPoints := [  PointF( (1/2)*canvasRect.Width, (1/2)*canvasRect.Height ),
                                PointF( canvasRect.Width, (1/2)*canvasRect.Height ),
                                PointF( canvasRect.Width, 0 ),
                                PointF( (3/4)*canvasRect.Width, 0 ),
                                PointF( (3/4)*canvasRect.Width, (1/4)*canvasRect.Height ),
                                PointF( (1/2)*canvasRect.Width, (1/4)*canvasRect.Height )   ];

                D2DCanvas.Brush.Color := TColors.Royalblue;

                D2DCanvas.drawLTPolygonF( True, True, arrPoints );
            end;

        D2DCanvas.printLTTextF( 'Path Geometry Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        FreeAndNil( D2DCanvas );

        PaintBoxPathGeometry.Canvas.Draw( 0, 0, bitmap );
    end;

procedure TJDB_D2D_Form.PaintBoxRectanglePaint(Sender: TObject);
    var
        handlePoint : TPointF;
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYEntityCanvas;
    begin
        canvasRect  := PaintBoxRectangle.ClientRect;

        bitmap.SetSize( canvasRect.Width, canvasRect.Height );
        bitmap.canvas.Brush.Color := TDirect2DXYEntityCanvas.BackgroundColour;
        bitmap.canvas.FillRect( canvasRect );

        D2DCanvas := TDirect2DXYEntityCanvas.Create( bitmap );

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        //top left handle point
            D2DCanvas.Brush.Color := TColors.Greenyellow;
            handlePoint := PointF( 0, 0 );
            D2DCanvas.drawLTRectangleF( True, True, canvasRect.Width/4, canvasRect.Height/4, 15, handlePoint, THorzRectAlign.Left, TVertRectAlign.Top );

        //bottom right handle point
            D2DCanvas.Brush.Color := TColors.Mediumblue;
            handlePoint := PointF( canvasRect.Width, canvasRect.Height );
            D2DCanvas.drawLTRectangleF( True, True, canvasRect.Width/4, canvasRect.Height/4, 25, handlePoint, THorzRectAlign.Right, TVertRectAlign.Bottom );

        //centre handle point
            D2DCanvas.Brush.Color := TColors.Darkred;
            handlePoint := PointF( canvasRect.Width/2, canvasRect.Height/2 );
            D2DCanvas.drawLTRectangleF( True, True, canvasRect.Width/4, canvasRect.Height/4, 0, handlePoint );

        D2DCanvas.printLTTextF( 'Rectangle Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        FreeAndNil( D2DCanvas );

        PaintBoxRectangle.Canvas.Draw( 0, 0, bitmap );
    end;

procedure TJDB_D2D_Form.PaintBoxXYPaint(Sender: TObject);
    var
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYEntityCanvas;
    begin
        canvasRect  := PaintBoxXY.ClientRect;

        bitmap.SetSize( canvasRect.Width, canvasRect.Height );
        bitmap.canvas.Brush.Color := TDirect2DXYEntityCanvas.BackgroundColour;
        bitmap.canvas.FillRect( canvasRect );

        D2DCanvas := TDirect2DXYEntityCanvas.Create( bitmap );

        D2DCanvas.Pen.Width := 3;

        axisConverter.setGraphicBoundary( TGeomBox.newBox( (2/3) * canvasRect.Width, (2/3) * canvasRect.Height ) );
        axisConverter.resetDrawingRegionToGraphicBoundary();

        axisConverter.setCanvasDimensions( canvasRect.Width, canvasRect.Height );
        axisConverter.setDrawingSpaceRatio( 1 );

//        D2DCanvas.rotateCanvasXY( -15, TGeomPoint.create( 0, 0 ), axisConverter );

        //arc
            begin
                D2DCanvas.Brush.Color := TColors.Indianred;

                var centrePoint : TGeomPoint := TGeomPoint.create( 550, 400 );

                D2DCanvas.drawXYArc( True, True, 45, -45, 200, 125, centrePoint, axisConverter, EScaleType.scCanvas );

                centrePoint := TGeomPoint.create( 500, 400 );

                D2DCanvas.drawXYArc( True, True, 45, 360 - 45, 200, 125, centrePoint, axisConverter );

                var textPoint : TGeomPoint := TGeomPoint.create( 500, 525 );

                D2DCanvas.printXYText(  'Arc XY entities', textPoint, axisConverter, False, 12, THorzRectAlign.Center, TVertRectAlign.Bottom, EScaleType.scDrawing, clRed, [TFontStyle.fsUnderline] );

                D2DCanvas.printXYText( 'Arc Centre ', centrePoint, axisConverter, False, 16, THorzRectAlign.Right, TVertRectAlign.Center, EScaleType.scDrawing );

                textPoint.setPoint(500, 275);
                D2DCanvas.printXYText( 'Arc Bottom ', textPoint, axisConverter, False, 16, THorzRectAlign.Center, TVertRectAlign.Top, EScaleType.scCanvas );
            end;

        //ellipse
            begin
                D2DCanvas.Brush.Color := TColors.Indigo;
                var handlePoint : TGeomPoint;

                //top-left handle
                    handlePoint.setPoint( 800, 550 );
                    D2DCanvas.drawXYEllipse( True, True, 50, 100, handlePoint, axisConverter, THorzRectAlign.Left, TVertRectAlign.Top );

                //centre handle
                    handlePoint.setPoint( 900, 550 );
                    D2DCanvas.drawXYEllipse( True, True, 50, 100, handlePoint, axisConverter, THorzRectAlign.Center, TVertRectAlign.Center );

                //bottom-right handle
                    handlePoint.setPoint( 1000, 550 );
                    D2DCanvas.drawXYEllipse( True, True, 50, 100, handlePoint, axisConverter, THorzRectAlign.Right, TVertRectAlign.Bottom, EScaleType.scCanvas );
            end;

        //line
            begin
                var testLine : TGeomLine := TGeomLine.create();

                testLine.setStartPoint( 0, 0 );
                testLine.setEndPoint( 100, 100 );

                var linePoints : TArray<TGeomPoint> := testLine.getArrGeomPoints();

                D2DCanvas.drawXYLine( linePoints, axisConverter );

                FreeAndNil( testLine );
            end;

        //polyline
            begin
                var testPolyline : TGeomPolyLine := TGeomPolyLine.create();

                testPolyline.clearVertices();

                for var i := 0 to 200 do
                    begin
                        var x, y, piVal : double;

                        piVal := Pi();

                        x := 100 + i;

                        y := 50 * sin( piVal * i / 100 ) + 125;

                        testPolyline.addVertex( x, y );
                    end;

                var polylinePoints : TArray<TGeomPoint> := testPolyline.getArrGeomPoints();

                D2DCanvas.drawXYPolyline( polylinePoints, axisConverter );

                FreeAndNil( testPolyline );
            end;

        //polygon
            begin
                var xC, yC : double;
                xC := 200;
                yC := 300;

                D2DCanvas.Brush.Color := TColors.Blueviolet;

                var testPolygon : TGeomPolygon := TGeomPolygon.create();

                testPolygon.clearVertices();

                testPolygon.addVertex( xC + 100, yC );
                testPolygon.addVertex( xC + 25, yC + 25 );
                testPolygon.addVertex( xC, yC + 100 );
                testPolygon.addVertex( xC - 25, yC + 25 );
                testPolygon.addVertex( xC - 100, yC );
                testPolygon.addVertex( xC - 25, yC - 25 );
                testPolygon.addVertex( xC, yC - 100 );
                testPolygon.addVertex( xC + 25, yC - 25 );

                var polygonPoints : TArray<TGeomPoint> := testPolygon.getArrGeomPoints();

                D2DCanvas.drawXYPolygon( True, True, polygonPoints, axisConverter );

                testPolygon.setVertices( [0, 50, 25], [200, 200, 300] );

                polygonPoints := testPolygon.getArrGeomPoints();

                D2DCanvas.drawXYPolygon( True, True, polygonPoints, axisConverter );

                FreeAndNil( testPolygon );
            end;

        //rectangle
            begin
                D2DCanvas.Brush.Color := TColors.Green;
                var handlePoint : TGeomPoint;

                //top-left handle
                    handlePoint.setPoint( 900, 350 );
                    D2DCanvas.drawXYRectangle( True, True, 75, 150, 10, handlePoint, axisConverter, THorzRectAlign.Left, TVertRectAlign.Top );

                //centre handle
                    handlePoint.setPoint( 1100, 350 );
                    D2DCanvas.drawXYRectangle( True, True, 75, 150, 20, handlePoint, axisConverter, THorzRectAlign.Center, TVertRectAlign.Center, EScaleType.scCanvas );

                //bottom-right
                    handlePoint.setPoint( 1300, 350 );
                    D2DCanvas.drawXYRectangle( True, True, 75, 150, 30, handlePoint, axisConverter, THorzRectAlign.Right, TVertRectAlign.Bottom );
            end;

        //text
            begin
                var textPoint : TGeomPoint := TGeomPoint.create( 0, (2/3) * canvasRect.Height );

                D2DCanvas.printXYText( 'Text test, size 18, drawing scale, top-left align', textPoint, axisConverter, True, 18, THorzRectAlign.Left, TVertRectAlign.Top, EScaleType.scDrawing );

                textPoint.shiftX( (2/3)*canvasRect.Width );

                D2DCanvas.printXYText( 'Text test, size 18, canvas scale, top-right align', textPoint, axisConverter, False, 18, THorzRectAlign.Right, TVertRectAlign.Top, EScaleType.scCanvas );
            end;

        FreeAndNil( D2DCanvas );

        PaintBoxXY.Canvas.Draw( 0, 0, bitmap );
    end;

end.
