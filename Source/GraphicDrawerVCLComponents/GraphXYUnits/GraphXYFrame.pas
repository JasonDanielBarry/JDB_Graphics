unit GraphXYFrame;

interface

uses
    Winapi.Windows, Winapi.Messages,
    System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, System.UITypes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,

    GeometryTypes,
    GeomBox,
    GeomPolyLineClass,
    Direct2DXYEntityCanvasClass,
    GraphicGridSettingsRecord,
    GraphicScatterPlotClass,
    GraphicPolylineClass,
    GraphicMousePointTrackerClass,
    GraphicGridClass,
    GraphPlotsListClass,
    GraphicDrawer2DPaintBoxClass,
    GraphXYTypes
    ;

    type
        TCustomGraphXY = class(TFrame)
            PBGraphXY: TPaintBox;
            LabelTitle: TLabel;
            LabelYAxis: TLabel;
            LabelXAxis: TLabel;
            PageControlSettings: TPageControl;
            TabSheetGraph: TTabSheet;
            TabSheetGrid: TTabSheet;
            ComboBoxPlotNames: TComboBox;
            CheckBoxShowSelectedPlot: TCheckBox;
            GroupBoxGridElementVisibility: TGroupBox;
            GridPanelGridElementVisibility: TGridPanel;
            LabelAxesVisibility: TLabel;
            CheckBoxXAxis: TCheckBox;
            CheckBoxYAxis: TCheckBox;
            LabelAxisValuesVisibility: TLabel;
            CheckBoxXAxisValues: TCheckBox;
            CheckBoxYAxisValues: TCheckBox;
            LabelGridLineVisibility: TLabel;
            CheckBoxMajorLines: TCheckBox;
            CheckBoxMinorLines: TCheckBox;
            ButtonShowSettings: TButton;
            //events
                procedure FrameResize(Sender: TObject);
                procedure ComboBoxPlotNamesChange(Sender: TObject);
                procedure CheckBoxShowSelectedPlotClick(Sender: TObject);
                procedure CheckBoxGridVisibilityClick(Sender: TObject);
                procedure ButtonShowSettingsClick(Sender: TObject);
            private
                var
                    mouseTrackingActive     : boolean;
                    graphLabels             : TGraphLabelData;
                    selectedGraphPlot       : TGraphPlotData;
                    graphPlotsMap           : TGraphXYMap;
                    onUpdateGraphPlotsEvent : TUpdateGraphPlotsEvent;
                //set grid elements visibility to drawer
                    procedure collectGridSettings();
                //write axis labels
                    procedure writeXAxisLabel();
                    procedure writeYAxisLabel();
                //set graph boundaries
                    procedure setGraphBoundaries(const xMinIn, xMaxIn, yMinIn, yMaxIn : double);
                //send graph plots to drawer
                    procedure sendGraphPlotsToDrawer();
                //post draw event
                    procedure postDrawGraphEvent(   const canvasWidthIn, canvasHeightIn : integer;
                                                    const D2DCanvasIn                   : TDirect2DXYEntityCanvas   );
            protected
                //process windows messages
                    procedure wndProc(var messageInOut : TMessage); override;
            public
                //constructor
                    constructor create(AOwner : TComponent); override;
                //destructor
                    destructor destroy(); override;
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
                //update plots event
                    function getOnUpdateGraphPlotsEvent() : TUpdateGraphPlotsEvent;
                    procedure setOnUpdateGraphPlotsEvent(const OnUpdateGraphPlotsEventIn : TUpdateGraphPlotsEvent);
                    procedure updateGraphPlots();
                //replot graphs
                    procedure replot();
        end;

implementation

{$R *.dfm}

    //events
        procedure TCustomGraphXY.FrameResize(Sender: TObject);
            begin
                replot();
            end;

        procedure TCustomGraphXY.ButtonShowSettingsClick(Sender: TObject);
            begin
                PageControlSettings.Visible := NOT( PageControlSettings.Visible );

                replot();

                self.Refresh();
            end;

        procedure TCustomGraphXY.CheckBoxGridVisibilityClick(Sender: TObject);
            begin
                collectGridSettings();
            end;

        procedure TCustomGraphXY.ComboBoxPlotNamesChange(Sender: TObject);
            var
                selectedPlotName    : string;
                localSelectedPlot   : TGraphPlotData;
            begin
                selectedPlotName := ComboBoxPlotNames.Text;

                if NOT( graphPlotsMap.TryGetValue( selectedPlotName, localSelectedPlot ) ) then
                    begin
                        mouseTrackingActive := False;
                        sendGraphPlotsToDrawer();
                        exit();
                    end;

                mouseTrackingActive := True;

                selectedGraphPlot.copyOther( localSelectedPlot );

                CheckBoxShowSelectedPlot.Checked := selectedGraphPlot.visible;

                sendGraphPlotsToDrawer();
            end;

        procedure TCustomGraphXY.CheckBoxShowSelectedPlotClick(Sender: TObject);
            var
                mapGraphPlot : TGraphPlotData;
            begin
                selectedGraphPlot.visible := CheckBoxShowSelectedPlot.Checked;

                if NOT( graphPlotsMap.TryGetValue( selectedGraphPlot.plotName, mapGraphPlot ) ) then
                    exit();

                mapGraphPlot.copyOther( selectedGraphPlot );

                graphPlotsMap.AddOrSetValue( mapGraphPlot.plotName, mapGraphPlot );

                sendGraphPlotsToDrawer();
            end;

    //private
        //set grid elements visibility to drawer
            procedure TCustomGraphXY.collectGridSettings();
                var
                    gridSettings : TGraphicGridSettings;
                begin
                    gridSettings.setValues(
                                                CheckBoxXAxisValues.Checked,
                                                CheckBoxYAxisValues.Checked,
                                                CheckBoxXAxis.Checked,
                                                CheckBoxYAxis.Checked,
                                                CheckBoxMajorLines.Checked,
                                                CheckBoxMinorLines.Checked
                                          );

                    PBGraphXY.GraphicDrawer.setGridSettings( gridSettings );

                    replot();
                end;

        //write axis labels
            procedure TCustomGraphXY.writeXAxisLabel();
                begin
                    LabelXAxis.Caption := graphLabels.writeXAxisLabel();
                end;

            procedure TCustomGraphXY.writeYAxisLabel();
                begin
                    LabelYAxis.Caption := graphLabels.writeYAxisLabel();
                end;

        //set graph boundaries
            procedure TCustomGraphXY.setGraphBoundaries(const xMinIn, xMaxIn, yMinIn, yMaxIn : double);
                var
                    newRegion : TGeomBox;
                begin
                    newRegion.setBounds( xMinIn, xMaxIn, yMinIn, yMaxIn, 0, 0 );

                    PBGraphXY.GraphicDrawer.setDrawingRegion(0, newRegion );

                    replot();
                end;

        //send graph plots to drawer
            procedure TCustomGraphXY.sendGraphPlotsToDrawer();
                var
                    continuousTracking  : boolean;
                    tempGraphPlotItem   : TPair<string, TGraphPlotData>;
                    mousePointTracker   : TGraphicMousePointTracker;
                    graphPlotsList      : TGraphPlotsList;
                begin
                    //create graphic object list
                        graphPlotsList := TGraphPlotsList.create();

                        //collect graph plots
                            for tempGraphPlotItem in graphPlotsMap do
                                graphPlotsList.addGraphPlot( tempGraphPlotItem.Value );

                        //collect mouse point tracker
                            if ( mouseTrackingActive AND selectedGraphPlot.visible AND ( 2 < length( selectedGraphPlot.arrDataPoints ) ) ) then
                                begin
                                    continuousTracking := ( selectedGraphPlot.graphPlotType <> EGraphPlotType.gpScatter );

                                    mousePointTracker := TGraphicMousePointTracker.create( continuousTracking, selectedGraphPlot.arrDataPoints );

                                    graphPlotsList.addMousePointTracker( mousePointTracker );

                                    PBGraphXY.GraphicDrawer.setRedrawOnMouseMoveActive( True );
                                end;

                    //update the graphic drawers graphicsS
                        PBGraphXY.GraphicDrawer.updateGraphicEntitys( self, graphPlotsList );

                    //free graphic object list memory
                        FreeAndNil( graphPlotsList );

                    //grid settings
                        collectGridSettings();

                    replot();
                end;

        //post draw event
            procedure TCustomGraphXY.postDrawGraphEvent(const canvasWidthIn, canvasHeightIn : integer;
                                                        const D2DCanvasIn                   : TDirect2DXYEntityCanvas);
                begin

                end;

    //protected
        //process windows messages
            procedure TCustomGraphXY.wndProc(var messageInOut : TMessage);
                var
                    graphWasRedrawn : boolean;
                begin
                    if ( Assigned( PBGraphXY ) ) then
                        begin
                            //drawing messages
                                PBGraphXY.processWindowsMessages( messageInOut, graphWasRedrawn );

                            //more messages
                                //
                        end;

                    inherited wndProc( messageInOut );
                end;

    //public
        //constructor
            constructor TCustomGraphXY.create(AOwner : TComponent);
                begin
                    inherited Create( AOwner );

                    ButtonShowSettings.top := 0;
                    ButtonShowSettings.left := self.Width - ButtonShowSettings.Width;

                    graphPlotsMap := TGraphXYMap.Create();

                    PBGraphXY.GraphicDrawer.setGridEnabled( True );
                    PBGraphXY.GraphicDrawer.setDrawingSpaceRatioEnabled( False );
                    PBGraphXY.GraphicDrawer.setGraphicBorderPercentage( 0 );

                    PageControlSettings.ActivePageIndex := 0;

                    collectGridSettings();
                end;

        //destructor
            destructor TCustomGraphXY.destroy();
                begin
                    graphPlotsMap.clear();
                    FreeAndNil( graphPlotsMap );

                    inherited destroy();
                end;

        //accessors
            function TCustomGraphXY.getGraphTitle() : string;
                begin
                    result := graphLabels.graphTitle;
                end;

            function TCustomGraphXY.getXAxisLabel() : string;
                begin
                    result := graphLabels.xAxisLabel;
                end;

            function TCustomGraphXY.getXAxisUnits() : string;
                begin
                    result := graphLabels.xAxisUnit;
                end;

            function TCustomGraphXY.getYAxisLabel() : string;
                begin
                    result := graphLabels.yAxisLabel;
                end;

            function TCustomGraphXY.getYAxisUnits() : string;
                begin
                    result := graphLabels.yAxisUnit;
                end;

        //modifiers
            procedure TCustomGraphXY.setGraphTitle(const titleIn : string);
                begin
                    graphLabels.graphTitle := titleIn;

                    LabelTitle.Caption := graphLabels.graphTitle;
                end;

            procedure TCustomGraphXY.setXAxisLabel(const labelIn : string);
                begin
                    graphLabels.xAxisLabel := labelIn;

                    writeXAxisLabel();
                end;

            procedure TCustomGraphXY.setXAxisUnits(const unitIn : string);
                begin
                    graphLabels.xAxisUnit := unitIn;

                    writeXAxisLabel();
                end;

            procedure TCustomGraphXY.setYAxisLabel(const labelIn : string);
                begin
                    graphLabels.yAxisLabel := labelIn;

                    writeYAxisLabel();
                end;

            procedure TCustomGraphXY.setYAxisUnits(const unitIn : string);
                begin
                    graphLabels.yAxisUnit := unitIn;

                    writeYAxisLabel();
                end;

        //update plots event
            function TCustomGraphXY.getOnUpdateGraphPlotsEvent() : TUpdateGraphPlotsEvent;
                begin
                    result := onUpdateGraphPlotsEvent;
                end;

            procedure TCustomGraphXY.setOnUpdateGraphPlotsEvent(const OnUpdateGraphPlotsEventIn : TUpdateGraphPlotsEvent);
                begin
                    onUpdateGraphPlotsEvent := OnUpdateGraphPlotsEventIn;
                end;

            procedure TCustomGraphXY.updateGraphPlots();
                var
                    plotName : string;
                begin
                    //clear map
                        graphPlotsMap.Clear();

                    //update the plots
                        if NOT( Assigned( onUpdateGraphPlotsEvent ) ) then
                            exit();

                        onUpdateGraphPlotsEvent( self, graphPlotsMap );

                    //populate the combo box with the plot names
                        ComboBoxPlotNames.Clear();

                        ComboBoxPlotNames.Items.Add( '<none>' );

                        for plotName in graphPlotsMap.Keys do
                            ComboBoxPlotNames.Items.Add( plotName );

                        ComboBoxPlotNames.ItemIndex := 0;

                    //send plots to drawer
                        sendGraphPlotsToDrawer();
                end;

        //replot graphs
            procedure TCustomGraphXY.replot();
                begin
                    PBGraphXY.GraphicDrawer.postRedrawGraphicMessage( self );
                end;

end.
