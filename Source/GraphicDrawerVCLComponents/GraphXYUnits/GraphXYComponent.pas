unit GraphXYComponent;

interface

    uses
        System.SysUtils, System.Classes, System.UITypes,
        Vcl.Graphics,
        Vcl.Controls,

        GeometryTypes,
        CustomComponentPanelClass,
        GraphXYTypes,
        GraphXYFrame;

    type
        TJDBGraphXY = class(TCustomComponentPanel)
            private
                var
                    customGraphXY : TCustomGraphXY;
                //accessors
                    function getGraphTitle() : string;
                    function getXAxisLabel() : string;
                    function getXAxisUnits() : string;
                    function getYAxisLabel() : string;
                    function getYAxisUnits() : string;
                //modifiers
                    procedure setGraphTitle(const titleIn : string);
                    procedure setXAxisLabel(const labelIn : string);
                    procedure setXAxisUnits(const unitIn : string);
                    procedure setYAxisLabel(const labelIn : string);
                    procedure setYAxisUnits(const unitIn : string);
            public
                constructor Create(AOwner: TComponent); override;
                destructor Destroy(); override;
                //update plots event
                    function getOnUpdateGraphPlotsEvent() : TUpdateGraphPlotsEvent;
                    procedure setOnUpdateGraphPlotsEvent(const OnUpdateGraphPlotsEventIn : TUpdateGraphPlotsEvent);
                    procedure updateGraphPlots();
                //replot graphs
                    procedure replot();
            published
                property GraphTitle : string read getGraphTitle write setGraphTitle;
                property XAxisLabel : string read getXAxisLabel write setXAxisLabel;
                property XAxisUnits : string read getXAxisUnits write setXAxisUnits;
                property YAxisLabel : string read getYAxisLabel write setYAxisLabel;
                property YAxisUnits : string read getYAxisUnits write setYAxisUnits;
                property OnUpdateGraphPlots : TUpdateGraphPlotsEvent read getOnUpdateGraphPlotsEvent write setOnUpdateGraphPlotsEvent;
        end;

implementation

    //private
        //accessors
            function TJDBGraphXY.getGraphTitle() : string;
                begin
                    result := customGraphXY.getGraphTitle();
                end;

            function TJDBGraphXY.getXAxisLabel() : string;
                begin
                    result := customGraphXY.getXAxisLabel();
                end;

            function TJDBGraphXY.getXAxisUnits() : string;
                begin
                    result := customGraphXY.getXAxisUnits();
                end;

            function TJDBGraphXY.getYAxisLabel() : string;
                begin
                    result := customGraphXY.getYAxisLabel();
                end;

            function TJDBGraphXY.getYAxisUnits() : string;
                begin
                    result := customGraphXY.getYAxisUnits();
                end;

        //modifiers
            procedure TJDBGraphXY.setGraphTitle(const titleIn : string);
                begin
                    customGraphXY.setGraphTitle( titleIn );
                end;

            procedure TJDBGraphXY.setXAxisLabel(const labelIn : string);
                begin
                    customGraphXY.setXAxisLabel( labelIn );
                end;

            procedure TJDBGraphXY.setXAxisUnits(const unitIn : string);
                begin
                    customGraphXY.setXAxisUnits( unitIn );
                end;

            procedure TJDBGraphXY.setYAxisLabel(const labelIn : string);
                begin
                    customGraphXY.setYAxisLabel( labelIn );
                end;

            procedure TJDBGraphXY.setYAxisUnits(const unitIn : string);
                begin
                    customGraphXY.setYAxisUnits( unitIn );
                end;

    //public
        constructor TJDBGraphXY.Create(AOwner: TComponent);
            begin
                inherited create( AOwner );

                customGraphXY := TCustomGraphXY.create(Self);
                customGraphXY.parent    := self;
                customGraphXY.Align     := TAlign.alClient;
                customGraphXY.Visible   := True;
            end;

        destructor TJDBGraphXY.Destroy();
            begin
                FreeAndNil( customGraphXY );

                inherited Destroy();
            end;

        //update plots event
            function TJDBGraphXY.getOnUpdateGraphPlotsEvent() : TUpdateGraphPlotsEvent;
                begin
                    result := customGraphXY.getOnUpdateGraphPlotsEvent();
                end;

            procedure TJDBGraphXY.setOnUpdateGraphPlotsEvent(const OnUpdateGraphPlotsEventIn : TUpdateGraphPlotsEvent);
                begin
                    customGraphXY.setOnUpdateGraphPlotsEvent( OnUpdateGraphPlotsEventIn );
                end;

            procedure TJDBGraphXY.updateGraphPlots();
                begin
                    customGraphXY.updateGraphPlots();
                end;

        //replot graphs
            procedure TJDBGraphXY.replot();
                begin
                    customGraphXY.replot();
                end;

end.
