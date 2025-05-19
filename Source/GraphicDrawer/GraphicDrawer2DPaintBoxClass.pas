unit GraphicDrawer2DPaintBoxClass;

interface

    uses
        Vcl.Direct2D, Winapi.D2D1,
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Classes,
        Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.Themes,

        GraphicGridClass,
        GraphicObjectListBaseClass, GraphicDrawerDirect2DClass
        ;

    type
        TPaintBox = class(Vcl.ExtCtrls.TPaintBox)
            private
                const
                    WM_USER_REDRAWGRAPHIC = WM_USER + 1;
                var
                    mustRedrawGraphic       : boolean;
                    gridVisibilitySettings  : TGridVisibilitySettings;
                    graphicBackgroundColour : TColor;
                    currentGraphicBuffer    : TBitmap;
                    D2DGraphicDrawer        : TGraphicDrawerDirect2D;
                //events
                    procedure PaintBoxDrawer2DPaint(Sender: TObject);
                    procedure PaintBoxGraphicMouseEnter(Sender: TObject);
                    procedure PaintBoxGraphicMouseLeave(Sender: TObject);
                //background colour
                    procedure setGraphicBackgroundColour();
                //mouse cursor
                    procedure setMouseCursor(const messageIn : TMessage);
                //update buffer
                    procedure updateGraphicBuffer();
            protected
                //
            public
                //constructor
                    constructor create(AOwner : TComponent); override;
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setGridEnabled(const enabledIn : boolean);
                    procedure setGridElementsVisiblity(const gridVisibilitySettingsIn : TGridVisibilitySettings);
                //redraw the graphic
                    procedure postRedrawGraphicMessage(const callingControlIn : TWinControl);
                    procedure updateBackgroundColour(const callingControlIn : TWinControl);
                    procedure updateGraphics(   const callingControlIn      : TWinControl;
                                                const graphicObjectListIn   : TGraphicObjectListBase);
                //process windows messages
                    procedure processWindowsMessages(var messageInOut : TMessage; out graphicWasRedrawnOut : boolean);
                //access graphic drawer
                    property GraphicDrawer : TGraphicDrawerDirect2D read D2DGraphicDrawer;
        end;

implementation

    //private
        //events
            procedure TPaintBox.PaintBoxDrawer2DPaint(Sender: TObject);
                begin
                    //draw buffer to screen
                        self.Canvas.Draw( 0, 0, currentGraphicBuffer );

                    mustRedrawGraphic := False;
                end;

            procedure TPaintBox.PaintBoxGraphicMouseEnter(Sender: TObject);
                begin
                    D2DGraphicDrawer.activateMouseControl();
                end;

            procedure TPaintBox.PaintBoxGraphicMouseLeave(Sender: TObject);
                begin
                    D2DGraphicDrawer.deactivateMouseControl();
                end;

        //background colour
            procedure TPaintBox.setGraphicBackgroundColour();
                begin
                    //set the background colour according to the application theme
                        graphicBackgroundColour := TStyleManager.ActiveStyle.GetStyleColor( TStyleColor.scGenericBackground );
                end;

        //mouse cursor
            procedure TPaintBox.setMouseCursor(const messageIn : TMessage);
                begin
                    //if the graphic drawer is nil then nothing can happen
                        if NOT( Assigned(D2DGraphicDrawer) ) then
                            exit();

                    //set the cursor based on the user input
                        if NOT(D2DGraphicDrawer.getMouseControlActive() ) then
                            begin
                                self.Cursor := crDefault;
                                exit();
                            end;

                        case (messageIn.Msg) of
                            WM_MBUTTONDOWN:
                                self.Cursor := crSizeAll;

                            WM_MBUTTONUP:
                                self.Cursor := crDefault;
                        end;
                end;

        //update buffer
            procedure TPaintBox.updateGraphicBuffer();
                var
                    canvasWidth, canvasHeight : integer;
                begin
                    //cache the canvas dimensions
                        canvasWidth     := self.Width;
                        canvasHeight    := self.Height;

                    //set graphic buffer size
                        currentGraphicBuffer.SetSize( canvasWidth, canvasHeight );

                    //draw to the canvas
                        D2DGraphicDrawer.drawAll(
                                                    canvasWidth,
                                                    canvasHeight,
                                                    graphicBackgroundColour,
                                                    currentGraphicBuffer.Canvas
                                                );

                    //signify to wndProc() that the graphic must be redrawn
                        mustRedrawGraphic := True;
                end;

    //protected
        //

    //public
        //constructor
            constructor TPaintBox.create(AOwner : TComponent);
                begin
                    inherited Create( AOwner );

                    //create required classes
                        currentGraphicBuffer    := TBitmap.create();
                        D2DGraphicDrawer        := TGraphicDrawerDirect2D.create();

                    //assign events
                        self.OnPaint        := PaintBoxDrawer2DPaint;
                        self.OnMouseEnter   := PaintBoxGraphicMouseEnter;
                        self.OnMouseLeave   := PaintBoxGraphicMouseLeave;

                    //for design time to ensure the colour is not black on the form builder
                        setGraphicBackgroundColour();

                    //grid is not visible by default
                        setGridEnabled( False );
                end;

        //destructor
            destructor TPaintBox.destroy();
                begin
                    //free classes
                        FreeAndNil( currentGraphicBuffer );
                        FreeAndNil( D2DGraphicDrawer );

                    inherited destroy();
                end;

        //modifiers
            procedure TPaintBox.setGridEnabled(const enabledIn : boolean);
                begin
                    GraphicDrawer.setGridEnabled( enabledIn );
                end;

            procedure TPaintBox.setGridElementsVisiblity(const gridVisibilitySettingsIn : TGridVisibilitySettings);
                begin
                    gridVisibilitySettings.copyOther( gridVisibilitySettingsIn );
                end;

        //redraw the graphic
            procedure TPaintBox.postRedrawGraphicMessage(const callingControlIn : TWinControl);
                begin
                    //this message is sent to callingControlIn.wndProc() where the graphic is updated and redrawn
                    //the self.processWindowsMessages() method must be called in callingControlIn.wndProc()
                        PostMessage( callingControlIn.Handle, WM_USER_REDRAWGRAPHIC, 0, 0 );
                end;

            procedure TPaintBox.updateBackgroundColour(const callingControlIn : TWinControl);
                begin
                    setGraphicBackgroundColour();
                    postRedrawGraphicMessage( callingControlIn );
                end;

            procedure TPaintBox.updateGraphics( const callingControlIn      : TWinControl;
                                                const graphicObjectListIn   : TGraphicObjectListBase);
                begin
                    //set background to match theme
                        setGraphicBackgroundColour();

                    //reset the stored graphics
                        D2DGraphicDrawer.clearGraphicObjects();

                    //update the D2DGraphicDrawer graphics
                        D2DGraphicDrawer.setGridElementsVisiblity( gridVisibilitySettings );

                        D2DGraphicDrawer.readGraphicObjectList( graphicObjectListIn );

                    //activate all drawing layers
                        D2DGraphicDrawer.activateAllDrawingLayers();

                    //send message to redraw
                        postRedrawGraphicMessage( callingControlIn );
                end;

        //process windows messages
            procedure TPaintBox.processWindowsMessages(var messageInOut : TMessage; out graphicWasRedrawnOut : boolean);
                var
                    mouseInputRequiresRedraw        : boolean;
                    currentMousePositionOnPaintbox  : TPoint;
                begin
                    //drawing graphic-----------------------------------------------------------------------------------------------
                        //update the mouse position
                            if ( messageInOut.Msg = WM_MOUSEMOVE ) then
                                currentMousePositionOnPaintbox := self.ScreenToClient( mouse.CursorPos );

                        //process windows message in axis converter
                            mouseInputRequiresRedraw := D2DGraphicDrawer.windowsMessageRequiredRedraw( messageInOut, currentMousePositionOnPaintbox );

                        //render image off screen
                            if ( mouseInputRequiresRedraw OR (messageInOut.Msg = WM_USER_REDRAWGRAPHIC) ) then
                                updateGraphicBuffer();

                        //paint rendered image to screen
                            if ( mustRedrawGraphic ) then
                                begin
                                    self.Repaint();
                                    graphicWasRedrawnOut := True;
                                end
                            else
                                graphicWasRedrawnOut := False;
                    //--------------------------------------------------------------------------------------------------------------

                    //set the cursor to drag or default
                        setMouseCursor( messageInOut );
                end;

end.
