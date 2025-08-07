unit GenericCustomCanvasAbstractClass;

interface

    uses
        System.SysUtils, system.Math, System.UITypes, system.Types,
        Vcl.Graphics, Vcl.Themes
        ;

    type
        TGenericCustomAbstractCanvas = class
            private
                class var textSizeMeasuringBitmap : TBitmap;
                //background colour
                    class function determineBackgroundColour() : Tcolor; static;
            protected
                var
                    localBackgroundColour : TColor; //used for member functions of the class while it is instatiated - DO NOT WRITE TO
            public
                //constructor
                    constructor create(); virtual;
                //set brush properties
                    procedure setBrushFillProperties(const solidIn : boolean; const colourIn : TColor); virtual; abstract;
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle = TPenStyle.psSolid ); virtual; abstract;
                //set font properties
                    procedure setFontTextProperties(const sizeIn        : integer;
                                                    const colourIn      : TColor;
                                                    const underlaidIn   : boolean = False;
                                                    const stylesIn      : TFontStyles = [];
                                                    const nameIn        : string = ''       ); virtual; abstract;
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
            class function TGenericCustomAbstractCanvas.determineBackgroundColour() : Tcolor;
                begin
                    result := TStyleManager.ActiveStyle.GetStyleColor( TStyleColor.scGenericBackground );
                end;

    //public
        //constructor
            constructor TGenericCustomAbstractCanvas.create();
                begin
                    inherited create();
                end;

        //measure text entent
            class function TGenericCustomAbstractCanvas.measureTextExtent(  const textStringIn      : string;
                                                                            const textSizeIn        : integer = 9;
                                                                            const textFontStylesIn  : TFontStyles = [];
                                                                            const textNameIn        : string = 'Segoe UI'   ) : TSize;
                const
                    EMPTY_STRING : string = '';
                var
                    i, arrLen       : integer;
                    tempSize,
                    textExtentOut   : TSize;
                    stringArray     : TArray<string>;
                begin
                    //assign settings to bitmap
                        textSizeMeasuringBitmap.Canvas.font.Size := textSizeIn;
                        textSizeMeasuringBitmap.Canvas.font.Style := textFontStylesIn;

                        if ( textNameIn <> '' ) then
                            textSizeMeasuringBitmap.Canvas.font.Name := textNameIn;

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
                                        tempSize := textSizeMeasuringBitmap.Canvas.TextExtent( stringArray[i] );

                                        textExtentOut.Width     := max( tempSize.Width, textExtentOut.Width );
                                        textExtentOut.Height    := textExtentOut.Height + tempSize.Height;
                                    end;
                            end
                        else
                            textExtentOut := textSizeMeasuringBitmap.Canvas.TextExtent( textStringIn );

                    result := textExtentOut;
                end;

initialization

    TGenericCustomAbstractCanvas.textSizeMeasuringBitmap := TBitmap.Create(100, 100); //these dimensions are not important

finalization

    FreeAndNil( TGenericCustomAbstractCanvas.textSizeMeasuringBitmap );

end.
