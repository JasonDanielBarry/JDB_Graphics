unit MetafileXYEntityCanvasClass;

interface

    uses
        system.SysUtils, system.types,
        vcl.Graphics,
        CanvasHelperClass,
        GenericXYEntityCanvasClass
        ;

    type
        TMetafileXYEntityCanvas = class( TGenericXYEntityCanvas )
            private
                var
                    metafileLTEntityCanvas  : TMetafileCanvas;
                    metafile                : TMetafile;
                //set font properties
                    procedure setFontTextProperties(const sizeIn        : integer;
                                                    const colourIn      : TColor;
                                                    const underlaidIn   : boolean = False;
                                                    const stylesIn      : TFontStyles = [];
                                                    const nameIn        : string = ''       ); override;
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
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //begin and end drawing
                    procedure beginDrawing(const metafileWidthIn, metafileHeightIn : integer);
                    procedure endDrawing();
                //set brush properties
                    procedure setBrushFillProperties(const solidIn : boolean; const colourIn : TColor); override;
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle = TPenStyle.psSolid ); override;
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
                //save to file
                    procedure saveToFile(const fileNameIn : string);
        end;

implementation

    //private
        //set font properties
            procedure TMetafileXYEntityCanvas.setFontTextProperties(const sizeIn        : integer;
                                                                    const colourIn      : TColor;
                                                                    const underlaidIn   : boolean = False;
                                                                    const stylesIn      : TFontStyles = [];
                                                                    const nameIn        : string = ''       );
                begin
                    inherited setFontTextProperties( sizeIn, colourIn, underlaidIn, stylesIn, nameIn );

                    metafileLTEntityCanvas.setFontTextProperties( sizeIn, nameIn, colourIn, stylesIn );
                end;

        //ellipse
            procedure TMetafileXYEntityCanvas.drawLTEllipseF_abst(  const   filledIn, outlinedIn    : boolean;
                                                                    const   ellipseWidthIn,
                                                                            ellipseHeightIn         : double;
                                                                    const   centrePointIn           : TPointF   );
                begin
                    metafileLTEntityCanvas.drawLTEllipseF(  filledIn, outlinedIn,
                                                            ellipseWidthIn, ellipseHeightIn,
                                                            centrePointIn                   );
                end;

        //rectangle
            procedure TMetafileXYEntityCanvas.drawLTRectangleF_abst(const   filledIn, outlinedIn        : boolean;
                                                                    const   leftBoundIn, rightBoundIn,
                                                                            topBoundIn, bottomBoundIn,
                                                                            cornerRadiusHorIn,
                                                                            cornerRadiusVertIn          : double );
                begin
                    metafileLTEntityCanvas.drawLTRectangleF(    filledIn, outlinedIn,
                                                                leftBoundIn, rightBoundIn,
                                                                topBoundIn, bottomBoundIn,
                                                                cornerRadiusHorIn,
                                                                cornerRadiusVertIn          );
                end;

        //text
            procedure TMetafileXYEntityCanvas.printLTTextF_abst(const textStringIn          : string;
                                                                const textDrawingPointIn    : TPointF);
                begin
                    metafileLTEntityCanvas.printLTTextF( textStringIn, textDrawingPointIn );
                end;

    //public
        //constructor
            constructor TMetafileXYEntityCanvas.create();
                begin
                    inherited create();

                    metafile := TMetafile.Create();
                    metafile.Enhanced := True;
                end;

        //destructor
            destructor TMetafileXYEntityCanvas.destroy();
                begin
                    FreeAndNil( metafile );

                    inherited destroy();
                end;

        //set metafile size
            procedure TMetafileXYEntityCanvas.beginDrawing(const metafileWidthIn, metafileHeightIn : integer);
                begin
                    metafile.SetSize( metafileWidthIn, metafileHeightIn );

                    metafileLTEntityCanvas := TMetafileCanvas.create( metafile, 0 );
                    metafileLTEntityCanvas.Font.Quality := TFontQuality.fqClearTypeNatural;
                end;

            procedure TMetafileXYEntityCanvas.endDrawing();
                begin
                    FreeAndNil( metafileLTEntityCanvas );
                end;

        //set brush properties
            procedure TMetafileXYEntityCanvas.setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
                begin
                    metafileLTEntityCanvas.setBrushFillProperties( solidIn, colourIn );
                end;

        //set pen properties
            procedure TMetafileXYEntityCanvas.setPenLineProperties( const widthIn   : integer;
                                                                    const colourIn  : TColor;
                                                                    const styleIn   : TPenStyle = TPenStyle.psSolid );
                begin
                    metafileLTEntityCanvas.setPenLineProperties( widthIn, colourIn, styleIn );
                end;

        //canvas rotation
            procedure TMetafileXYEntityCanvas.rotateCanvasLT(   const rotationAngleIn           : double;
                                                                const rotationReferencePointIn  : TPointF   );
                begin
                    metafileLTEntityCanvas.rotateCanvasLT( rotationAngleIn, rotationReferencePointIn );
                end;

            procedure TMetafileXYEntityCanvas.resetCanvasRotation();
                begin
                    metafileLTEntityCanvas.resetCanvasRotation();
                end;

        //arc
            procedure TMetafileXYEntityCanvas.drawLTArcF(   const   filledIn, outlinedIn            : boolean;
                                                            const   startAngleIn, endAngleIn,
                                                                    arcHorRadiusIn, arcVertRadiusIn : double;
                                                            const   centrePointIn                   : TPointF   );
                begin
                    metafileLTEntityCanvas.drawLTArcF(  filledIn, outlinedIn,
                                                        startAngleIn, endAngleIn,
                                                        arcHorRadiusIn, arcVertRadiusIn,
                                                        centrePointIn                   );
                end;

        //polyline
            procedure TMetafileXYEntityCanvas.drawLTPolylineF(const arrDrawingPointsIn : TArray<TPointF>);
                begin
                    metafileLTEntityCanvas.drawLTPolylineF( arrDrawingPointsIn );
                end;

        //polygon
            procedure TMetafileXYEntityCanvas.drawLTPolygonF(   const filledIn, outlinedIn  : boolean;
                                                                const arrDrawingPointsIn    : TArray<TPointF>   );
                begin
                    metafileLTEntityCanvas.drawLTPolygonF( filledIn, outlinedIn, arrDrawingPointsIn );
                end;

        //save to file
            procedure TMetafileXYEntityCanvas.saveToFile(const fileNameIn : string);
                begin
                    if ( Assigned( metafileLTEntityCanvas ) ) then
                        endDrawing();

                    metafile.SaveToFile( fileNameIn );
                end;

end.
