unit GraphicTextClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Types, system.Classes, System.Math, System.StrUtils,
        Vcl.Direct2D, vcl.Graphics, vcl.Themes, Vcl.ExtCtrls,
        GeometryTypes,
        GeomBox,
        GraphicDrawingTypes,
        DrawingAxisConversionClass,
        GraphicEntityBaseClass
        ;

    type
        TGraphicText = class(TGraphicEntity)
            private
                var
                    addUnderlay     : boolean;
                    textSize        : integer;
                    textString      : string;
                    textColour      : TColor;
                    textFontStyles  : TFontStyles;
                //set font properties
                    procedure setFontProperties(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DCanvas       );
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
                class var
                    fontName : TFontName;
                //constructor
                    constructor create( const   addUnderlayIn       : boolean;
                                        const   textSizeIn          : integer;
                                        const   textRotationAngleIn : double;
                                        const   textStringIn        : string;
                                        const   scaleTypeIn         : EScaleType;
                                        const   textHorAlignmentIn  : THorzRectAlign;
                                        const   textVertAlignmentIn : TVertRectAlign;
                                        const   textColourIn        : TColor;
                                        const   textFontStylesIn    : TFontStyles;
                                        const   textHandlePointIn   : TGeomPoint        );
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setTextString(const newTextIn : string);
                //measure text
                    class function measureTextExtent(   const textStringIn      : string;
                                                        const textSizeIn        : integer = 9;
                                                        const textFontStylesIn  : TFontStyles = []) : TSize;
        end;

implementation

    //private
        //set font properties
            procedure TGraphicText.setFontProperties(   const axisConverterIn   : TDrawingAxisConverter;
                                                        var canvasInOut         : TDirect2DCanvas       );
                begin
                    //set font properties
                        //size
                            case (objectScaleType) of
                                EScaleType.scCanvas:
                                    canvasInOut.Font.size := textSize;

                                EScaleType.scDrawing:
                                    begin
                                        var drawingSize : integer := abs(round( axisConverterIn.dY_To_dT( textSize ) ) );

                                        canvasInOut.Font.size := max( 1, drawingSize );
                                    end;
                            end;

                        canvasInOut.Font.Color  := TStyleManager.ActiveStyle.GetSystemColor( textColour );
                        canvasInOut.Font.Name   := fontName;
                        canvasInOut.Font.Style  := textFontStyles;

                        if ( addUnderlay ) then
                            canvasInOut.Brush.Style := TBrushStyle.bsSolid
                        else
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
                            THorzRectAlign.Left:
                                xTranslationOut := 0;

                            THorzRectAlign.Center:
                                xTranslationOut := textExtentOut.Width / 2;

                            THorzRectAlign.Right:
                                xTranslationOut := textExtentOut.Width;
                        end;

                    //y - translation
                        case ( verticalAlignment ) of
                            TVertRectAlign.Bottom:
                                yTranslationOut := textExtentOut.Height;

                            TVertRectAlign.Center:
                                yTranslationOut := textExtentOut.Height / 2;

                            TVertRectAlign.Top:
                                yTranslationOut := 0;
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
                    //set the canvas font properties
                        setFontProperties( axisConverterIn, canvasInOut );

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
                                            const   textHorAlignmentIn  : THorzRectAlign;
                                            const   textVertAlignmentIn : TVertRectAlign;
                                            const   textColourIn        : TColor;
                                            const   textFontStylesIn    : TFontStyles;
                                            const   textHandlePointIn   : TGeomPoint        );
                begin
                    inherited create(   false,
                                        1,
                                        textRotationAngleIn,
                                        scaleTypeIn,
                                        textHorAlignmentIn,
                                        textVertAlignmentIn,
                                        clNone,
                                        clNone,
                                        TPenStyle.psSolid,
                                        textHandlePointIn   );

                    addUnderlay         := addUnderlayIn;
                    textSize            := textSizeIn;
                    textColour          := textColourIn;
                    textFontStyles      := textFontStylesIn;

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

                    case ( objectScaleType ) of
                        EScaleType.scCanvas:
                            dimensionAndPositionGraphicBox( 0, 0 );

                        EScaleType.scDrawing:
                            begin
                                var textExtent : TSize := measureTextExtent( newTextIn, textSize, textFontStyles );

                                dimensionAndPositionGraphicBox( textExtent.Width, textExtent.Height );
                            end;
                    end;
                end;

        //measure text
            class function TGraphicText.measureTextExtent(  const textStringIn      : string;
                                                            const textSizeIn        : integer = 9;
                                                            const textFontStylesIn  : TFontStyles = []) : TSize;
                var
                    i, arrLen       : integer;
                    textExtentOut   : TSize;
                    tempBitmap      : TBitmap;
                    stringArray     : TArray<string>;
                begin
                    //create a temp bitmap to use the canvas
                        tempBitmap := TBitmap.Create( 100, 100 );

                        tempBitmap.Canvas.font.Size     := textSizeIn;
                        tempBitmap.Canvas.font.Style    := textFontStylesIn;

                    //split the string using line breaks as delimiter
                        stringArray := textStringIn.Split( [sLineBreak] );
                        arrLen := length( stringArray );

                    //calculate the extent (size) of the text
                        if ( 1 < arrLen ) then
                            begin
                                textExtentOut.Width     := 0;
                                textExtentOut.Height    := 0;

                                for i := 0 to (arrLen - 1) do
                                    begin
                                        var tempSize : TSize := tempBitmap.Canvas.TextExtent( stringArray[i] );

                                        textExtentOut.Width     := max( tempSize.Width, textExtentOut.Width );
                                        textExtentOut.Height    := textExtentOut.Height + tempSize.Height;
                                    end;
                            end
                        else
                            textExtentOut := tempBitmap.Canvas.TextExtent( textStringIn );

                    //free bitmap memory
                        FreeAndNil( tempBitmap );

                    result := textExtentOut;
                end;

end.
