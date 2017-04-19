unit MicroNetClient;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls,
  OPCDA, OPCutils, ComObj, ActiveX, Types, OPCTypes;

type
  TMicroNetOPCClient = class(TComponent)
  private
    FProd : array[1..31] of single;           //Мгновенные значения производительности
    FAverage : array[1..31] of single;        //Усредненные значения производительности
    FWeight : array[1..31] of single;         //Вес на ленте
    FSumm : array[1..31] of single;           //Набранный вес
    FConv2 : array[1..31] of boolean;         //Флаги работы весовых конвейеров
    FState : array[1..31] of TState;          //Состояние Микросимов
    FWorkTime : array[1..31] of word;         //Время работы
    FSendPaks : array[1..31] of word;         //Количество отправленных запросов
    FErrPaks : array[1..31] of word;          //Количество полученных ответов с ошибкой
    FLostPaks : array[1..31] of word;         //Количество потерянных запросов
    FConnected : boolean;                     //Состояние связи с MicroNet.OPCServer-ом
    ReadTimer : TTimer;                       //Таймер периодичности чтения тегов из MicroNet.OPCServer
    ConnectTimer : TTimer;                    //Таймер интервала восстановления связи с MicroNet.OPCServer
    procedure ReadTimerTimer(Sender : TObject);
    procedure Read;
    procedure ConnectTimerTimer(Sender : TObject);
    procedure Connect;
    procedure Disconnect;
    function GetProd(Index : byte) : single;
    procedure SetProd(Index : byte; Value : single);
    function GetSumm(Index : byte) : single;
    procedure SetSumm(Index : byte; Value : single);
    function GetConv2(Index : byte) : boolean;
    function GetState(Index : byte) : TState;
    procedure SetState(Index : byte; Value : TState);
    function GetWorkTime(Index : byte) : word;
    function GetSendPaks(Index : byte) : word;
    function GetErrPaks(Index : byte) : word;
    function GetLostPaks(Index : byte) : word;
    function GetWeight(Index : byte) : single;
    function GetAverage(Index : byte) : single;
    procedure SetConnected(Value : boolean);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Prod[Index : byte] : single read GetProd write SetProd;
    property Summ[Index : byte] : single read GetSumm write SetSumm;
    property Conv2[Index : byte] : boolean read GetConv2;
    property State[Index : byte] : TState read GetState write SetState;
    property WorkTime[Index : byte] : word read GetWorkTime;
    property SendPaks[Index : byte] : word read GetSendPaks;
    property ErrPaks[Index : byte] : word read GetErrPaks;
    property LostPaks[Index : byte] : word read GetLostPaks;
    property Weight[Index : byte] : single read GetWeight;
    property Average[Index : byte] : single read GetAverage;
    property Connected : boolean read FConnected write SetConnected;
  end;

const
  ServerProgID = 'MicroNet.OPCServer';           //Ключевое имя сервера
  OneSecond = 1 / (24 * 60 * 60);                //Интервал ожидания после установления связи с сервером

var
  ServerIf : IOPCServer;                         //Интерфейс MicroNet.OPCServer
  GroupIf : IOPCItemMgt;                         //Интерфейс управления группами тегов MicroNet.OPCServer
  GroupHandle : OPCHANDLE;                       //Группа тегов MicroNet.OPCServer
  ItemHandle : array[1..310] of OPCHANDLE;       //Массив указателей на теги MicroNet.OPCServer
  StartTime : TDateTime;

implementation

constructor TMicroNetOPCClient.Create(AOwner : TComponent);
var
  i : byte;
begin
  ReadTimer := TTimer.Create(AOwner);
  ReadTimer.Interval := 2000;
  ReadTimer.Enabled := False;
  ReadTimer.OnTimer := ReadTimerTimer;

  ConnectTimer := TTimer.Create(AOwner);
  ConnectTimer.Interval := 5000;
  ConnectTimer.Enabled := False;
  ConnectTimer.OnTimer := ConnectTimerTimer;

  for i := 1 to 31 do
    begin
      FProd[i] := 0;
      FSumm[i] := 0;
      FConv2[i] := False;
      FState[i] := stOk;
      FWorkTime[i] := 0;
      FSendPaks[i] := 0;
      FErrPaks[i] := 0;
      FLostPaks[i] := 0;
      FWeight[i] := 0;
      FAverage[i] := 0;
    end;
  FConnected := False;
end;

procedure TMicroNetOPCClient.ReadTimerTimer(Sender: TObject);
begin
  Read;
end;

procedure TMicroNetOPCClient.Read;
var
  i : byte;
  ItemValue : string;   //Значение тега с виде строки
  ItemQuality : Word;   //Тачество тега
  HR : HResult;         //Результат OLE-операции
begin
  ReadTimer.Enabled := False;
  if FConnected then
    begin
      for i := 1 to 20 do
        begin
          HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                if StrToInt(ItemValue) < 32767 then
                  FProd[i] := StrToInt(ItemValue) / 10 else
                  FProd[i] := (StrToInt(ItemValue) - 65536) / 10;
              except
//                FProd[i] := 0;
              end;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 31], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                if StrToInt(ItemValue) < 32767 then
                  FAverage[i] := StrToInt(ItemValue) / 10 else
                  FAverage[i] := (StrToInt(ItemValue) - 65536) / 10;
              except
//                FAverage[i] := 0;
              end;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 62], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                FWeight[i] := StrToInt(ItemValue) / 10;
              except
//                FWeight[i] := 0;
              end;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 93], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                FSumm[i] := StrToInt(ItemValue);
              except
//                FSumm[i] := 0;
              end;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 124], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                FWorkTime[i] := StrToInt(ItemValue);
              except
//                FWorkTime[i] := 0;
              end;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 155], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                if ItemValue = '0' then FState[i] := stOk;
                if ItemValue = '1' then FState[i] := stSenErr;
                if ItemValue = '2' then FState[i] := stNetErr;
                if ItemValue = '3' then FState[i] := stNotMnt;
              except
                FState[i] := stOk;
              end;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 186], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              if ItemValue <> '0' then FConv2[i] := True else FConv2[i] := False;
            end else FConnected := False;
            HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 217], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                FSendPaks[i] := StrToInt(ItemValue);
              except
//                FSendPaks[i] := 0;
              end;
            end else FConnected := False;
          HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 248], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                FErrPaks[i] := StrToInt(ItemValue);
              except
//                FErrPaks[i] := 0;
              end;
            end else FConnected := False;
          HR := ReadOPCGroupItemValue(GroupIf, ItemHandle[i + 279], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              try
                FLostPaks[i] := StrToInt(ItemValue);
              except
//                FLostPaks[i] := 0;
              end;
            end else FConnected := False;
        end;
      if not FConnected then Disconnect;
    end;
  ReadTimer.Enabled := True;
end;

procedure TMicroNetOPCClient.ConnectTimerTimer(Sender: TObject);
begin
  Connect;
end;

procedure TMicroNetOPCClient.Connect;
var
  i : byte;
  ItemType : TVarType;    //Формат данных тега
  HR : HResult;         //Результат OLE-операции
begin
  ConnectTimer.Enabled := False;
  try
    ServerIf := CreateComObject(ProgIDToClassID(ServerProgID)) as IOPCServer;
  except
    ServerIf := nil;
  end;
  if ServerIf = nil then
    begin
      Disconnect;
    end else
    begin
      HR := ServerAddGroup(ServerIf, 'MyGroup', True, 2000, 0, GroupIf, GroupHandle);
      if not Succeeded(HR) then
        begin
          Disconnect;
        end else
        begin
          for i := 1 to 20 do
            begin
              GroupAddItem(GroupIf, 'Prod' + IntToStr(i), 0, VT_UI2, ItemHandle[i], ItemType);
              GroupAddItem(GroupIf, 'Average' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 31], ItemType);
              GroupAddItem(GroupIf, 'Weight' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 62], ItemType);
              GroupAddItem(GroupIf, 'Summ' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 93], ItemType);
              GroupAddItem(GroupIf, 'Time' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 124], ItemType);
              GroupAddItem(GroupIf, 'State' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 155], ItemType);
              GroupAddItem(GroupIf, 'Process' + IntToStr(i), 0, VT_BOOL, ItemHandle[i + 186], ItemType);
              GroupAddItem(GroupIf, 'SendPaks' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 217], ItemType);
              GroupAddItem(GroupIf, 'ErrPaks' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 248], ItemType);
              GroupAddItem(GroupIf, 'LostPaks' + IntToStr(i), 0, VT_UI2, ItemHandle[i + 279], ItemType);
            end;
          StartTime := Now;
          while (Now - StartTime) < OneSecond do Application.ProcessMessages;
          ReadTimer.Enabled := True;
          FConnected := True;
        end;
    end;
end;

procedure TMicroNetOPCClient.Disconnect;
begin
  if ServerIf <> nil then ServerIf.RemoveGroup(GroupHandle, False);
  GroupIf := nil;
  ServerIf := nil;
  FConnected := False;
  ConnectTimer.Enabled := True;
end;

function TMicroNetOPCClient.GetProd(Index : byte) : single;
begin
  Result := FProd[Index];
end;

procedure TMicroNetOPCClient.SetProd(Index : byte; Value : single);
var
  ItemValue : string;   //Значение тега с виде строки
begin
  if Value = 0 then
    begin
      ItemValue := '0';
      WriteOPCGroupItemValue(GroupIf, ItemHandle[Index], ItemValue);
    end;
end;

function TMicroNetOPCClient.GetSumm(Index : byte) : single;
begin
  Result := FSumm[Index];
end;

procedure TMicroNetOPCClient.SetSumm(Index : byte; Value : single);
var
  ItemValue : string;   //Значение тега с виде строки
begin
  if Value = 0 then
    begin
      ItemValue := '0';
      WriteOPCGroupItemValue(GroupIf, ItemHandle[Index + 93], ItemValue);
    end;
end;

function TMicroNetOPCClient.GetConv2(Index : byte) : boolean;
begin
  Result := FConv2[Index];
end;

function TMicroNetOPCClient.GetState(Index : byte) : TState;
begin
  Result := FState[Index];
end;

procedure TMicroNetOPCClient.SetState(Index : byte; Value : TState);
begin

end;

function TMicroNetOPCClient.GetWorkTime(Index : byte) : word;
begin
  Result := FWorkTime[Index];
end;

function TMicroNetOPCClient.GetSendPaks(Index : byte) : word;
begin
  Result := FSendPaks[Index];
end;

function TMicroNetOPCClient.GetErrPaks(Index : byte) : word;
begin
  Result := FErrPaks[Index];
end;

function TMicroNetOPCClient.GetLostPaks(Index : byte) : word;
begin
  Result := FLostPaks[Index];
end;

function TMicroNetOPCClient.GetWeight(Index : byte) : single;
begin
  Result := FWeight[Index];
end;

function TMicroNetOPCClient.GetAverage(Index : byte) : single;
begin
  Result := FAverage[Index];
end;

procedure TMicroNetOPCClient.SetConnected(Value : boolean);
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

end.



