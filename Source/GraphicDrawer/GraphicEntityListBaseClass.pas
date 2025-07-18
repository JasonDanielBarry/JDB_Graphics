unit GraphicEntityListBaseClass;

interface

    uses
        System.Generics.Collections,
        GraphicEntityBaseClass
        ;

    type
        TGraphicEntityListBase = class(TList< TPair< string, TGraphicEntity > >)
            private
                var
                    currentDrawingLayer : string;
            protected
                //add a graphic object to the list
                    procedure addGraphicEntity(const GraphicEntityIn : TGraphicEntity);
            public
                //constructor
                    constructor create();
                //set the layer to which to send the graphic objects
                    procedure setcurrentDrawingLayer(const layerIn : string);
        end;

implementation

    //protected
        //add a graphic object to the list
            procedure TGraphicEntityListBase.addGraphicEntity(const GraphicEntityIn : TGraphicEntity);
                var
                    layerGraphicEntityPair : TPair<string, TGraphicEntity>;
                begin
                    layerGraphicEntityPair.Key      := currentDrawingLayer;
                    layerGraphicEntityPair.Value    := GraphicEntityIn;

                    self.Add( layerGraphicEntityPair );
                end;

    //public
        //constructor
            constructor TGraphicEntityListBase.create();
                begin
                    inherited create();

                    currentDrawingLayer := 'Default drawing layer';

                    clear();
                end;

        //set the layer to which to send the graphic objects
            procedure TGraphicEntityListBase.setcurrentDrawingLayer(const layerIn : string);
                begin
                    currentDrawingLayer := layerIn;
                end;

end.
