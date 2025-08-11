unit Direct2DXYEntityCanvasClass;

interface

    uses
        system.SysUtils, system.types,
        vcl.Graphics,
        Direct2DLTEntityCanvasClass,
        GenericXYEntityCanvasClass

        ;

    type
        TDirect2DXYEntityCanvas = class( TGenericXYEntityCanvas )
            private
                var
                    direct2DLTEntityCanvas : TDirect2DLTEntityCanvas;
            protected
                //ellipse
                    procedure drawLTEllipseF_abst(  const   filledIn, outlinedIn    : boolean;
                                                    const   ellipseWidthIn,
                                                            ellipseHeightIn         : double;
                                                    const   centrePointIn           : TPointF   ); override;
                //rectangle
                    procedure drawLTRectangleF_abst(const   filledIn, outlinedIn        : boolean;
                                                    const   leftBoundIn, rightBoundIn,
                                                            topBoundIn, bottomBoundIn,
                                                            cornerRadiusHorIn,
                                                            cornerRadiusVertIn          : double ); override;
                //text
                    procedure printLTTextF_abst(const textStringIn          : string;
                                                const textDrawingPointIn    : TPointF); override;

            public
                //begine drawing
                    procedure beginDrawing(const bitmapIn : TBitmap);
                //end drawing
                    procedure endDrawing();
                //set brush properties
                    procedure setBrushFillProperties(const solidIn : boolean; const colourIn : TColor); override;
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle = TPenStyle.psSolid ); override;
                //set font properties
                    procedure setFontTextProperties(const sizeIn        : integer;
                                                    const colourIn      : TColor;
                                                    const underlaidIn   : boolean = False;
                                                    const stylesIn      : TFontStyles = [];
                                                    const nameIn        : string = ''       ); override;
                //canvas rotation
                    procedure rotateCanvasLT(   const rotationAngleIn           : double;
                                                const rotationReferencePointIn  : TPointF   ); override;
                    procedure resetCanvasRotation();  override;
                //arc
                    procedure drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                            const   startAngleIn, endAngleIn,
                                                    arcHorRadiusIn, arcVertRadiusIn : double;
                                            const   centrePointIn                   : TPointF   ); override;
                //polyline
                    procedure drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>); override;
                //polygon
                    procedure drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                const arrDrawingPointsIn    : TArray<TPointF>   ); override;
        end;

implementation

    //protected
        //ellipse
            procedure TDirect2DXYEntityCanvas.drawLTEllipseF_abst(  const   filledIn, outlinedIn    : boolean;
                                                                    const   ellipseWidthIn,
                                                                            ellipseHeightIn         : double;
                                                                    const   centrePointIn           : TPointF   );
                begin

                end;

        //rectangle
            procedure drawLTRectangleF_abst(const   filledIn, outlinedIn        : boolean;
                                            const   leftBoundIn, rightBoundIn,
                                                    topBoundIn, bottomBoundIn,
                                                    cornerRadiusHorIn,
                                                    cornerRadiusVertIn          : double );
                begin

                end;

        //text
            procedure TDirect2DXYEntityCanvas.printLTTextF_abst(const textStringIn          : string;
                                                                const textDrawingPointIn    : TPointF);
                begin
                    direct2DLTEntityCanvas.printLTTextF( textStringIn, textDrawingPointIn );
                end;

    //public
        //begin drawing
            procedure TDirect2DXYEntityCanvas.beginDrawing(const bitmapIn : TBitmap);
                begin
                    direct2DLTEntityCanvas := TDirect2DLTEntityCanvas.create( bitmapIn );
                end;

        //end drawing
            procedure TDirect2DXYEntityCanvas.endDrawing();
                begin
                    FreeAndNil( direct2DLTEntityCanvas );
                end;

        //set brush properties
            procedure TDirect2DXYEntityCanvas.setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
                begin
                    direct2DLTEntityCanvas.setBrushFillProperties( solidIn, colourIn );
                end;

        //set pen properties
            procedure TDirect2DXYEntityCanvas.setPenLineProperties( const widthIn   : integer;
                                                                    const colourIn  : TColor;
                                                                    const styleIn   : TPenStyle = TPenStyle.psSolid );
                begin
                    direct2DLTEntityCanvas.setPenLineProperties( widthIn, colourIn, styleIn );
                end;

        //set font properties
            procedure TDirect2DXYEntityCanvas.setFontTextProperties(const sizeIn        : integer;
                                                                    const colourIn      : TColor;
                                                                    const underlaidIn   : boolean = False;
                                                                    const stylesIn      : TFontStyles = [];
                                                                    const nameIn        : string = ''       );
                begin
                    inherited setFontTextProperties( sizeIn, colourIn, underlaidIn, stylesIn, nameIn );

                    direct2DLTEntityCanvas.setFontTextProperties( sizeIn, nameIn, colourIn, stylesIn );
                end;

        //canvas rotation
            procedure TDirect2DXYEntityCanvas.rotateCanvasLT(   const rotationAngleIn           : double;
                                                                const rotationReferencePointIn  : TPointF   );
                begin
                    direct2DLTEntityCanvas.rotateCanvasLT( rotationAngleIn, rotationReferencePointIn );
                end;

            procedure TDirect2DXYEntityCanvas.resetCanvasRotation();
                begin
                    direct2DLTEntityCanvas.resetCanvasRotation();
                end;

        //arc
            procedure TDirect2DXYEntityCanvas.drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                                            const   startAngleIn, endAngleIn,
                                                                    arcHorRadiusIn, arcVertRadiusIn : double;
                                                            const   centrePointIn                   : TPointF   );
                begin
                    direct2DLTEntityCanvas.drawLTArcF(  filledIn, outlinedIn,
                                                        startAngleIn, endAngleIn,
                                                        arcHorRadiusIn, arcVertRadiusIn,
                                                        centrePointIn                   );
                end;

        //polyline
            procedure TDirect2DXYEntityCanvas.drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                begin
                    direct2DLTEntityCanvas.drawLTPolylineF( arrDrawingPointsIn );
                end;

        //polygon
            procedure TDirect2DXYEntityCanvas.drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                                const arrDrawingPointsIn    : TArray<TPointF>   );
                begin
                    direct2DLTEntityCanvas.drawLTPolygonF( filledIn, outlinedIn, arrDrawingPointsIn );
                end;

end.
