unit GraphicDrawerDirect2DClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes, system.UIConsts,
            vcl.Graphics,
            vcl.Direct2D, Winapi.D2D1,
        //custom
            DrawingAxisConversionClass,
            GraphicGeometryClass,
            GraphicDrawerAxisConversionInterfaceClass,
            GeometryBaseClass;

    type
        TOnPostGraphicDrawEvent = procedure(const AWidth, AHeight : integer; const AD2DCanvas : TDirect2DCanvas) of object;

        TGraphicDrawerDirect2D = class(TGraphicDrawerAxisConversionInterface)
            private
                var
                    onPostGraphicDrawEvent : TOnPostGraphicDrawEvent;
            public
                //constructor
                    constructor create(); override;
                //destructor
                    destructor destroy(); override;
                //graphic draw event
                    function getOnPostGraphicDrawEvent() : TOnPostGraphicDrawEvent;
                    procedure setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TOnPostGraphicDrawEvent);
                //draw all geometry
                    procedure drawAll(  const canvasWidthIn, canvasHeightIn : integer;
                                        const canvasIn                      : TCanvas   );
        end;

implementation

    //public
        //constructor
            constructor TGraphicDrawerDirect2D.create();
                begin
                    inherited create();

                    onPostGraphicDrawEvent := nil;
                end;

        //destructor
            destructor TGraphicDrawerDirect2D.destroy();
                begin
                    inherited destroy();
                end;

        //graphic draw event
            function TGraphicDrawerDirect2D.getOnPostGraphicDrawEvent() : TOnPostGraphicDrawEvent;
                begin
                    result := onPostGraphicDrawEvent;
                end;

            procedure TGraphicDrawerDirect2D.setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TOnPostGraphicDrawEvent);
                begin
                    onPostGraphicDrawEvent := onPostGraphicDrawEventIn;
                end;

        //draw all geometry
            procedure TGraphicDrawerDirect2D.drawAll(   const canvasWidthIn, canvasHeightIn : integer;
                                                        const canvasIn                      : TCanvas   );
                var
                    D2DCanvas : TDirect2DCanvas;
                begin
                    //create D2D canvas
                        D2DCanvas := TDirect2DCanvas.Create( canvasIn, Rect(0, 0, canvasWidthIn, canvasHeightIn) );

                        D2DCanvas.RenderTarget.SetAntialiasMode( TD2D1AntiAliasMode.D2D1_ANTIALIAS_MODE_PER_PRIMITIVE );

                        D2DCanvas.RenderTarget.SetTextAntialiasMode( TD2D1TextAntiAliasMode.D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE );

                    //draw to the D2D canvas
                        D2DCanvas.BeginDraw();

                        inherited drawAll(
                                            canvasWidthIn,
                                            canvasHeightIn,
                                            D2DCanvas
                                         );

                        if ( Assigned( onPostGraphicDrawEvent ) ) then
                            onPostGraphicDrawEvent( canvasWidthIn, canvasHeightIn, D2DCanvas );

                        D2DCanvas.EndDraw();

                    FreeAndNil( D2DCanvas );
                end;

end.
