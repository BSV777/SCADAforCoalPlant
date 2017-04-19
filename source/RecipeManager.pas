unit RecipeManager;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls, Types, mask,
  Batcher, Storage, Dialogs, Controls, CoalGrade;

type
  TRecipeManager = class(TCustomPanel)
  private
    ScrollBox1: TScrollBox;
    lbRecipeText : TLabel;
    meRecipe1Summ : TEdit;
    meRecipe2Summ : TEdit;
    lbConv : TLabel;
    rbRecipe1 : TRadioButton;
    rbRecipe2 : TRadioButton;
    btSaveRecipe : TButton;
    GradesNameList : TList;
    GradesAsRecipe1List : TList;
    GradesAsRecipe2List : TList;
    BatchEnableList : TList;
    BatchAssignedList : TList;
    FBatchList : TList;
    pStorage : ^TStorage;
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
    procedure meKeyPress(Sender: TObject; var Key: Char);
    procedure meKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btSaveRecipeClick(Sender: TObject);
  protected
    procedure SetBatch(Value : TList);
    procedure SetStorage(var Value : TStorage);
  public
    constructor Create(AOwner:TComponent); override;
    procedure DeleteGrades;
    procedure CreateGrades;
    procedure SetGradesNamesToBatchers(Value : TList);    
    property Batch : TList write SetBatch;
    property Storage : TStorage write SetStorage;
  end;

implementation

constructor TRecipeManager.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Width := 1003;
  Height := 265;
  BevelWidth := 1;
  Caption := '';
  Font.Name := 'MS Sans Serif';
  ScrollBox1 := TScrollBox.Create(Self);
  with ScrollBox1 do
    begin
      Parent := Self;
      Left := 2;
      Top := 2;
      Width := 1000;
      Height := 225;
      VertScrollBar.Range := 100;
    end;
  lbRecipeText := TLabel.Create(Self);
  with lbRecipeText do
    begin
      Parent := Self;
      Left := 10;
      Top := 240;
      Caption := 'Составы шихты:';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  rbRecipe1 := TRadioButton.Create(Self);
  with rbRecipe1 do
    begin
      Parent := Self;
      Left := 142;
      Top := 240;
      Width := 40;
      Caption := '1';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  meRecipe1Summ := TEdit.Create(Self);
  with meRecipe1Summ do
    begin
      Parent := Self;
      Left := 182;
      Top := 235;
      Caption := '0';
      Width := 40;
      Font.Color := clBlack;
      Font.Size := 11;
      Font.Charset := 204;
      Font.Name := 'MS Sans Serif';
      Font.Style := [fsBold];
      OnKeyPress := meKeyPress;
      OnKeyDown := meKeyDown;
    end;
  rbRecipe2 := TRadioButton.Create(Self);
  with rbRecipe2 do
    begin
      Parent := Self;
      Left := 242;
      Top := 240;
      Width := 40;
      Caption := '2';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  meRecipe2Summ := TEdit.Create(Self);
  with meRecipe2Summ do
    begin
      Parent := Self;
      Left := 282;
      Top := 235;
      Caption := '0';
      Width := 40;
      Font.Color := clBlack;
      Font.Size := 11;
      Font.Charset := 204;
      Font.Name := 'MS Sans Serif';
      Font.Style := [fsBold];
      OnKeyPress := meKeyPress;
      OnKeyDown := meKeyDown;
    end;
  lbConv := TLabel.Create(Self);
  with lbConv do
    begin
      Parent := Self;
      Left := 350;
      Top := 237;
      Caption := '___ / ___';
      Font.Color := clNavy;
      Font.Size := 12;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  btSaveRecipe := TButton.Create(Self);
  with btSaveRecipe do
    begin
      Parent := Self;
      Left := 500;
      Top := 235;
      Width := 100;
      Height := 25;
      Caption := 'Запись';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
      OnClick := btSaveRecipeClick;
    end;

  GradesNameList := TList.Create;
  GradesAsRecipe1List := TList.Create;
  GradesAsRecipe2List := TList.Create;
  BatchEnableList := TList.Create;
  BatchAssignedList := TList.Create;
end;

procedure TRecipeManager.SetBatch(Value : TList); //
var
  Batch : TBatcher;
  i, j, CalcBatchCount, TotalBatchCount : byte;
  BatchEnableCount : array of byte;
  cbBatchEnable : TCheckBox;
  meBatchAssigned : TEdit;
  Summ1, Summ2 : single;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  FBatchList := Value;
  SetLength(BatchEnableCount, pStorage.CoalGradesList.Count + 1);
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      Batch := FBatchList.Items[i - 1];
      meBatchAssigned := BatchAssignedList.Items[i - 1];
      meBatchAssigned.Visible := (Batch.State <> stNotMnt) and (Batch.Grade <> 0);
      cbBatchEnable := BatchEnableList.Items[i - 1];
      cbBatchEnable.Visible := (Batch.State <> stNotMnt) and (Batch.Grade <> 0);
      cbBatchEnable.Checked := Batch.Enable;
    end;

  for j := 1 to pStorage.CoalGradesList.Count do
    begin
      if pStorage.RecipeNo = 1 then
        begin
          meAsRecipe1 := GradesAsRecipe1List.Items[j - 1];
          meAsRecipe1.Color := clWhite;
          meRecipe1Summ.Color := clWhite;
          meAsRecipe2 := GradesAsRecipe2List.Items[j - 1];
          meAsRecipe2.Color := clLtGray;
          meRecipe2Summ.Color := clLtGray;
        end else
        begin
          meAsRecipe1 := GradesAsRecipe1List.Items[j - 1];
          meAsRecipe1.Color := clLtGray;
          meRecipe1Summ.Color := clLtGray;
          meAsRecipe2 := GradesAsRecipe2List.Items[j - 1];
          meAsRecipe2.Color := clWhite;
          meRecipe2Summ.Color := clWhite;
        end;
      FGrade := pStorage.CoalGradesList.Items[j - 1];
      CalcBatchCount := 0;
      TotalBatchCount := 0;
      for i := 1 to pStorage.MaxBatchCounter do
        begin
          Batch := FBatchList.Items[i - 1];
          if (Batch.State <> stNotMnt) and (FGrade.GradeNum = Batch.Grade) and Batch.Enable then CalcBatchCount := CalcBatchCount + 1;
          if (Batch.State <> stNotMnt) and (FGrade.GradeNum = Batch.Grade) then TotalBatchCount := TotalBatchCount + 1;
        end;
      BatchEnableCount[j] := 0;

      for i := 1 to pStorage.MaxBatchCounter do
        begin
          Batch := FBatchList.Items[i - 1];
          if (Batch.State <> stNotMnt) then
            begin
              if (TotalBatchCount > 0) and (FGrade.GradeNum = Batch.Grade) then
                begin
                  BatchEnableCount[j] := BatchEnableCount[j] + 1;
                  cbBatchEnable := BatchEnableList.Items[i - 1];
                  cbBatchEnable.Left := 290 + BatchEnableCount[j] * 100;

                  cbBatchEnable.Top := 27 * (j - 1) + 4 - ScrollBox1.VertScrollBar.Position;
                  meBatchAssigned := BatchAssignedList.Items[i - 1];
                  meBatchAssigned.Left := 330 + BatchEnableCount[j] * 100;

                  meBatchAssigned.Top := 27 * (j - 1) + 2 - ScrollBox1.VertScrollBar.Position;
                end;
            end;
          if (Batch.State <> stNotMnt) and Batch.Enable then
            begin
              if (CalcBatchCount > 0) and (FGrade.GradeNum = Batch.Grade) then Batch.Recommend := FGrade.AssignTh / CalcBatchCount;
            end else Batch.Recommend := 0;
        end;
    end;
  Summ1 := 0;
  Summ2 := 0;
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      Batch := FBatchList.Items[i - 1];
      cbBatchEnable := BatchEnableList.Items[i - 1];
      Batch.Enable := cbBatchEnable.Checked;
      meBatchAssigned := BatchAssignedList.Items[i - 1];
      meBatchAssigned.Text := Format('%3.0f', [Batch.Recommend]);
      if Batch.Enable then
        begin
          if Odd(i) then Summ1 := Summ1 + Batch.Recommend else Summ2 := Summ2 + Batch.Recommend;
        end;
    end;
    lbConv.Caption := '= ' + Format('%3.0f', [Summ1]) + ' / ' + Format('%3.0f', [Summ2]);
end;

procedure TRecipeManager.meKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #8 then if not(Key in['0'..'9'])then Key := #0;
end;

procedure TRecipeManager.meKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

end;

procedure TRecipeManager.SetStorage(var Value : TStorage);
var
  i : byte;
  cbBatchEnable : TCheckBox;
  meBatchAssigned : TEdit;
begin
  pStorage := @Value;
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      BatchEnableList.Add(TCheckBox.Create(Self));
      cbBatchEnable := BatchEnableList.Items[i - 1];
      with cbBatchEnable do
        begin
          Parent := ScrollBox1;
          Left := 500;
          Top := 3;
          Height := 18;
          Width :=  35;
          Caption := IntToStr(i);
          Enabled := True;
          Visible := True;
          Checked := True;
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
        end;
      BatchAssignedList.Add(TEdit.Create(Self));
      meBatchAssigned := BatchAssignedList.Items[i - 1];
      with meBatchAssigned do
        begin
          Parent := ScrollBox1;
          Left := 500;
          Top := 3;
          Width := 40;
          Height := 18;
          Visible := True;
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
          OnKeyPress := meKeyPress;
          OnKeyDown := meKeyDown;
        end;
    end;
end;

procedure TRecipeManager.DeleteGrades;
var
  i, Count : byte;
  lbGradeName : TLabel;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  Count := GradesNameList.Count - 1;
  for i := Count downto 0 do
    begin
      lbGradeName := GradesNameList.Items[i];
      GradesNameList.Delete(i);
      lbGradeName.Free;

      meAsRecipe1 := GradesAsRecipe1List.Items[i];
      GradesAsRecipe1List.Delete(i);
      meAsRecipe1.Free;

      meAsRecipe2 := GradesAsRecipe2List.Items[i];
      GradesAsRecipe2List.Delete(i);
      meAsRecipe2.Free;
    end;
end;

procedure TRecipeManager.CreateGrades;
var
  i : byte;
  lbGradeName : TLabel;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  ScrollBox1.VertScrollBar.Range := pStorage.CoalGradesList.Count * 30;
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      GradesNameList.Add(TLabel.Create(Self));
      GradesAsRecipe1List.Add(TEdit.Create(Self));
      GradesAsRecipe2List.Add(TEdit.Create(Self));

      FGrade := pStorage.CoalGradesList.Items[i - 1];

      lbGradeName := GradesNameList.Items[i - 1];
      with lbGradeName do
        begin
          Parent := ScrollBox1;
          Top := (i - 1) * 27 + 3 - ScrollBox1.VertScrollBar.Position;;
          Left := 10;
          Caption := FGrade.GradeName;
          AutoSize := True;
          Font.Color := TrendsColors[i];
          Font.Size := 10;
          Font.Charset := 204;
          Font.Name := 'Times New Roman';
          Font.Style := [fsBold];
        end;

      meAsRecipe1 := GradesAsRecipe1List.Items[i - 1];
      with meAsRecipe1 do
        begin
          Parent := ScrollBox1;
          Top := (i - 1) * 27 + 1 - ScrollBox1.VertScrollBar.Position;;
          Left := 180;
          Width := 40;
          Text := IntToStr(Round(pStorage.RecipeGrade1[FGrade.GradeNum]));
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
          OnKeyPress := meKeyPress;
          OnKeyDown := meKeyDown;
        end;

      meAsRecipe2 := GradesAsRecipe2List.Items[i - 1];
      with meAsRecipe2 do
        begin
          Parent := ScrollBox1;
          Top := (i - 1) * 27 + 1 - ScrollBox1.VertScrollBar.Position;;
          Left := 280;
          Width := 40;
          Text := IntToStr(Round(pStorage.RecipeGrade2[FGrade.GradeNum]));
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
          OnKeyPress := meKeyPress;
          OnKeyDown := meKeyDown;
        end;
    end;
  meRecipe1Summ.Text := IntToStr(Round(pStorage.AssignTotal1));
  meRecipe2Summ.Text := IntToStr(Round(pStorage.AssignTotal2));
  if pStorage.RecipeNo = 1 then
    begin
      rbRecipe2.Checked := False;
      rbRecipe1.Checked := True
    end else
    begin
      rbRecipe1.Checked := False;
      rbRecipe2.Checked := True;
    end;
end;

procedure TRecipeManager.btSaveRecipeClick(Sender: TObject);
var
  i : byte;
  Summ1, Summ2 : single;
  AnyChange : boolean;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  Summ1 := 0;
  Summ2 := 0;
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      meAsRecipe1 := GradesAsRecipe1List.Items[i - 1];
      Summ1 := Summ1 + StrToFloat(meAsRecipe1.Text);
      meAsRecipe2 := GradesAsRecipe2List.Items[i - 1];
      Summ2 := Summ2 + StrToFloat(meAsRecipe2.Text);
    end;
  if (Summ1 <> 100) or (Summ2 <> 100) then ShowMessage('Сумма не равна 100%')
    else if MessageDlg('Подтвердите запись' , mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        for i := 1 to pStorage.GradesCount do
          begin
            pStorage.RecipeGrade1[i] := 0;
            pStorage.RecipeGrade2[i] := 0;
          end;
        for i := 1 to pStorage.CoalGradesList.Count do
          begin
            meAsRecipe1 := GradesAsRecipe1List.Items[i - 1];
            meAsRecipe2 := GradesAsRecipe2List.Items[i - 1];
            FGrade := pStorage.CoalGradesList.Items[i - 1];
            pStorage.RecipeGrade1[FGrade.GradeNum] := StrToFloat(meAsRecipe1.Text);
            pStorage.RecipeGrade2[FGrade.GradeNum] := StrToFloat(meAsRecipe2.Text);
          end;
        pStorage.AssignTotal1 := StrToInt(meRecipe1Summ.Text);
        pStorage.AssignTotal2 := StrToInt(meRecipe2Summ.Text);
        AnyChange := False;
        if rbRecipe1.Checked then
          begin
            pStorage.RecipeNo := 1;
            AnyChange := AnyChange or (pStorage.CurrentAssignTotal <> pStorage.AssignTotal1);
            pStorage.CurrentAssignTotal := pStorage.AssignTotal1;
            for i := 1 to pStorage.GradesCount do
              begin
                AnyChange := AnyChange or (pStorage.CurrentRecipeGrade[i] <> pStorage.RecipeGrade1[i]);
                pStorage.CurrentRecipeGrade[i] := pStorage.RecipeGrade1[i];
              end;
          end else
          begin
            pStorage.RecipeNo := 2;
            AnyChange := AnyChange or (pStorage.CurrentAssignTotal <> pStorage.AssignTotal2);
            pStorage.CurrentAssignTotal := pStorage.AssignTotal2;
            for i := 1 to pStorage.GradesCount do
              begin
                AnyChange := AnyChange or (pStorage.CurrentRecipeGrade[i] <> pStorage.RecipeGrade2[i]);
                pStorage.CurrentRecipeGrade[i] := pStorage.RecipeGrade2[i];
              end;
          end;
        if AnyChange then pStorage.SaveCurrentRecipe;
        pStorage.UpdateRecipes;
        pStorage.SaveConfig;
      end;
end;

procedure TRecipeManager.SetGradesNamesToBatchers(Value : TList);
//Присвоение дозаторам наименований и цветов шихтогрупп по их номерам
var
  i, j : byte;
  Batch : TBatcher;
begin
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      Batch := Value.Items[i - 1];
      Batch.GrName := pStorage.GradeNames[Batch.Grade];
    end;
  for j := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[j - 1];
      for i := 1 to pStorage.MaxBatchCounter do
        begin
          Batch := Value.Items[i - 1];
          if Batch.Grade = FGrade.GradeNum then Batch.GradeColor := j;
        end;
    end;
end;

end.
unit RecipeManager;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls, Types, mask,
  Batcher, Storage, Dialogs, Controls, CoalGrade;

type
  TRecipeManager = class(TCustomPanel)
  private
    ScrollBox1: TScrollBox;
    lbRecipeText : TLabel;
    meRecipe1Summ : TEdit;
    meRecipe2Summ : TEdit;
    lbConv : TLabel;
    rbRecipe1 : TRadioButton;
    rbRecipe2 : TRadioButton;
    btSaveRecipe : TButton;
    GradesNameList : TList;
    GradesAsRecipe1List : TList;
    GradesAsRecipe2List : TList;
    BatchEnableList : TList;
    BatchAssignedList : TList;
    FBatchList : TList;
    pStorage : ^TStorage;
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
    procedure meKeyPress(Sender: TObject; var Key: Char);
    procedure meKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btSaveRecipeClick(Sender: TObject);
  protected
    procedure SetBatch(Value : TList);
    procedure SetStorage(var Value : TStorage);
  public
    constructor Create(AOwner:TComponent); override;
    procedure DeleteGrades;
    procedure CreateGrades;
    procedure SetGradesNamesToBatchers(Value : TList);    
    property Batch : TList write SetBatch;
    property Storage : TStorage write SetStorage;
  end;

implementation

constructor TRecipeManager.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Width := 1003;
  Height := 265;
  BevelWidth := 1;
  Caption := '';
  Font.Name := 'MS Sans Serif';
  ScrollBox1 := TScrollBox.Create(Self);
  with ScrollBox1 do
    begin
      Parent := Self;
      Left := 2;
      Top := 2;
      Width := 1000;
      Height := 225;
      VertScrollBar.Range := 100;
    end;
  lbRecipeText := TLabel.Create(Self);
  with lbRecipeText do
    begin
      Parent := Self;
      Left := 10;
      Top := 240;
      Caption := 'Составы шихты:';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  rbRecipe1 := TRadioButton.Create(Self);
  with rbRecipe1 do
    begin
      Parent := Self;
      Left := 142;
      Top := 240;
      Width := 40;
      Caption := '1';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  meRecipe1Summ := TEdit.Create(Self);
  with meRecipe1Summ do
    begin
      Parent := Self;
      Left := 182;
      Top := 235;
      Caption := '0';
      Width := 40;
      Font.Color := clBlack;
      Font.Size := 11;
      Font.Charset := 204;
      Font.Name := 'MS Sans Serif';
      Font.Style := [fsBold];
      OnKeyPress := meKeyPress;
      OnKeyDown := meKeyDown;
    end;
  rbRecipe2 := TRadioButton.Create(Self);
  with rbRecipe2 do
    begin
      Parent := Self;
      Left := 242;
      Top := 240;
      Width := 40;
      Caption := '2';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  meRecipe2Summ := TEdit.Create(Self);
  with meRecipe2Summ do
    begin
      Parent := Self;
      Left := 282;
      Top := 235;
      Caption := '0';
      Width := 40;
      Font.Color := clBlack;
      Font.Size := 11;
      Font.Charset := 204;
      Font.Name := 'MS Sans Serif';
      Font.Style := [fsBold];
      OnKeyPress := meKeyPress;
      OnKeyDown := meKeyDown;
    end;
  lbConv := TLabel.Create(Self);
  with lbConv do
    begin
      Parent := Self;
      Left := 350;
      Top := 237;
      Caption := '___ / ___';
      Font.Color := clNavy;
      Font.Size := 12;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  btSaveRecipe := TButton.Create(Self);
  with btSaveRecipe do
    begin
      Parent := Self;
      Left := 500;
      Top := 235;
      Width := 100;
      Height := 25;
      Caption := 'Запись';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
      OnClick := btSaveRecipeClick;
    end;

  GradesNameList := TList.Create;
  GradesAsRecipe1List := TList.Create;
  GradesAsRecipe2List := TList.Create;
  BatchEnableList := TList.Create;
  BatchAssignedList := TList.Create;
end;

procedure TRecipeManager.SetBatch(Value : TList); //
var
  Batch : TBatcher;
  i, j, CalcBatchCount, TotalBatchCount : byte;
  BatchEnableCount : array of byte;
  cbBatchEnable : TCheckBox;
  meBatchAssigned : TEdit;
  Summ1, Summ2 : single;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  FBatchList := Value;
  SetLength(BatchEnableCount, pStorage.CoalGradesList.Count + 1);
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      Batch := FBatchList.Items[i - 1];
      meBatchAssigned := BatchAssignedList.Items[i - 1];
      meBatchAssigned.Visible := (Batch.State <> stNotMnt) and (Batch.Grade <> 0);
      cbBatchEnable := BatchEnableList.Items[i - 1];
      cbBatchEnable.Visible := (Batch.State <> stNotMnt) and (Batch.Grade <> 0);
      cbBatchEnable.Checked := Batch.Enable;
    end;

  for j := 1 to pStorage.CoalGradesList.Count do
    begin
      if pStorage.RecipeNo = 1 then
        begin
          meAsRecipe1 := GradesAsRecipe1List.Items[j - 1];
          meAsRecipe1.Color := clWhite;
          meRecipe1Summ.Color := clWhite;
          meAsRecipe2 := GradesAsRecipe2List.Items[j - 1];
          meAsRecipe2.Color := clLtGray;
          meRecipe2Summ.Color := clLtGray;
        end else
        begin
          meAsRecipe1 := GradesAsRecipe1List.Items[j - 1];
          meAsRecipe1.Color := clLtGray;
          meRecipe1Summ.Color := clLtGray;
          meAsRecipe2 := GradesAsRecipe2List.Items[j - 1];
          meAsRecipe2.Color := clWhite;
          meRecipe2Summ.Color := clWhite;
        end;
      FGrade := pStorage.CoalGradesList.Items[j - 1];
      CalcBatchCount := 0;
      TotalBatchCount := 0;
      for i := 1 to pStorage.MaxBatchCounter do
        begin
          Batch := FBatchList.Items[i - 1];
          if (Batch.State <> stNotMnt) and (FGrade.GradeNum = Batch.Grade) and Batch.Enable then CalcBatchCount := CalcBatchCount + 1;
          if (Batch.State <> stNotMnt) and (FGrade.GradeNum = Batch.Grade) then TotalBatchCount := TotalBatchCount + 1;
        end;
      BatchEnableCount[j] := 0;

      for i := 1 to pStorage.MaxBatchCounter do
        begin
          Batch := FBatchList.Items[i - 1];
          if (Batch.State <> stNotMnt) then
            begin
              if (TotalBatchCount > 0) and (FGrade.GradeNum = Batch.Grade) then
                begin
                  BatchEnableCount[j] := BatchEnableCount[j] + 1;
                  cbBatchEnable := BatchEnableList.Items[i - 1];
                  cbBatchEnable.Left := 290 + BatchEnableCount[j] * 100;

                  cbBatchEnable.Top := 27 * (j - 1) + 4 - ScrollBox1.VertScrollBar.Position;
                  meBatchAssigned := BatchAssignedList.Items[i - 1];
                  meBatchAssigned.Left := 330 + BatchEnableCount[j] * 100;

                  meBatchAssigned.Top := 27 * (j - 1) + 2 - ScrollBox1.VertScrollBar.Position;
                end;
            end;
          if (Batch.State <> stNotMnt) and Batch.Enable then
            begin
              if (CalcBatchCount > 0) and (FGrade.GradeNum = Batch.Grade) then Batch.Recommend := FGrade.AssignTh / CalcBatchCount;
            end else Batch.Recommend := 0;
        end;
    end;
  Summ1 := 0;
  Summ2 := 0;
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      Batch := FBatchList.Items[i - 1];
      cbBatchEnable := BatchEnableList.Items[i - 1];
      Batch.Enable := cbBatchEnable.Checked;
      meBatchAssigned := BatchAssignedList.Items[i - 1];
      meBatchAssigned.Text := Format('%3.0f', [Batch.Recommend]);
      if Batch.Enable then
        begin
          if Odd(i) then Summ1 := Summ1 + Batch.Recommend else Summ2 := Summ2 + Batch.Recommend;
        end;
    end;
    lbConv.Caption := '= ' + Format('%3.0f', [Summ1]) + ' / ' + Format('%3.0f', [Summ2]);
end;

procedure TRecipeManager.meKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #8 then if not(Key in['0'..'9'])then Key := #0;
end;

procedure TRecipeManager.meKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

end;

procedure TRecipeManager.SetStorage(var Value : TStorage);
var
  i : byte;
  cbBatchEnable : TCheckBox;
  meBatchAssigned : TEdit;
begin
  pStorage := @Value;
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      BatchEnableList.Add(TCheckBox.Create(Self));
      cbBatchEnable := BatchEnableList.Items[i - 1];
      with cbBatchEnable do
        begin
          Parent := ScrollBox1;
          Left := 500;
          Top := 3;
          Height := 18;
          Width :=  35;
          Caption := IntToStr(i);
          Enabled := True;
          Visible := True;
          Checked := True;
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
        end;
      BatchAssignedList.Add(TEdit.Create(Self));
      meBatchAssigned := BatchAssignedList.Items[i - 1];
      with meBatchAssigned do
        begin
          Parent := ScrollBox1;
          Left := 500;
          Top := 3;
          Width := 40;
          Height := 18;
          Visible := True;
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
          OnKeyPress := meKeyPress;
          OnKeyDown := meKeyDown;
        end;
    end;
end;

procedure TRecipeManager.DeleteGrades;
var
  i, Count : byte;
  lbGradeName : TLabel;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  Count := GradesNameList.Count - 1;
  for i := Count downto 0 do
    begin
      lbGradeName := GradesNameList.Items[i];
      GradesNameList.Delete(i);
      lbGradeName.Free;

      meAsRecipe1 := GradesAsRecipe1List.Items[i];
      GradesAsRecipe1List.Delete(i);
      meAsRecipe1.Free;

      meAsRecipe2 := GradesAsRecipe2List.Items[i];
      GradesAsRecipe2List.Delete(i);
      meAsRecipe2.Free;
    end;
end;

procedure TRecipeManager.CreateGrades;
var
  i : byte;
  lbGradeName : TLabel;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  ScrollBox1.VertScrollBar.Range := pStorage.CoalGradesList.Count * 30;
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      GradesNameList.Add(TLabel.Create(Self));
      GradesAsRecipe1List.Add(TEdit.Create(Self));
      GradesAsRecipe2List.Add(TEdit.Create(Self));

      FGrade := pStorage.CoalGradesList.Items[i - 1];

      lbGradeName := GradesNameList.Items[i - 1];
      with lbGradeName do
        begin
          Parent := ScrollBox1;
          Top := (i - 1) * 27 + 3 - ScrollBox1.VertScrollBar.Position;;
          Left := 10;
          Caption := FGrade.GradeName;
          AutoSize := True;
          Font.Color := TrendsColors[i];
          Font.Size := 10;
          Font.Charset := 204;
          Font.Name := 'Times New Roman';
          Font.Style := [fsBold];
        end;

      meAsRecipe1 := GradesAsRecipe1List.Items[i - 1];
      with meAsRecipe1 do
        begin
          Parent := ScrollBox1;
          Top := (i - 1) * 27 + 1 - ScrollBox1.VertScrollBar.Position;;
          Left := 180;
          Width := 40;
          Text := IntToStr(Round(pStorage.RecipeGrade1[FGrade.GradeNum]));
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
          OnKeyPress := meKeyPress;
          OnKeyDown := meKeyDown;
        end;

      meAsRecipe2 := GradesAsRecipe2List.Items[i - 1];
      with meAsRecipe2 do
        begin
          Parent := ScrollBox1;
          Top := (i - 1) * 27 + 1 - ScrollBox1.VertScrollBar.Position;;
          Left := 280;
          Width := 40;
          Text := IntToStr(Round(pStorage.RecipeGrade2[FGrade.GradeNum]));
          Font.Color := clBlack;
          Font.Size := 11;
          Font.Charset := 204;
          Font.Name := 'MS Sans Serif';
          Font.Style := [fsBold];
          OnKeyPress := meKeyPress;
          OnKeyDown := meKeyDown;
        end;
    end;
  meRecipe1Summ.Text := IntToStr(Round(pStorage.AssignTotal1));
  meRecipe2Summ.Text := IntToStr(Round(pStorage.AssignTotal2));
  if pStorage.RecipeNo = 1 then
    begin
      rbRecipe2.Checked := False;
      rbRecipe1.Checked := True
    end else
    begin
      rbRecipe1.Checked := False;
      rbRecipe2.Checked := True;
    end;
end;

procedure TRecipeManager.btSaveRecipeClick(Sender: TObject);
var
  i : byte;
  Summ1, Summ2 : single;
  AnyChange : boolean;
  meAsRecipe1 : TEdit;
  meAsRecipe2 : TEdit;
begin
  Summ1 := 0;
  Summ2 := 0;
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      meAsRecipe1 := GradesAsRecipe1List.Items[i - 1];
      Summ1 := Summ1 + StrToFloat(meAsRecipe1.Text);
      meAsRecipe2 := GradesAsRecipe2List.Items[i - 1];
      Summ2 := Summ2 + StrToFloat(meAsRecipe2.Text);
    end;
  if (Summ1 <> 100) or (Summ2 <> 100) then ShowMessage('Сумма не равна 100%')
    else if MessageDlg('Подтвердите запись' , mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        for i := 1 to pStorage.GradesCount do
          begin
            pStorage.RecipeGrade1[i] := 0;
            pStorage.RecipeGrade2[i] := 0;
          end;
        for i := 1 to pStorage.CoalGradesList.Count do
          begin
            meAsRecipe1 := GradesAsRecipe1List.Items[i - 1];
            meAsRecipe2 := GradesAsRecipe2List.Items[i - 1];
            FGrade := pStorage.CoalGradesList.Items[i - 1];
            pStorage.RecipeGrade1[FGrade.GradeNum] := StrToFloat(meAsRecipe1.Text);
            pStorage.RecipeGrade2[FGrade.GradeNum] := StrToFloat(meAsRecipe2.Text);
          end;
        pStorage.AssignTotal1 := StrToInt(meRecipe1Summ.Text);
        pStorage.AssignTotal2 := StrToInt(meRecipe2Summ.Text);
        AnyChange := False;
        if rbRecipe1.Checked then
          begin
            pStorage.RecipeNo := 1;
            AnyChange := AnyChange or (pStorage.CurrentAssignTotal <> pStorage.AssignTotal1);
            pStorage.CurrentAssignTotal := pStorage.AssignTotal1;
            for i := 1 to pStorage.GradesCount do
              begin
                AnyChange := AnyChange or (pStorage.CurrentRecipeGrade[i] <> pStorage.RecipeGrade1[i]);
                pStorage.CurrentRecipeGrade[i] := pStorage.RecipeGrade1[i];
              end;
          end else
          begin
            pStorage.RecipeNo := 2;
            AnyChange := AnyChange or (pStorage.CurrentAssignTotal <> pStorage.AssignTotal2);
            pStorage.CurrentAssignTotal := pStorage.AssignTotal2;
            for i := 1 to pStorage.GradesCount do
              begin
                AnyChange := AnyChange or (pStorage.CurrentRecipeGrade[i] <> pStorage.RecipeGrade2[i]);
                pStorage.CurrentRecipeGrade[i] := pStorage.RecipeGrade2[i];
              end;
          end;
        if AnyChange then pStorage.SaveCurrentRecipe;
        pStorage.UpdateRecipes;
        pStorage.SaveConfig;
      end;
end;

procedure TRecipeManager.SetGradesNamesToBatchers(Value : TList);
//Присвоение дозаторам наименований и цветов шихтогрупп по их номерам
var
  i, j : byte;
  Batch : TBatcher;
begin
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      Batch := Value.Items[i - 1];
      Batch.GrName := pStorage.GradeNames[Batch.Grade];
    end;
  for j := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[j - 1];
      for i := 1 to pStorage.MaxBatchCounter do
        begin
          Batch := Value.Items[i - 1];
          if Batch.Grade = FGrade.GradeNum then Batch.GradeColor := j;
        end;
    end;
end;

end.
