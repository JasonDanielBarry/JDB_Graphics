unit GraphicDrawerTypes;

interface

    uses
        GenericLTEntityCanvasClass;

    type
        TPostGraphicDrawEvent = procedure(const AWidth, AHeight : integer; const AD2DCanvas : TGenericLTEntityCanvas) of object;

implementation

end.
