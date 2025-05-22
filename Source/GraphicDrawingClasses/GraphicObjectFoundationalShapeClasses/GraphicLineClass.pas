unit GraphicLineClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, System.UIConsts,
            Winapi.D2D1, Vcl.Direct2D,
            vcl.Graphics,
        //custom
            GraphicDrawingTypes,
            GraphicGeometryClass,
            DrawingAxisConversionClass,
            GeometryTypes,
            GeometryBaseClass,
            GeomLineClass
            ;

    type
        TGraphicLine = class(TGraphicGeometry)
            private
                //draw to canvas
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       ); override;
            public
                //constructor
                    constructor create( const   lineThicknessIn : integer;
                                        const   lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle;
                                        const   geometryIn      : TGeomLine ); overload;
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setStartPoint(const xIn, yIn : double);
                    procedure setEndPoint(const xIn, yIn : double);
        end;

implementation

    //private
        //draw to canvas
            procedure TGraphicLine.drawGraphicToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DCanvas       );
                begin
                    if (length( geometryPoints ) < 2) then
                        exit();

                    drawOpenPathGeometry(
                                            geometryPoints,
                                            axisConverterIn,
                                            canvasInOut
                                        );
                end;

    //public
        //constructor
            constructor TGraphicLine.create(const   lineThicknessIn : integer;
                                            const   lineColourIn    : TColor;
                                            const   lineStyleIn     : TPenStyle;
                                            const   geometryIn      : TGeomLine );
                begin
                    inherited create(   false,
                                        lineThicknessIn,
                                        TColors.Null,
                                        lineColourIn,
                                        lineStyleIn,
                                        geometryIn.getArrGeomPoints()   );
                end;

        //destructor
            destructor TGraphicLine.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            procedure TGraphicLine.setStartPoint(const xIn, yIn : double);
                begin
                    geometryPoints[0].setPoint( xIn, yIn );
                end;

            procedure TGraphicLine.setEndPoint(const xIn, yIn : double);
                begin
                    geometryPoints[1].setPoint( xIn, yIn );
                end;

end.
