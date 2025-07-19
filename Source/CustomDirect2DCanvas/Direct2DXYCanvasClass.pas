unit Direct2DXYCanvasClass;

interface

    uses
        system.Types,
        DrawingAxisConversionClass,
        GeometryTypes,
        GeomLineClass,
        Direct2DEntityCanvasClass;

    type
        TDirect2DXYCanvas = class( TDirect2DEntityCanvas )
            public
                //line
                    procedure drawXYLine(   const lineIn            : TGeomLine;
                                            const axisConverterIn   : TDrawingAxisConverter );
        end;

implementation

    //public
        //line
            procedure TDirect2DXYCanvas.drawXYLine( const lineIn            : TGeomLine;
                                                    const axisConverterIn   : TDrawingAxisConverter );
                var
                    arrDrawingPoints    : TArray<TPointF>;
                    arrGeomPoints       : TArray<TGeomPoint>;
                begin
                    arrGeomPoints := lineIn.getArrGeomPoints();

                    arrDrawingPoints := axisConverterIn.arrXY_to_arrLT( arrGeomPoints );

                    drawLineF( arrDrawingPoints );
                end;

end.
