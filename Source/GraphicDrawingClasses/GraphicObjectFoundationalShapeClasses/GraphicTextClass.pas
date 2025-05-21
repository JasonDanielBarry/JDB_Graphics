unit GraphicTextClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Types, system.Classes,
        Vcl.Direct2D, vcl.Graphics, vcl.Themes,
        GeometryTypes,
        GeomBox,
        GraphicDrawingTypes,
        DrawingAxisConversionClass,
        GraphicObjectBaseClass
        ;

    type
        TGraphicText = class(TGraphicObject)
            private
                var
                    addUnderlay     : boolean;
                    textSize        : integer;
                    textString      : string;
                    textColour      : TColor;
                    textFontStyles  : TFontStyles;
                //set font properties
                    procedure setFontProperties(var canvasInOut : TDirect2DCanvas);
                //calculate the translation of the text for the alignment settings
                    procedure calculateTextAlignmentTranslation(out xTranslationOut, yTranslationOut    : double;
                                                                out textExtentOut                       : Tsize;
                                                                var canvasInOut                         : TDirect2DCanvas);
                //dray the text underlay
                    procedure drawTextUnderlay( const xIn, yIn      : integer;
                                                const textExtentIn  : TSize;
                                                var canvasInOut     : TDirect2DCanvas );
                //draw to canvas
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       ); override;
            public
                //constructor
                    constructor create( const   addUnderlayIn       : boolean;
                                        const   textSizeIn          : integer;
                                        const   textRotationAngleIn : double;
                                        const   textStringIn        : string;
                                        const   scaleTypeIn         : EScaleType;
                                        const   textHorAlignmentIn  : TAlignment;
                                        const   textVertAlignmentIn : TVerticalAlignment;
                                        const   textColourIn        : TColor;
                                        const   textFontStylesIn    : TFontStyles;
                                        const   textHandlePointIn   : TGeomPoint        );
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setTextString(const newTextIn : string);
        end;

implementation

    //private
        //set font properties
            procedure TGraphicText.setFontProperties(var canvasInOut : TDirect2DCanvas);
                begin
                    //set font properties
                        canvasInOut.Font.size   := textSize;
                        canvasInOut.Font.Color  := TStyleManager.ActiveStyle.GetSystemColor( textColour );
                        canvasInOut.Font.Name   := 'Segoe UI';
                        canvasInOut.Font.Style  := textFontStyles;
                        canvasInOut.Brush.Style := TBrushStyle.bsClear;
                end;

        //calculate the translation of the text for the alignment settings
            procedure TGraphicText.calculateTextAlignmentTranslation(   out xTranslationOut, yTranslationOut    : double;
                                                                        out textExtentOut                       : Tsize;
                                                                        var canvasInOut                         : TDirect2DCanvas   );
                begin
                    textExtentOut := canvasInOut.TextExtent( textString );

                    //x - translation
                        case ( horizontalAlignment ) of
                            TAlignment.taLeftJustify:
                                xTranslationOut := 0;

                            TAlignment.taCenter:
                                xTranslationOut := textExtentOut.Width / 2;

                            TAlignment.taRightJustify:
                                xTranslationOut := textExtentOut.Width;
                        end;

                    //y - translation
                        case ( verticalAlignment ) of
                            TVerticalAlignment.taAlignTop:
                                yTranslationOut := 0;

                            TVerticalAlignment.taVerticalCenter:
                                yTranslationOut := textExtentOut.Height / 2;

                            TVerticalAlignment.taAlignBottom:
                                yTranslationOut := textExtentOut.Height;
                        end;
                end;

        //dray the text underlay
            procedure TGraphicText.drawTextUnderlay(const xIn, yIn      : integer;
                                                    const textExtentIn  : TSize;
                                                    var canvasInOut     : TDirect2DCanvas );
                var
                    fillColour : TColor;
                begin
                    if NOT( addUnderlay ) then
                        exit();

                    fillColour := TStyleManager.ActiveStyle.GetStyleColor( TStyleColor.scGenericBackground );

                    canvasInOut.Brush.Color := fillColour;
                    canvasInOut.Brush.Style := TBrushStyle.bsSolid;

                    canvasInOut.FillRect( Rect( xIn, yIn, xIn + textExtentIn.Width, yIn + textExtentIn.Height ) );
                end;

        //draw to canvas
            procedure TGraphicText.drawGraphicToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DCanvas       );
                var
                    x, y                        : integer;
                    xTranslation, yTranslation  : double;
                    textExtent                  : Tsize;
                    transformMatrix             : TD2DMatrix3x2F;
                begin
                    //set the canvas dont properties
                        setFontProperties( canvasInOut );

                    //calculate text translation
                        calculateTextAlignmentTranslation( xTranslation, yTranslation, textExtent, canvasInOut );

                        x := round( handlePointLT.X - xTranslation );
                        y := round( handlePointLT.Y - yTranslation );

                    //draw underlay (if required)
                        drawTextUnderlay( x, y, textExtent, canvasInOut );

                    //draw text to canvas
                        canvasInOut.TextOut( x, y, textString );
                end;

    //public
        //constructor
            constructor TGraphicText.create(const   addUnderlayIn       : boolean;
                                            const   textSizeIn          : integer;
                                            const   textRotationAngleIn : double;
                                            const   textStringIn        : string;
                                            const   scaleTypeIn         : EScaleType;
                                            const   textHorAlignmentIn  : TAlignment;
                                            const   textVertAlignmentIn : TVerticalAlignment;
                                            const   textColourIn        : TColor;
                                            const   textFontStylesIn    : TFontStyles;
                                            const   textHandlePointIn   : TGeomPoint        );
                begin
                    inherited create(   false,
                                        1,
                                        textRotationAngleIn,
                                        scaleTypeIn,
                                        horizontalAlignment,
                                        verticalAlignment,
                                        clNone,
                                        clNone,
                                        TPenStyle.psSolid,
                                        textHandlePointIn   );

                    addUnderlay         := addUnderlayIn;
                    textSize            := textSizeIn;
                    textString          := textStringIn;
                    textColour          := textColourIn;
                    textFontStyles      := textFontStylesIn;

                    graphicBox.setDimensions( 0, 0 );
                    graphicBox.setCentrePoint( textHandlePointIn );
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

end.
