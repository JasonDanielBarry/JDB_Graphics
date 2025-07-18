unit GraphicLinePlotClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, System.UIConsts, System.Classes, System.Math,
            Winapi.D2D1, Vcl.Direct2D,
            vcl.Graphics,
        //custom
            GraphicDrawingTypes,
            DrawingAxisConversionClass,
            GeometryTypes, GeomPolyLineClass,
            GraphicEntityGroupClass,
            GraphicPolylineClass, GraphicScatterPlotClass
            ;

    type
        TGraphicLinePlot = class(TGraphicEntityGroup)
            public
                //constructor
                    constructor create( const   showPlotPointsIn    : boolean;
                                        const   plotLineThicknessIn : integer;
                                        const   plotColourIn        : TColor;
                                        const   plotLineStyleIn     : TPenStyle;
                                        const   arrPlotPointsIn     : TArray<TGeomPoint> );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //public
        //constructor
            constructor TGraphicLinePlot.create(const   showPlotPointsIn    : boolean;
                                                const   plotLineThicknessIn : integer;
                                                const   plotColourIn        : TColor;
                                                const   plotLineStyleIn     : TPenStyle;
                                                const   arrPlotPointsIn     : TArray<TGeomPoint>);
                var
                    tempPolyline    : TGeomPolyLine;
                    linePlot        : TGraphicPolyline;
                    pointPlot       : TGraphicScatterPlot;
                begin
                    inherited create();

                    //create line plot
                        tempPolyline := TGeomPolyLine.create( arrPlotPointsIn );

                        linePlot := TGraphicPolyline.create( plotLineThicknessIn, plotColourIn, plotLineStyleIn, tempPolyline );

                        FreeAndNil( tempPolyline );

                        addGraphicEntityToGroup( linePlot );

                        if NOT( showPlotPointsIn ) then
                            exit();

                    //create point plot
                        var pointSize : integer := max( 5, round(2.5 * plotLineThicknessIn) );

                        pointPlot := TGraphicScatterPlot.create(  pointSize, plotColourIn, arrPlotPointsIn );

                        addGraphicEntityToGroup( pointPlot );
                end;

        //destructor
            destructor TGraphicLinePlot.destroy();
                begin
                    inherited destroy();
                end;



end.
