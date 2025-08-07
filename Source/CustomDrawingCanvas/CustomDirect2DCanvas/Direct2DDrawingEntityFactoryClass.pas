unit Direct2DDrawingEntityFactoryClass;

interface

    uses
        Winapi.D2D1,
        System.Threading, system.SysUtils, system.Math, system.Types,
        Vcl.Direct2D;

    type
        TDirect2DDrawingEntityFactory = class
            private
                class var
                    D2DGeometryFactory : ID2D1Factory;
                //entity factory create and destroy
                    class procedure initialiseEntityFactory(); static;
                //create generic path geometry
                    class function createGenericPathGeometry(   const figureBeginIn         : D2D1_FIGURE_BEGIN;
                                                                const figureEndIn           : D2D1_FIGURE_END;
                                                                const arrDrawingPointsIn    : TArray<TPointF>   ) : ID2D1PathGeometry; static;
            public
                //create arc geometry
                    class function createArcPathGeometry(   const   filledIn                        : boolean;
                                                            const   startAngleIn, endAngleIn,
                                                                    arcHorRadiusIn, arcVertRadiusIn : double;
                                                            const   centrePointIn                   : TPointF ) : ID2D1PathGeometry; static;
                //create ellipse geometry
                    class function createEllipseGeometry(   const   ellipseWidthIn,
                                                                    ellipseHeightIn         : double;
                                                            const   horizontalAlignmentIn   : THorzRectAlign;
                                                            const   verticalAlignmentIn     : TVertRectAlign;
                                                            const   handlePointIn           : TPointF       ) : TD2D1Ellipse; static;
                //generic path geometry
                    //create closed geometry
                        class function createClosedPathGeometry(const arrDrawingPointsIn : TArray<TPointF>) : ID2D1PathGeometry; static;
                    //create open geometry
                        class function createOpenPathGeometry(const arrDrawingPointsIn : TArray<TPointF>) : ID2D1PathGeometry; static;
                //create rectangle geometry
                    class function createRectangleGeometry( const   widthIn, heightIn,
                                                                    cornerRadiusHorIn,
                                                                    cornerRadiusVertIn      : double;
                                                            const   horizontalAlignmentIn   : THorzRectAlign;
                                                            const   verticalAlignmentIn     : TVertRectAlign;
                                                            const   handlePointIn           : TPointF           ) : TD2D1RoundedRect; static;
    end;

implementation

    //private
        //entity factory
            class procedure TDirect2DDrawingEntityFactory.initialiseEntityFactory();
                begin
                    D2DGeometryFactory := D2DFactory( D2D1_FACTORY_TYPE.D2D1_FACTORY_TYPE_MULTI_THREADED );
                end;

    //public
        //constructor
            constructor TDirect2DDrawingEntityFactory.create();
                begin
                    inherited create();

                    D2DGeometryFactory := D2DFactory( D2D1_FACTORY_TYPE.D2D1_FACTORY_TYPE_MULTI_THREADED );
                end;

        //destructor
            destructor TDirect2DDrawingEntityFactory.destroy();
                begin
                    inherited destroy();
                end;

    //ARC-------------------------------------------------------------------------------------------------------------
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
            function normaliseAngle(const angleIn : double) : double;
                begin
                    if ( 360 < abs( angleIn ) ) then
                        result := FMod( angleIn, 360 )
                    else
                        result := angleIn;
                end;

            function TDirect2DDrawingEntityFactory.createArcPathGeometry(   const   filledIn                        : boolean;
                                                                            const   startAngleIn, endAngleIn,
                                                                                    arcHorRadiusIn, arcVertRadiusIn : double;
                                                                            const   centrePointIn                   : TPointF   ) : ID2D1PathGeometry;
                var
                    normStartAngle,
                    normEndAngle            : double;
                    figureEnd               : D2D1_FIGURE_END;
                    geometrySink            : ID2D1GeometrySink;
                    pathGeometryOut         : ID2D1PathGeometry;
                    startPoint, endPoint    : TPointF;
                    arcSegment              : TD2D1ArcSegment;
                begin
                    //normalise start and end angles
                        normStartAngle  := normaliseAngle( startAngleIn );
                        normEndAngle    := normaliseAngle( endAngleIn );

                        if ( SameValue( normStartAngle, normEndAngle, 1e-3 ) ) then
                            exit();

                    //get start and end points
                        calculateArcStartAndEndPoints(  normStartAngle, normEndAngle,
                                                        arcHorRadiusIn, arcVertRadiusIn,
                                                        centrePointIn,
                                                        startPoint, endPoint            );

                    //create arc segment
                        arcSegment := createArcSegment( normStartAngle, normEndAngle, arcHorRadiusIn, arcVertRadiusIn, endPoint );

                    //create path geometry
                        D2DGeometryFactory.CreatePathGeometry( pathGeometryOut );

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
            procedure calculateEllipseCentreCoordinates(const horizontalAlignmentIn : THorzRectAlign;
                                                        const verticalAlignmentIn   : TVertRectAlign;
                                                        const ellipseIn             : TD2D1Ellipse;
                                                        const handlePointIn         : TPointF;
                                                        out ellipseCentreXOut,
                                                            ellipseCentreYOut       : double        );
                begin
                    case ( horizontalAlignmentIn ) of
                        THorzRectAlign.Left: //centre to the right of handle point
                            ellipseCentreXOut := handlePointIn.X + ellipseIn.radiusX;

                        THorzRectAlign.Center:
                            ellipseCentreXOut := handlePointIn.X;

                        THorzRectAlign.Right: //centre to the left of handle point
                            ellipseCentreXOut := handlePointIn.X - ellipseIn.radiusX;
                    end;

                    case ( verticalAlignmentIn ) of
                        TVertRectAlign.Bottom: //centre above handle point
                            ellipseCentreYOut := handlePointIn.y - ellipseIn.radiusY;

                        TVertRectAlign.Center:
                            ellipseCentreYOut := handlePointIn.y;

                        TVertRectAlign.Top: //centre below handle point
                            ellipseCentreYOut := handlePointIn.y + ellipseIn.radiusY;
                    end;
                end;

            function TDirect2DDrawingEntityFactory.createEllipseGeometry(   const   ellipseWidthIn,
                                                                                    ellipseHeightIn         : double;
                                                                            const   horizontalAlignmentIn   : THorzRectAlign;
                                                                            const   verticalAlignmentIn     : TVertRectAlign;
                                                                            const   handlePointIn           : TPointF           ) : TD2D1Ellipse;
                var
                    ellipseCentreX,
                    ellipseCentreY  : double;
                    ellipseOut      : TD2D1Ellipse;
                begin
                    //ellipse size
                        ellipseOut.radiusX := ellipseWidthIn / 2;
                        ellipseOut.radiusY := ellipseHeightIn / 2;

                    //alignment
                        calculateEllipseCentreCoordinates(  horizontalAlignmentIn,
                                                            verticalAlignmentIn,
                                                            ellipseOut,
                                                            handlePointIn,
                                                            ellipseCentreX,
                                                            ellipseCentreY          );

                        ellipseOut.point.x := ellipseCentreX;
                        ellipseOut.point.y := ellipseCentreY;

                    result := ellipseOut;
                end;

    //GEOMETRY--------------------------------------------------------------------------------------------------------
        //create generic path geometry
            class function TDirect2DDrawingEntityFactory.createGenericPathGeometry( const figureBeginIn         : D2D1_FIGURE_BEGIN;
                                                                                    const figureEndIn           : D2D1_FIGURE_END;
                                                                                    const arrDrawingPointsIn    : TArray<TPointF>       ) : ID2D1PathGeometry;
                var
                    i, arrLen       : integer;
                    geometrySink    : ID2D1GeometrySink;
                    pathGeometryOut : ID2D1PathGeometry;
                begin
                    //create path geometry
                        D2DGeometryFactory.CreatePathGeometry( pathGeometryOut );

                    //open path geometry
                        pathGeometryOut.Open( geometrySink );

                    //create geometry sink
                        geometrySink.BeginFigure( D2D1PointF( arrDrawingPointsIn[0].x, arrDrawingPointsIn[0].y ), figureBeginIn );

                    //add lines
                        arrLen := length(arrDrawingPointsIn);

                        //single line
                            if ( arrLen < 3 ) then
                                geometrySink.AddLine( D2D1PointF( arrDrawingPointsIn[1].x, arrDrawingPointsIn[1].y ) )
                        //polyline
                            else
                                for i := 1 to ( arrLen - 1 ) do
                                    geometrySink.AddLine( D2D1PointF( arrDrawingPointsIn[i].x, arrDrawingPointsIn[i].y ) );

                    //end geometry
                        geometrySink.EndFigure( figureEndIn );

                        geometrySink.Close();

                    result := pathGeometryOut;
                end;

        //create closed geometry
            class function TDirect2DDrawingEntityFactory.createClosedPathGeometry(const arrDrawingPointsIn : TArray<TPointF>) : ID2D1PathGeometry;
                begin
                    result := createGenericPathGeometry(
                                                            D2D1_FIGURE_BEGIN.D2D1_FIGURE_BEGIN_FILLED,
                                                            D2D1_FIGURE_END.D2D1_FIGURE_END_CLOSED,
                                                            arrDrawingPointsIn
                                                       );
                end;

        //create open geometry
            class function TDirect2DDrawingEntityFactory.createOpenPathGeometry(const arrDrawingPointsIn : TArray<TPointF>) : ID2D1PathGeometry;
                begin
                    result := createGenericPathGeometry(
                                                            D2D1_FIGURE_BEGIN.D2D1_FIGURE_BEGIN_HOLLOW,
                                                            D2D1_FIGURE_END.D2D1_FIGURE_END_OPEN,
                                                            arrDrawingPointsIn
                                                       );
                end;

    //RECTANGLE-------------------------------------------------------------------------------------------------------
        class function TDirect2DDrawingEntityFactory.createRectangleGeometry(   const   widthIn, heightIn,
                                                                                        cornerRadiusHorIn,
                                                                                        cornerRadiusVertIn      : double;
                                                                                const   horizontalAlignmentIn   : THorzRectAlign;
                                                                                const   verticalAlignmentIn     : TVertRectAlign;
                                                                                const   handlePointIn           : TPointF           ) : TD2D1RoundedRect;
            var
                roundRectOut : TD2D1RoundedRect;
            begin
                //set radius
                    roundRectOut.radiusX := cornerRadiusHorIn;
                    roundRectOut.radiusY := cornerRadiusVertIn;

                //set rectangle bounds
                    case ( horizontalAlignmentIn ) of
                        THorzRectAlign.Left:
                            begin
                                roundRectOut.rect.left   := handlePointIn.X;
                                roundRectOut.rect.right  := handlePointIn.X + widthIn;
                            end;

                        THorzRectAlign.Center:
                            begin
                                roundRectOut.rect.left   := handlePointIn.X - widthIn / 2;
                                roundRectOut.rect.right  := handlePointIn.X + widthIn / 2;
                            end;

                        THorzRectAlign.Right:
                            begin
                                roundRectOut.rect.left   := handlePointIn.X - widthIn;
                                roundRectOut.rect.right  := handlePointIn.X;
                            end;
                    end;

                    case ( verticalAlignmentIn ) of
                        TVertRectAlign.Bottom:
                            begin
                                roundRectOut.rect.bottom := handlePointIn.Y;
                                roundRectOut.rect.top    := handlePointIn.Y - heightIn;
                            end;

                        TVertRectAlign.Center:
                            begin
                                //on the drawing canvas the top value < the bottom value
                                    roundRectOut.rect.bottom := handlePointIn.Y + heightIn / 2;
                                    roundRectOut.rect.top    := handlePointIn.Y - heightIn / 2;
                            end;

                        TVertRectAlign.Top:
                            begin
                                roundRectOut.rect.bottom := handlePointIn.Y + heightIn;
                                roundRectOut.rect.top    := handlePointIn.Y;
                            end;
                    end;

                result := roundRectOut;
            end;

initialization

    TDirect2DDrawingEntityFactory.initialiseEntityFactory();

end.
