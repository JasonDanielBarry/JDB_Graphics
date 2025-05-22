unit GraphicScatterPlotClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, System.UIConsts, System.Classes,
            Winapi.D2D1, Vcl.Direct2D,
            vcl.Graphics,
        //custom
            GraphicDrawingTypes,
            DrawingAxisConversionClass,
            GeometryTypes, GeomBox,
            GraphicEllipseClass,
            GraphicObjectGroupClass;

    type
        TGraphicScatterPlot = class(TGraphicObjectGroup)
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

                            addGraphicObjectToGroup( graphicPlotPoint );
                        end;
                end;

        //destructor
            destructor TGraphicScatterPlot.destroy();
                begin
                    inherited destroy();
                end;

end.
