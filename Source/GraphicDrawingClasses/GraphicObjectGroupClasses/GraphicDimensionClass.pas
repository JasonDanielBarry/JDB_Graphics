unit GraphicDimensionClass;

interface

    uses
        System.SysUtils, system.UITypes, system.Math, System.Classes, System.Types,
        vcl.Graphics,
        GeometryTypes,
        GeometryBaseClass, GeomLineClass,
        GraphicDrawingTypes,
        GraphicLineClass, GraphicTextClass,
        GraphicObjectGroupClass
        ;

    type
        TGraphicDimension = class(TGraphicObjectGroup)
            private
                //create the dimension line group
                    function createDimensionLineGroup(const dimensionLineIn : TGeomLine) : TArray<TGeomLine>;
            public
                //constructor
                    constructor create(
                                            const customTextIn      : string;
                                            const colourIn          : TColor;
                                            const dimensionLineIn   : TGeomLine
                                      );
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //create the dimension line group
            function TGraphicDimension.createDimensionLineGroup(const dimensionLineIn : TGeomLine) : TArray<TGeomLine>;
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

                        //rotate line group
                            dimLineRotationReferencePoint.copyPoint( dimLineShift );
                            dimLineAngle := dimensionLineIn.calculate2DLineAngle();

                            TGeomBase.rotate( dimLineAngle, dimLineRotationReferencePoint, [leftLine, dimLine, rightLine] );

                        //scale line group
                            dimLineLength := dimensionLineIn.calculateLength();

                            TGeomBase.scale( dimLineLength, dimLineRotationReferencePoint, [leftLine, dimLine, rightLine] );

                    result := [leftLine, dimLine, rightLine];
                end;

    //public
        //constructor
            constructor TGraphicDimension.create(
                                                    const customTextIn      : string;
                                                    const colourIn          : TColor;
                                                    const dimensionLineIn   : TGeomLine
                                                );
                var
                    i, arrLen           : integer;
                    textRotation        : double;
                    textString          : string;
                    textHandlePoint     : TGeomPoint;
                    graphicLine         : TGraphicLine;
                    graphicText         : TGraphicText;
                    dimensionLineGroup  : TArray<TGeomLine>;
                begin
                    dimensionLineGroup := createDimensionLineGroup( dimensionLineIn );
                    textHandlePoint := dimensionLineGroup[1].calculateCentroidPoint();

                    arrLen := Length( dimensionLineGroup );

                    for i := 0 to ( arrLen - 1 ) do
                        begin
                            graphicLine := TGraphicLine.create( 1, colourIn, TPenStyle.psSolid, dimensionLineGroup[i] );

                            addGraphicObjectToGroup( graphicLine );

                            FreeAndNil( dimensionLineGroup[i] );
                        end;

                    textRotation    := dimensionLineIn.calculate2DLineAngle();
                    textString      := FloatToStrF( dimensionLineIn.calculateLength(), ffFixed, 5, 2 );

                    graphicText := TGraphicText.create( False,
                                                        9,
                                                        textRotation,
                                                        textString,
                                                        EScaleType.scCanvas,
                                                        THorzRectAlign.Center,
                                                        TVertRectAlign.Bottom,
                                                        colourIn,
                                                        [],
                                                        textHandlePoint         );

                    addGraphicObjectToGroup( graphicText );
                end;

        //destructor
            destructor TGraphicDimension.destroy();
                begin
                    inherited destroy();
                end;

end.
