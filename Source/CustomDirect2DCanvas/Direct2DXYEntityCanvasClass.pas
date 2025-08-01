unit Direct2DXYEntityCanvasClass;

interface

    uses
        System.Types, System.Math,
        vcl.Graphics,
        DrawingAxisConversionClass,
        GeometryTypes,
        Direct2DLTEntityCanvasClass;

    type
        {$SCOPEDENUMS ON}
            EScaleType = (scCanvas = 0, scDrawing);
        {$SCOPEDENUMS OFF}

        TDirect2DXYEntityCanvas = class( TDirect2DLTEntityCanvas )
            private
                //convert the height, width and handle point of entites from XY to LT based on drawing scale option
                    class procedure convertWidthHeightAndHandlePoint(   const   widthXYIn, heightXYIn   : double;
                                                                        const   handlePointXYIn         : TGeomPoint;
                                                                        const   scaleTypeIn             : EScaleType;
                                                                        const   axisConverterIn         : TDrawingAxisConverter;
                                                                        out widthLTOut, heightLTOut     : double;
                                                                        out handlePointLTOut            : TPointF               ); static;
            public
                //canvas rotation
                    procedure rotateCanvasXY(   const rotationAngleIn           : double;
                                                const rotationReferencePointIn  : TGeomPoint;
                                                const axisConverterIn           : TDrawingAxisConverter );
                //drawing entities
                    //arc
                        procedure drawXYArc(const   filledIn, outlinedIn            : boolean;
                                            const   startAngleIn, endAngleIn,
                                                    arcXRadiusInIn, arcYRadiusIn    : double;
                                            const   centrePointIn                   : TGeomPoint;
                                            const   axisConverterIn                 : TDrawingAxisConverter;
                                            const   scaleTypeIn                     : EScaleType = EScaleType.scDrawing);
                    //ellipse
                        procedure drawXYEllipse(const   filledIn, outlinedIn    : boolean;
                                                const   ellipseWidthIn,
                                                        ellipseHeightIn         : double;
                                                const   handlePointIn           : TGeomPoint;
                                                const   axisConverterIn         : TDrawingAxisConverter;
                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center;
                                                const   scaleTypeIn             : EScaleType = EScaleType.scDrawing     );
                    //line
                        procedure drawXYLine(   const arrLinePointsIn   : TArray<TGeomPoint>;
                                                const axisConverterIn   : TDrawingAxisConverter );
                    //polyline
                        procedure drawXYPolyline(   const arrPolylinePointsIn   : TArray<TGeomPoint>;
                                                    const axisConverterIn       : TDrawingAxisConverter );
                    //polygon
                        procedure drawXYPolygon(const filledIn, outlinedIn  : boolean;
                                                const arrPolygonPointsIn    : TArray<TGeomPoint>;
                                                const axisConverterIn       : TDrawingAxisConverter);
                    //rectangle
                        procedure drawXYRectangle(  const   filledIn, outlinedIn        : boolean;
                                                    const   rectWidthIn, rectHeightIn,
                                                            cornerRadiusXIn,
                                                            cornerRadiusYIn             : double;
                                                    const   handlePointIn               : TGeomPoint;
                                                    const   axisConverterIn             : TDrawingAxisConverter;
                                                    const   horizontalAlignmentIn       : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn         : TVertRectAlign = TVertRectAlign.Center;
                                                    const   scaleTypeIn                 : EScaleType = EScaleType.scDrawing         ); overload;
                        procedure drawXYRectangle(  const   filledIn, outlinedIn        : boolean;
                                                    const   rectWidthIn, rectHeightIn,
                                                            cornerRadiusIn              : double;
                                                    const   handlePointIn               : TGeomPoint;
                                                    const   axisConverterIn             : TDrawingAxisConverter;
                                                    const   horizontalAlignmentIn       : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn         : TVertRectAlign = TVertRectAlign.Center;
                                                    const   scaleTypeIn                 : EScaleType = EScaleType.scDrawing         ); overload;
                    //text
                        procedure printXYText(  const   textStringIn            : string;
                                                const   textHandlePointIn       : TGeomPoint;
                                                const   axisConverterIn         : TDrawingAxisConverter;
                                                const   drawTextUnderlayIn      : boolean = False;
                                                const   textSizeIn              : double = 9.0;
                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top;
                                                const   scaleTypeIn             : EScaleType = EScaleType.scCanvas;
                                                const   textColourIn            : TColor = clWindowText;
                                                const   textStylesIn            : TFontStyles = [];
                                                const   textFontNameIn          : string = ''                           );
        end;

implementation

    //private
        //convert the height, width and handle point of entites based on drawing scale option
            class procedure TDirect2DXYEntityCanvas.convertWidthHeightAndHandlePoint(   const   widthXYIn, heightXYIn   : double;
                                                                                        const   handlePointXYIn         : TGeomPoint;
                                                                                        const   scaleTypeIn             : EScaleType;
                                                                                        const   axisConverterIn         : TDrawingAxisConverter;
                                                                                        out widthLTOut, heightLTOut     : double;
                                                                                        out handlePointLTOut            : TPointF               );
                begin
                    case ( scaleTypeIn ) of
                        EScaleType.scCanvas:
                            begin
                                widthLTOut  := widthXYIn;
                                heightLTOut := heightXYIn;
                            end;

                        EScaleType.scDrawing:
                            begin
                                widthLTOut  := axisConverterIn.dX_To_dL( widthXYIn );
                                heightLTOut := abs( axisConverterIn.dY_To_dT( heightXYIn ) );
                            end;
                    end;

                    handlePointLTOut := axisConverterIn.XY_to_LT( handlePointXYIn );
                end;

    //public
        //canvas rotation
            procedure TDirect2DXYEntityCanvas.rotateCanvasXY(   const rotationAngleIn           : double;
                                                                const rotationReferencePointIn  : TGeomPoint;
                                                                const axisConverterIn           : TDrawingAxisConverter );
                var
                    rotationReferencePointLT : TPointF;
                begin
                    rotationReferencePointLT := axisConverterIn.XY_to_LT( rotationReferencePointIn );

                    rotateCanvasLT( rotationAngleIn, rotationReferencePointLT );
                end;

        //drawing entities
            //arc
                procedure TDirect2DXYEntityCanvas.drawXYArc(const   filledIn, outlinedIn            : boolean;
                                                            const   startAngleIn, endAngleIn,
                                                                    arcXRadiusInIn, arcYRadiusIn    : double;
                                                            const   centrePointIn                   : TGeomPoint;
                                                            const   axisConverterIn                 : TDrawingAxisConverter;
                                                            const   scaleTypeIn                     : EScaleType = EScaleType.scDrawing);
                    var
                        horRadiusLT, VertRadiusLT   : double;
                        centrePointLT               : TPointF;
                    begin
                        convertWidthHeightAndHandlePoint(   arcXRadiusInIn, arcYRadiusIn,
                                                            centrePointIn,
                                                            scaleTypeIn,
                                                            axisConverterIn,
                                                            horRadiusLT, VertRadiusLT,
                                                            centrePointLT           );

                        drawLTArcF( filledIn, outlinedIn,
                                    startAngleIn, endAngleIn,
                                    horRadiusLT, VertRadiusLT,
                                    centrePointLT            );
                    end;

            //ellipse
                procedure TDirect2DXYEntityCanvas.drawXYEllipse(const   filledIn, outlinedIn    : boolean;
                                                                const   ellipseWidthIn,
                                                                        ellipseHeightIn         : double;
                                                                const   handlePointIn           : TGeomPoint;
                                                                const   axisConverterIn         : TDrawingAxisConverter;
                                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center;
                                                                const   scaleTypeIn             : EScaleType = EScaleType.scDrawing     );
                    var
                        widthLT, heightLT   : double;
                        handlePointLT       : TPointF;
                    begin
                        convertWidthHeightAndHandlePoint(   ellipseWidthIn, ellipseHeightIn,
                                                            handlePointIn,
                                                            scaleTypeIn,
                                                            axisConverterIn,
                                                            widthLT, heightLT,
                                                            handlePointLT                   );

                        drawLTEllipseF( filledIn, outlinedIn,
                                        widthLT, heightLT,
                                        handlePointLT,
                                        horizontalAlignmentIn,
                                        verticalAlignmentIn     );
                    end;

            //line
                procedure TDirect2DXYEntityCanvas.drawXYLine(   const arrLinePointsIn   : TArray<TGeomPoint>;
                                                                const axisConverterIn   : TDrawingAxisConverter );
                    var
                        arrDrawingPoints : TArray<TPointF>;
                    begin
                        if ( length( arrLinePointsIn ) < 2 ) then
                            exit();

                        arrDrawingPoints := axisConverterIn.arrXY_to_arrLT( arrLinePointsIn );

                        drawLTLineF( arrDrawingPoints );
                    end;

            //polyline
                procedure TDirect2DXYEntityCanvas.drawXYPolyline(   const arrPolylinePointsIn   : TArray<TGeomPoint>;
                                                                    const axisConverterIn       : TDrawingAxisConverter );

                    var
                        arrDrawingPoints : TArray<TPointF>;
                    begin
                        if ( length( arrPolylinePointsIn ) < 3 ) then
                            exit();

                        arrDrawingPoints := axisConverterIn.arrXY_to_arrLT( arrPolylinePointsIn );

                        drawLTPolylineF( arrDrawingPoints );
                    end;

            //polygon
                procedure TDirect2DXYEntityCanvas.drawXYPolygon(const filledIn, outlinedIn  : boolean;
                                                                const arrPolygonPointsIn    : TArray<TGeomPoint>;
                                                                const axisConverterIn       : TDrawingAxisConverter);
                    var
                        arrDrawingPoints : TArray<TPointF>;
                    begin
                        if ( length( arrPolygonPointsIn ) < 3 ) then
                            exit();

                        arrDrawingPoints := axisConverterIn.arrXY_to_arrLT( arrPolygonPointsIn );

                        drawLTPolygonF( filledIn, outlinedIn, arrDrawingPoints );
                    end;

            //rectangle
                procedure TDirect2DXYEntityCanvas.drawXYRectangle(  const   filledIn, outlinedIn        : boolean;
                                                                    const   rectWidthIn, rectHeightIn,
                                                                            cornerRadiusXIn,
                                                                            cornerRadiusYIn             : double;
                                                                    const   handlePointIn               : TGeomPoint;
                                                                    const   axisConverterIn             : TDrawingAxisConverter;
                                                                    const   horizontalAlignmentIn       : THorzRectAlign = THorzRectAlign.Center;
                                                                    const   verticalAlignmentIn         : TVertRectAlign = TVertRectAlign.Center;
                                                                    const   scaleTypeIn                 : EScaleType = EScaleType.scDrawing         );
                    var
                        widthLT, heightLT,
                        cornerRadiusHor,
                        cornerRadiusVert    : double;
                        handlePointLT       : TPointF;
                    begin
                        //convert from XY to LT
                            cornerRadiusHor     := axisConverterIn.dX_To_dL( cornerRadiusXIn );
                            cornerRadiusVert    := abs( axisConverterIn.dY_To_dT( cornerRadiusYIn ) );

                            convertWidthHeightAndHandlePoint(   rectWidthIn, rectHeightIn,
                                                                handlePointIn,
                                                                scaleTypeIn,
                                                                axisConverterIn,
                                                                widthLT, heightLT,
                                                                handlePointLT               );



                        drawLTRectangleF(   filledIn, outlinedIn,
                                            widthLT, heightLT,
                                            cornerRadiusHor, cornerRadiusVert,
                                            handlePointLT,
                                            horizontalAlignmentIn,
                                            verticalAlignmentIn                 );
                    end;

                procedure TDirect2DXYEntityCanvas.drawXYRectangle(  const   filledIn, outlinedIn        : boolean;
                                                                    const   rectWidthIn, rectHeightIn,
                                                                            cornerRadiusIn              : double;
                                                                    const   handlePointIn               : TGeomPoint;
                                                                    const   axisConverterIn             : TDrawingAxisConverter;
                                                                    const   horizontalAlignmentIn       : THorzRectAlign = THorzRectAlign.Center;
                                                                    const   verticalAlignmentIn         : TVertRectAlign = TVertRectAlign.Center;
                                                                    const   scaleTypeIn                 : EScaleType = EScaleType.scDrawing         );
                    begin
                        drawXYRectangle(    filledIn, outlinedIn,
                                            rectWidthIn, rectHeightIn,
                                            cornerRadiusIn, cornerRadiusIn,
                                            handlePointIn,
                                            axisConverterIn,
                                            horizontalAlignmentIn,
                                            verticalAlignmentIn,
                                            scaleTypeIn                     );
                    end;

            //text
                procedure TDirect2DXYEntityCanvas.printXYText(  const   textStringIn            : string;
                                                                const   textHandlePointIn       : TGeomPoint;
                                                                const   axisConverterIn         : TDrawingAxisConverter;
                                                                const   drawTextUnderlayIn      : boolean = False;
                                                                const   textSizeIn              : double = 9.0;
                                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top;
                                                                const   scaleTypeIn             : EScaleType = EScaleType.scCanvas;
                                                                const   textColourIn            : TColor = clWindowText;
                                                                const   textStylesIn            : TFontStyles = [];
                                                                const   textFontNameIn          : string = ''                           );
                    var
                        textSizeInteger : integer;
                        textSizeLT      : double;
                        handlePointLT   : TPointF;
                    begin
                        //convert XY to LT
                            //text size
                                case ( scaleTypeIn ) of
                                    EScaleType.scCanvas:
                                        textSizeLT := textSizeIn;

                                    EScaleType.scDrawing:
                                        textSizeLT := abs( axisConverterIn.dY_To_dT( textSizeIn ) );
                                end;

                                textSizeLT      := max( 1,  textSizeLT );
                                textSizeInteger := round( textSizeLT );

                            //handle point
                                handlePointLT := axisConverterIn.XY_to_LT( textHandlePointIn );

                        printLTTextF(   textSizeInteger,
                                        textStringIn,
                                        textFontNameIn,
                                        textColourIn,
                                        textStylesIn,
                                        handlePointLT,
                                        drawTextUnderlayIn,
                                        horizontalAlignmentIn,
                                        verticalAlignmentIn     );
                    end;

end.
