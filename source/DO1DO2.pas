unit DO1DO2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Mask, StdCtrls, Buttons, RXCtrls, ToolEdit, Grids, ComCtrls,
  TeeProcs, TeEngine, Chart, DBChart, DBTables, Batcher, MainF, Types, ComObj,
  Db, Series, CoalGrade, Storage;

type
  TDO1DO2Form = class(TForm)
    PageControl1: TPageControl;
    SheetTrends: TTabSheet;
    DBChart1: TDBChart;
    lbChTime1: TLabel;
    lbChG: TLabel;
    UpDown1: TUpDown;
    SheetAlarms: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    sgAlarms1: TStringGrid;
    deAlarmsDate1: TDateEdit;
    clbAlarms1: TRxCheckListBox;
    SheetReport1: TTabSheet;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label10: TLabel;
    deReportDate1: TDateEdit;
    rbDay1: TRadioButton;
    rbNight1: TRadioButton;
    rbMonth1: TRadioButton;
    meBeginTime1: TMaskEdit;
    meEndTime1: TMaskEdit;
    rbTime1: TRadioButton;
    btMakeReport1: TBitBtn;
    rgReportCategory1: TRadioGroup;
    btMakeTrends1: TBitBtn;
    clbReportCategory1: TRxCheckListBox;
    rgReportType1: TRadioGroup;
    SheetGrades1: TTabSheet;
    SheetSumm1: TTabSheet;
    lbPrT: TLabel;
    lbPrTotal1: TLabel;
    lbPr1: TLabel;
    lbPrTot11: TLabel;
    lbPr2: TLabel;
    lbPrTot21: TLabel;
    lbW: TLabel;
    lbWeight1: TLabel;
    lbTablePc: TLabel;
    Label6: TLabel;
    lbPrU1: TLabel;
    sgGradesPc1: TStringGrid;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    DBChart2: TDBChart;
    lbChTime2: TLabel;
    Label11: TLabel;
    UpDown2: TUpDown;
    SheetAlarms2: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    sgAlarms2: TStringGrid;
    deAlarmsDate2: TDateEdit;
    clbAlarms2: TRxCheckListBox;
    SheetReport2: TTabSheet;
    GroupBox4: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    deReportDate2: TDateEdit;
    rbDay2: TRadioButton;
    rbNight2: TRadioButton;
    rbMonth2: TRadioButton;
    meBeginTime2: TMaskEdit;
    meEndTime2: TMaskEdit;
    rbTime2: TRadioButton;
    btMakeReport2: TBitBtn;
    rgReportCategory2: TRadioGroup;
    btMakeTrends2: TBitBtn;
    clbReportCategory2: TRxCheckListBox;
    rgReportType2: TRadioGroup;
    SheetGrades2: TTabSheet;
    SheetSumm2: TTabSheet;
    Label21: TLabel;
    lbPrTotal2: TLabel;
    Label23: TLabel;
    lbPrTot12: TLabel;
    Label25: TLabel;
    lbPrTot22: TLabel;
    Label27: TLabel;
    lbWeight2: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    lbPrU2: TLabel;
    sgGradesPc2: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    lbWeightU2: TLabel;
    Label7: TLabel;
    lbWeightU1: TLabel;
    Label3: TLabel;
    deBeginDate2: TDateEdit;
    deEndDate2: TDateEdit;
    procedure SheetAlarms2Show(Sender: TObject);
    procedure clbAlarms2ClickCheck(Sender: TObject);
    procedure deAlarmsDate2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure deReportDate2Change(Sender: TObject);
    procedure rgReportCategory2Click(Sender: TObject);
    procedure rgReportType2Click(Sender: TObject);
    procedure btMakeReport2Click(Sender: TObject);
    procedure btMakeTrends2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgGradesPc2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure UpDown2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgGradesPc1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    FGrade : TCoalGrade;                         //Экземпляр объекта TCoalGrade
    procedure MakeReport(BeginTime, EndTime : TDateTime);
    procedure MakeMonthReport;
    procedure MakeBatchReport(BeginTime, EndTime : TDateTime);
  public
    procedure DeleteTrends(DONum : byte);
    procedure MakeTrends(DONum : byte);
    procedure RedrawTrends(DONum : byte);
  end;

var
  DO1DO2Form: TDO1DO2Form;
  Batch : TBatcher;
  Serie: TLineSeries;
  SeriesList1 : TList;
  SeriesList2 : TList;
  TrendsQuery : TQuery;
  TrendsQueriesList1 : TList;
  TrendsQueriesList2 : TList;

implementation

uses View, Summ, DO1, DO2, ReportSplash, Splash;

{$R *.DFM}

{$INCLUDE MonthReport}
{$INCLUDE BatchReport}

procedure TDO1DO2Form.SheetAlarms2Show(Sender: TObject);
var
  CurrRaw, CurrLine, j : integer;
  PriorState, PriorWrk, CurrState, CurrWrk : byte;
  NewMessage : boolean;
  AlarmsQuery : TQuery;
  i : byte;
  F : TextFile;
  BeginTime, EndTime : string;  
begin
  WStationForm.OPCReadTimer.Enabled := False;      //Отключить обновление данных
  DO1Form.DeSelectAll;
  DO2Form.DeSelectAll;
  BeginTime := FormatDateTime('yyyy/mm/dd', deAlarmsDate2.Date) + ' 00:00:00';
  EndTime := FormatDateTime('yyyy/mm/dd', deAlarmsDate2.Date) + ' 23:59:59';
  AlarmsQuery := TQuery.Create(Self);
  AlarmsQuery.SessionName := 'MySession';
  AlarmsQuery.DatabaseName := 'UPC';
  AlarmsQuery.SQL.Clear;
  AlarmsQuery.SQL.Add('select * from CONFIG2 where (dat > ''' + BeginTime + ''') and (dat < ''' + EndTime + ''') order by dat;');
  AlarmsQuery.Open;
  AlarmsQuery.Last;
  SendMessage(sgAlarms2.Handle, WM_SETREDRAW, 0, 0);

  sgAlarms2.RowCount := 2;
  sgAlarms2.Cells[0, 1] := '';
  sgAlarms2.Cells[1, 1] := '';
  sgAlarms2.Cells[2, 1] := '';
  CurrRaw := 1;
  NewMessage := False;

  AssignFile(F, 'Messages.txt');
  Rewrite(F);
  Writeln(F, 'Журнал событий за: ' + FormatDateTime('dd/mm/yyyy', deAlarmsDate2.Date));

  for CurrLine := AlarmsQuery.RecordCount - 1 downto 1 do
    begin
      i := 0;
      for j := 1 to 16 do
        begin
          if clbAlarms2.State[i] = cbChecked then
            begin
              CurrState :=AlarmsQuery.Fields.FieldByName('state_' + IntToStr(j)).AsInteger;
              CurrWrk := AlarmsQuery.Fields.FieldByName('wrk_' + IntToStr(j)).AsInteger;
              AlarmsQuery.Prior;
              PriorState :=AlarmsQuery.Fields.FieldByName('state_' + IntToStr(j)).AsInteger;
              PriorWrk := AlarmsQuery.Fields.FieldByName('wrk_' + IntToStr(j)).AsInteger;
              AlarmsQuery.Next;
              sgAlarms2.Cells[2, CurrRaw] := '';
              if CurrState <> PriorState then
                begin
                  NewMessage := True;
                  sgAlarms2.Cells[1, CurrRaw] := '   ' + IntToStr(j);
                  case CurrState of
                  0: sgAlarms2.Cells[2, CurrRaw] := ' +   OK.';
                  1: sgAlarms2.Cells[2, CurrRaw] := ' !   Нарушение работы тензодатчика.';
                  2: sgAlarms2.Cells[2, CurrRaw] := '!!!  Потеряна связь с "Микросимом".';
                  3: sgAlarms2.Cells[2, CurrRaw] := ' -   Дозатор выведен из работы.';
                  end;
                end;
              if (CurrState = 0) and (CurrWrk <> PriorWrk) then
                begin
                  NewMessage := True;
                  sgAlarms2.Cells[1, CurrRaw] := '   ' + IntToStr(j);
                  case CurrWrk of
                  0: sgAlarms2.Cells[2, CurrRaw] := sgAlarms2.Cells[2, CurrRaw] + '     Останов весового конвейера.';
                  1: sgAlarms2.Cells[2, CurrRaw] := sgAlarms2.Cells[2, CurrRaw] + '     Пуск весового конвейера.';
                  end;
                end;
              if NewMessage then
                begin
                  sgAlarms2.Cells[0, CurrRaw] := AlarmsQuery.Fields.FieldByName('dat').AsString;
                  Writeln(F, sgAlarms2.Cells[0, CurrRaw] + Chr(VK_TAB) + sgAlarms2.Cells[1, CurrRaw] + Chr(VK_TAB) + sgAlarms2.Cells[2, CurrRaw]);
                  CurrRaw := CurrRaw + 1;
                  sgAlarms2.RowCount := sgAlarms2.RowCount + 1;
                  NewMessage := False;
                end;
            end;
          i := i + 1;
        end;
      AlarmsQuery.Prior;
    end;
  CloseFile(F);
  SendMessage(sgAlarms2.Handle, WM_SETREDRAW, 1, 0);
  sgAlarms2.Refresh;
  AlarmsQuery.Close;
  AlarmsQuery.Free;
  WStationForm.OPCReadTimer.Enabled := True;      //Включить обновление данных
end;

procedure TDO1DO2Form.clbAlarms2ClickCheck(Sender: TObject);
begin
  SheetAlarms2Show(Sender);
end;

procedure TDO1DO2Form.deAlarmsDate2Change(Sender: TObject);
begin
  SheetAlarms2Show(Sender);
end;

procedure TDO1DO2Form.FormCreate(Sender: TObject);
begin
  Height := 740;
  Width := 1024;
  Top := 0;
  Left := 0;
  SeriesList1 := TList.Create;
  TrendsQueriesList1 := TList.Create;
  SeriesList2 := TList.Create;
  TrendsQueriesList2 := TList.Create;
end;

procedure TDO1DO2Form.deReportDate2Change(Sender: TObject);
begin
  rbMonth2.Caption := FormatDateTime('mmmm yyyy', deReportDate2.Date);
end;

procedure TDO1DO2Form.rgReportCategory2Click(Sender: TObject);
var
  i : byte;
begin
  clbReportCategory2.Items.Clear;
  case rgReportCategory2.ItemIndex of
    0 : begin
          rbMonth2.Visible := False;
          if rgReportType2.ItemIndex = 0 then clbReportCategory2.Visible := False else clbReportCategory2.Visible := True;
          for i := 1 to 16 do
            begin
              Batch := BatchList2.Items[i - 1];
              clbReportCategory2.Items.Add('Дозатор №' + IntToStr(i) + ' - ' + Batch.GrName);
              if i = 2 then clbReportCategory2.EnabledItem[i - 1] := False;
            end;
        end;
    1:  begin
          if rgReportType2.ItemIndex = 0 then rbMonth2.Visible := True else rbMonth2.Visible := False;
          clbReportCategory2.Visible := False;
        end;
  end;
end;

procedure TDO1DO2Form.rgReportType2Click(Sender: TObject);
begin
  case rgReportType2.ItemIndex of
    0 : begin
          clbReportCategory2.Visible := False;
          btMakeTrends2.Visible := False;
          btMakeReport2.Visible := True;
          if rgReportCategory2.ItemIndex = 0 then rbMonth2.Visible := False else rbMonth2.Visible := True;
        end;
    1:  begin
          if rgReportCategory2.ItemIndex = 0 then clbReportCategory2.Visible := True else clbReportCategory2.Visible := False;
          btMakeTrends2.Visible := True;
          btMakeReport2.Visible := False;
          rbMonth2.Visible := False;
        end;
  end;
end;

procedure TDO1DO2Form.btMakeReport2Click(Sender: TObject);
var
  BeginTime, EndTime : TDateTime;
begin
  WStationForm.OPCReadTimer.Enabled := False;      //Отключить обновление данных
  btMakeTrends2.Enabled := False;      //Погасить кнопку
  btMakeReport2.Enabled := False;      //Погасить кнопку
  Screen.Cursor := crHourGlass;       //Включить песочные часы
  if rbMonth2.Checked then
    begin
      ReportSplashForm := nil;
      try
        ReportSplashForm := TReportSplashForm.Create(Self);                 //Создать форму
        ReportSplashForm.Show;
        ReportSplashForm.Update;
        MakeMonthReport;
        ReportSplashForm.Hide;
      finally
        if Assigned(ReportSplashForm) then ReportSplashForm.Release;        //Удалить форму
      end;
    end else
    begin
      if rbDay2.Checked then
        begin
          BeginTime := deReportDate2.Date + StrToTime('08:00:00');
          EndTime := deReportDate2.Date + StrToTime('20:00:00');
        end else
      if rbNight2.Checked then
        begin
          BeginTime := deReportDate2.Date - 1 + StrToTime('20:00:00');
          EndTime := deReportDate2.Date + StrToTime('08:00:00');
        end else
        begin
//          BeginTime := deReportDate2.Date + StrToTime(meBeginTime2.Text + ':00');
//          EndTime := deReportDate2.Date + StrToTime(meEndTime2.Text + ':59');
          BeginTime := deBeginDate2.Date + StrToTime(meBeginTime2.Text + ':00');
          EndTime := deEndDate2.Date + StrToTime(meEndTime2.Text + ':59');
        end;
      if rgReportCategory2.ItemIndex = 0 then MakeBatchReport(BeginTime, EndTime) else MakeReport(BeginTime, EndTime);
    end;
  WStationForm.OPCReadTimer.Enabled := True;                             //Включить обновление данных
  btMakeTrends2.Enabled := True;                             //Включить кнопку
  btMakeReport2.Enabled := True;                             //Включить кнопку
  Screen.Cursor := crDefault;                               //Включить песочные часы
end;

procedure TDO1DO2Form.btMakeTrends2Click(Sender: TObject);
var
  ObjEnum : byte;           //Перечислитель объектов
  ViewingObjects : TList;   //Перечень объектов для просмотра трендов
  BeginTime, EndTime : TDateTime;
begin
  ViewingObjects := TList.Create;
  ViewForm := nil;
  try
    WStationForm.OPCReadTimer.Enabled := False;      //Отключить обновление данных
    btMakeTrends2.Enabled := False;      //Погасить кнопку
    btMakeReport2.Enabled := False;      //Погасить кнопку
    Screen.Cursor := crHourGlass;       //Включить песочные часы
    ViewForm := TViewForm.Create(Self); //Создать форму для просмотра графиков
    if rbDay2.Checked then
      begin
        BeginTime := deReportDate2.Date + StrToTime('08:00:00');
        EndTime := deReportDate2.Date + StrToTime('20:00:00');
      end else
    if rbNight2.Checked then
      begin
        BeginTime := deReportDate2.Date - 1 + StrToTime('20:00:00');
        EndTime := deReportDate2.Date + StrToTime('08:00:00');
      end else
      begin
//        BeginTime := deReportDate2.Date + StrToTime(meBeginTime2.Text + ':00');
//        EndTime := deReportDate2.Date + StrToTime(meEndTime2.Text + ':00');
        BeginTime := deBeginDate2.Date + StrToTime(meBeginTime2.Text + ':00');
        EndTime := deEndDate2.Date + StrToTime(meEndTime2.Text + ':00');
      end;
    case rgReportCategory2.ItemIndex of  //Выбор типа графиков
    0 : begin
          for ObjEnum := 1 to 16 do
            begin
              Batch := BatchList2.Items[ObjEnum - 1];
              if clbReportCategory2.State[ObjEnum - 1] = cbChecked then ViewingObjects.Add(Batch);
            end;
        end;
    1:  begin
          for ObjEnum := 1 to Storage2.GradesCount do
            begin
              if Storage2.GradeWasLoaded(ObjEnum, BeginTime, EndTime) then
                begin
                  FGrade := TCoalGrade.Create();
                  ViewingObjects.Add(FGrade);
                  FGrade.GradeNum := ObjEnum;
                  FGrade.GradeName := Storage2.GradeNames[ObjEnum];
                end;
            end;
        end;
    end;
    if ViewingObjects.Count > 0 then ViewForm.ViewTrends(BeginTime, EndTime, ViewingObjects);  //Формирование графиков
    WStationForm.OPCReadTimer.Enabled := True;                             //Включить обновление данных
    Screen.Cursor := crDefault;                               //Включить песочные часы
  finally
    btMakeTrends2.Enabled := True;                             //Включить кнопку
    btMakeReport2.Enabled := True;                             //Включить кнопку
    if Assigned(ViewForm) then ViewForm.Release;              //Удалить форму с графиками
  end;
  ViewingObjects.Free;                                      //Удаление списка объектов
end;

procedure TDO1DO2Form.MakeReport(BeginTime, EndTime : TDateTime);
begin
  SummForm := nil;
  try
    SummForm := TSummForm.Create(Self);                 //Создать форму
    SummForm.Initialize(Storage2, BeginTime, EndTime);  //Передать параметры
    SummForm.Report := SummForm.QuickRep1;              //Подготовить к просмотру
    WStationForm.OPCReadTimer.Enabled := True;                     //Включить обновление данных
    Screen.Cursor := crDefault;                         //Включить песочные часы
    SummForm.Report.Preview;                            //Просмотр отчета
  finally
    SummForm.Finalize;
    if Assigned(SummForm) then SummForm.Release;        //Удалить форму
  end;
end;


procedure TDO1DO2Form.FormShow(Sender: TObject);
var
  myRect: TGridRect;
begin
  rgReportCategory2Click(Sender);
  rgReportType2Click(Sender);
  sgGradesPc1.ColWidths[0] := 140;
  sgGradesPc1.Cells[0,0] := 'Шихтогруппы:';
  sgGradesPc1.Cells[0,1] := 'Задано, (%):';
  sgGradesPc1.Cells[0,2] := 'Производительн., (%):';
  sgGradesPc2.ColWidths[0] := 140;
  sgGradesPc2.Cells[0,0] := 'Шихтогруппы:';
  sgGradesPc2.Cells[0,1] := 'Задано, (%):';
  sgGradesPc2.Cells[0,2] := 'Производительн., (%):';

  myRect.Left := -1;
  myRect.Top := -1;
  myRect.Right := -1;
  myRect.Bottom := -1;
  sgAlarms2.ColWidths[0] := 165;
  sgAlarms2.Cells[0, 0] := '     Дата, время';
  sgAlarms2.ColWidths[1] := 60;
  sgAlarms2.Cells[1, 0] := 'Дозатор';
  sgAlarms2.ColWidths[2] := 550;
  sgAlarms2.Cells[2, 0] := '     Сообщение';
  sgAlarms2.Selection := myRect;
  deAlarmsDate2.Date := Now;
  deReportDate2.Date := Now;
  sgAlarms1.ColWidths[0] := 165;
  sgAlarms1.Cells[0, 0] := '     Дата, время';
  sgAlarms1.ColWidths[1] := 60;
  sgAlarms1.Cells[1, 0] := 'Дозатор';
  sgAlarms1.ColWidths[2] := 550;
  sgAlarms1.Cells[2, 0] := '     Сообщение';
  sgAlarms1.Selection := myRect;
  deAlarmsDate1.Date := Now;
  deReportDate1.Date := Now;
  sgGradesPc1.Selection := myRect;
  sgGradesPc2.Selection := myRect;
end;

procedure TDO1DO2Form.sgGradesPc2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
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
              if AnyWorking2 and (Abs(FGrade.ProdPc - FGrade.AssignPc) > 2) then
                Canvas.Font.Color := clRed else Canvas.Font.Color := clNavy;
            end;
        end;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TDO1DO2Form.DeleteTrends(DONum : byte);
var
  i : integer;
  Count : byte;
begin
  if DONum = 1 then
    begin
      Count := TrendsQueriesList1.Count - 1;
      for i := Count downto 0 do
        begin
          TrendsQuery := TrendsQueriesList1.Items[i];
          TrendsQuery.Close;
          TrendsQueriesList1.Delete(i);
          TrendsQuery.Free;
          Serie := SeriesList1.Items[i];
          SeriesList1.Delete(i);
          Serie.Free;
        end;
    end else
    begin
      Count := TrendsQueriesList2.Count - 1;
      for i := Count downto 0 do
        begin
          TrendsQuery := TrendsQueriesList2.Items[i];
          TrendsQuery.Close;
          TrendsQueriesList2.Delete(i);
          TrendsQuery.Free;
          Serie := SeriesList2.Items[i];
          SeriesList2.Delete(i);
          Serie.Free;
        end;
    end;
end;

procedure TDO1DO2Form.MakeTrends(DONum : byte);
var
  i : integer;
  pStorage : ^TStorage;
begin
  if DONum = 1 then pStorage := @Storage1 else pStorage := @Storage2;

  //Создание серий и запросов для шихтогрупп с Active
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[i - 1];
      if DONum = 1 then
        begin
          SeriesList1.Add(TLineSeries.Create(Self));
          Serie := SeriesList1.Items[i - 1];
          TrendsQueriesList1.Add(TQuery.Create(Self));
          TrendsQuery := TrendsQueriesList1.Items[i - 1];
        end else
        begin
          SeriesList2.Add(TLineSeries.Create(Self));
          Serie := SeriesList2.Items[i - 1];
          TrendsQueriesList2.Add(TQuery.Create(Self));
          TrendsQuery := TrendsQueriesList2.Items[i - 1];
        end;

      TrendsQuery.SessionName := 'MySession';
      TrendsQuery.DatabaseName := 'UPC';
      with Serie do
        begin
          if DONum = 1 then ParentChart := DBChart1 else ParentChart := DBChart2;
          DataSource := TrendsQuery;
          XValues.ValueSource := 'DAT';
          XValues.DateTime := True;
          YValues.ValueSource:= 'PR_TH';
          SeriesColor := TrendsColors[i];
          Title := FGrade.GradeName;
        end;
    end;
end;

procedure TDO1DO2Form.RedrawTrends(DONum : byte);
var
  BeginTime, EndTime : string;
  i : integer;
  pStorage : ^TStorage;
begin
  if DONum = 1 then pStorage := @Storage1 else pStorage := @Storage2;

  if not CanRedraw then CurrHour := UpDown2.Position;
  DBChart2.LeftAxis.Minimum := 0;
  DBChart2.LeftAxis.Maximum := 400;
  UpDown2.Enabled := False;
  UpDown2.Position := CurrHour;
  lbChTime2.Caption := IntToStr(CurrHour) + ':00 - ' + IntToStr(CurrHour) + ':59';
  BeginTime := FormatDateTime('dd/mm/yyyy', Now) + ' ' + IntToStr(CurrHour) + ':00:00';
  EndTime := FormatDateTime('dd/mm/yyyy', Now) + ' ' + IntToStr(CurrHour) + ':59:59';
  if DBChart2.BottomAxis.Minimum > StrToDateTime(EndTime) then
    begin
      DBChart2.BottomAxis.Minimum := StrToDateTime(BeginTime);
      DBChart2.BottomAxis.Maximum := StrToDateTime(EndTime);
    end else
    begin
      DBChart2.BottomAxis.Maximum := StrToDateTime(EndTime);
      DBChart2.BottomAxis.Minimum := StrToDateTime(BeginTime);
    end;
  DBChart2.BottomAxis.DateTimeFormat := 'hh:mm';
  DBChart2.BottomAxis.Increment := DateTimeStep[dtFiveMinutes];
  for i := 1 to pStorage.CoalGradesList.Count do
    begin
      FGrade := pStorage.CoalGradesList.Items[i - 1];
      if DONum = 1 then TrendsQuery := TrendsQueriesList1.Items[i - 1] else TrendsQuery := TrendsQueriesList2.Items[i - 1];
      TrendsQuery.Close;
      TrendsQuery.SQL.Clear;
      TrendsQuery.SQL.Add('select DAT, PR_TH from grade' + IntToStr(DONum) + '_' + IntToStr(FGrade.GradeNum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', StrToDateTime(BeginTime)) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', StrToDateTime(EndTime)) + ''');');
      TrendsQuery.Open;
    end;
  UpDown2.Enabled := True;
end;

procedure TDO1DO2Form.UpDown2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CanRedraw := False;
  RedrawTrends(2);
end;

procedure TDO1DO2Form.sgGradesPc1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
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
              if AnyWorking1 and (Abs(FGrade.ProdPc - FGrade.AssignPc) > 2) then
                Canvas.Font.Color := clRed else Canvas.Font.Color := clNavy;
            end;
        end;
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TDO1DO2Form.BitBtn1Click(Sender: TObject);
begin
  DO1DO2Form.Hide;
  DO2Form.Show;
end;

procedure TDO1DO2Form.BitBtn2Click(Sender: TObject);
begin
  DO1DO2Form.Hide;
  DO1Form.Show;
end;

end.
