unit Batcher;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls, Types;

type
  TBatcher = class(TCustomPanel)      //Класс индикатора дозатора
  private
    FNum : byte;                        //Номер дозатора
    FDONum : byte;                      //Номер дозировки
    FGrade : byte;                      //Номер марки угля в дозаторе
    FGrName : string;                   //Наименование марки угля в дозаторе
    FAssigned : single;                 //Заданая производительность в тн/час
    FRecommend : single;                //Рекомендованная производительность в тн/час
    FProdTh : single;                   //Фактическая усредненная производительность в тн/час
    FSumm : single;                     //Набранный вес в тн
    FLevel : single;                    //Уровень (масса) угля в силосе в тн
    FWeight : single;                   //Вес на ленте
    FState : TState;                    //Состояние индикатора (и Микросима)
    FEnable : boolean;
    FToReport : boolean;                //участвует в отчете
    FConv1 : boolean;                   //Питатель включен
    FConv2 : boolean;                   //Весовой конвейер включен
    FTime : word;                       //Время работы дозатора в мин
    FOsc : boolean;                     //Флаг мерцания
    imgBat : TImage;                    //Изображение бункера
    imgConv1 : TImage;                  //Изображение питающего конвейера
    imgConv2 : TImage;                  //Изображение весового конвейера
    imgCoal : TImage;                   //Изображение угля на ленте
    lbN : TLabel;                       //Метка - Номер дозатора
    lbGrName : TLabel;                  //Метка - Наименование марки угля в дозаторе
    lbAssignTh : TLabel;                //Метка - Заданая производительность в тн/час
    lbProdTh : TLabel;                  //Метка - Фактическая усредненная производительность в тн/час
    lbSumm : TLabel;                    //Метка - Набранный вес в тн
    lbLevel : TLabel;                   //Метка - Уровень (масса) угля в силосе в тн
    lbTime: TLabel;                     //Метка - Время работы дозатора
    lbAs : TLabel;                      //Метка - 'Задано:'
    lbW : TLabel;                       //Метка - 'Всего:'
    lbTh : TLabel;                      //Метка - 'т/ч'
    lbT1 : TLabel;                      //Метка - 'т'
    lbT2 : TLabel;                      //Метка - 'т'
    lbH : TLabel;                       //Метка - 'ч:м'
    procedure SetNum(const Value : byte);           //Просвоение номера дозатору
    procedure SetDONum(const Value : byte);         //Просвоение номера дозировки
    procedure SetGrade(const Value : byte);         //Присвоение номера марки угля
    procedure SetGradeColor(const Value : byte);    //Цвет наименования марки угля в дозаторе
    procedure SetGrName(const Value : string);      //Задание наименования марки угля
    procedure SetAssigned(const Value : single);    //Запись задания в тн/час
    procedure SetProdTh(const Value : single);      //Запись производительности в тн/час
    procedure SetSumm(const Value : single);        //Запись набранного веса в тн
    procedure SetLevel(const Value : single);       //Запись уровня (веса) угля в силосе в тн
    procedure SetWeight(const Value : single);      //Запись веса на ленте
    procedure SetState(const Value : TState);       //Установка состояния индикатора
    procedure SetConv1(const Value : boolean);      //Установка флага работы питателя
    procedure SetConv2(const Value : boolean);      //Установка флага работы весового конвейера
    procedure SetSelect(const Value : boolean);     //Включение подсветки индикатора
    procedure SetTime(const Value : word);          //Запись времени работы
    procedure IndClick(Sender : TObject);           //Обработчик двойного щелчка
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Num : byte read FNum write SetNum;                     //Номер дозатора
    property DONum : byte read FDONum write SetDONum;               //Номер дозировки
    property Grade : byte read FGrade write SetGrade;               //Номер марки угля в дозаторе
    property GradeColor : byte write SetGradeColor;                 //Цвет наименования марки угля в дозаторе
    property GrName : string read FGrName write SetGrName;          //Наименование марки угля
    property Assigned : single read FAssigned write SetAssigned;    //Задание в тн/час
    property Recommend : single read FRecommend write FRecommend;   //Рекомендованная производительность в тн/час
    property ProdTh : single read FProdTh write SetProdTh;          //Фактическая усредненная производительность в тн/час
    property Summ : single read FSumm write SetSumm;                //Набранный вес в тн
    property Level : single read FLevel write SetLevel;             //Уровень (масса) угля в силосе в тн
    property Weight : single read FWeight write SetWeight;          //Вес на ленте
    property Enable : boolean read FEnable write FEnable;
    property Conv1 : boolean read FConv1 write SetConv1;            //Питатель включен
    property Conv2 : boolean read FConv2 write SetConv2;            //Весовая лента включена
    property State : TState read FState write SetState;             //Состояние дозатора
    property ToReport : boolean read FToReport write FToReport;     //Участвует в отчете
    property Time : word read FTime write SetTime;                  //Время работы дозатора в мин
    property Select : boolean write SetSelect;                      //Включение подсветки индикатора
    property OnClick;                                               //Событие - щелчок мыши
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
  imgBat := TImage.Create(Self);                //Изображение бункера
  with imgBat do
    begin
      Parent := Self;
      Left := 12;
      Top := 26;
      AutoSize := True;
      Picture.LoadFromFile('bat.wmf');
    end;
  imgConv1 := TImage.Create(Self);              //Изображение питающего конвейера
  with imgConv1 do
    begin
      Parent := Self;
      Left := 4;
      Top := 65;
      AutoSize := True;
      Picture.LoadFromFile('conv1_off.wmf');
    end;
  imgConv2 := TImage.Create(Self);              //Изображение весового конвейера
  with imgConv2 do
    begin
      Parent := Self;
      Left := 40;
      Top := 83;
      AutoSize := True;
      Picture.LoadFromFile('conv2_off.wmf');
    end;
  imgCoal := TImage.Create(Self);               //Изображение угля на ленте
  with imgCoal do
    begin
      Parent := Self;
      Left := 60;
      Top := 70;
      AutoSize := True;
      Visible := False;
      Picture.LoadFromFile('coal.wmf');
    end;
  lbN := TLabel.Create(Self);                   //Метка - Номер дозатора
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
  lbGrName := TLabel.Create(Self);              //Метка - Наименование марки угля в дозаторе
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
  lbAssignTh := TLabel.Create(Self);            //Метка - Задание в тн/час
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
  lbProdTh := TLabel.Create(Self);              //Метка - Производительность в тн/час
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
  lbSumm := TLabel.Create(Self);                //Метка - Набранный вес в тн
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
  lbLevel := TLabel.Create(Self);                //Метка - Набранный вес в тн
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
  lbTime := TLabel.Create(Self);                //Метка - Время работы дозатора
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
  lbAs := TLabel.Create(Self);                  //Метка - 'Задано:'
  with lbAs do
    begin
      Parent := Self;
      Left := 4;
      Top := 145;
      AutoSize := True;
      Caption := 'Задано:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbW := TLabel.Create(Self);                   //Метка - 'Всего:'
  with lbW do
    begin
      Parent := Self;
      Left := 4;
      Top := 160;
      AutoSize := True;
      Caption := 'Всего:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbTh := TLabel.Create(Self);                  //Метка - 'т/ч'
  with lbTh do
    begin
      Parent := Self;
      Left := 90;
      Caption := 'т/ч';
      Top := 145;
      AutoSize := True;
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT1 := TLabel.Create(Self);                   //Метка - 'т'
  with lbT1 do
    begin
      Parent := Self;
      Left := 110;
      Top := 160;
      Width := 18;
      Height := 20;
      Caption := 'т';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT2 := TLabel.Create(Self);                   //Метка - 'т'
  with lbT2 do
    begin
      Parent := Self;
      Left := 110; //57
      Top := 25; //35
      Width := 18;
      Height := 20;
      Caption := 'т';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbH := TLabel.Create(Self);                   //Метка - 'ч:м'
  with lbH do
    begin
      Parent := Self;
      Left := 88;
      Top := 63;
      AutoSize := True;
      Caption := 'ч : м';
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
        lbProdTh.Caption := 'Сеть  ';
      end;
    stSenErr:
      begin
        lbProdTh.Font.Size := 14;
        lbProdTh.Caption := 'Датчик';
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
  TBatcher = class(TCustomPanel)      //Класс индикатора дозатора
  private
    FNum : byte;                        //Номер дозатора
    FDONum : byte;                      //Номер дозировки
    FGrade : byte;                      //Номер марки угля в дозаторе
    FGrName : string;                   //Наименование марки угля в дозаторе
    FAssigned : single;                 //Заданая производительность в тн/час
    FRecommend : single;                //Рекомендованная производительность в тн/час
    FProdTh : single;                   //Фактическая усредненная производительность в тн/час
    FSumm : single;                     //Набранный вес в тн
    FLevel : single;                    //Уровень (масса) угля в силосе в тн
    FWeight : single;                   //Вес на ленте
    FState : TState;                    //Состояние индикатора (и Микросима)
    FEnable : boolean;
    FToReport : boolean;                //участвует в отчете
    FConv1 : boolean;                   //Питатель включен
    FConv2 : boolean;                   //Весовой конвейер включен
    FTime : word;                       //Время работы дозатора в мин
    FOsc : boolean;                     //Флаг мерцания
    imgBat : TImage;                    //Изображение бункера
    imgConv1 : TImage;                  //Изображение питающего конвейера
    imgConv2 : TImage;                  //Изображение весового конвейера
    imgCoal : TImage;                   //Изображение угля на ленте
    lbN : TLabel;                       //Метка - Номер дозатора
    lbGrName : TLabel;                  //Метка - Наименование марки угля в дозаторе
    lbAssignTh : TLabel;                //Метка - Заданая производительность в тн/час
    lbProdTh : TLabel;                  //Метка - Фактическая усредненная производительность в тн/час
    lbSumm : TLabel;                    //Метка - Набранный вес в тн
    lbLevel : TLabel;                   //Метка - Уровень (масса) угля в силосе в тн
    lbTime: TLabel;                     //Метка - Время работы дозатора
    lbAs : TLabel;                      //Метка - 'Задано:'
    lbW : TLabel;                       //Метка - 'Всего:'
    lbTh : TLabel;                      //Метка - 'т/ч'
    lbT1 : TLabel;                      //Метка - 'т'
    lbT2 : TLabel;                      //Метка - 'т'
    lbH : TLabel;                       //Метка - 'ч:м'
    procedure SetNum(const Value : byte);           //Просвоение номера дозатору
    procedure SetDONum(const Value : byte);         //Просвоение номера дозировки
    procedure SetGrade(const Value : byte);         //Присвоение номера марки угля
    procedure SetGradeColor(const Value : byte);    //Цвет наименования марки угля в дозаторе
    procedure SetGrName(const Value : string);      //Задание наименования марки угля
    procedure SetAssigned(const Value : single);    //Запись задания в тн/час
    procedure SetProdTh(const Value : single);      //Запись производительности в тн/час
    procedure SetSumm(const Value : single);        //Запись набранного веса в тн
    procedure SetLevel(const Value : single);       //Запись уровня (веса) угля в силосе в тн
    procedure SetWeight(const Value : single);      //Запись веса на ленте
    procedure SetState(const Value : TState);       //Установка состояния индикатора
    procedure SetConv1(const Value : boolean);      //Установка флага работы питателя
    procedure SetConv2(const Value : boolean);      //Установка флага работы весового конвейера
    procedure SetSelect(const Value : boolean);     //Включение подсветки индикатора
    procedure SetTime(const Value : word);          //Запись времени работы
    procedure IndClick(Sender : TObject);           //Обработчик двойного щелчка
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Num : byte read FNum write SetNum;                     //Номер дозатора
    property DONum : byte read FDONum write SetDONum;               //Номер дозировки
    property Grade : byte read FGrade write SetGrade;               //Номер марки угля в дозаторе
    property GradeColor : byte write SetGradeColor;                 //Цвет наименования марки угля в дозаторе
    property GrName : string read FGrName write SetGrName;          //Наименование марки угля
    property Assigned : single read FAssigned write SetAssigned;    //Задание в тн/час
    property Recommend : single read FRecommend write FRecommend;   //Рекомендованная производительность в тн/час
    property ProdTh : single read FProdTh write SetProdTh;          //Фактическая усредненная производительность в тн/час
    property Summ : single read FSumm write SetSumm;                //Набранный вес в тн
    property Level : single read FLevel write SetLevel;             //Уровень (масса) угля в силосе в тн
    property Weight : single read FWeight write SetWeight;          //Вес на ленте
    property Enable : boolean read FEnable write FEnable;
    property Conv1 : boolean read FConv1 write SetConv1;            //Питатель включен
    property Conv2 : boolean read FConv2 write SetConv2;            //Весовая лента включена
    property State : TState read FState write SetState;             //Состояние дозатора
    property ToReport : boolean read FToReport write FToReport;     //Участвует в отчете
    property Time : word read FTime write SetTime;                  //Время работы дозатора в мин
    property Select : boolean write SetSelect;                      //Включение подсветки индикатора
    property OnClick;                                               //Событие - щелчок мыши
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
  imgBat := TImage.Create(Self);                //Изображение бункера
  with imgBat do
    begin
      Parent := Self;
      Left := 12;
      Top := 26;
      AutoSize := True;
      Picture.LoadFromFile('bat.wmf');
    end;
  imgConv1 := TImage.Create(Self);              //Изображение питающего конвейера
  with imgConv1 do
    begin
      Parent := Self;
      Left := 4;
      Top := 65;
      AutoSize := True;
      Picture.LoadFromFile('conv1_off.wmf');
    end;
  imgConv2 := TImage.Create(Self);              //Изображение весового конвейера
  with imgConv2 do
    begin
      Parent := Self;
      Left := 40;
      Top := 83;
      AutoSize := True;
      Picture.LoadFromFile('conv2_off.wmf');
    end;
  imgCoal := TImage.Create(Self);               //Изображение угля на ленте
  with imgCoal do
    begin
      Parent := Self;
      Left := 60;
      Top := 70;
      AutoSize := True;
      Visible := False;
      Picture.LoadFromFile('coal.wmf');
    end;
  lbN := TLabel.Create(Self);                   //Метка - Номер дозатора
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
  lbGrName := TLabel.Create(Self);              //Метка - Наименование марки угля в дозаторе
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
  lbAssignTh := TLabel.Create(Self);            //Метка - Задание в тн/час
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
  lbProdTh := TLabel.Create(Self);              //Метка - Производительность в тн/час
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
  lbSumm := TLabel.Create(Self);                //Метка - Набранный вес в тн
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
  lbLevel := TLabel.Create(Self);                //Метка - Набранный вес в тн
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
  lbTime := TLabel.Create(Self);                //Метка - Время работы дозатора
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
  lbAs := TLabel.Create(Self);                  //Метка - 'Задано:'
  with lbAs do
    begin
      Parent := Self;
      Left := 4;
      Top := 145;
      AutoSize := True;
      Caption := 'Задано:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbW := TLabel.Create(Self);                   //Метка - 'Всего:'
  with lbW do
    begin
      Parent := Self;
      Left := 4;
      Top := 160;
      AutoSize := True;
      Caption := 'Всего:';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbTh := TLabel.Create(Self);                  //Метка - 'т/ч'
  with lbTh do
    begin
      Parent := Self;
      Left := 90;
      Caption := 'т/ч';
      Top := 145;
      AutoSize := True;
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT1 := TLabel.Create(Self);                   //Метка - 'т'
  with lbT1 do
    begin
      Parent := Self;
      Left := 110;
      Top := 160;
      Width := 18;
      Height := 20;
      Caption := 'т';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbT2 := TLabel.Create(Self);                   //Метка - 'т'
  with lbT2 do
    begin
      Parent := Self;
      Left := 110; //57
      Top := 25; //35
      Width := 18;
      Height := 20;
      Caption := 'т';
      Font.Color := clWhite;
      Font.Size := 8;
    end;
  lbH := TLabel.Create(Self);                   //Метка - 'ч:м'
  with lbH do
    begin
      Parent := Self;
      Left := 88;
      Top := 63;
      AutoSize := True;
      Caption := 'ч : м';
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
        lbProdTh.Caption := 'Сеть  ';
      end;
    stSenErr:
      begin
        lbProdTh.Font.Size := 14;
        lbProdTh.Caption := 'Датчик';
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
