object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 787
  ClientWidth = 1660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object JDBGraphXY1: TJDBGraphXY
    Left = 0
    Top = 0
    Width = 1660
    Height = 787
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    Caption = 'JDBGraphXY1'
    ParentColor = True
    ParentShowHint = False
    ShowCaption = False
    ShowHint = True
    TabOrder = 0
    GraphTitle = 'Displacement vs Time'
    XAxisLabel = 'Time'
    XAxisUnits = 's'
    YAxisLabel = 'Displ.'
    YAxisUnits = 'm'
    OnUpdateGraphPlots = JDBGraphXY1UpdateGraphPlots
    ExplicitLeft = 96
    ExplicitTop = 120
  end
end
