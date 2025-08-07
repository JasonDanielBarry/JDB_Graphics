unit Direct2DLTEntityCanvasClass;

{
The fundamental drawing entities from which all 2D graphics can be created are
    1. Arcs
    2. Ellipses
    3. Lines
    4. Polylines
    5. Polygons
    6. Rectangles (with rounded corners, corner radius of 0 is a standard rectangle)
    7. Text
}

interface

    uses
        Winapi.D2D1,
        System.SysUtils, system.Math, system.Types, System.UITypes,
        Vcl.Direct2D, Vcl.Graphics, vcl.Themes,
        Direct2DCustomCanvasClass,
        Direct2DDrawingEntityFactoryClass
        ;

    type
        TDirect2DLTEntityCanvas = class( TDirect2DCustomCanvas )
            private
                class var
                    D2DEntityFactory : TDirect2DDrawingEntityFactory;
                //entity factory create and destroy
                    class procedure initialiseEntityFactory(); static;
                    class procedure finaliseEntityFactory(); static;
            protected
                //draw text
                    procedure printLTTextF( const   textSizeIn              : integer;
                                            const   textStringIn,
                                                    textFontNameIn          : string;
                                            const   textColourIn            : TColor;
                                            const   textStylesIn            : TFontStyles;
                                            const   textHandlePointIn       : TPointF;
                                            const   drawTextUnderlayIn      : boolean = False;
                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top   ); overload;
            public
                //canvas rotation
                    procedure rotateCanvasLT(   const rotationAngleIn           : double;
                                                const rotationReferencePointIn  : TPointF   );
                    procedure resetCanvasRotation();
                //drawing entities
                    //arc
                        procedure drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                                const   startAngleIn, endAngleIn,
                                                        arcHorRadiusIn, arcVertRadiusIn : double;
                                                const   centrePointIn                   : TPointF   );
                    //ellipse
                        procedure drawLTEllipseF(   const   filledIn, outlinedIn    : boolean;
                                                    const   ellipseWidthIn,
                                                            ellipseHeightIn         : double;
                                                    const   handlePointIn           : TPointF;
                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    );
                    //line
                        procedure drawLTLineF(const arrDrawingPointsIn : TArray<TPointF>); overload;
                        procedure drawLTLineF(const startPointIn, endPointIn : TPointF); overload;
                    //polyline
                        procedure drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                    //polygon
                        procedure drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                    const arrDrawingPointsIn    : TArray<TPointF> );
                    //rectangle
                        procedure drawLTRectangleF( const   filledIn, outlinedIn    : boolean;
                                                    const   widthIn, heightIn,
                                                            cornerRadiusHorIn,
                                                            cornerRadiusVertIn      : double;
                                                    const   handlePointIn           : TPointF;
                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    ); overload;
                        procedure drawLTRectangleF( const   filledIn, outlinedIn    : boolean;
                                                    const   widthIn, heightIn,
                                                            cornerRadiusIn          : double;
                                                    const   handlePointIn           : TPointF;
                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    ); overload;
                    //text
                        procedure printLTTextF( const textStringIn          : string;
                                                const textHandlePointIn     : TPointF;
                                                const drawTextUnderlayIn    : boolean = False;
                                                const horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Left;
                                                const verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Top   ); overload;

        end;

implementation

    //private
        //entity factory
            class procedure TDirect2DLTEntityCanvas.initialiseEntityFactory();
                begin
                    D2DEntityFactory := TDirect2DDrawingEntityFactory.create();
                end;

            class procedure TDirect2DLTEntityCanvas.finaliseEntityFactory();
                begin
                    FreeAndNil( D2DEntityFactory );
                end;

    //protected
        //draw text
            procedure TDirect2DLTEntityCanvas.printLTTextF( const   textSizeIn              : integer;
                                                            const   textStringIn,
                                                                    textFontNameIn          : string;
                                                            const   textColourIn            : TColor;
                                                            const   textStylesIn            : TFontStyles;
                                                            const   textHandlePointIn       : TPointF;
                                                            const   drawTextUnderlayIn      : boolean = False;
                                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top   );
                begin
                    setFontTextProperties( textSizeIn, textColourIn, textStylesIn, textFontNameIn );

                    printLTTextF(   textStringIn,
                                    textHandlePointIn,
                                    drawTextUnderlayIn,
                                    horizontalAlignmentIn,
                                    verticalAlignmentIn     );
                end;


    //public
        //canvas rotation
            procedure TDirect2DLTEntityCanvas.rotateCanvasLT(   const rotationAngleIn           : double;
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

            procedure TDirect2DLTEntityCanvas.resetCanvasRotation();
                begin
                    RenderTarget.SetTransform( TD2DMatrix3x2F.Identity );
                end;

        //drawing entities
            //arc
                procedure TDirect2DLTEntityCanvas.drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                                                const   startAngleIn, endAngleIn,
                                                                        arcHorRadiusIn, arcVertRadiusIn : double;
                                                                const   centrePointIn                   : TPointF   );
                    var
                        arcPathGeometry : ID2D1PathGeometry;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        arcPathGeometry := D2DEntityFactory.createArcPathGeometry(  filledIn,
                                                                                    startAngleIn, endAngleIn,
                                                                                    arcHorRadiusIn, arcVertRadiusIn,
                                                                                    centrePointIn                   );

                        //fill arc shape
                            if ( filledIn ) then
                                FillGeometry( arcPathGeometry );

                        //draw arc line
                            if ( outlinedIn ) then
                                DrawGeometry( arcPathGeometry );
                    end;

            //ellipse
                procedure TDirect2DLTEntityCanvas.drawLTEllipseF(   const   filledIn, outlinedIn    : boolean;
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
                            drawingEllipse := D2DEntityFactory.createEllipseGeometry(   ellipseWidthIn, ellipseHeightIn,
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
                procedure TDirect2DLTEntityCanvas.drawLTLineF(const arrDrawingPointsIn : TArray<TPointF>);
                    var
                        lineGeometry : ID2D1PathGeometry;
                    begin
                        lineGeometry := D2DEntityFactory.createOpenPathGeometry( arrDrawingPointsIn );

                        DrawGeometry( lineGeometry );
                    end;

                procedure TDirect2DLTEntityCanvas.drawLTLineF(const startPointIn, endPointIn : TPointF);
                    var
                        drawingPoints : TArray<TPointF>;
                    begin
                        SetLength( drawingPoints, 2 );

                        drawingPoints[0] := startPointIn;
                        drawingPoints[1] := endPointIn;

                        drawLTLineF( drawingPoints );
                    end;

            //polyline
                procedure TDirect2DLTEntityCanvas.drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                    var
                        polylineGeometry : ID2D1PathGeometry;
                    begin
                        polylineGeometry := D2DEntityFactory.createOpenPathGeometry( arrDrawingPointsIn );

                        DrawGeometry( polylineGeometry );
                    end;

            //polygon
                procedure TDirect2DLTEntityCanvas.drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                                    const arrDrawingPointsIn    : TArray<TPointF>   );
                    var
                        polygonGeometry : ID2D1PathGeometry;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        polygonGeometry := D2DEntityFactory.createClosedPathGeometry( arrDrawingPointsIn );

                        if ( filledIn ) then
                            FillGeometry( polygonGeometry );

                        if ( outlinedIn ) then
                            DrawGeometry( polygonGeometry );
                    end;

            //rectangle
                procedure TDirect2DLTEntityCanvas.drawLTRectangleF( const   filledIn, outlinedIn    : boolean;
                                                                    const   widthIn, heightIn,
                                                                            cornerRadiusHorIn,
                                                                            cornerRadiusVertIn      : double;
                                                                    const   handlePointIn           : TPointF;
                                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center );
                    var
                        drawingRect : TD2D1RoundedRect;
                    begin
                        if NOT( filledIn OR outlinedIn ) then
                            exit();

                        drawingRect := D2DEntityFactory.createRectangleGeometry(    widthIn, heightIn,
                                                                                    cornerRadiusHorIn,
                                                                                    cornerRadiusVertIn,
                                                                                    horizontalAlignmentIn,
                                                                                    verticalAlignmentIn,
                                                                                    handlePointIn           );

                        if ( filledIn ) then
                            FillRoundedRectangle( drawingRect );

                        if ( outlinedIn ) then
                            DrawRoundedRectangle( drawingRect );
                    end;

                procedure TDirect2DLTEntityCanvas.drawLTRectangleF( const   filledIn, outlinedIn    : boolean;
                                                                    const   widthIn, heightIn,
                                                                            cornerRadiusIn          : double;
                                                                    const   handlePointIn           : TPointF;
                                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    );
                    begin
                        drawLTRectangleF(   filledIn, outlinedIn,
                                            widthIn, heightIn,
                                            cornerRadiusIn, cornerRadiusIn,
                                            handlePointIn,
                                            horizontalAlignmentIn,
                                            verticalAlignmentIn             );
                    end;

            //text
                procedure TDirect2DLTEntityCanvas.printLTTextF( const textStringIn          : string;
                                                                const textHandlePointIn     : TPointF;
                                                                const drawTextUnderlayIn    : boolean = False;
                                                                const horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Left;
                                                                const verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Top   );
                    var
                        mustCalculateDrawingPoint   : boolean;
                        textExtent                  : TSize;
                        drawingPoint                : TPoint;
                    begin
                        //check if drawing point must be calculated - True if alignment is NOT top left
                        // NOT( A AND B ) = NOT(A) OR NOT(B)
                            mustCalculateDrawingPoint := ( horizontalAlignmentIn <> THorzRectAlign.Left ) OR ( verticalAlignmentIn <> TVertRectAlign.Top );

                        //calculate the drawing point
                            if ( mustCalculateDrawingPoint ) then
                                begin
                                    //measure text extent
                                        textExtent := measureTextExtent( textStringIn, Font.Size, Font.Style, Font.Name );

                                    //calculate drawing point
                                        drawingPoint := D2DEntityFactory.calculateTextDrawingPoint( textExtent,
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
                                    Brush.Color := localBackgroundColour;
                                    Brush.Style := TBrushStyle.bsSolid;
                                end
                            else
                                Brush.Style := TBrushStyle.bsClear;

                        TextOut( drawingPoint.x, drawingPoint.y, textStringIn );
                    end;

initialization

    TDirect2DLTEntityCanvas.initialiseEntityFactory();

finalization

    TDirect2DLTEntityCanvas.finaliseEntityFactory();

end.
