unit TestJDBD2DCanvasMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  JDBDirect2DCanvasClass;

type
  TJDB_D2D_Form = class(TForm)
    PaintBoxArcEntity: TPaintBox;
    GridPanel1: TGridPanel;
    PaintBoxEllipseEntity: TPaintBox;
    procedure PaintBoxArcEntityPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBoxEllipseEntityPaint(Sender: TObject);
  private
    { Private declarations }
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
    end;

procedure TJDB_D2D_Form.FormCreate(Sender: TObject);
    begin
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
        D2DCanvas   : TJDBDirect2DCanvas;
    begin
        canvasRect  := PaintBoxArcEntity.ClientRect;

        D2DCanvas := TJDBDirect2DCanvas.Create( PaintBoxArcEntity.Canvas, canvasRect );

        D2DCanvas.Brush.Color := TColors.Deepskyblue;

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        centrePoint := PointF( canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawArcF( True, True, 45, 315, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 1.2*canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawArcF( True, True, -45, 45, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        centrePoint := PointF( 3*canvasRect.Width/4, 3*canvasRect.Height/4 );
        D2DCanvas.drawArcF( True, True, 135, 225, canvasRect.Width/6, canvasRect.Height/6, centrePoint );

        FreeAndNil( D2DCanvas );
    end;

procedure TJDB_D2D_Form.PaintBoxEllipseEntityPaint(Sender: TObject);
    var
        handlePoint : TPointF;
        canvasRect  : TRect;
        D2DCanvas   : TJDBDirect2DCanvas;
    begin
        canvasRect  := PaintBoxEllipseEntity.ClientRect;

        D2DCanvas := TJDBDirect2DCanvas.Create( PaintBoxEllipseEntity.Canvas, canvasRect );

        D2DCanvas.Pen.Color := TColors.Black;
        D2DCanvas.Pen.Width := 3;

        D2DCanvas.Brush.Color := TColors.Darkred;
        handlePoint := PointF( canvasRect.Width/4, canvasRect.Height/4 );
        D2DCanvas.drawEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint );

        D2DCanvas.Brush.Color := TColors.Greenyellow;
        handlePoint := PointF( canvasRect.Width/2, canvasRect.Height/2 );
        D2DCanvas.drawEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint, THorzRectAlign.Left, TVertRectAlign.Top );

        D2DCanvas.Brush.Color := TColors.Mediumblue;
        handlePoint := PointF( canvasRect.Width/2, canvasRect.Height/2 );
        D2DCanvas.drawEllipseF( True, True, canvasRect.Width/4, canvasRect.Height/4, handlePoint, THorzRectAlign.Right, TVertRectAlign.Bottom );

        FreeAndNil( D2DCanvas );
    end;

end.
