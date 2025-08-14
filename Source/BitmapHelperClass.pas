unit BitmapHelperClass;

interface

    uses
        system.SysUtils, system.Types,
        Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage
        ;

    type
        TBitmapHelper = class helper for TBitmap
            public
                procedure saveToJPegFile(const fileNameIn : string);
                procedure saveToPngFile(const fileNameIn : string);
                function getRectangle() : TRect;
        end;

implementation

    procedure TBitmapHelper.saveToJPegFile(const fileNameIn : string);
        var
            tempJPEG : TJPEGImage;
        begin
            tempJPEG := TJPEGImage.Create();

            tempJPEG.Performance := TJPEGPerformance.jpBestQuality;

            tempJPEG.Assign( self );

            tempJPEG.SaveToFile( fileNameIn );

            FreeAndNil( tempJPEG );
        end;

    procedure TBitmapHelper.saveToPngFile(const fileNameIn : string);
        var
            tempPNG : TPngImage;
        begin
            tempPNG := TPngImage.Create();

            tempPNG.Assign( self );

            tempPNG.SaveToFile( fileNameIn );

            FreeAndNil( tempPNG );
        end;

    function TBitmapHelper.getRectangle() : TRect;
        begin
            result := Rect( 0, 0, self.Width, self.Height );
        end;


end.
