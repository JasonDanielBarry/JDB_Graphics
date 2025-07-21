unit GraphicGeometryClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, System.UIConsts, system.Classes,
            vcl.Graphics,
        //custom
            DrawingAxisConversionClass,
            GeometryTypes,
            GeomBox,
            GraphicDrawingTypes,
            GeometryBaseClass,
            Direct2DXYEntityCanvasClass,
            GraphicEntityFoundationalClass
            ;

    type
        TGraphicGeometry = class(TFoundationalGraphicEntity)
            protected
                var
                    geometryPoints : TArray<TGeomPoint>;
            public
                //constructor
                    constructor create( const   filledIn            : boolean;
                                        const   lineThicknessIn     : integer;
                                        const   fillColourIn,
                                                lineColourIn        : TColor;
                                        const   lineStyleIn         : TPenStyle;
                                        const   geometryPointsIn    : TArray<TGeomPoint> );
                //destructor
                    destructor destroy(); override;
                //bounding box
                    function determineBoundingBox() : TGeomBox; override;
        end;

implementation

    //public
        //constructor
            constructor TGraphicGeometry.create(const   filledIn            : boolean;
                                                const   lineThicknessIn     : integer;
                                                const   fillColourIn,
                                                        lineColourIn        : TColor;
                                                const   lineStyleIn         : TPenStyle;
                                                const   geometryPointsIn    : TArray<TGeomPoint>);
                begin
                    inherited create(   filledIn,
                                        lineThicknessIn,
                                        fillColourIn,
                                        lineColourIn,
                                        lineStyleIn     );

                    TGeomPoint.copyPoints( geometryPointsIn, geometryPoints );
                end;

        //destructor
            destructor TGraphicGeometry.destroy();
                begin
                    inherited destroy();
                end;

        //bounding box
            function TGraphicGeometry.determineBoundingBox() : TGeomBox;
                begin
                    result := TGeomBox.determineBoundingBox( geometryPoints );
                end;

end.
