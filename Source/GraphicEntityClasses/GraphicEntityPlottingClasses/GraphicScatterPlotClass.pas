unit GraphicScatterPlotClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types,
            vcl.Graphics,
        //custom
            DrawingAxisConversionClass,
            Direct2DXYEntityCanvasClass,
            GeometryTypes, GeomBox,
            GraphicEllipseClass,
            GraphicEntityGroupClass;

    type
        TGraphicScatterPlot = class(TGraphicEntityGroup)
            public
                //constructor
                    constructor create( const   pointSizeIn     : integer;
                                        const   pointColourIn   : TColor;
                                        const   arrPlotPointsIn : TArray<TGeomPoint> );
                //destructor
                    destructor destroy(); override;
        end;


implementation

    //public
        //constructor
            constructor TGraphicScatterPlot.create( const   pointSizeIn     : integer;
                                                    const   pointColourIn   : TColor;
                                                    const   arrPlotPointsIn : TArray<TGeomPoint> );
                var
                    i, arrLen           : integer;
                    graphicPlotPoint    : TGraphicEllipse;
                begin
                    inherited create();

                    arrLen := length( arrPlotPointsIn );

                    for i := 0 to (arrLen - 1) do
                        begin
                            graphicPlotPoint := TGraphicEllipse.create(
                                                                            True,
                                                                            1,
                                                                            pointSizeIn,
                                                                            pointSizeIn,
                                                                            0,
                                                                            EScaleType.scCanvas,
                                                                            THorzRectAlign.Center,
                                                                            TVertRectAlign.Center,
                                                                            pointColourIn,
                                                                            clWindowText,
                                                                            TPenStyle.psSolid,
                                                                            arrPlotPointsIn[i]
                                                                      );

                            addGraphicEntityToGroup( graphicPlotPoint );
                        end;
                end;

        //destructor
            destructor TGraphicScatterPlot.destroy();
                begin
                    inherited destroy();
                end;

end.
