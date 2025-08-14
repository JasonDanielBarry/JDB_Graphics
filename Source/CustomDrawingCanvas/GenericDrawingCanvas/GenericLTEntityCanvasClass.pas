unit GenericLTEntityCanvasClass;

interface

    uses
        system.types,
        vcl.Graphics,
        GenericLTEntityDrawingMethods,
        GenericLTEntityCanvasAbstractClass
        ;

    type
        TGenericLTEntityCanvas = class( TGenericLTEntityAbstractCanvas )
            private

            public
                //draw ellipse
                    procedure drawLTEllipseF(   const filledIn, outlinedIn  : boolean;
                                                const widthIn, heightIn     : double;
                                                const handlePointIn         : TPointF;
                                                const horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Center;
                                                const verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Center  );
                //draw line
                    procedure drawLTLineF(const startPointIn, endPointIn : TPointF);
                //draw rectangle
                    procedure drawLTRectangleF( const   filledIn, outlinedIn    : boolean;
                                                const   widthIn, heightIn,
                                                        cornerRadiusHorIn,
                                                        cornerRadiusVertIn      : double;
                                                const   handlePointIn           : TPointF;
                                                const   horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Center;
                                                const   verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Center  );
                //draw text
                    procedure printLTTextF( const   textSizeIn              : integer;
                                            const   textStringIn            : string;
                                            const   textHandlePointIn       : TPointF;
                                            const   drawTextUnderlayIn      : boolean = False;
                                            const   textColourIn            : TColor = clWindowText;
                                            const   textStylesIn            : TFontStyles = [];
                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top;
                                            const   textFontNameIn          : string = ''                           );
        end;

implementation

    //private
        

            

    //public
        //draw ellipse
            procedure TGenericLTEntityCanvas.drawLTEllipseF(const filledIn, outlinedIn  : boolean;
                                                            const widthIn, heightIn     : double;
                                                            const handlePointIn         : TPointF;
                                                            const horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Center;
                                                            const verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Center  );
                var
                    centrePoint : TPointF;
                begin
                    if NOT( filledIn OR outlinedIn ) then
                        exit();

                    centrePoint := calculateEllipseCentreLTPoint( widthIn, heightIn, horizontalAlignmentIn, verticalAlignmentIn, handlePointIn );

                    drawLTEllipseF_abst( filledIn, outlinedIn, widthIn, heightIn, centrePoint );
                end;

        //draw line
            procedure TGenericLTEntityCanvas.drawLTLineF(const startPointIn, endPointIn : TPointF);
                var
                    arrDrawingPoints : TArray<TPointF>;
                begin
                    SetLength( arrDrawingPoints, 2 );

                    arrDrawingPoints[0] := startPointIn;
                    arrDrawingPoints[1] := endPointIn;

                    drawLTPolylineF( arrDrawingPoints );
                end;

        //draw rectangle
            procedure TGenericLTEntityCanvas.drawLTRectangleF(  const   filledIn, outlinedIn    : boolean;
                                                                const   widthIn, heightIn,
                                                                        cornerRadiusHorIn,
                                                                        cornerRadiusVertIn      : double;
                                                                const   handlePointIn           : TPointF;
                                                                const   horizontalAlignmentIn : THorzRectAlign = THorzRectAlign.Center;
                                                                const   verticalAlignmentIn   : TVertRectAlign = TVertRectAlign.Center  );
                var
                    rectLeft, rectRight, rectTop, rectBottom : double;
                begin
                    if NOT( filledIn OR outlinedIn ) then
                        exit();

                    calculateRectangleLTBounds( widthIn, heightIn,
                                                horizontalAlignmentIn,
                                                verticalAlignmentIn,
                                                handlePointIn,
                                                rectLeft, rectRight, rectTop, rectBottom );

                    drawLTRectangleF_abst(  filledIn, outlinedIn,
                                            rectLeft, rectRight, rectTop, rectBottom,
                                            cornerRadiusHorIn, cornerRadiusVertIn       );
                end;

        //draw text
            procedure TGenericLTEntityCanvas.printLTTextF(  const   textSizeIn              : integer;
                                                            const   textStringIn            : string;
                                                            const   textHandlePointIn       : TPointF;
                                                            const   drawTextUnderlayIn      : boolean = False;
                                                            const   textColourIn            : TColor = clWindowText;
                                                            const   textStylesIn            : TFontStyles = [];
                                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top;
                                                            const   textFontNameIn          : string = ''                           );
                var
                    textDrawingPoint : TPointF;
                begin
                    setFontTextProperties( textSizeIn, textColourIn, drawTextUnderlayIn, textStylesIn, textFontNameIn );

                    textDrawingPoint := calculateTextLTDrawingPoint(    textSizeIn,
                                                                        textStringIn,
                                                                        textFontNameIn,
                                                                        textStylesIn,
                                                                        horizontalAlignmentIn,
                                                                        verticalAlignmentIn,
                                                                        textHandlePointIn       );

                    printLTTextF_abst( textStringIn, textDrawingPoint );
                end;

end.
