unit GraphicDrawer2DPaintBoxClass;

interface

    uses
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Classes,
        Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.Themes,
        GraphicTextClass,
        GraphicGridSettingsRecord,
        GraphicEntityListBaseClass,
        GraphicDrawerDirect2DClass
        ;

    type
        TPaintBox = class(Vcl.ExtCtrls.TPaintBox)
            private
                var
                    mustRedrawGraphic       : boolean;
                    D2DGraphicDrawer        : TGraphicDrawerDirect2D;
                //events
                    procedure PaintBoxDrawer2DPaint(Sender: TObject);
                    procedure PaintBoxGraphicMouseEnter(Sender: TObject);
                    procedure PaintBoxGraphicMouseLeave(Sender: TObject);
                //mouse cursor
                    procedure setMouseCursor(const messageIn : TMessage);
            protected
                //
            public
                //constructor
                    constructor create(AOwner : TComponent); override;
                //destructor
                    destructor destroy(); override;
                //accessors
                    function getOnPostGraphicDrawEvent() : TOnPostGraphicDrawEvent;
                //modifiers
                    procedure setGridEnabled(const enabledIn : boolean);
                    procedure setGridSettings(const gridSettingsIn : TGraphicGridSettings);
                    procedure setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TOnPostGraphicDrawEvent);
                //redraw the graphic
                    procedure postRedrawGraphicMessage(const callingControlIn : TWinControl);
                    procedure updateBackgroundColour(const callingControlIn : TWinControl);
                    procedure updateGraphics(   const callingControlIn      : TWinControl;
                                                const GraphicEntityListIn   : TGraphicEntityListBase );
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
                    //draw buffer to paintbox
                        self.Canvas.Draw( 0, 0, D2DGraphicDrawer.GraphicBuffer );

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

        //mouse cursor
            procedure TPaintBox.setMouseCursor(const messageIn : TMessage);
                begin
                    //if the graphic drawer is nil then nothing can happen
                        if NOT( Assigned( D2DGraphicDrawer ) ) then
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

    //protected
        //

    //public
        //constructor
            constructor TPaintBox.create(AOwner : TComponent);
                begin
                    inherited Create( AOwner );

                    //create required classes
                        D2DGraphicDrawer := TGraphicDrawerDirect2D.create();

                    //assign events
                        self.OnPaint        := PaintBoxDrawer2DPaint;
                        self.OnMouseEnter   := PaintBoxGraphicMouseEnter;
                        self.OnMouseLeave   := PaintBoxGraphicMouseLeave;

                    //for design time to ensure the colour is not black on the form builder
                        D2DGraphicDrawer.updateBackgroundColour();

                    //grid is not visible by default
                        setGridEnabled( False );

                    //assign font name to graphic text class
                        TGraphicText.fontName := 'Segoe UI';
                end;

        //destructor
            destructor TPaintBox.destroy();
                begin
                    //free classes
                        FreeAndNil( D2DGraphicDrawer );

                    inherited destroy();
                end;

        //accessors
            function TPaintBox.getOnPostGraphicDrawEvent() : TOnPostGraphicDrawEvent;
                begin
                    result := D2DGraphicDrawer.getOnPostGraphicDrawEvent();
                end;

        //modifiers
            procedure TPaintBox.setGridEnabled(const enabledIn : boolean);
                begin
                    GraphicDrawer.setGridEnabled( enabledIn );
                end;

            procedure TPaintBox.setGridSettings(const gridSettingsIn : TGraphicGridSettings);
                begin
                    D2DGraphicDrawer.setGridSettings( gridSettingsIn );
                end;

            procedure TPaintBox.setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TOnPostGraphicDrawEvent);
                begin
                    D2DGraphicDrawer.setOnPostGraphicDrawEvent( onPostGraphicDrawEventIn );
                end;

        //redraw the graphic
            procedure TPaintBox.postRedrawGraphicMessage(const callingControlIn : TWinControl);
                begin
                    //this message is sent to callingControlIn.wndProc() where the graphic is updated and redrawn
                    //the self.processWindowsMessages() method must be called in callingControlIn.wndProc()
                        PostMessage( callingControlIn.Handle, TGraphicDrawerDirect2D.WM_USER_REDRAWGRAPHIC, 0, 0 );
                end;

            procedure TPaintBox.updateBackgroundColour(const callingControlIn : TWinControl);
                begin
                    D2DGraphicDrawer.updateBackgroundColour();
                    postRedrawGraphicMessage( callingControlIn );
                end;

            procedure TPaintBox.updateGraphics( const callingControlIn      : TWinControl;
                                                const GraphicEntityListIn   : TGraphicEntityListBase );
                begin
                    //update the D2DGraphicDrawer graphics
                        D2DGraphicDrawer.updateGraphicEntitys( GraphicEntityListIn );

                    //send message to redraw
                        postRedrawGraphicMessage( callingControlIn );
                end;

        //process windows messages
            procedure TPaintBox.processWindowsMessages(var messageInOut : TMessage; out graphicWasRedrawnOut : boolean);
                var
                    graphicBufferWasUpdated        : boolean;
                    currentMousePositionOnPaintbox  : TPoint;
                begin
                    //drawing graphic-----------------------------------------------------------------------------------------------
                        //update the mouse position
                            if ( messageInOut.Msg = WM_MOUSEMOVE ) then
                                currentMousePositionOnPaintbox := self.ScreenToClient( mouse.CursorPos );

                        //process windows message in axis converter
                            D2DGraphicDrawer.processWindowsMessages( self.Width, self.Height, currentMousePositionOnPaintbox, messageInOut, graphicBufferWasUpdated );

                        //DO NOT TOUCH!
//////////////////////////////////////////////////////////////////////////////////////////////////////////
                        //the variable mustRedrawGraphic is used in the paintbox onPaintEvent           //
                        //to signify if the paintbox must update itself using the graphic buffer        //
                        //and is set to false after the paintbox updates itself                         //
                                                                                                        //
                        //The processWindowsMessages has a special case where it can run multiple times //
                        //with mustRedrawGraphic = False                                                //
                                                                                                        //
                        //If the value of graphicBufferWasUpdated is assigned to mustRedrawGraphic      //
                        //each time processWindowsMessages is called then the graphic flickers          //
                                                                                                        //
                        //The structure below prevents flickering                                       //
                                                                                                        //
                        //signify that the paintbot canvas must be update with the graphic buffer       //
                            if ( graphicBufferWasUpdated ) then                                         //
                                mustRedrawGraphic := True;                                              //
                                                                                                        //
//////////////////////////////////////////////////////////////////////////////////////////////////////////

                        //paint buffer to paintbox
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
