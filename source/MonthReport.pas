procedure TDO1DO2Form.MakeMonthReport;
var
  ObjEnum, Count : byte;
  BeginTime, EndTime, RecipeBeginTime, RecipeEndTime : TDateTime;
  Summ, AddedSumm, ConvSumm : single;
  i, MaxDay, TargetDay, TargetYear, TargetMonth : word;
  RExcel, RWorkBook, RWorkSheet: Variant;
  RRange: Variant;
  Res : TResourceStream;
  RecordsCounter : byte;
  GradesSummArray : array of single;
  ItemsCount : byte;
  FGrade : TCoalGrade;                        //Экземпляр шихтогруппы
  PrintingObjects : TList;                    //Контейнер объектов TCoalGrade
begin
  Res := TResourceStream.Create(Hinstance, 'TEMPLATE', Pchar('XLSFILES'));
  Res.SaveToFile('template.xls');
  Res.Free;
  if FileExists('c:\UPC\WStation\report.xls') then DeleteFile('c:\UPC\WStation\report.xls');
  try
    RExcel := CreateOLEObject('Excel.Application'); // Вызываем сервер
    RWorkBook := RExcel.WorkBooks.Open('c:\UPC\WStation\template.xls');
//    RWorkBook := RExcel.WorkBooks.Add;
    RWorkSheet := RWorkBook.ActiveSheet; // Выбираем активный лист
    DecodeDate(deReportDate2.Date, TargetYear, TargetMonth, TargetDay);
    MaxDay := MonthDays[IsLeapYear(TargetYear), TargetMonth];
    RRange := RWorkSheet.Cells[1, 1];
    RRange.Value := 'Отчет о количестве угольных концентратов, поданных на угольные башни №3 и №4 за:';
    RRange.Font.Bold := True; // Делаем жирным
    RRange.Font.Name := 'Times New Roman Cyr';
    RRange := RWorkSheet.Cells[2, 1];
    RRange.Value := rbMonth2.Caption;
    RRange.Font.Bold := True; // Делаем жирным
    RRange.Font.Name := 'Times New Roman Cyr';

    RRange := RWorkSheet.Cells[3, 1];
    RRange.Value := 'День';

    BeginTime := EncodeDate(TargetYear, TargetMonth, 1) + StrToTime('00:00:01');
    EndTime := EncodeDate(TargetYear, TargetMonth, MaxDay) + StrToTime('23:59:59');
    PrintingObjects := TList.Create;
    //Отбор шихтогрупп для отчета (те, которые были в силосах)
    for ObjEnum := 1 to Storage2.GradesCount do
      begin
        if Storage2.GradeWasLoaded(ObjEnum, BeginTime, EndTime) then
          begin
            FGrade := TCoalGrade.Create();
            PrintingObjects.Add(FGrade);
            FGrade.GradeNum := ObjEnum;
            FGrade.GradeName := Storage2.GradeNames[ObjEnum];
          end;
      end;
    SetLength(GradesSummArray, Storage2.GradesCount + 1);

    ItemsCount := 0;
    for ObjEnum := 1 to PrintingObjects.Count do
      begin
        FGrade := PrintingObjects.Items[ObjEnum - 1];
        ItemsCount := ItemsCount + 1;
        RRange := RWorkSheet.Cells[3, ItemsCount * 3 + 3];
        RRange.Value := FGrade.GradeName;
        RRange.Font.Bold := True; // Делаем жирным
        RRange.Font.Name := 'Times New Roman Cyr';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 3];
        RRange.Value := 'Масса';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 3];
        RRange.Value := '[тн]';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 4];
        RRange.Value := 'Задано';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 4];
        RRange.Value := '[%]';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 5];
        RRange.Value := 'Факт';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 5];
        RRange.Value := '[%]';
        GradesSummArray[ObjEnum] := 0;
      end;

    AddedSumm := 0;
    RecordsCounter := 1;
    for i := 1 to MaxDay do
      begin
        BeginTime := EncodeDate(TargetYear, TargetMonth, i) + StrToTime('00:00:01');
        EndTime := EncodeDate(TargetYear, TargetMonth, i) + StrToTime('23:59:59');
        if EndTime < Now then
          begin
            RRange := RWorkSheet.Cells[RecordsCounter + 5, 1];
            RRange.Value := Format('%d', [i]);
            ItemsCount := 0;
            for ObjEnum := 1 to PrintingObjects.Count do
              begin
                FGrade := PrintingObjects.Items[ObjEnum - 1];
                ItemsCount := ItemsCount + 1;
                Summ := Storage2.CalcGradeSumm(FGrade.GradeNum, BeginTime, EndTime);

                RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 3];
                RRange.Value := Format('%8.1f', [Summ]);
                RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                RRange.Value := Format('%8.1f', [Storage2.StoredAssignTotal]);

                GradesSummArray[ObjEnum] := GradesSummArray[ObjEnum] + Summ;
                if Summ <> 0 then
                  begin
                    RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 4];
                    RRange.Value := Format('%8.1f', [Storage2.StoredRecipeGrade[FGrade.GradeNum]]);
                  end;
              end;

            ConvSumm := Storage2.CalcConvSumm(BeginTime, EndTime);
            RRange := RWorkSheet.Cells[RecordsCounter + 5, 2];
            RRange.Value := Format('%8.1f', [ConvSumm]);
            AddedSumm := AddedSumm + ConvSumm;

            RRange := RWorkSheet.Cells[RecordsCounter + 5, 3];
            RRange.Value := Format('%8.1f', [AddedSumm]);

            RecipeEndTime := Storage2.ViewStoredRecipe(BeginTime, EndTime);
            if RecipeEndTime <> EndTime then
              begin
                for ObjEnum := 1 to PrintingObjects.Count do
                  begin
                    RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                    RRange.Value := '0';

                    RRange := RWorkSheet.Cells[RecordsCounter + 5, ObjEnum * 3 + 4];
                    RRange.Value := '0';
                    RRange := RWorkSheet.Cells[RecordsCounter + 5, ObjEnum * 3 + 5];
                    RRange.Value := '0';
                  end;
                RecordsCounter := RecordsCounter + 1;
                RecipeBeginTime := BeginTime;
                repeat
                  RecipeEndTime := Storage2.ViewStoredRecipe(RecipeBeginTime, EndTime);
                  ItemsCount := 0;
                  for ObjEnum := 1 to PrintingObjects.Count do
                    begin
                      FGrade := PrintingObjects.Items[ObjEnum - 1];
                      ItemsCount := ItemsCount + 1;
                      RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                      RRange.Value := Format('%8.1f', [Storage2.StoredAssignTotal]);

                      Summ := Storage2.CalcGradeSumm(FGrade.GradeNum, RecipeBeginTime, RecipeEndTime);

                      RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 3];
                      RRange.Value := Format('%8.1f', [Summ]);
                      if Summ <> 0 then
                        begin
                          RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 4];
                          RRange.Value := Format('%8.1f', [Storage2.StoredRecipeGrade[FGrade.GradeNum]]);
                        end;
                    end;
                  RecipeBeginTime := RecipeEndTime;
                  RecordsCounter := RecordsCounter + 1;
                until (RecipeEndTime = EndTime);
              end else RecordsCounter := RecordsCounter + 1;
          end;
      end;

    RRange := RWorkSheet.Cells[RecordsCounter + 6, 1];
    RRange.Value := 'ИТОГО:';

    for ObjEnum := 1 to PrintingObjects.Count do
      begin
        RRange := RWorkSheet.Cells[RecordsCounter + 6, ObjEnum * 3 + 3];
        RRange.Value := Format('%8.1f', [GradesSummArray[ObjEnum]]);
      end;

    for ObjEnum := 1 to PrintingObjects.Count * 3 + 5 do
      begin
        for i := 3 to RecordsCounter + 6 do
          begin
            RRange := RWorkSheet.Cells[i, ObjEnum];
            RRange.BorderAround(1);
          end;
      end;

    RWorkBook.Protect('123');
    RWorkBook.SaveAs('c:\UPC\WStation\report.xls');
    RExcel.Visible := True; // Делаем Excel видимым
  finally
    RExcel := UnAssigned;
  end;
  Count := PrintingObjects.Count - 1;
  for i := Count downto 0 do
    begin
      FGrade := PrintingObjects.Items[i];
      PrintingObjects.Delete(i);
      FGrade.Free;
    end;
  PrintingObjects.Free;                                      //Удаление списка объектов
end;


