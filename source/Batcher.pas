unit Batcher;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls, Types;

type
  TBatcher = class(TCustomPanel)      //����� ���������� ��������
  private
    FNum : byte;                        //����� ��������
    FDONum : byte;                      //����� ���������
    FGrade : byte;                      //����� ����� ���� � ��������
    FGrName : string;                   //������������ ����� ���� � ��������
    FAssigned : single;                 //������� ������������������ � ��/���
    FRecommend : single;                //��������������� ������������������ � ��/���
    FProdTh : single;                   //����������� ����������� ������������������ � ��/���
    FSumm : single;                     //��������� ��� � ��
    FLevel : single;                    //������� (�����) ���� � ������ � ��
    FWeight : single;                   //��� �� �����
    FState : TState;                    //��������� ���������� (� ���������)
    FEnable : boolean;
    FToReport : boolean;                //��������� � ������
    FConv1 : boolean;                   //�������� �������
    FConv2 : boolean;                   //������� �������� �������
    FTime : word;                       //����� ������ �������� � ���
    FOsc : boolean;                     //���� ��������
    imgBat : TImage;                    //����������� �������
    imgConv1 : TImage;                  //����������� ��������� ���������
    imgConv2 : TImage;                  //����������� �������� ���������
    imgCoal : TImage;                   //����������� ���� �� �����
    lbN : TLabel;                       //����� - ����� ��������
    lbGrName : TLabel;                  //����� - ������������ ����� ���� � ��������
    lbAssignTh : TLabel;                //����� - ������� ������������������ � ��/���
    lbProdTh : TLabel;                  //����� - ����������� ����������� ������������������ � ��/���
    lbSumm : TLabel;                    //����� - ��������� ��� � ��
    lbLevel : TLabel;                   //����� - ������� (�����) ���� � ������ � ��
    lbTime: TLabel;                     //����� - ����� ������ ��������
    lbAs : TLabel;                      //����� - '������:'
    lbW : TLabel;                       //����� - '�����:'
    lbTh : TLabel;                      //����� - '�/�'
    lbT1 : TLabel;                      //����� - '�'
    lbT2 : TLabel;                      //����� - '�'
    lbH : TLabel;                       //����� - '�:�'
    procedure SetNum(const Value : byte);           //���������� ������ ��������
    procedure SetDONum(const Value : byte);         //���������� ������ ���������
    procedure SetGrade(const Value : byte);         //���������� ������ ����� ����
    procedure SetGradeColor(const Value : byte);    //���� ������������ ����� ���� � ��������
    procedure SetGrName(const Value : string);      //������� ������������ ����� ����
    procedure SetAssigned(const Value : single);    //������ ������� � ��/���
    procedure SetProdTh(const Value : single);      //������ ������������������ � ��/���
    procedure SetSumm(const Value : single);        //������ ���������� ���� � ��
    procedure SetLevel(const Value : single);       //������ ������ (����) ���� � ������ � ��
    procedure SetWeight(const Value : single);      //������ ���� �� �����
    procedure SetState(const Value : TState);       //��������� ��������� ����������
    procedure SetConv1(const Value : boolean);      //��������� ����� ������ ��������
    procedure SetConv2(const Value : boolean);      //��������� ����� ������ �������� ���������
    procedure SetSelect(const Value : boolean);     //��������� ��������� ����������
    procedure SetTime(const Value : word);          //������ ������� ������
    procedure IndClick(Sender : TObject);           //���������� �������� ������
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Num : byte read FNum write SetNum;                     //����� ��������
    property DONum : byte read FDONum write SetDONum;               //����� ���������
    property Grade : byte read FGrade write SetGrade;               //����� ����� ���� � ��������
    property GradeColor : byte write SetGradeColor;                 //���� ������������ ����� ���� � ��������
    property GrName : string read FGrName write SetGrName;          //������������ ����� ����
    property Assigned : single read FAssigned write SetAssigned;    //������� � ��/���
    property Recommend : single read FRecommend write FRecommend;   //��������������� ������������������ � ��/���
    property ProdTh : single read FProdTh write SetProdTh;          //����������� ����������� ������������������ � ��/���
    property Summ : single read FSumm write SetSumm;                //��������� ��� � ��
    property Level : single read FLevel write SetLevel;             //������� (�����) ���� � ������ � ��
    property Weight : single read FWeight write SetWeight;          //��� �� �����
    property Enable : boolean read FEnable write FEnable;
    property Conv1 : boolean read FConv1 write SetConv1;            //�������� �������
    property Conv2 : boolean read FConv2 write SetConv2;            //������� ����� ��������
    property State : TState read FState write SetState;             //��������� ��������
    property ToReport : boolean read FToReport write FToReport;     //��������� � ������
    property Time : word read FTime write SetTime;                  //����� ������ �������� � ���
    property Select : boolean write SetSelect;                      //��������� ��������� ����������
    property OnClick;                                               //������� - ������ ����
  end;

implementation

constructor TBatcher.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Width := 127;
  Height := 178;
  BevelWidth := 1;
  Caption := '';
  Font.Name := 'MS Sans Serif';
  imgBat := TImage.Create(Self);                //����������� �������
  with imgBat do
    begin
      Parent := Self;
      Left := 12;
      Top := 26;
      AutoSize := True;
      Picture.LoadFromFile('bat.wmf');
    end;
  imgConv1 := TImage.Create(Self);              //����������� ��������� ���������
  with imgConv1 do
    begin
      Parent := Self;
      Left := 4;
      Top := 65;
      AutoSize := True;
      Picture.LoadFromFile('conv1_off.wmf');
    end;
  imgConv2 := TImage.Create(Self);              //����������� �������� ���������
  with imgConv2 do
    begin
      Parent := Self;
      Left := 40;
      Top := 83;
      AutoSize := True;
      Picture.LoadFromFile('conv2_off.wmf');
    end;
  imgCoal := TImage.Create(Self);               //����������� ���� �� �����
  with imgCoal do
    begin
      Parent := Self;
      Left := 60;
      Top := 70;
      AutoSize := True;
      Visible := False;
      Picture.LoadFromFile('coal.wmf');
    end;
  lbN := TLabel.Create(Self);                   //����� - ����� ��������
  with lbN do
    begin
      Parent := Self;
      Left := 5;
      Top := 4;
      AutoSize := True;
      Caption := '0';
      Font.Color := clWhite;
      Font.Size := 10;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  lbGrName := TLabel.Create(Self);              //����� - ������������ ����� ���� � ��������
  with lbGrName do
    begin
      Parent := Self;
      Left := 21;
      Top := 4;
      AutoSize := True;
      Caption := '';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  lbAssignTh := TLabel.Create(Self);            //����� - ������� � ��/���
  with lbAssignTh do
    begin
      Parent := Self;
      Left := 45;
      Top := 145;
      Alignment := taRightJustify;
      AutoSize := False;
      Width := 33;
      Caption := '0';
      Font.Size := 8;
      Font.Style := [fsBold];
    end;
  lbProdTh := TLabel.Create(Self);              //����� - ������������������ � ��/���
  with lbProdTh do
    begin
      Parent := Self;
      Left := 35;
      Top := 110;
      Width := 85;
      Height := 33;
      AutoSize := False;
      Alignment := taRightJustify;
      Caption := '0';
      Font.Size := 24;
      Font.Style := [fsBold];
    end;
  lbSumm := TLabel.Create(Self);                //����� - ��������� ��� � ��
  with lbSumm do
    begin
      Parent := Self;
      Left := 65;
      Top := 160;
      Width := 40;
      Alignment := taRightJustify;
      AutoSize := False;
      Caption := '0';
      Font.Size := 8;
      Font.Style := [fsBold];
    end;
  lbLevel := TLabel.Create(Self);                //����� - ��������� ��� � ��
  with lbLevel do
    begin
      Parent := Self;
      Left := 65;  //14
      Top := 25;  //35
      Alignment := taRightJustify;
      AutoSize := False;
      Width := 40;
      Caption := '0';
      Font.Color := clBlack;
      Font.Size := 8;
      Font.Style := [fsBold];
    end;
  lbTime := TLabel.Create(Self);                //����� - ����� ������ ��������
  with lbTime do
    begin
    Parent := Self;
    Left := 78;
    Top := 48;
    Width := 40;
    Height := 20;
    Alignment := taRightJustify;
    AutoSize := False;
    Caption := '00:00';
    Font.Size := 8;
    Font.Style := [fsBold];
    end;
  lbAs := TLabel.Create(Self);                  //����� - '������:'
  with lbAs do
    begin
      Parent := Self;
      Left := 4;
      Top := 145;
      AutoSize := True;
      Caption := '������:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbW := TLabel.Create(Self);                   //����� - '�����:'
  with lbW do
    begin
      Parent := Self;
      Left := 4;
      Top := 160;
      AutoSize := True;
      Caption := '�����:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbTh := TLabel.Create(Self);                  //����� - '�/�'
  with lbTh do
    begin
      Parent := Self;
      Left := 90;
      Caption := '�/�';
      Top := 145;
      AutoSize := True;
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT1 := TLabel.Create(Self);                   //����� - '�'
  with lbT1 do
    begin
      Parent := Self;
      Left := 110;
      Top := 160;
      Width := 18;
      Height := 20;
      Caption := '�';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT2 := TLabel.Create(Self);                   //����� - '�'
  with lbT2 do
    begin
      Parent := Self;
      Left := 110; //57
      Top := 25; //35
      Width := 18;
      Height := 20;
      Caption := '�';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbH := TLabel.Create(Self);                   //����� - '�:�'
  with lbH do
    begin
      Parent := Self;
      Left := 88;
      Top := 63;
      AutoSize := True;
      Caption := '� : �';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  Self.OnClick := IndClick;
  lbN.OnClick := IndClick;
  lbGrName.OnClick := IndClick;
  lbAssignTh.OnClick := IndClick;
  lbProdTh.OnClick := IndClick;
  lbSumm.OnClick := IndClick;
  lbLevel.OnClick := IndClick;
  lbTime.OnClick := IndClick;
  lbAs.OnClick := IndClick;
  lbW.OnClick := IndClick;
  lbTh.OnClick := IndClick;
  lbT1.OnClick := IndClick;
  lbT2.OnClick := IndClick;
  lbH.OnClick := IndClick;
  imgBat.OnClick := IndClick;
  imgConv1.OnClick := IndClick;
  imgConv2.OnClick := IndClick;
  imgCoal.OnClick := IndClick;
  FNum := 0;
  FGrade := 0;
  FAssigned := 0;
  FRecommend := 0;
  FProdTh := 0;
  FSumm := 0;
  FLevel := 0;
  FWeight := 0;
  FConv1 := False;
  FConv2 := False;
  FState := stOk;
  FToReport := True;
  FOsc := True;
end;

procedure TBatcher.SetNum(const Value : byte);
begin
  FNum := Value;
  lbN.Caption := IntToStr(FNum);
end;

procedure TBatcher.SetDONum(const Value : byte);
begin
  FDONum := Value;
  if FDONum = 1 then Width := 137;
end;

procedure TBatcher.SetGrade(const Value : byte);
begin
  FGrade := Value;
end;

procedure TBatcher.SetGradeColor(const Value : byte);
begin
  lbGrName.Font.Color := TrendsColors[Value];
end;

procedure TBatcher.SetGrName(const Value : string);
begin
  FGrName := Value;
  lbGrName.Caption := FGrName;
end;

procedure TBatcher.SetAssigned(const Value : single);
begin
  FAssigned := Value;
  lbAssignTh.Caption := Format('%3.1f', [FAssigned]);
end;

procedure TBatcher.SetProdTh(const Value : single);
begin
  FProdTh := Value;
  case FState of
    stOk:
      begin
        lbProdTh.Font.Size := 24;
        lbProdTh.Caption := Format('%3.1f', [FProdTh]);
        if FConv2 and (FProdTh < 20) then lbProdTh.Font.Color := clRed else lbProdTh.Font.Color := clBlack;
      end;
    stNetErr:
      begin
        lbProdTh.Font.Size := 14;
        lbProdTh.Caption := '����  ';
      end;
    stSenErr:
      begin
        lbProdTh.Font.Size := 14;
        lbProdTh.Caption := '������';
      end;
  end;
end;

procedure TBatcher.SetSumm(const Value : single);
begin
  FSumm := Value;
  lbSumm.Caption := Format('%3.1f', [FSumm]);
end;

procedure TBatcher.SetLevel(const Value : single);
begin
  FLevel := Value;
  lbLevel.Caption := Format('%3.1f', [FLevel]);
end;

procedure TBatcher.SetWeight(const Value : single);
begin
  FWeight := Value;
  if (not FConv2) and (FState = stOK) then
    begin
      if FWeight > 50 then imgCoal.Visible := True;
      if FWeight < 45 then imgCoal.Visible := False;
    end else imgCoal.Visible := False;
end;

procedure TBatcher.SetTime(const Value : word);
begin
  FTime := Value;
  if FTime > 24 * 60 - 1 then FTime := 24 * 60 - 1;
  lbTime.Caption := FormatDateTime('hh:nn', EncodeTime(FTime div 60, FTime mod 60, 0, 0));
end;

procedure TBatcher.SetState(const Value : TState);
var
  Vis : boolean;
begin
  FState := Value;
  if FState = stNotMnt then Vis := False else Vis := True;
  lbGrName.Visible := Vis;
  lbAssignTh.Visible := Vis;
  lbProdTh.Visible := Vis;
  lbSumm.Visible := Vis;
  lbLevel.Visible := Vis;
  lbTime.Visible := Vis;
  lbAs.Visible := Vis;
  lbW.Visible := Vis;
  lbTh.Visible := Vis;
  lbT1.Visible := Vis;
  lbT2.Visible := Vis;
  lbH.Visible := Vis;
  imgBat.Visible := Vis;
  imgConv1.Visible := Vis;
  imgConv2.Visible := Vis;
  imgCoal.Visible := Vis and (FState = stOK);
  if FState in [stNetErr, stSenErr] then
    begin
      SetProdTh(0);
      FOsc := not(FOsc);
      if FOsc then lbProdTh.Font.Color := clRed else lbProdTh.Font.Color := clBlack;
    end else lbProdTh.Font.Color := clBlack;
end;

procedure TBatcher.IndClick(Sender:TObject);
begin
  inherited Click;
end;

procedure TBatcher.SetConv2(const Value : boolean);
begin
  if Value <> FConv2 then
    begin
      FConv2 := Value;
      if FConv2 then imgConv2.Picture.LoadFromFile('conv2_on.wmf')
        else imgConv2.Picture.LoadFromFile('conv2_off.wmf');
    end;
end;

procedure TBatcher.SetConv1(const Value : boolean);
begin
  if Value <> FConv1 then
    begin
      FConv1 := Value;
      if FConv1 then imgConv1.Picture.LoadFromFile('conv1_on.wmf')
        else imgConv1.Picture.LoadFromFile('conv1_off.wmf');
    end;
end;

procedure TBatcher.SetSelect(const Value : boolean);
begin
  if Value then Color := $00A0B0C0 else Color := clBtnFace;
end;

end.
unit Batcher;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls, Types;

type
  TBatcher = class(TCustomPanel)      //����� ���������� ��������
  private
    FNum : byte;                        //����� ��������
    FDONum : byte;                      //����� ���������
    FGrade : byte;                      //����� ����� ���� � ��������
    FGrName : string;                   //������������ ����� ���� � ��������
    FAssigned : single;                 //������� ������������������ � ��/���
    FRecommend : single;                //��������������� ������������������ � ��/���
    FProdTh : single;                   //����������� ����������� ������������������ � ��/���
    FSumm : single;                     //��������� ��� � ��
    FLevel : single;                    //������� (�����) ���� � ������ � ��
    FWeight : single;                   //��� �� �����
    FState : TState;                    //��������� ���������� (� ���������)
    FEnable : boolean;
    FToReport : boolean;                //��������� � ������
    FConv1 : boolean;                   //�������� �������
    FConv2 : boolean;                   //������� �������� �������
    FTime : word;                       //����� ������ �������� � ���
    FOsc : boolean;                     //���� ��������
    imgBat : TImage;                    //����������� �������
    imgConv1 : TImage;                  //����������� ��������� ���������
    imgConv2 : TImage;                  //����������� �������� ���������
    imgCoal : TImage;                   //����������� ���� �� �����
    lbN : TLabel;                       //����� - ����� ��������
    lbGrName : TLabel;                  //����� - ������������ ����� ���� � ��������
    lbAssignTh : TLabel;                //����� - ������� ������������������ � ��/���
    lbProdTh : TLabel;                  //����� - ����������� ����������� ������������������ � ��/���
    lbSumm : TLabel;                    //����� - ��������� ��� � ��
    lbLevel : TLabel;                   //����� - ������� (�����) ���� � ������ � ��
    lbTime: TLabel;                     //����� - ����� ������ ��������
    lbAs : TLabel;                      //����� - '������:'
    lbW : TLabel;                       //����� - '�����:'
    lbTh : TLabel;                      //����� - '�/�'
    lbT1 : TLabel;                      //����� - '�'
    lbT2 : TLabel;                      //����� - '�'
    lbH : TLabel;                       //����� - '�:�'
    procedure SetNum(const Value : byte);           //���������� ������ ��������
    procedure SetDONum(const Value : byte);         //���������� ������ ���������
    procedure SetGrade(const Value : byte);         //���������� ������ ����� ����
    procedure SetGradeColor(const Value : byte);    //���� ������������ ����� ���� � ��������
    procedure SetGrName(const Value : string);      //������� ������������ ����� ����
    procedure SetAssigned(const Value : single);    //������ ������� � ��/���
    procedure SetProdTh(const Value : single);      //������ ������������������ � ��/���
    procedure SetSumm(const Value : single);        //������ ���������� ���� � ��
    procedure SetLevel(const Value : single);       //������ ������ (����) ���� � ������ � ��
    procedure SetWeight(const Value : single);      //������ ���� �� �����
    procedure SetState(const Value : TState);       //��������� ��������� ����������
    procedure SetConv1(const Value : boolean);      //��������� ����� ������ ��������
    procedure SetConv2(const Value : boolean);      //��������� ����� ������ �������� ���������
    procedure SetSelect(const Value : boolean);     //��������� ��������� ����������
    procedure SetTime(const Value : word);          //������ ������� ������
    procedure IndClick(Sender : TObject);           //���������� �������� ������
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Num : byte read FNum write SetNum;                     //����� ��������
    property DONum : byte read FDONum write SetDONum;               //����� ���������
    property Grade : byte read FGrade write SetGrade;               //����� ����� ���� � ��������
    property GradeColor : byte write SetGradeColor;                 //���� ������������ ����� ���� � ��������
    property GrName : string read FGrName write SetGrName;          //������������ ����� ����
    property Assigned : single read FAssigned write SetAssigned;    //������� � ��/���
    property Recommend : single read FRecommend write FRecommend;   //��������������� ������������������ � ��/���
    property ProdTh : single read FProdTh write SetProdTh;          //����������� ����������� ������������������ � ��/���
    property Summ : single read FSumm write SetSumm;                //��������� ��� � ��
    property Level : single read FLevel write SetLevel;             //������� (�����) ���� � ������ � ��
    property Weight : single read FWeight write SetWeight;          //��� �� �����
    property Enable : boolean read FEnable write FEnable;
    property Conv1 : boolean read FConv1 write SetConv1;            //�������� �������
    property Conv2 : boolean read FConv2 write SetConv2;            //������� ����� ��������
    property State : TState read FState write SetState;             //��������� ��������
    property ToReport : boolean read FToReport write FToReport;     //��������� � ������
    property Time : word read FTime write SetTime;                  //����� ������ �������� � ���
    property Select : boolean write SetSelect;                      //��������� ��������� ����������
    property OnClick;                                               //������� - ������ ����
  end;

implementation

constructor TBatcher.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Width := 127;
  Height := 178;
  BevelWidth := 1;
  Caption := '';
  Font.Name := 'MS Sans Serif';
  imgBat := TImage.Create(Self);                //����������� �������
  with imgBat do
    begin
      Parent := Self;
      Left := 12;
      Top := 26;
      AutoSize := True;
      Picture.LoadFromFile('bat.wmf');
    end;
  imgConv1 := TImage.Create(Self);              //����������� ��������� ���������
  with imgConv1 do
    begin
      Parent := Self;
      Left := 4;
      Top := 65;
      AutoSize := True;
      Picture.LoadFromFile('conv1_off.wmf');
    end;
  imgConv2 := TImage.Create(Self);              //����������� �������� ���������
  with imgConv2 do
    begin
      Parent := Self;
      Left := 40;
      Top := 83;
      AutoSize := True;
      Picture.LoadFromFile('conv2_off.wmf');
    end;
  imgCoal := TImage.Create(Self);               //����������� ���� �� �����
  with imgCoal do
    begin
      Parent := Self;
      Left := 60;
      Top := 70;
      AutoSize := True;
      Visible := False;
      Picture.LoadFromFile('coal.wmf');
    end;
  lbN := TLabel.Create(Self);                   //����� - ����� ��������
  with lbN do
    begin
      Parent := Self;
      Left := 5;
      Top := 4;
      AutoSize := True;
      Caption := '0';
      Font.Color := clWhite;
      Font.Size := 10;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  lbGrName := TLabel.Create(Self);              //����� - ������������ ����� ���� � ��������
  with lbGrName do
    begin
      Parent := Self;
      Left := 21;
      Top := 4;
      AutoSize := True;
      Caption := '';
      Font.Color := clNavy;
      Font.Size := 10;
      Font.Charset := 204;
      Font.Name := 'Times New Roman';
      Font.Style := [fsBold];
    end;
  lbAssignTh := TLabel.Create(Self);            //����� - ������� � ��/���
  with lbAssignTh do
    begin
      Parent := Self;
      Left := 45;
      Top := 145;
      Alignment := taRightJustify;
      AutoSize := False;
      Width := 33;
      Caption := '0';
      Font.Size := 8;
      Font.Style := [fsBold];
    end;
  lbProdTh := TLabel.Create(Self);              //����� - ������������������ � ��/���
  with lbProdTh do
    begin
      Parent := Self;
      Left := 35;
      Top := 110;
      Width := 85;
      Height := 33;
      AutoSize := False;
      Alignment := taRightJustify;
      Caption := '0';
      Font.Size := 24;
      Font.Style := [fsBold];
    end;
  lbSumm := TLabel.Create(Self);                //����� - ��������� ��� � ��
  with lbSumm do
    begin
      Parent := Self;
      Left := 65;
      Top := 160;
      Width := 40;
      Alignment := taRightJustify;
      AutoSize := False;
      Caption := '0';
      Font.Size := 8;
      Font.Style := [fsBold];
    end;
  lbLevel := TLabel.Create(Self);                //����� - ��������� ��� � ��
  with lbLevel do
    begin
      Parent := Self;
      Left := 65;  //14
      Top := 25;  //35
      Alignment := taRightJustify;
      AutoSize := False;
      Width := 40;
      Caption := '0';
      Font.Color := clBlack;
      Font.Size := 8;
      Font.Style := [fsBold];
    end;
  lbTime := TLabel.Create(Self);                //����� - ����� ������ ��������
  with lbTime do
    begin
    Parent := Self;
    Left := 78;
    Top := 48;
    Width := 40;
    Height := 20;
    Alignment := taRightJustify;
    AutoSize := False;
    Caption := '00:00';
    Font.Size := 8;
    Font.Style := [fsBold];
    end;
  lbAs := TLabel.Create(Self);                  //����� - '������:'
  with lbAs do
    begin
      Parent := Self;
      Left := 4;
      Top := 145;
      AutoSize := True;
      Caption := '������:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbW := TLabel.Create(Self);                   //����� - '�����:'
  with lbW do
    begin
      Parent := Self;
      Left := 4;
      Top := 160;
      AutoSize := True;
      Caption := '�����:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbTh := TLabel.Create(Self);                  //����� - '�/�'
  with lbTh do
    begin
      Parent := Self;
      Left := 90;
      Caption := '�/�';
      Top := 145;
      AutoSize := True;
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT1 := TLabel.Create(Self);                   //����� - '�'
  with lbT1 do
    begin
      Parent := Self;
      Left := 110;
      Top := 160;
      Width := 18;
      Height := 20;
      Caption := '�';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT2 := TLabel.Create(Self);                   //����� - '�'
  with lbT2 do
    begin
      Parent := Self;
      Left := 110; //57
      Top := 25; //35
      Width := 18;
      Height := 20;
      Caption := '�';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbH := TLabel.Create(Self);                   //����� - '�:�'
  with lbH do
    begin
      Parent := Self;
      Left := 88;
      Top := 63;
      AutoSize := True;
      Caption := '� : �';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  Self.OnClick := IndClick;
  lbN.OnClick := IndClick;
  lbGrName.OnClick := IndClick;
  lbAssignTh.OnClick := IndClick;
  lbProdTh.OnClick := IndClick;
  lbSumm.OnClick := IndClick;
  lbLevel.OnClick := IndClick;
  lbTime.OnClick := IndClick;
  lbAs.OnClick := IndClick;
  lbW.OnClick := IndClick;
  lbTh.OnClick := IndClick;
  lbT1.OnClick := IndClick;
  lbT2.OnClick := IndClick;
  lbH.OnClick := IndClick;
  imgBat.OnClick := IndClick;
  imgConv1.OnClick := IndClick;
  imgConv2.OnClick := IndClick;
  imgCoal.OnClick := IndClick;
  FNum := 0;
  FGrade := 0;
  FAssigned := 0;
  FRecommend := 0;
  FProdTh := 0;
  FSumm := 0;
  FLevel := 0;
  FWeight := 0;
  FConv1 := False;
  FConv2 := False;
  FState := stOk;
  FToReport := True;
  FOsc := True;
end;

procedure TBatcher.SetNum(const Value : byte);
begin
  FNum := Value;
  lbN.Caption := IntToStr(FNum);
end;

procedure TBatcher.SetDONum(const Value : byte);
begin
  FDONum := Value;
  if FDONum = 1 then Width := 137;
end;

procedure TBatcher.SetGrade(const Value : byte);
begin
  FGrade := Value;
end;

procedure TBatcher.SetGradeColor(const Value : byte);
begin
  lbGrName.Font.Color := TrendsColors[Value];
end;

procedure TBatcher.SetGrName(const Value : string);
begin
  FGrName := Value;
  lbGrName.Caption := FGrName;
end;

procedure TBatcher.SetAssigned(const Value : single);
begin
  FAssigned := Value;
  lbAssignTh.Caption := Format('%3.1f', [FAssigned]);
end;

procedure TBatcher.SetProdTh(const Value : single);
begin
  FProdTh := Value;
  case FState of
    stOk:
      begin
        lbProdTh.Font.Size := 24;
        lbProdTh.Caption := Format('%3.1f', [FProdTh]);
        if FConv2 and (FProdTh < 20) then lbProdTh.Font.Color := clRed else lbProdTh.Font.Color := clBlack;
      end;
    stNetErr:
      begin
        lbProdTh.Font.Size := 14;
        lbProdTh.Caption := '����  ';
      end;
    stSenErr:
      begin
        lbProdTh.Font.Size := 14;
        lbProdTh.Caption := '������';
      end;
  end;
end;

procedure TBatcher.SetSumm(const Value : single);
begin
  FSumm := Value;
  lbSumm.Caption := Format('%3.1f', [FSumm]);
end;

procedure TBatcher.SetLevel(const Value : single);
begin
  FLevel := Value;
  lbLevel.Caption := Format('%3.1f', [FLevel]);
end;

procedure TBatcher.SetWeight(const Value : single);
begin
  FWeight := Value;
  if (not FConv2) and (FState = stOK) then
    begin
      if FWeight > 50 then imgCoal.Visible := True;
      if FWeight < 45 then imgCoal.Visible := False;
    end else imgCoal.Visible := False;
end;

procedure TBatcher.SetTime(const Value : word);
begin
  FTime := Value;
  if FTime > 24 * 60 - 1 then FTime := 24 * 60 - 1;
  lbTime.Caption := FormatDateTime('hh:nn', EncodeTime(FTime div 60, FTime mod 60, 0, 0));
end;

procedure TBatcher.SetState(const Value : TState);
var
  Vis : boolean;
begin
  FState := Value;
  if FState = stNotMnt then Vis := False else Vis := True;
  lbGrName.Visible := Vis;
  lbAssignTh.Visible := Vis;
  lbProdTh.Visible := Vis;
  lbSumm.Visible := Vis;
  lbLevel.Visible := Vis;
  lbTime.Visible := Vis;
  lbAs.Visible := Vis;
  lbW.Visible := Vis;
  lbTh.Visible := Vis;
  lbT1.Visible := Vis;
  lbT2.Visible := Vis;
  lbH.Visible := Vis;
  imgBat.Visible := Vis;
  imgConv1.Visible := Vis;
  imgConv2.Visible := Vis;
  imgCoal.Visible := Vis and (FState = stOK);
  if FState in [stNetErr, stSenErr] then
    begin
      SetProdTh(0);
      FOsc := not(FOsc);
      if FOsc then lbProdTh.Font.Color := clRed else lbProdTh.Font.Color := clBlack;
    end else lbProdTh.Font.Color := clBlack;
end;

procedure TBatcher.IndClick(Sender:TObject);
begin
  inherited Click;
end;

procedure TBatcher.SetConv2(const Value : boolean);
begin
  if Value <> FConv2 then
    begin
      FConv2 := Value;
      if FConv2 then imgConv2.Picture.LoadFromFile('conv2_on.wmf')
        else imgConv2.Picture.LoadFromFile('conv2_off.wmf');
    end;
end;

procedure TBatcher.SetConv1(const Value : boolean);
begin
  if Value <> FConv1 then
    begin
      FConv1 := Value;
      if FConv1 then imgConv1.Picture.LoadFromFile('conv1_on.wmf')
        else imgConv1.Picture.LoadFromFile('conv1_off.wmf');
    end;
end;

procedure TBatcher.SetSelect(const Value : boolean);
begin
  if Value then Color := $00A0B0C0 else Color := clBtnFace;
end;

end.
