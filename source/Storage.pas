unit Storage;

interface

uses
  Classes, DBTables, SysUtils, Types, Batcher, CoalGrade;

type
  TStorage = class(TComponent)
  private
    FDONum : byte;
    FMaxBatchCounter : byte;
    FCoalGradesList : TList;                            //��������� �������� TCoalGrade
    FGradesCount : byte; //���������� ���������� � ����
    FGrade : TCoalGrade;
    FCurrentRecipeGrade : array of single;
    FRecipeGrade1 : array of single;
    FRecipeGrade2 : array of single;
    FStoredRecipeGrade : array of single;
    FGrades : array of byte;                     //������ ����� � ���������
    FGradeNames : array of string;               //������������ �����
    FState : array of TState;                    //��������� ��������
    FWrk : array of boolean;                     //���� - � ������
    FCurrentAssignTotal : single;
    FAssignTotal1 : single;
    FAssignTotal2 : single;
    FStoredAssignTotal : single;
    FRecipeNo : byte;
    Query1 : TQuery;                                    //��������� TQuery
    function TestTable(const Value : string) : boolean; //��������� ������� ������� � ����
    procedure CreateTable(const Value : string); //������� �������
    function GetGrades(Index : byte) : byte;            //������ ����� ����� ���� � ��������
    procedure SetGrades(Index : byte; Value : byte);    //���������� ����� ����� ���� � ��������
    function GetCurrentRecipeGrade(Index : byte) : single;
    procedure SetCurrentRecipeGrade(Index : byte; Value : single);
    function GetRecipeGrade1(Index : byte) : single;
    procedure SetRecipeGrade1(Index : byte; Value : single);
    function GetRecipeGrade2(Index : byte) : single;
    procedure SetRecipeGrade2(Index : byte; Value : single);
    function GetStoredRecipeGrade(Index : byte) : single;
    function GetGradeNames(Index : byte) : string;      //������ ������������ ����� � ����
    function GetState(Index : byte) : TState;           //������ �������� ��������
    procedure SetState(Index : byte; Value : TState);   //���������� �������� ��������
    function GetWrk(Index : byte) : boolean;            //������ ����
    procedure SetWrk(Index : byte; Value : boolean);    //���������� ����
  protected
    { Protected declarations }
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Initialize(Value : byte);   //���������������� ������
    procedure SaveConfig;                 //��������� ������������
    procedure LoadLastConfig;             //�������� ��������� ������������
    procedure CreateGrades;               //������� ������� - �����������
    procedure DeleteGrades;               //������� ������� - �����������
    procedure SaveBat(var Value : TList;
      Pr_t_k, Pr_p_k, Weight_k : single; Worktime_k : integer); //�������� ��������� ��������� � �������� ���������
    procedure SaveGrd;                    //�������� ��������� ����������
    procedure SaveCurrentRecipe;          //��������� � ���� ������� ������
    procedure UpdateRecipes;              //��������� � ���� ��� ������� �����
    procedure LoadGradesList;             //��������� (����������) �� ���� �������� ����������
    procedure AddGrade(Value : string);

    function CalcGradeSumm(GrdNum : byte; BeginTime, EndTime : TDateTime) : single;
              //��������� ��������� ����� ���� ������ ����������� ����������� �� ������
    function CalcBatchSumm(BatchNum : byte; BeginTime, EndTime : TDateTime) : single;
              //��������� ��������� ����� ���� ����������� ��������� �� ������
    function CalcConvSumm(BeginTime, EndTime : TDateTime) : single;
              //��������� ��������� ����� ���� ����������� ������� ���������� �� ������
    function CalcRecipes(BeginTime, EndTime : TDateTime) : byte;
              //����� ���������� �������� �� ������
    function CalcBatchTime(BatchNum : byte; BeginTime, EndTime : TDateTime) : integer;
              //��������� ����� ������ �������� �� ������
    function ViewStoredRecipe(BeginTime, EndTime : TDateTime) : TDateTime;
              //����� ����� ��������� �������� ������� � BeginTime � �� EndTime ������������
    function ViewStoredConfig(BatchNum : byte; BeginTime, EndTime : TDateTime; var StoredBatchGrade : byte) : TDateTime;
              //����� ����� ���� � �������� � ����� � ��������� ������� � BeginTime � �� EndTime ������������
    function ViewStoredBatchers(BatchNum : byte; BeginTime, EndTime : TDateTime; var StoredBatchAssign : single) : TDateTime;
              //����� ������� �� ������������������ �������� � ����� ��� ��������� ������� � BeginTime � �� EndTime ������������
    function GradeWasLoaded(GradeNum : byte; BeginTime, EndTime : TDateTime) : boolean;
              //����������, ���� �� ������ ����������� ��������� ���� �� � ���� ������� � ������ ������ �������
    property DONum : byte read FDONum; //����� ������������� ���������
    property MaxBatchCounter : byte read FMaxBatchCounter; //���������� ��������� � ������������ ���������
    property Grades[Index : byte] : byte read GetGrades write SetGrades; //����� ����������� � ��������
    property GradesCount : byte read FGradesCount; //���������� ���������� � ����
    property CurrentRecipeGrade[Index : byte] : single read GetCurrentRecipeGrade write SetCurrentRecipeGrade;
              //
    property RecipeGrade1[Index : byte] : single read GetRecipeGrade1 write SetRecipeGrade1;
    property RecipeGrade2[Index : byte] : single read GetRecipeGrade2 write SetRecipeGrade2;
    property StoredRecipeGrade[Index : byte] : single read GetStoredRecipeGrade;
    property GradeNames[Index : byte] : string read GetGradeNames; //������������ ���������� � ����
    property State[Index : byte] : TState read GetState write SetState;          //��������� ��������
    property Wrk[Index : byte] : boolean read GetWrk write SetWrk;               //���� - � ������
    property CurrentAssignTotal : single read FCurrentAssignTotal write FCurrentAssignTotal;
    property AssignTotal1 : single read FAssignTotal1 write FAssignTotal1;
    property AssignTotal2 : single read FAssignTotal2 write FAssignTotal2;
    property StoredAssignTotal : single read FStoredAssignTotal;
    property RecipeNo : byte read FRecipeNo write FRecipeNo;
    property CoalGradesList : TList read FCoalGradesList;
end;

implementation

constructor TStorage.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  DecimalSeparator := '.';
  Query1 := TQuery.Create(Self);
  Query1.SessionName := 'MySession';
  Query1.DatabaseName := 'UPC';
end;

destructor TStorage.Destroy;
begin
  Query1.Close;
  Query1.Destroy;
  CoalGradesList.Free;
  inherited Destroy;
end;

procedure TStorage.Initialize(Value : byte); //���������������� ������
var
  i, GradesCount : byte;
begin
  //����������� ��� ������� ���������
  FDONum := Value;
  if FDONum = 1 then FMaxBatchCounter := 14 else FMaxBatchCounter := 16;
  SetLength(FGrades, FMaxBatchCounter + 1);
  SetLength(FState, FMaxBatchCounter + 1);
  SetLength(FWrk, FMaxBatchCounter + 1);
  if not TestTable('COAL') then CreateTable('COAL');
  if not TestTable('recipe' + IntToStr(FDONum)) then CreateTable('recipe'+ IntToStr(FDONum));
  if not TestTable('recipes' + IntToStr(FDONum)) then CreateTable('recipes' + IntToStr(FDONum));
  if not TestTable('config' + IntToStr(FDONum)) then CreateTable('config'+ IntToStr(FDONum));
  if not TestTable('batchers' + IntToStr(FDONum)) then CreateTable('batchers' + IntToStr(FDONum));
  Query1.SQL.Clear;
  Query1.SQL.Add('select count(*) from COAL;');
  Query1.Open;
  GradesCount := Query1.Fields.FieldByNumber(1).AsInteger;
  Query1.Close;
  for i := 1 to GradesCount do if not TestTable('grade' + IntToStr(FDONum) + '_' + IntToStr(i)) then
    CreateTable('grade' + IntToStr(FDONum) +'_' + IntToStr(i));
  FCoalGradesList := TList.Create;

  LoadGradesList;

  LoadLastConfig;

  CreateGrades;
end;

function TStorage.TestTable(const Value : string) : boolean; //��������� ������� ������� � ����
begin
  //����������� ��� ������� ���������
  Query1.SQL.Clear;
  Query1.SQL.Add('select count(*) from SYSCATALOG where tname=''' + Value + ''';');
  Query1.Open;
  if Query1.Fields.FieldByNumber(1).AsInteger <> 0 then Result := True else Result := False;
  Query1.Close;
end;

procedure TStorage.CreateTable(const Value : string); //������� �������
var
  i : byte;
  s : string;
begin
  //����������� ��� ������� ���������
  if Value = 'COAL' then
    begin
      Query1.SQL.Clear;
      Query1.SQL.Add('create table COAL(grade smallint not null, name varchar(15), density float, primary key(grade));');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(1, ''����������'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(2, ''���������'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(3, ''����'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(4, ''��������������'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(5, ''����������'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(6, ''���������'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(7, ''�����������'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(8, ''��������-�9'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(9, ''��������-�'', 0);');
      Query1.ExecSQL;
      Query1.SQL.Clear;
      Query1.SQL.Add('insert into COAL values(10, ''��������������'', 0);');
      Query1.ExecSQL;
    end;
  if copy(Value, 1, 6) = 'recipe' then
    begin
      Query1.SQL.Clear;
      s:='create table recipe' + IntToStr(FDONum) + '(dat timestamp not null, AsTot float';
      for i := 1 to 10 do s := s + ', grade_' + IntToStr(i) + ' float';
      s := s + ',primary key(dat));';
      Query1.SQL.Add(s);
      Query1.ExecSQL;
      Query1.SQL.Clear;
      s := 'insert into recipe' + IntToStr(FDONum) + ' values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + ''',900,' +
      '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0);';
      Query1.SQL.Add(s);
      Query1.ExecSQL;
    end;
  if copy(Value, 1, 7) = 'recipes' then
    begin
      Query1.SQL.Clear;
      s:='create table recipes' + IntToStr(FDONum) + '(recipe_no smallint not null, AsTot float';
      for i := 1 to 10 do s := s + ', grade_' + IntToStr(i) + ' float';
      s := s + ',primary key(recipe_no));';
      Query1.SQL.Add(s);
      Query1.ExecSQL;
      Query1.SQL.Clear;
      s := 'insert into recipes' + IntToStr(FDONum) + ' values(1,600,' +
      '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0);';
      Query1.SQL.Add(s);
      Query1.ExecSQL;
      Query1.SQL.Clear;
      s := 'insert into recipes' + IntToStr(FDONum) + ' values(2,900,' +
      '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0,' + '0,0,0,0);';
      Query1.SQL.Add(s);
      Query1.ExecSQL;
    end;
  if copy(Value, 1, 6) = 'config' then
    begin
      s:='create table config' + IntToStr(FDONum) + '(dat timestamp not null';
      for i := 1 to FMaxBatchCounter do s := s + ', state_' + IntToStr(i) + ' smallint,  wrk_' + IntToStr(i) +
        ' smallint,  grade_' + IntToStr(i) + ' smallint';
      s := s + ', recipe_no smallint, state_k smallint, wrk_k smallint, primary key(dat));';
      Query1.SQL.Clear;
      Query1.SQL.Add(s);
      Query1.ExecSQL;
      case FDONum of
        1:  s := 'insert into config1 values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + ''',' +
              '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' +
              '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1, 0,0, 1);';
        2:  s := 'insert into config2 values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + ''',' +
              '0,0,1,' + '3,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' +
              '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,' + '0,0,1,  0,0, 1);';
      end;
      Query1.SQL.Clear;
      Query1.SQL.Add(s);
      Query1.ExecSQL;
    end;
  if copy(Value, 1, 8) = 'batchers' then
    begin
      s := 'create table batchers' + IntToStr(FDONum) + '(dat timestamp not null';
      for i := 1 to FMaxBatchCounter do s := s + ', as_th_' + IntToStr(i) + ' float, pr_th_' + IntToStr(i) +
        ' float, weight_' + IntToStr(i) + ' float, worktime_' + IntToStr(i) + ' integer';
      s := s + ', pr_t_k float, pr_p_k float, weight_k float, worktime_k integer, primary key(dat));';
      Query1.SQL.Clear;
      Query1.SQL.Add(s);
      Query1.ExecSQL;
    end;
  if copy(Value, 1, 5) = 'grade' then
    begin
      s:='create table ' + Value +
        '(dat timestamp not null, as_pc float, as_th float, pr_pc float, pr_th float, weight float, primary key(dat));';
      Query1.SQL.Clear;
      Query1.SQL.Add(s);
      Query1.ExecSQL;
    end;
  Query1.Close;
end;

function TStorage.GetGrades(Index : byte) : byte;
begin
  Result := FGrades[Index];
end;

procedure TStorage.SetGrades(Index : byte; Value : byte);
begin
  FGrades[Index] := Value;
end;

function TStorage.GetState(Index : byte) : TState;
begin
  Result := FState[Index];
end;

procedure TStorage.SetState(Index : byte; Value : TState);
begin
  FState[Index] := Value;
end;

function TStorage.GetWrk(Index : byte) : boolean;
begin
  Result := FWrk[Index];
end;

procedure TStorage.SetWrk(Index : byte; Value : boolean);
begin
  FWrk[Index] := Value;
end;

procedure TStorage.SaveConfig; //��������� ������������
var
  i : byte;
  s : string;
begin
  //����������� ��� ��������� ����������� � ���������, ��� ������� � �������� ������� � �������� ���������,
  //��� ��������� ��������� � ������ �����
  DecimalSeparator := '.';
  s := 'insert into config' + IntToStr(FDONum) + ' values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + '''';
  for i := 1 to FMaxBatchCounter do
    begin
      s := s + ',';
      case FState[i] of
        stOk: s := s + '0,';
        stSenErr: s := s + '1,';
        stNetErr: s := s + '2,';
        stNotMnt: s := s + '3,';
      end;
      if FWrk[i] then s := s + '1,' else s := s + '0,';
      s := s + IntToStr(FGrades[i]);
    end;
  s := s + ',' + IntToStr(RecipeNo) + ',0,0);';
  Query1.SQL.Clear;
  Query1.SQL.Add(s);
  Query1.ExecSQL;
  Query1.Close;
end;

procedure TStorage.SaveBat(var Value : TList; Pr_t_k, Pr_p_k, Weight_k : single; Worktime_k : integer); //�������� ��������� ���������
var
  i : byte;
  s : string;
  Batch : TBatcher;
begin
  //����������� ���������� ��� � 10 ���.
  DecimalSeparator := '.';
  s := 'insert into batchers' + IntToStr(FDONum) + ' values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + '''';
  for i := 1 to FMaxBatchCounter do
    begin
      Batch := Value.Items[i - 1];
      s := s + ',' + FloatToStr(Batch.Assigned) + ',' + FloatToStr(Batch.ProdTh) + ',' + FloatToStr(Batch.Summ)+ ',' + IntToStr(Batch.Time);
    end;
  s := s + ',' + FloatToStr(Pr_t_k) + ',' + FloatToStr(Pr_p_k) + ',' + FloatToStr(Weight_k) + ',' + IntToStr(Worktime_k) + ');';
  Query1.SQL.Clear;
  Query1.SQL.Add(s);
  Query1.ExecSQL;
  Query1.Close;
end;

procedure TStorage.SaveGrd; //�������� ��������� ����������
var
  i : byte;
  s : string;
begin
  //����������� ���������� ��� � 30 ���.
  DecimalSeparator := '.';
  Query1.SQL.Clear;
  for i := 1 to FCoalGradesList.Count do
    begin
      FGrade := FCoalGradesList.Items[i - 1];
      s := 'insert into grade' + IntToStr(FDONum) + '_' + IntToStr(FGrade.GradeNum) + ' values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + '''';
      s := s + ',' + FloatToStr(FGrade.AssignPc) + ',' +
      FloatToStr(FGrade.AssignTh) + ',' + FloatToStr(FGrade.ProdPc) + ',' +
      FloatToStr(FGrade.ProdTh) + ',' + FloatToStr(FGrade.Summ) + ');';
      Query1.SQL.Add(s);
    end;
    Query1.ExecSQL;
    Query1.Close;
end;

procedure TStorage.LoadLastConfig; //�������� ��������� ������������
var
  i : byte;
begin
  //����������� ��� ������� ���������
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from config' + IntToStr(FDONum) + ' where config' + IntToStr(FDONum) + '.dat=(select max(dat) from config' + IntToStr(FDONum) + ');');
  Query1.Open;
  for i := 1 to FMaxBatchCounter do
    begin
      FGrades[i] := Query1.Fields.FieldByName('grade_' + IntToStr(i)).AsInteger;
      case Query1.Fields.FieldByName('state_' + IntToStr(i)).AsInteger of
        0: FState[i] := stOk;
        1: FState[i] := stSenErr;
        2: FState[i] := stNetErr;
        3: FState[i] := stNotMnt;
      end;
      if Query1.Fields.FieldByName('wrk_' + IntToStr(i)).AsInteger = 0 then FWrk[i] := False else FWrk[i] := True;
    end;
  FRecipeNo := Query1.Fields.FieldByName('recipe_no').AsInteger;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from recipe' + IntToStr(FDONum) + ' where recipe' + IntToStr(FDONum) + '.dat=(select max(dat) from recipe' + IntToStr(FDONum) + ');');
  Query1.Open;
  for i := 1 to FGradesCount do FCurrentRecipeGrade[i] := Query1.Fields.FieldByName('grade_' + IntToStr(i)).AsFloat;
  FCurrentAssignTotal := Query1.Fields.FieldByName('AsTot').AsFloat;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from recipes' + IntToStr(FDONum) + ' where recipe_no = 1;');
  Query1.Open;
  for i := 1 to FGradesCount do FRecipeGrade1[i] := Query1.Fields.FieldByName('grade_' + IntToStr(i)).AsFloat;
  FAssignTotal1 := Query1.Fields.FieldByName('AsTot').AsFloat;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from recipes' + IntToStr(FDONum) + ' where recipe_no = 2;');
  Query1.Open;
  for i := 1 to FGradesCount do FRecipeGrade2[i] := Query1.Fields.FieldByName('grade_' + IntToStr(i)).AsFloat;
  FAssignTotal2 := Query1.Fields.FieldByName('AsTot').AsFloat;
  Query1.Close;
end;

function TStorage.GetGradeNames(Index : byte) : string;
begin
  Result := FGradeNames[Index];
end;

function TStorage.GetCurrentRecipeGrade(Index : byte) : single;
begin
  Result := FCurrentRecipeGrade[Index];
end;

procedure TStorage.SetCurrentRecipeGrade(Index : byte; Value : single);
begin
  FCurrentRecipeGrade[Index] := Value;
end;

function TStorage.GetRecipeGrade1(Index : byte) : single;
begin
  Result := FRecipeGrade1[Index];
end;

procedure TStorage.SetRecipeGrade1(Index : byte; Value : single);
begin
  FRecipeGrade1[Index] := Value;
end;

function TStorage.GetRecipeGrade2(Index : byte) : single;
begin
  Result := FRecipeGrade2[Index];
end;

function TStorage.GetStoredRecipeGrade(Index : byte) : single;
begin
  Result := FStoredRecipeGrade[Index];
end;

procedure TStorage.SetRecipeGrade2(Index : byte; Value : single);
begin
  FRecipeGrade2[Index] := Value;
end;

procedure TStorage.SaveCurrentRecipe; //��������� � ���� ������� ������
var
  i : byte;
  s : string;
begin
  //����������� ��� ��������� �������� �����
  Query1.SQL.Clear;
  s := 'insert into recipe' + IntToStr(FDONum) + ' values(''' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) +
    ''',' + Format('%3.1f', [FCurrentAssignTotal]);
  for i := 1 to High(FCurrentRecipeGrade) do s := s + ',' + Format('%3.1f', [FCurrentRecipeGrade[i]]);
  s := s +');';
  Query1.SQL.Add(s);
  Query1.ExecSQL;
end;

procedure TStorage.UpdateRecipes; //��������� � ���� ��� ������� �����
var
  i : byte;
  s : string;
begin
  //����������� ��� ��������� �������� �����
  Query1.SQL.Clear;
  s := 'update recipes' + IntToStr(FDONum) + ' set AsTot = ' + Format('%3.1f', [FAssignTotal1]);
  for i := 1 to High(FRecipeGrade1) do s := s + ', grade_' + IntToStr(i) + ' = ' + Format('%3.1f', [FRecipeGrade1[i]]);
  s := s +'where recipe_no = 1;';
  Query1.SQL.Add(s);
  Query1.ExecSQL;
  Query1.SQL.Clear;
  s := 'update recipes' + IntToStr(FDONum) + ' set AsTot = ' + Format('%3.1f', [FAssignTotal2]);
  for i := 1 to High(FRecipeGrade2) do s := s + ', grade_' + IntToStr(i) + ' = ' + Format('%3.1f', [FRecipeGrade2[i]]);
  s := s +'where recipe_no = 2;';
  Query1.SQL.Add(s);
  Query1.ExecSQL;
end;

function TStorage.CalcGradeSumm(GrdNum : byte; BeginTime, EndTime : TDateTime) : single;
//��������� ��������� ����� ���� ������ ����������� ����������� �� ������
var
  i : integer;
  S1 : single;  //������ �������
  S2 : single;  //����� �������
  Summ : single;
begin
  //����������� ��� ������������ ������ � ������������
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, weight from grade' + IntToStr(FDONum) + '_' +
    IntToStr(GrdNum) + ' where ((dat >= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) + ''') and (weight <> 0)) order by dat;');
  Query1.Open;
  Query1.First;
  if Query1.RecordCount > 1 then
    begin
      S1 := Query1.Fields.FieldByName('weight').AsFloat;
      Summ := -S1;  //�������� ��������� ����� ���������
      for i := 1 to Query1.RecordCount - 2 do
        begin
          S2 := S1;
          S1 := Query1.Fields.FieldByName('weight').AsFloat;
          if S1 - S2 < -1 then
            begin
              Summ := Summ + S2 - S1;
            end;
          Query1.Next;
        end;
      Summ := Summ + S1;
      Query1.Close;
    end else Summ := 0;
  Result := Summ;
end;

function TStorage.CalcBatchSumm(BatchNum : byte; BeginTime, EndTime : TDateTime) : single;
//��������� ��������� ����� ���� ����������� ��������� �� ������
var
  i : integer;
  S1 : single;  //������ �������
  S2 : single;  //����� �������
  Summ : single;
begin
  //����������� ��� ������������ ������ � ���������
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, weight_' + IntToStr(BatchNum) + ' from batchers' + IntToStr(FDONum) + '' +
    ' where ((dat >= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and (weight_' + IntToStr(BatchNum) + ' <> 0)) order by dat;');
  Query1.Open;
  Query1.First;
  if Query1.RecordCount > 1 then
    begin
      S1 := Query1.Fields.FieldByName('weight_' + IntToStr(BatchNum)).AsFloat;
      Summ := -S1;  //�������� ��������� ����� ���������
      for i := 1 to Query1.RecordCount - 2 do
        begin
          S2 := S1;
          S1 := Query1.Fields.FieldByName('weight_' + IntToStr(BatchNum)).AsFloat;
          if S1 - S2 < -1 then
            begin
              Summ := Summ + S2 - S1;
            end;
          Query1.Next;
        end;
      Summ := Summ + S1;
      Query1.Close;
    end else Summ := 0;
  Result := Summ;
end;

function TStorage.CalcConvSumm(BeginTime, EndTime : TDateTime) : single;
//��������� ��������� ����� ���� ����������� ������� ���������� �� ������
var
  i : integer;
  S1 : single;  //������ �������
  S2 : single;  //����� �������
  Summ : single;
begin
  //����������� ��� ������������ �������
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, weight_k from batchers' + IntToStr(FDONum) + '' +
    ' where ((dat >= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and (weight_k <> 0)) order by dat;');
  Query1.Open;
  Query1.First;
  if Query1.RecordCount > 1 then
    begin
      S1 := Query1.Fields.FieldByName('weight_k').AsFloat;
      Summ := -S1;  //�������� ��������� ����� ���������
      for i := 1 to Query1.RecordCount - 2 do
        begin
          S2 := S1;
          S1 := Query1.Fields.FieldByName('weight_k').AsFloat;
          if S1 - S2 < -1 then
            begin
              Summ := Summ + S2 - S1;
            end;
          Query1.Next;
        end;
      Summ := Summ + S1;
      Query1.Close;
    end else Summ := 0;
  Result := Summ;
end;

function TStorage.CalcBatchTime(BatchNum : byte; BeginTime, EndTime : TDateTime) : integer;
//��������� ����� ������ �������� �� ������
var
  i : integer;
  T1 : integer;  //������ �������
  T2 : integer;  //����� �������
  SummT : integer;
begin
  //����������� ��� ������������ ������ � ���������
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, worktime_' + IntToStr(BatchNum) + ' from batchers' + IntToStr(FDONum) + '' +
    ' where ((dat >= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and (worktime_' + IntToStr(BatchNum) + ' <> 0)) order by dat;');
  Query1.Open;
  Query1.First;
  if Query1.RecordCount > 1 then
    begin
      T1 := Query1.Fields.FieldByName('worktime_' + IntToStr(BatchNum)).AsInteger;
      SummT := -T1;  //�������� ��������� ����� ���������
      for i := 1 to Query1.RecordCount - 2 do
        begin
          T2 := T1;
          T1 := Query1.Fields.FieldByName('worktime_' + IntToStr(BatchNum)).AsInteger;
          if T1 - T2 < -1 then
            begin
              SummT := SummT + T2 - T1;
            end;
          Query1.Next;
        end;
      SummT := SummT + T1;
      Query1.Close;
    end else SummT := 0;
  Result := SummT;
end;

function TStorage.ViewStoredRecipe(BeginTime, EndTime : TDateTime) : TDateTime;
//����� ����� ��������� �������� ������� � BeginTime � �� EndTime ������������
var
  i : byte;
  RecipeEndTime : TDateTime;
begin
  //����������� ��� ������������ ������ �� ������������
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from recipe' + IntToStr(FDONum) + ' where recipe' + IntToStr(FDONum) + '.dat=(select max(dat) from recipe' + IntToStr(FDONum) + ' where dat <= ''' +
    FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) + ''');');
  Query1.Open;
  for i := 1 to FGradesCount do FStoredRecipeGrade[i] := Query1.Fields.FieldByName('grade_' + IntToStr(i)).AsFloat;
  FStoredAssignTotal := Query1.Fields.FieldByName('AsTot').AsFloat;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat from recipe' + IntToStr(FDONum) + ' where recipe' + IntToStr(FDONum) + '.dat=(select min(dat) from recipe' + IntToStr(FDONum) + ' where dat > '''+
    FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) + ''');');
  Query1.Open;
  if Query1.RecordCount = 0 then RecipeEndTime := EndTime else
  RecipeEndTime := Query1.Fields.FieldByName('dat').AsDateTime;
  Query1.Close;
  if RecipeEndTime <= EndTime then Result := RecipeEndTime else Result := EndTime;
end;

function TStorage.ViewStoredConfig(BatchNum : byte; BeginTime, EndTime : TDateTime; var StoredBatchGrade : byte) : TDateTime;
//����� ����� ���� � �������� � ����� � ��������� ������� � BeginTime � �� EndTime ������������
begin
  //����������� ��� ������������ ������ �� ���������
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, grade_' + IntToStr(BatchNum) + ' from config' + IntToStr(FDONum) +
    ' where (dat=(select max(dat) from config' + IntToStr(FDONum) + ' where dat <= ''' +
    FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) + '''));');
  Query1.Open;
  StoredBatchGrade := Query1.Fields.FieldByName('grade_' + IntToStr(BatchNum)).AsInteger;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, grade_' + IntToStr(BatchNum) + ' from config' + IntToStr(FDONum) +
    ' where (dat=(select min(dat) from config' + IntToStr(FDONum) +
    ' where (dat > ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and (grade_' + IntToStr(BatchNum) + ' <> ' + IntToStr(StoredBatchGrade) + ')));');
  Query1.Open;
  if Query1.RecordCount = 0 then Result := EndTime else Result := Query1.Fields.FieldByName('dat').AsDateTime;
  Query1.Close;
end;

function TStorage.ViewStoredBatchers(BatchNum : byte; BeginTime, EndTime : TDateTime; var StoredBatchAssign : single) : TDateTime;
//����� ������� �� ������������������ �������� � ����� ��� ��������� ������� � BeginTime � �� EndTime ������������
begin
  //����������� ��� ������������ ������ � ���������
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, as_th_' + IntToStr(BatchNum) + ' from batchers' + IntToStr(FDONum) +
    ' where (dat=(select min(dat) from batchers' + IntToStr(FDONum) +
    ' where (dat >= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and (as_th_' + IntToStr(BatchNum) + ' <> 0)));');
  Query1.Open;
  StoredBatchAssign := Query1.Fields.FieldByName('as_th_' + IntToStr(BatchNum)).AsFloat;
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select dat, as_th_' + IntToStr(BatchNum) + ' from batchers' + IntToStr(FDONum) +
    ' where (dat=(select min(dat) from batchers' + IntToStr(FDONum) +
    ' where (dat > ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and (as_th_' + IntToStr(BatchNum) + ' <> 0) and ((as_th_' + IntToStr(BatchNum) + ' < ' +
    FloatToStr(StoredBatchAssign - 1) + ') or (as_th_' + IntToStr(BatchNum) + ' > ' +
    FloatToStr(StoredBatchAssign + 1) + '))));');
  Query1.Open;
  if Query1.RecordCount = 0 then Result := EndTime else Result := Query1.Fields.FieldByName('dat').AsDateTime;
  Query1.Close;
end;

function TStorage.GradeWasLoaded(GradeNum : byte; BeginTime, EndTime : TDateTime) : boolean;
//����������, ���� �� ������ ����������� ��������� ���� �� � ���� ������� � ������ ������ �������
var
  s : string;
  i : byte;
begin
  //����������� ��� ������������ ������ � ���������� �������� ����������
  Query1.SQL.Clear;
  s := 'select dat';
  for i := 1 to FMaxBatchCounter do s := s + ',grade_' + IntToStr(i);
  s := s + ' from config' + IntToStr(FDONum) + '' +
    ' where (dat>=(select max(dat) from config' + IntToStr(FDONum) + ' where dat <= ''' +
    FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''')) and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) +
    ''') and ((grade_1' + ' = ' + IntToStr(GradeNum) + ')';
  for i := 2 to FMaxBatchCounter do s := s + ' or (grade_' + IntToStr(i) + ' = ' + IntToStr(GradeNum) + ')';
  s := s + ') order by dat;';
  Query1.SQL.Add(s);
  Query1.Open;
  if Query1.RecordCount <> 0 then Result := True else Result := False;
  Query1.Close;
end;

function TStorage.CalcRecipes(BeginTime, EndTime : TDateTime) : byte; //����� ���������� �������� �� ������
begin
  //����������� ��� ������������ ������
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from recipe' + IntToStr(FDONum) + '' +
    ' where ((dat >= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', BeginTime) +
    ''') and (dat <= ''' + FormatDateTime('yyyy/mm/dd hh:mm:ss', EndTime) + '''));');
  Query1.Open;
  Result := Query1.RecordCount + 1;
  Query1.Close;
end;

procedure TStorage.LoadGradesList; //��������� (����������) �� ���� �������� ����������
var
  i : byte;
begin
  //��������� ������ ������������ ���������� FGradeNames � �� ���������� FGradesCount
  //����������� ��� ������� ��������� � ����� ���������� �����������
  Query1.SQL.Clear;
  Query1.SQL.Add('select * from COAL order by grade');
  Query1.Open;
  FGradesCount := Query1.RecordCount;
  SetLength(FGradeNames, FGradesCount + 1);
  SetLength(FCurrentRecipeGrade, FGradesCount + 1);
  SetLength(FRecipeGrade1, FGradesCount + 1);
  SetLength(FRecipeGrade2, FGradesCount + 1);
  SetLength(FStoredRecipeGrade, FGradesCount + 1);
  Query1.First;
  for i := 1 to FGradesCount do
    begin
      FGradeNames[i] := Query1.Fields.FieldByName('name').AsString;
      Query1.Next;
    end;
  Query1.Close;
end;

procedure TStorage.DeleteGrades; //������� ������� - �����������
var
  i, Count : byte;
begin
  //����������� ��� ��������� ���������� � ��������� � ����� ���������� ����� �����������
  //����� ��������� ��������� �������� - ����������
  Count := FCoalGradesList.Count - 1;
  for i := Count downto 0 do
    begin
      FGrade := FCoalGradesList.Items[i];
      FCoalGradesList.Delete(i);
      FGrade.Free;
    end;
end;

procedure TStorage.CreateGrades; //������� ������� - �����������
var
  i, j : byte;
begin
  //����������� ��� ������� ���������, ��� ��������� ���������� � ���������
  //� ����� ���������� ����� �����������
  //��������� �� �����������, ������� ���� � ���������
  for i := 1 to FGradesCount do
    begin
      j := 0;
      repeat
        j := j + 1;
      until (j > FMaxBatchCounter) or (FGrades[j] = i);
      if j <= FMaxBatchCounter then
        begin
          FGrade := TCoalGrade.Create();
          FCoalGradesList.Add(FGrade);
          FGrade.GradeNum := i;
          FGrade.GradeName := FGradeNames[i];
        end;
    end;
end;

procedure TStorage.AddGrade(Value : string);
begin
  Query1.SQL.Clear;
  Query1.SQL.Add('insert into COAL values(' + IntToStr(FGradesCount + 1) + ', ''' + Value + ''', 0);');
  Query1.ExecSQL;
  Query1.SQL.Clear;
  Query1.SQL.Add('alter table recipe1 add grade_' + IntToStr(FGradesCount + 1) + ' float');
  Query1.ExecSQL;
  Query1.SQL.Clear;
  Query1.SQL.Add('alter table recipes1 add grade_' + IntToStr(FGradesCount + 1) + ' float');
  Query1.ExecSQL;
  Query1.SQL.Clear;
  Query1.SQL.Add('alter table recipe2 add grade_' + IntToStr(FGradesCount + 1) + ' float');
  Query1.ExecSQL;
  Query1.SQL.Clear;
  Query1.SQL.Add('alter table recipes2 add grade_' + IntToStr(FGradesCount + 1) + ' float');
  Query1.ExecSQL;
  Query1.SQL.Clear;
  Query1.SQL.Add('create table grade1_' + IntToStr(FGradesCount + 1) +
    '(dat timestamp not null, as_pc float, as_th float, pr_pc float, pr_th float, weight float, primary key(dat));');
  Query1.ExecSQL;
  Query1.SQL.Clear;
  Query1.SQL.Add('create table grade2_' + IntToStr(FGradesCount + 1) +
    '(dat timestamp not null, as_pc float, as_th float, pr_pc float, pr_th float, weight float, primary key(dat));');
  Query1.ExecSQL;
  Query1.Close;
end;

end.
