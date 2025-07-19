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
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object GridPanel1: TGridPanel
    Left = 0
    Top = 0
    Width = 1334
    Height = 721
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
    object PaintBoxArcEntity: TPaintBox
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 657
      Height = 350
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
      Left = 672
      Top = 5
      Width = 657
      Height = 350
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
      Top = 365
      Width = 657
      Height = 351
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
      Left = 672
      Top = 365
      Width = 657
      Height = 351
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
