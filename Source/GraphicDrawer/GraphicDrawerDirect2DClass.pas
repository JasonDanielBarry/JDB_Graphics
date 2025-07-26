unit GraphicDrawerDirect2DClass;

interface

    uses
        //Delphi
            Winapi.D2D1, Winapi.Messages,
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
                    currentGraphicBufferBMP : TBitmap;
                    onPostGraphicDrawEvent  : TOnPostGraphicDrawEvent;
                //draw all graphic entities
                    procedure drawAll(const canvasWidthIn, canvasHeightIn : integer);
            public

                //constructor
                    constructor create(); override;
                //destructor
                    destructor destroy(); override;
                //graphic draw event
                    function getOnPostGraphicDrawEvent() : TOnPostGraphicDrawEvent;
                    procedure setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TOnPostGraphicDrawEvent);
                //process windows messages
                    procedure processWindowsMessages(   const canvasWidthIn, canvasHeightIn : integer;
                                                        const newMousePositionIn            : TPoint;
                                                        const messageIn                     : Tmessage;
                                                        out graphicBufferWasUpdatedOut      : boolean   );
                property GraphicBuffer : TBitmap read currentGraphicBufferBMP;
        end;

implementation

    //private
        //draw all graphic entities
            procedure TGraphicDrawerDirect2D.drawAll(const canvasWidthIn, canvasHeightIn : integer);
                var
                    D2DCanvas : TDirect2DXYEntityCanvas;
                begin
                    //size bitmap for drawing
                        currentGraphicBufferBMP.SetSize( canvasWidthIn, canvasHeightIn );

                    //create D2D canvas
                        D2DCanvas := TDirect2DXYEntityCanvas.Create( currentGraphicBufferBMP.Canvas, Rect(0, 0, canvasWidthIn, canvasHeightIn) );

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

    //public
        //constructor
            constructor TGraphicDrawerDirect2D.create();
                begin
                    inherited create();

                    currentGraphicBufferBMP             := TBitmap.Create();
                    currentGraphicBufferBMP.PixelFormat := TPixelFormat.pf32bit;

                    onPostGraphicDrawEvent := nil;
                end;

        //destructor
            destructor TGraphicDrawerDirect2D.destroy();
                begin
                    FreeAndNil( currentGraphicBufferBMP );

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

        //process windows messages
            procedure TGraphicDrawerDirect2D.processWindowsMessages(const canvasWidthIn, canvasHeightIn : integer;
                                                                    const newMousePositionIn            : TPoint;
                                                                    const messageIn                     : Tmessage;
                                                                    out graphicBufferWasUpdatedOut      : boolean);
                var
                    graphicBufferMustBeUpdated : boolean;
                begin
                    //test if the buffer must be updated based on received windows messages
                        if ( messageIn.Msg = WM_USER_REDRAW_GRAPHIC ) then
                            graphicBufferMustBeUpdated := True
                        else
                            graphicBufferMustBeUpdated := axisConverter.windowsMessageRequiredRedraw( messageIn, newMousePositionIn );

                        if NOT( graphicBufferMustBeUpdated ) then
                            begin
                                graphicBufferWasUpdatedOut := False;
                                exit();
                            end;

                    //update the graphic buffer
                        drawAll( canvasWidthIn, canvasHeightIn );

                    graphicBufferWasUpdatedOut := True;
                end;

end.
