unit GraphicDrawerBaseClass;

interface

    uses
        //Delphi
            system.SysUtils, System.Math, system.types, system.UITypes, system.Generics.Collections,
            vcl.Graphics, Vcl.Themes,
        //custom
            ColourMethods,
            GeometryTypes,
            DrawingAxisConversionClass,
            Direct2DXYEntityCanvasClass
            ;

    type
        TGraphicDrawerBase = class
            protected
                var
                    graphicBackgroundColour : Tcolor;
            protected
                var
                    axisConverter : TDrawingAxisConverter;
                    //these variables are declared here to be used in the drawAll() procedure
                    //but are set in GraphicDrawerAxisConversionInterfaceClass
                        drawingSpaceRatioEnabled    : boolean;
                        drawingSpaceRatio           : double;
                //drawing procedures
                    //draw all geometry
                        procedure drawAll(  const canvasWidthIn, canvasHeightIn : integer;
                                            var D2DCanvasInOut                  : TDirect2DXYEntityCanvas   );
            public
                //constructor
                    constructor create(); virtual;
                //destructor
                    destructor destroy(); override;
                //update background colour
                    procedure updateBackgroundColour();
        end;

implementation

    //protected
        //drawing procedures
            //draw all geometry
                procedure TGraphicDrawerBase.drawAll(   const canvasWidthIn, canvasHeightIn : integer;
                                                        var D2DCanvasInOut                  : TDirect2DXYEntityCanvas);
                    begin
                        //set axis converter canvas dimensions
                            axisConverter.setCanvasDimensions( canvasWidthIn, canvasHeightIn );

                        //set the drawing space ratio
                            if ( drawingSpaceRatioEnabled ) then
                                axisConverter.setDrawingSpaceRatio( drawingSpaceRatio );

                        //clear the canvas
                            D2DCanvasInOut.Brush.Color := graphicBackgroundColour;
                            D2DCanvasInOut.FillRect( Rect(0, 0, canvasWidthIn, canvasHeightIn) );
                    end;

    //public
        //constructor
            constructor TGraphicDrawerBase.create();
                begin
                    inherited create();

                    updateBackgroundColour();

                    axisConverter := TDrawingAxisConverter.create();
                end;

        //destructor
            destructor TGraphicDrawerBase.destroy();
                begin
                    FreeAndNil( axisConverter );

                    inherited destroy();
                end;

        //update background colour
            procedure TGraphicDrawerBase.updateBackgroundColour();
                begin
                    //set the background colour to match the style
                        graphicBackgroundColour := TStyleManager.ActiveStyle.GetStyleColor( TStyleColor.scGenericBackground );
                end;

end.
