unit GraphicEllipseClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Types, System.Classes,
        Vcl.Direct2D, vcl.Graphics,
        GeometryTypes,
        GeomBox,
        GraphicDrawingTypes,
        GraphicObjectBaseClass,
        DrawingAxisConversionClass
        ;

    type
        TGraphicEllipse = class(TGraphicObject)
            private
                //convert geom box to ellipse
                    function convertGeomBoxToEllipse(   const geomBoxIn         : TGeomBox;
                                                        const axisConverterIn   : TDrawingAxisConverter ) : TD2D1Ellipse;
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
                                        const   horizontalAlignmentIn   : TAlignment;
                                        const   verticalAlignmentIn     : TVerticalAlignment;
                                        const   fillColourIn,
                                                lineColourIn            : TColor;
                                        const   lineStyleIn             : TPenStyle;
                                        const   handlePointXYIn         : TGeomPoint        );
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setCentrePoint(const xIn, yIn : double);

        end;

implementation

    //private
        //convert geom box to ellipse
            function TGraphicEllipse.convertGeomBoxToEllipse(   const geomBoxIn         : TGeomBox;
                                                                const axisConverterIn   : TDrawingAxisConverter ) : TD2D1Ellipse;
                var
                    handlePointLT   : TPointF;
                    ellipseOut      : TD2D1Ellipse;
                begin
                    //calculate the ellipse handle point
                        handlePointLT := axisConverterIn.XY_to_LT( graphicBox.calculateCentrePoint() );

                        ellipseOut.point.x := handlePointLT.X;
                        ellipseOut.point.y := handlePointLT.y;

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

                    result := ellipseOut;
                end;

        //draw to canvas
            procedure TGraphicEllipse.drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas       );
                var
                    drawingEllipse : TD2D1Ellipse;
                begin
                    //get the drawing ellipse
                        drawingEllipse := convertGeomBoxToEllipse( graphicBox, axisConverterIn );

                    //draw fill
                        if ( filled ) then
                            canvasInOut.FillEllipse( drawingEllipse );

                    //draw line
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
                                                const   horizontalAlignmentIn   : TAlignment;
                                                const   verticalAlignmentIn     : TVerticalAlignment;
                                                const   fillColourIn,
                                                        lineColourIn            : TColor;
                                                const   lineStyleIn             : TPenStyle;
                                                const   handlePointXYIn           : TGeomPoint        );
                var
                    localMinPoint, localMaxPoint : TGeomPoint;
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

        //modifiers
            procedure TGraphicEllipse.setCentrePoint(const xIn, yIn : double);
                begin
                    graphicBox.setCentrePoint( xIn, yIn );
                end;

end.
