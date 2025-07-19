unit GraphicRectangleClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Types, system.Classes,
        Vcl.Direct2D, vcl.Graphics,
        GeometryTypes,
        GeomBox,
        GraphicDrawingTypes,
        GraphicEntityBaseClass,
        DrawingAxisConversionClass
        ;

    type
        TGraphicRectangle = class(TGraphicEntity)
            private
                var
                    cornerRadius : double;
                //convert a TGeomBox to TD2D1Rectangle
                    //canvas scale
                        function convertGeomBoxToD2DRectCanvasScale() : TD2D1RoundedRect;
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
                function TGraphicRectangle.convertGeomBoxToD2DRectCanvasScale() : TD2D1RoundedRect;
                    var
                        width, height   : double;
                        roundRectOut    : TD2D1RoundedRect;
                    begin
                        //cache dimensions
                            width   := graphicBox.calculateXDimension();
                            height  := graphicBox.calculateYDimension();

                        //set radius
                            roundRectOut.radiusX := cornerRadius;
                            roundRectOut.radiusY := cornerRadius;

                        //set rectangle bounds
                            case ( horizontalAlignment ) of
                                THorzRectAlign.Left:
                                    begin
                                        roundRectOut.rect.left   := handlePointLT.X;
                                        roundRectOut.rect.right  := handlePointLT.X + width;
                                    end;

                                THorzRectAlign.Center:
                                    begin
                                        roundRectOut.rect.left   := handlePointLT.X - width / 2;
                                        roundRectOut.rect.right  := handlePointLT.X + width / 2;
                                    end;

                                THorzRectAlign.Right:
                                    begin
                                        roundRectOut.rect.left   := handlePointLT.X - width;
                                        roundRectOut.rect.right  := handlePointLT.X;
                                    end;
                            end;

                            case ( verticalAlignment ) of
                                TVertRectAlign.Bottom:
                                    begin
                                        roundRectOut.rect.bottom := handlePointLT.Y;
                                        roundRectOut.rect.top    := handlePointLT.Y - height;
                                    end;

                                TVertRectAlign.Center:
                                    begin
                                        roundRectOut.rect.bottom := handlePointLT.Y + height / 2;
                                        roundRectOut.rect.top    := handlePointLT.Y - height / 2;
                                    end;

                                TVertRectAlign.Top:
                                    begin
                                        roundRectOut.rect.bottom := handlePointLT.Y + height;
                                        roundRectOut.rect.top    := handlePointLT.Y;
                                    end;
                            end;

                        result := roundRectOut;
                    end;

            //drawing scale
                function TGraphicRectangle.convertGeomBoxToD2DRectDrawingScale(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                    var
                        bottomLeft, topRight    : TPointF;
                        roundRectOut            : TD2D1RoundedRect;
                    begin
                        //set radius
                            roundRectOut.radiusX := axisConverterIn.dX_To_dL( cornerRadius );
                            roundRectOut.radiusY := abs( axisConverterIn.dY_To_dT( cornerRadius ) );

                        //get bottom-left and top-right points
                            bottomLeft  := axisConverterIn.XY_to_LT( graphicBox.minPoint );
                            topRight    := axisConverterIn.XY_to_LT( graphicBox.maxPoint );

                        //set rectangle bounds
                            roundRectOut.rect.left   := bottomLeft.X;
                            roundRectOut.rect.bottom := bottomLeft.Y;
                            roundRectOut.rect.right  := topRight.X;
                            roundRectOut.rect.top    := topRight.Y;

                        result := roundRectOut;
                    end;

            function TGraphicRectangle.convertGeomBoxToD2DRect(const axisConverterIn : TDrawingAxisConverter) : TD2D1RoundedRect;
                var

                    roundRectOut : TD2D1RoundedRect;
                begin
                    case ( objectScaleType ) of
                        EScaleType.scDrawing:
                            roundRectOut := convertGeomBoxToD2DRectDrawingScale( axisConverterIn );

                        EScaleType.scCanvas:
                            roundRectOut := convertGeomBoxToD2DRectCanvasScale();
                    end;

                    result := roundRectOut;
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
