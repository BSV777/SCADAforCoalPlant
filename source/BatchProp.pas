unit BatchProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MainF, Types, CoalGrade, Storage;

type
  TBatchPropForm = class(TForm)
    lbN: TLabel;
    cbMount: TCheckBox;
    lbPrGrade: TLabel;
    cbPropGrade: TComboBox;
    Label8: TLabel;
    lbRecommend: TLabel;
    btSaveConfig: TBitBtn;
    GroupBox1: TGroupBox;
    lbCurrent: TLabel;
    lbBatN: TLabel;
    edAddGrade: TEdit;
    btAddGrade: TBitBtn;
    procedure btSaveConfigClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  //  procedure btAddGradeClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateGradesList;
  end;

var
  BatchPropForm: TBatchPropForm;

implementation

uses DO1DO2, DO1, DO2;

{$R *.DFM}

procedure TBatchPropForm.btSaveConfigClick(Sender: TObject);
var
  pStorage : ^TStorage;
begin
  if CurrentDO = 1 then
    begin
      Batch := BatchList1.Items[CurrentBatch - 1];
      pStorage := @Storage1;
    end else
    begin
      Batch := BatchList2.Items[CurrentBatch - 1];
      pStorage := @Storage2;
    end;
  Batch.Select := False;
  Batch.Grade := cbPropGrade.ItemIndex;
  pStorage.Grades[CurrentBatch] := Batch.Grade;
  if cbMount.Checked then Batch.State := stOk else Batch.State := stNotMnt;
  pStorage.State[CurrentBatch] := Batch.State;
  pStorage.SaveConfig;

  pStorage.DeleteGrades;

  pStorage.CreateGrades;

  MakeGradesTables;

  if CurrentDO = 1 then
    begin
      RecipeManager1.DeleteGrades;
      RecipeManager1.CreateGrades;
      RecipeManager1.Batch := BatchList1;
      RecipeManager1.SetGradesNamesToBatchers(BatchList1);
      DO1DO2Form.DeleteTrends(1);
      DO1DO2Form.MakeTrends(1);
      DO1DO2Form.RedrawTrends(1);
    end else
    begin
      RecipeManager2.DeleteGrades;
      RecipeManager2.CreateGrades;
      RecipeManager2.Batch := BatchList2;
      RecipeManager2.SetGradesNamesToBatchers(BatchList2);
      DO1DO2Form.DeleteTrends(2);
      DO1DO2Form.MakeTrends(2);
      DO1DO2Form.RedrawTrends(2);
    end;
  Hide;
end;

procedure TBatchPropForm.FormHide(Sender: TObject);
begin
  if CurrentDO = 1 then DO1Form.DeSelectAll else DO2Form.DeSelectAll; 
end;

procedure TBatchPropForm.FormDeactivate(Sender: TObject);
begin
  if CurrentDO = 1 then DO1Form.DeSelectAll else DO2Form.DeSelectAll;
end;

{procedure TBatchPropForm.btAddGradeClick(Sender: TObject);
begin
  if Length(edAddGrade.Text) > 3 then
    if MessageDlg('Вы уверены, что шихтогруппа "' + edAddGrade.Text +
      '" отсутствует в списке?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          Storage1.AddGrade(edAddGrade.Text); //Только Storage1 !!!
          Storage1.LoadGradesList;
          Storage2.LoadGradesList;
          CreateGradesList;
        end;
end;}

procedure TBatchPropForm.CreateGradesList;
var
  i : byte;
begin
  cbPropGrade.Clear;
  cbPropGrade.Items.Add('---');
  for i := 1 to Storage1.GradesCount do cbPropGrade.Items.Add(Storage1.GradeNames[i]);
end;

end.
unit BatchProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MainF, Types, CoalGrade, Storage;

type
  TBatchPropForm = class(TForm)
    lbN: TLabel;
    cbMount: TCheckBox;
    lbPrGrade: TLabel;
    cbPropGrade: TComboBox;
    Label8: TLabel;
    lbRecommend: TLabel;
    btSaveConfig: TBitBtn;
    GroupBox1: TGroupBox;
    lbCurrent: TLabel;
    lbBatN: TLabel;
    edAddGrade: TEdit;
    btAddGrade: TBitBtn;
    procedure btSaveConfigClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  //  procedure btAddGradeClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateGradesList;
  end;

var
  BatchPropForm: TBatchPropForm;

implementation

uses DO1DO2, DO1, DO2;

{$R *.DFM}

procedure TBatchPropForm.btSaveConfigClick(Sender: TObject);
var
  pStorage : ^TStorage;
begin
  if CurrentDO = 1 then
    begin
      Batch := BatchList1.Items[CurrentBatch - 1];
      pStorage := @Storage1;
    end else
    begin
      Batch := BatchList2.Items[CurrentBatch - 1];
      pStorage := @Storage2;
    end;
  Batch.Select := False;
  Batch.Grade := cbPropGrade.ItemIndex;
  pStorage.Grades[CurrentBatch] := Batch.Grade;
  if cbMount.Checked then Batch.State := stOk else Batch.State := stNotMnt;
  pStorage.State[CurrentBatch] := Batch.State;
  pStorage.SaveConfig;

  pStorage.DeleteGrades;

  pStorage.CreateGrades;

  MakeGradesTables;

  if CurrentDO = 1 then
    begin
      RecipeManager1.DeleteGrades;
      RecipeManager1.CreateGrades;
      RecipeManager1.Batch := BatchList1;
      RecipeManager1.SetGradesNamesToBatchers(BatchList1);
      DO1DO2Form.DeleteTrends(1);
      DO1DO2Form.MakeTrends(1);
      DO1DO2Form.RedrawTrends(1);
    end else
    begin
      RecipeManager2.DeleteGrades;
      RecipeManager2.CreateGrades;
      RecipeManager2.Batch := BatchList2;
      RecipeManager2.SetGradesNamesToBatchers(BatchList2);
      DO1DO2Form.DeleteTrends(2);
      DO1DO2Form.MakeTrends(2);
      DO1DO2Form.RedrawTrends(2);
    end;
  Hide;
end;

procedure TBatchPropForm.FormHide(Sender: TObject);
begin
  if CurrentDO = 1 then DO1Form.DeSelectAll else DO2Form.DeSelectAll; 
end;

procedure TBatchPropForm.FormDeactivate(Sender: TObject);
begin
  if CurrentDO = 1 then DO1Form.DeSelectAll else DO2Form.DeSelectAll;
end;

{procedure TBatchPropForm.btAddGradeClick(Sender: TObject);
begin
  if Length(edAddGrade.Text) > 3 then
    if MessageDlg('Вы уверены, что шихтогруппа "' + edAddGrade.Text +
      '" отсутствует в списке?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          Storage1.AddGrade(edAddGrade.Text); //Только Storage1 !!!
          Storage1.LoadGradesList;
          Storage2.LoadGradesList;
          CreateGradesList;
        end;
end;}

procedure TBatchPropForm.CreateGradesList;
var
  i : byte;
begin
  cbPropGrade.Clear;
  cbPropGrade.Items.Add('---');
  for i := 1 to Storage1.GradesCount do cbPropGrade.Items.Add(Storage1.GradeNames[i]);
end;

end.
