unit GenericLTEntityCanvasClass;

interface

    uses
        system.types,
        vcl.Graphics,
        GenericLTEntityCanvasAbstractClass

        ;

    type
        TGenericLTEntityCanvas = class( TGenericLTEntityAbstractCanvas )
            private
                //text top left point for drawing
                    class function calculateTextLTDrawingPoint( const textExtentIn              : TSize;
                                                                const horizontalAlignmentIn     : THorzRectAlign;
                                                                const verticalAlignmentIn       : TVertRectAlign;
                                                                const textHandlePointIn         : TPointF           ) : TPointF; static;
            public
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

    //public
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
                                    textExtent := TGenericLTEntityAbstractCanvas.measureTextExtent( textStringIn, textSizeIn, textStylesIn, textFontNameIn );

                                //calculate drawing point
                                    textDrawingPoint := calculateTextLTDrawingPoint(textExtent,
                                                                                    horizontalAlignmentIn,
                                                                                    verticalAlignmentIn,
                                                                                    textHandlePointIn       );
                            end
                        else
                            textDrawingPoint := textHandlePointIn;

                    inherited printLTTextF( textStringIn,
                                            textDrawingPoint );
                end;


end.
