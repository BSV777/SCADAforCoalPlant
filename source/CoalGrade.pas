unit CoalGrade;

interface

uses
  Classes;

type
  TCoalGrade = class  //Класс марки угля
  private
    FGradeNum : byte;     //Номер марки
    FGradeName : string;  //Наименование марки
    FAssignPc : single;   //Задание в процентах
    FAssignTh : single;   //Задание в тн/час
    FProdPc : single;     //Производительность в процентах
    FProdTh : single;     //Производительность в тн/час
    FSumm : single;       //Набранный вес в тн
    FDelta : single;
    FLastSumm : array[1..120] of single;
    procedure SetGradeNum(const Value : byte);      //Установка номера марки
    procedure SetGradeName(const Value : string);   //Установка наименования марки
    procedure SetAssignPc(const Value : single);    //Установка задания в процентах
    procedure SetAssignTh(const Value : single);    //Установка задания в тн/час
    procedure SetProdPc(const Value : single);      //Установка производительности в процентах
    procedure SetProdTh(const Value : single);      //Установка производительности в тн/час
    procedure SetSumm(const Value : single);        //Установка набранного веса в тн
  protected
    { Protected declarations }
  public
    constructor Create;
    procedure CalcDelta;
    property GradeNum : byte read FGradeNum write SetGradeNum;      //Номер марки
    property GradeName : string read FGradeName write SetGradeName; //Наименование марки
    property AssignPc : single read FAssignPc write SetAssignPc;    //Задание в процентах
    property AssignTh : single read FAssignTh write SetAssignTh;    //Задание в тн/час
    property ProdPc : single read FProdPc write SetProdPc;          //Производительность в процентах
    property ProdTh : single read FProdTh write SetProdTh;          //Производительность в тн/час
    property Summ : single read FSumm write SetSumm;                //Набранный вес в тн
    property Delta : single read FDelta;
  end;

implementation

constructor TCoalGrade.Create;
var
  i : byte;
begin
  inherited Create();
  for i := 1 to 120 do FLastSumm[i] := 0;
end;

procedure TCoalGrade.SetAssignPc(const Value:single);
begin
  FAssignPc := Value;
end;

procedure TCoalGrade.SetAssignTh(const Value:single);
begin
  FAssignTh := Value;
end;

procedure TCoalGrade.SetProdPc(const Value:single);
begin
  FProdPc := Value;
end;

procedure TCoalGrade.SetProdTh(const Value:single);
begin
  FProdTh := Value;
end;

procedure TCoalGrade.SetSumm(const Value:single);
begin
  FSumm := Value;
end;

procedure TCoalGrade.SetGradeNum(const Value : byte);
begin
  FGradeNum := Value;
end;

procedure TCoalGrade.SetGradeName(const Value : string);
begin
  FGradeName := Value;
end;

procedure TCoalGrade.CalcDelta;
var
  i : byte;
begin
  for i := 119 downto 1 do FLastSumm[i + 1] := FLastSumm[i];
  FLastSumm[1] := FSumm;
  FDelta := FLastSumm[1] - FLastSumm[120];
  if FDelta < 0 then FDelta := 0;
end;

end.
unit CoalGrade;

interface

uses
  Classes;

type
  TCoalGrade = class  //Класс марки угля
  private
    FGradeNum : byte;     //Номер марки
    FGradeName : string;  //Наименование марки
    FAssignPc : single;   //Задание в процентах
    FAssignTh : single;   //Задание в тн/час
    FProdPc : single;     //Производительность в процентах
    FProdTh : single;     //Производительность в тн/час
    FSumm : single;       //Набранный вес в тн
    FDelta : single;
    FLastSumm : array[1..120] of single;
    procedure SetGradeNum(const Value : byte);      //Установка номера марки
    procedure SetGradeName(const Value : string);   //Установка наименования марки
    procedure SetAssignPc(const Value : single);    //Установка задания в процентах
    procedure SetAssignTh(const Value : single);    //Установка задания в тн/час
    procedure SetProdPc(const Value : single);      //Установка производительности в процентах
    procedure SetProdTh(const Value : single);      //Установка производительности в тн/час
    procedure SetSumm(const Value : single);        //Установка набранного веса в тн
  protected
    { Protected declarations }
  public
    constructor Create;
    procedure CalcDelta;
    property GradeNum : byte read FGradeNum write SetGradeNum;      //Номер марки
    property GradeName : string read FGradeName write SetGradeName; //Наименование марки
    property AssignPc : single read FAssignPc write SetAssignPc;    //Задание в процентах
    property AssignTh : single read FAssignTh write SetAssignTh;    //Задание в тн/час
    property ProdPc : single read FProdPc write SetProdPc;          //Производительность в процентах
    property ProdTh : single read FProdTh write SetProdTh;          //Производительность в тн/час
    property Summ : single read FSumm write SetSumm;                //Набранный вес в тн
    property Delta : single read FDelta;
  end;

implementation

constructor TCoalGrade.Create;
var
  i : byte;
begin
  inherited Create();
  for i := 1 to 120 do FLastSumm[i] := 0;
end;

procedure TCoalGrade.SetAssignPc(const Value:single);
begin
  FAssignPc := Value;
end;

procedure TCoalGrade.SetAssignTh(const Value:single);
begin
  FAssignTh := Value;
end;

procedure TCoalGrade.SetProdPc(const Value:single);
begin
  FProdPc := Value;
end;

procedure TCoalGrade.SetProdTh(const Value:single);
begin
  FProdTh := Value;
end;

procedure TCoalGrade.SetSumm(const Value:single);
begin
  FSumm := Value;
end;

procedure TCoalGrade.SetGradeNum(const Value : byte);
begin
  FGradeNum := Value;
end;

procedure TCoalGrade.SetGradeName(const Value : string);
begin
  FGradeName := Value;
end;

procedure TCoalGrade.CalcDelta;
var
  i : byte;
begin
  for i := 119 downto 1 do FLastSumm[i + 1] := FLastSumm[i];
  FLastSumm[1] := FSumm;
  FDelta := FLastSumm[1] - FLastSumm[120];
  if FDelta < 0 then FDelta := 0;
end;

end.
