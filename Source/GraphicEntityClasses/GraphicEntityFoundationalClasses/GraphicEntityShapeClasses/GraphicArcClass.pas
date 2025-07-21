unit GraphicArcClass;

interface

    uses
        //Delphi
            system.SysUtils, system.Math, system.types, system.UITypes,
            vcl.Graphics,
        //custom
            DrawingAxisConversionClass,
            GeometryTypes,
            GeomBox,
            GeometryBaseClass,
            Direct2DXYEntityCanvasClass,
            GraphicEntityTypes,
            GraphicShapeClass
            ;

    type
        TGraphicArc = class(TGraphicShape)
            strict private
                var
                    startAngle, endAngle,
                    arcXRadius, arcYRadius      : double;
                //draw to canvas
                    procedure drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DXYEntityCanvas); override;
            public
                //constructor
                    constructor create( const   filledIn        : boolean;
                                        const   lineThicknessIn : integer;
                                        const   arcXRadiusIn,
                                                arcYRadiusIn,
                                                startAngleIn,
                                                endAngleIn,
                                                rotationAngleIn : double;
                                        const   fillColourIn,
                                                lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle;
                                        const   handlePointXYIn : TGeomPoint );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //draw to canvas
            procedure TGraphicArc.drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DXYEntityCanvas);
                begin
                    canvasInOut.drawXYArc(  filled, outlined,
                                            startAngle, endAngle,
                                            arcXRadius, arcYRadius,
                                            handlePointXY,
                                            axisConverterIn,
                                            scaleType               );
                end;

    //public
        //constructor
            constructor TGraphicArc.create( const   filledIn        : boolean;
                                            const   lineThicknessIn : integer;
                                            const   arcXRadiusIn,
                                                    arcYRadiusIn,
                                                    startAngleIn,
                                                    endAngleIn,
                                                    rotationAngleIn : double;
                                            const   fillColourIn,
                                                    lineColourIn    : TColor;
                                            const   lineStyleIn     : TPenStyle;
                                            const   handlePointXYIn : TGeomPoint );
                begin
                    inherited create(
                                        filledIn,
                                        lineThicknessIn,
                                        rotationAngleIn,
                                        EScaleType.scDrawing,
                                        THorzRectAlign.Center,
                                        TVertRectAlign.Center,
                                        fillColourIn,
                                        lineColourIn,
                                        lineStyleIn,
                                        handlePointXYIn
                                    );

                    //calculate start and end angles
                        startAngle  := startAngleIn;
                        endAngle    := endAngleIn;

                    //determine the graphic box
                        arcXRadius := arcXRadiusIn;
                        arcYRadius := arcYRadiusIn;
                end;

        //destructor
            destructor TGraphicArc.destroy();
                begin
                    inherited destroy();
                end;

end.
