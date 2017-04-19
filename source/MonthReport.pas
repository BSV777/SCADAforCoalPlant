procedure TDO1DO2Form.MakeMonthReport(DONum : byte);
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
  FGrade : TCoalGrade;                        //��������� �����������
  PrintingObjects : TList;                    //��������� �������� TCoalGrade
  pStorage : ^TStorage;
begin
  Res := TResourceStream.Create(Hinstance, 'TEMPLATE', Pchar('XLSFILES'));
  Res.SaveToFile('template.xls');
  Res.Free;
  if FileExists('c:\UPC\WStation\report.xls') then DeleteFile('c:\UPC\WStation\report.xls');
  try
    RExcel := CreateOLEObject('Excel.Application'); // �������� ������
    RWorkBook := RExcel.WorkBooks.Open('c:\UPC\WStation\template.xls');
//    RWorkBook := RExcel.WorkBooks.Add;
    RWorkSheet := RWorkBook.ActiveSheet; // �������� �������� ����

    if DONum = 1 then
      begin
        pStorage := @Storage1;
        DecodeDate(deReportDate1.Date, TargetYear, TargetMonth, TargetDay);
        RRange := RWorkSheet.Cells[1, 1];
        RRange.Value := '����� � ���������� �������� ������������, �������� �� �������� ����� �1 � �2 ��:';
      end else
      begin
        pStorage := @Storage2;
        DecodeDate(deReportDate2.Date, TargetYear, TargetMonth, TargetDay);
        RRange := RWorkSheet.Cells[1, 1];
        RRange.Value := '����� � ���������� �������� ������������, �������� �� �������� ����� �3 � �4 ��:';
      end;

    MaxDay := MonthDays[IsLeapYear(TargetYear), TargetMonth];
    RRange.Font.Bold := True; // ������ ������
    RRange.Font.Name := 'Times New Roman Cyr';
    RRange := RWorkSheet.Cells[2, 1];
    RRange.Value := rbMonth2.Caption;
    RRange.Font.Bold := True; // ������ ������
    RRange.Font.Name := 'Times New Roman Cyr';

    RRange := RWorkSheet.Cells[3, 1];
    RRange.Value := '����';

    BeginTime := EncodeDate(TargetYear, TargetMonth, 1) + StrToTime('00:00:01');
    EndTime := EncodeDate(TargetYear, TargetMonth, MaxDay) + StrToTime('23:59:59');
    PrintingObjects := TList.Create;
    //����� ���������� ��� ������ (��, ������� ���� � �������)
    for ObjEnum := 1 to pStorage.GradesCount do
      begin
        if pStorage.GradeWasLoaded(ObjEnum, BeginTime, EndTime) then
          begin
            FGrade := TCoalGrade.Create();
            PrintingObjects.Add(FGrade);
            FGrade.GradeNum := ObjEnum;
            FGrade.GradeName := pStorage.GradeNames[ObjEnum];
          end;
      end;
    SetLength(GradesSummArray, pStorage.GradesCount + 1);

    ItemsCount := 0;
    for ObjEnum := 1 to PrintingObjects.Count do
      begin
        FGrade := PrintingObjects.Items[ObjEnum - 1];
        ItemsCount := ItemsCount + 1;
        RRange := RWorkSheet.Cells[3, ItemsCount * 3 + 3];
        RRange.Value := FGrade.GradeName;
        RRange.Font.Bold := True; // ������ ������
        RRange.Font.Name := 'Times New Roman Cyr';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 3];
        RRange.Value := '�����';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 3];
        RRange.Value := '[��]';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 4];
        RRange.Value := '������';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 4];
        RRange.Value := '[%]';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 5];
        RRange.Value := '����';
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
                Summ := pStorage.CalcGradeSumm(FGrade.GradeNum, BeginTime, EndTime);

                RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 3];
                RRange.Value := Format('%8.1f', [Summ]);
                RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                RRange.Value := Format('%8.1f', [pStorage.StoredAssignTotal]);

                GradesSummArray[ObjEnum] := GradesSummArray[ObjEnum] + Summ;
                if Summ <> 0 then
                  begin
                    RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 4];
                    RRange.Value := Format('%8.1f', [pStorage.StoredRecipeGrade[FGrade.GradeNum]]);
                  end;
              end;

            ConvSumm := pStorage.CalcConvSumm(BeginTime, EndTime);
            RRange := RWorkSheet.Cells[RecordsCounter + 5, 2];
            RRange.Value := Format('%8.1f', [ConvSumm]);
            AddedSumm := AddedSumm + ConvSumm;

            RRange := RWorkSheet.Cells[RecordsCounter + 5, 3];
            RRange.Value := Format('%8.1f', [AddedSumm]);

            RecipeEndTime := pStorage.ViewStoredRecipe(BeginTime, EndTime);
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
                  RecipeEndTime := pStorage.ViewStoredRecipe(RecipeBeginTime, EndTime);
                  ItemsCount := 0;
                  for ObjEnum := 1 to PrintingObjects.Count do
                    begin
                      FGrade := PrintingObjects.Items[ObjEnum - 1];
                      ItemsCount := ItemsCount + 1;
                      RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                      RRange.Value := Format('%8.1f', [pStorage.StoredAssignTotal]);

                      Summ := pStorage.CalcGradeSumm(FGrade.GradeNum, RecipeBeginTime, RecipeEndTime);

                      RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 3];
                      RRange.Value := Format('%8.1f', [Summ]);
                      if Summ <> 0 then
                        begin
                          RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 4];
                          RRange.Value := Format('%8.1f', [pStorage.StoredRecipeGrade[FGrade.GradeNum]]);
                        end;
                    end;
                  RecipeBeginTime := RecipeEndTime;
                  RecordsCounter := RecordsCounter + 1;
                until (RecipeEndTime = EndTime);
              end else RecordsCounter := RecordsCounter + 1;
          end;
      end;

    RRange := RWorkSheet.Cells[RecordsCounter + 6, 1];
    RRange.Value := '�����:';

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
    RExcel.Visible := True; // ������ Excel �������
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
  PrintingObjects.Free;                                      //�������� ������ ��������
end;


procedure TDO1DO2Form.MakeMonthReport(DONum : byte);
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
  FGrade : TCoalGrade;                        //��������� �����������
  PrintingObjects : TList;                    //��������� �������� TCoalGrade
  pStorage : ^TStorage;
begin
  Res := TResourceStream.Create(Hinstance, 'TEMPLATE', Pchar('XLSFILES'));
  Res.SaveToFile('template.xls');
  Res.Free;
  if FileExists('c:\UPC\WStation\report.xls') then DeleteFile('c:\UPC\WStation\report.xls');
  try
    RExcel := CreateOLEObject('Excel.Application'); // �������� ������
    RWorkBook := RExcel.WorkBooks.Open('c:\UPC\WStation\template.xls');
//    RWorkBook := RExcel.WorkBooks.Add;
    RWorkSheet := RWorkBook.ActiveSheet; // �������� �������� ����

    if DONum = 1 then
      begin
        pStorage := @Storage1;
        DecodeDate(deReportDate1.Date, TargetYear, TargetMonth, TargetDay);
        RRange := RWorkSheet.Cells[1, 1];
        RRange.Value := '����� � ���������� �������� ������������, �������� �� �������� ����� �1 � �2 ��:';
      end else
      begin
        pStorage := @Storage2;
        DecodeDate(deReportDate2.Date, TargetYear, TargetMonth, TargetDay);
        RRange := RWorkSheet.Cells[1, 1];
        RRange.Value := '����� � ���������� �������� ������������, �������� �� �������� ����� �3 � �4 ��:';
      end;

    MaxDay := MonthDays[IsLeapYear(TargetYear), TargetMonth];
    RRange.Font.Bold := True; // ������ ������
    RRange.Font.Name := 'Times New Roman Cyr';
    RRange := RWorkSheet.Cells[2, 1];
    RRange.Value := rbMonth2.Caption;
    RRange.Font.Bold := True; // ������ ������
    RRange.Font.Name := 'Times New Roman Cyr';

    RRange := RWorkSheet.Cells[3, 1];
    RRange.Value := '����';

    BeginTime := EncodeDate(TargetYear, TargetMonth, 1) + StrToTime('00:00:01');
    EndTime := EncodeDate(TargetYear, TargetMonth, MaxDay) + StrToTime('23:59:59');
    PrintingObjects := TList.Create;
    //����� ���������� ��� ������ (��, ������� ���� � �������)
    for ObjEnum := 1 to pStorage.GradesCount do
      begin
        if pStorage.GradeWasLoaded(ObjEnum, BeginTime, EndTime) then
          begin
            FGrade := TCoalGrade.Create();
            PrintingObjects.Add(FGrade);
            FGrade.GradeNum := ObjEnum;
            FGrade.GradeName := pStorage.GradeNames[ObjEnum];
          end;
      end;
    SetLength(GradesSummArray, pStorage.GradesCount + 1);

    ItemsCount := 0;
    for ObjEnum := 1 to PrintingObjects.Count do
      begin
        FGrade := PrintingObjects.Items[ObjEnum - 1];
        ItemsCount := ItemsCount + 1;
        RRange := RWorkSheet.Cells[3, ItemsCount * 3 + 3];
        RRange.Value := FGrade.GradeName;
        RRange.Font.Bold := True; // ������ ������
        RRange.Font.Name := 'Times New Roman Cyr';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 3];
        RRange.Value := '�����';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 3];
        RRange.Value := '[��]';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 4];
        RRange.Value := '������';
        RRange := RWorkSheet.Cells[5, ItemsCount * 3 + 4];
        RRange.Value := '[%]';
        RRange := RWorkSheet.Cells[4, ItemsCount * 3 + 5];
        RRange.Value := '����';
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
                Summ := pStorage.CalcGradeSumm(FGrade.GradeNum, BeginTime, EndTime);

                RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 3];
                RRange.Value := Format('%8.1f', [Summ]);
                RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                RRange.Value := Format('%8.1f', [pStorage.StoredAssignTotal]);

                GradesSummArray[ObjEnum] := GradesSummArray[ObjEnum] + Summ;
                if Summ <> 0 then
                  begin
                    RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 4];
                    RRange.Value := Format('%8.1f', [pStorage.StoredRecipeGrade[FGrade.GradeNum]]);
                  end;
              end;

            ConvSumm := pStorage.CalcConvSumm(BeginTime, EndTime);
            RRange := RWorkSheet.Cells[RecordsCounter + 5, 2];
            RRange.Value := Format('%8.1f', [ConvSumm]);
            AddedSumm := AddedSumm + ConvSumm;

            RRange := RWorkSheet.Cells[RecordsCounter + 5, 3];
            RRange.Value := Format('%8.1f', [AddedSumm]);

            RecipeEndTime := pStorage.ViewStoredRecipe(BeginTime, EndTime);
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
                  RecipeEndTime := pStorage.ViewStoredRecipe(RecipeBeginTime, EndTime);
                  ItemsCount := 0;
                  for ObjEnum := 1 to PrintingObjects.Count do
                    begin
                      FGrade := PrintingObjects.Items[ObjEnum - 1];
                      ItemsCount := ItemsCount + 1;
                      RRange := RWorkSheet.Cells[RecordsCounter + 5, 5];
                      RRange.Value := Format('%8.1f', [pStorage.StoredAssignTotal]);

                      Summ := pStorage.CalcGradeSumm(FGrade.GradeNum, RecipeBeginTime, RecipeEndTime);

                      RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 3];
                      RRange.Value := Format('%8.1f', [Summ]);
                      if Summ <> 0 then
                        begin
                          RRange := RWorkSheet.Cells[RecordsCounter + 5, ItemsCount * 3 + 4];
                          RRange.Value := Format('%8.1f', [pStorage.StoredRecipeGrade[FGrade.GradeNum]]);
                        end;
                    end;
                  RecipeBeginTime := RecipeEndTime;
                  RecordsCounter := RecordsCounter + 1;
                until (RecipeEndTime = EndTime);
              end else RecordsCounter := RecordsCounter + 1;
          end;
      end;

    RRange := RWorkSheet.Cells[RecordsCounter + 6, 1];
    RRange.Value := '�����:';

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
    RExcel.Visible := True; // ������ Excel �������
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
  PrintingObjects.Free;                                      //�������� ������ ��������
end;


