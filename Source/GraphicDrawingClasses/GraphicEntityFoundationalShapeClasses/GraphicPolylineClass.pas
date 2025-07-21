unit GraphicPolylineClass;

interface

    uses
        //Delphi
            system.SysUtils, system.UITypes, System.Math,
            vcl.Graphics,
        //custom
            GeomPolyLineClass,
            DrawingAxisConversionClass,
            Direct2DXYEntityCanvasClass,
            GraphicGeometryClass
            ;

    type
        TGraphicPolyline = class(TGraphicGeometry)
            public
                //constructor
                    constructor create( const   lineThicknessIn : integer;
                                        const   lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle;
                                        const   geometryIn      : TGeomPolyLine );
                //destructor
                    destructor destroy(); override;
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas ); override;
        end;

implementation

    //public
        //constructor
            constructor TGraphicPolyline.create(const   lineThicknessIn : integer;
                                                const   lineColourIn    : TColor;
                                                const   lineStyleIn     : TPenStyle;
                                                const   geometryIn      : TGeomPolyLine);
                begin
                    inherited create(   false,
                                        max( lineThicknessIn, 1 ),
                                        TColors.Null,
                                        lineColourIn,
                                        lineStyleIn,
                                        geometryIn.getArrGeomPoints()   );
                end;

        //destructor
            destructor TGraphicPolyline.destroy();
                begin
                    inherited destroy();
                end;

        //draw to canvas
            procedure TGraphicPolyline.drawToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DXYEntityCanvas);
                begin
                    inherited drawToCanvas( axisConverterIn, canvasInOut );

                    canvasInOut.drawXYPolyline( geometryPoints, axisConverterIn );
                end;

end.
