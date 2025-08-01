unit Direct2DCustomCanvasClass;

interface

    uses
        Winapi.D2D1,
        System.SysUtils, system.Math, system.Types, System.UITypes,
        Vcl.Direct2D, Vcl.Graphics, vcl.Themes
        ;

    type
        TDirect2DCustomCanvas = class( TDirect2DCanvas )
            private
                const
                    EMPTY_STRING : string = '';
                //background colour
                    class function determineBackgroundColour() : Tcolor; static;
            protected
                var
                    localBackgroundColour : TColor; //used for member functions of the class while it is instatiated - DO NOT WRITE TO
            public
                //constructor
                    constructor create( const canvasIn  : TCanvas;
                                        const rectIn    : TRect     );
                //destructor
                    destructor destroy(); override;
                //set brush properties
                    procedure setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle = TPenStyle.psSolid );
                //set font properties
                    procedure setFontTextProperties(const sizeIn    : integer;
                                                    const colourIn  : TColor;
                                                    const stylesIn  : TFontStyles = [];
                                                    const nameIn    : string = ''       );
                //measure text entent
                    class function measureTextExtent(   const textStringIn      : string;
                                                        const textSizeIn        : integer = 9;
                                                        const textFontStylesIn  : TFontStyles = [];
                                                        const textNameIn        : string = 'Segoe UI'   ) : TSize; static;
                class property BackgroundColour : TColor read determineBackgroundColour;
        end;

implementation

    //private
        //background colour
            class function TDirect2DCustomCanvas.determineBackgroundColour() : Tcolor;
                begin
                    result := TStyleManager.ActiveStyle.GetStyleColor( TStyleColor.scGenericBackground );
                end;

    //constructor
        constructor TDirect2DCustomCanvas.create(   const canvasIn  : TCanvas;
                                                    const rectIn    : TRect     );
            begin
                inherited create( canvasIn, rectIn );

                localBackgroundColour := determineBackgroundColour();

                RenderTarget.SetAntialiasMode( TD2D1AntiAliasMode.D2D1_ANTIALIAS_MODE_PER_PRIMITIVE );

                RenderTarget.SetTextAntialiasMode( TD2D1TextAntiAliasMode.D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE );

                BeginDraw();
            end;

    //destructor
        destructor TDirect2DCustomCanvas.destroy();
            begin
                EndDraw();

                inherited destroy();
            end;

    //set brush properties
        procedure TDirect2DCustomCanvas.setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
            begin
                if NOT( solidIn ) then
                    begin
                        brush.Style := TBrushStyle.bsClear;
                        exit();
                    end;

                Brush.Style := TBrushStyle.bsSolid;
                Brush.Color := colourIn;
            end;



    //set pen properties
        procedure TDirect2DCustomCanvas.setPenLineProperties(   const widthIn   : integer;
                                                                const colourIn  : TColor;
                                                                const styleIn   : TPenStyle = TPenStyle.psSolid );
            begin
                if ( widthIn < 1 ) then
                    begin
                        pen.Style := TPenStyle.psClear;
                        exit();
                    end;

                Pen.Width := widthIn;
                Pen.Color := colourIn;
                Pen.Style := styleIn;
            end;

    //set font properties
        procedure TDirect2DCustomCanvas.setFontTextProperties(  const sizeIn    : integer;
                                                                const colourIn  : TColor;
                                                                const stylesIn  : TFontStyles = [];
                                                                const nameIn    : string = ''       );
            begin
                Font.Size   := sizeIn;
                Font.Color  := colourIn;
                Font.Style  := stylesIn;

                if ( nameIn <> EMPTY_STRING ) then
                    Font.Name := nameIn;
            end;

    //measure text entent
        class function TDirect2DCustomCanvas.measureTextExtent( const textStringIn      : string;
                                                                const textSizeIn        : integer = 9;
                                                                const textFontStylesIn  : TFontStyles = [];
                                                                const textNameIn        : string = 'Segoe UI' ) : TSize;
            var
                i, arrLen       : integer;
                textExtentOut   : TSize;
                tempBitmap      : TBitmap;
                stringArray     : TArray<string>;
            begin
                //create a temp bitmap to use the canvas
                    tempBitmap := TBitmap.Create( 100, 100 );

                    tempBitmap.Canvas.font.Size := textSizeIn;
                    tempBitmap.Canvas.font.Style := textFontStylesIn;

                    if ( textNameIn <> EMPTY_STRING ) then
                        tempBitmap.Canvas.font.Name := textNameIn;

                //split the string using line breaks as delimiter
                    stringArray := textStringIn.Split( [sLineBreak] );
                    arrLen      := length( stringArray );

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
