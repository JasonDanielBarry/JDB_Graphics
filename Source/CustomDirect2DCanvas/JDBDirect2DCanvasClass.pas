unit JDBDirect2DCanvasClass;

interface

    uses
        Winapi.D2D1,
        system.Types,
        Vcl.Direct2D, Vcl.Graphics,
        D2D_EntityGeometryMethods
        ;

    type
        TJDBDirect2DCanvas = class( TDirect2DCanvas )
            public
                //constructor
                    constructor create( const canvasIn  : TCanvas;
                                        const rectIn    : TRect     );
                //destructor
                    destructor destroy(); override;
                //canvas rotation
                    procedure rotateCanvas( const rotationAngleIn           : double;
                                            const rotationReferencePointIn  : TPointF );
                    procedure resetCanvasRotation();
                //draw arc
                    procedure drawArcF( const   filledIn, outlinedIn        : boolean;
                                        const   startAngleIn, endAngleIn,
                                                arcWidthIn, arcHeightIn     : double;
                                        const   centrePointIn               : TPointF );
                //draw ellipse
                    procedure drawEllipseF( const   filledIn, outlinedIn    : boolean;
                                            const   ellipseWidthIn,
                                                    ellipseHeightIn         : double;
                                            const   handlePointIn           : TPointF;
                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center );

        end;

implementation

    //public
        //constructor
            constructor TJDBDirect2DCanvas.create(  const canvasIn  : TCanvas;
                                                    const rectIn    : TRect     );
                begin
                    inherited create( canvasIn, rectIn );

                    RenderTarget.SetAntialiasMode( TD2D1AntiAliasMode.D2D1_ANTIALIAS_MODE_PER_PRIMITIVE );

                    RenderTarget.SetTextAntialiasMode( TD2D1TextAntiAliasMode.D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE );

                    BeginDraw();
                end;

        //destructor
            destructor TJDBDirect2DCanvas.destroy();
                begin
                    EndDraw();

                    inherited destroy();
                end;

        //canvas rotation
            procedure TJDBDirect2DCanvas.rotateCanvas(  const rotationAngleIn           : double;
                                                        const rotationReferencePointIn  : TPointF   );
                var
                    transformMatrix : TD2DMatrix3x2F;
                begin
                    //angle is in degrees
                    //get transformation matrix:
                        //positive angles = anti-clockwise rotation of the canvas
                        //which results in clockwise rotation of the drawing entities
                            transformMatrix := TD2DMatrix3x2F.Rotation( -rotationAngleIn, rotationReferencePointIn.X, rotationReferencePointIn.Y );

                    //rotate canvas
                        RenderTarget.SetTransform( transformMatrix );
                end;

            procedure TJDBDirect2DCanvas.resetCanvasRotation();
                begin
                    RenderTarget.SetTransform( TD2DMatrix3x2F.Identity );
                end;

        //draw arc
            procedure TJDBDirect2DCanvas.drawArcF(  const   filledIn, outlinedIn        : boolean;
                                                    const   startAngleIn, endAngleIn,
                                                            arcWidthIn, arcHeightIn     : double;
                                                    const   centrePointIn               : TPointF );
                var
                    arcPathGeometry : ID2D1PathGeometry;
                begin
                    arcPathGeometry := createArcPathGeometry(   filledIn,
                                                                startAngleIn, endAngleIn,
                                                                arcWidthIn, arcHeightIn,
                                                                centrePointIn               );

                    //fill arc shape
                        if ( filledIn ) then
                            FillGeometry( arcPathGeometry );

                    //draw arc line
                        if ( outlinedIn ) then
                            DrawGeometry( arcPathGeometry );
                end;

        //draw ellipse
            procedure TJDBDirect2DCanvas.drawEllipseF(  const   filledIn, outlinedIn    : boolean;
                                                        const   ellipseWidthIn,
                                                                ellipseHeightIn         : double;
                                                        const   handlePointIn           : TPointF;
                                                        const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Center;
                                                        const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Center );
                var
                    drawingEllipse : TD2D1Ellipse;
                begin
                    //create drawing ellipse
                        drawingEllipse := createEllipseGeometry(    ellipseWidthIn, ellipseHeightIn,
                                                                    horizontalAlignmentIn, verticalAlignmentIn,
                                                                    handlePointIn                               );

                    //draw fill
                        if ( filledIn ) then
                            FillEllipse( drawingEllipse );

                    //draw line
                        if ( outlinedIn ) then
                            DrawEllipse( drawingEllipse );
                end;

end.
