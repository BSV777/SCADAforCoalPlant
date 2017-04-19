unit View;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ExtCtrls, TeeProcs, TeEngine, Chart, DBChart, StdCtrls,
  Buttons, Series, Batcher, Types, QuickRpt, CoalGrade;

type
  TViewForm = class(TForm)
    ReportChart: TDBChart;
    btPrint: TBitBtn;
    procedure btPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FReport : TQuickRep;
    procedure SetReport(Value : TQuickRep);
  public
    procedure ViewTrends(DONum : byte; Time1, Time2 : TDateTime; ObjList : TList);
    property Report : TQuickRep read FReport write SetReport;
  end;

var
  ViewForm: TViewForm;
  ReportSerie : TLineSeries;
  ReportSeriesList : TList;
  ReportQuery : TQuery;
  ReportQueriesList : TList;
  ReportType : boolean;
  BeginTime : TDateTime;
  EndTime : TDateTime;
  ViewingObjects : TList;

implementation

uses MainF, Report;

{$R *.DFM}

procedure TViewForm.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;

procedure TViewForm.btPrintClick(Sender: TObject);
var
  ObjEnum : byte;       //Перечислитель объектов
  SerieEnum : byte;     //Перечислитель серий
  Batch : TBatcher;     //Переменная класса - дозаторы
  Grd : TCoalGrade;     //Переменная класса - щихтогруппы
  TitleString : string;
begin
  PrintForm := nil;
  try
    PrintForm := TPrintForm.Create(Self);
    PrintForm.QRChart1.Chart.BottomAxis.Automatic := False;
    PrintForm.QRChart1.Chart.BottomAxis.Maximum := ReportChart.BottomAxis.Maximum;
    PrintForm.QRChart1.Chart.BottomAxis.Minimum := ReportChart.BottomAxis.Minimum;
    PrintForm.QRChart1.Chart.LeftAxis.Maximum := ReportChart.LeftAxis.Maximum;
    PrintForm.QRChart1.Chart.LeftAxis.Minimum := ReportChart.LeftAxis.Minimum;
    PrintForm.QRChart1.Chart.BottomAxis.DateTimeFormat := 'hh:mm';
    if ReportType then
      begin
        TitleString := 'Отчет о производительности дозаторов (';
        SerieEnum := 1;
        for ObjEnum := 0 to ViewingObjects.Count - 1 do
          begin
            Batch := ViewingObjects.Items[ObjEnum];
            ReportSerie := ReportSeriesList.Items[SerieEnum];
            if ReportSerie.Active then
              begin
                TitleString := TitleString + IntToStr(Batch.Num) + ', ';
                ReportSerie.ParentChart := PrintForm.QRChart1.Chart;
              end;
            SerieEnum := SerieEnum + 2;
          end;
      end else
      begin
        TitleString := 'Отчет по шихтогруппам (';
        SerieEnum := 1;
        for ObjEnum := 0 to ViewingObjects.Count - 1 do
          begin
            Grd := ViewingObjects.Items[ObjEnum];
            ReportSerie := ReportSeriesList.Items[SerieEnum];
            if ReportSerie.Active then
              begin
                TitleString := TitleString + '"' + Grd.GradeName + '", ';
                ReportSerie.ParentChart := PrintForm.QRChart1.Chart;
              end;
            SerieEnum := SerieEnum + 2;
          end;
      end;
    PrintForm.QRLabel1.Caption := Copy(TitleString, 1, Length(TitleString) - 2) + ')';
    PrintForm.QRLabel2.Caption := 'с ' +
      FormatDateTime('dd.mm.yyyy hh:mm', PrintForm.QRChart1.Chart.BottomAxis.Minimum) + ' по ' +
      FormatDateTime('dd.mm.yyyy hh:mm', PrintForm.QRChart1.Chart.BottomAxis.Maximum);
    Report := PrintForm.QuickRep1;
    Screen.Cursor := crDefault;
    Report.Preview;
    for SerieEnum := 0 to ReportSeriesList.Count - 1 do
      begin
        ReportSerie := ReportSeriesList.Items[SerieEnum];
        ReportSerie.ParentChart := nil;
      end;
    for SerieEnum := 0 to ReportSeriesList.Count - 1 do
      begin
        ReportSerie := ReportSeriesList.Items[SerieEnum];
        ReportSerie.ParentChart := ReportChart;
      end;
  finally
    if Assigned(PrintForm) then PrintForm.Release;
  end;
end;

procedure TViewForm.ViewTrends(DONum : byte; Time1, Time2 : TDateTime; ObjList : TList);
var
  ObjEnum : byte;       //Перечислитель объектов
  SerieEnum : byte;     //Перечислитель серий
  Obj : TObject;
  Batch : TBatcher;     //Переменная класса - дозаторы
  Grd : TCoalGrade;     //Переменная класса - щихтогруппы
  SQLString : string;   //Строка запроса
begin
  BeginTime := Time1;
  EndTime := Time2;
  ViewingObjects := ObjList;
  //Установка параметров осей диаграммы
  ReportChart.BottomAxis.Automatic := False;
  ReportChart.BottomAxis.DateTimeFormat := 'hh:mm';
  if ReportChart.BottomAxis.Minimum > EndTime then
    begin
      ReportChart.BottomAxis.Minimum := BeginTime;
      ReportChart.BottomAxis.Maximum := EndTime;
    end else
    begin
      ReportChart.BottomAxis.Maximum := EndTime;
      ReportChart.BottomAxis.Minimum := BeginTime;
    end;
  //Определение типа объектов в списке
  Obj := ViewingObjects.Items[0];
  if Obj is TBatcher then
    begin
      ReportType := True;
      if DONum = 1 then ReportChart.LeftAxis.Maximum := 100 else ReportChart.LeftAxis.Maximum := 200;
      ReportQuery := TQuery.Create(Self);     //Создание и инициализация запроса
      ReportQuery.SessionName := 'MySession';
      ReportQuery.DatabaseName := 'UPC';
      ReportQuery.SQL.Clear;
      SQLString := 'select DAT';
      //Создание серий для дозаторов
      SerieEnum := 0;
      for ObjEnum := 0 to ViewingObjects.Count - 1 do
        begin
          Batch := ViewingObjects.Items[ObjEnum];
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'AS_TH_' + IntToStr(Batch.Num);
              SeriesColor := TrendsColors[Batch.Num];
              Title := 'Задание дозатора №' + IntToStr(Batch.Num);
              Active := False;
            end;
          SerieEnum := SerieEnum + 1;
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'PR_TH_' + IntToStr(Batch.Num);
              SeriesColor := TrendsColors[Batch.Num];
              Title := 'Произв. дозатора №' + IntToStr(Batch.Num);
            end;
          SerieEnum := SerieEnum + 1;
          SQLString := SQLString + ', AS_TH_' + IntToStr(Batch.Num) + ', PR_TH_' + IntToStr(Batch.Num);
        end;
      SQLString := SQLString + ' from batchers' + IntToStr(DONum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', BeginTime) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', EndTime) + ''');'; //SQLAnywhere
        ReportQuery.SQL.Add(SQLString);
        ReportQuery.Open;
    end else
    begin
      ReportType := False;
      if DONum = 1 then ReportChart.LeftAxis.Maximum := 200 else ReportChart.LeftAxis.Maximum := 400;
      //Создание серий для шихтогрупп
      SerieEnum := 0;
      for ObjEnum := 0 to ViewingObjects.Count - 1 do
        begin
          ReportQueriesList.Add(TQuery.Create(Self));
          ReportQuery := ReportQueriesList[ObjEnum];     //Создание и инициализация запроса
          ReportQuery.SessionName := 'MySession';
          ReportQuery.DatabaseName := 'UPC';
          ReportQuery.SQL.Clear;
          Grd := ViewingObjects.Items[ObjEnum];
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'AS_TH';
              SeriesColor := TrendsColors[Grd.GradeNum];
              Title := 'Задание ш/гр "' + Grd.GradeName + '"';
              Active := False;
            end;
          SerieEnum := SerieEnum + 1;
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'PR_TH';
              SeriesColor := TrendsColors[Grd.GradeNum];
              Title := 'Произв. ш/гр "' + Grd.GradeName + '"';
            end;
          SerieEnum := SerieEnum + 1;
          SQLString := 'select DAT, AS_TH, PR_TH from grade' + IntToStr(DONum) + '_' + IntToStr(Grd.GradeNum) + ' where (dat > ''' +
            FormatDateTime('yyyy/mm/dd hh:nn:ss', BeginTime) + ''') and (dat < ''' +
            FormatDateTime('yyyy/mm/dd hh:nn:ss', EndTime) + ''');'; //SQLAnywhere
          ReportQuery.SQL.Add(SQLString);
          ReportQuery.Open;
        end;
    end;
    Caption := 'Диаграмма с ' +
      FormatDateTime('dd.mm.yyyy hh:mm', BeginTime) + ' по ' +
      FormatDateTime('dd.mm.yyyy hh:mm', EndTime);
    ViewForm.ShowModal;
end;

procedure TViewForm.FormCreate(Sender: TObject);
begin
  ReportSeriesList := TList.Create;
  ReportQueriesList := TList.Create;
end;

end.
unit View;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ExtCtrls, TeeProcs, TeEngine, Chart, DBChart, StdCtrls,
  Buttons, Series, Batcher, Types, QuickRpt, CoalGrade;

type
  TViewForm = class(TForm)
    ReportChart: TDBChart;
    btPrint: TBitBtn;
    procedure btPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FReport : TQuickRep;
    procedure SetReport(Value : TQuickRep);
  public
    procedure ViewTrends(DONum : byte; Time1, Time2 : TDateTime; ObjList : TList);
    property Report : TQuickRep read FReport write SetReport;
  end;

var
  ViewForm: TViewForm;
  ReportSerie : TLineSeries;
  ReportSeriesList : TList;
  ReportQuery : TQuery;
  ReportQueriesList : TList;
  ReportType : boolean;
  BeginTime : TDateTime;
  EndTime : TDateTime;
  ViewingObjects : TList;

implementation

uses MainF, Report;

{$R *.DFM}

procedure TViewForm.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;

procedure TViewForm.btPrintClick(Sender: TObject);
var
  ObjEnum : byte;       //Перечислитель объектов
  SerieEnum : byte;     //Перечислитель серий
  Batch : TBatcher;     //Переменная класса - дозаторы
  Grd : TCoalGrade;     //Переменная класса - щихтогруппы
  TitleString : string;
begin
  PrintForm := nil;
  try
    PrintForm := TPrintForm.Create(Self);
    PrintForm.QRChart1.Chart.BottomAxis.Automatic := False;
    PrintForm.QRChart1.Chart.BottomAxis.Maximum := ReportChart.BottomAxis.Maximum;
    PrintForm.QRChart1.Chart.BottomAxis.Minimum := ReportChart.BottomAxis.Minimum;
    PrintForm.QRChart1.Chart.LeftAxis.Maximum := ReportChart.LeftAxis.Maximum;
    PrintForm.QRChart1.Chart.LeftAxis.Minimum := ReportChart.LeftAxis.Minimum;
    PrintForm.QRChart1.Chart.BottomAxis.DateTimeFormat := 'hh:mm';
    if ReportType then
      begin
        TitleString := 'Отчет о производительности дозаторов (';
        SerieEnum := 1;
        for ObjEnum := 0 to ViewingObjects.Count - 1 do
          begin
            Batch := ViewingObjects.Items[ObjEnum];
            ReportSerie := ReportSeriesList.Items[SerieEnum];
            if ReportSerie.Active then
              begin
                TitleString := TitleString + IntToStr(Batch.Num) + ', ';
                ReportSerie.ParentChart := PrintForm.QRChart1.Chart;
              end;
            SerieEnum := SerieEnum + 2;
          end;
      end else
      begin
        TitleString := 'Отчет по шихтогруппам (';
        SerieEnum := 1;
        for ObjEnum := 0 to ViewingObjects.Count - 1 do
          begin
            Grd := ViewingObjects.Items[ObjEnum];
            ReportSerie := ReportSeriesList.Items[SerieEnum];
            if ReportSerie.Active then
              begin
                TitleString := TitleString + '"' + Grd.GradeName + '", ';
                ReportSerie.ParentChart := PrintForm.QRChart1.Chart;
              end;
            SerieEnum := SerieEnum + 2;
          end;
      end;
    PrintForm.QRLabel1.Caption := Copy(TitleString, 1, Length(TitleString) - 2) + ')';
    PrintForm.QRLabel2.Caption := 'с ' +
      FormatDateTime('dd.mm.yyyy hh:mm', PrintForm.QRChart1.Chart.BottomAxis.Minimum) + ' по ' +
      FormatDateTime('dd.mm.yyyy hh:mm', PrintForm.QRChart1.Chart.BottomAxis.Maximum);
    Report := PrintForm.QuickRep1;
    Screen.Cursor := crDefault;
    Report.Preview;
    for SerieEnum := 0 to ReportSeriesList.Count - 1 do
      begin
        ReportSerie := ReportSeriesList.Items[SerieEnum];
        ReportSerie.ParentChart := nil;
      end;
    for SerieEnum := 0 to ReportSeriesList.Count - 1 do
      begin
        ReportSerie := ReportSeriesList.Items[SerieEnum];
        ReportSerie.ParentChart := ReportChart;
      end;
  finally
    if Assigned(PrintForm) then PrintForm.Release;
  end;
end;

procedure TViewForm.ViewTrends(DONum : byte; Time1, Time2 : TDateTime; ObjList : TList);
var
  ObjEnum : byte;       //Перечислитель объектов
  SerieEnum : byte;     //Перечислитель серий
  Obj : TObject;
  Batch : TBatcher;     //Переменная класса - дозаторы
  Grd : TCoalGrade;     //Переменная класса - щихтогруппы
  SQLString : string;   //Строка запроса
begin
  BeginTime := Time1;
  EndTime := Time2;
  ViewingObjects := ObjList;
  //Установка параметров осей диаграммы
  ReportChart.BottomAxis.Automatic := False;
  ReportChart.BottomAxis.DateTimeFormat := 'hh:mm';
  if ReportChart.BottomAxis.Minimum > EndTime then
    begin
      ReportChart.BottomAxis.Minimum := BeginTime;
      ReportChart.BottomAxis.Maximum := EndTime;
    end else
    begin
      ReportChart.BottomAxis.Maximum := EndTime;
      ReportChart.BottomAxis.Minimum := BeginTime;
    end;
  //Определение типа объектов в списке
  Obj := ViewingObjects.Items[0];
  if Obj is TBatcher then
    begin
      ReportType := True;
      if DONum = 1 then ReportChart.LeftAxis.Maximum := 100 else ReportChart.LeftAxis.Maximum := 200;
      ReportQuery := TQuery.Create(Self);     //Создание и инициализация запроса
      ReportQuery.SessionName := 'MySession';
      ReportQuery.DatabaseName := 'UPC';
      ReportQuery.SQL.Clear;
      SQLString := 'select DAT';
      //Создание серий для дозаторов
      SerieEnum := 0;
      for ObjEnum := 0 to ViewingObjects.Count - 1 do
        begin
          Batch := ViewingObjects.Items[ObjEnum];
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'AS_TH_' + IntToStr(Batch.Num);
              SeriesColor := TrendsColors[Batch.Num];
              Title := 'Задание дозатора №' + IntToStr(Batch.Num);
              Active := False;
            end;
          SerieEnum := SerieEnum + 1;
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'PR_TH_' + IntToStr(Batch.Num);
              SeriesColor := TrendsColors[Batch.Num];
              Title := 'Произв. дозатора №' + IntToStr(Batch.Num);
            end;
          SerieEnum := SerieEnum + 1;
          SQLString := SQLString + ', AS_TH_' + IntToStr(Batch.Num) + ', PR_TH_' + IntToStr(Batch.Num);
        end;
      SQLString := SQLString + ' from batchers' + IntToStr(DONum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', BeginTime) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', EndTime) + ''');'; //SQLAnywhere
        ReportQuery.SQL.Add(SQLString);
        ReportQuery.Open;
    end else
    begin
      ReportType := False;
      if DONum = 1 then ReportChart.LeftAxis.Maximum := 200 else ReportChart.LeftAxis.Maximum := 400;
      //Создание серий для шихтогрупп
      SerieEnum := 0;
      for ObjEnum := 0 to ViewingObjects.Count - 1 do
        begin
          ReportQueriesList.Add(TQuery.Create(Self));
          ReportQuery := ReportQueriesList[ObjEnum];     //Создание и инициализация запроса
          ReportQuery.SessionName := 'MySession';
          ReportQuery.DatabaseName := 'UPC';
          ReportQuery.SQL.Clear;
          Grd := ViewingObjects.Items[ObjEnum];
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'AS_TH';
              SeriesColor := TrendsColors[Grd.GradeNum];
              Title := 'Задание ш/гр "' + Grd.GradeName + '"';
              Active := False;
            end;
          SerieEnum := SerieEnum + 1;
          ReportSeriesList.Add(TLineSeries.Create(Self));
          ReportSerie := ReportSeriesList.Items[SerieEnum];
          with ReportSerie do
            begin
              ParentChart := ReportChart;
              DataSource := ReportQuery;
              XValues.ValueSource := 'DAT';
              XValues.DateTime := True;
              YValues.ValueSource:= 'PR_TH';
              SeriesColor := TrendsColors[Grd.GradeNum];
              Title := 'Произв. ш/гр "' + Grd.GradeName + '"';
            end;
          SerieEnum := SerieEnum + 1;
          SQLString := 'select DAT, AS_TH, PR_TH from grade' + IntToStr(DONum) + '_' + IntToStr(Grd.GradeNum) + ' where (dat > ''' +
            FormatDateTime('yyyy/mm/dd hh:nn:ss', BeginTime) + ''') and (dat < ''' +
            FormatDateTime('yyyy/mm/dd hh:nn:ss', EndTime) + ''');'; //SQLAnywhere
          ReportQuery.SQL.Add(SQLString);
          ReportQuery.Open;
        end;
    end;
    Caption := 'Диаграмма с ' +
      FormatDateTime('dd.mm.yyyy hh:mm', BeginTime) + ' по ' +
      FormatDateTime('dd.mm.yyyy hh:mm', EndTime);
    ViewForm.ShowModal;
end;

procedure TViewForm.FormCreate(Sender: TObject);
begin
  ReportSeriesList := TList.Create;
  ReportQueriesList := TList.Create;
end;

end.
