unit Summ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Qrctrls, TeeProcs, TeEngine, Chart, DBChart, QrTee, Series, DBTables,
  Types, Storage, CoalGrade;

type
  GrdRec = record       //��������� ��� ������� ���������� ����������
    GrdSumm : single;   //��������� ��� �� �����
    GrdPart : single;   //���� ����� � �����
    GrdAssign : single; //�������� % �������
    GrdDelta : single;  //���������� ����������
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
    ReportArray : array of GrdRec;              //������ ��� ������� ���������� ����������
    pGrdRec : ^GrdRec;                          //��������� �� ��������� ������� ���������� ����������
    ReportBeginTime, ReportEndTime : TDateTime; //������ ������� ������
    RecipeBeginTime, RecipeEndTime : TDateTime; //������ ������� ������ ������� �����
    ReportSerie : TLineSeries;                  //����� �����������
    ReportSeriesList : TList;                   //����� �������
    ReportQuery : TQuery;                       //������ � ���� ������ ��� ������������ �������
    ReportQueriesList : TList;                  //����� ��������
    pStorage : ^TStorage;                       //��������� �� ������ ����� � ����� ������
    FGrade : TCoalGrade;                        //��������� �����������
    PrintingObjects : TList;                    //��������� �������� TCoalGrade
    TotalRecipes : byte;                        //���������� �������� �����
    RecipesCount : byte;                        //������� �������� �����
    CurrGrade : byte;                           //������� �����������
    RecipeSumm : single;                        //��������� ��� ���� �� ������� ������� �����
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
  SQLString : string;   //������ �������
begin
  pStorage := @Value;             //��������� ��������� �� ������ ����� � ����� ������
  ReportBeginTime := BeginTime;   //��������� �������� ������� ������
  ReportEndTime := EndTime;
  if pStorage.DONum = 1 then
    QRTitle.Caption := '�������� �� �������� ����� �1 � �2 �� ������:' else
    QRTitle.Caption := '�������� �� �������� ����� �3 � �4 �� ������:';
  RecipesCount := 0;              //���������������� ������� �������� �����
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
  SetLength(ReportArray, PrintingObjects.Count); //������ ������ ������� ��� ������� ���������� ����������
  if pStorage.DONum = 1 then QRChart.Chart.LeftAxis.Maximum := 200 else QRChart.Chart.LeftAxis.Maximum := 400; 
  for ObjEnum := 1 to PrintingObjects.Count do
    begin
      FGrade := PrintingObjects.Items[ObjEnum - 1];
      //�������� � ������������� �������� ��� ������������ �������
      ReportQueriesList.Add(TQuery.Create(Self));
      ReportQuery := ReportQueriesList[ObjEnum - 1];
      ReportQuery.SessionName := 'MySession';
      ReportQuery.DatabaseName := 'UPC';
      ReportQuery.SQL.Clear;
      pGrdRec := @ReportArray[ObjEnum - 1];
      //�������� ������� ��� ����������
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
      //������ �� ����� �������� ��� ������
      SQLString := 'select DAT, PR_TH from grade' + IntToStr(pStorage.DONum) + '_' + IntToStr(FGrade.GradeNum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportBeginTime) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportEndTime) + ''');';
      ReportQuery.SQL.Add(SQLString);
      ReportQuery.Open;
    end;
  QRInfo.Caption := '��� ������� ������� - ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
//  RecipeBeginTime := ReportBeginTime;   //������� ������ ��������� ������� ������� �����
end;

procedure TSummForm.QuickRep1BeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  RecipesCount := 0;
  RecipeBeginTime := ReportBeginTime;   //������� ������ ��������� ������� ������� �����
  RecipeEndTime := RecipeBeginTime;
  Tag := 0;
  TotalRecipes := pStorage.CalcRecipes(ReportBeginTime, ReportEndTime);   //����� ���������� �������� �����
  QRRecipes.Caption := IntToStr(TotalRecipes);
  QRReportPeriod.Caption := '� ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportBeginTime) +
    ' �� ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportEndTime);
end;

procedure TSummForm.QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
begin
  //����� ����� � �������������
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
      QRPeriod.Caption := '� ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeBeginTime) +
        ' �� ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeEndTime);

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
          QRTotal.Caption := Format('%3.1f', [pStorage.StoredAssignTotal]) + ' �/�.';
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
  PrintingObjects.Free;                                      //�������� ������ ��������
end;

end.
unit Summ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Qrctrls, TeeProcs, TeEngine, Chart, DBChart, QrTee, Series, DBTables,
  Types, Storage, CoalGrade;

type
  GrdRec = record       //��������� ��� ������� ���������� ����������
    GrdSumm : single;   //��������� ��� �� �����
    GrdPart : single;   //���� ����� � �����
    GrdAssign : single; //�������� % �������
    GrdDelta : single;  //���������� ����������
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
    ReportArray : array of GrdRec;              //������ ��� ������� ���������� ����������
    pGrdRec : ^GrdRec;                          //��������� �� ��������� ������� ���������� ����������
    ReportBeginTime, ReportEndTime : TDateTime; //������ ������� ������
    RecipeBeginTime, RecipeEndTime : TDateTime; //������ ������� ������ ������� �����
    ReportSerie : TLineSeries;                  //����� �����������
    ReportSeriesList : TList;                   //����� �������
    ReportQuery : TQuery;                       //������ � ���� ������ ��� ������������ �������
    ReportQueriesList : TList;                  //����� ��������
    pStorage : ^TStorage;                       //��������� �� ������ ����� � ����� ������
    FGrade : TCoalGrade;                        //��������� �����������
    PrintingObjects : TList;                    //��������� �������� TCoalGrade
    TotalRecipes : byte;                        //���������� �������� �����
    RecipesCount : byte;                        //������� �������� �����
    CurrGrade : byte;                           //������� �����������
    RecipeSumm : single;                        //��������� ��� ���� �� ������� ������� �����
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
  SQLString : string;   //������ �������
begin
  pStorage := @Value;             //��������� ��������� �� ������ ����� � ����� ������
  ReportBeginTime := BeginTime;   //��������� �������� ������� ������
  ReportEndTime := EndTime;
  if pStorage.DONum = 1 then
    QRTitle.Caption := '�������� �� �������� ����� �1 � �2 �� ������:' else
    QRTitle.Caption := '�������� �� �������� ����� �3 � �4 �� ������:';
  RecipesCount := 0;              //���������������� ������� �������� �����
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
  SetLength(ReportArray, PrintingObjects.Count); //������ ������ ������� ��� ������� ���������� ����������
  if pStorage.DONum = 1 then QRChart.Chart.LeftAxis.Maximum := 200 else QRChart.Chart.LeftAxis.Maximum := 400; 
  for ObjEnum := 1 to PrintingObjects.Count do
    begin
      FGrade := PrintingObjects.Items[ObjEnum - 1];
      //�������� � ������������� �������� ��� ������������ �������
      ReportQueriesList.Add(TQuery.Create(Self));
      ReportQuery := ReportQueriesList[ObjEnum - 1];
      ReportQuery.SessionName := 'MySession';
      ReportQuery.DatabaseName := 'UPC';
      ReportQuery.SQL.Clear;
      pGrdRec := @ReportArray[ObjEnum - 1];
      //�������� ������� ��� ����������
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
      //������ �� ����� �������� ��� ������
      SQLString := 'select DAT, PR_TH from grade' + IntToStr(pStorage.DONum) + '_' + IntToStr(FGrade.GradeNum) + ' where (dat > ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportBeginTime) + ''') and (dat < ''' +
        FormatDateTime('yyyy/mm/dd hh:nn:ss', ReportEndTime) + ''');';
      ReportQuery.SQL.Add(SQLString);
      ReportQuery.Open;
    end;
  QRInfo.Caption := '��� ������� ������� - ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
//  RecipeBeginTime := ReportBeginTime;   //������� ������ ��������� ������� ������� �����
end;

procedure TSummForm.QuickRep1BeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  RecipesCount := 0;
  RecipeBeginTime := ReportBeginTime;   //������� ������ ��������� ������� ������� �����
  RecipeEndTime := RecipeBeginTime;
  Tag := 0;
  TotalRecipes := pStorage.CalcRecipes(ReportBeginTime, ReportEndTime);   //����� ���������� �������� �����
  QRRecipes.Caption := IntToStr(TotalRecipes);
  QRReportPeriod.Caption := '� ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportBeginTime) +
    ' �� ' + FormatDateTime('dd/mm/yyyy hh:nn', ReportEndTime);
end;

procedure TSummForm.QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
begin
  //����� ����� � �������������
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
      QRPeriod.Caption := '� ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeBeginTime) +
        ' �� ' + FormatDateTime('dd/mm/yyyy hh:mm', RecipeEndTime);

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
          QRTotal.Caption := Format('%3.1f', [pStorage.StoredAssignTotal]) + ' �/�.';
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
  PrintingObjects.Free;                                      //�������� ������ ��������
end;

end.
