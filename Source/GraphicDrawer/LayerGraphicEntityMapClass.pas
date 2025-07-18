unit LayerGraphicEntityMapClass;

interface

    uses
        //Delphi
            Winapi.D2D1, Vcl.Direct2D,
            system.SysUtils, system.Generics.Collections,
        //custom
            DrawingAxisConversionClass,
            GraphicEntityBaseClass, GraphicEntityGroupClass,
            GeomBox,
            GraphicEntityListBaseClass
            ;

    type
        TLayerGraphicEntityMap = class(TOrderedDictionary< string, TArray< TGraphicEntity > >)
            private
                var
                    activeGraphicEntities : TGraphicEntityGroup;
                //add graphic drawing object
                    procedure addGraphicEntity( const layerIn           : string;
                                                const GraphicEntityIn   : TGraphicEntity );
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //clear graphic objects
                    procedure clear();
                //read in a graphic object list
                    procedure readGraphicEntityList(const GraphicEntityListIn : TGraphicEntityListBase);
                //set active drawing layers
                    procedure setActiveDrawingLayers(const arrDrawingLayersToActiveIn : TArray<string>);
                    procedure activateAllDrawingLayers();
                //active drawing layers bounding box
                    function determineActiveBoundingBox() : TGeomBox;
                //draw active graphic objects
                    procedure drawActiveGraphicEntitysToCanvas( const axisConverter : TDrawingAxisConverter;
                                                                var D2DCanvasInOut : TDirect2DCanvas        );
        end;

implementation

    //public
        //constructor
            constructor TLayerGraphicEntityMap.create();
                begin
                    inherited Create();

                    activeGraphicEntities := TGraphicEntityGroup.create();
                end;

        //destructor
            destructor TLayerGraphicEntityMap.destroy();
                begin
                    clear();
                    FreeAndNil( activeGraphicEntities );

                    inherited destroy();
                end;

        //clear graphic objects
            procedure TLayerGraphicEntityMap.clear();
                begin
                    activateAllDrawingLayers();

                    activeGraphicEntities.clearGraphicEntitysGroup( True );

                    inherited clear();
                end;

        //add graphic drawing object
            procedure TLayerGraphicEntityMap.addGraphicEntity(  const layerIn           : string;
                                                                const GraphicEntityIn   : TGraphicEntity    );
                var
                    GraphicEntityCount  : integer;
                    arrGraphicEntitys   : TArray<TGraphicEntity>;
                begin
                    //get the drawing geometry array and add the new drawing geometry to it
                        TryGetValue( layerIn, arrGraphicEntitys );

                        GraphicEntityCount := length( arrGraphicEntitys );

                        SetLength( arrGraphicEntitys, GraphicEntityCount + 1 );

                        arrGraphicEntitys[ GraphicEntityCount ] := GraphicEntityIn;

                    //add the array back to the map
                        AddOrSetValue( layerIn, arrGraphicEntitys );
                end;

        //read in a graphic object list
            procedure TLayerGraphicEntityMap.readGraphicEntityList(const GraphicEntityListIn : TGraphicEntityListBase);
                var
                    layerGraphicEntityItem : TPair<string, TGraphicEntity>;
                begin
                    for layerGraphicEntityItem in GraphicEntityListIn do
                        addGraphicEntity(
                                            layerGraphicEntityItem.Key,
                                            layerGraphicEntityItem.Value
                                        );
                end;

        //set active drawing layers
            procedure TLayerGraphicEntityMap.setActiveDrawingLayers(const arrDrawingLayersToActiveIn : TArray<string>);
                var
                    i, arrLen           : integer;
                    layer               : string;
                    arrGraphicEntitys   : TArray<TGraphicEntity>;
                begin
                    //clear active graphic objects
                        activeGraphicEntities.clearGraphicEntitysGroup( False );

                    arrLen := length( arrDrawingLayersToActiveIn );

                    for i := 0 to (arrLen - 1) do
                        begin
                            layer := arrDrawingLayersToActiveIn[i];

                            //check if layer is valid
                                if NOT( ContainsKey( layer ) ) then
                                    Continue;

                            //try get the layer's graphic objects
                                if NOT( TryGetValue( layer, arrGraphicEntitys ) ) then
                                    Continue;

                            activeGraphicEntities.addGraphicEntitysToGroup( arrGraphicEntitys );
                        end;
                end;

            procedure TLayerGraphicEntityMap.activateAllDrawingLayers();
                var
                    allDrawingLayers : TArray<string>;
                begin
                    allDrawingLayers := Keys.ToArray();

                    setActiveDrawingLayers( allDrawingLayers );
                end;

        //active drawing layers bounding box
            function TLayerGraphicEntityMap.determineActiveBoundingBox() : TGeomBox;
                begin
                    result := activeGraphicEntities.determineBoundingBox();
                end;

        //draw active graphic objects
            procedure TLayerGraphicEntityMap.drawActiveGraphicEntitysToCanvas(  const axisConverter : TDrawingAxisConverter;
                                                                                var D2DCanvasInOut : TDirect2DCanvas        );
                begin
                    activeGraphicEntities.drawToCanvas( axisConverter, D2DCanvasInOut );
                end;

end.
