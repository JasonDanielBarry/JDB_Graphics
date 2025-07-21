unit GraphicPolygonClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes,
            vcl.Graphics,
        //custom
            DrawingAxisConversionClass,
            GeomPolygonClass,
            GraphicGeometryClass,
            Direct2DXYEntityCanvasClass
            ;

    type
        TGraphicPolygon = class(TGraphicGeometry)
            public
                //constructor
                    constructor create( const   filledIn        : boolean;
                                        const   lineThicknessIn : integer;
                                        const   fillColourIn,
                                                lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle;
                                        const   geometryIn      : TGeomPolygon );
                //destructor
                    destructor destroy(); override;
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas ); override;
        end;

implementation

    //public
        //constructor
            constructor TGraphicPolygon.create( const   filledIn        : boolean;
                                                const   lineThicknessIn : integer;
                                                const   fillColourIn,
                                                        lineColourIn    : TColor;
                                                const   lineStyleIn     : TPenStyle;
                                                const   geometryIn      : TGeomPolygon );
                begin
                    inherited create(   filledIn,
                                        lineThicknessIn,
                                        fillColourIn,
                                        lineColourIn,
                                        lineStyleIn,
                                        geometryIn.getArrGeomPoints()   );
                end;

        //destructor
            destructor TGraphicPolygon.destroy();
                begin
                    inherited destroy();
                end;

        //draw to canvas
            procedure TGraphicPolygon.drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DXYEntityCanvas );
                begin
                    inherited drawToCanvas( axisConverterIn, canvasInOut );

                    canvasInOut.drawXYPolygon( filled, outlined, geometryPoints, axisConverterIn );
                end;

end.
