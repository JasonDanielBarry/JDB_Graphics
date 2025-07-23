unit GraphicTextClass;

interface

    uses
        system.SysUtils, system.Types, System.Math,
        vcl.Graphics, vcl.Themes,
        GeometryTypes,
        GeomBox,
        DrawingAxisConversionClass,
        GraphicShapeClass,
        Direct2DXYEntityCanvasClass
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
                //set font properties
                    procedure setFontProperties(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DXYEntityCanvas);
                //draw to canvas
                    procedure drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DXYEntityCanvas); override;
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
        //set font properties
            procedure TGraphicText.setFontProperties(   const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DXYEntityCanvas       );
                begin
                    canvasInOut.Font.Color  := TStyleManager.ActiveStyle.GetSystemColor( textColour );
                    canvasInOut.Font.Name   := fontName;
                    canvasInOut.Font.Style  := textFontStyles;

                    if ( addTextUnderlay ) then
                        canvasInOut.Brush.Style := TBrushStyle.bsSolid
                    else
                        canvasInOut.Brush.Style := TBrushStyle.bsClear;
                end;

        //draw to canvas
            procedure TGraphicText.drawShapeToCanvas(   const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DXYEntityCanvas   );
                begin
                    //set the canvas font properties
                        setFontProperties( axisConverterIn, canvasInOut );

                    //draw text to canvas
                        canvasInOut.printXYText(    textString,
                                                    handlePointXY,
                                                    axisConverterIn,
                                                    addTextUnderlay,
                                                    textSize,
                                                    horizontalAlignment,
                                                    verticalAlignment,
                                                    scaleType               );
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
                                var textExtent : TSize := TDirect2DXYEntityCanvas.measureTextExtent( textString, round( textSize ), textFontStyles );

                                boundingBoxOut := calculateShapeBoundingBox( textExtent.Width, textExtent.Height );
                            end;
                    end;

                    result := boundingBoxOut;
                end;

end.
