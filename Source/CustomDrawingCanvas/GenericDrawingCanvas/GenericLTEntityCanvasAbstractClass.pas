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
        TGenericLTEntityCanvas = class( TGenericCustomAbstractCanvas )
            private
                //text top left point for drawing
                    class function calculateTextLTDrawingPoint( const textExtentIn              : TSize;
                                                                const horizontalAlignmentIn     : THorzRectAlign;
                                                                const verticalAlignmentIn       : TVertRectAlign;
                                                                const textHandlePointIn         : TPointF           ) : TPointF; static;
            protected
                //draw text
                    procedure printLTTextF( const   drawTextUnderlayIn      : boolean;
                                            const   textSizeIn              : integer;
                                            const   textStringIn,
                                                    textFontNameIn          : string;
                                            const   textColourIn            : TColor;
                                            const   textStylesIn            : TFontStyles;
                                            const   textHandlePointIn       : TPointF;
                                            const   horizontalAlignmentIn   : THorzRectAlign;
                                            const   verticalAlignmentIn     : TVertRectAlign); overload;
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
                        //text
                            procedure printLTTextF( const textStringIn          : string;
                                                    const textDrawingPointIn    : TPointF ); overload; virtual; abstract;
            public


        end;

implementation

    //private
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

            class function TGenericLTEntityCanvas.calculateTextLTDrawingPoint(  const textExtentIn              : TSize;
                                                                                const horizontalAlignmentIn     : THorzRectAlign;
                                                                                const verticalAlignmentIn       : TVertRectAlign;
                                                                                const textHandlePointIn         : TPointF           ) : TPointF;
                var
                    horShift, vertShift : double;
                    pointOut            : TPointF;
                begin
                    calculateTextAlignmentTranslation(  textExtentIn,
                                                        horizontalAlignmentIn,
                                                        verticalAlignmentIn,
                                                        horShift, vertShift     );

                    pointOut.x := textHandlePointIn.x - horShift;
                    pointOut.y := textHandlePointIn.y - vertShift;

                    result := pointOut;
                end;

    //protected
        //draw text
            procedure TGenericLTEntityCanvas.printLTTextF(  const   drawTextUnderlayIn      : boolean;
                                                            const   textSizeIn              : integer;
                                                            const   textStringIn,
                                                                    textFontNameIn          : string;
                                                            const   textColourIn            : TColor;
                                                            const   textStylesIn            : TFontStyles;
                                                            const   textHandlePointIn       : TPointF;
                                                            const   horizontalAlignmentIn   : THorzRectAlign;
                                                            const   verticalAlignmentIn     : TVertRectAlign    );
                var

                    mustCalculateDrawingPoint   : boolean;
                    textExtent                  : TSize;
                    textDrawingPoint            : TPointF;
                begin
                    setFontTextProperties( textSizeIn, textColourIn, drawTextUnderlayIn, textStylesIn, textFontNameIn );

                    //check if drawing point must be calculated - True if alignment is NOT top left
                    // NOT( A AND B ) = NOT(A) OR NOT(B)
                        mustCalculateDrawingPoint := ( horizontalAlignmentIn <> THorzRectAlign.Left ) OR ( verticalAlignmentIn <> TVertRectAlign.Top );

                    //calculate the drawing point
                        if ( mustCalculateDrawingPoint ) then
                            begin
                                //measure text extent
                                    textExtent := TGenericLTEntityCanvas.measureTextExtent( textStringIn, textSizeIn, textStylesIn, textFontNameIn );

                                //calculate drawing point
                                    textDrawingPoint := TGenericLTEntityCanvas.calculateTextLTDrawingPoint( textExtent,
                                                                                                            horizontalAlignmentIn,
                                                                                                            verticalAlignmentIn,
                                                                                                            textHandlePointIn       );
                            end
                        else
                            textDrawingPoint := textHandlePointIn;

                    printLTTextF(   textStringIn,
                                    textDrawingPoint    );
                end;


end.
