unit Direct2DXYEntityCanvasClass;

interface

    uses
        system.types,
        vcl.Graphics,
        Direct2DLTEntityCanvasClass,
        GenericXYEntityCanvasAbstractClass

        ;

    type
        TDirect2DXYEntityCanvas = class( TGenericXYEntityCanvas )
            private
                var
                    direct2DLTEntityCanvas : TDirect2DLTEntityCanvas;
                //text
                    procedure printLTTextF( const textStringIn          : string;
                                            const textDrawingPointIn    : TPointF ); override;

            public
                //begine drawing
                    procedure beginDrawing(const bitmapIn : TBitmap);
                //end drawing
                    procedure endDrawing();
        end;

implementation

    //private
        //text
            procedure TDirect2DXYEntityCanvas.printLTTextF( const textStringIn          : string;
                                                            const textDrawingPointIn    : TPointF );
                begin
                    direct2DLTEntityCanvas.printLTTextF
                end;

end.
