unit GenericLTEntityDrawingMethods;

interface

    uses
        system.math, system.types
        ;

    //ARC----------------------------------------------------------------------------------------------
        //normalise angle
            function normaliseAngle(const angleIn : double) : double;

        //calculate an arc's start and end points from the centre and start and end angles
            procedure calculateArcStartAndEndPoints(const   startAngleIn, endAngleIn,
                                                            arcHorRadiusIn, arcVertRadiusIn : double;
                                                    const   centrePointIn                   : TPointF;
                                                    out startPointOut, endPointOut          : TPointF);

    //ELLIPSE------------------------------------------------------------------------------------------
        //calculate ellipse centre point
            procedure calculateEllipseCentreCoordinates(const widthIn, heightIn     : double;
                                                        const horizontalAlignmentIn : THorzRectAlign;
                                                        const verticalAlignmentIn   : TVertRectAlign;
                                                        const handlePointIn         : TPointF;
                                                        out ellipseCentreXOut,
                                                            ellipseCentreYOut       : double        );

    //RECTANGLE----------------------------------------------------------------------------------------
        //calculate rectangle bounds
            procedure calculateRectangleBounds( const widthIn, heightIn         : double;
                                                const horizontalAlignmentIn     : THorzRectAlign;
                                                const verticalAlignmentIn       : TVertRectAlign;
                                                const handlePointIn             : TPointF;
                                                out leftBoundOut, rightBoundOut,
                                                    topBoundOut, bottomBoundOUt : double        );

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
                    sinComponent, cosComponent  : double;
                    pointOut                    : TPointF;
                begin
                    SinCos( DegToRad( pointAngleIn ), sinComponent, cosComponent );

                    pointOut.x := ellipseCentrePointIn.x + ( cosComponent * ellipseWidthIn );
                    pointOut.y := ellipseCentrePointIn.y + ( sinComponent * ellipseHeightIn );

                    result := pointOut;
                end;

        //calculate an arc's start and end points from the centre and start and end angles
            procedure calculateArcStartAndEndPoints(const   startAngleIn, endAngleIn,
                                                            arcHorRadiusIn, arcVertRadiusIn : double;
                                                    const   centrePointIn                   : TPointF;
                                                    out startPointOut, endPointOut          : TPointF);
                begin
                    //find start point
                        startPointOut := calculateEllipsePoint( startAngleIn, arcHorRadiusIn, -arcVertRadiusIn, centrePointIn );

                    //find end point
                        endPointOut := calculateEllipsePoint( endAngleIn, arcHorRadiusIn, -arcVertRadiusIn, centrePointIn );
                end;

    //ELLIPSE-------------------------------------------------------------------------------------------------------------------
        //create ellipse geometry
            procedure calculateEllipseCentreCoordinates(const widthIn, heightIn     : double;
                                                        const horizontalAlignmentIn : THorzRectAlign;
                                                        const verticalAlignmentIn   : TVertRectAlign;
                                                        const handlePointIn         : TPointF;
                                                        out ellipseCentreXOut,
                                                            ellipseCentreYOut       : double        );
                begin
                    //horizontal alignment
                        case ( horizontalAlignmentIn ) of
                            THorzRectAlign.Left: //centre to the right of handle point
                                ellipseCentreXOut := handlePointIn.X + widthIn / 2;

                            THorzRectAlign.Center:
                                ellipseCentreXOut := handlePointIn.X;

                            THorzRectAlign.Right: //centre to the left of handle point
                                ellipseCentreXOut := handlePointIn.X - widthIn / 2;
                        end;

                    //vertical alignment
                        case ( verticalAlignmentIn ) of
                            TVertRectAlign.Bottom: //centre above handle point in LT coordinate system
                                ellipseCentreYOut := handlePointIn.y - heightIn / 2;

                            TVertRectAlign.Center:
                                ellipseCentreYOut := handlePointIn.y;

                            TVertRectAlign.Top: //centre below handle point in LT coordinate system
                                ellipseCentreYOut := handlePointIn.y + heightIn / 2;
                        end;
                end;

    //RECTANGLE-----------------------------------------------------------------------------------------------------------------
        //calculate rectangle bounds
            procedure calculateRectangleBounds( const widthIn, heightIn         : double;
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
                                    leftBoundOut    := handlePointIn.X - widthIn / 2;
                                    rightBoundOut   := handlePointIn.X + widthIn / 2;
                                end;

                            THorzRectAlign.Right:
                                begin
                                    leftBoundOut    := handlePointIn.X - widthIn;
                                    rightBoundOut   := handlePointIn.X;
                                end;
                        end;

                    //vertical alignment
                        case ( verticalAlignmentIn ) of
                            TVertRectAlign.Bottom:
                                begin
                                    bottomBoundOUt  := handlePointIn.Y;
                                    topBoundOut     := handlePointIn.Y - heightIn;
                                end;

                            TVertRectAlign.Center:
                                begin
                                    //on the drawing canvas: top value < bottom value
                                        bottomBoundOUt  := handlePointIn.Y + heightIn / 2;
                                        topBoundOut     := handlePointIn.Y - heightIn / 2;
                                end;

                            TVertRectAlign.Top:
                                begin
                                    bottomBoundOUt  := handlePointIn.Y + heightIn;
                                    topBoundOut     := handlePointIn.Y;
                                end;
                        end;
                end;

end.
