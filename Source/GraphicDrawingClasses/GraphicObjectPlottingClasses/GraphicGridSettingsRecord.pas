unit GraphicGridSettingsRecord;

interface

    type
        TGraphicGridSettings  = record
            xAxisValuesVisible,     yAxisValuesVisible,
            xAxisVisible,           yAxisVisible,
            majorGridLinesVisible,  minorGridLinesVisible : boolean;
            procedure copyOther(const otherGridVisibilitySettingsIn : TGraphicGridSettings);
            procedure setValues(const   showXAxisValuesIn,      showYAxisValuesIn,
                                        showXAxisIn,            showYAxisIn,
                                        showMajorGridLinesIn,   showMinorGridLinesIn : boolean);
            function allElementsDisabled() : boolean;
            function allElementsEnabled() : boolean;
            function atLeastOneElementEnabled() : boolean;
        end;

implementation

    //grid visibility settings
        procedure TGraphicGridSettings.copyOther(const otherGridVisibilitySettingsIn : TGraphicGridSettings);
            begin
                self.setValues(
                                    otherGridVisibilitySettingsIn.xAxisValuesVisible,
                                    otherGridVisibilitySettingsIn.yAxisValuesVisible,
                                    otherGridVisibilitySettingsIn.xAxisVisible,
                                    otherGridVisibilitySettingsIn.yAxisVisible,
                                    otherGridVisibilitySettingsIn.majorGridLinesVisible,
                                    otherGridVisibilitySettingsIn.minorGridLinesVisible
                              );
            end;

        procedure TGraphicGridSettings.setValues(const  showXAxisValuesIn,      showYAxisValuesIn,
                                                        showXAxisIn,            showYAxisIn,
                                                        showMajorGridLinesIn,   showMinorGridLinesIn : boolean);
            begin
                //axis values
                    self.xAxisValuesVisible := showXAxisValuesIn;
                    self.yAxisValuesVisible := showYAxisValuesIn;

                //axis lines
                    self.xAxisVisible := showXAxisIn;
                    self.yAxisVisible := showYAxisIn;

                //grid lines
                    self.majorGridLinesVisible := showMajorGridLinesIn;
                    self.minorGridLinesVisible := showMinorGridLinesIn;
            end;

        function TGraphicGridSettings.allElementsDisabled() : boolean;
            begin
                result:= (      NOT(xAxisValuesVisible)
                            AND NOT(yAxisValuesVisible)
                            AND NOT(xAxisVisible)
                            AND NOT(yAxisVisible)
                            AND NOT(majorGridLinesVisible)
                            AND NOT(minorGridLinesVisible)  );
            end;

        function TGraphicGridSettings.allElementsEnabled() : boolean;
            begin
                result := (     xAxisValuesVisible
                            AND yAxisValuesVisible
                            AND xAxisVisible
                            AND yAxisVisible
                            AND majorGridLinesVisible
                            AND minorGridLinesVisible   );
            end;

        function TGraphicGridSettings.atLeastOneElementEnabled() : boolean;
            begin
                result := NOT( allElementsDisabled() ) AND NOT( allElementsDisabled() );
            end;

end.
