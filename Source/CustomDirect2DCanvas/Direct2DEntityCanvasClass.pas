unit Direct2DEntityCanvasClass;

interface

    uses
        Winapi.D2D1,
        system.Types,
        Vcl.Direct2D, Vcl.Graphics,
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
                        procedure drawLineF(const startPointIn, endPointIn : TPointF);
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
                procedure TDirect2DEntityCanvas.drawLineF(const startPointIn, endPointIn : TPointF);
                    var
                        lineGeometry    : ID2D1PathGeometry;
                        drawingPoints   : TArray<TPointF>;
                    begin
                        SetLength( drawingPoints, 2 );

                        drawingPoints[0] := startPointIn;
                        drawingPoints[1] := endPointIn;

                        lineGeometry := createOpenPathGeometry( drawingPoints );

                        DrawGeometry( lineGeometry );
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

end.
