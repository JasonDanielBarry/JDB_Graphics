unit GraphicDrawerLayersClass;

interface

    uses
        //Delphi
            system.SysUtils, system.UITypes, system.Generics.Collections,
        //custom
            GeomBox,
            Direct2DXYEntityCanvasClass,
            GraphicEntityListBaseClass,
            LayerGraphicEntityMapClass,
            DrawingAxisConversionClass,
            GraphicGridClass,
            GraphicDrawerBaseClass,
            GraphicGridSettingsRecord
            ;

    type
        TGraphicDrawerLayers = class(TGraphicDrawerBase)
            private
                var
                    gridEnabled             : boolean;
                    graphicGrid             : TGraphicGrid;
                    layerGraphicEntityMap   : TLayerGraphicEntityMap;
                //bounding box
                    procedure determineActiveBoundingBox();
            protected
                //draw all geometry
                    procedure drawAll(  const canvasWidthIn, canvasHeightIn : integer;
                                        var D2DCanvasInOut                  : TDirect2DXYEntityCanvas);
            public
                //constructor
                    constructor create(); override;
                //destructor
                    destructor destroy(); override;
                //add graphic drawing objects to the drawing object container
                    procedure updateGraphicEntitys(const GraphicEntityListIn : TGraphicEntityListBase);
                //accessors
                    function getAllDrawingLayers() : TArray<string>;
                //modifiers
                    procedure setGridEnabled(const enabledIn : boolean);
                    procedure setGridSettings(const gridSettingsIn : TGraphicGridSettings);
                    procedure setActiveDrawingLayers(const arrActiveDrawingLayersIn : TArray<string>);
                    procedure activateAllDrawingLayers();
        end;

implementation

    //private
        //bounding box
            procedure TGraphicDrawerLayers.determineActiveBoundingBox();
                var
                    activeBoundingBox : TGeomBox;
                begin
                    activeBoundingBox := layerGraphicEntityMap.determineActiveBoundingBox();

                    axisConverter.setGeometryBoundary( activeBoundingBox );
                end;

    //protected
        //drawing procedures
            //draw all geometry
                procedure TGraphicDrawerLayers.drawAll( const canvasWidthIn, canvasHeightIn : integer;
                                                        var D2DCanvasInOut                  : TDirect2DXYEntityCanvas);
                    begin
                        inherited drawAll(  canvasWidthIn, canvasHeightIn,
                                            D2DCanvasInOut                  );

                        //draw the grid
                            if ( gridEnabled ) then
                                graphicGrid.drawToCanvas( axisConverter, D2DCanvasInOut );

                        //draw graphic objects
                            layerGraphicEntityMap.drawActiveGraphicEntitysToCanvas( axisConverter, D2DCanvasInOut );

                        //draw the grid axis labels
                            if ( gridEnabled ) then
                                graphicGrid.drawAxisLabels( axisConverter, D2DCanvasInOut );
                    end;

    //public
        //constructor
            constructor TGraphicDrawerLayers.create();
                begin
                    inherited create();

                    graphicGrid             := TGraphicGrid.create();
                    layerGraphicEntityMap   := TLayerGraphicEntityMap.Create();
                end;

        //destructor
            destructor TGraphicDrawerLayers.destroy();
                begin
                    layerGraphicEntityMap.clear();

                    FreeAndNil( graphicGrid );
                    FreeAndNil( layerGraphicEntityMap );

                    inherited destroy();
                end;

        //add graphic objects to the map
            procedure TGraphicDrawerLayers.updateGraphicEntitys(const GraphicEntityListIn : TGraphicEntityListBase);
                begin
                    //set background to match theme
                        updateBackgroundColour();

                    //reset the stored graphics
                        layerGraphicEntityMap.clear();

                    //read the graphic entity list
                        layerGraphicEntityMap.readGraphicEntityList( GraphicEntityListIn );

                    //activate all drawing layers
                        activateAllDrawingLayers();
                end;

        //accessors
            function TGraphicDrawerLayers.getAllDrawingLayers() : TArray<string>;
                begin
                    result := layerGraphicEntityMap.Keys.ToArray();
                end;

        //modifiers
            procedure TGraphicDrawerLayers.setGridEnabled(const enabledIn : boolean);
                begin
                    gridEnabled := enabledIn;
                end;

            procedure TGraphicDrawerLayers.setGridSettings(const gridSettingsIn : TGraphicGridSettings);
                begin
                    graphicGrid.setGridSettings( gridSettingsIn );
                end;

            procedure TGraphicDrawerLayers.setActiveDrawingLayers(const arrActiveDrawingLayersIn : TArray<string>);
                begin
                    layerGraphicEntityMap.setActiveDrawingLayers( arrActiveDrawingLayersIn );

                    determineActiveBoundingBox();
                end;

            procedure TGraphicDrawerLayers.activateAllDrawingLayers();
                begin
                    layerGraphicEntityMap.activateAllDrawingLayers();

                    determineActiveBoundingBox();
                end;

end.
