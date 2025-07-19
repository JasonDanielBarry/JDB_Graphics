unit Direct2DEntityCanvasClass;

interface

    uses
        Winapi.D2D1,
        System.SysUtils, system.Math, system.Types,
        Vcl.Direct2D, Vcl.Graphics, vcl.Themes,
        Direct2DDrawingEntityMethods
        ;

    type
        TDirect2DEntityCanvas = class( TDirect2DCanvas )
            public
                //constructor
                    constructor create( const canvasIn  : TCanvas;
                                        const rectIn    : TRect     );
                //destructor
                    destructor destroy(); override;
                //canvas rotation
                    procedure rotateCanvas( const rotationAngleIn           : double;
                                            const rotationReferencePointIn  : TPointF );
                    procedure resetCanvasRotation();
                //drawing entities
                    //arc
                        procedure drawArcF( const   filledIn, outlinedIn        : boolean;
                                            const   startAngleIn, endAngleIn,
                                                    arcWidthIn, arcHeightIn     : double;
                                            const   centrePointIn               : TPointF );
                    //ellipse
                        procedure drawEllipseF( const   filledIn, outlinedIn    : boolean;
                                                const   ellipseWidthIn,
                                                        ellipseHeightIn         : double;
                                                const   handlePointIn           : TPointF;
                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center );
                    //line
                        procedure drawLineF(const arrDrawingPointsIn : TArray<TPointF>); overload;
                        procedure drawLineF(const startPointIn, endPointIn : TPointF); overload;
                    //polyline
                        procedure drawPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                    //polygon
                        procedure drawPolygonF( const filledIn, outlinedIn  : boolean;
                                                const arrDrawingPointsIn    : TArray<TPointF> );
                    //rectangle
                        procedure drawRectangleF(   const   filledIn, outlinedIn    : boolean;
                                                    const   widthIn, heightIn,
                                                            cornerRadiusIn          : double;
                                                    const   handlePointIn           : TPointF;
                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    );
                    //text
                        class function measureTextExtent(   const textStringIn      : string;
                                                            const textSizeIn        : integer = 9;
                                                            const textFontStylesIn  : TFontStyles = []  ) : TSize; static;
                        procedure printTextF(   const textStringIn          : string;
                                                const textHandlePointIn     : TPointF;
                                                const drawTextUnderlayIn    : boolean = False;
                                                const horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Left;
                                                const verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Top   );
        end;

implementation

    //public
        //constructor
            constructor TDirect2DEntityCanvas.create(   const canvasIn  : TCanvas;
                                                        const rectIn    : TRect     );
                begin
                    inherited create( canvasIn, rectIn );

                    RenderTarget.SetAntialiasMode( TD2D1AntiAliasMode.D2D1_ANTIALIAS_MODE_PER_PRIMITIVE );

                    RenderTarget.SetTextAntialiasMode( TD2D1TextAntiAliasMode.D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE );

                    BeginDraw();
                end;

        //destructor
            destructor TDirect2DEntityCanvas.destroy();
                begin
                    EndDraw();

                    inherited destroy();
                end;

        //canvas rotation
            procedure TDirect2DEntityCanvas.rotateCanvas(   const rotationAngleIn           : double;
                                                            const rotationReferencePointIn  : TPointF   );
                var
                    transformMatrix : TD2DMatrix3x2F;
                begin
                    //angle is in degrees
                    //get transformation matrix:
                        //positive angles = anti-clockwise rotation of the canvas
                        //which results in clockwise rotation of the drawing entities
                            transformMatrix := TD2DMatrix3x2F.Rotation( -rotationAngleIn, rotationReferencePointIn.X, rotationReferencePointIn.Y );

                    //rotate canvas
                        RenderTarget.SetTransform( transformMatrix );
                end;

            procedure TDirect2DEntityCanvas.resetCanvasRotation();
                begin
                    RenderTarget.SetTransform( TD2DMatrix3x2F.Identity );
                end;

        //drawing entities
            //arc
                procedure TDirect2DEntityCanvas.drawArcF(   const   filledIn, outlinedIn        : boolean;
                                                            const   startAngleIn, endAngleIn,
                                                                    arcWidthIn, arcHeightIn     : double;
                                                            const   centrePointIn               : TPointF   );
                    var
                        arcPathGeometry : ID2D1PathGeometry;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        arcPathGeometry := createArcPathGeometry(   filledIn,
                                                                    startAngleIn, endAngleIn,
                                                                    arcWidthIn, arcHeightIn,
                                                                    centrePointIn               );

                        //fill arc shape
                            if ( filledIn ) then
                                FillGeometry( arcPathGeometry );

                        //draw arc line
                            if ( outlinedIn ) then
                                DrawGeometry( arcPathGeometry );
                    end;

            //ellipse
                procedure TDirect2DEntityCanvas.drawEllipseF(   const   filledIn, outlinedIn    : boolean;
                                                                const   ellipseWidthIn,
                                                                        ellipseHeightIn         : double;
                                                                const   handlePointIn           : TPointF;
                                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    );
                    var
                        drawingEllipse : TD2D1Ellipse;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        //create drawing ellipse
                            drawingEllipse := createEllipseGeometry(    ellipseWidthIn, ellipseHeightIn,
                                                                        horizontalAlignmentIn, verticalAlignmentIn,
                                                                        handlePointIn                               );

                        //draw fill
                            if ( filledIn ) then
                                FillEllipse( drawingEllipse );

                        //draw line
                            if ( outlinedIn ) then
                                DrawEllipse( drawingEllipse );
                    end;

            //line
                procedure TDirect2DEntityCanvas.drawLineF(const arrDrawingPointsIn : TArray<TPointF>);
                    var
                        lineGeometry : ID2D1PathGeometry;
                    begin
                        lineGeometry := createOpenPathGeometry( arrDrawingPointsIn );

                        DrawGeometry( lineGeometry );
                    end;

                procedure TDirect2DEntityCanvas.drawLineF(const startPointIn, endPointIn : TPointF);
                    var
                        drawingPoints : TArray<TPointF>;
                    begin
                        SetLength( drawingPoints, 2 );

                        drawingPoints[0] := startPointIn;
                        drawingPoints[1] := endPointIn;

                        drawLineF( drawingPoints );
                    end;

            //polyline
                procedure TDirect2DEntityCanvas.drawPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                    var
                        polylineGeometry : ID2D1PathGeometry;
                    begin
                        polylineGeometry := createOpenPathGeometry( arrDrawingPointsIn );

                        DrawGeometry( polylineGeometry );
                    end;

            //polygon
                procedure TDirect2DEntityCanvas.drawPolygonF(   const filledIn, outlinedIn  : boolean;
                                                                const arrDrawingPointsIn    : TArray<TPointF>   );
                    var
                        polygonGeometry : ID2D1PathGeometry;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        polygonGeometry := createClosedPathGeometry( arrDrawingPointsIn );

                        if ( filledIn ) then
                            FillGeometry( polygonGeometry );

                        if ( outlinedIn ) then
                            DrawGeometry( polygonGeometry );
                    end;

            //rectangle
                procedure TDirect2DEntityCanvas.drawRectangleF( const   filledIn, outlinedIn    : boolean;
                                                                const   widthIn, heightIn,
                                                                        cornerRadiusIn          : double;
                                                                const   handlePointIn           : TPointF;
                                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center );
                    var
                        drawingRect : TD2D1RoundedRect;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        drawingRect := createRectangleGeometry( widthIn, heightIn,
                                                                cornerRadiusIn,
                                                                horizontalAlignmentIn,
                                                                verticalAlignmentIn,
                                                                handlePointIn           );

                        if ( filledIn ) then
                            FillRoundedRectangle( drawingRect );

                        if ( outlinedIn ) then
                            DrawRoundedRectangle( drawingRect );
                    end;

            //text
                class function TDirect2DEntityCanvas.measureTextExtent( const textStringIn      : string;
                                                                        const textSizeIn        : integer = 9;
                                                                        const textFontStylesIn  : TFontStyles = [] ) : TSize;
                    var
                        i, arrLen       : integer;
                        textExtentOut   : TSize;
                        tempBitmap      : TBitmap;
                        stringArray     : TArray<string>;
                    begin
                        //create a temp bitmap to use the canvas
                            tempBitmap := TBitmap.Create( 100, 100 );

                            tempBitmap.Canvas.font.Size     := textSizeIn;
                            tempBitmap.Canvas.font.Style    := textFontStylesIn;

                        //split the string using line breaks as delimiter
                            stringArray := textStringIn.Split( [sLineBreak] );
                            arrLen := length( stringArray );

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

                procedure TDirect2DEntityCanvas.printTextF( const textStringIn          : string;
                                                            const textHandlePointIn     : TPointF;
                                                            const drawTextUnderlayIn    : boolean = False;
                                                            const horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Left;
                                                            const verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Top   );
                    var
                        mustCalculateDrawingPoint   : boolean;
                        textExtent                  : TSize;
                        drawingPoint                : TPoint;
                    begin
                        //check if drawing point must be calculated
                            //true alignment is NOT top left
                                mustCalculateDrawingPoint := NOT( ( horizontalAlignmentIn = THorzRectAlign.Left ) AND ( verticalAlignmentIn = TVertRectAlign.Top ) );

                        //calculate the drawing point
                            if ( mustCalculateDrawingPoint ) then
                                begin
                                    //measure text extent
                                        textExtent := measureTextExtent( textStringIn, font.Size, font.Style );

                                    //calculate drawing point
                                        drawingPoint := calculateTextDrawingPoint(  textExtent,
                                                                                    horizontalAlignmentIn,
                                                                                    verticalAlignmentIn,
                                                                                    textHandlePointIn       );
                                end
                            else
                                begin
                                    drawingPoint.X := round( textHandlePointIn.X );
                                    drawingPoint.Y := round( textHandlePointIn.Y );
                                end;

                        //adjust canvas for underlay box
                            if ( drawTextUnderlayIn ) then
                                begin
                                    var underlayColour : TColor;

                                    underlayColour := TStyleManager.ActiveStyle.GetStyleColor( TStyleColor.scGenericBackground );

                                    Brush.Color := underlayColour;
                                    Brush.Style := TBrushStyle.bsSolid;
                                end
                            else
                                Brush.Style := TBrushStyle.bsClear;

                        TextOut( drawingPoint.x, drawingPoint.y, textStringIn );
                    end;

end.
