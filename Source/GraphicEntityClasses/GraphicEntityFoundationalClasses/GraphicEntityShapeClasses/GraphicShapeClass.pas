unit GraphicShapeClass;

interface

    uses
        system.SysUtils, System.Math, system.Types,
        Vcl.Graphics,
        GeometryTypes, GeomBox,
        DrawingAxisConversionClass,
        GraphicEntityFoundationalClass,
        GenericXYEntityCanvasClass
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
                                                var canvasInOut         : TGenericXYEntityCanvas); virtual; abstract;
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
                                            var canvasInOut         : TGenericXYEntityCanvas ); override;
        end;

implementation

    //protected
        //calculate bounding box
            function calculateUnrotatedShapeBoundingBox(const shapeWidthIn, shapeHeightIn   : double;
                                                        const horAlignmentIn                : THorzRectAlign;
                                                        const vertAlignmentIn               : TVertRectAlign;
                                                        const handlePointXYIn               : TGeomPoint    ) : TGeomBox;
                var
                    boxCentreX, boxCentreY  : double;
                    shapeBoxOut             : TGeomBox;
                begin
                    //determine the horizontal centre of the box
                        case (horAlignmentIn) of
                            THorzRectAlign.Left:
                                boxCentreX := handlePointXYIn.X + shapeWidthIn / 2;

                            THorzRectAlign.Center:
                                boxCentreX := handlePointXYIn.X;

                            THorzRectAlign.Right:
                                boxCentreX := handlePointXYIn.X - shapeWidthIn / 2;
                        end;

                    //determine the vertical centre of the box
                        case (vertAlignmentIn) of
                            TVertRectAlign.Bottom:
                                boxCentreY := handlePointXYIn.y + shapeHeightIn / 2;

                            TVertRectAlign.Center:
                                boxCentreY := handlePointXYIn.y;

                            TVertRectAlign.Top:
                                boxCentreY := handlePointXYIn.y - shapeHeightIn / 2;
                        end;

                    //dimension the box
                        shapeBoxOut := TGeomBox.newBox( shapeWidthIn, shapeHeightIn );

                    //shift the box to the centre point
                        shapeBoxOut.setCentrePoint( boxCentreX, boxCentreY );

                    result := shapeBoxOut;
                end;

            function TGraphicShape.calculateShapeBoundingBox(const shapeWidthIn, shapeHeightIn : double) : TGeomBox;
                var
                    shapeHasZeroDimensions,
                    shapeIsCanvasScale,
                    mustNotCalculateBoundingBox             : boolean;
                    unrotatedShapeBoxPoints, rotatedPoints  : TArray<TGeomPoint>;
                    unrotatedShapeBox, boundingBoxOut       : TGeomBox;
                begin
                    //determine if bounding box calculation is necessary
                    //if the dimensions entered are 0 or if canvas scale is selected then the graphic box is a dot at the handle point
                        shapeHasZeroDimensions := ( IsZero( shapeWidthIn ) AND IsZero( shapeHeightIn ) );

                        shapeIsCanvasScale := ( scaleType = EScaleType.scCanvas );

                        mustNotCalculateBoundingBox := ( shapeHasZeroDimensions OR shapeIsCanvasScale );

                        if ( mustNotCalculateBoundingBox ) then
                            begin
                                result := TGeomBox.determineBoundingBox( [ handlePointXY, handlePointXY ] );
                                exit();
                            end;

                    //calculate the unrotated shape bounding box
                        unrotatedShapeBox := calculateUnrotatedShapeBoundingBox( shapeWidthIn, shapeHeightIn,
                                                                        horizontalAlignment,
                                                                        verticalAlignment,
                                                                        handlePointXY               );

                    //apply the rotation
                        unrotatedShapeBoxPoints := unrotatedShapeBox.getCornerPoints2D();

                        TGeomPoint.copyPoints( unrotatedShapeBoxPoints, rotatedPoints );

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
                                                    var canvasInOut         : TGenericXYEntityCanvas   );
                var
                    canvasWasRotated : boolean;
                begin
                    if ( filled OR outlined ) then
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
