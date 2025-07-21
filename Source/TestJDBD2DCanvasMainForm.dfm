object JDB_D2D_Form: TJDB_D2D_Form
  Left = 0
  Top = 0
  Caption = 'JDB_D2D_Form'
  ClientHeight = 721
  ClientWidth = 1334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1334
    Height = 721
    ActivePage = TabSheetXY
    Align = alClient
    TabOrder = 0
    object TabSheetLT: TTabSheet
      Caption = 'LT-Coordinates'
      object GridPanel1: TGridPanel
        Left = 0
        Top = 0
        Width = 1326
        Height = 691
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = PaintBoxArcEntity
            Row = 0
          end
          item
            Column = 1
            Control = PaintBoxEllipseEntity
            Row = 0
          end
          item
            Column = 0
            Control = PaintBoxPathGeometry
            Row = 1
          end
          item
            Column = 1
            Control = PaintBoxRectangle
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 0
        ExplicitWidth = 1334
        ExplicitHeight = 721
        object PaintBoxArcEntity: TPaintBox
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 653
          Height = 336
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Anchors = []
          OnPaint = PaintBoxArcEntityPaint
          ExplicitLeft = 312
          ExplicitTop = 320
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
        object PaintBoxEllipseEntity: TPaintBox
          AlignWithMargins = True
          Left = 668
          Top = 5
          Width = 653
          Height = 336
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          OnPaint = PaintBoxEllipseEntityPaint
          ExplicitLeft = 616
          ExplicitTop = 312
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
        object PaintBoxPathGeometry: TPaintBox
          AlignWithMargins = True
          Left = 5
          Top = 351
          Width = 653
          Height = 335
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          OnPaint = PaintBoxPathGeometryPaint
          ExplicitLeft = 616
          ExplicitTop = 312
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
        object PaintBoxRectangle: TPaintBox
          AlignWithMargins = True
          Left = 668
          Top = 351
          Width = 653
          Height = 335
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          OnPaint = PaintBoxRectanglePaint
          ExplicitLeft = 816
          ExplicitTop = 592
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
      end
    end
    object TabSheetXY: TTabSheet
      Caption = 'XY-Coordinates'
      ImageIndex = 1
      object PaintBoxXY: TPaintBox
        Left = 0
        Top = 0
        Width = 1326
        Height = 691
        Align = alClient
        OnPaint = PaintBoxXYPaint
        ExplicitLeft = 328
        ExplicitTop = 368
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
end
