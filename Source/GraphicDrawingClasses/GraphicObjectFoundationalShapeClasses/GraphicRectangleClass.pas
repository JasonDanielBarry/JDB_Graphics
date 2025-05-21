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
                    rectangleBox : TGeomBox;
                //convert a TGeomBox to TD2D1Rectangle
                    function convertGeomBoxToD2DRect(   const cornerRadiusIn    : double;
                                                        const geomBoxIn         : TGeomBox;
                                                        const axisConverterIn   : TDrawingAxisConverter ) : TD2D1RoundedRect;
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
                                        const   horizontalAlignmentIn   : TAlignment;
                                        const   verticalAlignmentIn     : TVerticalAlignment;
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
            function TGraphicRectangle.convertGeomBoxToD2DRect( const cornerRadiusIn    : double;
                                                                const geomBoxIn         : TGeomBox;
                                                                const axisConverterIn   : TDrawingAxisConverter ) : TD2D1RoundedRect;
                var
                    bottomLeft, topRight    : TPointF;
                    rectOut                 : TD2D1RoundedRect;
                begin
                    //set radius
                        rectOut.radiusX := axisConverterIn.dX_To_dL( cornerRadiusIn );
                        rectOut.radiusY := axisConverterIn.dY_To_dT( cornerRadiusIn );

                    //get bottom-left and top-right points
                        bottomLeft  := axisConverterIn.XY_to_LT( geomBoxIn.minPoint );
                        topRight    := axisConverterIn.XY_to_LT( geomBoxIn.maxPoint );

                    //set rectangle bounds
                        rectOut.rect.left   := bottomLeft.X;
                        rectOut.rect.bottom := bottomLeft.Y;
                        rectOut.rect.right  := topRight.X;
                        rectOut.rect.top    := topRight.Y;

                    result := rectOut;
                end;

        //draw to canvas
            procedure TGraphicRectangle.drawGraphicToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas       );
                var
                    drawingRect : TD2D1RoundedRect;
                begin
                    drawingRect := convertGeomBoxToD2DRect( cornerRadius, rectangleBox, axisConverterIn );

                    //draw rectangle fill
                        if ( filled ) then
                            canvasInOut.FillRoundedRectangle( drawingRect );

                    //draw rectangle line
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
                                                    const   horizontalAlignmentIn   : TAlignment;
                                                    const   verticalAlignmentIn     : TVerticalAlignment;
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
