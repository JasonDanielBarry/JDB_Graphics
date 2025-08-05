unit Graphic2DComponent;

interface

    uses
        System.SysUtils, System.Classes,
        Vcl.Controls,
        CustomComponentPanelClass,
        GraphicDrawerTypes,
        Graphic2DTypes,
        Graphic2DFrame;

    type
        TJDBGraphic2D = class(TCustomComponentPanel)
            private
                var
                    customGraphic2D : TCustomGraphic2D;
                procedure setOnUpdateGraphicsEvent(const graphicDrawEventIn : TUpdateGraphicsEvent);
                procedure setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TPostGraphicDrawEvent);
                function getOnUpdateGraphicsEvent() : TUpdateGraphicsEvent;
                function getOnPostGraphicDrawEvent() : TPostGraphicDrawEvent;
            public
                constructor Create(AOwner: TComponent); override;
                destructor Destroy(); override;
                procedure redrawGraphic();
                procedure updateBackgroundColour();
                procedure updateGraphics();
                procedure zoomAll();
            published
                property OnUpdateGraphics : TUpdateGraphicsEvent read getOnUpdateGraphicsEvent write setOnUpdateGraphicsEvent;
                property OnPostGraphicDraw : TPostGraphicDrawEvent read getOnPostGraphicDrawEvent write setOnPostGraphicDrawEvent;
        end;

implementation

    //private
        procedure TJDBGraphic2D.setOnUpdateGraphicsEvent(const graphicDrawEventIn : TUpdateGraphicsEvent);
            begin
                customGraphic2D.setOnUpdateGraphicsEvent(graphicDrawEventIn);
            end;

        procedure TJDBGraphic2D.setOnPostGraphicDrawEvent(const onPostGraphicDrawEventIn : TPostGraphicDrawEvent);
            begin
                customGraphic2D.setOnPostGraphicDrawEvent( onPostGraphicDrawEventIn );
            end;

        function TJDBGraphic2D.getOnUpdateGraphicsEvent() : TUpdateGraphicsEvent;
            begin
                result := customGraphic2D.getOnUpdateGraphicsEvent();
            end;

        function TJDBGraphic2D.getOnPostGraphicDrawEvent() : TPostGraphicDrawEvent;
            begin
                result := customGraphic2D.getOnPostGraphicDrawEvent();
            end;

    //public
        constructor TJDBGraphic2D.Create(AOwner: TComponent);
            begin
                inherited create( AOwner );

                customGraphic2D := TCustomGraphic2D.create(Self);
                customGraphic2D.parent  := self;
                customGraphic2D.Align   := TAlign.alClient;
                customGraphic2D.Visible := True;
            end;

        destructor TJDBGraphic2D.Destroy();
            begin
                FreeAndNil( customGraphic2D );

                inherited Destroy();
            end;

        procedure TJDBGraphic2D.redrawGraphic();
            begin
                customGraphic2D.redrawGraphic();
            end;

        procedure TJDBGraphic2D.updateBackgroundColour();
            begin
                customGraphic2D.updateBackgroundColour();
            end;

        procedure TJDBGraphic2D.updateGraphics();
            begin
                customGraphic2D.updateGraphics();
            end;

        procedure TJDBGraphic2D.zoomAll();
            begin
                customGraphic2D.zoomAll();
            end;

end.
