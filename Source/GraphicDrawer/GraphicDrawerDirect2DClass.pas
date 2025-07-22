unit GraphicDrawerDirect2DClass;

interface

    uses
        //Delphi
            Winapi.D2D1,
            system.SysUtils, system.types,
            vcl.Graphics,
        //custom
            DrawingAxisConversionClass,
            Direct2DXYEntityCanvasClass,
            GraphicGeometryClass,
            GraphicDrawerAxisConversionInterfaceClass,
            GeometryBaseClass;

    type
        TOnPostGraphicDrawEvent = procedure(const AWidth, AHeight : integer; const AD2DCanvas : TDirect2DXYEntityCanvas) of object;

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
                    D2DCanvas : TDirect2DXYEntityCanvas;
                begin
                    //create D2D canvas
                        D2DCanvas := TDirect2DXYEntityCanvas.Create( canvasIn, Rect(0, 0, canvasWidthIn, canvasHeightIn) );

                    //draw to the D2D canvas
                        inherited drawAll(
                                            canvasWidthIn,
                                            canvasHeightIn,
                                            D2DCanvas
                                         );

                        if ( Assigned( onPostGraphicDrawEvent ) ) then
                            onPostGraphicDrawEvent( canvasWidthIn, canvasHeightIn, D2DCanvas );

                    FreeAndNil( D2DCanvas );
                end;

end.
