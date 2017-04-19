unit MainF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,OleCtrls,
  Buttons, Batcher, Grids, TeEngine, Series, TeeProcs,Chart, DBChart, DBGrids, DBCtrls,
  ExtCtrls, Menus, Db, DBTables, ComCtrls, Types, Storage,
  Mask, ToolEdit, RXSpin, RXCtrls, Report, ImgList, Math,
  MicroNetClient, WinCCClient, MMSystem, ComObj, shellapi, RecipeManager, CoalGrade;

type
  TWStationForm = class(TForm)
    OPCReadTimer: TTimer;
    AfterShowTimer: TTimer;
    MuteTimer: TTimer;
    StabileWorkTimer: TTimer;
    imgCoalReceive: TImage;
    imgCoalPaths: TImage;
    imgOpenStore: TImage;
    Label9: TLabel;
    imgDO1: TImage;
    imgDO2: TImage;
    Image6: TImage;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    shDO1: TShape;
    shDO2: TShape;
    BitBtn1: TBitBtn;
    Database1: TDatabase;
    Session1: TSession;
    Label1: TLabel;
    IdleTimer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure OPCReadTimerTimer(Sender: TObject);
    procedure BatchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AfterShowTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MuteTimerTimer(Sender: TObject);
    procedure StabileWorkTimerTimer(Sender: TObject);
    procedure sgGradesInput1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgGradesInput2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgGradesInput3DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgOpenStoreMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgCoalReceiveMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgDO1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDO2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDO1Click(Sender: TObject);
    procedure imgDO2Click(Sender: TObject);
    procedure imgCoalPathsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image6Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure IdleTimer2Timer(Sender: TObject);
  private
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
    procedure CalculateGrades(Value : byte);
    procedure SaveFilesFromResource;
  public
    procedure OPCRead;
    procedure Backup;
  end;

procedure MakeGradesTables;

const
  CanRedraw : boolean = True;

var
  WStationForm : TWStationForm;
  Batch : TBatcher;
  BatchList1 : TList;
  BatchList2 : TList;
  Storage1 : TStorage;
  Storage2 : TStorage;
  MicroNet : TMicroNetOPCClient;
  WinCC : TWinCCOPCClient;
  RecipeManager1 : TRecipeManager;
  RecipeManager2 : TRecipeManager;
  CurrentBatch : byte;
  CurrentDO : byte;
  Pr_Total, Weight, Pr_T1, Pr_T2 : single;
  CurrHour : byte;
  StartTime: TDateTime;
  BeginTime, EndTime : string;
  UpdateCounter : byte;
  CalibrationStep : byte;
  CalibrationArray : array[1..16] of boolean;
  AnyWorking1 : boolean;
  AnyWorking2 : boolean;
  DO2isIdle : boolean;
  StabileWork : boolean;
  PrDelay2 : array [1..45] of single;

implementation

uses
  Splash,     //Форма-заставка при запуске программы
  View,       //Форма просмотра графиков производительности
  Summ,       //Форма отчета об отклонениях
  Backup,     //Форма с процедурой архивации базы данных
  DO2,        //Мнемосхема ДО№1
  DO1,        //Мнемосхема ДО№2
  DO1DO2,     //Сводный экран дозировок
  BatchProp;  //Форма корректировки свойств дозатора

{$R *.DFM}

procedure TWStationForm.FormCreate(Sender: TObject);
var
  i, d : byte;
begin
  Height := 740;
  Width := 1024;
  Top := 0;
  Left := 0;

  //Создаем OPC-клиенты
  MicroNet := TMicroNetOPCClient.Create(Self);
  WinCC := TWinCCOPCClient.Create(Self);

  //Подключаемся к СУБД
  Session1.Active := True;
  Database1.Connected := True;

  //Создаем и инициализируем классы взаимодействия с СУБД
  Storage1 := TStorage.Create(Self);
  Storage1.Initialize(1);
  Storage2 := TStorage.Create(Self);
  Storage2.Initialize(2);

  //Создаем контейнеры объектов-дозаторов
  BatchList1 := TList.Create;
  BatchList2 := TList.Create;

  //Создаем файлы с изображениями, звуками и др.
  SaveFilesFromResource;

  //Создаем обеъекты - дозаторы ДО № 1
  for i := 1 to 14 do
    begin
      BatchList1.Add(TBatcher.Create(Self));
      Batch := BatchList1.Items[i - 1];
      with Batch do
        begin
          Parent := DO1Form;
          Num := i;
          DONum := 1;
          if i <= 7 then
            begin
              Top := 86 + 80;
              TabOrder := (i + 1) div 2;
              Left := (i - 1) * 145 + 3;
            end else
            begin
              Top := 264 + 130;
              TabOrder := i div 2 + 12;
              Left := (i - 8) * 145 + 3;
            end;
          OnClick := BatchClick;
          TabStop := True;
          Assigned := 0;
          State := Storage1.State[i];
          Conv2 := Storage1.Wrk[i];
          Grade := Storage1.Grades[i];
          Select := False;
          DO1DO2Form.clbAlarms1.Items.Add('Дозатор №' + IntToStr(i));
        end;
    end;

  //Создаем обеъекты - дозаторы ДО № 2
  for i := 1 to 16 do
    begin
      BatchList2.Add(TBatcher.Create(Self));
      Batch := BatchList2.Items[i - 1];
      with Batch do
        begin
          Parent:=DO2Form;
          Num := i;
          DONum := 2;
          if i in [1, 3, 5, 7, 9, 11, 13, 15] then
            begin
              Top := 86 + 80;
              TabOrder := (i + 1) div 2;
            end else
            begin
              Top := 264 + 130;
              TabOrder := i div 2 + 12;
            end;
          Left := ((i + 1) div 2 - 1) * 127 + 1;
          OnClick := BatchClick;
          TabStop := True;
          Assigned := 0;
          State := Storage2.State[i];
          Conv2 := Storage2.Wrk[i];
          Grade := Storage2.Grades[i];
          Select := False;
          DO1DO2Form.clbAlarms2.Items.Add('Дозатор №' + IntToStr(i));
          if i = 2 then DO1DO2Form.clbAlarms2.EnabledItem[i - 1] := False;
        end;
    end;

  //Создаем и инициализируем менеджер шихтовок ДО № 1
  RecipeManager1 := TRecipeManager.Create(Self);
  RecipeManager1.Parent := DO1DO2Form.SheetGrades1;
  RecipeManager1.Top := 1;
  RecipeManager1.Left := 1;
  RecipeManager1.Storage := Storage1;
  RecipeManager1.CreateGrades;
  RecipeManager1.Batch := BatchList1;
  RecipeManager1.SetGradesNamesToBatchers(BatchList1);

  //Создаем и инициализируем менеджер шихтовок ДО № 2
  RecipeManager2 := TRecipeManager.Create(Self);
  RecipeManager2.Parent := DO1DO2Form.SheetGrades2;
  RecipeManager2.Top := 1;
  RecipeManager2.Left := 1;
  RecipeManager2.Storage := Storage2;
  RecipeManager2.CreateGrades;
  RecipeManager2.Batch := BatchList2;
  RecipeManager2.SetGradesNamesToBatchers(BatchList2);

  DO1DO2Form.MakeTrends(1);
  DO1DO2Form.MakeTrends(2);
  DO1DO2Form.RedrawTrends(1);
  DO1DO2Form.RedrawTrends(2);

  MakeGradesTables;

  BatchPropForm.CreateGradesList;

  for d := 1 to 35 do PrDelay2[d] := 0;

  UpdateCounter := 1;

  StabileWork := False;
end;

procedure TWStationForm.OPCReadTimerTimer(Sender: TObject);
begin
  OPCRead;
end;

procedure TWStationForm.BatchClick(Sender: TObject);
begin
  CurrentBatch := (Sender as TBatcher).Num;
  CurrentDO := (Sender as TBatcher).DONum;
  BatchPropForm.lbBatN.Caption := IntToStr(CurrentBatch);
  if CurrentDO = 1 then
    begin
      Batch := BatchList1.Items[CurrentBatch - 1];
      DO1Form.DeSelectAll;
    end else
    begin
      Batch := BatchList2.Items[CurrentBatch - 1];
      DO2Form.DeSelectAll;
    end;
  Batch.Select := True;
  BatchPropForm.lbCurrent.Caption := Format('%3.1f', [Batch.ProdTh]);
  BatchPropForm.lbRecommend.Caption := Format('%3.1f', [Batch.Recommend]);
  BatchPropForm.cbPropGrade.ItemIndex := Batch.Grade;
  if Batch.State = stNotMnt then BatchPropForm.cbMount.Checked := False else BatchPropForm.cbMount.Checked := True;
  BatchPropForm.Show;
end;

procedure TWStationForm.sgGradesThDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
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
          if (ACol = FGrade.GradeNum) and (ARow = 0) then
            begin
              if AnyWorking2 and (Abs(FGrade.AssignTh - FGrade.ProdTh) > 0.03 * FGrade.AssignTh) then
                Canvas.Font.Color := clRed else Canvas.Font.Color := clNavy;
            end;
        end;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TWStationForm.FormDestroy(Sender: TObject);
begin
  Database1.Connected := False;
end;

procedure TWStationForm.OPCRead;
const
  AlarmFlag : boolean = False;
var
  i, d : byte;
  NHour, NMin, NSec, NMSec : word;
begin
  OPCReadTimer.Enabled := False;
  Pr_Total := 0;
  Weight := 0;
  Pr_T1 := 0;
  Pr_T2 := 0;
  for i := 1 to 14 do
    begin
      Batch := BatchList1.Items[i - 1];
      Batch.State := Batch.State; //!!!
      if i <> 2 then Batch.Weight := 0;
      if i = 9 then Batch.Conv2 := True;
      if (CurrentDO = 1) and (i = CurrentBatch) then BatchPropForm.lbRecommend.Caption := Format('%3.1f', [Batch.Recommend]);
    end;
  CalculateGrades(1);
  CalculateGrades(2);

  if WinCC.Connected and (not WinCC.AssemblyConv) and (not IdleTimer2.Enabled) then IdleTimer2.Enabled := True;
  if (not WinCC.Connected) or WinCC.AssemblyConv then
    begin
      IdleTimer2.Enabled := False;
      DO2isIdle := False;
    end;
  AnyWorking2 := False;
  if not DO2isIdle then
    begin
      for i := 1 to 16 do
        begin
          Batch := BatchList2.Items[i - 1];
          if Batch.State <> stNotMnt then
            begin
              Storage2.State[i] := MicroNet.State[i];
              if Batch.State <> Storage2.State[i] then AlarmFlag := True;
              Batch.State := Storage2.State[i];
              if (CurrentDO = 2) and (i = CurrentBatch) then BatchPropForm.lbRecommend.Caption := Format('%3.1f', [Batch.Recommend]);
              if Batch.State = stOk then
                begin
                  if (CurrentDO = 2) and (i = CurrentBatch) then BatchPropForm.lbCurrent.Caption := Format('%3.1f', [MicroNet.Prod[i]]);
                  Batch.Assigned := WinCC.Assigned[i];
                  Batch.ProdTh := MicroNet.Average[i];
                  Batch.Summ := MicroNet.Summ[i];
                  Batch.Time := MicroNet.WorkTime[i];
                  Batch.Conv1 := WinCC.Conv1[i];
                  Batch.Weight := MicroNet.Weight[i];
                  if MicroNet.Conv2[i] then Storage2.Wrk[i] := True else Storage2.Wrk[i] := False;
                  if Batch.Conv2 <> Storage2.Wrk[i] then AlarmFlag := True;
                  Batch.Conv2 := Storage2.Wrk[i];
                  AnyWorking2 := AnyWorking2 or Batch.Conv2;
                  Pr_Total := Pr_Total + Batch.ProdTh;
                  Weight := Weight + Batch.Summ;
                  if i in [1, 3, 5, 7, 9, 11, 13, 15] then
                    Pr_T1 := Pr_T1 + Batch.ProdTh else Pr_T2 := Pr_T2 + Batch.ProdTh;
                    if (((not WinCC.Connected) and Batch.Conv2 and (Batch.ProdTh < 10)) or
                      (WinCC.Connected and Batch.Conv1 and Batch.Conv2 and (Batch.ProdTh < 10))) and not MuteTimer.Enabled then
                      begin
                        PlaySound('sound1.wav', 0, SND_ASYNC);
                        MuteTimer.Enabled := True;
                      end;
                end;
            end;
        end;

      DO2Form.btCalibrAll2.Enabled := not AnyWorking2;
//      DO1DO2Form.btMakeTrends2.Enabled := not AnyWorking2;
//      DO1DO2Form.btMakeReport2.Enabled := not AnyWorking2;

      if Pr_Total = 0 then Pr_Total := 0.001;
      DO1DO2Form.lbPrTot12.Caption := Format('%3.1f', [Pr_T1]);
      DO1DO2Form.lbPrTot22.Caption := Format('%3.1f', [Pr_T2]);
      DO1DO2Form.lbPrTotal2.Caption := Format('%3.1f', [Pr_Total]);
      DO1DO2Form.lbWeight2.Caption := Format('%8.1f', [Weight]);
      DO1DO2Form.lbWeightU2.Caption := Format('%8.1f', [MicroNet.Summ[17]]);
      DO1DO2Form.lbPrU2.Caption := Format('%3.1f', [MicroNet.Average[17]]);

      DO2Form.lbPrTot1.Caption := Format('%3.1f', [Pr_T1]);
      DO2Form.lbPrTot2.Caption := Format('%3.1f', [Pr_T2]);
      DO2Form.lbPrTotal.Caption := Format('%3.1f', [Pr_Total]);
      DO2Form.lbWeight.Caption := Format('%8.1f', [Weight]);
      DO2Form.lbWeightU.Caption := Format('%8.1f', [MicroNet.Summ[17]]);
      DO2Form.lbPrU.Caption := Format('%3.1f', [MicroNet.Average[17]]);

      DO2Form.lbPrDelay.Caption := Format('%3.1f', [PrDelay2[1]]);
      for d := 1 to 34 do PrDelay2[d] := PrDelay2[d + 1];
      PrDelay2[35] := Pr_Total;

      if UpdateCounter in [3, 8, 14] then Storage2.SaveBat(BatchList2,
        MicroNet.Average[17], 100, MicroNet.Summ[17], MicroNet.WorkTime[17]);
      if UpdateCounter = 2 then
        begin
          if CanRedraw then
            begin
              CurrHour := StrToInt(FormatDateTime('hh', Now));
              DO1DO2Form.RedrawTrends(2);
            end;
          CanRedraw := True;
        end;
      if UpdateCounter < 16 then UpdateCounter := UpdateCounter + 1 else
        begin
          Storage2.SaveGrd;
          UpdateCounter := 1;
        end;
      if AlarmFlag then
        begin
          Storage2.SaveConfig;
          AlarmFlag := False;
        end;

      if AnyWorking2 then StabileWorkTimer.Enabled := True else
        begin
          StabileWork := False;
          StabileWorkTimer.Enabled := False;
        end;
    end;
  Application.ProcessMessages;
  DecodeTime(Now, NHour, NMin, NSec, NMSec);
  if (FormatDateTime('dddd', Now) = 'воскресенье') and (NHour = 10) and (NMin = 0) then Backup;
  if (((NHour = 7) and (NMin = 59)) or ((NHour = 19) and (NMin = 59))) and (NSec > 50) then
    begin
      DO2Form.ResetAllSumm;
      MicroNet.Summ[17] := 0;
    end;
  OPCReadTimer.Enabled := True;
end;

procedure TWStationForm.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
  OPCReadTimer.Enabled := False;
  MicroNet.Connected := False;
  WinCC.Connected := False;
end;

procedure TWStationForm.AfterShowTimerTimer(Sender: TObject);
begin
  AfterShowTimer.Enabled := False;
  SplashForm.Hide;
  SplashForm.Free;
end;

procedure TWStationForm.FormShow(Sender: TObject);
begin
  SplashForm.Position := 25;        //Форма создана, установлена связь с СУБД
  MicroNet.Connected := True;
  SplashForm.Position := 50;        //Установлена связь с MicroNet.OPCServer-ом
  CurrHour := StrToInt(FormatDateTime('hh', Now));

  SplashForm.Position := 75;        //Созданы серии для шихтогрупп, выбраны данные
  WinCC.Connected := True;
  OPCReadTimer.Enabled := True;
  SplashForm.Position := 100;       //Установлена связь с OPCServer.WinCC
  AfterShowTimer.Enabled := True;
end;

procedure TWStationForm.CalculateGrades(Value : byte);
var
  i, j : byte;
  DeltaSumm : single;
  AnyDiffer1 : boolean;
  AnyDiffer2 : boolean;  
  pStorage : ^TStorage;
begin
  if Value = 1 then pStorage := @Storage1 else pStorage := @Storage2;

  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[i - 1];
      FGrade.AssignPc := 0;
      FGrade.AssignTh := 0;
      FGrade.ProdPc := 0;
      FGrade.ProdTh := 0;
      FGrade.Summ := 0;
    end;
  for i := 1 to pStorage.MaxBatchCounter do
    begin
      if Value = 1 then Batch := BatchList1.Items[i - 1] else Batch := BatchList2.Items[i - 1];
      if (Batch.Grade <> 0) then
        begin
          for j := 1 to pStorage.CoalGradesList.Count do
            begin
              FGrade := pStorage.CoalGradesList.Items[j - 1];
              if FGrade.GradeNum = Batch.Grade then
                begin
                  FGrade.AssignPc := pStorage.CurrentRecipeGrade[FGrade.GradeNum];
                  FGrade.AssignTh := pStorage.CurrentAssignTotal * FGrade.AssignPc / 100;
                  FGrade.ProdTh := FGrade.ProdTh + Batch.ProdTh;
                  FGrade.Summ := FGrade.Summ + Batch.Summ;
                end;
            end;
        end;
    end;
  DeltaSumm := 0;
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[i - 1];
      FGrade.CalcDelta;
      DeltaSumm := DeltaSumm + FGrade.Delta;
    end;
  AnyDiffer1 := False;
  AnyDiffer2 := False;
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[i - 1];
      if Value = 1 then
        begin
          DO1Form.sgGradesTh.Cells[i, 0] := DO1Form.sgGradesTh.Cells[i, 0];
          DO1Form.sgGradesTh.Cells[i, 1] := Format('%2.1f', [FGrade.AssignTh]);
          DO1Form.sgGradesTh.Cells[i, 2] := Format('%2.1f', [FGrade.ProdTh]);
          DO1DO2Form.sgGradesPc1.Cells[i, 0] := DO1DO2Form.sgGradesPc1.Cells[i, 0];
          if DeltaSumm > 0 then FGrade.ProdPc := FGrade.Delta * 100 / DeltaSumm;
          DO1DO2Form.sgGradesPc1.Cells[i, 1] := Format('%2.1f', [FGrade.AssignPc]);
          DO1DO2Form.sgGradesPc1.Cells[i, 2] := Format('%2.1f', [FGrade.ProdPc]);
          if Abs(FGrade.ProdPc - FGrade.AssignPc) > 3 then AnyDiffer1 := True;
        end else
        begin
          DO2Form.sgGradesTh.Cells[i, 0] := DO2Form.sgGradesTh.Cells[i, 0];
          DO2Form.sgGradesTh.Cells[i, 1] := Format('%2.1f', [FGrade.AssignTh]);
          DO2Form.sgGradesTh.Cells[i, 2] := Format('%2.1f', [FGrade.ProdTh]);
          DO1DO2Form.sgGradesPc2.Cells[i, 0] := DO1DO2Form.sgGradesPc2.Cells[i, 0];
          if DeltaSumm > 0 then FGrade.ProdPc := FGrade.Delta * 100 / DeltaSumm;
          DO1DO2Form.sgGradesPc2.Cells[i, 1] := Format('%2.1f', [FGrade.AssignPc]);
          DO1DO2Form.sgGradesPc2.Cells[i, 2] := Format('%2.1f', [FGrade.ProdPc]);
          if Abs(FGrade.ProdPc - FGrade.AssignPc) > 3 then AnyDiffer2 := True;
        end;
    end;
  if ((AnyDiffer1 and AnyWorking1) or (AnyDiffer2 and AnyWorking2)) and not MuteTimer.Enabled then
    begin
      PlaySound('sound2.wav', 0, SND_ASYNC);
      MuteTimer.Enabled := True;
    end;
  for i := 1 to 16 do
     begin
       Batch := BatchList2.Items[i - 1];
       Batch.Enable := (Batch.State <> stNotMnt) and WinCC.Enable[i];
     end;
  RecipeManager2.Batch := BatchList2;
  for i := 1 to 16 do
    begin
      Batch := BatchList2.Items[i - 1];
      WinCC.Recommend[i] := Batch.Recommend;
      WinCC.Enable[i] := Batch.Enable;
    end;
end;

procedure TWStationForm.Backup;
begin
  if FileExists('c:\Program Files\WinRAR\RAR.exe') then
    begin
      BackupForm := nil;
        try
          BackupForm := TBackupForm.Create(Self);
          OPCReadTimer.Enabled := False;      //Отключить обновление данных
          Database1.Connected := False;
          BackupForm.ShowModal;
          Database1.Connected := True;
          OPCReadTimer.Enabled := True;
        finally
          if Assigned(BackupForm) then BackupForm.Release;
        end;
    end;
end;

procedure TWStationForm.MuteTimerTimer(Sender: TObject);
begin
  if StabileWork then MuteTimer.Enabled := False;
end;

procedure TWStationForm.StabileWorkTimerTimer(Sender: TObject);
begin
  StabileWorkTimer.Enabled := False;
  StabileWork := True;
end;

procedure TWStationForm.sgGradesInput1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
    begin
      Canvas.Font.Color := clNavy;
      Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TWStationForm.sgGradesInput2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
    begin
      Canvas.Font.Color := clNavy;
      Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TWStationForm.sgGradesInput3DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
    begin
      Canvas.Font.Color := clNavy;
      Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TWStationForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  shDO1.Visible := False;
  shDO2.Visible := False;
end;

procedure TWStationForm.imgOpenStoreMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  shDO1.Visible := False;
  shDO2.Visible := False;
end;

procedure TWStationForm.imgCoalReceiveMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  shDO1.Visible := False;
  shDO2.Visible := False;
end;

procedure TWStationForm.imgDO1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  shDO1.Visible := True;
  shDO2.Visible := False;
end;

procedure TWStationForm.imgDO2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  shDO1.Visible := False;
  shDO2.Visible := True;      
end;

procedure TWStationForm.Image6MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  shDO1.Visible := True;
  shDO2.Visible := True;
end;

procedure TWStationForm.imgDO1Click(Sender: TObject);
begin
  DO1Form.Show;
end;

procedure TWStationForm.imgDO2Click(Sender: TObject);
begin
  DO2Form.Show;
end;

procedure TWStationForm.imgCoalPathsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  shDO1.Visible := False;
  shDO2.Visible := False;
end;

procedure TWStationForm.Image6Click(Sender: TObject);
begin
  DO1DO2Form.Show;
end;

procedure TWStationForm.BitBtn1Click(Sender: TObject);
begin
  if MessageDlg('Завершить работу программы?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then Close;
end;

procedure TWStationForm.SaveFilesFromResource;
var
  Res : TResourceStream;
begin
  if not FileExists('bat.wmf') then
    begin
      Res := TResourceStream.Create(Hinstance, 'BAT', Pchar('WMFFILES'));
      Res.SaveToFile('bat.wmf');
      Res.Free;
    end;
  if not FileExists('conv1_on.wmf') then
    begin
      Res := TResourceStream.Create(Hinstance, 'CONV1_ON', Pchar('WMFFILES'));
      Res.SaveToFile('conv1_on.wmf');
      Res.Free;
    end;
  if not FileExists('conv1_off.wmf') then
    begin
      Res := TResourceStream.Create(Hinstance, 'CONV1_OFF', Pchar('WMFFILES'));
      Res.SaveToFile('conv1_off.wmf');
      Res.Free;
    end;
  if not FileExists('conv2_on.wmf') then
    begin
      Res := TResourceStream.Create(Hinstance, 'CONV2_ON', Pchar('WMFFILES'));
      Res.SaveToFile('conv2_on.wmf');
      Res.Free;
    end;
  if not FileExists('conv2_off.wmf') then
    begin
      Res := TResourceStream.Create(Hinstance, 'CONV2_OFF', Pchar('WMFFILES'));
      Res.SaveToFile('conv2_off.wmf');
      Res.Free;
    end;
  if not FileExists('coal.wmf') then
    begin
      Res := TResourceStream.Create(Hinstance, 'COAL', Pchar('WMFFILES'));
      Res.SaveToFile('coal.wmf');
      Res.Free;
    end;
  if not FileExists('sound1.wav') then
    begin
      Res := TResourceStream.Create(Hinstance, 'SOUND1', Pchar('WAVFILES'));
      Res.SaveToFile('sound1.wav');
      Res.Free;
    end;
  if not FileExists('sound2.wav') then
    begin
      Res := TResourceStream.Create(Hinstance, 'SOUND2', Pchar('WAVFILES'));
      Res.SaveToFile('sound2.wav');
      Res.Free;
    end;
end;

procedure MakeGradesTables;
var
  i : byte;
  FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
begin
  DO1Form.sgGradesTh.ColCount := Storage1.CoalGradesList.Count + 1;
  DO2Form.sgGradesTh.ColCount := Storage2.CoalGradesList.Count + 1;
  DO1DO2Form.sgGradesPc1.ColCount := Storage1.CoalGradesList.Count + 1;
  DO1DO2Form.sgGradesPc2.ColCount := Storage2.CoalGradesList.Count + 1;

  for i := 1 to Storage1.CoalGradesList.Count do
    begin
      DO1Form.sgGradesTh.ColWidths[i] := (DO1Form.sgGradesTh.Width - 149) div Storage1.CoalGradesList.Count;
      DO1DO2Form.sgGradesPc1.ColWidths[i] := (DO1DO2Form.sgGradesPc1.Width - 149) div Storage1.CoalGradesList.Count;
    end;
  for i := 1 to Storage2.CoalGradesList.Count do
    begin
      DO2Form.sgGradesTh.ColWidths[i] := (DO2Form.sgGradesTh.Width - 149) div Storage2.CoalGradesList.Count;
      DO1DO2Form.sgGradesPc2.ColWidths[i] := (DO1DO2Form.sgGradesPc2.Width - 149) div Storage2.CoalGradesList.Count;
    end;

  for i := 1 to Storage1.CoalGradesList.Count do
    begin
      FGrade := Storage1.CoalGradesList.Items[i - 1];
      DO1Form.sgGradesTh.Cells[i, 0] := FGrade.GradeName;
      DO1DO2Form.sgGradesPc1.Cells[i, 0] := FGrade.GradeName;
    end;
  for i := 1 to Storage2.CoalGradesList.Count do
    begin
      FGrade := Storage2.CoalGradesList.Items[i - 1];
      DO2Form.sgGradesTh.Cells[i, 0] := FGrade.GradeName;
      DO1DO2Form.sgGradesPc2.Cells[i, 0] := FGrade.GradeName;
    end;
end;

procedure TWStationForm.IdleTimer2Timer(Sender: TObject);
begin
  DO2isIdle := True;
end;

end.





