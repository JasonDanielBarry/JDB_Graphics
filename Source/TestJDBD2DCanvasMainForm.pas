unit TestJDBD2DCanvasMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  JDBDirect2DCanvasClass;

type
  TJDB_D2D_Form = class(TForm)
    PaintBox1: TPaintBox;
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  JDB_D2D_Form: TJDB_D2D_Form;

implementation

{$R *.dfm}

procedure TJDB_D2D_Form.PaintBox1Paint(Sender: TObject);
    var
        D2DCanvas : TJDBDirect2DCanvas;
    begin
//        asdf
    end;

end.
