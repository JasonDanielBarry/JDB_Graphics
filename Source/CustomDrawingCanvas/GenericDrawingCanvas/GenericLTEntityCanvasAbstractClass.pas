unit GenericLTEntityCanvasAbstractClass;

{
The fundamental drawing entities from which all 2D graphics can be created are
    1. Arcs
    2. Ellipses (equal width and height yields a circle
    3. Lines
    4. Polylines
    5. Polygons
    6. Rectangles (with rounded corners, corner radius of 0 is a standard rectangle)
    7. Text
}

interface

    uses
        system.Types,
        vcl.Graphics,
        GenericCustomCanvasAbstractClass
        ;

    type
        TGenericLTEntityAbstractCanvas = class( TGenericCustomAbstractCanvas )
            private

            protected
                //text
                    procedure printLTTextF( const textStringIn          : string;
                                            const textDrawingPointIn    : TPointF ); overload; virtual; abstract;
            public
                //-------------------------------------------------------------------------------------------------------------------------------------------
                    //virtual abstract drawing entity methods
                        //canvas rotation
                            procedure rotateCanvasLT(   const rotationAngleIn           : double;
                                                        const rotationReferencePointIn  : TPointF   ); virtual; abstract;
                            procedure resetCanvasRotation();  virtual; abstract;
                        //drawing entities
                            //arc
                                procedure drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                                        const   startAngleIn, endAngleIn,
                                                                arcHorRadiusIn, arcVertRadiusIn : double;
                                                        const   centrePointIn                   : TPointF   ); virtual; abstract;
                            //ellipse
                                procedure drawLTEllipseF(   const   filledIn, outlinedIn    : boolean;
                                                            const   ellipseWidthIn,
                                                                    ellipseHeightIn         : double;
                                                            const   handlePointIn           : TPointF;
                                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    ); virtual; abstract;
                            //line
                                procedure drawLTLineF(const arrDrawingPointsIn : TArray<TPointF>); virtual; abstract;
                            //polyline
                                procedure drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>); virtual; abstract;
                            //polygon
                                procedure drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                            const arrDrawingPointsIn    : TArray<TPointF> ); virtual; abstract;
                            //rectangle
                                procedure drawLTRectangleF( const   filledIn, outlinedIn    : boolean;
                                                            const   widthIn, heightIn,
                                                                    cornerRadiusHorIn,
                                                                    cornerRadiusVertIn      : double;
                                                            const   handlePointIn           : TPointF;
                                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center    ); virtual; abstract;
        end;

implementation

    //public
        

end.
