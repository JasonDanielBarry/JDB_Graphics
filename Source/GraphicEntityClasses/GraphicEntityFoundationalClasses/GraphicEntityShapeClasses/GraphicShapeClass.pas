unit GraphicShapeClass;

interface

    uses
        system.SysUtils, System.Math, system.Types, System.UITypes,
        Vcl.Graphics,
        GeometryTypes, GeomBox,
        DrawingAxisConversionClass,
        GraphicEntityFoundationalClass,
        Direct2DXYEntityCanvasClass
        ;

    type
        TGraphicShape = class( TFoundationalGraphicEntity )
            private
                var
                    mustRotateCanvas    : boolean;
                    rotationAngle       : double;
            protected
                var
                    scaleType           : EScaleType;
                    horizontalAlignment : THorzRectAlign;
                    verticalAlignment   : TVertRectAlign;
                    handlePointXY       : TGeomPoint;
                //calculate bounding box
                    function calculateShapeBoundingBox(const shapeWidthIn, shapeHeightIn : double) : TGeomBox;
                //draw shape to canvas
                    procedure drawShapeToCanvas(const axisConverterIn   : TDrawingAxisConverter;
                                                var canvasInOut         : TDirect2DXYEntityCanvas   ); virtual; abstract;
            public
                //constructor
                    constructor create( const   filledIn                : boolean;
                                        const   lineThicknessIn         : integer;
                                        const   rotationAngleIn         : double;
                                        const   scaleTypeIn             : EScaleType;
                                        const   horizontalAlignmentIn   : THorzRectAlign;
                                        const   verticalAlignmentIn     : TVertRectAlign;
                                        const   fillColourIn,
                                                lineColourIn            : TColor;
                                        const   lineStyleIn             : TPenStyle;
                                        const   handlePointXYIn         : TGeomPoint        );
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setRotationAngle(const rotationAngleIn : double);
                    procedure setAlignment( const horAlignmentIn    : THorzRectAlign;
                                            const vertAlignmentIn   : TVertRectAlign );
                    procedure setHandlePoint(const xIn, yIn : double);
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas   ); override;

        end;


implementation

    //protected
        //calculate bounding box
            function TGraphicShape.calculateShapeBoundingBox(const shapeWidthIn, shapeHeightIn : double) : TGeomBox;
                var
                    mustCalculateBoundingBox        : boolean;
                    boxCentreX, boxCentreY          : double;
                    shapeBoxPoints, rotatedPoints   : TArray<TGeomPoint>;
                    shapeBox, boundingBoxOut        : TGeomBox;
                begin
                    //determine if bounding box calculation is necessary
                    //if the dimensions entered are 0 or if canvas scale is selected then the graphic box is a dot at the handle point
                        mustCalculateBoundingBox := NOT(
                                                            ( IsZero( shapeWidthIn ) AND IsZero( shapeHeightIn ) )
                                                            OR
                                                            (scaleType = EScaleType.scCanvas )
                                                       );


                        if NOT (mustCalculateBoundingBox ) then
                            begin
                                result := TGeomBox.determineBoundingBox( [ handlePointXY, handlePointXY ] );
                                exit();
                            end;

                    //dimension the box
                        shapeBox.newBox( shapeWidthIn, shapeHeightIn );

                    //determine the horizontal centre of the box
                        case (horizontalAlignment) of
                            THorzRectAlign.Left:
                                boxCentreX := handlePointXY.X + shapeWidthIn / 2;

                            THorzRectAlign.Center:
                                boxCentreX := handlePointXY.X;

                            THorzRectAlign.Right:
                                boxCentreX := handlePointXY.X - shapeWidthIn / 2;
                        end;

                    //determine the vertical centre of the box
                        case (verticalAlignment) of
                            TVertRectAlign.Bottom:
                                boxCentreY := handlePointXY.y + shapeHeightIn / 2;

                            TVertRectAlign.Center:
                                boxCentreY := handlePointXY.y;

                            TVertRectAlign.Top:
                                boxCentreY := handlePointXY.y - shapeHeightIn / 2;
                        end;

                    //shift the box to the centre point
                        shapeBox.setCentrePoint( boxCentreX, boxCentreY );

                    //apply the rotation
                        shapeBoxPoints := shapeBox.getCornerPoints2D();

                        TGeomPoint.copyPoints( shapeBoxPoints, rotatedPoints );

                        TGeomPoint.rotateArrPoints( rotationAngle, handlePointXY, rotatedPoints );

                    //determine the rotated shape's bounding box
                        boundingBoxOut := TGeomBox.determineBoundingBox( rotatedPoints );

                    result := boundingBoxOut;
                end;

    //public
        //constructor
            constructor TGraphicShape.create(   const   filledIn                : boolean;
                                                const   lineThicknessIn         : integer;
                                                const   rotationAngleIn         : double;
                                                const   scaleTypeIn             : EScaleType;
                                                const   horizontalAlignmentIn   : THorzRectAlign;
                                                const   verticalAlignmentIn     : TVertRectAlign;
                                                const   fillColourIn,
                                                        lineColourIn            : TColor;
                                                const   lineStyleIn             : TPenStyle;
                                                const   handlePointXYIn         : TGeomPoint        );
                begin
                    inherited create(   filledIn,
                                        lineThicknessIn,
                                        fillColourIn,
                                        lineColourIn,
                                        lineStyleIn     );

                    setRotationAngle( rotationAngleIn );

                    scaleType           := scaleTypeIn;
                    horizontalAlignment := horizontalAlignmentIn;
                    verticalAlignment   := verticalAlignmentIn;

                    handlePointXY.copyPoint( handlePointXYIn );
                end;

        //destructor
            destructor TGraphicShape.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            procedure TGraphicShape.setRotationAngle(const rotationAngleIn : double);
                begin
                    rotationAngle := FMod( rotationAngleIn, 360 );

                    mustRotateCanvas := NOT( IsZero( rotationAngle, 1e-3 ) );
                end;

            procedure TGraphicShape.setAlignment(   const horAlignmentIn    : THorzRectAlign;
                                                    const vertAlignmentIn   : TVertRectAlign    );
                begin
                    horizontalAlignment := horAlignmentIn;
                    verticalAlignment   := vertAlignmentIn;
                end;

            procedure TGraphicShape.setHandlePoint(const xIn, yIn : double);
                begin
                    handlePointXY.setPoint( xIn, yIn );
                end;

        //draw to canvas
            procedure TGraphicShape.drawToCanvas(   const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DXYEntityCanvas   );
                var
                    canvasWasRotated : boolean;
                begin
                    inherited drawToCanvas( axisConverterIn, canvasInOut );

                    //rotate canvas
                        if ( mustRotateCanvas ) then
                            begin
                                canvasInOut.rotateCanvasXY( rotationAngle, handlePointXY, axisConverterIn );
                                canvasWasRotated := True;
                            end
                        else
                            canvasWasRotated := False;

                    //draw the shape
                        drawShapeToCanvas( axisConverterIn, canvasInOut );

                    //reset canvas rotation
                        if ( canvasWasRotated ) then
                            canvasInOut.resetCanvasRotation();
                end;

end.
