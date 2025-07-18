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
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 0
    ExplicitLeft = 584
    ExplicitTop = 360
    ExplicitWidth = 185
    ExplicitHeight = 41
    object PaintBoxArcEntity: TPaintBox
      Left = 0
      Top = 0
      Width = 667
      Height = 360
      Align = alClient
      Anchors = []
      OnPaint = PaintBoxArcEntityPaint
      ExplicitLeft = 312
      ExplicitTop = 320
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object PaintBoxEllipseEntity: TPaintBox
      Left = 667
      Top = 0
      Width = 667
      Height = 360
      Align = alClient
      OnPaint = PaintBoxEllipseEntityPaint
      ExplicitLeft = 616
      ExplicitTop = 312
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
end
