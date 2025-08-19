unit CanvasHelperClass;

interface

    uses
        Winapi.Windows,
        system.SysUtils, system.Math, system.Types,
        Vcl.Graphics, vcl.Themes,
        GenericLTEntityDrawingMethods
        ;

    type
        TCanvaHelper = class helper for TCanvas
            private
                function cachePenStyle(const filledIn, outlinedIn : boolean) : TPenStyle;
            public
                //set brush properties
                    procedure setBrushFillProperties(   const solidIn : boolean;
                                                        const colourIn : TColor );
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle );
                //set font properties
                    procedure setFontTextProperties(const sizeIn    : integer;
                                                    const nameIn    : string;
                                                    const colourIn  : TColor;
                                                    const stylesIn  : TFontStyles);
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
                                                    const   centrePointIn           : TPointF   );
                    //polyline
                        procedure drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                    //polygon
                        procedure drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                    const arrDrawingPointsIn    : TArray<TPointF> );
                    //rectangle
                        procedure drawLTRectangleF( const   filledIn, outlinedIn        : boolean;
                                                    const   leftBoundIn, rightBoundIn,
                                                            topBoundIn, bottomBoundIn,
                                                            cornerRadiusHorIn,
                                                            cornerRadiusVertIn          : double    );
                    //text
                        procedure printLTTextF( const textStringIn          : string;
                                                const textDrawingPointIn    : TPointF   );
        end;

implementation

    //private
        function TCanvaHelper.cachePenStyle(const filledIn, outlinedIn : boolean) : TPenStyle;
            var
                cachedPenStyleOut : TPenStyle;
            begin
                cachedPenStyleOut := pen.Style;

                if ( filledIn ) then
                    Brush.Style := TBrushStyle.bsSolid
                else
                    brush.Style := TBrushStyle.bsClear;

                if NOT( outlinedIn ) then
                    pen.Style := TPenStyle.psClear;

                result := cachedPenStyleOut;
            end;

    //public
        //set brush properties
            procedure TCanvaHelper.setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
                begin
                    if NOT( solidIn ) then
                        begin
                            brush.Style := TBrushStyle.bsClear;
                            exit();
                        end;

                    Brush.Style := TBrushStyle.bsSolid;
                    Brush.Color := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                end;

        //set pen properties
            procedure TCanvaHelper.setPenLineProperties(const widthIn   : integer;
                                                        const colourIn  : TColor;
                                                        const styleIn   : TPenStyle );
                begin
                    if ( widthIn < 1 ) then
                        begin
                            pen.Style := TPenStyle.psClear;
                            exit();
                        end;

                    Pen.Color := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                    Pen.Style := styleIn;

                    if ( styleIn <> TPenStyle.psSolid ) then
                        Pen.Width := 1
                    else
                        Pen.Width := widthIn;
                end;

        //set font properties
            procedure TCanvaHelper.setFontTextProperties(   const sizeIn        : integer;
                                                            const nameIn        : string;
                                                            const colourIn      : TColor;
                                                            const stylesIn      : TFontStyles   );
                begin
                    Font.Size   := sizeIn;
                    Font.Name   := nameIn;
                    Font.Color  := TStyleManager.ActiveStyle.GetSystemColor( colourIn );
                    Font.Style  := stylesIn;
                end;

        //canvas rotation
            procedure TCanvaHelper.rotateCanvasLT(  const rotationAngleIn           : double;
                                                    const rotationReferencePointIn  : TPointF   );
                var
                    centreX, centreY,
                    sinComp, cosComp,
                    angleRadians        : double;
                    transformInfo       : XFORM;
                begin
                    //convert from degrees to radians
                    //negative value used because positive angles rotate the canvas anti-clockwise
                    //so negative angles rotate drawing entities anti-clockwise
                        angleRadians := -rotationAngleIn * Pi() / 180;

                    //calculate sin and cos components
                        SinCos( angleRadians, sinComp, cosComp );

                    //write to xFrom
                        transformInfo.eM11 := cosComp;
                        transformInfo.eM12 := sinComp;
                        transformInfo.eM21 := -sinComp;
                        transformInfo.eM22 := cosComp;

                        centreX := rotationReferencePointIn.X;
                        centreY := rotationReferencePointIn.Y;

                        transformInfo.eDx := centreX * (1 - cosComp) + centreY * sinComp;
                        transformInfo.eDy := centreY * (1 - cosComp) - centreX * sinComp;

                    //apply to canvas
                        SetGraphicsMode( self.Handle, GM_ADVANCED );
                        ModifyWorldTransform( self.Handle, transformInfo, MWT_LEFTMULTIPLY );
                end;

            procedure TCanvaHelper.resetCanvasRotation();
                var
                    transformInfo : XFORM;
                begin
                    SetGraphicsMode( self.Handle, GM_ADVANCED );
                    ModifyWorldTransform( self.Handle, transformInfo, MWT_IDENTITY );
                end;

        //drawing entities
            //arc
                procedure TCanvaHelper.drawLTArcF(  const   filledIn, outlinedIn            : boolean;
                                                    const   startAngleIn, endAngleIn,
                                                            arcHorRadiusIn, arcVertRadiusIn : double;
                                                    const   centrePointIn                   : TPointF   );
                    var
                        left, top, right, bottom        : integer;
                        normStartAngle, normEndAngle    : double;
                        centrePoint,
                        startPoint, endPoint            : TPoint;
                        startPointF, endPointF          : TPointF;
                    begin
                        //calculate start and end points
                            normStartAngle  := normaliseAngle( startAngleIn );
                            normEndAngle    := normaliseAngle( endAngleIn );

                            if ( normEndAngle < normStartAngle ) then //swap start and end angle
                                begin
                                    var tempAngle : double;

                                    tempAngle := normStartAngle;
                                    normStartAngle := normEndAngle;
                                    normEndAngle := tempAngle;
                                end;

                            calculateArcStartAndEndLTPoints( normStartAngle, normEndAngle, arcHorRadiusIn, arcVertRadiusIn, centrePointIn, startPointF, endPointF );

                        //get ellipse bounds
                            left    := round( centrePointIn.X - arcHorRadiusIn );
                            top     := round( centrePointIn.Y - arcVertRadiusIn );
                            right   := round( centrePointIn.X + arcHorRadiusIn );
                            bottom  := round( centrePointIn.Y + arcVertRadiusIn );

                        //get start and end points in integer format
                            startPoint  := startPointF.Round();
                            endPoint    := endPointF.Round();

                        //fill arc
                            if ( filledIn ) then
                                begin
                                    self.Pie( left, top, right, bottom, startPoint.X, startPoint.Y, endPoint.X, endPoint.Y );
                                    exit();
                                end;

                        //draw arc
                            if ( outlinedIn ) then
                                self.Arc( left, top, right, bottom, startPoint.X, startPoint.Y, endPoint.X, endPoint.Y );
                    end;

            //ellipse
                procedure TCanvaHelper.drawLTEllipseF(  const   filledIn, outlinedIn    : boolean;
                                                        const   ellipseWidthIn,
                                                                ellipseHeightIn         : double;
                                                        const   centrePointIn           : TPointF   );
                    var
                        left, top, right, bottom    : integer;
                        cachedPenStyle              : TPenStyle;
                    begin
                        left    := round( centrePointIn.X - ellipseWidthIn / 2 );
                        top     := round( centrePointIn.Y - ellipseHeightIn / 2 );
                        right   := round( centrePointIn.X + ellipseWidthIn / 2 );
                        bottom  := round( centrePointIn.Y + ellipseHeightIn / 2 );

                        cachedPenStyle := cachePenStyle( filledIn, outlinedIn );

                        self.Ellipse( left, top, right, bottom );

                        pen.Style := cachedPenStyle;
                    end;

            //polyline
                function convertArrPointFToArrPoint(const arrPointFIn : TArray<TPointF>) : TArray<TPoint>;
                    var
                        i, arrLen       : integer;
                        arrPointsOut    : TArray<TPoint>;
                    begin
                        arrLen := Length( arrPointFIn );

                        SetLength( arrPointsOut, arrLen );

                        for i := 0 to ( arrLen - 1 ) do
                            arrPointsOut[i] := arrPointFIn[i].Round();

                        result := arrPointsOut;
                    end;

                procedure TCanvaHelper.drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                    var
                        arrDrawingPointsLocal : TArray<TPoint>;
                    begin
                        arrDrawingPointsLocal := convertArrPointFToArrPoint( arrDrawingPointsIn );

                        Polyline( arrDrawingPointsLocal );
                    end;

            //polygon
                procedure TCanvaHelper.drawLTPolygonF(  const filledIn, outlinedIn  : boolean;
                                                        const arrDrawingPointsIn    : TArray<TPointF> );
                    var
                        cachedPenStyle          : TPenStyle;
                        arrDrawingPointsLocal   : TArray<TPoint>;
                    begin
                        arrDrawingPointsLocal := convertArrPointFToArrPoint( arrDrawingPointsIn );

                        cachedPenStyle := cachePenStyle( filledIn, outlinedIn );

                        self.Polygon( arrDrawingPointsLocal );

                        pen.Style := cachedPenStyle;
                    end;

            //rectangle
                procedure TCanvaHelper.drawLTRectangleF(const   filledIn, outlinedIn        : boolean;
                                                        const   leftBoundIn, rightBoundIn,
                                                                topBoundIn, bottomBoundIn,
                                                                cornerRadiusHorIn,
                                                                cornerRadiusVertIn          : double );
                    var
                        left, top, right, bottom    : integer;
                        cachedPenStyle              : TPenStyle;
                    begin
                        left    := round( leftBoundIn );
                        top     := round( topBoundIn );
                        right   := round( rightBoundIn );
                        bottom  := round( bottomBoundIn );

                        cachedPenStyle := cachePenStyle( filledIn, outlinedIn );

                        self.RoundRect( Rect( left, top, right, bottom ), round(cornerRadiusHorIn), round(cornerRadiusVertIn) );

                        pen.Style := cachedPenStyle;
                    end;

            //text
                procedure TCanvaHelper.printLTTextF(const textStringIn          : string;
                                                    const textDrawingPointIn    : TPointF);
                    begin
                        self.TextOut( round( textDrawingPointIn.X ), round( textDrawingPointIn.Y ), textStringIn );
                    end;

end.
