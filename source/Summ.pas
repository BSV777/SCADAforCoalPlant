unit Summ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Qrctrls, TeeProcs, TeEngine, Chart, DBChart, QrTee, Series, DBTables,
  Types, Storage, CoalGrade;

type
  GrdRec = record       //Структура для расчета процентных отклонений
    GrdSumm : single;   //Суммарный вес по марке
    GrdPart : single;   //Доля марки в шихте
    GrdAssign : single; //Заданный % участия
    GrdDelta : single;  //Процентное отклонение
  end;

  TSummForm = class(TForm)
    QuickRep1: TQuickRep;
    PageHeaderBand: TQRBand;
    QRlbTitle: TQRLabel;
    QRTitle: TQRLabel;
    QRPeriod: TQRLabel;
    QRlbGrName: TQRLabel;
    QRlbGrSumm: TQRLabel;
    QRlbGrAs: TQRLabel;
    QRlbGrPart: TQRLabel;
    QRlbGrDelta: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRTotal: TQRLabel;
    QRlbTotal: TQRLabel;
    QRlbth: TQRLabel;
    PageFooterBand: TQRBand;
    QRInfo: TQRLabel;
    DetailBand: TQRBand;
    QRGrName: TQRLabel;
    QRGrSumm: TQRLabel;
    QRGrAs: TQRLabel;
    QRGrPart: TQRLabel;
    QRGrDelta: TQRLabel;
    QRChart: TQRChart;
    QRDBChart1: TQRDBChart;
    QRlbRecipeSumm: TQRLabel;
    QRRecipeSumm: TQRLabel;
    QRlbRecipeth: TQRLabel;
    QRlbReportPeriod: TQRLabel;
    QRReportPeriod: TQRLabel;
    QRlbRecipes: TQRLabel;
    QRRecipes: TQRLabel;
    QRlb_: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
    procedure PageFooterBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure PageHeaderBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
  private
    FReport : TQuickRep;
    ReportArray : array of GrdRec;              //Массив для расчета процентных отклонений
    pGrdRec : ^GrdRec;                          //Указатель на структуру расчета процентных отклонений
    ReportBeginTime, ReportEndTime : TDateTime; //Период времени отчета
    RecipeBeginTime, RecipeEndTime : TDateTime; //Период времени одного состава шихты
    ReportSerie : TLineSeries;                  //Тренд шихтогруппы
    ReportSeriesList : TList;                   //Набор трендов
    ReportQuery : TQuery;                       //Запрос к базе данных для формирования трендов
    ReportQueriesList : TList;                  //Набор запросов
    pStorage : ^TStorage;                       //Указатель на объект связи с базой данных
    FGrade : TCoalGrade;                        //Экземпляр шихтогруппы
    PrintingObjects : TList;                    //Контейнер объектов TCoalGrade
    TotalRecipes : byte;                        //Количество составов шихты
    RecipesCount : byte;                        //Счетчик составов шихты
    CurrGrade : byte;                           //Текущая шихтогруппа
    RecipeSumm : single;                        //Суммарный вес угля по данному составу шихты
    procedure SetReport(Value : TQuickRep);
  public
    procedure Initialize(var Value : TStorage; BeginTime, EndTime : TDateTime);
    property Report : TQuickRep read FReport write SetReport;
    procedure Finalize();
  end;

var
  SummForm: TSummForm;

const
  Tag : integer = 0;

implementation

{$R *.DFM}

procedure TSummForm.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;

procedure TSummForm.FormCreate(Sender: TObject);
begin
  SetLength(ReportArray, 0);
  ReportSeriesList := TList.Create;
  ReportQueriesList := TList.Create;
end;

procedure TSummForm.Initialize(var Value : TStorage; BeginTime, EndTime : TDateTime);
var
  ObjEnum : byte;
  SQLString : string;   //Строка запроса
begin
  pStorage := @Value;             //Запомнить указатель на объект связи с базой данных
  ReportBeginTime := BeginTime;   //Запомнить интервал времени отчета
  ReportEndTime := EndTime;
  if pStorage.DONum = 1 then
    QRTitle.Caption := 'поданных на угольные башни №1 и №2 за период:' else
    QRTitle.Caption := 'поданных на угольные башни №3 и №4 за период:';
  RecipesCount := 0;              //Инициализировать счетчик составов шихты
  PrintingObjects := TList.Create;
  //Отбор шихтогрупп для отчета (те, которые были в силосах)
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
  SetLength(ReportArray, PrintingObjects.Count); //Задать размер массива для расчета процентных отклонений
  if pStorage.DONum = 1 then QRChart.Chart.LeftAxis.Maximum := 200 else QRChart.Chart.LeftAxis.Maximum := 400; 
  for ObjEnum := 1 to PrintingObjects.Count do
    begin
      FGrade := PrintingObjects.Items[ObjEnum - 1];
      //Создание и инициализация запросов для формирования трендов
      ReportQueriesList.Add(TQuery.Create(Self));
      ReportQuery := ReportQueriesList[ObjEnum - 1];
      ReportQuery.SessionName := 'MySession';
      ReportQuery.DatabaseName := 'UPC';
      ReportQuery.SQL.Clear;
      pGrdRec := @ReportArray[ObjEnum - 1];
      //Создание трендов для шихтогрупп
      ReportSeriesList.Add(TLineSeries.Create(Self));
      ReportSerie := ReportSeriesList.Items[ObjEnum - 1];
      with ReportSerie do
        begin
          ParentChart := QRChart.Chart;
          DataSource := ReportQuery;
          XValues.ValueSource := 'DAT';
          XValues.DateTime := True;
          YValues.ValueSource:= 'PR_TH';
          SeriesColor := TrendsColors[FGrade.GradeNum];
          Title := FGrade.GradeName;
        end;
      //Запрос на выбор значений для тренда
      SQLString := 'select DAT, PR_TH from grade' + IntToStr(pStorage.DONum) + '_' + IntToStr(FGrade.GradeNum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportBeginTime) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportEndTime) + ''');';
      ReportQuery.SQL.Add(SQLString);
      ReportQuery.Open;
    end;
  QRInfo.Caption := 'УПЦ Весовая станция - ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
//  RecipeBeginTime := ReportBeginTime;   //Задание начала интервала первого состава шихты
end;

procedure TSummForm.QuickRep1BeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  RecipesCount := 0;
  RecipeBeginTime := ReportBeginTime;   //Задание начала интервала первого состава шихты
  RecipeEndTime := RecipeBeginTime;
  Tag := 0;
  TotalRecipes := pStorage.CalcRecipes(ReportBeginTime, ReportEndTime);   //Найти количество составов шихты
  QRRecipes.Caption := IntToStr(TotalRecipes);
  QRReportPeriod.Caption := 'с ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportBeginTime) +
    ' по ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportEndTime);
end;

procedure TSummForm.QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
begin
  //Вывод строк с шихтогруппами
  MoreData := (RecipesCount < TotalRecipes);
  if Tag = 0 then
    begin
      QRGrName.Caption := '';
      QRGrSumm.Caption := '';
      QRGrAs.Caption := '';
      QRGrPart.Caption := '';
      QRGrDelta.Caption := '';
    end else
    begin
      Inc(CurrGrade);
      if (CurrGrade > PrintingObjects.Count) then
        begin
          CurrGrade := 0;
          Inc(RecipesCount);
          Tag := 0;
          QRGrName.Caption := '';
          QRGrSumm.Caption := '';
          QRGrAs.Caption := '';
          QRGrPart.Caption := '';
          QRGrDelta.Caption := '';
          QuickRep1.NewPage;
        end else
        begin
          FGrade := PrintingObjects.Items[CurrGrade - 1];
          pGrdRec := @ReportArray[CurrGrade - 1];
          QRGrName.Caption := FGrade.GradeName;
          QRGrSumm.Caption := Format('%8.1f', [pGrdRec.GrdSumm]);
          QRGrAs.Caption := Format('%8.1f', [pGrdRec.GrdAssign]);
          QRGrPart.Caption := Format('%8.1f', [pGrdRec.GrdPart]);
          QRGrDelta.Caption := Format('%8.1f', [pGrdRec.GrdDelta]);
        end;
    end;
end;

procedure TSummForm.PageFooterBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
  QRRecipeSumm.Caption := Format('%8.1f', [RecipeSumm]);
  Tag := 0;
end;

procedure TSummForm.PageHeaderBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
var
  ObjEnum : byte;
begin
  Tag := 1;
  CurrGrade := 0;
  if RecipeEndTime < ReportEndTime then
    begin
      RecipeEndTime := pStorage.ViewStoredRecipe(RecipeBeginTime, ReportEndTime);
      for ObjEnum := 1 to PrintingObjects.Count do
        begin
          FGrade := PrintingObjects.Items[ObjEnum - 1];
          pGrdRec := @ReportArray[ObjEnum - 1];
          pGrdRec.GrdSumm := pStorage.CalcGradeSumm(FGrade.GradeNum, RecipeBeginTime, RecipeEndTime);
          pGrdRec.GrdAssign := pStorage.StoredRecipeGrade[FGrade.GradeNum];
        end;
      QRPeriod.Caption := 'с ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeBeginTime) +
        ' по ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeEndTime);

      RecipeSumm := 0;
      for ObjEnum := 1 to PrintingObjects.Count do
        begin
          FGrade := PrintingObjects.Items[ObjEnum - 1];
          pGrdRec := @ReportArray[ObjEnum - 1];
          RecipeSumm := RecipeSumm + pGrdRec.GrdSumm;
        end;
      if RecipeSumm <> 0 then
        begin
          for ObjEnum := 1 to PrintingObjects.Count do
            begin
              FGrade := PrintingObjects.Items[ObjEnum - 1];
              pGrdRec := @ReportArray[ObjEnum - 1];
              pGrdRec.GrdPart := pGrdRec.GrdSumm * 100 / RecipeSumm;
              pGrdRec.GrdDelta := pGrdRec.GrdPart - pGrdRec.GrdAssign;
            end;
          QRTotal.Caption := Format('%3.1f', [pStorage.StoredAssignTotal]) + ' т/ч.';
        end;
      RecipeBeginTime := RecipeEndTime;
    end;
end;

procedure TSummForm.Finalize();
var
  i, Count : byte;
begin
  Count := PrintingObjects.Count - 1;
  for i := Count downto 0 do
    begin
      FGrade := PrintingObjects.Items[i];
      PrintingObjects.Delete(i);
      FGrade.Free;
    end;
  PrintingObjects.Free;                                      //Удаление списка объектов
end;

end.
unit Summ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Qrctrls, TeeProcs, TeEngine, Chart, DBChart, QrTee, Series, DBTables,
  Types, Storage, CoalGrade;

type
  GrdRec = record       //Структура для расчета процентных отклонений
    GrdSumm : single;   //Суммарный вес по марке
    GrdPart : single;   //Доля марки в шихте
    GrdAssign : single; //Заданный % участия
    GrdDelta : single;  //Процентное отклонение
  end;

  TSummForm = class(TForm)
    QuickRep1: TQuickRep;
    PageHeaderBand: TQRBand;
    QRlbTitle: TQRLabel;
    QRTitle: TQRLabel;
    QRPeriod: TQRLabel;
    QRlbGrName: TQRLabel;
    QRlbGrSumm: TQRLabel;
    QRlbGrAs: TQRLabel;
    QRlbGrPart: TQRLabel;
    QRlbGrDelta: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRTotal: TQRLabel;
    QRlbTotal: TQRLabel;
    QRlbth: TQRLabel;
    PageFooterBand: TQRBand;
    QRInfo: TQRLabel;
    DetailBand: TQRBand;
    QRGrName: TQRLabel;
    QRGrSumm: TQRLabel;
    QRGrAs: TQRLabel;
    QRGrPart: TQRLabel;
    QRGrDelta: TQRLabel;
    QRChart: TQRChart;
    QRDBChart1: TQRDBChart;
    QRlbRecipeSumm: TQRLabel;
    QRRecipeSumm: TQRLabel;
    QRlbRecipeth: TQRLabel;
    QRlbReportPeriod: TQRLabel;
    QRReportPeriod: TQRLabel;
    QRlbRecipes: TQRLabel;
    QRRecipes: TQRLabel;
    QRlb_: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
    procedure PageFooterBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure PageHeaderBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
  private
    FReport : TQuickRep;
    ReportArray : array of GrdRec;              //Массив для расчета процентных отклонений
    pGrdRec : ^GrdRec;                          //Указатель на структуру расчета процентных отклонений
    ReportBeginTime, ReportEndTime : TDateTime; //Период времени отчета
    RecipeBeginTime, RecipeEndTime : TDateTime; //Период времени одного состава шихты
    ReportSerie : TLineSeries;                  //Тренд шихтогруппы
    ReportSeriesList : TList;                   //Набор трендов
    ReportQuery : TQuery;                       //Запрос к базе данных для формирования трендов
    ReportQueriesList : TList;                  //Набор запросов
    pStorage : ^TStorage;                       //Указатель на объект связи с базой данных
    FGrade : TCoalGrade;                        //Экземпляр шихтогруппы
    PrintingObjects : TList;                    //Контейнер объектов TCoalGrade
    TotalRecipes : byte;                        //Количество составов шихты
    RecipesCount : byte;                        //Счетчик составов шихты
    CurrGrade : byte;                           //Текущая шихтогруппа
    RecipeSumm : single;                        //Суммарный вес угля по данному составу шихты
    procedure SetReport(Value : TQuickRep);
  public
    procedure Initialize(var Value : TStorage; BeginTime, EndTime : TDateTime);
    property Report : TQuickRep read FReport write SetReport;
    procedure Finalize();
  end;

var
  SummForm: TSummForm;

const
  Tag : integer = 0;

implementation

{$R *.DFM}

procedure TSummForm.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;

procedure TSummForm.FormCreate(Sender: TObject);
begin
  SetLength(ReportArray, 0);
  ReportSeriesList := TList.Create;
  ReportQueriesList := TList.Create;
end;

procedure TSummForm.Initialize(var Value : TStorage; BeginTime, EndTime : TDateTime);
var
  ObjEnum : byte;
  SQLString : string;   //Строка запроса
begin
  pStorage := @Value;             //Запомнить указатель на объект связи с базой данных
  ReportBeginTime := BeginTime;   //Запомнить интервал времени отчета
  ReportEndTime := EndTime;
  if pStorage.DONum = 1 then
    QRTitle.Caption := 'поданных на угольные башни №1 и №2 за период:' else
    QRTitle.Caption := 'поданных на угольные башни №3 и №4 за период:';
  RecipesCount := 0;              //Инициализировать счетчик составов шихты
  PrintingObjects := TList.Create;
  //Отбор шихтогрупп для отчета (те, которые были в силосах)
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
  SetLength(ReportArray, PrintingObjects.Count); //Задать размер массива для расчета процентных отклонений
  if pStorage.DONum = 1 then QRChart.Chart.LeftAxis.Maximum := 200 else QRChart.Chart.LeftAxis.Maximum := 400; 
  for ObjEnum := 1 to PrintingObjects.Count do
    begin
      FGrade := PrintingObjects.Items[ObjEnum - 1];
      //Создание и инициализация запросов для формирования трендов
      ReportQueriesList.Add(TQuery.Create(Self));
      ReportQuery := ReportQueriesList[ObjEnum - 1];
      ReportQuery.SessionName := 'MySession';
      ReportQuery.DatabaseName := 'UPC';
      ReportQuery.SQL.Clear;
      pGrdRec := @ReportArray[ObjEnum - 1];
      //Создание трендов для шихтогрупп
      ReportSeriesList.Add(TLineSeries.Create(Self));
      ReportSerie := ReportSeriesList.Items[ObjEnum - 1];
      with ReportSerie do
        begin
          ParentChart := QRChart.Chart;
          DataSource := ReportQuery;
          XValues.ValueSource := 'DAT';
          XValues.DateTime := True;
          YValues.ValueSource:= 'PR_TH';
          SeriesColor := TrendsColors[FGrade.GradeNum];
          Title := FGrade.GradeName;
        end;
      //Запрос на выбор значений для тренда
      SQLString := 'select DAT, PR_TH from grade' + IntToStr(pStorage.DONum) + '_' + IntToStr(FGrade.GradeNum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportBeginTime) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportEndTime) + ''');';
      ReportQuery.SQL.Add(SQLString);
      ReportQuery.Open;
    end;
  QRInfo.Caption := 'УПЦ Весовая станция - ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
//  RecipeBeginTime := ReportBeginTime;   //Задание начала интервала первого состава шихты
end;

procedure TSummForm.QuickRep1BeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  RecipesCount := 0;
  RecipeBeginTime := ReportBeginTime;   //Задание начала интервала первого состава шихты
  RecipeEndTime := RecipeBeginTime;
  Tag := 0;
  TotalRecipes := pStorage.CalcRecipes(ReportBeginTime, ReportEndTime);   //Найти количество составов шихты
  QRRecipes.Caption := IntToStr(TotalRecipes);
  QRReportPeriod.Caption := 'с ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportBeginTime) +
    ' по ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportEndTime);
end;

procedure TSummForm.QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
begin
  //Вывод строк с шихтогруппами
  MoreData := (RecipesCount < TotalRecipes);
  if Tag = 0 then
    begin
      QRGrName.Caption := '';
      QRGrSumm.Caption := '';
      QRGrAs.Caption := '';
      QRGrPart.Caption := '';
      QRGrDelta.Caption := '';
    end else
    begin
      Inc(CurrGrade);
      if (CurrGrade > PrintingObjects.Count) then
        begin
          CurrGrade := 0;
          Inc(RecipesCount);
          Tag := 0;
          QRGrName.Caption := '';
          QRGrSumm.Caption := '';
          QRGrAs.Caption := '';
          QRGrPart.Caption := '';
          QRGrDelta.Caption := '';
          QuickRep1.NewPage;
        end else
        begin
          FGrade := PrintingObjects.Items[CurrGrade - 1];
          pGrdRec := @ReportArray[CurrGrade - 1];
          QRGrName.Caption := FGrade.GradeName;
          QRGrSumm.Caption := Format('%8.1f', [pGrdRec.GrdSumm]);
          QRGrAs.Caption := Format('%8.1f', [pGrdRec.GrdAssign]);
          QRGrPart.Caption := Format('%8.1f', [pGrdRec.GrdPart]);
          QRGrDelta.Caption := Format('%8.1f', [pGrdRec.GrdDelta]);
        end;
    end;
end;

procedure TSummForm.PageFooterBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
  QRRecipeSumm.Caption := Format('%8.1f', [RecipeSumm]);
  Tag := 0;
end;

procedure TSummForm.PageHeaderBandBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
var
  ObjEnum : byte;
begin
  Tag := 1;
  CurrGrade := 0;
  if RecipeEndTime < ReportEndTime then
    begin
      RecipeEndTime := pStorage.ViewStoredRecipe(RecipeBeginTime, ReportEndTime);
      for ObjEnum := 1 to PrintingObjects.Count do
        begin
          FGrade := PrintingObjects.Items[ObjEnum - 1];
          pGrdRec := @ReportArray[ObjEnum - 1];
          pGrdRec.GrdSumm := pStorage.CalcGradeSumm(FGrade.GradeNum, RecipeBeginTime, RecipeEndTime);
          pGrdRec.GrdAssign := pStorage.StoredRecipeGrade[FGrade.GradeNum];
        end;
      QRPeriod.Caption := 'с ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeBeginTime) +
        ' по ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeEndTime);

      RecipeSumm := 0;
      for ObjEnum := 1 to PrintingObjects.Count do
        begin
          FGrade := PrintingObjects.Items[ObjEnum - 1];
          pGrdRec := @ReportArray[ObjEnum - 1];
          RecipeSumm := RecipeSumm + pGrdRec.GrdSumm;
        end;
      if RecipeSumm <> 0 then
        begin
          for ObjEnum := 1 to PrintingObjects.Count do
            begin
              FGrade := PrintingObjects.Items[ObjEnum - 1];
              pGrdRec := @ReportArray[ObjEnum - 1];
              pGrdRec.GrdPart := pGrdRec.GrdSumm * 100 / RecipeSumm;
              pGrdRec.GrdDelta := pGrdRec.GrdPart - pGrdRec.GrdAssign;
            end;
          QRTotal.Caption := Format('%3.1f', [pStorage.StoredAssignTotal]) + ' т/ч.';
        end;
      RecipeBeginTime := RecipeEndTime;
    end;
end;

procedure TSummForm.Finalize();
var
  i, Count : byte;
begin
  Count := PrintingObjects.Count - 1;
  for i := Count downto 0 do
    begin
      FGrade := PrintingObjects.Items[i];
      PrintingObjects.Delete(i);
      FGrade.Free;
    end;
  PrintingObjects.Free;                                      //Удаление списка объектов
end;

end.
