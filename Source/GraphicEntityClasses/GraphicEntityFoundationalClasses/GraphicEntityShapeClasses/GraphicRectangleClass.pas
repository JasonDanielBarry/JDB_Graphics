unit GraphicRectangleClass;

interface

    uses
        system.SysUtils, system.Types,
        vcl.Graphics,
        GeometryTypes,
        GeomBox,
        DrawingAxisConversionClass,
        GraphicShapeClass,
        Direct2DXYEntityCanvasClass
        ;

    type
        TGraphicRectangle = class( TGraphicShape )
            private
                var
                    cornerRadius,
                    rectangleWidth, rectangleHeight : double;
                //draw to canvas
                    procedure drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DXYEntityCanvas); override;
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
                                        const   handlePointXYIn         : TGeomPoint    );
                //destructor
                    destructor destroy(); override;
                //bounding box
                    function determineBoundingBox() : TGeomBox; override;
        end;

implementation

    //private
        //draw to canvas
            procedure TGraphicRectangle.drawShapeToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DXYEntityCanvas   );
                begin
                    canvasInOut.drawXYRectangle(    filled, outlined,
                                                    rectangleWidth, rectangleHeight,
                                                    cornerRadius,
                                                    handlePointXY,
                                                    axisConverterIn,
                                                    horizontalAlignment,
                                                    verticalAlignment,
                                                    scaleType                           );
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

                    cornerRadius    := rectangleCornerRadiusIn;
                    rectangleWidth  := rectangleWidthIn;
                    rectangleHeight := rectangleHeightIn;
                end;

        //destructor
            destructor TGraphicRectangle.destroy();
                begin
                    inherited destroy();
                end;

        //bounding box
            function TGraphicRectangle.determineBoundingBox() : TGeomBox;
                begin
                    result := calculateShapeBoundingBox( rectangleWidth, rectangleHeight );
                end;

end.
