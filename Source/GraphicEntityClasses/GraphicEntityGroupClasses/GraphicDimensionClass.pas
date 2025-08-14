unit GraphicDimensionClass;

interface

    uses
        System.SysUtils, system.Math, System.Types,
        vcl.Graphics,
        GeometryTypes,
        GeometryBaseClass, GeomLineClass,
        GenericXYEntityCanvasClass,
        GraphicLineClass, GraphicTextClass,
        GraphicEntityGroupClass
        ;

    type
        TGraphicDimension = class(TGraphicEntityGroup)
            private
                //create the dimension line group
                    function createDimensionLineGroup(  const dimensionOffsetIn : double;
                                                        const dimensionLineIn   : TGeomLine ) : TArray<TGeomLine>;
            public
                //constructor
                    constructor create(
                                            const dimensionOffsetIn : double;
                                            const dimensionTextIn   : string;
                                            const colourIn          : TColor;
                                            const dimensionLineIn   : TGeomLine
                                      );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //create the dimension line group
            function TGraphicDimension.createDimensionLineGroup(const dimensionOffsetIn : double;
                                                                const dimensionLineIn   : TGeomLine) : TArray<TGeomLine>;
                const
                    SIDE_LINE_LENGTH : double = 0.05;
                var
                    dimLineAngle, dimLineLength     : double;
                    dimLineShift,
                    dimLineRotationReferencePoint   : TGeomPoint;
                    leftLine, dimLine, rightLine    : TGeomLine;
                begin
                    //the dimension line is 1 unit long and can be scaled

                    //line group creation
                        //left line
                            leftLine := TGeomLine.create();

                            leftLine.setStartPoint( -0.5, -SIDE_LINE_LENGTH/2 );
                            leftLine.setEndPoint( -0.5, SIDE_LINE_LENGTH/2 );

                        //dimension line
                            dimLine := TGeomLine.create();

                            dimLine.setStartPoint( -0.5, 0 );
                            dimLine.setEndPoint( 0.5, 0 );

                        //right line
                            rightLine := TGeomLine.create();

                            rightLine.setStartPoint( 0.5, -SIDE_LINE_LENGTH/2 );
                            rightLine.setEndPoint( 0.5, SIDE_LINE_LENGTH/2 );

                    //position line group
                        //shift line group
                            dimLineShift := dimensionLineIn.calculateCentroidPoint();

                            TGeomBase.shift( dimLineShift.x, dimLineShift.y, [leftLine, dimLine, rightLine] );

                            //this shift ensures the bottom of the dim line group aligns with the rotation reference point
                                TGeomBase.shift( 0, SIDE_LINE_LENGTH/2, [leftLine, dimLine, rightLine] );

                        //scale line group
                            dimLineRotationReferencePoint.copyPoint( dimLineShift );

                            dimLineLength := dimensionLineIn.calculateLength();

                            TGeomBase.scale( dimLineLength, dimLineRotationReferencePoint, [leftLine, dimLine, rightLine] );

                            //apply the offset here AFTER scaling but BEFORE rotation
                                TGeomBase.shift( 0, dimensionOffsetIn, [leftLine, dimLine, rightLine] );

                        //rotate line group
                            dimLineAngle := dimensionLineIn.calculate2DLineAngle();

                            TGeomBase.rotate( dimLineAngle, dimLineRotationReferencePoint, [leftLine, dimLine, rightLine] );

                    result := [leftLine, dimLine, rightLine];
                end;

    //public
        //constructor
            constructor TGraphicDimension.create(
                                                    const dimensionOffsetIn : double;
                                                    const dimensionTextIn   : string;
                                                    const colourIn          : TColor;
                                                    const dimensionLineIn   : TGeomLine
                                                );
                var
                    i, arrLen           : integer;
                    textRotation        : double;
                    dimensionText       : string;
                    textHandlePoint     : TGeomPoint;
                    graphicLine         : TGraphicLine;
                    graphicText         : TGraphicText;
                    dimensionLineGroup  : TArray<TGeomLine>;
                begin
                    //create lines
                        dimensionLineGroup := createDimensionLineGroup( dimensionOffsetIn, dimensionLineIn );
                        textHandlePoint := dimensionLineGroup[1].calculateCentroidPoint();

                        arrLen := Length( dimensionLineGroup );

                        for i := 0 to ( arrLen - 1 ) do
                            begin
                                graphicLine := TGraphicLine.create( 1, colourIn, TPenStyle.psSolid, dimensionLineGroup[i] );

                                addGraphicEntityToGroup( graphicLine );

                                FreeAndNil( dimensionLineGroup[i] );
                            end;

                    //create text
                        textRotation := dimensionLineIn.calculate2DLineAngle();

                        textRotation := FMod( textRotation, 180 );

                        if ( 90 < abs(textRotation) ) then
                            textRotation := textRotation + 180;

                        if ( dimensionTextIn = '' ) then
                            dimensionText := FloatToStrF( dimensionLineIn.calculateLength(), ffFixed, 5, 2 )
                        else
                            dimensionText := dimensionTextIn;

                        graphicText := TGraphicText.create( False,
                                                            9,
                                                            textRotation,
                                                            dimensionText,
                                                            EScaleType.scCanvas,
                                                            THorzRectAlign.Center,
                                                            TVertRectAlign.Bottom,
                                                            colourIn,
                                                            [],
                                                            textHandlePoint         );

                        addGraphicEntityToGroup( graphicText );
                end;

        //destructor
            destructor TGraphicDimension.destroy();
                begin
                    inherited destroy();
                end;

end.
