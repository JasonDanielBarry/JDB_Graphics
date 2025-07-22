unit GraphicEllipseClass;

interface

    uses
        system.SysUtils, system.Types, System.Classes,
        vcl.Graphics,
        GeometryTypes,
        GeomBox,
        DrawingAxisConversionClass,
        GraphicShapeClass,
        Direct2DXYEntityCanvasClass
        ;

    type
        TGraphicEllipse = class( TGraphicShape )
            private
                var
                    ellipseWidth, ellipseHeight : double;
                //draw to canvas
                    procedure drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DXYEntityCanvas); override;
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
                                        const   handlePointXYIn         : TGeomPoint    );
                //destructor
                    destructor destroy(); override;
                //bounding box
                    function determineBoundingBox() : TGeomBox; override;
        end;

implementation

        //draw to canvas
            procedure TGraphicEllipse.drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DXYEntityCanvas);
                begin
                    canvasInOut.drawXYEllipse(  filled, outlined,
                                                ellipseWidth, ellipseHeight,
                                                handlePointXY,
                                                axisConverterIn,
                                                horizontalAlignment,
                                                verticalAlignment,
                                                scaleType                   );
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

                    ellipseWidth    := ellipseWidthIn;
                    ellipseHeight   := ellipseHeightIn;
                end;

        //destructor
            destructor TGraphicEllipse.destroy();
                begin
                    inherited destroy();
                end;

        //bounding box
            function TGraphicEllipse.determineBoundingBox() : TGeomBox;
                begin
                    result := calculateShapeBoundingBox( ellipseWidth, ellipseHeight );
                end;

end.
