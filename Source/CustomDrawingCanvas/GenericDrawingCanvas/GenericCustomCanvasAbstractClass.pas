unit GenericCustomCanvasAbstractClass;

interface

    uses
        System.SysUtils, system.Math, System.UITypes, system.Types,
        Vcl.Graphics, Vcl.Themes
        ;

    type
        TGenericCustomAbstractCanvas = class
            private
                //background colour
                    class function determineBackgroundColour() : Tcolor; static;
            public
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
                                                    const nameIn        : string = ''       ); virtual;
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
        //set font properties
            procedure TGenericCustomAbstractCanvas.setFontTextProperties(   const sizeIn        : integer;
                                                                            const colourIn      : TColor;
                                                                            const underlaidIn   : boolean = False;
                                                                            const stylesIn      : TFontStyles = [];
                                                                            const nameIn        : string = ''       );
                begin
                    if ( underlaidIn ) then
                        setBrushFillProperties( True, BackgroundColour );
                end;



end.
