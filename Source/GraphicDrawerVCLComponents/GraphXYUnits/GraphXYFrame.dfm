object CustomGraphXY: TCustomGraphXY
  Left = 0
  Top = 0
  Width = 1766
  Height = 843
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    1766
    843)
  object LabelTitle: TLabel
    AlignWithMargins = True
    Left = 2
    Top = 2
    Width = 1762
    Height = 15
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    Alignment = taCenter
    Caption = 'Title'
    Layout = tlCenter
    ExplicitWidth = 23
  end
  object LabelXAxis: TLabel
    AlignWithMargins = True
    Left = 2
    Top = 826
    Width = 1762
    Height = 15
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    Alignment = taCenter
    Caption = 'X-Axis'
    Layout = tlCenter
    ExplicitWidth = 33
  end
  object LabelYAxis: TLabel
    AlignWithMargins = True
    Left = 2
    Top = 21
    Width = 33
    Height = 801
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alLeft
    Alignment = taCenter
    Caption = 'Y-Axis'
    Layout = tlCenter
    ExplicitHeight = 15
  end
  object PBGraphXY: TPaintBox
    AlignWithMargins = True
    Left = 38
    Top = 20
    Width = 1473
    Height = 803
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    Align = alClient
    ExplicitLeft = 416
    ExplicitTop = 368
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object PageControlSettings: TPageControl
    AlignWithMargins = True
    Left = 1514
    Top = 21
    Width = 250
    Height = 801
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ActivePage = TabSheetGraph
    Align = alRight
    MultiLine = True
    TabOrder = 0
    Visible = False
    object TabSheetGraph: TTabSheet
      Caption = 'Graph'
      object ComboBoxPlotNames: TComboBox
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 232
        Height = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Style = csDropDownList
        TabOrder = 0
        OnChange = ComboBoxPlotNamesChange
      end
      object CheckBoxShowSelectedPlot: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 38
        Width = 232
        Height = 17
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Show Graph'
        TabOrder = 1
        OnClick = CheckBoxShowSelectedPlotClick
      end
    end
    object TabSheetGrid: TTabSheet
      Caption = 'Grid'
      ImageIndex = 1
      object GroupBoxGridElementVisibility: TGroupBox
        Left = 0
        Top = 0
        Width = 242
        Height = 210
        Align = alTop
        Caption = 'Grid Element Visibility'
        TabOrder = 0
        object GridPanelGridElementVisibility: TGridPanel
          Left = 2
          Top = 17
          Width = 238
          Height = 191
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = LabelAxesVisibility
              Row = 0
            end
            item
              Column = 0
              Control = CheckBoxXAxis
              Row = 1
            end
            item
              Column = 0
              Control = CheckBoxYAxis
              Row = 2
            end
            item
              Column = 0
              Control = LabelAxisValuesVisibility
              Row = 3
            end
            item
              Column = 0
              Control = CheckBoxXAxisValues
              Row = 4
            end
            item
              Column = 0
              Control = CheckBoxYAxisValues
              Row = 5
            end
            item
              Column = 0
              Control = LabelGridLineVisibility
              Row = 6
            end
            item
              Column = 0
              Control = CheckBoxMajorLines
              Row = 7
            end
            item
              Column = 0
              Control = CheckBoxMinorLines
              Row = 8
            end>
          ParentColor = True
          RowCollection = <
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111110000
            end
            item
              Value = 11.111111111111100000
            end>
          TabOrder = 0
          object LabelAxesVisibility: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 1
            Width = 24
            Height = 15
            Margins.Left = 5
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Axes'
            Layout = tlCenter
          end
          object CheckBoxXAxis: TCheckBox
            AlignWithMargins = True
            Left = 20
            Top = 22
            Width = 217
            Height = 19
            Margins.Left = 20
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'X-Axis'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = CheckBoxGridVisibilityClick
          end
          object CheckBoxYAxis: TCheckBox
            AlignWithMargins = True
            Left = 20
            Top = 43
            Width = 217
            Height = 20
            Margins.Left = 20
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Y-Axis'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = CheckBoxGridVisibilityClick
          end
          object LabelAxisValuesVisibility: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 65
            Width = 57
            Height = 15
            Margins.Left = 5
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Axis Values'
            Layout = tlCenter
          end
          object CheckBoxXAxisValues: TCheckBox
            AlignWithMargins = True
            Left = 20
            Top = 86
            Width = 217
            Height = 19
            Margins.Left = 20
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'X-Axis'
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = CheckBoxGridVisibilityClick
          end
          object CheckBoxYAxisValues: TCheckBox
            AlignWithMargins = True
            Left = 20
            Top = 107
            Width = 217
            Height = 19
            Margins.Left = 20
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Y-Axis'
            Checked = True
            State = cbChecked
            TabOrder = 3
            OnClick = CheckBoxGridVisibilityClick
          end
          object LabelGridLineVisibility: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 128
            Width = 52
            Height = 15
            Margins.Left = 5
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Grid Lines'
            Layout = tlCenter
          end
          object CheckBoxMajorLines: TCheckBox
            AlignWithMargins = True
            Left = 20
            Top = 150
            Width = 217
            Height = 19
            Margins.Left = 20
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Major'
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnClick = CheckBoxGridVisibilityClick
          end
          object CheckBoxMinorLines: TCheckBox
            AlignWithMargins = True
            Left = 20
            Top = 171
            Width = 217
            Height = 19
            Margins.Left = 20
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 1
            Align = alClient
            Caption = 'Minor'
            Checked = True
            State = cbChecked
            TabOrder = 5
            OnClick = CheckBoxGridVisibilityClick
          end
        end
      end
    end
  end
  object ButtonShowSettings: TButton
    Left = 1738
    Top = 3
    Width = 25
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'S'
    TabOrder = 1
    OnClick = ButtonShowSettingsClick
  end
end
