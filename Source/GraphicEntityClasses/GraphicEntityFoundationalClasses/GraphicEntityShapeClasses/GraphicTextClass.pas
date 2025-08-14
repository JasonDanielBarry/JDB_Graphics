unit GraphicTextClass;

interface

    uses
        system.SysUtils, system.Types, System.Math,
        vcl.Graphics, vcl.Themes,
        GeometryTypes,
        GeomBox,
        DrawingAxisConversionClass,
        GenericLTEntityDrawingMethods,
        GraphicShapeClass,
        GenericXYEntityCanvasClass
        ;

    type
        TGraphicText = class( TGraphicShape )
            private
                var
                    addTextUnderlay : boolean;
                    textSize        : double;
                    textString      : string;
                    textColour      : TColor;
                    textFontStyles  : TFontStyles;
                //draw to canvas
                    procedure drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TGenericXYEntityCanvas); override;
            public
                class var
                    fontName : TFontName;
                //constructor
                    constructor create( const   addTextUnderlayIn   : boolean;
                                        const   textSizeIn,
                                                textRotationAngleIn : double;
                                        const   textStringIn        : string;
                                        const   scaleTypeIn         : EScaleType;
                                        const   textHorAlignmentIn  : THorzRectAlign;
                                        const   textVertAlignmentIn : TVertRectAlign;
                                        const   textColourIn        : TColor;
                                        const   textFontStylesIn    : TFontStyles;
                                        const   textHandlePointIn   : TGeomPoint    );
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setTextString(const newTextIn : string);
                //bounding box
                    function determineBoundingBox() : TGeomBox; override;
        end;

implementation

    //private
        //draw to canvas
            procedure TGraphicText.drawShapeToCanvas(   const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TGenericXYEntityCanvas );
                begin
                    //draw text to canvas
                        canvasInOut.printXYText(    textString,
                                                    handlePointXY,
                                                    axisConverterIn,
                                                    addTextUnderlay,
                                                    textSize,
                                                    horizontalAlignment,
                                                    verticalAlignment,
                                                    scaleType,
                                                    textColour,
                                                    textFontStyles,
                                                    fontName,           );
                end;

    //public
        //constructor
            constructor TGraphicText.create(const   addTextUnderlayIn   : boolean;
                                            const   textSizeIn,
                                                    textRotationAngleIn : double;
                                            const   textStringIn        : string;
                                            const   scaleTypeIn         : EScaleType;
                                            const   textHorAlignmentIn  : THorzRectAlign;
                                            const   textVertAlignmentIn : TVertRectAlign;
                                            const   textColourIn        : TColor;
                                            const   textFontStylesIn    : TFontStyles;
                                            const   textHandlePointIn   : TGeomPoint    );
                begin
                    inherited create(   false,
                                        0,
                                        textRotationAngleIn,
                                        scaleTypeIn,
                                        textHorAlignmentIn,
                                        textVertAlignmentIn,
                                        clNone,
                                        clNone,
                                        TPenStyle.psSolid,
                                        textHandlePointIn   );

                    addTextUnderlay := addTextUnderlayIn;
                    textSize        := textSizeIn;
                    textColour      := textColourIn;
                    textFontStyles  := textFontStylesIn;

                    setTextString( textStringIn );
                end;

        //destructor
            destructor TGraphicText.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            procedure TGraphicText.setTextString(const newTextIn : string);
                begin
                    textString := newTextIn;
                end;

        //bounding box
            function TGraphicText.determineBoundingBox() : TGeomBox;
                var
                    boundingBoxOut : TGeomBox;
                begin
                    case ( scaleType ) of
                        EScaleType.scCanvas:
                            boundingBoxOut := TGeomBox.determineBoundingBox( [ handlePointXY, handlePointXY ] );

                        EScaleType.scDrawing:
                            begin
                                var textExtent : TSize := measureTextLTExtent( textString, round( textSize ), textFontStyles );

                                boundingBoxOut := calculateShapeBoundingBox( textExtent.Width, textExtent.Height );
                            end;
                    end;

                    result := boundingBoxOut;
                end;

end.
