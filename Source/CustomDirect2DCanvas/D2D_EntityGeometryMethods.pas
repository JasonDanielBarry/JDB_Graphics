unit D2D_EntityGeometryMethods;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.Math, system.Types,
        Vcl.Direct2D;

    //create arc geometry
        function createArcPathGeometry( const   filledIn                        : boolean;
                                        const   startAngleIn, endAngleIn,
                                                arcHorRadiusIn, arcVertRadiusIn : double;
                                        const   centrePointIn                   : TPointF ) : ID2D1PathGeometry;

    //create ellipse geometry
        function createEllipseGeometry( const   ellipseWidthIn,
                                                ellipseHeightIn         : double;
                                        const   horizontalAlignmentIn   : THorzRectAlign;
                                        const   verticalAlignmentIn     : TVertRectAlign;
                                        const   handlePointIn           : TPointF       ) : TD2D1Ellipse;

implementation

    //ARC------------------------------------------------------------------------------------------------------------
        //calculate the point on an ellipse given an angle
            function calculateEllipsePoint( const pointAngleIn, ellipseWidthIn, ellipseHeightIn : double;
                                            const ellipseCentrePointIn                          : TPointF) : TPointF;
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

        //create the D2D arc segment from the arc properties
            function createArcSegment(  const   startAngleIn, endAngleIn,
                                                arcHorRadiusIn, arcVertRadiusIn : double;
                                        const   endPointIn                      : TPointF ) : TD2D1ArcSegment;
                var
                    sweepAngle      : double;
                    arcSegmentOut   : TD2D1ArcSegment;
                begin
                    //end point
                        arcSegmentOut.point := D2D1PointF( endPointIn.X, endPointIn.Y );

                    //size
                        arcSegmentOut.size := D2D1SizeF( arcHorRadiusIn, arcVertRadiusIn );

                    //rotation angle
                        ArcSegmentOut.rotationAngle := 0;

                    //sweep angle size
                        sweepAngle := endAngleIn - startAngleIn;

                        if ( 180 < abs( sweepAngle ) ) then
                            ArcSegmentOut.arcSize := D2D1_ARC_SIZE.D2D1_ARC_SIZE_LARGE
                        else
                            ArcSegmentOut.arcSize := D2D1_ARC_SIZE.D2D1_ARC_SIZE_SMALL;

                    //sweep angle direction
                        if ( 0 < sweepAngle ) then
                            ArcSegmentOut.sweepDirection := D2D1_SWEEP_DIRECTION.D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE
                        else
                            ArcSegmentOut.sweepDirection := D2D1_SWEEP_DIRECTION.D2D1_SWEEP_DIRECTION_CLOCKWISE;

                    result := arcSegmentOut;
                end;

        //create arc geometry
            function createArcPathGeometry( const   filledIn                    : boolean;
                                            const   startAngleIn, endAngleIn,
                                                    arcHorRadiusIn, arcVertRadiusIn     : double;
                                            const   centrePointIn               : TPointF ) : ID2D1PathGeometry;
                var
                    figureEnd               : D2D1_FIGURE_END;
                    geometrySink            : ID2D1GeometrySink;
                    pathGeometryOut         : ID2D1PathGeometry;
                    startPoint, endPoint    : TPointF;
                    arcSegment              : TD2D1ArcSegment;
                begin
                    //get start and end points
                        calculateArcStartAndEndPoints(  startAngleIn, endAngleIn,
                                                        arcHorRadiusIn, arcVertRadiusIn,
                                                        centrePointIn,
                                                        startPoint, endPoint        );

                    //create arc segment
                        arcSegment := createArcSegment( startAngleIn, endAngleIn, arcHorRadiusIn, arcVertRadiusIn, endPoint );

                    //create path geometry
                        D2DFactory( D2D1_FACTORY_TYPE.D2D1_FACTORY_TYPE_MULTI_THREADED ).CreatePathGeometry( pathGeometryOut );

                        //open geometry
                            pathGeometryOut.Open( geometrySink );

                        //determine figure-end condition
                            if ( filledIn ) then
                                begin
                                    figureEnd := D2D1_FIGURE_END.D2D1_FIGURE_END_CLOSED;

                                    //filled arcs start and end at their centre
                                        geometrySink.BeginFigure( D2D1PointF( centrePointIn.x, centrePointIn.y ), D2D1_FIGURE_BEGIN.D2D1_FIGURE_BEGIN_FILLED );

                                        geometrySink.AddLine( D2D1PointF( startPoint.X, startPoint.Y ) );
                                end
                            else
                                begin
                                    figureEnd := D2D1_FIGURE_END.D2D1_FIGURE_END_OPEN;

                                    geometrySink.BeginFigure( D2D1PointF( startPoint.x, startPoint.y ), D2D1_FIGURE_BEGIN.D2D1_FIGURE_BEGIN_HOLLOW );
                                end;

                        //add arc
                            geometrySink.AddArc( arcSegment );

                        //end and close
                            geometrySink.EndFigure( figureEnd );

                            geometrySink.Close();

                    result := pathGeometryOut;
                end;

    //ELLIPSE---------------------------------------------------------------------------------------------------------
        //create ellipse geometry
            function createEllipseGeometry( const   ellipseWidthIn,
                                                    ellipseHeightIn         : double;
                                            const   horizontalAlignmentIn   : THorzRectAlign;
                                            const   verticalAlignmentIn     : TVertRectAlign;
                                            const   handlePointIn           : TPointF       ) : TD2D1Ellipse;
                var
                    ellipseCentreX,
                    ellipseCentreY  : double;
                    ellipseOut      : TD2D1Ellipse;
                begin
                    //ellipse size
                        ellipseOut.radiusX := ellipseWidthIn / 2;
                        ellipseOut.radiusY := ellipseHeightIn / 2;

                    //alignment
                        case ( horizontalAlignmentIn ) of
                            THorzRectAlign.Left:
                                ellipseCentreX := handlePointIn.X + ellipseOut.radiusX;

                            THorzRectAlign.Center:
                                ellipseCentreX := handlePointIn.X;

                            THorzRectAlign.Right:
                                ellipseCentreX := handlePointIn.X - ellipseOut.radiusX;
                        end;

                        case ( verticalAlignmentIn ) of
                            TVertRectAlign.Bottom:
                                ellipseCentreY := handlePointIn.y + ellipseOut.radiusY;

                            TVertRectAlign.Center:
                                ellipseCentreY := handlePointIn.y;

                            TVertRectAlign.Top:
                                ellipseCentreY := handlePointIn.y - ellipseOut.radiusY;
                        end;

                        ellipseOut.point.x := ellipseCentreX;
                        ellipseOut.point.y := ellipseCentreY;

                    result := ellipseOut;
                end;



end.
