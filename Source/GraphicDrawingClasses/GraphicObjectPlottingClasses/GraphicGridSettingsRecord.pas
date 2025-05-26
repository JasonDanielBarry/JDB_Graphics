unit GraphicGridSettingsRecord;

interface

    type
        TGridVisibilitySettings  = record
            axisLabelsVisible,
            axesVisible,
            majorGridLinesVisible,
            minorGridLinesVisible : boolean;
            procedure copyOther(const otherGridVisibilitySettingsIn : TGridVisibilitySettings);
            procedure setValues(const showAxisLabelsIn, showAxesIn, showMajorGridLinesIn, showMinorGridLinesIn : boolean);
            function allElementsDisabled() : boolean;
        end;

implementation

    //grid visibility settings
        procedure TGridVisibilitySettings.copyOther(const otherGridVisibilitySettingsIn : TGridVisibilitySettings);
            begin
                self.setValues(
                                    otherGridVisibilitySettingsIn.axisLabelsVisible,
                                    otherGridVisibilitySettingsIn.axesVisible,
                                    otherGridVisibilitySettingsIn.majorGridLinesVisible,
                                    otherGridVisibilitySettingsIn.minorGridLinesVisible
                              );
            end;

        procedure TGridVisibilitySettings.setValues(const showAxisLabelsIn, showAxesIn, showMajorGridLinesIn, showMinorGridLinesIn : boolean);
            begin
                self.axisLabelsVisible      := showAxisLabelsIn;
                self.axesVisible            := showAxesIn;
                self.majorGridLinesVisible  := showMajorGridLinesIn;
                self.minorGridLinesVisible  := showMinorGridLinesIn;
            end;

        function TGridVisibilitySettings.allElementsDisabled() : boolean;
            var
                atLeastOneElementIsVisible : boolean;
            begin
                atLeastOneElementIsVisible := axisLabelsVisible OR axesVisible OR majorGridLinesVisible OR minorGridLinesVisible;

                result := NOT( atLeastOneElementIsVisible );
            end;

end.
