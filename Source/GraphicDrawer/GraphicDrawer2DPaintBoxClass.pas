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
                    mustRedrawGraphic   : boolean;
                    D2DGraphicDrawer    : TGraphicDrawerDirect2D;
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
                        D2DGraphicDrawer.updateBackgroundColour( nil );

                    //grid is not visible by default
                        GraphicDrawer.setGridEnabled( False );

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

                        //process windows message in D2DGraphicDrawer
                            D2DGraphicDrawer.processWindowsMessages( self.Width, self.Height, currentMousePositionOnPaintbox, messageInOut, graphicBufferWasUpdated );

                        //This method is only responsible for setting mustRedrawGraphic to True if the buffer in updated
                        //PaintBoxDrawer2DPaint is responsible for setting mustRedrawGraphic to False once redrawing is complete
                            if ( graphicBufferWasUpdated ) then
                                mustRedrawGraphic := True;

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
