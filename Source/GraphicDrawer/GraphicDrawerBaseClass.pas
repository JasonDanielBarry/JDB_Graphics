unit GraphicDrawerBaseClass;

interface

    uses
        //Delphi
            Winapi.Windows, Winapi.Messages,
            system.SysUtils, System.Math, system.types, system.UITypes, system.Generics.Collections,
            vcl.Controls, vcl.Graphics, Vcl.Themes,
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
                const
                    WM_USER_REDRAW_GRAPHIC = WM_USER + 1;
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
                //post redraw message
                    procedure postRedrawGraphicMessage(const callingControlIn : TWinControl);
                //update background colour
                    procedure updateBackgroundColour(const callingControlIn : TWinControl);
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
                            D2DCanvasInOut.setBrushFillProperties( True, graphicBackgroundColour );
                            D2DCanvasInOut.FillRect( Rect(0, 0, canvasWidthIn, canvasHeightIn) );
                    end;

    //public
        //constructor
            constructor TGraphicDrawerBase.create();
                begin
                    inherited create();

                    axisConverter := TDrawingAxisConverter.create();
                end;

        //destructor
            destructor TGraphicDrawerBase.destroy();
                begin
                    FreeAndNil( axisConverter );

                    inherited destroy();
                end;

        //post redraw message
            procedure TGraphicDrawerBase.postRedrawGraphicMessage(const callingControlIn: TWinControl);
                begin
                    if NOT( Assigned( callingControlIn ) ) then
                        exit();

                    PostMessage( callingControlIn.Handle, WM_USER_REDRAW_GRAPHIC, 0, 0 );
                end;

        //update background colour
            procedure TGraphicDrawerBase.updateBackgroundColour(const callingControlIn : TWinControl);
                begin
                    //set the background colour to match the style
                        graphicBackgroundColour := TDirect2DXYEntityCanvas.BackgroundColour;

                        if NOT( Assigned( callingControlIn ) ) then
                            exit();

                    //post redraw message
                        postRedrawGraphicMessage( callingControlIn );
                end;

end.
