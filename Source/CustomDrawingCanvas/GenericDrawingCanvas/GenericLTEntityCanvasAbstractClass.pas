unit GenericLTEntityCanvasAbstractClass;

{
The fundamental drawing entities from which all 2D graphics can be created are
    1. Arcs
    2. Ellipses (equal width and height yields a circle)
    3. Lines
    4. Polylines
    5. Polygons
    6. Rectangles (with rounded corners, corner radius of 0 is a standard rectangle)
    7. Text
}

interface

    uses
        system.Types,
        GenericCustomCanvasAbstractClass
        ;

    type
        TGenericLTEntityAbstractCanvas = class( TGenericCustomAbstractCanvas )
            protected
                //ellipse
                    procedure drawLTEllipseF_abst(  const   filledIn, outlinedIn    : boolean;
                                                    const   ellipseWidthIn,
                                                            ellipseHeightIn         : double;
                                                    const   centrePointIn           : TPointF   ); virtual; abstract;
                //rectangle
                    procedure drawLTRectangleF_abst(const   filledIn, outlinedIn        : boolean;
                                                    const   leftBoundIn, rightBoundIn,
                                                            topBoundIn, bottomBoundIn,
                                                            cornerRadiusHorIn,
                                                            cornerRadiusVertIn          : double ); virtual; abstract;
                //text
                    procedure printLTTextF_abst(const textStringIn          : string;
                                                const textDrawingPointIn    : TPointF ); virtual; abstract;
            public
                //canvas rotation
                    procedure rotateCanvasLT(   const rotationAngleIn           : double;
                                                const rotationReferencePointIn  : TPointF   ); virtual; abstract;
                    procedure resetCanvasRotation();  virtual; abstract;
                //arc
                    procedure drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                            const   startAngleIn, endAngleIn,
                                                    arcHorRadiusIn, arcVertRadiusIn : double;
                                            const   centrePointIn                   : TPointF   ); virtual; abstract;
                //polyline
                    procedure drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>); virtual; abstract;
                //polygon
                    procedure drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                const arrDrawingPointsIn    : TArray<TPointF> ); virtual; abstract;
        end;

implementation

end.
