procedure TDO1DO2Form.MakeBatchReport(DONum : byte; BeginTime, EndTime : TDateTime);
var
  GradeBeginTime, GradeEndTime : TDateTime;
  AssignBeginTime, AssignEndTime : TDateTime;
  RExcel, RWorkBook, RWorkSheet: Variant;
  RRange: Variant;
  Res : TResourceStream;
  i, j : byte;
  RecordsCounter : byte;
  StoredBatchGrade : byte;
  StoredBatchAssign : single;
  pStorage : ^TStorage;
begin
  if DONum = 1 then pStorage := @Storage1 else pStorage := @Storage2;
  Res := TResourceStream.Create(Hinstance, 'TEMPLATE2', Pchar('XLSFILES'));
  Res.SaveToFile('template2.xls');
  Res.Free;
  if FileExists('c:\UPC\WStation\report2.xls') then DeleteFile('c:\UPC\WStation\report2.xls');
  try
    RExcel := CreateOLEObject('Excel.Application'); // Вызываем сервер
    RWorkBook := RExcel.WorkBooks.Open('c:\UPC\WStation\template2.xls');
//    RWorkBook := RExcel.WorkBooks.Add;
    RWorkSheet := RWorkBook.ActiveSheet; // Выбираем активный лист

    RRange := RWorkSheet.Cells[1, 1];
    RRange.Value := 'Отчет о работе дозаторов за период:';
    RRange := RWorkSheet.Cells[2, 1];
    RRange.Value := 'с ' + FormatDateTime('dd/mm/yyyy hh:mm', BeginTime) +
    ' по ' + FormatDateTime('dd/mm/yyyy hh:mm', EndTime);
    RRange := RWorkSheet.Cells[3, 1];
    RRange.Value := 'Дозатор';
    RRange := RWorkSheet.Cells[3, 2];
    RRange.Value := 'Шихтогруппа';
    RRange := RWorkSheet.Cells[3, 3];
    RRange.Value := 'Задание, т/ч';
    RRange := RWorkSheet.Cells[3, 4];
    RRange.Value := 'Время работы, ч';
    RRange := RWorkSheet.Cells[3, 5];
    RRange.Value := 'Расчетный вес, т';
    RRange := RWorkSheet.Cells[3, 6];
    RRange.Value := 'Фактический вес, т';
    RRange := RWorkSheet.Cells[3, 7];
    RRange.Value := 'Отклонение, %';

    RecordsCounter := 0;

    for i := 1 to pStorage.MaxBatchCounter do
      begin
        RecordsCounter := RecordsCounter + 1;
        RRange := RWorkSheet.Cells[RecordsCounter + 3, 1];
        RRange.Value := IntToStr(i);
        RRange := RWorkSheet.Cells[RecordsCounter + 3, 2];
        RRange.Value := '-----';
        GradeBeginTime := BeginTime;
        repeat
          GradeEndTime := pStorage.ViewStoredConfig(i, GradeBeginTime, EndTime, StoredBatchGrade);
          RRange := RWorkSheet.Cells[RecordsCounter + 3, 2];
          RRange.Value := pStorage.GradeNames[StoredBatchGrade];
          AssignBeginTime := GradeBeginTime;
            repeat
              AssignEndTime := pStorage.ViewStoredBatchers(i, AssignBeginTime, GradeEndTime, StoredBatchAssign);
              RRange := RWorkSheet.Cells[RecordsCounter + 3, 3];
              RRange.Value := Format('%8.1f', [StoredBatchAssign]);
              RRange := RWorkSheet.Cells[RecordsCounter + 3, 4];
              RRange.Value := Format('%8.1f', [pStorage.CalcBatchTime(i, AssignBeginTime, AssignEndTime) / 60]);
              RRange := RWorkSheet.Cells[RecordsCounter + 3, 6];
              RRange.Value := Format('%8.1f', [pStorage.CalcBatchSumm(i, AssignBeginTime, AssignEndTime)]);
              AssignBeginTime := AssignEndTime;
              Inc(RecordsCounter);
            until (GradeEndTime - AssignEndTime < EncodeTime(0, 1, 0, 0));
          GradeBeginTime := GradeEndTime;
        until (EndTime - GradeEndTime < EncodeTime(0, 1, 0, 0));
      end;

    for j := 1 to 7 do
      begin
        for i := 3 to RecordsCounter + 3 do
          begin
            RRange := RWorkSheet.Cells[i, j];
            RRange.BorderAround(1);
          end;
      end;

    RWorkBook.Protect('123');
    RWorkBook.SaveAs('c:\UPC\WStation\report2.xls');
    RExcel.Visible := True; // Делаем Excel видимым
  finally
    RExcel := UnAssigned;
  end;
end;


procedure TDO1DO2Form.MakeBatchReport(DONum : byte; BeginTime, EndTime : TDateTime);
var
  GradeBeginTime, GradeEndTime : TDateTime;
  AssignBeginTime, AssignEndTime : TDateTime;
  RExcel, RWorkBook, RWorkSheet: Variant;
  RRange: Variant;
  Res : TResourceStream;
  i, j : byte;
  RecordsCounter : byte;
  StoredBatchGrade : byte;
  StoredBatchAssign : single;
  pStorage : ^TStorage;
begin
  if DONum = 1 then pStorage := @Storage1 else pStorage := @Storage2;
  Res := TResourceStream.Create(Hinstance, 'TEMPLATE2', Pchar('XLSFILES'));
  Res.SaveToFile('template2.xls');
  Res.Free;
  if FileExists('c:\UPC\WStation\report2.xls') then DeleteFile('c:\UPC\WStation\report2.xls');
  try
    RExcel := CreateOLEObject('Excel.Application'); // Вызываем сервер
    RWorkBook := RExcel.WorkBooks.Open('c:\UPC\WStation\template2.xls');
//    RWorkBook := RExcel.WorkBooks.Add;
    RWorkSheet := RWorkBook.ActiveSheet; // Выбираем активный лист

    RRange := RWorkSheet.Cells[1, 1];
    RRange.Value := 'Отчет о работе дозаторов за период:';
    RRange := RWorkSheet.Cells[2, 1];
    RRange.Value := 'с ' + FormatDateTime('dd/mm/yyyy hh:mm', BeginTime) +
    ' по ' + FormatDateTime('dd/mm/yyyy hh:mm', EndTime);
    RRange := RWorkSheet.Cells[3, 1];
    RRange.Value := 'Дозатор';
    RRange := RWorkSheet.Cells[3, 2];
    RRange.Value := 'Шихтогруппа';
    RRange := RWorkSheet.Cells[3, 3];
    RRange.Value := 'Задание, т/ч';
    RRange := RWorkSheet.Cells[3, 4];
    RRange.Value := 'Время работы, ч';
    RRange := RWorkSheet.Cells[3, 5];
    RRange.Value := 'Расчетный вес, т';
    RRange := RWorkSheet.Cells[3, 6];
    RRange.Value := 'Фактический вес, т';
    RRange := RWorkSheet.Cells[3, 7];
    RRange.Value := 'Отклонение, %';

    RecordsCounter := 0;

    for i := 1 to pStorage.MaxBatchCounter do
      begin
        RecordsCounter := RecordsCounter + 1;
        RRange := RWorkSheet.Cells[RecordsCounter + 3, 1];
        RRange.Value := IntToStr(i);
        RRange := RWorkSheet.Cells[RecordsCounter + 3, 2];
        RRange.Value := '-----';
        GradeBeginTime := BeginTime;
        repeat
          GradeEndTime := pStorage.ViewStoredConfig(i, GradeBeginTime, EndTime, StoredBatchGrade);
          RRange := RWorkSheet.Cells[RecordsCounter + 3, 2];
          RRange.Value := pStorage.GradeNames[StoredBatchGrade];
          AssignBeginTime := GradeBeginTime;
            repeat
              AssignEndTime := pStorage.ViewStoredBatchers(i, AssignBeginTime, GradeEndTime, StoredBatchAssign);
              RRange := RWorkSheet.Cells[RecordsCounter + 3, 3];
              RRange.Value := Format('%8.1f', [StoredBatchAssign]);
              RRange := RWorkSheet.Cells[RecordsCounter + 3, 4];
              RRange.Value := Format('%8.1f', [pStorage.CalcBatchTime(i, AssignBeginTime, AssignEndTime) / 60]);
              RRange := RWorkSheet.Cells[RecordsCounter + 3, 6];
              RRange.Value := Format('%8.1f', [pStorage.CalcBatchSumm(i, AssignBeginTime, AssignEndTime)]);
              AssignBeginTime := AssignEndTime;
              Inc(RecordsCounter);
            until (GradeEndTime - AssignEndTime < EncodeTime(0, 1, 0, 0));
          GradeBeginTime := GradeEndTime;
        until (EndTime - GradeEndTime < EncodeTime(0, 1, 0, 0));
      end;

    for j := 1 to 7 do
      begin
        for i := 3 to RecordsCounter + 3 do
          begin
            RRange := RWorkSheet.Cells[i, j];
            RRange.BorderAround(1);
          end;
      end;

    RWorkBook.Protect('123');
    RWorkBook.SaveAs('c:\UPC\WStation\report2.xls');
    RExcel.Visible := True; // Делаем Excel видимым
  finally
    RExcel := UnAssigned;
  end;
end;


