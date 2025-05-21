unit GraphicPolylineClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, System.UIConsts,
            Winapi.D2D1, Vcl.Direct2D,
            vcl.Graphics,
        //custom
            GraphicGeometryClass,
            GeometryBaseClass,
            GeomPolyLineClass,
            DrawingAxisConversionClass

            ;

    type
        TGraphicPolyline = class(TGraphicGeometry)
            private
                //draw to canvas
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       ); override;
            public
                //constructor
                    constructor create( const   lineThicknessIn : integer;
                                        const   lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle;
                                        const   geometryIn      : TGeomPolyLine );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //draw to canvas
            procedure TGraphicPolyline.drawGraphicToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas       );
                var
                    pathGeometry : ID2D1PathGeometry;
                begin
                    if (length( geometryPoints ) < 2) then
                        exit();

                    pathGeometry := createOpenPathGeometry(
                                                                geometryPoints,
                                                                axisConverterIn
                                                          );

                    canvasInOut.DrawGeometry( pathGeometry );
                end;

    //public
        //constructor
            constructor TGraphicPolyline.create(const   lineThicknessIn : integer;
                                                const   lineColourIn    : TColor;
                                                const   lineStyleIn     : TPenStyle;
                                                const   geometryIn      : TGeomPolyLine);
                begin
                    inherited create(   false,
                                        lineThicknessIn,
                                        TColors.Null,
                                        lineColourIn,
                                        lineStyleIn,
                                        geometryIn.getDrawingPoints()   );
                end;

        //destructor
            destructor TGraphicPolyline.destroy();
                begin
                    inherited destroy();
                end;

end.
