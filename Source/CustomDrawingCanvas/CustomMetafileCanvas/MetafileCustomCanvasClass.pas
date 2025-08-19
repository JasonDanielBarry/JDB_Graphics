unit MetafileCustomCanvasClass;

interface

    uses
        Winapi.Windows,
        system.SysUtils, system.Math, system.Types,
        Vcl.Graphics
        ;

    type
        TMetafileCustomCanvas = class( TMetafile )
            private
                type
                    TCustomBrushProperties = record
                        isSolid : boolean;
                        colour  : TColor;
                    end;

                    TCustomPenProperties = record
                        width   : integer;
                        colour  : TColor;
                        style   : TPenStyle;
                    end;

                    TCustomFontProperties = record
                        size    : integer;
                        name    : string;
                        colour  : TColor;
                        styles  : TFontStyles;
                    end;

                    TCustomRotationProperties = record
                        rotationIsNeeded        : boolean;
                        rotationAngle           : double;
                        rotationReferencePoint  : TPoint;
                    end;
                var
                    brushProperties     : TCustomBrushProperties;
                    penProperties       : TCustomPenProperties;
                    fontProperties      : TCustomFontProperties;
                    rotationProperties  : TCustomRotationProperties;
                //rotate metafile canvas
                    procedure rotateMetafileCanvas();
                //instantiate metafile canvas with assigned properties
                    procedure instantiateMetafileCanvasAndAssignProperties();
            protected
                var
                    metafileDrawingCanvas : TMetafileCanvas;
                //rotation properties
                    procedure setRotationProperties(const rotationAngleIn : double; const rotationReferencePointIn : TPoint);
                //begin drawing to metafile canvas with assign properties
                    procedure beginDrawing();
                //end drawing (free metafileCanvas)
                    procedure endDrawing();
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //set brush properties
                    procedure setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
                //set pen properties
                    procedure setPenLineProperties( const widthIn   : integer;
                                                    const colourIn  : TColor;
                                                    const styleIn   : TPenStyle );
                //set font properties
                    procedure setFontTextProperties(const sizeIn        : integer;
                                                    const nameIn        : string;
                                                    const colourIn      : TColor;
                                                    const stylesIn      : TFontStyles);
        end;

implementation

    //private
        //rotate metafile canvas
            procedure TMetafileCustomCanvas.rotateMetafileCanvas();
                begin
                    if NOT( rotationProperties.rotationIsNeeded ) then
                        exit();



                end;

        //create a metafile canvas with assigned properties
            procedure TMetafileCustomCanvas.instantiateMetafileCanvasAndAssignProperties();
                begin
                    metafileDrawingCanvas := TMetafileCanvas.Create( Self, 0 );

                    //assign brush properties
                        if ( brushProperties.isSolid ) then
                            begin
                                metafileDrawingCanvas.Brush.Style := TBrushStyle.bsSolid;
                                metafileDrawingCanvas.Brush.Color := brushProperties.colour;
                            end
                        else
                            metafileDrawingCanvas.Brush.Style := TBrushStyle.bsClear;

                    //assign pen properties
                        metafileDrawingCanvas.Pen.Width := penProperties.width;
                        metafileDrawingCanvas.Pen.Color := penProperties.colour;
                        metafileDrawingCanvas.Pen.Style := penProperties.style;

                    //assign font properties
                        metafileDrawingCanvas.Font.Size     := fontProperties.size;
                        metafileDrawingCanvas.Font.Name     := fontProperties.name;
                        metafileDrawingCanvas.Font.Color    := fontProperties.colour;
                        metafileDrawingCanvas.Font.Style    := fontProperties.styles;

                    //rotate canvas
                        rotateMetafileCanvas();
                end;

    //protected
        //rotation properties
            procedure TMetafileCustomCanvas.setRotationProperties(const rotationAngleIn : double; const rotationReferencePointIn : TPoint);
                begin
                    rotationProperties.rotationIsNeeded := NOT( IsZero( rotationAngleIn, 1e-3 ) );

                    if NOT( rotationProperties.rotationIsNeeded ) then
                        exit();

                    rotationProperties.rotationAngle            := rotationAngleIn;
                    rotationProperties.rotationReferencePoint   := rotationReferencePointIn;
                end;

        //begin drawing to metafile canvas with assign properties
            procedure TMetafileCustomCanvas.beginDrawing();
                begin
                    //create canvas and assign brush pen and font properties
                        instantiateMetafileCanvasAndAssignProperties();
                end;

        //end drawing (free metafileCanvas)
            procedure TMetafileCustomCanvas.endDrawing();
                begin
                    FreeAndNil( metafileDrawingCanvas );
                end;

    //public
        //constructor
            constructor TMetafileCustomCanvas.create();
                begin
                    inherited create();

                    self.Enhanced := True;

                    setRotationProperties( 0, Point( 0, 0 ) );
                end;

        //destructor
            destructor TMetafileCustomCanvas.destroy();
                begin
                    if ( Assigned( metafileDrawingCanvas ) ) then
                        FreeAndNil( metafileDrawingCanvas );

                    inherited destroy();
                end;

        //set brush properties
            procedure TMetafileCustomCanvas.setBrushFillProperties(const solidIn : boolean; const colourIn : TColor);
                begin
                    brushProperties.isSolid := solidIn;
                    brushProperties.colour  := colourIn;
                end;

        //set pen properties
            procedure TMetafileCustomCanvas.setPenLineProperties(   const widthIn   : integer;
                                                                    const colourIn  : TColor;
                                                                    const styleIn   : TPenStyle );
                begin
                    penProperties.width     := widthIn;
                    penProperties.colour    := colourIn;
                    penProperties.style     := styleIn;
                end;

        //set font properties
            procedure TMetafileCustomCanvas.setFontTextProperties(  const sizeIn        : integer;
                                                                    const nameIn        : string;
                                                                    const colourIn      : TColor;
                                                                    const stylesIn      : TFontStyles   );
                begin
                    fontProperties.size     := sizeIn;
                    fontProperties.name     := nameIn;
                    fontProperties.colour   := colourIn;
                    fontProperties.styles   := stylesIn;
                end;

end
