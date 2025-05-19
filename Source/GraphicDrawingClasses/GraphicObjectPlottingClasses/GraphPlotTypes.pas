unit GraphPlotTypes;

interface

    uses
        System.UITypes,
        Vcl.Graphics,
        GeometryTypes;

    type
        EGraphPlotType = (gpLine = 0, gpScatter = 1, gpFuntion = 2, gpClassFunction = 3);

        TSingleVariableFunction = function(x : double) : double;

        TSingleVariableClassFunction = function(x : double) : double of object;

        TGraphPlotData = record
            var
                plottingSize    : integer;
                plotName        : string;
                graphPlotType   : EGraphPlotType;
                plotColour      : TColor;
                lineStyle       : TPenStyle;
                arrDataPoints   : TArray<TGeomPoint>;
                plotFunction    : TSingleVariableFunction;
        end;

implementation

end.
