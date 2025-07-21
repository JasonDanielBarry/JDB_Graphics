unit GraphicArrowClass;

interface

    uses
        Winapi.D2D1,
        system.SysUtils, system.UITypes,
        Vcl.Direct2D, vcl.Graphics,
        GeomBox, GeometryTypes,
        GeometryBaseClass,
        GeomLineClass, GeomPolygonClass,
        GraphicDrawingTypes,
        DrawingAxisConversionClass,
        GraphicLineClass, GraphicPolygonClass,
        GraphicEntityGroupClass
        ;

    type
        TGraphicArrow = class(TGraphicEntityGroup)
            private
                var
                    arrowHeadPoint, arrowTailPoint  : TGeomPoint;
                    arrowHead                       : TGeomPolygon;
                    arrowTail                       : TGeomLine;
                //create arrow geometry
                    function createArrowHead() : TGeomPolygon;
                    function createArrowTail() : TGeomLine;
                    procedure createArrowGeometry(  const   arrowLengthIn,
                                                            directionAngleIn    : double;
                                                    const   arrowOriginIn       : EArrowOrigin;
                                                    const   arrowOriginPointIn  : TGeomPoint    );
            public
                //constructor
                    constructor create( const   filledIn            : boolean;
                                        const   lineThicknessIn     : integer;
                                        const   arrowLengthIn,
                                                directionAngleIn    : double;
                                        const   fillColourIn,
                                                lineColourIn        : TColor;
                                        const   lineStyleIn         : TPenStyle;
                                        const   arrowOriginIn       : EArrowOrigin;
                                        const   arrowOriginPointIn  : TGeomPoint    );
                //destructor
                    destructor destroy(); override;
                //get geometry
                    function getArrowHeadPoint() : TGeomPoint;
                    function getArrowTailPoint() : TGeomPoint;
        end;

implementation

    const
        ARROW_HEAD_HEIGHT   : double = 0.066;
        ARROW_HEAD_WIDTH    : double = 0.022;

    //private
        //create arrow geometry
            function TGraphicArrow.createArrowHead() : TGeomPolygon;
                var
                    arrowHeadPolygonOut : TGeomPolygon;
                begin
                    arrowHeadPolygonOut := TGeomPolygon.create();

                    arrowHeadPolygonOut.addVertex( 1, 0 );
                    arrowHeadPolygonOut.addVertex( 1 - ARROW_HEAD_HEIGHT, ARROW_HEAD_WIDTH );
                    arrowHeadPolygonOut.addVertex( 1 - ARROW_HEAD_HEIGHT, -ARROW_HEAD_WIDTH );

                    result := arrowHeadPolygonOut;
                end;

            function TGraphicArrow.createArrowTail() : TGeomLine;
                var
                    arrowTailLineOut : TGeomLine;
                begin
                    arrowTailLineOut := TGeomLine.create();

                    arrowTailLineOut.setStartPoint( 0, 0 );
                    arrowTailLineOut.setEndPoint( 1 - ARROW_HEAD_HEIGHT, 0 );

                    result := arrowTailLineOut;
                end;

            procedure TGraphicArrow.createArrowGeometry(const   arrowLengthIn,
                                                                directionAngleIn    : double;
                                                        const   arrowOriginIn       : EArrowOrigin;
                                                        const   arrowOriginPointIn  : TGeomPoint    );
                var
                    referencePoint : TGeomPoint;

                begin
                    //objects created here
                        arrowHead := createArrowHead();
                        arrowTail := createArrowTail();

                    //the origin sits by default at the tail
                        if ( arrowOriginIn = EArrowOrigin.aoHead ) then
                            TGeomBase.shift( -1, 0, [arrowHead, arrowTail] );

                        referencePoint := TGeomPoint.create( 0, 0 );

                    //scale the arrow - the arrow is 1 unit in length so the required length IS the scale factor
                        TGeomBase.scale( arrowLengthIn, referencePoint, [arrowHead, arrowTail] );

                    //rotate the arrow
                        TGeomBase.rotate( directionAngleIn, referencePoint, [arrowHead, arrowTail] );

                    //shift the arrow
                        TGeomBase.shift( arrowOriginPointIn.x, arrowOriginPointIn.y, [arrowHead, arrowTail] );

                    //get the head and tail points
                        arrowHeadPoint := arrowHead.getArrGeomPoints()[0];
                        arrowTailPoint := arrowTail.getStartPoint();
                end;

    //public
        //constructor
            constructor TGraphicArrow.create(   const   filledIn            : boolean;
                                                const   lineThicknessIn     : integer;
                                                const   arrowLengthIn,
                                                        directionAngleIn    : double;
                                                const   fillColourIn,
                                                        lineColourIn        : TColor;
                                                const   lineStyleIn         : TPenStyle;
                                                const   arrowOriginIn       : EArrowOrigin;
                                                const   arrowOriginPointIn  : TGeomPoint    );
                var
                    headGraphic : TGraphicPolygon;
                    tailGraphic : TGraphicLine;
                begin
                    inherited create();

                    //create the arrow geometry
                        createArrowGeometry( arrowLengthIn, directionAngleIn, arrowOriginIn, arrowOriginPointIn );

                    //create graphic objects
                        headGraphic := TGraphicPolygon.create( filledIn, lineThicknessIn, fillColourIn, lineColourIn, lineStyleIn, arrowHead );
                        tailGraphic := TGraphicLine.create( lineThicknessIn, lineColourIn, lineStyleIn, arrowTail );

                        addGraphicEntitysToGroup( [headGraphic, tailGraphic] );

                    //free geometry objects
                        FreeAndNil( arrowHead );
                        FreeAndNil( arrowTail );
                end;

        //destructor
            destructor TGraphicArrow.destroy();
                begin
                    inherited destroy();
                end;

        //get geometry
            function TGraphicArrow.getArrowHeadPoint() : TGeomPoint;
                begin
                    result := arrowHeadPoint;
                end;

            function TGraphicArrow.getArrowTailPoint() : TGeomPoint;
                begin
                    result := arrowTailPoint;
                end;


end.
