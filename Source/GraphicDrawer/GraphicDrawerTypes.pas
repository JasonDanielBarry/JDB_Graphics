unit GraphicDrawerTypes;

interface

    uses
        Direct2DLTEntityCanvasClass;

    type
        TPostGraphicDrawEvent = procedure(const AWidth, AHeight : integer; const AD2DCanvas : TDirect2DLTEntityCanvas) of object;

implementation

end.
