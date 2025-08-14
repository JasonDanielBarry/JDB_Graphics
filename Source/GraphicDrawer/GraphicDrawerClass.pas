unit GraphicDrawerClass;

interface

    uses
        //Delphi
            Winapi.D2D1, Winapi.Messages,
            system.SysUtils, system.types,
            vcl.Graphics,
        //custom
            BitmapHelperClass,
            DrawingAxisConversionClass,
            GenericXYEntityCanvasClass,
            Direct2DXYEntityCanvasClass,
            GraphicDrawerTypes,
            GraphicDrawerAxisConversionInterfaceClass,
            GeometryBaseClass;

    type
        TGraphicDrawer = class(TGraphicDrawerAxisConversionInterface)
            private
                var
                    currentGraphicBufferBMP : TBitmap;
                    onPostGraphicDrawEvent  : TPostGraphicDrawEvent;
                    D2DDrawingCanvas        : TDirect2DXYEntityCanvas;
                //draw all graphic entities
                    procedure drawAll(const canvasWidthIn, canvasHeightIn : integer);
            public
                //constructor
                    constructor create(); override;
                //destructor
                    destructor destroy(); override;
                //save bitmap to image
                    procedure saveGraphicToFile(const fileNameIn : string);
                //graphic draw event
                    function getOnPostGraphicDrawEvent() : TPostGraphicDrawEvent;
                    procedure setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TPostGraphicDrawEvent);
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
            procedure TGraphicDrawer.drawAll(const canvasWidthIn, canvasHeightIn : integer);
                begin
                    //size bitmap for drawing
                        currentGraphicBufferBMP.SetSize( canvasWidthIn, canvasHeightIn );

                    //begin D2D canvas drawing
                        D2DDrawingCanvas.beginDrawing( currentGraphicBufferBMP );

                    //draw to the D2D canvas
                        inherited drawAll(
                                            canvasWidthIn,
                                            canvasHeightIn,
                                            TGenericXYEntityCanvas( D2DDrawingCanvas )
                                         );

                        if ( Assigned( onPostGraphicDrawEvent ) ) then
                            onPostGraphicDrawEvent( canvasWidthIn, canvasHeightIn, D2DDrawingCanvas );

                    //end drawing
                        D2DDrawingCanvas.endDrawing();
                end;

    //public
        //constructor
            constructor TGraphicDrawer.create();
                begin
                    inherited create();

                    currentGraphicBufferBMP             := TBitmap.Create();
                    currentGraphicBufferBMP.PixelFormat := TPixelFormat.pf32bit;

                    D2DDrawingCanvas := TDirect2DXYEntityCanvas.Create();

                    onPostGraphicDrawEvent := nil;
                end;

        //destructor
            destructor TGraphicDrawer.destroy();
                begin
                    FreeAndNil( currentGraphicBufferBMP );

                    inherited destroy();
                end;

        //save bitmap to image
            procedure TGraphicDrawer.saveGraphicToFile(const fileNameIn : string);
                const
                    BMP_EXT : string    = '.bmp';
                    JPEG_EXT : string   = '.jpg';
                    PNG_EXT : string    = '.png';
                var
                    fileExtension : string;
                begin
                    if NOT( fileNameIn.Contains('.') ) then
                        exit();

                    fileExtension := ExtractFileExt( fileNameIn );

                    if ( fileExtension = BMP_EXT ) then
                        currentGraphicBufferBMP.SaveToFile( fileNameIn )

                    else if ( fileExtension = JPEG_EXT ) then
                        currentGraphicBufferBMP.saveToJPegFile( fileNameIn )

                    else if (fileExtension = PNG_EXT ) then
                        currentGraphicBufferBMP.saveToPngFile( fileNameIn );
                end;

        //graphic draw event
            function TGraphicDrawer.getOnPostGraphicDrawEvent() : TPostGraphicDrawEvent;
                begin
                    result := onPostGraphicDrawEvent;
                end;

            procedure TGraphicDrawer.setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TPostGraphicDrawEvent);
                begin
                    onPostGraphicDrawEvent := onPostGraphicDrawEventIn;
                end;

        //process windows messages
            procedure TGraphicDrawer.processWindowsMessages(const canvasWidthIn, canvasHeightIn : integer;
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
                            graphicBufferMustBeUpdated := axisConverter.windowsMessageRequiredRedraw( newMousePositionIn, messageIn );

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
