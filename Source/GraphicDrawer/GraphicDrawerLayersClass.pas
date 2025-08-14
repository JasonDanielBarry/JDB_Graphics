unit GraphicDrawerLayersClass;

interface

    uses
        //Delphi
            system.SysUtils, system.Generics.Collections,
            Vcl.Controls,
        //custom
            GeomBox,
            DrawingAxisConversionClass,
            GenericXYEntityCanvasClass,
            GraphicEntityListBaseClass,
            LayerGraphicEntityMapClass,
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
                                        var canvasInOut                     : TGenericXYEntityCanvas    );
            public
                //constructor
                    constructor create(); override;
                //destructor
                    destructor destroy(); override;
                //add graphic drawing objects to the drawing object container
                    procedure updateGraphicEntitys( const callingControlIn      : TWinControl;
                                                    const GraphicEntityListIn   : TGraphicEntityListBase );
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

                    axisConverter.setGraphicBoundary( activeBoundingBox );
                end;

    //protected
        //drawing procedures
            //draw all geometry
                procedure TGraphicDrawerLayers.drawAll( const canvasWidthIn, canvasHeightIn : integer;
                                                        var canvasInOut                     : TGenericXYEntityCanvas );
                    begin
                        inherited drawAll(  canvasWidthIn, canvasHeightIn,
                                            canvasInOut                     );

                        //draw the grid
                            if ( gridEnabled ) then
                                graphicGrid.drawToCanvas( axisConverter, canvasInOut );

                        //draw graphic objects
                            layerGraphicEntityMap.drawActiveGraphicEntitysToCanvas( axisConverter, canvasInOut );

                        //draw the grid axis labels
                            if ( gridEnabled ) then
                                graphicGrid.drawAxisLabels( axisConverter, canvasInOut );
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
            procedure TGraphicDrawerLayers.updateGraphicEntitys(const callingControlIn      : TWinControl;
                                                                const GraphicEntityListIn   : TGraphicEntityListBase);
                begin
                    //reset the stored graphics
                        layerGraphicEntityMap.clear();

                    //read the graphic entity list
                        layerGraphicEntityMap.readGraphicEntityList( GraphicEntityListIn );

                    //activate all drawing layers
                        activateAllDrawingLayers();

                    //set background to match theme
                        updateBackgroundColour( callingControlIn );
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
