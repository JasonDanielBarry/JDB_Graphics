unit GraphicEllipseClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Types, System.Classes,
        Vcl.Direct2D, vcl.Graphics,
        GeometryTypes,
        GeomBox,
        GraphicDrawingTypes,
        GraphicEntityBaseClass,
        DrawingAxisConversionClass
        ;

    type
        TGraphicEllipse = class(TGraphicEntity)
            private
                //convert geom box to ellipse
                    function convertGraphicBoxToEllipse(const axisConverterIn : TDrawingAxisConverter) : TD2D1Ellipse;
                //draw to canvas
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       ); override;
            public
                //constructor
                    constructor create( const   filledIn                : boolean;
                                        const   lineThicknessIn         : integer;
                                                ellipseWidthIn,
                                                ellipseHeightIn,
                                                rotationAngleIn         : double;
                                        const   scaleTypeIn             : EScaleType;
                                        const   horizontalAlignmentIn   : THorzRectAlign;
                                        const   verticalAlignmentIn     : TVertRectAlign;
                                        const   fillColourIn,
                                                lineColourIn            : TColor;
                                        const   lineStyleIn             : TPenStyle;
                                        const   handlePointXYIn         : TGeomPoint        );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //convert geom box to ellipse
            function TGraphicEllipse.convertGraphicBoxToEllipse(const axisConverterIn : TDrawingAxisConverter) : TD2D1Ellipse;
                var
                    ellipseCentreX,
                    ellipseCentreY  : double;
                    ellipseOut      : TD2D1Ellipse;
                begin
                    //calculate the ellipse dimensions
                        case ( objectScaleType ) of
                            EScaleType.scDrawing:
                                begin
                                    ellipseOut.radiusX := 0.5 * axisConverterIn.dX_To_dL( graphicBox.calculateXDimension() );
                                    ellipseOut.radiusY := 0.5 * axisConverterIn.dY_To_dT( graphicBox.calculateYDimension() );
                                end;

                            EScaleType.scCanvas:
                                begin
                                    ellipseOut.radiusX := 0.5 * graphicBox.calculateXDimension();
                                    ellipseOut.radiusY := 0.5 * graphicBox.calculateYDimension();
                                end;
                        end;

                    //alignment
                        case ( horizontalAlignment ) of
                            THorzRectAlign.Left:
                                ellipseCentreX := handlePointLT.X + ellipseOut.radiusX;

                            THorzRectAlign.Center:
                                ellipseCentreX := handlePointLT.X;

                            THorzRectAlign.Right:
                                ellipseCentreX := handlePointLT.X - ellipseOut.radiusX;
                        end;

                        case ( verticalAlignment ) of
                            TVertRectAlign.Bottom:
                                ellipseCentreY := handlePointLT.y + ellipseOut.radiusY;

                            TVertRectAlign.Center:
                                ellipseCentreY := handlePointLT.y;

                            TVertRectAlign.Top:
                                ellipseCentreY := handlePointLT.y - ellipseOut.radiusY;
                        end;

                        ellipseOut.point.x := ellipseCentreX;
                        ellipseOut.point.y := ellipseCentreY;

                    result := ellipseOut;
                end;

        //draw to canvas
            procedure TGraphicEllipse.drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas       );
                var
                    drawingEllipse : TD2D1Ellipse;
                begin
                    //get the drawing ellipse
                        drawingEllipse := convertGraphicBoxToEllipse( axisConverterIn );

                    //draw fill
                        if ( filled ) then
                            canvasInOut.FillEllipse( drawingEllipse );

                    //draw line
                        if ( outlined ) then
                            canvasInOut.DrawEllipse( drawingEllipse );
                end;

    //public
        //constructor
            constructor TGraphicEllipse.create( const   filledIn                : boolean;
                                                const   lineThicknessIn         : integer;
                                                        ellipseWidthIn,
                                                        ellipseHeightIn,
                                                        rotationAngleIn         : double;
                                                const   scaleTypeIn             : EScaleType;
                                                const   horizontalAlignmentIn   : THorzRectAlign;
                                                const   verticalAlignmentIn     : TVertRectAlign;
                                                const   fillColourIn,
                                                        lineColourIn            : TColor;
                                                const   lineStyleIn             : TPenStyle;
                                                const   handlePointXYIn         : TGeomPoint        );
                begin
                    inherited create(   filledIn,
                                        lineThicknessIn,
                                        rotationAngleIn,
                                        scaleTypeIn,
                                        horizontalAlignmentIn,
                                        verticalAlignmentIn,
                                        fillColourIn,
                                        lineColourIn,
                                        lineStyleIn,
                                        handlePointXYIn         );

                    dimensionAndPositionGraphicBox( ellipseWidthIn, ellipseHeightIn );
                end;

        //destructor
            destructor TGraphicEllipse.destroy();
                begin
                    inherited destroy();
                end;

end.
