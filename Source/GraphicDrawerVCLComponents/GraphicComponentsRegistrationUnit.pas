unit GraphicComponentsRegistrationUnit;

interface

    uses
        System.Classes,
        Graphic2DComponent, GraphXYComponent
        ;

    procedure register();

implementation

    procedure register();
        begin
            RegisterComponents(
                                    'JDBDelphiLibrary',
                                    [
                                        TJDBGraphic2D,
                                        TJDBGraphXY
                                    ]
                              );
        end;

end.
