unit GraphicLineClass;

interface

    uses
        //Delphi
            system.SysUtils, system.UITypes, System.Math,
            vcl.Graphics,
        //custom
            DrawingAxisConversionClass,
            GeomLineClass,
            GraphicGeometryClass,
            GenericXYEntityCanvasClass
            ;

    type
        TGraphicLine = class(TGraphicGeometry)
            public
                //constructor
                    constructor create( const   lineThicknessIn : integer;
                                        const   lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle;
                                        const   geometryIn      : TGeomLine );
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setStartPoint(const xIn, yIn : double);
                    procedure setEndPoint(const xIn, yIn : double);
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TGenericXYEntityCanvas ); override;
        end;

implementation

    //public
        //constructor
            constructor TGraphicLine.create(const   lineThicknessIn : integer;
                                            const   lineColourIn    : TColor;
                                            const   lineStyleIn     : TPenStyle;
                                            const   geometryIn      : TGeomLine );
                begin
                    inherited create(   false,
                                        max( lineThicknessIn, 1 ),
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

        //draw to canvas
            procedure TGraphicLine.drawToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TGenericXYEntityCanvas);
                begin
                    inherited drawToCanvas( axisConverterIn, canvasInOut );

                    canvasInOut.drawXYLine( geometryPoints, axisConverterIn );
                end;

end.
