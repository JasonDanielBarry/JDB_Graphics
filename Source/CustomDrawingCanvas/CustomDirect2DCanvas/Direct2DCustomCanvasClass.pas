unit Direct2DCustomCanvasClass;

interface

    uses
        Winapi.D2D1,
        System.SysUtils, system.Math, system.Types, System.UITypes,
        Vcl.Direct2D, Vcl.Graphics, vcl.Themes
        ;

    type
        TDirect2DCustomCanvas = class( TDirect2DCanvas )
            public
                //constructor
                    constructor create(const bitmapIn : TBitmap);
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
        end;

implementation

    //constructor
        constructor TDirect2DCustomCanvas.create(const bitmapIn : TBitmap);
            var
                bitmapRect : TRect;
            begin
                bitmapRect := Rect( 0, 0, bitmapIn.Width, bitmapIn.Height );

                inherited create( bitmapIn.Canvas, bitmapRect );

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
                Brush.Color := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
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
                Pen.Color := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                Pen.Style := styleIn;
            end;

    //set font properties
        procedure TDirect2DCustomCanvas.setFontTextProperties(  const sizeIn    : integer;
                                                                const colourIn  : TColor;
                                                                const stylesIn  : TFontStyles = [];
                                                                const nameIn    : string = ''       );
            begin
                Font.Size   := sizeIn;
                Font.Color  := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                Font.Style  := stylesIn;

                if ( nameIn <> '' ) then
                    Font.Name := nameIn;
            end;

end.
