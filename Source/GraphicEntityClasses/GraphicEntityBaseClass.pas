unit GraphicEntityBaseClass;

interface

    uses
        system.UITypes, system.Math, System.Classes, System.Types,
        vcl.Graphics, vcl.Themes,
        GeomBox,
        Direct2DXYEntityCanvasClass,
        DrawingAxisConversionClass
        ;

    type
        TGraphicEntity = class
            private
                var
                    mustRotateCanvas    : boolean;

                    rotationAngle       : double;

                //rotate canvas
                    procedure rotateCanvas(var canvasInOut : TDirect2DXYEntityCanvas);
                    procedure resetCanvasRotation(var canvasInOut : TDirect2DXYEntityCanvas);
            protected
                var
                    filled, outlined    : boolean;
                    horizontalAlignment : THorzRectAlign;
                    verticalAlignment   : TVertRectAlign;
                    objectScaleType     : EScaleType;
                    handlePointLT       : TPointF;
                    handlePointXY       : TGeomPoint;
                    graphicBox          : TGeomBox; //graphicBox defines the position of the Arc, Ellipse, Rectangle and Text drawing entities before rotation
                //position graphic box
                    procedure dimensionAndPositionGraphicBox(const boxWidthIn, boxHeightIn : double);
                //draw graphic
                    procedure drawGraphicToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DXYEntityCanvas       ); virtual;
            public
                //constructor
                    constructor create(); overload;
                    constructor create( const   filledIn                : boolean;
                                        const   lineThicknessIn         : integer;
                                        const   rotationAngleIn         : double;
                                        const   scaleTypeIn             : EScaleType;
                                        const   horizontalAlignmentIn   : THorzRectAlign;
                                        const   verticalAlignmentIn     : TVertRectAlign;
                                        const   fillColourIn,
                                                lineColourIn            : TColor;
                                        const   lineStyleIn             : TPenStyle;
                                        const   handlePointXYIn         : TGeomPoint        ); overload;
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setRotationAngle(const rotationAngleIn : double);
                    procedure setAlignment( const horAlignmentIn    : THorzRectAlign;
                                            const vertAlignmentIn   : TVertRectAlign );
                    procedure setHandlePoint(const xIn, yIn : double);
                //draw to canvas
                    procedure drawToCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DXYEntityCanvas       ); virtual;
                    class procedure drawAllToCanvas(const arrGraphicEntitiesIn  : TArray<TGraphicEntity>;
                                                    const axisConverterIn       : TDrawingAxisConverter;
                                                    var canvasInOut             : TDirect2DXYEntityCanvas       ); static;
                //bounding box
                    function determineBoundingBox() : TGeomBox; overload; virtual;
                    class function determineBoundingBox(const arrGraphicEntitiesIn : TArray<TGraphicEntity>) : TGeomBox; overload; static;
        end;

implementation

    

        //rotate canvas
            procedure TGraphicEntity.rotateCanvas(var canvasInOut : TDirect2DXYEntityCanvas);
                var
                    transformMatrix : TD2DMatrix3x2F;
                begin
                    //get transformation matrix:
                    //positive angles result in anti-clockwise rotation of the canvas
                    //which results in clockwise rotation of the drawing entities
                        transformMatrix := TD2DMatrix3x2F.Rotation( -rotationAngle, handlePointLT.X, handlePointLT.Y );

                    //rotate canvas
                        canvasInOut.RenderTarget.SetTransform( transformMatrix );
                end;

            procedure TGraphicEntity.resetCanvasRotation(var canvasInOut : TDirect2DXYEntityCanvas);
                begin
                    canvasInOut.RenderTarget.SetTransform( TD2DMatrix3x2F.Identity );
                end;

    //protected
        //position graphic box
            procedure TGraphicEntity.dimensionAndPositionGraphicBox(const boxWidthIn, boxHeightIn : double);
                var
                    boxCentreX, boxCentreY : double;
                begin
                    //if the dimensions entered are 0 then the graphic box is a dot at the handle point
                        if ( IsZero( boxWidthIn ) AND IsZero( boxHeightIn ) ) then
                            graphicBox := TGeomBox.determineBoundingBox( [ handlePointXY, handlePointXY ] );

                    //dimension the box
                        graphicBox.setDimensions( boxWidthIn, boxHeightIn );

                    //determine the horizontal centre of the box
                        case (horizontalAlignment) of
                            THorzRectAlign.Left:
                                boxCentreX := handlePointXY.X + boxWidthIn / 2;

                            THorzRectAlign.Center:
                                boxCentreX := handlePointXY.X;

                            THorzRectAlign.Right:
                                boxCentreX := handlePointXY.X - boxWidthIn / 2;
                        end;

                    //determine the vertical centre of the box
                        case (verticalAlignment) of
                            TVertRectAlign.Bottom:
                                boxCentreY := handlePointXY.y + boxHeightIn / 2;

                            TVertRectAlign.Center:
                                boxCentreY := handlePointXY.y;

                            TVertRectAlign.Top:
                                boxCentreY := handlePointXY.y - boxHeightIn / 2;
                        end;

                    //shift the box to the centre values
                        graphicBox.setCentrePoint( boxCentreX, boxCentreY );
                end;

        //draw graphic
            procedure TGraphicEntity.drawGraphicToCanvas(   const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DXYEntityCanvas           );
                begin
                    //nothing here
                end;

    //public
        //constructor
            constructor TGraphicEntity.create();
                begin
                    inherited create();
                end;

            constructor TGraphicEntity.create(  const   filledIn                : boolean;
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
                    inherited create();

                    filled              := filledIn;
                    outlined            := ( 0 < lineThicknessIn );
                    lineThickness       := lineThicknessIn;
                    setRotationAngle( rotationAngleIn );
                    objectScaleType     := scaleTypeIn;
                    horizontalAlignment := horizontalAlignmentIn;
                    verticalAlignment   := verticalAlignmentIn;
                    fillColour          := fillColourIn;
                    lineColour          := lineColourIn;
                    lineStyle           := lineStyleIn;
                    handlePointXY.copyPoint( handlePointXYIn );

                    dimensionAndPositionGraphicBox( 0, 0 );
                end;

        //destructor
            destructor TGraphicEntity.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            procedure TGraphicEntity.setRotationAngle(const rotationAngleIn : double);
                begin
                    rotationAngle := FMod( rotationAngleIn, 360 );

                    mustRotateCanvas := NOT( IsZero( rotationAngle, 1e-3 ) );
                end;

            procedure TGraphicEntity.setAlignment(  const horAlignmentIn    : THorzRectAlign;
                                                    const vertAlignmentIn   : TVertRectAlign );
                begin
                    horizontalAlignment := horAlignmentIn;
                    verticalAlignment   := vertAlignmentIn;

                    dimensionAndPositionGraphicBox(
                                                        graphicBox.calculateXDimension(),
                                                        graphicBox.calculateYDimension()
                                                  );
                end;

            procedure TGraphicEntity.setHandlePoint(const xIn, yIn : double);
                begin
                    handlePointXY.setPoint( xIn, yIn );

                    dimensionAndPositionGraphicBox(
                                                        graphicBox.calculateXDimension(),
                                                        graphicBox.calculateYDimension()
                                                  );
                end;

        //draw to canvas
            procedure TGraphicEntity.drawToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DXYEntityCanvas       );
                begin
                    //calculate handle point on canvas
                        handlePointLT := axisConverterIn.XY_to_LT( handlePointXY );

                    //canvas rotation
                        if ( mustRotateCanvas ) then
                            rotateCanvas( canvasInOut );

                    //fill properties
                        setFillProperties( canvasInOut );

                    //line properties
                        setLineProperties( canvasInOut );

                    //draw graphic object
                        drawGraphicToCanvas( axisConverterIn, canvasInOut );

                    //reset canvas rotation
                        if ( mustRotateCanvas ) then
                            resetCanvasRotation( canvasInOut );
                end;

            class procedure TGraphicEntity.drawAllToCanvas( const arrGraphicEntitiesIn   : TArray<TGraphicEntity>;
                                                            const axisConverterIn       : TDrawingAxisConverter;
                                                            var canvasInOut             : TDirect2DXYEntityCanvas           );
                var
                    i, arrLen : integer;
                begin
                    arrLen := length( arrGraphicEntitiesIn );

                    for i := 0 to ( arrLen - 1 ) do
                        arrGraphicEntitiesIn[i].drawToCanvas( axisConverterIn, canvasInOut );
                end;

        //bounding box
            function TGraphicEntity.determineBoundingBox() : TGeomBox;
                var
                    boundingBoxOut : TGeomBox;
                begin
                    case ( objectScaleType ) of
                        EScaleType.scCanvas:
                            boundingBoxOut := TGeomBox.determineBoundingBox( [ handlePointXY, handlePointXY ] );

                        EScaleType.scDrawing:
                            begin
                                var boundingBoxPoints : TArray<TGeomPoint> := graphicBox.getCornerPoints2D();

                                TGeomPoint.rotateArrPoints( rotationAngle, handlePointXY, boundingBoxPoints );

                                boundingBoxOut := TGeomBox.determineBoundingBox( boundingBoxPoints );
                            end;
                    end;

                    result := boundingBoxOut;
                end;

            class function TGraphicEntity.determineBoundingBox(const arrGraphicEntitiesIn : TArray<TGraphicEntity>) : TGeomBox;
                var
                    i, graphicObjectsCount  : integer;
                    arrBoundingBoxes        : TArray<TGeomBox>;
                begin
                    graphicObjectsCount := length( arrGraphicEntitiesIn );

                    SetLength( arrBoundingBoxes, graphicObjectsCount );

                    for i := 0 to (graphicObjectsCount - 1) do
                        arrBoundingBoxes[i] := arrGraphicEntitiesIn[i].determineBoundingBox();

                    result := TGeomBox.determineBoundingBox( arrBoundingBoxes );
                end;

end.
