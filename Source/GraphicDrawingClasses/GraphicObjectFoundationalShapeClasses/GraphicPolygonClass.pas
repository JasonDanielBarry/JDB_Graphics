unit GraphicPolygonClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, System.UIConsts,
            Winapi.D2D1, Vcl.Direct2D,
            vcl.Graphics,
        //custom
            GraphicGeometryClass,
            DrawingAxisConversionClass,
            GeometryTypes,
            GeometryBaseClass,
            GeomPolygonClass
            ;

    type
        TGraphicPolygon = class(TGraphicGeometry)
            private
                //draw to canvas
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       ); override;
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
        end;

implementation

    //private
        //draw to canvas
            procedure TGraphicPolygon.drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas       );
                begin
                    if (length( geometryPoints ) < 3) then
                        exit();

                    //get path geometry
                        drawClosedPathGeometry(
                                                    filled, outlined,
                                                    geometryPoints,
                                                    axisConverterIn,
                                                    canvasInOut
                                              );
                end;

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

end.
