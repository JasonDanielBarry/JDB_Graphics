unit GraphicEntityFoundationalClass;

interface

    uses
        system.UITypes, system.Math, System.Classes, System.Types,
        vcl.Graphics, vcl.Themes,
        DrawingAxisConversionClass,
        GenericXYEntityCanvasClass,
        GraphicEntityBaseClass
        ;

    type
        TFoundationalGraphicEntity = class( TGraphicEntity )
            private
                var
                    lineThickness   : integer;
                    fillColour,
                    lineColour      : TColor;
                    lineStyle       : TPenStyle;
            protected
                var
                    filled, outlined : boolean;
            public
                //constructor
                    constructor create( const   filledIn        : boolean;
                                        const   lineThicknessIn : integer;
                                        const   fillColourIn,
                                                lineColourIn    : TColor;
                                        const   lineStyleIn     : TPenStyle );
                //destructor
                    destructor destroy(); override;
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TGenericXYEntityCanvas ); override;
        end;

implementation

    //public
        //constructor
            constructor TFoundationalGraphicEntity.create(  const   filledIn        : boolean;
                                                            const   lineThicknessIn : integer;
                                                            const   fillColourIn,
                                                                    lineColourIn    : TColor;
                                                            const   lineStyleIn     : TPenStyle );
                begin
                    inherited create();

                    filled          := filledIn;
                    outlined        := (0 < lineThicknessIn);
                    lineThickness   := lineThicknessIn;
                    fillColour      := fillColourIn;
                    lineColour      := lineColourIn;
                    lineStyle       := lineStyleIn;
                end;

        //destructor
            destructor TFoundationalGraphicEntity.destroy();
                begin
                    inherited destroy();
                end;

        //draw to canvas
            procedure TFoundationalGraphicEntity.drawToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                                var canvasInOut         : TGenericXYEntityCanvas );
                begin
                    //fill properties
                        canvasInOut.setBrushFillProperties( filled, fillColour );

                    //line properties
                        canvasInOut.setPenLineProperties( lineThickness, lineColour, lineStyle );
                end;

end.
