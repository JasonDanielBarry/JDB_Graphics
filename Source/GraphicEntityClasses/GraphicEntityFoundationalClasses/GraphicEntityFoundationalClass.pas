unit GraphicEntityFoundationalClass;

interface

    uses
        system.UITypes, system.Math, System.Classes, System.Types,
        vcl.Graphics, vcl.Themes,
        DrawingAxisConversionClass,
        Direct2DXYEntityCanvasClass,
        GraphicEntityBaseClass
        ;

    type
        TFoundationalGraphicEntity = class( TGraphicEntity )
            private
                var
                    lineThickness   : integer;
                    fillColour,
                    lineColour      : TColor;
                    lineStyle       : TPenStyle;
                //set canvas properties for drawing
                    procedure setFillProperties(var canvasInOut : TDirect2DXYEntityCanvas);
                    procedure setLineProperties(var canvasInOut : TDirect2DXYEntityCanvas);
            protected
                var
                    filled, outlined : boolean;
            public
                //constructor
                    constructor create( const   filledIn        : boolean;
                                        const   lineThicknessIn : integer;
                                        const   fillColourIn,
                                                lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle );
                //destructor
                    destructor destroy(); override;
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas ); override;
        end;


implementation

    //private
        //set canvas properties for drawing
        procedure TFoundationalGraphicEntity.setFillProperties(var canvasInOut : TDirect2DXYEntityCanvas);
                begin
                    //hollow object
                        if NOT( filled ) then
                            begin
                                canvasInOut.Brush.Style := TBrushStyle.bsClear;
                                exit();
                            end;

                    canvasInOut.Brush.Color := TStyleManager.ActiveStyle.GetSystemColor( fillColour );
                    canvasInOut.Brush.Style := TBrushStyle.bsSolid;
                end;

            procedure TFoundationalGraphicEntity.setLineProperties(var canvasInOut : TDirect2DXYEntityCanvas);
                begin
                    if NOT( outlined ) then
                        begin
                            canvasInOut.Pen.Style := TPenStyle.psClear;
                            exit();
                        end;

                    canvasInOut.Pen.Color := TStyleManager.ActiveStyle.GetSystemColor( lineColour );
                    canvasInOut.Pen.Style := lineStyle;
                    canvasInOut.Pen.Width := lineThickness;
                end;

    //public
        //constructor
            constructor TFoundationalGraphicEntity.create(  const   filledIn        : boolean;
                                                            const   lineThicknessIn : integer;
                                                            const   fillColourIn,
                                                                    lineColourIn    : TColor;
                                                            const   lineStyleIn     : TPenStyle );
                begin
                    inherited create();

                    filled          := filledIn;
                    outlined        := (0 < lineThicknessIn);
                    lineThickness   := lineThicknessIn;
                    fillColour      := fillColourIn;
                    lineColour      := lineColourIn;
                    lineStyle       := lineStyleIn;
                end;

        //destructor
            destructor TFoundationalGraphicEntity.destroy();
                begin
                    inherited destroy();
                end;

        //draw to canvas
            procedure TFoundationalGraphicEntity.drawToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                                var canvasInOut         : TDirect2DXYEntityCanvas   );
                begin
                    //fill properties
                        setFillProperties( canvasInOut );

                    //line properties
                        setLineProperties( canvasInOut );
                end;

end.
