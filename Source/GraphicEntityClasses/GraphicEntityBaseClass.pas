unit GraphicEntityBaseClass;

interface

    uses
        system.UITypes, system.Math, System.Classes, System.Types,
        vcl.Graphics,
        GeomBox,
        Direct2DXYEntityCanvasClass,
        DrawingAxisConversionClass
        ;

    type
        TGraphicEntity = class
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas       ); virtual; abstract;
                    class procedure drawAllToCanvas(const arrGraphicEntitiesIn  : TArray<TGraphicEntity>;
                                                    const axisConverterIn       : TDrawingAxisConverter;
                                                    var canvasInOut             : TDirect2DXYEntityCanvas); static;
                //bounding box
                    function determineBoundingBox() : TGeomBox; overload; virtual; abstract;
                    class function determineBoundingBox(const arrGraphicEntitiesIn : TArray<TGraphicEntity>) : TGeomBox; overload; static;
        end;

implementation

    //public
        //constructor
            constructor TGraphicEntity.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TGraphicEntity.destroy();
                begin
                    inherited destroy();
                end;

        //draw to canvas
            class procedure TGraphicEntity.drawAllToCanvas( const arrGraphicEntitiesIn   : TArray<TGraphicEntity>;
                                                            const axisConverterIn       : TDrawingAxisConverter;
                                                            var canvasInOut             : TDirect2DXYEntityCanvas   );
                var
                    i, arrLen : integer;
                begin
                    arrLen := length( arrGraphicEntitiesIn );

                    for i := 0 to ( arrLen - 1 ) do
                        arrGraphicEntitiesIn[i].drawToCanvas( axisConverterIn, canvasInOut );
                end;

        //bounding box
            class function TGraphicEntity.determineBoundingBox(const arrGraphicEntitiesIn : TArray<TGraphicEntity>) : TGeomBox;
                var
                    i, graphicObjectsCount  : integer;
                    arrBoundingBoxes        : TArray<TGeomBox>;
                begin
                    graphicObjectsCount := length( arrGraphicEntitiesIn );

                    SetLength( arrBoundingBoxes, graphicObjectsCount );

                    for i := 0 to (graphicObjectsCount - 1) do
                        arrBoundingBoxes[i] := arrGraphicEntitiesIn[i].determineBoundingBox();

                    result := TGeomBox.determineBoundingBox( arrBoundingBoxes );
                end;

end.

