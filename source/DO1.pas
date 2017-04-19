unit DO1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons, Types, MainF, CoalGrade;

type
  TDO1Form = class(TForm)
    sgGradesTh: TStringGrid;
    Label1: TLabel;
    btResAllSumm1: TBitBtn;
    btCalibrAll1: TBitBtn;
    BitBtn1: TBitBtn;
    Label21: TLabel;
    lbPrTotal: TLabel;
    Label23: TLabel;
    lbPrTot1: TLabel;
    Label25: TLabel;
    lbPrTot2: TLabel;
    Label27: TLabel;
    lbWeight: TLabel;
    Label30: TLabel;
    lbPrU: TLabel;
    Label2: TLabel;
    lbWeightU: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
  public
    procedure DeSelectAll;
  end;

var
  DO1Form: TDO1Form;

implementation

uses DO1DO2, BatchProp;

{$R *.DFM}

procedure TDO1Form.FormCreate(Sender: TObject);
var
  myRect: TGridRect;
begin
  Height := 740;
  Width := 1024;
  Top := 0;
  Left := 0;

  myRect.Left := -1;
  myRect.Top := -1;
  myRect.Right := -1;
  myRect.Bottom := -1;

  sgGradesTh.ColWidths[0] := 140;
  sgGradesTh.Cells[0,0] := 'Шихтогруппы:';
  sgGradesTh.Cells[0,1] := 'Задано, (т/ч):';
  sgGradesTh.Cells[0,2] := 'Производительн., (т/ч):';
  sgGradesTh.Selection := myRect;
end;

procedure TDO1Form.BitBtn1Click(Sender: TObject);
begin
  DO1Form.Hide;
  DO1DO2Form.Show;
end;

procedure TDO1Form.FormHide(Sender: TObject);
begin
  BatchPropForm.Hide;
end;

procedure TDO1Form.sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i : byte;
begin
  with Sender as TStringGrid do
    begin
      if (ACol > 0) and (ARow > 0) and (Cells[ACol, ARow] <> '') then
        begin
          Canvas.Font.Color := TrendsColors[ACol];
          Canvas.Font.Name := 'Courier New';
          Canvas.Font.Size := 16;
          Canvas.Font.Style := [fsBold];
        end;
      for i := 1 to Storage1.CoalGradesList.Count do
        begin
          FGrade := Storage1.CoalGradesList.Items[i - 1];
          if (ACol = i) and (ARow = 0) then
            begin
              if AnyWorking1 and (Abs(FGrade.AssignTh - FGrade.ProdTh) > 0.03 * FGrade.AssignTh) then
                Canvas.Font.Color := clRed else Canvas.Font.Color := clNavy;
            end;
        end;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TDO1Form.FormShow(Sender: TObject);
begin
  DeSelectAll;
end;

procedure TDO1Form.DeSelectAll;
var
  i : byte;
begin
  for i := 1 to 14 do
    begin
      Batch := BatchList1.Items[i - 1];
      Batch.Select := False;
    end;
end;


end.
