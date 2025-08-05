unit Graphic2DTypes;

interface

    uses
        system.SysUtils,
        Graphic2DListClass
        ;

    type
        TUpdateGraphicsEvent = procedure(ASender : TObject; var AGraphic2DList : TGraphic2DList) of object;

implementation

end.
