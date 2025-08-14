unit GenericLTEntityDrawingMethods;

interface

    uses
        system.SysUtils, system.math, system.types,
        vcl.Graphics
        ;

    //ARC----------------------------------------------------------------------------------------------
        //normalise angle
            function normaliseAngle(const angleIn : double) : double;

        //calculate an arc's start and end points from the centre and start and end angles
            procedure calculateArcStartAndEndLTPoints(  const   startAngleIn, endAngleIn,
                                                                arcHorRadiusIn, arcVertRadiusIn : double;
                                                        const   centrePointIn                   : TPointF;
                                                        out startPointOut, endPointOut          : TPointF   );

    //ELLIPSE------------------------------------------------------------------------------------------
        //calculate ellipse centre point
            function calculateEllipseCentreLTPoint( const widthIn, heightIn     : double;
                                                    const horizontalAlignmentIn : THorzRectAlign;
                                                    const verticalAlignmentIn   : TVertRectAlign;
                                                    const handlePointIn         : TPointF       ) : TPointF;

    //RECTANGLE----------------------------------------------------------------------------------------
        //calculate rectangle bounds
            procedure calculateRectangleLTBounds(   const widthIn, heightIn         : double;
                                                    const horizontalAlignmentIn     : THorzRectAlign;
                                                    const verticalAlignmentIn       : TVertRectAlign;
                                                    const handlePointIn             : TPointF;
                                                    out leftBoundOut, rightBoundOut,
                                                        topBoundOut, bottomBoundOUt : double            );

    //TEXT---------------------------------------------------------------------------------------------
        //measure text size on canvas
            function measureTextLTExtent(   const textStringIn      : string;
                                            const textSizeIn        : integer = 9;
                                            const textFontStylesIn  : TFontStyles = [];
                                            const textNameIn        : string = 'Segoe UI'   ) : TSize;

        //text top left point for drawing
            function calculateTextLTDrawingPoint(   const   textSizeIn              : integer;
                                                    const   textStringIn,
                                                            textNameIn              : string;
                                                    const   textFontStylesIn        : TFontStyles;
                                                    const   horizontalAlignmentIn   : THorzRectAlign;
                                                    const   verticalAlignmentIn     : TVertRectAlign;
                                                    const   textHandlePointIn       : TPointF           ) : TPointF; overload;

implementation

    //ARC-----------------------------------------------------------------------------------------------------------------------
        //normalise angle
            function normaliseAngle(const angleIn : double) : double;
                begin
                    if ( 360 < abs( angleIn ) ) then
                        result := FMod( angleIn, 360 )
                    else
                        result := angleIn;
                end;

        //calculate the point on an ellipse given an angle
            function calculateEllipsePoint( const pointAngleIn, ellipseWidthIn, ellipseHeightIn : double;
                                            const ellipseCentrePointIn                          : TPointF ) : TPointF;
                var
                    angleRadians,
                    sinComponent, cosComponent  : double;
                    pointOut                    : TPointF;
                begin
                    angleRadians := DegToRad( pointAngleIn );

                    SinCos( angleRadians, sinComponent, cosComponent );

                    pointOut.x := ellipseCentrePointIn.x + ( cosComponent * ellipseWidthIn );
                    pointOut.y := ellipseCentrePointIn.y + ( sinComponent * ellipseHeightIn );

                    result := pointOut;
                end;

        //calculate an arc's start and end points from the centre and start and end angles
            procedure calculateArcStartAndEndLTPoints(  const   startAngleIn, endAngleIn,
                                                                arcHorRadiusIn, arcVertRadiusIn : double;
                                                        const   centrePointIn                   : TPointF;
                                                        out startPointOut, endPointOut          : TPointF   );
                begin
                    //NOTE: arcVertRadiusIn is negative because drawing canvas top = 0 and increases downwards

                    //find start point
                        startPointOut := calculateEllipsePoint( startAngleIn, arcHorRadiusIn, -arcVertRadiusIn, centrePointIn );

                    //find end point
                        endPointOut := calculateEllipsePoint( endAngleIn, arcHorRadiusIn, -arcVertRadiusIn, centrePointIn );
                end;

    //ELLIPSE-------------------------------------------------------------------------------------------------------------------
        //create ellipse geometry
            function calculateEllipseCentreLTPoint( const widthIn, heightIn     : double;
                                                    const horizontalAlignmentIn : THorzRectAlign;
                                                    const verticalAlignmentIn   : TVertRectAlign;
                                                    const handlePointIn         : TPointF       ) : TPointF;
                var
                    pointOut : TPointF;
                begin
                    //horizontal alignment
                        case ( horizontalAlignmentIn ) of
                            THorzRectAlign.Left: //centre to the right of handle point
                                pointOut.X := handlePointIn.X + widthIn / 2;

                            THorzRectAlign.Center:
                                pointOut.X := handlePointIn.X;

                            THorzRectAlign.Right: //centre to the left of handle point
                                pointOut.X := handlePointIn.X - widthIn / 2;
                        end;

                    //vertical alignment
                        case ( verticalAlignmentIn ) of
                            TVertRectAlign.Bottom: //centre above handle point in LT coordinate system
                                pointOut.Y := handlePointIn.Y - heightIn / 2;

                            TVertRectAlign.Center:
                                pointOut.Y := handlePointIn.Y;

                            TVertRectAlign.Top: //centre below handle point in LT coordinate system
                                pointOut.Y := handlePointIn.Y + heightIn / 2;
                        end;

                    result := pointOut;
                end;

    //RECTANGLE-----------------------------------------------------------------------------------------------------------------
        //calculate rectangle bounds
            procedure calculateRectangleLTBounds(   const widthIn, heightIn         : double;
                                                    const horizontalAlignmentIn     : THorzRectAlign;
                                                    const verticalAlignmentIn       : TVertRectAlign;
                                                    const handlePointIn             : TPointF;
                                                    out leftBoundOut, rightBoundOut,
                                                        topBoundOut, bottomBoundOUt : double        );
                begin
                    //horizontal alignment
                        case ( horizontalAlignmentIn ) of
                            THorzRectAlign.Left:
                                begin
                                    leftBoundOut    := handlePointIn.X;
                                    rightBoundOut   := handlePointIn.X + widthIn;
                                end;

                            THorzRectAlign.Center:
                                begin
                                    var halfWidth : double := widthIn / 2;

                                    leftBoundOut    := handlePointIn.X - halfWidth;
                                    rightBoundOut   := handlePointIn.X + halfWidth;
                                end;

                            THorzRectAlign.Right:
                                begin
                                    leftBoundOut    := handlePointIn.X - widthIn;
                                    rightBoundOut   := handlePointIn.X;
                                end;
                        end;

                    //vertical alignment - on the drawing canvas: top value < bottom value
                        case ( verticalAlignmentIn ) of
                            TVertRectAlign.Bottom:
                                begin
                                    bottomBoundOUt  := handlePointIn.Y;
                                    topBoundOut     := handlePointIn.Y - heightIn;
                                end;

                            TVertRectAlign.Center:
                                begin
                                    var halfHeight : double := heightIn / 2;

                                    bottomBoundOUt  := handlePointIn.Y + halfHeight;
                                    topBoundOut     := handlePointIn.Y - halfHeight;
                                end;

                            TVertRectAlign.Top:
                                begin
                                    bottomBoundOUt  := handlePointIn.Y + heightIn;
                                    topBoundOut     := handlePointIn.Y;
                                end;
                        end;
                end;

    //TEXT----------------------------------------------------------------------------------------------------------------------
        var textSizeMeasuringBitmap : TBitmap;

        //measure text size on canvas
            function measureTextLTExtent(   const textStringIn      : string;
                                            const textSizeIn        : integer = 9;
                                            const textFontStylesIn  : TFontStyles = [];
                                            const textNameIn        : string = 'Segoe UI' ) : TSize;
                    var
                        i, arrLen       : integer;
                        tempSize,
                        textExtentOut   : TSize;
                        stringArray     : TArray<string>;
                    begin
                        //assign settings to bitmap
                            textSizeMeasuringBitmap.Canvas.font.Size    := textSizeIn;
                            textSizeMeasuringBitmap.Canvas.font.Style   := textFontStylesIn;
                            textSizeMeasuringBitmap.Canvas.font.Name    := textNameIn;

                        //split the string using line breaks as delimiter
                            stringArray := textStringIn.Split( [sLineBreak] );
                            arrLen      := length( stringArray );

                        //calculate the extent (size) of the text
                            if ( 1 < arrLen ) then
                                begin
                                    textExtentOut.Width     := 0;
                                    textExtentOut.Height    := 0;

                                    for i := 0 to (arrLen - 1) do
                                        begin
                                            tempSize := textSizeMeasuringBitmap.Canvas.TextExtent( stringArray[i] );

                                            textExtentOut.Width     := max( tempSize.Width, textExtentOut.Width );
                                            textExtentOut.Height    := textExtentOut.Height + tempSize.Height;
                                        end;
                                end
                            else
                                textExtentOut := textSizeMeasuringBitmap.Canvas.TextExtent( textStringIn );

                        result := textExtentOut;
                    end;

        //text top left point for drawing
            procedure calculateTextAlignmentTranslation(const textExtentIn              : TSize;
                                                        const horizontalAlignmentIn     : THorzRectAlign;
                                                        const verticalAlignmentIn       : TVertRectAlign;
                                                        out horizontalShiftOut,
                                                            verticalShiftOut            : double        );
                begin
                    //horizontal - translation
                        case ( horizontalAlignmentIn ) of
                            THorzRectAlign.Left:
                                horizontalShiftOut := 0;

                            THorzRectAlign.Center:
                                horizontalShiftOut := textExtentIn.Width / 2;

                            THorzRectAlign.Right:
                                horizontalShiftOut := textExtentIn.Width;
                        end;

                    //vertical - translation
                        case ( verticalAlignmentIn ) of
                            TVertRectAlign.Top:
                                verticalShiftOut := 0;

                            TVertRectAlign.Center:
                                verticalShiftOut := textExtentIn.Height / 2;

                            TVertRectAlign.Bottom:
                                verticalShiftOut := textExtentIn.Height;
                        end;
                end;

            function calculateTextLTDrawingPoint(   const textExtentIn              : TSize;
                                                    const horizontalAlignmentIn     : THorzRectAlign;
                                                    const verticalAlignmentIn       : TVertRectAlign;
                                                    const textHandlePointIn         : TPointF           ) : TPointF; overload;
                var
                    horShift, vertShift     : double;
                    textLTDrawingPointOut   : TPointF;
                begin
                    calculateTextAlignmentTranslation(  textExtentIn,
                                                        horizontalAlignmentIn,
                                                        verticalAlignmentIn,
                                                        horShift, vertShift     );

                    textLTDrawingPointOut.x := textHandlePointIn.x - horShift;
                    textLTDrawingPointOut.y := textHandlePointIn.y - vertShift;

                    result := textLTDrawingPointOut;
                end;

            function calculateTextLTDrawingPoint(   const   textSizeIn              : integer;
                                                    const   textStringIn,
                                                            textNameIn              : string;
                                                    const   textFontStylesIn        : TFontStyles;
                                                    const   horizontalAlignmentIn   : THorzRectAlign;
                                                    const   verticalAlignmentIn     : TVertRectAlign;
                                                    const   textHandlePointIn       : TPointF           ) : TPointF;
                var
                    handlePointIsDrawingPoint   : boolean;
                    textExtent                  : TSize;
                begin
                    //check if drawing point must be calculated - True if alignment is NOT top left
                        handlePointIsDrawingPoint := ( horizontalAlignmentIn = THorzRectAlign.Left ) AND ( verticalAlignmentIn = TVertRectAlign.Top );

                        if ( handlePointIsDrawingPoint ) then
                            exit( textHandlePointIn );

                    //calculate the text size
                        textExtent := measureTextLTExtent( textStringIn, textSizeIn, textFontStylesIn, textNameIn );

                    //calculate and return drawing point
                        result := calculateTextLTDrawingPoint( textExtent, horizontalAlignmentIn, verticalAlignmentIn, textHandlePointIn );
                end;

initialization

    textSizeMeasuringBitmap := TBitmap.Create( 100, 100 ); //these dimensions are not important

finalization

    FreeAndNil( textSizeMeasuringBitmap );

end.
