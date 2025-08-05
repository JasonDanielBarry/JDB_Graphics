unit GraphXYTypes;

interface

    uses
        System.UITypes, System.Generics.Collections,
        Vcl.Graphics,
        GeometryTypes;

    type
        EGraphPlotType = (gpLine = 0, gpScatter = 1, gpMarkerLinePlot = 2, gpFuntion = 3, gpClassFunction = 4);

        TSingleVariableFunction = function(x : double) : double;

        TSingleVariableClassFunction = function(x : double) : double of object;

        TGraphLabelData = record
            private
                function writeAxisLabel(const labelIn, unitsIn : string) : string;
            public
                graphTitle,
                xAxisLabel, xAxisUnit,
                yAxisLabel, yAxisUnit : string;
                function writeXAxisLabel() : string;
                function writeYAxisLabel() : string;
        end;

        TGraphPlotData = record
            var
                visible             : boolean;
                plottingSize        : integer;
                plotName            : string;
                graphPlotType       : EGraphPlotType;
                plotColour          : TColor;
                lineStyle           : TPenStyle;
                arrDataPoints       : TArray<TGeomPoint>;
                plotFunction        : TSingleVariableFunction;
                classPlotFunction   : TSingleVariableClassFunction;
            procedure copyOther(const otherGraphPlotIn : TGraphPlotData);
        end;

        TGraphXYMap = class(TOrderedDictionary< string, TGraphPlotData >)
            private
                procedure addPlotToMap(const graphPlotIn : TGraphPlotData);
            public
                //add plots
                    //line plot
                        procedure addLinePlot(  const plotNameIn    : string;
                                                const dataPointsIn  : TArray<TGeomPoint>;
                                                const showPointsIn  : boolean = False;
                                                const lineSizeIn    : integer = 2;
                                                const lineColourIn  : TColor = clWindowText;
                                                const lineStyleIn   : TPenStyle = TPenStyle.psSolid );
                    //scatter plot
                        procedure addScatterPlot(   const plotNameIn    : string;
                                                    const dataPointsIn  : TArray<TGeomPoint>;
                                                    const pointSizeIn   : integer = 5;
                                                    const pointColourIn : TColor = TColors.Royalblue );
        end;

        TUpdateGraphPlotsEvent = procedure(ASender : TObject; var AGraphXYMap : TGraphXYMap) of object;

implementation

    //TGraphLabelData
        //private
            function TGraphLabelData.writeAxisLabel(const labelIn, unitsIn : string) : string;
                var
                    unitsString : string;
                begin
                    if ( unitsIn = '' ) then
                        exit( labelIn );

                    unitsString := '(' + unitsIn + ')';
                    result := labelIn + ' ' + unitsString;
                end;

        //public
            function TGraphLabelData.writeXAxisLabel() : string;
                begin
                    result := writeAxisLabel( xAxisLabel, xAxisUnit );
                end;

            function TGraphLabelData.writeYAxisLabel() : string;
                begin
                    result := writeAxisLabel( yAxisLabel, yAxisUnit );
                end;

    //TGraphPlotData
        procedure TGraphPlotData.copyOther(const otherGraphPlotIn : TGraphPlotData);
            begin
                self.visible            := otherGraphPlotIn.visible;
                self.plottingSize       := otherGraphPlotIn.plottingSize;
                self.plotName           := otherGraphPlotIn.plotName;
                self.graphPlotType      := otherGraphPlotIn.graphPlotType;
                self.plotColour         := otherGraphPlotIn.plotColour;
                self.lineStyle          := otherGraphPlotIn.lineStyle;
                TGeomPoint.copyPoints( otherGraphPlotIn.arrDataPoints, self.arrDataPoints );
                self.plotFunction       := otherGraphPlotIn.plotFunction;
                self.classPlotFunction  := otherGraphPlotIn.classPlotFunction;
            end;

    //TGraphXYMap
        //private
            procedure TGraphXYMap.addPlotToMap(const graphPlotIn : TGraphPlotData);
                var
                    graphPlotCopy : TGraphPlotData;
                begin
                    graphPlotCopy.copyOther( graphPlotIn );

                    graphPlotCopy.visible := True;

                    AddOrSetValue( graphPlotCopy.plotName, graphPlotCopy );
                end;

        //public
            //add plots
                //line plot
                    procedure TGraphXYMap.addLinePlot(  const plotNameIn    : string;
                                                        const dataPointsIn  : TArray<TGeomPoint>;
                                                        const showPointsIn  : boolean = False;
                                                        const lineSizeIn    : integer = 2;
                                                        const lineColourIn  : TColor = clWindowText;
                                                        const lineStyleIn   : TPenStyle = TPenStyle.psSolid );
                        var
                            newGraphPlot : TGraphPlotData;
                        begin
                            newGraphPlot.plottingSize   := lineSizeIn;
                            newGraphPlot.plotName       := plotNameIn;

                            if ( showPointsIn ) then
                                newGraphPlot.graphPlotType  := EGraphPlotType.gpMarkerLinePlot
                            else
                                newGraphPlot.graphPlotType  := EGraphPlotType.gpLine;

                            newGraphPlot.plotColour     := lineColourIn;
                            newGraphPlot.lineStyle      := lineStyleIn;
                            TGeomPoint.copyPoints( dataPointsIn, newGraphPlot.arrDataPoints );

                            addPlotToMap( newGraphPlot );
                        end;

                //scatter plot
                    procedure TGraphXYMap.addScatterPlot(   const plotNameIn    : string;
                                                            const dataPointsIn  : TArray<TGeomPoint>;
                                                            const pointSizeIn   : integer = 5;
                                                            const pointColourIn : TColor = TColors.Royalblue    );
                        var
                            newGraphPlot : TGraphPlotData;
                        begin
                            newGraphPlot.plottingSize   := pointSizeIn;
                            newGraphPlot.plotName       := plotNameIn;
                            newGraphPlot.graphPlotType  := EGraphPlotType.gpScatter;
                            newGraphPlot.plotColour     := pointColourIn;
                            TGeomPoint.copyPoints( dataPointsIn, newGraphPlot.arrDataPoints );

                            addPlotToMap( newGraphPlot );
                        end;

end.
