unit GraphicRectangleClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Types, system.Classes,
        Vcl.Direct2D, vcl.Graphics,
        GeometryTypes,
        GeomBox,
        GraphicDrawingTypes,
        GraphicObjectBaseClass,
        DrawingAxisConversionClass
        ;

    type
        TGraphicRectangle = class(TGraphicObject)
            private
                var
                    cornerRadius : double;
                //convert a TGeomBox to TD2D1Rectangle
                    //canvas scale
                        function convertGeomBoxToD2DRectCanvasScale(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                    //drawing scale
                        function convertGeomBoxToD2DRectDrawingScale(const axisConverterIn : TDrawingAxisConverter ) : TD2D1RoundedRect;
                    function convertGeomBoxToD2DRect(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                //draw to canvas
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       ); override;
            public
                //constructor
                    constructor create( const   filledIn                : boolean;
                                        const   lineThicknessIn         : integer;
                                        const   rectangleCornerRadiusIn,
                                                rectangleWidthIn,
                                                rectangleHeightIn,
                                                rotationIn              : double;
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
        //convert a TGeomBox to TD2D1Rectangle
            //canvas scale
                function TGraphicRectangle.convertGeomBoxToD2DRectCanvasScale(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                    var
                        width, height   : double;
                        rectOut         : TD2D1RoundedRect;
                    begin
                        //cache dimensions
                            width   := graphicBox.calculateXDimension();
                            height  := graphicBox.calculateYDimension();

                        //set radius
                            rectOut.radiusX := cornerRadius;
                            rectOut.radiusY := cornerRadius;

                        //set rectangle bounds
                            case ( horizontalAlignment ) of
                                THorzRectAlign.Left:
                                    begin
                                        rectOut.rect.left   := handlePointLT.X;
                                        rectOut.rect.right  := handlePointLT.X + width;
                                    end;

                                THorzRectAlign.Center:
                                    begin
                                        rectOut.rect.left   := handlePointLT.X - width / 2;
                                        rectOut.rect.right  := handlePointLT.X + width / 2;
                                    end;

                                THorzRectAlign.Right:
                                    begin
                                        rectOut.rect.left   := handlePointLT.X - width;
                                        rectOut.rect.right  := handlePointLT.X;
                                    end;
                            end;

                            case ( verticalAlignment ) of
                                TVertRectAlign.Bottom:
                                    begin
                                        rectOut.rect.bottom := handlePointLT.Y;
                                        rectOut.rect.top    := handlePointLT.Y + height;
                                    end;

                                TVertRectAlign.Center:
                                    begin
                                        rectOut.rect.bottom := handlePointLT.Y - height / 2;
                                        rectOut.rect.top    := handlePointLT.Y + height / 2;
                                    end;

                                TVertRectAlign.Top:
                                    begin
                                        rectOut.rect.bottom := handlePointLT.Y - height;
                                        rectOut.rect.top    := handlePointLT.Y;
                                    end;
                            end;

                        result := rectOut;
                    end;

            //drawing scale
                function TGraphicRectangle.convertGeomBoxToD2DRectDrawingScale(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                    var
                        bottomLeft, topRight    : TPointF;
                        rectOut                 : TD2D1RoundedRect;
                    begin
                        //set radius
                            rectOut.radiusX := axisConverterIn.dX_To_dL( cornerRadius );
                            rectOut.radiusY := abs( axisConverterIn.dY_To_dT( cornerRadius ) );

                        //get bottom-left and top-right points
                            bottomLeft  := axisConverterIn.XY_to_LT( graphicBox.minPoint );
                            topRight    := axisConverterIn.XY_to_LT( graphicBox.maxPoint );

                        //set rectangle bounds
                            rectOut.rect.left   := bottomLeft.X;
                            rectOut.rect.bottom := bottomLeft.Y;
                            rectOut.rect.right  := topRight.X;
                            rectOut.rect.top    := topRight.Y;

                        result := rectOut;
                    end;

            function TGraphicRectangle.convertGeomBoxToD2DRect(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                var

                    rectOut : TD2D1RoundedRect;
                begin
                    case ( objectScaleType ) of
                        EScaleType.scDrawing:
                            rectOut := convertGeomBoxToD2DRectDrawingScale( axisConverterIn );

                        EScaleType.scCanvas:
                            rectOut := convertGeomBoxToD2DRectCanvasScale( axisConverterIn );
                    end;

                    result := rectOut;
                end;

        //draw to canvas
            procedure TGraphicRectangle.drawGraphicToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas       );
                var
                    drawingRect : TD2D1RoundedRect;
                begin
                    drawingRect := convertGeomBoxToD2DRect( axisConverterIn );

                    //draw rectangle fill
                        if ( filled ) then
                            canvasInOut.FillRoundedRectangle( drawingRect );

                    //draw rectangle line
                        if ( outlined ) then
                            canvasInOut.DrawRoundedRectangle( drawingRect );
                end;

    //public
        //constructor
            constructor TGraphicRectangle.create(   const   filledIn                : boolean;
                                                    const   lineThicknessIn         : integer;
                                                    const   rectangleCornerRadiusIn,
                                                            rectangleWidthIn,
                                                            rectangleHeightIn,
                                                            rotationIn              : double;
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
                                        rotationIn,
                                        scaleTypeIn,
                                        horizontalAlignmentIn,
                                        verticalAlignmentIn,
                                        fillColourIn,
                                        lineColourIn,
                                        lineStyleIn,
                                        handlePointXYIn         );

                    cornerRadius := rectangleCornerRadiusIn;

                    dimensionAndPositionGraphicBox( rectangleWidthIn, rectangleHeightIn );
                end;

        //destructor
            destructor TGraphicRectangle.destroy();
                begin
                    inherited destroy();
                end;

end.
