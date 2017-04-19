unit DO2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Types, MainF, CoalGrade, ExtCtrls, Buttons;

type
  TDO2Form = class(TForm)
    sgGradesTh: TStringGrid;
    Label1: TLabel;
    btResAllSumm2: TBitBtn;
    btCalibrAll2: TBitBtn;
    CalibrationTimer: TTimer;
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
    lbDelay: TLabel;
    lbPrDelay: TLabel;
    procedure sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btResAllSumm2Click(Sender: TObject);
    procedure btCalibrAll2Click(Sender: TObject);
    procedure CalibrationTimerTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
  public
    procedure DeSelectAll;
    procedure ResetAllSumm;
  end;

var
  DO2Form: TDO2Form;

implementation

uses DO1DO2, BatchProp;

{$R *.DFM}

procedure TDO2Form.sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer;
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
      for i := 1 to Storage2.CoalGradesList.Count do
        begin
          FGrade := Storage2.CoalGradesList.Items[i - 1];
          if (ACol = i) and (ARow = 0) then
            begin
              if AnyWorking2 and (Abs(FGrade.AssignTh - FGrade.ProdTh) > 0.03 * FGrade.AssignTh) then
                Canvas.Font.Color := clRed else Canvas.Font.Color := clNavy;
            end;
        end;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TDO2Form.FormCreate(Sender: TObject);
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

procedure TDO2Form.btResAllSumm2Click(Sender: TObject);
begin
  if MessageDlg('Выполнить обнуление суммы на всех дозаторах?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ResetAllSumm;
      MicroNet.Summ[17] := 0;
    end;
end;

procedure TDO2Form.btCalibrAll2Click(Sender: TObject);
begin
  if MessageDlg('Запустить цикл автокалибровки?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    btCalibrAll2.Enabled := False;
    btResAllSumm2.Enabled := False;
    WinCC2.Calibration := True;
    CalibrationStep := 1;
    CalibrationTimer.Interval := 40000;
    CalibrationTimer.Enabled := True;
  end;
end;

procedure TDO2Form.CalibrationTimerTimer(Sender: TObject);
var
  i : byte;
begin
  CalibrationTimer.Enabled := False;
  Case CalibrationStep of
  1 : begin
        ResetAllSumm;
        for i := 1 to 16 do
          begin
            Batch := BatchList2.Items[i - 1];
            CalibrationArray[i] := Batch.Conv2;
          end;
        CalibrationStep := CalibrationStep + 1;
        CalibrationTimer.Interval := 60000;
        CalibrationTimer.Enabled := True;
      end;
  2 : begin
        for i := 1 to 16 do
          begin
            Batch := BatchList2.Items[i - 1];
            if CalibrationArray[i] and (not Batch.Conv2) then MicroNet.Prod[i] := 0;
          end;
        WinCC2.Calibration := False;
        CalibrationTimer.Enabled := False;
        btCalibrAll2.Enabled := True;
        btResAllSumm2.Enabled := True;
      end;
  end;
end;

procedure TDO2Form.ResetAllSumm;
var
  i : byte;
begin
  for i := 1 to 16 do
    begin
      Batch := BatchList2.Items[i - 1];
      if Batch.State <> stNotMnt then MicroNet.Summ[i] := 0;
    end;
end;

procedure TDO2Form.BitBtn1Click(Sender: TObject);
begin
  DO2Form.Hide;
  DO1DO2Form.Show;
end;

procedure TDO2Form.FormHide(Sender: TObject);
begin
  BatchPropForm.Hide;
end;

procedure TDO2Form.DeSelectAll;
var
  i : byte;
begin
  for i := 1 to 16 do
    begin
      Batch := BatchList2.Items[i - 1];
      Batch.Select := False;
    end;
end;


procedure TDO2Form.FormShow(Sender: TObject);
begin
  DeSelectAll;
end;

end.
unit DO2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Types, MainF, CoalGrade, ExtCtrls, Buttons;

type
  TDO2Form = class(TForm)
    sgGradesTh: TStringGrid;
    Label1: TLabel;
    btResAllSumm2: TBitBtn;
    btCalibrAll2: TBitBtn;
    CalibrationTimer: TTimer;
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
    lbDelay: TLabel;
    lbPrDelay: TLabel;
    procedure sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btResAllSumm2Click(Sender: TObject);
    procedure btCalibrAll2Click(Sender: TObject);
    procedure CalibrationTimerTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
  public
    procedure DeSelectAll;
    procedure ResetAllSumm;
  end;

var
  DO2Form: TDO2Form;

implementation

uses DO1DO2, BatchProp;

{$R *.DFM}

procedure TDO2Form.sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer;
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
      for i := 1 to Storage2.CoalGradesList.Count do
        begin
          FGrade := Storage2.CoalGradesList.Items[i - 1];
          if (ACol = i) and (ARow = 0) then
            begin
              if AnyWorking2 and (Abs(FGrade.AssignTh - FGrade.ProdTh) > 0.03 * FGrade.AssignTh) then
                Canvas.Font.Color := clRed else Canvas.Font.Color := clNavy;
            end;
        end;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TDO2Form.FormCreate(Sender: TObject);
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

procedure TDO2Form.btResAllSumm2Click(Sender: TObject);
begin
  if MessageDlg('Выполнить обнуление суммы на всех дозаторах?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ResetAllSumm;
      MicroNet.Summ[17] := 0;
    end;
end;

procedure TDO2Form.btCalibrAll2Click(Sender: TObject);
begin
  if MessageDlg('Запустить цикл автокалибровки?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    btCalibrAll2.Enabled := False;
    btResAllSumm2.Enabled := False;
    WinCC2.Calibration := True;
    CalibrationStep := 1;
    CalibrationTimer.Interval := 40000;
    CalibrationTimer.Enabled := True;
  end;
end;

procedure TDO2Form.CalibrationTimerTimer(Sender: TObject);
var
  i : byte;
begin
  CalibrationTimer.Enabled := False;
  Case CalibrationStep of
  1 : begin
        ResetAllSumm;
        for i := 1 to 16 do
          begin
            Batch := BatchList2.Items[i - 1];
            CalibrationArray[i] := Batch.Conv2;
          end;
        CalibrationStep := CalibrationStep + 1;
        CalibrationTimer.Interval := 60000;
        CalibrationTimer.Enabled := True;
      end;
  2 : begin
        for i := 1 to 16 do
          begin
            Batch := BatchList2.Items[i - 1];
            if CalibrationArray[i] and (not Batch.Conv2) then MicroNet.Prod[i] := 0;
          end;
        WinCC2.Calibration := False;
        CalibrationTimer.Enabled := False;
        btCalibrAll2.Enabled := True;
        btResAllSumm2.Enabled := True;
      end;
  end;
end;

procedure TDO2Form.ResetAllSumm;
var
  i : byte;
begin
  for i := 1 to 16 do
    begin
      Batch := BatchList2.Items[i - 1];
      if Batch.State <> stNotMnt then MicroNet.Summ[i] := 0;
    end;
end;

procedure TDO2Form.BitBtn1Click(Sender: TObject);
begin
  DO2Form.Hide;
  DO1DO2Form.Show;
end;

procedure TDO2Form.FormHide(Sender: TObject);
begin
  BatchPropForm.Hide;
end;

procedure TDO2Form.DeSelectAll;
var
  i : byte;
begin
  for i := 1 to 16 do
    begin
      Batch := BatchList2.Items[i - 1];
      Batch.Select := False;
    end;
end;


procedure TDO2Form.FormShow(Sender: TObject);
begin
  DeSelectAll;
end;

end.
