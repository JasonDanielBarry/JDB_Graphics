unit GraphPlotsListClass;

interface

    uses
        System.SysUtils,
        GraphicLinePlotClass,
        GraphicScatterPlotClass,
        GraphicMousePointTrackerClass,
        GraphXYTypes,
        GraphicEntityListBaseClass;

    type
        TGraphPlotsList = class(TGraphicEntityListBase)
            private
                procedure addLinePlot(const graphPlotIn : TGraphPlotData);
                procedure addScatterPlot(const graphPlotIn : TGraphPlotData);
                procedure addMarkedLinePlot(const graphPlotIn : TGraphPlotData);
                procedure addFunction(const graphPlotIn : TGraphPlotData);
                procedure addClassFunction(const graphPlotIn : TGraphPlotData);
            public
                procedure addGraphPlot(const graphPlotIn : TGraphPlotData);
                procedure addMousePointTracker(const mousePointTrackerIn : TGraphicMousePointTracker);
        end;

implementation

    //private
        procedure TGraphPlotsList.addLinePlot(const graphPlotIn : TGraphPlotData);
            var
                graphicLinePlot : TGraphicLinePlot;
            begin
                graphicLinePlot := TGraphicLinePlot.create( False,
                                                            graphPlotIn.plottingSize,
                                                            graphPlotIn.plotColour,
                                                            graphPlotIn.lineStyle,
                                                            graphPlotIn.arrDataPoints   );

                addGraphicEntity( graphicLinePlot );
            end;

        procedure TGraphPlotsList.addScatterPlot(const graphPlotIn : TGraphPlotData);
            var
                graphicScatterPlot : TGraphicScatterPlot;
            begin
                graphicScatterPlot := TGraphicScatterPlot.create(   graphPlotIn.plottingSize,
                                                                    graphPlotIn.plotColour,
                                                                    graphPlotIn.arrDataPoints   );

                addGraphicEntity( graphicScatterPlot );
            end;

        procedure TGraphPlotsList.addMarkedLinePlot(const graphPlotIn : TGraphPlotData);
            var
                graphicMarkedLinePlot : TGraphicLinePlot;
            begin
                graphicMarkedLinePlot := TGraphicLinePlot.create(   True,
                                                                    graphPlotIn.plottingSize,
                                                                    graphPlotIn.plotColour,
                                                                    graphPlotIn.lineStyle,
                                                                    graphPlotIn.arrDataPoints   );

                addGraphicEntity( graphicMarkedLinePlot );
            end;

        procedure TGraphPlotsList.addFunction(const graphPlotIn : TGraphPlotData);
            begin

            end;

        procedure TGraphPlotsList.addClassFunction(const graphPlotIn : TGraphPlotData);
            begin

            end;

    //public
        procedure TGraphPlotsList.addGraphPlot(const graphPlotIn : TGraphPlotData);
            begin
                if NOT( graphPlotIn.visible ) then
                    exit();

                case ( graphPlotIn.graphPlotType ) of
                    EGraphPlotType.gpLine:
                        addLinePlot( graphPlotIn );

                    EGraphPlotType.gpScatter:
                        addScatterPlot( graphPlotIn );

                    EGraphPlotType.gpMarkerLinePlot:
                        addMarkedLinePlot( graphPlotIn );

                    EGraphPlotType.gpFuntion:
                        addFunction( graphPlotIn );

                    EGraphPlotType.gpClassFunction:
                        addClassFunction( graphPlotIn );
                end;
            end;

        procedure TGraphPlotsList.addMousePointTracker(const mousePointTrackerIn : TGraphicMousePointTracker);
            begin
                addGraphicEntity( mousePointTrackerIn );
            end;


end.
