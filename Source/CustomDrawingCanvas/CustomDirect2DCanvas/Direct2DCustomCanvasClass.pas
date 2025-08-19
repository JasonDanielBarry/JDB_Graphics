unit Direct2DCustomCanvasClass;

interface

    uses
        Winapi.D2D1,
        System.SysUtils, system.Types,
        Vcl.Direct2D, Vcl.Graphics, vcl.Themes,
        BitmapHelperClass,
        GenericCustomCanvasAbstractClass
        ;

    type
        TDirect2DCustomCanvas = class( TDirect2DCanvas )
            public
                //constructor
                    constructor create(const bitmapIn : TBitmap);
                //destructor
                    destructor destroy(); override;
                //set brush properties
                    procedure setBrushFillProperties(   const solidIn : boolean;
                                                        const colourIn : TColor );
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle );
                //set font properties
                    procedure setFontTextProperties(const sizeIn    : integer;
                                                    const nameIn    : string;
                                                    const colourIn  : TColor;
                                                    const stylesIn  : TFontStyles);
        end;

implementation

    //constructor
        constructor TDirect2DCustomCanvas.create(const bitmapIn : TBitmap);
            var
                bitmapRectangle : TRect;
            begin
                //set up bitmap
                    bitmapRectangle := bitmapIn.getRectangle();
                    bitmapIn.Canvas.Brush.Color := TGenericCustomAbstractCanvas.BackgroundColour;
                    bitmapIn.Canvas.FillRect( bitmapRectangle );

                //set up D2D canvas
                    inherited create( bitmapIn.Canvas, bitmapRectangle );

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
        procedure TDirect2DCustomCanvas.setBrushFillProperties( const solidIn : boolean;
                                                                const colourIn : TColor );
            begin
                if NOT( solidIn ) then
                    begin
                        brush.Style := TBrushStyle.bsClear;
                        exit();
                    end;

                Brush.Style := TBrushStyle.bsSolid;
                Brush.Color := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
            end;

    //set pen properties
        procedure TDirect2DCustomCanvas.setPenLineProperties(   const widthIn   : integer;
                                                                const colourIn  : TColor;
                                                                const styleIn   : TPenStyle );
            begin
                if ( widthIn < 1 ) then
                    begin
                        pen.Style := TPenStyle.psClear;
                        exit();
                    end;

                Pen.Width := widthIn;
                Pen.Color := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                Pen.Style := styleIn;
            end;

    //set font properties
        procedure TDirect2DCustomCanvas.setFontTextProperties(  const sizeIn        : integer;
                                                                const nameIn        : string;
                                                                const colourIn      : TColor;
                                                                const stylesIn      : TFontStyles   );
            begin
                Font.Size   := sizeIn;
                Font.Name   := nameIn;
                Font.Color  := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                Font.Style  := stylesIn;
            end;

end.
