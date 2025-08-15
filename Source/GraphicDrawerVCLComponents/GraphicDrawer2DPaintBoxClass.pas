unit GraphicDrawer2DPaintBoxClass;

interface

    uses
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Classes,
        Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,
        GraphicTextClass,
        GraphicDrawerClass
        ;

    type
        TPaintBox = class(Vcl.ExtCtrls.TPaintBox)
            private
                var
                    mustRedrawGraphic       : boolean;
                    genericGraphicDrawer    : TGraphicDrawer;
                //events
                    procedure PaintBoxDrawer2DPaint(Sender: TObject);
                //mouse cursor
                    procedure setMouseCursor(const messageIn : TMessage);      
            public
                //constructor
                    constructor create(AOwner : TComponent); override;
                //destructor
                    destructor destroy(); override;
                //process windows messages
                    procedure processWindowsMessages(var messageInOut : TMessage; out graphicWasRedrawnOut : boolean);
                //access graphic drawer
                    property GraphicDrawer : TGraphicDrawer read genericGraphicDrawer;
        end;

implementation

    //private
        //events
            procedure TPaintBox.PaintBoxDrawer2DPaint(Sender: TObject);
                begin
                    //draw buffer to paintbox
                        self.Canvas.Draw( 0, 0, genericGraphicDrawer.GraphicBuffer );

                    mustRedrawGraphic := False;
                end;

		//mouse cursor
            procedure TPaintBox.setMouseCursor(const messageIn : TMessage);
                begin
                    //if the graphic drawer is nil then nothing can happen
                        if NOT( Assigned( genericGraphicDrawer ) ) then
                            exit();

                    //set the cursor based on the user input
                        if NOT( genericGraphicDrawer.getMouseControlActive() ) then
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

    //public
        //constructor
            constructor TPaintBox.create(AOwner : TComponent);
                begin
                    inherited Create( AOwner );

                    //create required classes
                        genericGraphicDrawer := TGraphicDrawer.create();

                    //assign events
                        self.OnPaint        := PaintBoxDrawer2DPaint;
                        self.OnMouseEnter   := genericGraphicDrawer.DrawingControlMouseEnter;
                        self.OnMouseLeave   := genericGraphicDrawer.DrawingControlMouseLeave;

                    //for design time to ensure the colour is not black on the form builder
                        genericGraphicDrawer.updateBackgroundColour( nil );
                    //---------------------------------------------------------------------

                    //grid is not visible by default
                        genericGraphicDrawer.setGridEnabled( False );

                    //assign font name to graphic text class
                        TGraphicText.fontName := 'Segoe UI';
                end;

        //destructor
            destructor TPaintBox.destroy();
                begin
                    //free classes
                        FreeAndNil( genericGraphicDrawer );

                    inherited destroy();
                end;

        //process windows messages
            procedure TPaintBox.processWindowsMessages(var messageInOut : TMessage; out graphicWasRedrawnOut : boolean);
                var
                    graphicBufferWasUpdated         : boolean;
                    currentMousePositionOnPaintbox  : TPoint;
                begin
                    //drawing graphic-----------------------------------------------------------------------------------------------
                        //update the mouse position
                            if ( messageInOut.Msg = WM_MOUSEMOVE ) then
                                currentMousePositionOnPaintbox := self.ScreenToClient( mouse.CursorPos );

                        //process windows message in genericGraphicDrawer
                            genericGraphicDrawer.processWindowsMessages( self.Width, self.Height, currentMousePositionOnPaintbox, messageInOut, mustRedrawGraphic );

                        //draw buffer to paintbox
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
