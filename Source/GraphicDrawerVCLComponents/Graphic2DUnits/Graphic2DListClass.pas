unit Graphic2DListClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UIConsts, system.UITypes, system.Generics.Collections, System.Classes,
            vcl.Graphics, vcl.StdCtrls,
        //custom
            GeometryTypes,
            GeomLineClass, GeomPolyLineClass, GeomPolygonClass,
            DrawingAxisConversionClass,
            Direct2DXYEntityCanvasClass,
            GraphicEntityTypes,
            GraphicEntityBaseClass,
            GraphicArcClass, GraphicEllipseClass, GraphicGeometryClass,
            GraphicLineClass, GraphicPolylineClass, GraphicPolygonClass,
            GraphicRectangleClass, GraphicTextClass, GraphicArrowClass,
            GraphicArrowGroupClass, GraphicDimensionClass,
            GraphicEntityListBaseClass
            ;

    type
        TGraphic2DList = class(TGraphicEntityListBase)
            public
                //add different drawing graphic objects
                    //arc
                        procedure addArc(   const   arcCentreXIn, arcCentreYIn,
                                                    arcXRadiusIn, arcYRadiusIn,
                                                    startAngleIn, endAngleIn    : double;
                                            const   filledIn                    : boolean = False;
                                            const   lineThicknessIn             : integer = 2;
                                            const   rotationAngleIn             : double = 0;
                                            const   fillColourIn                : TColor = TColors.Null;
                                            const   lineColourIn                : TColor = TColors.SysWindowText;
                                            const   lineStyleIn                 : TPenStyle = TPenStyle.psSolid );
                    //ellipse
                        procedure addEllipse(   const   diameterXIn,  diameterYIn,
                                                        handleXIn,    handleYIn     : double;
                                                const   filledIn                    : boolean = True;
                                                const   lineThicknessIn             : integer = 2;
                                                const   rotationAngleIn             : double = 0;
                                                const   scaleTypeIn                 : EScaleType = EScaleType.scDrawing;
                                                const   horizontalAlignmentIn       : THorzRectAlign = THorzRectAlign.Center;
                                                const   verticalAlignmentIn         : TVertRectAlign = TVertRectAlign.Center;
                                                const   fillColourIn                : TColor = TColors.Null;
                                                const   lineColourIn                : TColor = TColors.SysWindowText;
                                                const   lineStyleIn                 : TPenStyle = TPenStyle.psSolid             );
                    //geometry
                        //line
                            procedure addLine(  const lineIn            : TGeomLine;
                                                const lineThicknessIn   : integer = 2;
                                                const colourIn          : TColor = TColors.SysWindowText;
                                                const styleIn           : TPenStyle = TPenStyle.psSolid );
                        //polyline
                            procedure addPolyline(  const polylineIn        : TGeomPolyLine;
                                                    const lineThicknessIn   : integer = 2;
                                                    const colourIn          : TColor = TColors.SysWindowText;
                                                    const styleIn           : TPenStyle = TPenStyle.psSolid );
                        //polygon
                            procedure addPolygon(   const polygonIn         : TGeomPolygon;
                                                    const filledIn          : boolean = True;
                                                    const lineThicknessIn   : integer = 2;
                                                    const fillColourIn      : TColor = TColors.Null;
                                                    const lineColourIn      : TColor = TColors.SysWindowText;
                                                    const lineStyleIn       : TPenStyle = TPenStyle.psSolid     );
                    //rectanlge
                        procedure addRectangle( const   widthIn, heightIn,
                                                        handleXIn, handleYIn    : double;
                                                const   filledIn                : boolean = True;
                                                const   lineThicknessIn         : integer = 2;
                                                const   cornerRadiusIn          : double = 0;
                                                const   rotationAngleIn         : double = 0;
                                                const   scaleTypeIn             : EScaleType = EScaleType.scDrawing;
                                                const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Bottom;
                                                const   fillColourIn            : TColor = TColors.Null;
                                                const   lineColourIn            : TColor = TColors.SysWindowText;
                                                const   lineStyleIn             : TPenStyle = TPenStyle.psSolid             );
                    //text
                        procedure addText(  const   handleXIn, handleYIn    : double;
                                            const   textStringIn            : string;
                                            const   addTextUnderlayIn       : boolean = False;
                                            const   textSizeIn              : integer = 9;
                                            const   rotationAngleIn         : double = 0;
                                            const   scaleTypeIn             : EScaleType = EScaleType.scCanvas;
                                            const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                            const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top;
                                            const   textColourIn            : TColor = TColors.SysWindowText;
                                            const   textFontStylesIn        : TFontStyles = []                      );
                    //groups
                        //arrow
                            procedure addArrow( const   arrowLengthIn,
                                                        directionAngleIn    : double;
                                                const   arrowOriginPointIn  : TGeomPoint;
                                                const   arrowOriginIn       : EArrowOrigin = EArrowOrigin.aoTail;
                                                const   filledIn            : boolean = True;
                                                const   lineThicknessIn     : integer = 3;
                                                const   fillColourIn        : TColor = TColors.Null;
                                                const   lineColourIn        : TColor = TColors.SysWindowText;
                                                const   lineStyleIn         : TPenStyle = TPenStyle.psSolid         );
                        //arrow group
                            //single line
                                procedure addArrowGroup(const   arrowLengthIn           : double;
                                                        const   arrowGroupLineIn        : TGeomLine;
                                                        const   arrowOriginIn           : EArrowOrigin = EArrowOrigin.aoTail;
                                                        const   arrowGroupDirectionIn   : EArrowGroupDirection = EArrowGroupDirection.agdNormal;
                                                        const   userDirectionAngleIn    : double = 0;
                                                        const   filledIn                : boolean = True;
                                                        const   lineThicknessIn         : integer = 3;
                                                        const   fillColourIn            : TColor = TColors.Null;
                                                        const   lineColourIn            : TColor = TColors.SysWindowText;
                                                        const   lineStyleIn             : TPenStyle = TPenStyle.psSolid                         ); overload;
                            //polyline
                                procedure addArrowGroup(const   arrowLengthIn           : double;
                                                        const   arrowGroupPolylineIn    : TGeomPolyLine;
                                                        const   arrowOriginIn           : EArrowOrigin = EArrowOrigin.aoTail;
                                                        const   arrowGroupDirectionIn   : EArrowGroupDirection = EArrowGroupDirection.agdNormal;
                                                        const   userDirectionAngleIn    : double = 0;
                                                        const   filledIn                : boolean = True;
                                                        const   lineThicknessIn         : integer = 3;
                                                        const   fillColourIn            : TColor = TColors.Null;
                                                        const   lineColourIn            : TColor = TColors.SysWindowText;
                                                        const   lineStyleIn             : TPenStyle = TPenStyle.psSolid                         ); overload;
                        //dimension
                            procedure addDimensionLine( const dimensionLineIn   : TGeomLine;
                                                        const dimensionOffsetIn : double = 0;
                                                        const customDimTextIn   : string = '';
                                                        const colourIn          : TColor = TColors.SysWindowText );
        end;

implementation

    //public
        //add different drawing graphic objects
            //arc
                procedure TGraphic2DList.addArc(const   arcCentreXIn, arcCentreYIn,
                                                        arcXRadiusIn, arcYRadiusIn,
                                                        startAngleIn, endAngleIn    : double;
                                                const   filledIn                    : boolean = False;
                                                const   lineThicknessIn             : integer = 2;
                                                const   rotationAngleIn             : double = 0;
                                                const   fillColourIn                : TColor = TColors.Null;
                                                const   lineColourIn                : TColor = TColors.SysWindowText;
                                                const   lineStyleIn                 : TPenStyle = TPenStyle.psSolid );
                    var
                        centrePoint     : TGeomPoint;
                        newGraphicArc   : TGraphicArc;
                    begin
                        centrePoint := TGeomPoint.create( arcCentreXIn, arcCentreYIn );

                        newGraphicArc := TGraphicArc.create(    filledIn,
                                                                lineThicknessIn,
                                                                arcXRadiusIn, arcYRadiusIn,
                                                                startAngleIn, endAngleIn,
                                                                rotationAngleIn,
                                                                fillColourIn, lineColourIn,
                                                                lineStyleIn,
                                                                centrePoint                 );

                        addGraphicEntity( newGraphicArc );
                    end;

            //ellipse
                procedure TGraphic2DList.addEllipse(const   diameterXIn,  diameterYIn,
                                                            handleXIn,    handleYIn     : double;
                                                    const   filledIn                    : boolean = True;
                                                    const   lineThicknessIn             : integer = 2;
                                                    const   rotationAngleIn             : double = 0;
                                                    const   scaleTypeIn                 : EScaleType = EScaleType.scDrawing;
                                                    const   horizontalAlignmentIn       : THorzRectAlign = THorzRectAlign.Center;
                                                    const   verticalAlignmentIn         : TVertRectAlign = TVertRectAlign.Center;
                                                    const   fillColourIn                : TColor = TColors.Null;
                                                    const   lineColourIn                : TColor = TColors.SysWindowText;
                                                    const   lineStyleIn                 : TPenStyle = TPenStyle.psSolid             );
                    var
                        handlePoint         : TGeomPoint;
                        newGraphicEllipse   : TGraphicEllipse;
                    begin
                        handlePoint := TGeomPoint.create( handleXIn, handleYIn );

                        newGraphicEllipse := TGraphicEllipse.create(    filledIn,
                                                                        lineThicknessIn,
                                                                        diameterXIn, diameterYIn,
                                                                        rotationAngleIn,
                                                                        scaleTypeIn,
                                                                        horizontalAlignmentIn,
                                                                        verticalAlignmentIn,
                                                                        fillColourIn,
                                                                        lineColourIn,
                                                                        lineStyleIn,
                                                                        handlePoint                 );

                        addGraphicEntity( newGraphicEllipse );
                    end;

            //geometry
                //line
                    procedure TGraphic2DList.addLine(   const lineIn            : TGeomLine;
                                                        const lineThicknessIn   : integer = 2;
                                                        const colourIn          : TColor = TColors.SysWindowText;
                                                        const styleIn           : TPenStyle = TPenStyle.psSolid );
                        var
                            newGraphicGeometry : TGraphicGeometry;
                        begin
                            newGraphicGeometry := TGraphicLine.create(  lineThicknessIn,
                                                                        colourIn,
                                                                        styleIn,
                                                                        lineIn          );

                            addGraphicEntity( newGraphicGeometry );
                        end;

                //polyline
                    procedure TGraphic2DList.addPolyline(   const polylineIn        : TGeomPolyLine;
                                                            const lineThicknessIn   : integer = 2;
                                                            const colourIn          : TColor = TColors.SysWindowText;
                                                            const styleIn           : TPenStyle = TPenStyle.psSolid );
                        var
                            newGraphicGeometry : TGraphicGeometry;
                        begin
                            newGraphicGeometry := TGraphicPolyline.create(  lineThicknessIn,
                                                                            colourIn,
                                                                            styleIn,
                                                                            polylineIn      );

                            addGraphicEntity( newGraphicGeometry );
                        end;

                //polygon
                    procedure TGraphic2DList.addPolygon(const polygonIn         : TGeomPolygon;
                                                        const filledIn          : boolean = True;
                                                        const lineThicknessIn   : integer = 2;
                                                        const fillColourIn      : TColor = TColors.Null;
                                                        const lineColourIn      : TColor = TColors.SysWindowText;
                                                        const lineStyleIn       : TPenStyle = TPenStyle.psSolid );
                        var
                            newGraphicGeometry : TGraphicGeometry;
                        begin
                            newGraphicGeometry := TGraphicPolygon.create(   filledIn,
                                                                            lineThicknessIn,
                                                                            fillColourIn,
                                                                            lineColourIn,
                                                                            lineStyleIn,
                                                                            polygonIn       );

                            addGraphicEntity( newGraphicGeometry );
                        end;

            //rectanlge
                procedure TGraphic2DList.addRectangle(  const   widthIn, heightIn,
                                                                handleXIn, handleYIn    : double;
                                                        const   filledIn                : boolean = True;
                                                        const   lineThicknessIn         : integer = 2;
                                                        const   cornerRadiusIn          : double = 0;
                                                        const   rotationAngleIn         : double = 0;
                                                        const   scaleTypeIn             : EScaleType = EScaleType.scDrawing;
                                                        const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                        const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Bottom;
                                                        const   fillColourIn            : TColor = TColors.Null;
                                                        const   lineColourIn            : TColor = TColors.SysWindowText;
                                                        const   lineStyleIn             : TPenStyle = TPenStyle.psSolid             );
                    var
                        newGraphicRectangle : TGraphicRectangle;
                        handlePoint         : TGeomPoint;
                    begin
                        handlePoint := TGeomPoint.create( handleXIn, handleYIn );

                        newGraphicRectangle := TGraphicRectangle.create(    filledIn,
                                                                            lineThicknessIn,
                                                                            cornerRadiusIn,
                                                                            widthIn, heightIn,
                                                                            rotationAngleIn,
                                                                            scaleTypeIn,
                                                                            horizontalAlignmentIn,
                                                                            verticalAlignmentIn,
                                                                            fillColourIn,
                                                                            lineColourIn,
                                                                            lineStyleIn,
                                                                            handlePoint             );

                        addGraphicEntity( newGraphicRectangle );
                    end;

            //text
                procedure TGraphic2DList.addText(   const   handleXIn, handleYIn    : double;
                                                    const   textStringIn            : string;
                                                    const   addTextUnderlayIn       : boolean = False;
                                                    const   textSizeIn              : integer = 9;
                                                    const   rotationAngleIn         : double = 0;
                                                    const   scaleTypeIn             : EScaleType = EScaleType.scCanvas;
                                                    const   horizontalAlignmentIn   : THorzRectAlign = THorzRectAlign.Left;
                                                    const   verticalAlignmentIn     : TVertRectAlign = TVertRectAlign.Top;
                                                    const   textColourIn            : TColor = TColors.SysWindowText;
                                                    const   textFontStylesIn        : TFontStyles = []                      );
                    var
                        handlePoint     : TGeomPoint;
                        newGraphicText  : TGraphicText;
                    begin
                        if ( trim(textStringIn) = '' ) then
                            exit();

                        handlePoint := TGeomPoint.create( handleXIn, handleYIn );

                        newGraphicText := TGraphicText.create(  addTextUnderlayIn,
                                                                textSizeIn,
                                                                rotationAngleIn,
                                                                trim( textStringIn ),
                                                                scaleTypeIn,
                                                                horizontalAlignmentIn,
                                                                verticalAlignmentIn,
                                                                textColourIn,
                                                                textFontStylesIn,
                                                                handlePoint             );

                        addGraphicEntity( newGraphicText );
                    end;

            //groups
                //arrow
                    procedure TGraphic2DList.addArrow(  const   arrowLengthIn,
                                                                directionAngleIn    : double;
                                                        const   arrowOriginPointIn  : TGeomPoint;
                                                        const   arrowOriginIn       : EArrowOrigin = EArrowOrigin.aoTail;
                                                        const   filledIn            : boolean = True;
                                                        const   lineThicknessIn     : integer = 3;
                                                        const   fillColourIn        : TColor = TColors.Null;
                                                        const   lineColourIn        : TColor = TColors.SysWindowText;
                                                        const   lineStyleIn         : TPenStyle = TPenStyle.psSolid         );
                        var
                            newGraphicArrow : TGraphicArrow;
                        begin
                            newGraphicArrow := TGraphicArrow.create(    filledIn,
                                                                        lineThicknessIn,
                                                                        arrowLengthIn,
                                                                        directionAngleIn,
                                                                        fillColourIn,
                                                                        lineColourIn,
                                                                        lineStyleIn,
                                                                        arrowOriginIn,
                                                                        arrowOriginPointIn  );

                            addGraphicEntity( newGraphicArrow );
                        end;

                //arrow group
                    procedure TGraphic2DList.addArrowGroup( const   arrowLengthIn           : double;
                                                            const   arrowGroupLineIn        : TGeomLine;
                                                            const   arrowOriginIn           : EArrowOrigin = EArrowOrigin.aoTail;
                                                            const   arrowGroupDirectionIn   : EArrowGroupDirection = EArrowGroupDirection.agdNormal;
                                                            const   userDirectionAngleIn    : double = 0;
                                                            const   filledIn                : boolean = True;
                                                            const   lineThicknessIn         : integer = 3;
                                                            const   fillColourIn            : TColor = TColors.Null;
                                                            const   lineColourIn            : TColor = TColors.SysWindowText;
                                                            const   lineStyleIn             : TPenStyle = TPenStyle.psSolid                             );
                        var
                            newGraphicArrowGroup : TGraphicArrowGroup;
                        begin
                            newGraphicArrowGroup := TGraphicArrowGroup.create(  filledIn,
                                                                                lineThicknessIn,
                                                                                arrowLengthIn,
                                                                                userDirectionAngleIn,
                                                                                fillColourIn,
                                                                                lineColourIn,
                                                                                lineStyleIn,
                                                                                arrowOriginIn,
                                                                                arrowGroupDirectionIn,
                                                                                arrowGroupLineIn        );

                            addGraphicEntity( newGraphicArrowGroup );
                        end;

                    procedure TGraphic2DList.addArrowGroup( const   arrowLengthIn           : double;
                                                            const   arrowGroupPolylineIn    : TGeomPolyLine;
                                                            const   arrowOriginIn           : EArrowOrigin = EArrowOrigin.aoTail;
                                                            const   arrowGroupDirectionIn   : EArrowGroupDirection = EArrowGroupDirection.agdNormal;
                                                            const   userDirectionAngleIn    : double = 0;
                                                            const   filledIn                : boolean = True;
                                                            const   lineThicknessIn         : integer = 3;
                                                            const   fillColourIn            : TColor = TColors.Null;
                                                            const   lineColourIn            : TColor = TColors.SysWindowText;
                                                            const   lineStyleIn             : TPenStyle = TPenStyle.psSolid                         );
                        var
                            newGraphicArrowGroup : TGraphicArrowGroup;
                        begin
                            newGraphicArrowGroup := TGraphicArrowGroup.create(  filledIn,
                                                                                lineThicknessIn,
                                                                                arrowLengthIn,
                                                                                userDirectionAngleIn,
                                                                                fillColourIn,
                                                                                lineColourIn,
                                                                                lineStyleIn,
                                                                                arrowOriginIn,
                                                                                arrowGroupDirectionIn,
                                                                                arrowGroupPolylineIn    );

                            addGraphicEntity( newGraphicArrowGroup );
                        end;

                //dimension
                    procedure TGraphic2DList.addDimensionLine(  const dimensionLineIn   : TGeomLine;
                                                                const dimensionOffsetIn : double = 0;
                                                                const customDimTextIn   : string = '';
                                                                const colourIn          : TColor = TColors.SysWindowText );
                        var
                            newGraphicDimension : TGraphicDimension;
                        begin
                            newGraphicDimension := TGraphicDimension.create( dimensionOffsetIn, customDimTextIn, colourIn, dimensionLineIn );

                            addGraphicEntity( newGraphicDimension );
                        end;

end.
