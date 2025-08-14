unit GraphicDrawerTypes;

interface

    uses
        GenericLTEntityCanvasClass;

    type
        TPostGraphicDrawEvent = procedure(const AWidth, AHeight : integer; const ACanvas : TGenericLTEntityCanvas) of object;

implementation

end.
