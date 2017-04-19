unit CoalGrade;

interface

uses
  Classes;

type
  TCoalGrade = class  //����� ����� ����
  private
    FGradeNum : byte;     //����� �����
    FGradeName : string;  //������������ �����
    FAssignPc : single;   //������� � ���������
    FAssignTh : single;   //������� � ��/���
    FProdPc : single;     //������������������ � ���������
    FProdTh : single;     //������������������ � ��/���
    FSumm : single;       //��������� ��� � ��
    FDelta : single;
    FLastSumm : array[1..120] of single;
    procedure SetGradeNum(const Value : byte);      //��������� ������ �����
    procedure SetGradeName(const Value : string);   //��������� ������������ �����
    procedure SetAssignPc(const Value : single);    //��������� ������� � ���������
    procedure SetAssignTh(const Value : single);    //��������� ������� � ��/���
    procedure SetProdPc(const Value : single);      //��������� ������������������ � ���������
    procedure SetProdTh(const Value : single);      //��������� ������������������ � ��/���
    procedure SetSumm(const Value : single);        //��������� ���������� ���� � ��
  protected
    { Protected declarations }
  public
    constructor Create;
    procedure CalcDelta;
    property GradeNum : byte read FGradeNum write SetGradeNum;      //����� �����
    property GradeName : string read FGradeName write SetGradeName; //������������ �����
    property AssignPc : single read FAssignPc write SetAssignPc;    //������� � ���������
    property AssignTh : single read FAssignTh write SetAssignTh;    //������� � ��/���
    property ProdPc : single read FProdPc write SetProdPc;          //������������������ � ���������
    property ProdTh : single read FProdTh write SetProdTh;          //������������������ � ��/���
    property Summ : single read FSumm write SetSumm;                //��������� ��� � ��
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
