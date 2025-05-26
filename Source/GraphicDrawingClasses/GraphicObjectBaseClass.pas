unit GraphicObjectBaseClass;

interface

    uses
        Winapi.D2D1,
        system.UITypes, system.Math, System.Classes, System.Types,
        Vcl.Direct2D, vcl.Graphics, vcl.Themes,
        GeometryTypes, GeomBox,
        GraphicDrawingTypes,
        DrawingAxisConversionClass
        ;

    type
        TGraphicObject = class
            private
                var
                    mustRotateCanvas    : boolean;
                    lineThickness       : integer;
                    rotationAngle       : double;
                    fillColour,
                    lineColour          : TColor;
                    lineStyle           : TPenStyle;
                //set canvas properties for drawing
                    procedure setFillProperties(var canvasInOut : TDirect2DCanvas);
                    procedure setLineProperties(var canvasInOut : TDirect2DCanvas);
                //rotate canvas
                    procedure rotateCanvas( const axisConverterIn   : TDrawingAxisConverter;
                                            var canvasInOut         : TDirect2DCanvas       );
                    procedure resetCanvasRotation(var canvasInOut : TDirect2DCanvas);
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
                                                    var canvasInOut         : TDirect2DCanvas       ); virtual;
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
                                            var canvasInOut         : TDirect2DCanvas       ); virtual;
                    class procedure drawAllToCanvas(const arrGraphicObjectsIn   : TArray<TGraphicObject>;
                                                    const axisConverterIn       : TDrawingAxisConverter;
                                                    var canvasInOut             : TDirect2DCanvas       ); static;
                //bounding box
                    function determineBoundingBox() : TGeomBox; overload; virtual;
                    class function determineBoundingBox(const arrGraphicObjectsIn : TArray<TGraphicObject>) : TGeomBox; overload; static;
        end;

implementation

    //private
        //set canvas properties for drawing
            procedure TGraphicObject.setFillProperties(var canvasInOut : TDirect2DCanvas);
                begin
                    //hollow object
                        if NOT( filled ) then
                            begin
                                canvasInOut.Brush.Style := TBrushStyle.bsClear;
                                exit();
                            end;

                    canvasInOut.Brush.Color := TStyleManager.ActiveStyle.GetSystemColor( fillColour );
                    canvasInOut.Brush.Style := TBrushStyle.bsSolid;
                end;

            procedure TGraphicObject.setLineProperties(var canvasInOut : TDirect2DCanvas);
                begin
                    if ( lineThickness = 0 ) then
                        exit();

                    canvasInOut.Pen.Color := TStyleManager.ActiveStyle.GetSystemColor( lineColour );
                    canvasInOut.Pen.Style := lineStyle;
                    canvasInOut.Pen.Width := lineThickness;
                end;

        //rotate canvas
            procedure TGraphicObject.rotateCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       );
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

            procedure TGraphicObject.resetCanvasRotation(var canvasInOut : TDirect2DCanvas);
                begin
                    canvasInOut.RenderTarget.SetTransform( TD2DMatrix3x2F.Identity );
                end;

    //protected
        //position graphic box
            procedure TGraphicObject.dimensionAndPositionGraphicBox(const boxWidthIn, boxHeightIn : double);
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
            procedure TGraphicObject.drawGraphicToCanvas(   const axisConverterIn   : TDrawingAxisConverter;
                                                            var canvasInOut         : TDirect2DCanvas           );
                begin
                    //nothing here
                end;

    //public
        //constructor
            constructor TGraphicObject.create();
                begin
                    inherited create();
                end;

            constructor TGraphicObject.create(  const   filledIn                : boolean;
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
                    outlined            := 0 < lineThicknessIn;
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
            destructor TGraphicObject.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            procedure TGraphicObject.setRotationAngle(const rotationAngleIn : double);
                begin
                    rotationAngle := FMod( rotationAngleIn, 360 );

                    mustRotateCanvas := NOT( IsZero( rotationAngle, 1e-3 ) );
                end;

            procedure TGraphicObject.setAlignment(  const horAlignmentIn    : THorzRectAlign;
                                                    const vertAlignmentIn   : TVertRectAlign );
                begin
                    horizontalAlignment := horAlignmentIn;
                    verticalAlignment   := vertAlignmentIn;

                    dimensionAndPositionGraphicBox(
                                                        graphicBox.calculateXDimension(),
                                                        graphicBox.calculateYDimension()
                                                  );
                end;

            procedure TGraphicObject.setHandlePoint(const xIn, yIn : double);
                begin
                    handlePointXY.setPoint( xIn, yIn );

                    dimensionAndPositionGraphicBox(
                                                        graphicBox.calculateXDimension(),
                                                        graphicBox.calculateYDimension()
                                                  );
                end;

        //draw to canvas
            procedure TGraphicObject.drawToCanvas(  const axisConverterIn   : TDrawingAxisConverter;
                                                    var canvasInOut         : TDirect2DCanvas       );
                begin
                    //calculate handle point on canvas
                        handlePointLT := axisConverterIn.XY_to_LT( handlePointXY );

                    //canvas rotation
                        if ( mustRotateCanvas ) then
                            rotateCanvas( axisConverterIn, canvasInOut );

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

            class procedure TGraphicObject.drawAllToCanvas( const arrGraphicObjectsIn   : TArray<TGraphicObject>;
                                                            const axisConverterIn       : TDrawingAxisConverter;
                                                            var canvasInOut             : TDirect2DCanvas           );
                var
                    i, arrLen : integer;
                begin
                    arrLen := length( arrGraphicObjectsIn );

                    for i := 0 to ( arrLen - 1 ) do
                        arrGraphicObjectsIn[i].drawToCanvas( axisConverterIn, canvasInOut );
                end;

        //bounding box
            function TGraphicObject.determineBoundingBox() : TGeomBox;
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

            class function TGraphicObject.determineBoundingBox(const arrGraphicObjectsIn : TArray<TGraphicObject>) : TGeomBox;
                var
                    i, graphicObjectsCount  : integer;
                    arrBoundingBoxes        : TArray<TGeomBox>;
                begin
                    graphicObjectsCount := length( arrGraphicObjectsIn );

                    SetLength( arrBoundingBoxes, graphicObjectsCount );

                    for i := 0 to (graphicObjectsCount - 1) do
                        arrBoundingBoxes[i] := arrGraphicObjectsIn[i].determineBoundingBox();

                    result := TGeomBox.determineBoundingBox( arrBoundingBoxes );
                end;

end.
