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
            MetafileXYEntityCanvasClass,
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
                    //using Direct2D canvas
                        procedure drawAllUsingDirect2D(const canvasWidthIn, canvasHeightIn : integer);
                    //draw all entities to metafile and save to EMF
                        procedure drawAndSaveAllToMetafile( const metafileWidthIn, metafileHeightIn : integer;
                                                            const fileNameIn                        : string );
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
                                                        var graphicBufferWasUpdatedInOut    : boolean   );
                property GraphicBuffer : TBitmap read currentGraphicBufferBMP;
        end;

implementation

    //private
        //draw all graphic entities
            //using Direct2D canvas
                procedure TGraphicDrawer.drawAllUsingDirect2D(const canvasWidthIn, canvasHeightIn : integer);
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

            //draw all entities to metafile and save to EMF
                procedure TGraphicDrawer.drawAndSaveAllToMetafile(  const metafileWidthIn, metafileHeightIn : integer;
                                                                    const fileNameIn                        : string );
                    var
                        metafileXYCanvas : TMetafileXYEntityCanvas;
                    begin
                        metafileXYCanvas := TMetafileXYEntityCanvas.create();

                        metafileXYCanvas.beginDrawing( metafileWidthIn, metafileHeightIn );

                        inherited drawAll(
                                            metafileWidthIn,
                                            metafileHeightIn,
                                            TGenericXYEntityCanvas( metafileXYCanvas )
                                         );

                        metafileXYCanvas.saveToFile( fileNameIn );

                        FreeAndNil( metafileXYCanvas )
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
                    BMP_EXT     : string = '.bmp';
                    EMF_EXT     : string = '.emf';
                    JPEG_EXT    : string = '.jpg';
                    PNG_EXT     : string = '.png';
                var
                    fileExtension : string;
                begin
                    if NOT( fileNameIn.Contains('.') ) then
                        exit();

                    fileExtension := ExtractFileExt( fileNameIn );

                    if ( fileExtension = BMP_EXT ) then
                        currentGraphicBufferBMP.SaveToFile( fileNameIn )

                    else if ( fileExtension = EMF_EXT ) then
                        drawAndSaveAllToMetafile( currentGraphicBufferBMP.Width, currentGraphicBufferBMP.Height, fileNameIn )

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
                                                            var graphicBufferWasUpdatedInOut    : boolean);
                var
                    graphicBufferMustBeUpdated : boolean;
                begin
                    //NOTE: graphicBufferWasUpdatedInOut is passed BY REFERENCE because its state is share among the calling application and the graphic drawer
                        //The graphic drawer is responsible for setting graphicBufferWasUpdatedInOut to True,
                        //The calling application is responsible for setting the variable passed as graphicBufferWasUpdatedInOut to False

                    //test if the buffer must be updated based on received windows messages
                        if ( messageIn.Msg = WM_USER_REDRAW_GRAPHIC ) then
                            graphicBufferMustBeUpdated := True
                        else
                            graphicBufferMustBeUpdated := axisConverter.windowsMessageRequiresRedraw( newMousePositionIn, messageIn );

                        if NOT( graphicBufferMustBeUpdated ) then
                            exit();

                    //update the graphic buffer
                        drawAllUsingDirect2D( canvasWidthIn, canvasHeightIn );

                    graphicBufferWasUpdatedInOut := True;
                end;

end.
