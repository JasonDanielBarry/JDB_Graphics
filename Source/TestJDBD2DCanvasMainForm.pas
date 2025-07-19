unit TestJDBD2DCanvasMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls,

  GeometryTypes, GeomBox, GeomLineClass,
  DrawingAxisConversionClass,
  Direct2DXYCanvasClass;

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
        axisConverter : TDrawingAxisConverter;
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
        FreeAndNil( axisConverter );

        action := TCloseAction.caFree;
    end;

procedure TJDB_D2D_Form.FormCreate(Sender: TObject);
    begin
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
        D2DCanvas   : TDirect2DXYCanvas;
    begin
        canvasRect  := PaintBoxArcEntity.ClientRect;

        D2DCanvas := TDirect2DXYCanvas.Create( PaintBoxArcEntity.Canvas, canvasRect );

        D2DCanvas.Brush.Color := TColors.Deepskyblue;

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        centrePoint := PointF( canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawArcF( True, True, 45, 315, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 1.2*canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawArcF( True, False, -45, 45, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 1.4*canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawArcF( False, True, -45, 45, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 3*canvasRect.Width/4, 3*canvasRect.Height/4 );
        D2DCanvas.drawArcF( True, True, 135, 225, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        D2DCanvas.printTextF( 'Arc Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        D2DCanvas.printTextF( 'Text Test', PointF( canvasRect.Width - 1, canvasRect.Height - 1 ), False, THorzRectAlign.Right, TVertRectAlign.Bottom );

        D2DCanvas.printTextF( 'Text Test', PointF( 1, 1 ), False );

        FreeAndNil( D2DCanvas );
    end;

procedure TJDB_D2D_Form.PaintBoxEllipseEntityPaint(Sender: TObject);
    var
        handlePoint : TPointF;
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYCanvas;
    begin
        canvasRect  := PaintBoxEllipseEntity.ClientRect;

        D2DCanvas := TDirect2DXYCanvas.Create( PaintBoxEllipseEntity.Canvas, canvasRect );

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        //top left handle point
            D2DCanvas.Brush.Color := TColors.Greenyellow;
            handlePoint := PointF( 0, 0 );
            D2DCanvas.drawEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint, THorzRectAlign.Left, TVertRectAlign.Top );

        //bottom right handle point
            D2DCanvas.Brush.Color := TColors.Mediumblue;
            handlePoint := PointF( canvasRect.Width, canvasRect.Height );
            D2DCanvas.drawEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint, THorzRectAlign.Right, TVertRectAlign.Bottom );

        //centre handle point
            D2DCanvas.Brush.Color := TColors.Darkred;
            handlePoint := PointF( canvasRect.Width/2, canvasRect.Height/2 );
            D2DCanvas.drawEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint );

        D2DCanvas.printTextF( 'Ellipse Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        D2DCanvas.printTextF( 'Text Test', PointF( canvasRect.Width/2, canvasRect.Height/2 ), True, THorzRectAlign.Center, TVertRectAlign.Center );

        FreeAndNil( D2DCanvas );
    end;

procedure TJDB_D2D_Form.PaintBoxPathGeometryPaint(Sender: TObject);
    var
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYCanvas;
    begin
        canvasRect  := PaintBoxPathGeometry.ClientRect;

        D2DCanvas := TDirect2DXYCanvas.Create( PaintBoxPathGeometry.Canvas, canvasRect );

        D2DCanvas.Pen.Width := 4;

        //line
            begin
                var startPoint, endPoint : TPointF;

                startPoint := PointF(0, 0);
                endPoint := PointF( canvasRect.Width/4, canvasRect.Height/4 );

                D2DCanvas.drawLineF( startPoint, endPoint );
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

                D2DCanvas.drawPolylineF( arrPoints );
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

                D2DCanvas.drawPolygonF( True, True, arrPoints );
            end;

        D2DCanvas.printTextF( 'Path Geometry Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        FreeAndNil( D2DCanvas );
    end;

procedure TJDB_D2D_Form.PaintBoxRectanglePaint(Sender: TObject);
    var
        handlePoint : TPointF;
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYCanvas;
    begin
        canvasRect  := PaintBoxRectangle.ClientRect;

        D2DCanvas := TDirect2DXYCanvas.Create( PaintBoxRectangle.Canvas, canvasRect );

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        //top left handle point
            D2DCanvas.Brush.Color := TColors.Greenyellow;
            handlePoint := PointF( 0, 0 );
            D2DCanvas.drawRectangleF( True, True, canvasRect.Width/4, canvasRect.Height/4, 15, handlePoint, THorzRectAlign.Left, TVertRectAlign.Top );

        //bottom right handle point
            D2DCanvas.Brush.Color := TColors.Mediumblue;
            handlePoint := PointF( canvasRect.Width, canvasRect.Height );
            D2DCanvas.drawRectangleF( True, True, canvasRect.Width/4, canvasRect.Height/4, 25, handlePoint, THorzRectAlign.Right, TVertRectAlign.Bottom );

        //centre handle point
            D2DCanvas.Brush.Color := TColors.Darkred;
            handlePoint := PointF( canvasRect.Width/2, canvasRect.Height/2 );
            D2DCanvas.drawRectangleF( True, True, canvasRect.Width/4, canvasRect.Height/4, 0, handlePoint );

        D2DCanvas.printTextF( 'Rectangle Entities', PointF( canvasRect.Width/2, 1 ), False, THorzRectAlign.Center, TVertRectAlign.Top );

        FreeAndNil( D2DCanvas );
    end;

procedure TJDB_D2D_Form.PaintBoxXYPaint(Sender: TObject);
    var
        canvasRect  : TRect;
        D2DCanvas   : TDirect2DXYCanvas;
    begin
        canvasRect  := PaintBoxXY.ClientRect;

        D2DCanvas := TDirect2DXYCanvas.Create( PaintBoxXY.Canvas, canvasRect );

        D2DCanvas.Pen.Width := 3;

        axisConverter.setGeometryBoundary( TGeomBox.newBox( canvasRect.Width, canvasRect.Height ) );
        axisConverter.resetDrawingRegionToGeometryBoundary();

        axisConverter.setCanvasDimensions( canvasRect.Width, canvasRect.Height );
        axisConverter.setDrawingSpaceRatio( 1 );

        //line
            begin
                var testLine : TGeomLine := TGeomLine.create();

                testLine.setStartPoint( 0, 0 );
                testLine.setEndPoint( 100, 100 );

                D2DCanvas.drawXYLine( testLine, axisConverter );
            end;

        FreeAndNil( D2DCanvas );
    end;

end.
