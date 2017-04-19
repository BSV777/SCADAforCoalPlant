unit WinCCClient1;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls,
  OPCDA, OPCutils, ComObj, ActiveX, Types, OPCTypes, PSock;

type
  TWinCCOPCClient1 = class(TComponent)
  private
    FRecommend : array[1..14] of single;      //Рекомендуемые значения производительности
    FAssigned : array[1..14] of single;       //Заданные значения производительности
    FConv1 : array[1..14] of boolean;         //Флаги работы питателей
    FConv2 : array[1..14] of boolean;         //Флаги работы весовых конвейеров
    FEnable : array[1..14] of boolean;        //Флаги разрешения совместной работы
    FWorkTime : array[1..14] of word;         //Время работы
//    FProd : array[1..14] of single;           //Мгновенные значения производительности
    FAverage : array[1..14] of single;        //Усредненные значения производительности
    FWeight : array[1..14] of single;         //Вес на ленте
    FSumm : array[1..14] of single;           //Набранный вес
    FState : array[1..14] of TState;          //Состояние дозатора
    FConnected : boolean;                     //Состояние связи с OPCServer.WinCC
    ReadTimer : TTimer;                       //Таймер периодичности чтения тегов из OPCServer.WinCC
    ConnectTimer : TTimer;                    //Таймер интервала восстановления связи с OPCServer.WinCC
    FCalibration : boolean;                   //Флаг выполнения процедуры калибровки
    FAssemblyConv : boolean;
    procedure ReadTimerTimer(Sender : TObject);
    procedure Read;
    procedure ConnectTimerTimer(Sender : TObject);
    procedure Connect;
    procedure Disconnect;
    function GetRecommend(Index : byte) : single;
    procedure SetRecommend(Index : byte; Value : single);
    function GetAssigned(Index : byte) : single;
    function GetConv1(Index : byte) : boolean;
    function GetConv2(Index : byte) : boolean;
    function GetEnable(Index : byte) : boolean;
    procedure SetEnable(Index : byte; Value : boolean);

    function GetProd(Index : byte) : single;
    procedure SetProd(Index : byte; Value : single);
    function GetSumm(Index : byte) : single;
    procedure SetSumm(Index : byte; Value : single);
    function GetState(Index : byte) : TState;
    procedure SetState(Index : byte; Value : TState);
    function GetWorkTime(Index : byte) : word;
    function GetWeight(Index : byte) : single;
    function GetAverage(Index : byte) : single;

    procedure SetConnected(Value : boolean);
    procedure SetCalibration(Value : boolean);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Recommend[Index : byte] : single read GetRecommend write SetRecommend;
    property Assigned[Index : byte] : single read GetAssigned;
    property Conv1[Index : byte] : boolean read GetConv1;
    property Conv2[Index : byte] : boolean read GetConv2;
    property Enable[Index : byte] : boolean read GetEnable write SetEnable;

    property Prod[Index : byte] : single read GetProd write SetProd;
    property Summ[Index : byte] : single read GetSumm write SetSumm;
    property State[Index : byte] : TState read GetState write SetState;
    property WorkTime[Index : byte] : word read GetWorkTime;
    property Weight[Index : byte] : single read GetWeight;
    property Average[Index : byte] : single read GetAverage;

    property Connected : boolean read FConnected write SetConnected;
    property Calibration : boolean read FCalibration write SetCalibration;
    property AssemblyConv : boolean read FAssemblyConv;
  end;

const
  WinCCServerProgID = 'OPCServer.WinCC';          //Ключевое имя сервера
  OneSecond = 1 / (24 * 60 * 60);                 //Интервал ожидания после установления связи с сервером

var
  WinCCServerIf : IOPCServer;                            //Интерфейс OPCServer.WinCC
  WinCCGroupIf : IOPCItemMgt;                            //Интерфейс управления группами тегов OPCServer.WinCC
  WinCCGroupHandle: OPCHANDLE;                           //Группа тегов OPCServer.WinCC
  WinCCItemHandle : array[1..113] of OPCHANDLE;           //Массив указателей на теги OPCServer.WinCC
  StartTime : TDateTime;

implementation

constructor TWinCCOPCClient1.Create(AOwner : TComponent);
var
  i : byte;
begin
  ReadTimer := TTimer.Create(AOwner);
  ReadTimer.Interval := 3000;
  ReadTimer.Enabled := False;
  ReadTimer.OnTimer := ReadTimerTimer;

  ConnectTimer := TTimer.Create(AOwner);
  ConnectTimer.Interval := 6000;
  ConnectTimer.Enabled := False;
  ConnectTimer.OnTimer := ConnectTimerTimer;

  FCalibration := False;

  for i := 1 to 14 do
    begin
      FRecommend[i] := 0;
      FAssigned[i] := 0;
      FConv1[i] := False;
      FConv2[i] := False;
      FEnable[i] := False;
    end;

  FConnected := False;
  FAssemblyConv := True;
end;

procedure TWinCCOPCClient1.ReadTimerTimer(Sender: TObject);
begin
  Read;
end;

procedure TWinCCOPCClient1.Read;
var
  i : byte;
  ItemValue : string;   //Значение тега с виде строки
  ItemQuality : Word;   //Тачество тега
  HR : HResult;         //Результат OLE-операции
begin
  ReadTimer.Enabled := False;
  if FConnected then
    begin
      for i := 1 to 14 do
        begin
          if WinCCItemHandle[i] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FRecommend[i] := StrToInt(ItemValue);
                  except
//                    FRecommend[i] := 0;
                  end;
                end else FConnected := False;
            end;
          if WinCCItemHandle[i + 14] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 14], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FConv1[i] := True else FConv1[i] := False;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 28] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 28], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FAssigned[i] := StrToInt(ItemValue);
                  except
//                    FAssigned[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 42] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 42], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FEnable[i] := True else FEnable[i] := False;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 56] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 56], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FWorkTime[i] := StrToInt(ItemValue) div 60;
                  except
//                    FWorkTime[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 70] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 70], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FAverage[i] := StrToInt(ItemValue);
                  except
//                    FAverage[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 84] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 84], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FSumm[i] := StrToFloat(ItemValue);
                  except
//                    FSumm[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 98] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 98], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FConv2[i] := False else FConv2[i] := True;
                end else FConnected := False;
            end;
        end;
      if not FConnected then Disconnect;
    end;
  ReadTimer.Enabled := True;
end;

procedure TWinCCOPCClient1.ConnectTimerTimer(Sender: TObject);
begin
  Connect;
end;

procedure TWinCCOPCClient1.Connect;
var
  i : byte;
  Powersock1 : TPowersock;
  ItemType : TVarType;    //Формат данных тега
  HR : HResult;         //Результат OLE-операции
begin
  ConnectTimer.Enabled := False;
  Powersock1 := TPowersock.Create(Self);
  Powersock1.Host := 'KHP3';
  Powersock1.Port := 7;
  Powersock1.ReportLevel := 1;
  Powersock1.Timeout := 3000;
//  try Powersock1.Connect; except end;
  if not Powersock1.BeenTimedOut then
    begin
      try
        WinCCServerIf := CreateRemoteComObject('KHP3', ProgIDToClassID(WinCCServerProgID)) as IOPCServer;
      except
        WinCCServerIf := nil;
      end;
    end;
  Powersock1.Disconnect;
  Powersock1.Free;
  if WinCCServerIf = nil then
    begin
      Disconnect;
    end else
    begin
      HR := ServerAddGroup(WinCCServerIf, 'MyGroup', True, 3000, 0, WinCCGroupIf, WinCCGroupHandle);
      if not Succeeded(HR) then
        begin
          Disconnect;
        end else
        begin
          for i := 1 to 14 do
            begin
              GroupAddItem(WinCCGroupIf, 'Recommend_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/PulsesEn_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 14], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/DATA_' + Format('%0.2d',[i]) + '.SetProd', 0, VT_BSTR, WinCCItemHandle[i + 28], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/StartEn_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 42], ItemType);

              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/SiwarexCommPar_' + Format('%0.2d',[i]) + '.SecondsCount_D', 0, VT_BSTR, WinCCItemHandle[i + 56], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/SiwarexCommPar_' + Format('%0.2d',[i]) + '.SiwarexProd_I', 0, VT_BSTR, WinCCItemHandle[i + 70], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/SiwarexCommPar_' + Format('%0.2d',[i]) + '.SiwarexWorkSumm', 0, VT_BSTR, WinCCItemHandle[i + 84], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/WeightConvOn_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 98], ItemType);
            end;
          StartTime := Now;
          while (Now - StartTime) < OneSecond do Application.ProcessMessages;
          ReadTimer.Enabled := True;
          FConnected := True;
          Calibration := False;
        end;
    end;
end;

procedure TWinCCOPCClient1.Disconnect;
begin
  if WinCCServerIf <> nil then WinCCServerIf.RemoveGroup(WinCCGroupHandle, False);
  WinCCGroupIf := nil;
  WinCCServerIf := nil;
  FConnected := False;
  ConnectTimer.Enabled := True;
end;

function TWinCCOPCClient1.GetRecommend(Index : byte) : single;
begin
  Result := FRecommend[Index];
end;

procedure TWinCCOPCClient1.SetRecommend(Index : byte; Value : single);

var
  HR : HResult;         //Результат OLE-операции
begin
  FRecommend[Index] := Value;
  if WinCCItemHandle[Index] <> 0 then
    begin
      HR :=  WriteOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[Index], Format('%3d', [Round(FRecommend[Index])]));
      if not Succeeded(HR) then FConnected := False;
    end;
end;

procedure TWinCCOPCClient1.SetEnable(Index : byte; Value : boolean);
begin
  FEnable[Index] := Value;
end;

procedure TWinCCOPCClient1.SetCalibration(Value : boolean);
begin

end;

function TWinCCOPCClient1.GetAssigned(Index : byte) : single;
begin
  Result := FAssigned[Index];
end;

function TWinCCOPCClient1.GetConv1(Index : byte) : boolean;
begin
  Result := FConv1[Index];
end;

function TWinCCOPCClient1.GetConv2(Index : byte) : boolean;
begin
  Result := FConv2[Index];
end;

function TWinCCOPCClient1.GetEnable(Index : byte) : boolean;
begin
  Result := FEnable[Index];
end;

procedure TWinCCOPCClient1.SetConnected(Value : boolean);
begin
  if Value <> FConnected then
    begin
      if Value then Connect else
        begin
          Disconnect;
          ConnectTimer.Enabled := False;
        end;
    end;
end;

function TWinCCOPCClient1.GetProd(Index : byte) : single;
begin
  Result := FAverage[Index];
end;

procedure TWinCCOPCClient1.SetProd(Index : byte; Value : single);
begin

end;

function TWinCCOPCClient1.GetSumm(Index : byte) : single;
begin
  Result := FSumm[Index];
end;

procedure TWinCCOPCClient1.SetSumm(Index : byte; Value : single);
begin

end;

function TWinCCOPCClient1.GetState(Index : byte) : TState;
begin
  Result := FState[Index];
end;

procedure TWinCCOPCClient1.SetState(Index : byte; Value : TState);
begin

end;

function TWinCCOPCClient1.GetWorkTime(Index : byte) : word;
begin
  Result := FWorkTime[Index];
end;

function TWinCCOPCClient1.GetWeight(Index : byte) : single;
begin
  Result := FWeight[Index];
end;

function TWinCCOPCClient1.GetAverage(Index : byte) : single;
begin
  Result := FAverage[Index];
end;

end.
unit WinCCClient1;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls,
  OPCDA, OPCutils, ComObj, ActiveX, Types, OPCTypes, PSock;

type
  TWinCCOPCClient1 = class(TComponent)
  private
    FRecommend : array[1..14] of single;      //Рекомендуемые значения производительности
    FAssigned : array[1..14] of single;       //Заданные значения производительности
    FConv1 : array[1..14] of boolean;         //Флаги работы питателей
    FConv2 : array[1..14] of boolean;         //Флаги работы весовых конвейеров
    FEnable : array[1..14] of boolean;        //Флаги разрешения совместной работы
    FWorkTime : array[1..14] of word;         //Время работы
//    FProd : array[1..14] of single;           //Мгновенные значения производительности
    FAverage : array[1..14] of single;        //Усредненные значения производительности
    FWeight : array[1..14] of single;         //Вес на ленте
    FSumm : array[1..14] of single;           //Набранный вес
    FState : array[1..14] of TState;          //Состояние дозатора
    FConnected : boolean;                     //Состояние связи с OPCServer.WinCC
    ReadTimer : TTimer;                       //Таймер периодичности чтения тегов из OPCServer.WinCC
    ConnectTimer : TTimer;                    //Таймер интервала восстановления связи с OPCServer.WinCC
    FCalibration : boolean;                   //Флаг выполнения процедуры калибровки
    FAssemblyConv : boolean;
    procedure ReadTimerTimer(Sender : TObject);
    procedure Read;
    procedure ConnectTimerTimer(Sender : TObject);
    procedure Connect;
    procedure Disconnect;
    function GetRecommend(Index : byte) : single;
    procedure SetRecommend(Index : byte; Value : single);
    function GetAssigned(Index : byte) : single;
    function GetConv1(Index : byte) : boolean;
    function GetConv2(Index : byte) : boolean;
    function GetEnable(Index : byte) : boolean;
    procedure SetEnable(Index : byte; Value : boolean);

    function GetProd(Index : byte) : single;
    procedure SetProd(Index : byte; Value : single);
    function GetSumm(Index : byte) : single;
    procedure SetSumm(Index : byte; Value : single);
    function GetState(Index : byte) : TState;
    procedure SetState(Index : byte; Value : TState);
    function GetWorkTime(Index : byte) : word;
    function GetWeight(Index : byte) : single;
    function GetAverage(Index : byte) : single;

    procedure SetConnected(Value : boolean);
    procedure SetCalibration(Value : boolean);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Recommend[Index : byte] : single read GetRecommend write SetRecommend;
    property Assigned[Index : byte] : single read GetAssigned;
    property Conv1[Index : byte] : boolean read GetConv1;
    property Conv2[Index : byte] : boolean read GetConv2;
    property Enable[Index : byte] : boolean read GetEnable write SetEnable;

    property Prod[Index : byte] : single read GetProd write SetProd;
    property Summ[Index : byte] : single read GetSumm write SetSumm;
    property State[Index : byte] : TState read GetState write SetState;
    property WorkTime[Index : byte] : word read GetWorkTime;
    property Weight[Index : byte] : single read GetWeight;
    property Average[Index : byte] : single read GetAverage;

    property Connected : boolean read FConnected write SetConnected;
    property Calibration : boolean read FCalibration write SetCalibration;
    property AssemblyConv : boolean read FAssemblyConv;
  end;

const
  WinCCServerProgID = 'OPCServer.WinCC';          //Ключевое имя сервера
  OneSecond = 1 / (24 * 60 * 60);                 //Интервал ожидания после установления связи с сервером

var
  WinCCServerIf : IOPCServer;                            //Интерфейс OPCServer.WinCC
  WinCCGroupIf : IOPCItemMgt;                            //Интерфейс управления группами тегов OPCServer.WinCC
  WinCCGroupHandle: OPCHANDLE;                           //Группа тегов OPCServer.WinCC
  WinCCItemHandle : array[1..113] of OPCHANDLE;           //Массив указателей на теги OPCServer.WinCC
  StartTime : TDateTime;

implementation

constructor TWinCCOPCClient1.Create(AOwner : TComponent);
var
  i : byte;
begin
  ReadTimer := TTimer.Create(AOwner);
  ReadTimer.Interval := 3000;
  ReadTimer.Enabled := False;
  ReadTimer.OnTimer := ReadTimerTimer;

  ConnectTimer := TTimer.Create(AOwner);
  ConnectTimer.Interval := 6000;
  ConnectTimer.Enabled := False;
  ConnectTimer.OnTimer := ConnectTimerTimer;

  FCalibration := False;

  for i := 1 to 14 do
    begin
      FRecommend[i] := 0;
      FAssigned[i] := 0;
      FConv1[i] := False;
      FConv2[i] := False;
      FEnable[i] := False;
    end;

  FConnected := False;
  FAssemblyConv := True;
end;

procedure TWinCCOPCClient1.ReadTimerTimer(Sender: TObject);
begin
  Read;
end;

procedure TWinCCOPCClient1.Read;
var
  i : byte;
  ItemValue : string;   //Значение тега с виде строки
  ItemQuality : Word;   //Тачество тега
  HR : HResult;         //Результат OLE-операции
begin
  ReadTimer.Enabled := False;
  if FConnected then
    begin
      for i := 1 to 14 do
        begin
          if WinCCItemHandle[i] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FRecommend[i] := StrToInt(ItemValue);
                  except
//                    FRecommend[i] := 0;
                  end;
                end else FConnected := False;
            end;
          if WinCCItemHandle[i + 14] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 14], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FConv1[i] := True else FConv1[i] := False;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 28] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 28], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FAssigned[i] := StrToInt(ItemValue);
                  except
//                    FAssigned[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 42] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 42], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FEnable[i] := True else FEnable[i] := False;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 56] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 56], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FWorkTime[i] := StrToInt(ItemValue) div 60;
                  except
//                    FWorkTime[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 70] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 70], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FAverage[i] := StrToInt(ItemValue);
                  except
//                    FAverage[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 84] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 84], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FSumm[i] := StrToFloat(ItemValue);
                  except
//                    FSumm[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 98] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 98], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FConv2[i] := False else FConv2[i] := True;
                end else FConnected := False;
            end;
        end;
      if not FConnected then Disconnect;
    end;
  ReadTimer.Enabled := True;
end;

procedure TWinCCOPCClient1.ConnectTimerTimer(Sender: TObject);
begin
  Connect;
end;

procedure TWinCCOPCClient1.Connect;
var
  i : byte;
  Powersock1 : TPowersock;
  ItemType : TVarType;    //Формат данных тега
  HR : HResult;         //Результат OLE-операции
begin
  ConnectTimer.Enabled := False;
  Powersock1 := TPowersock.Create(Self);
  Powersock1.Host := 'KHP3';
  Powersock1.Port := 7;
  Powersock1.ReportLevel := 1;
  Powersock1.Timeout := 3000;
//  try Powersock1.Connect; except end;
  if not Powersock1.BeenTimedOut then
    begin
      try
        WinCCServerIf := CreateRemoteComObject('KHP3', ProgIDToClassID(WinCCServerProgID)) as IOPCServer;
      except
        WinCCServerIf := nil;
      end;
    end;
  Powersock1.Disconnect;
  Powersock1.Free;
  if WinCCServerIf = nil then
    begin
      Disconnect;
    end else
    begin
      HR := ServerAddGroup(WinCCServerIf, 'MyGroup', True, 3000, 0, WinCCGroupIf, WinCCGroupHandle);
      if not Succeeded(HR) then
        begin
          Disconnect;
        end else
        begin
          for i := 1 to 14 do
            begin
              GroupAddItem(WinCCGroupIf, 'Recommend_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/PulsesEn_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 14], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/DATA_' + Format('%0.2d',[i]) + '.SetProd', 0, VT_BSTR, WinCCItemHandle[i + 28], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/StartEn_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 42], ItemType);

              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/SiwarexCommPar_' + Format('%0.2d',[i]) + '.SecondsCount_D', 0, VT_BSTR, WinCCItemHandle[i + 56], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/SiwarexCommPar_' + Format('%0.2d',[i]) + '.SiwarexProd_I', 0, VT_BSTR, WinCCItemHandle[i + 70], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/SiwarexCommPar_' + Format('%0.2d',[i]) + '.SiwarexWorkSumm', 0, VT_BSTR, WinCCItemHandle[i + 84], ItemType);
              GroupAddItem(WinCCGroupIf, 'S7$Program(1)/WeightConvOn_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 98], ItemType);
            end;
          StartTime := Now;
          while (Now - StartTime) < OneSecond do Application.ProcessMessages;
          ReadTimer.Enabled := True;
          FConnected := True;
          Calibration := False;
        end;
    end;
end;

procedure TWinCCOPCClient1.Disconnect;
begin
  if WinCCServerIf <> nil then WinCCServerIf.RemoveGroup(WinCCGroupHandle, False);
  WinCCGroupIf := nil;
  WinCCServerIf := nil;
  FConnected := False;
  ConnectTimer.Enabled := True;
end;

function TWinCCOPCClient1.GetRecommend(Index : byte) : single;
begin
  Result := FRecommend[Index];
end;

procedure TWinCCOPCClient1.SetRecommend(Index : byte; Value : single);

var
  HR : HResult;         //Результат OLE-операции
begin
  FRecommend[Index] := Value;
  if WinCCItemHandle[Index] <> 0 then
    begin
      HR :=  WriteOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[Index], Format('%3d', [Round(FRecommend[Index])]));
      if not Succeeded(HR) then FConnected := False;
    end;
end;

procedure TWinCCOPCClient1.SetEnable(Index : byte; Value : boolean);
begin
  FEnable[Index] := Value;
end;

procedure TWinCCOPCClient1.SetCalibration(Value : boolean);
begin

end;

function TWinCCOPCClient1.GetAssigned(Index : byte) : single;
begin
  Result := FAssigned[Index];
end;

function TWinCCOPCClient1.GetConv1(Index : byte) : boolean;
begin
  Result := FConv1[Index];
end;

function TWinCCOPCClient1.GetConv2(Index : byte) : boolean;
begin
  Result := FConv2[Index];
end;

function TWinCCOPCClient1.GetEnable(Index : byte) : boolean;
begin
  Result := FEnable[Index];
end;

procedure TWinCCOPCClient1.SetConnected(Value : boolean);
begin
  if Value <> FConnected then
    begin
      if Value then Connect else
        begin
          Disconnect;
          ConnectTimer.Enabled := False;
        end;
    end;
end;

function TWinCCOPCClient1.GetProd(Index : byte) : single;
begin
  Result := FAverage[Index];
end;

procedure TWinCCOPCClient1.SetProd(Index : byte; Value : single);
begin

end;

function TWinCCOPCClient1.GetSumm(Index : byte) : single;
begin
  Result := FSumm[Index];
end;

procedure TWinCCOPCClient1.SetSumm(Index : byte; Value : single);
begin

end;

function TWinCCOPCClient1.GetState(Index : byte) : TState;
begin
  Result := FState[Index];
end;

procedure TWinCCOPCClient1.SetState(Index : byte; Value : TState);
begin

end;

function TWinCCOPCClient1.GetWorkTime(Index : byte) : word;
begin
  Result := FWorkTime[Index];
end;

function TWinCCOPCClient1.GetWeight(Index : byte) : single;
begin
  Result := FWeight[Index];
end;

function TWinCCOPCClient1.GetAverage(Index : byte) : single;
begin
  Result := FAverage[Index];
end;

end.
