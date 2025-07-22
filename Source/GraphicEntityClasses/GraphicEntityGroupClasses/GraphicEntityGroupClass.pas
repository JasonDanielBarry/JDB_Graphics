unit GraphicEntityGroupClass;

interface

    uses
        system.SysUtils,
        GeomBox,
        DrawingAxisConversionClass,
        Direct2DXYEntityCanvasClass,
        GraphicEntityBaseClass
        ;

    type
        TGraphicEntityGroup = class(TGraphicEntity)
            private
                arrGraphicEntitysGroup : TArray<TGraphicEntity>;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //add graphic object to array
                    procedure addGraphicEntityToGroup(const GraphicEntityIn : TGraphicEntity);
                    procedure addArrGraphicEntitysToGroup(const arrGraphicEntitysIn : TArray<TGraphicEntity>);
                //clear the array
                    procedure clearGraphicEntityGroup(const freeGraphicEntitysIn : boolean = True);
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas ); override;
                //bounding box
                    function determineBoundingBox() : TGeomBox; override;
        end;

implementation

    //protected


    //public
        //constructor
            constructor TGraphicEntityGroup.create();
                begin
                    inherited create();

                    clearGraphicEntityGroup( False );
                end;

        //destructor
            destructor TGraphicEntityGroup.destroy();
                begin
                    clearGraphicEntityGroup( True );

                    inherited destroy();
                end;

        //add graphic object to array
            procedure TGraphicEntityGroup.addGraphicEntityToGroup(const GraphicEntityIn : TGraphicEntity);
                var
                    arrLen : integer;
                begin
                    arrLen := length( arrGraphicEntitysGroup );

                    SetLength( arrGraphicEntitysGroup, arrLen + 1 );

                    arrGraphicEntitysGroup[ arrLen ] := GraphicEntityIn;
                end;

            procedure TGraphicEntityGroup.addArrGraphicEntitysToGroup(const arrGraphicEntitysIn : TArray<TGraphicEntity>);
                var
                    i : integer;
                begin
                    for i := 0 to ( length( arrGraphicEntitysIn ) - 1 ) do
                        addGraphicEntityToGroup( arrGraphicEntitysIn[i] );
                end;

        //clear the array
            procedure TGraphicEntityGroup.clearGraphicEntityGroup(const freeGraphicEntitysIn : boolean = True);
                var
                    i, arrLen : integer;
                begin
                    if NOT( freeGraphicEntitysIn ) then
                        begin
                            SetLength( arrGraphicEntitysGroup, 0 );
                            exit();
                        end;

                    arrLen := length( arrGraphicEntitysGroup );

                    for i := 0 to ( arrLen - 1 ) do
                        FreeAndNil( arrGraphicEntitysGroup[i] );

                    SetLength( arrGraphicEntitysGroup, 0 );
                end;

        //draw to canvas
            procedure TGraphicEntityGroup.drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DXYEntityCanvas );
                begin
                    TGraphicEntity.drawAllToCanvas(
                                                        arrGraphicEntitysGroup,
                                                        axisConverterIn,
                                                        canvasInOut
                                                  );
                end;

        //bounding box
            function TGraphicEntityGroup.determineBoundingBox() : TGeomBox;
                begin
                    result := TGraphicEntity.determineBoundingBox( arrGraphicEntitysGroup );
                end;


end.
