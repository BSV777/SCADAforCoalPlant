unit WinCCClient2;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls,
  OPCDA, OPCutils, ComObj, ActiveX, Types, OPCTypes, PSock;

type
  TWinCCOPCClient2 = class(TComponent)
  private
    FRecommend : array[1..16] of single;      //Рекомендуемые значения производительности
    FAssigned : array[1..16] of single;       //Заданные значения производительности
    FConv1 : array[1..16] of boolean;         //Флаги работы питателей
    FEnable : array[1..16] of boolean;        //Флаги разрешения совместной работы
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
    function GetEnable(Index : byte) : boolean;
    procedure SetEnable(Index : byte; Value : boolean);
    procedure SetConnected(Value : boolean);
    procedure SetCalibration(Value : boolean);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Recommend[Index : byte] : single read GetRecommend write SetRecommend;
    property Assigned[Index : byte] : single read GetAssigned;
    property Conv1[Index : byte] : boolean read GetConv1;
    property Enable[Index : byte] : boolean read GetEnable write SetEnable;
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
  WinCCItemHandle : array[1..66] of OPCHANDLE;           //Массив указателей на теги OPCServer.WinCC
  StartTime : TDateTime;

implementation

constructor TWinCCOPCClient2.Create(AOwner : TComponent);
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

  for i := 1 to 16 do
    begin
      FRecommend[i] := 0;
      FAssigned[i] := 0;
      FConv1[i] := False;
      FEnable[i] := False;
    end;

  FConnected := False;
  FAssemblyConv := True;
end;

procedure TWinCCOPCClient2.ReadTimerTimer(Sender: TObject);
begin
  Read;
end;

procedure TWinCCOPCClient2.Read;
var
  i : byte;
  ItemValue : string;   //Значение тега с виде строки
  ItemQuality : Word;   //Тачество тега
  HR : HResult;         //Результат OLE-операции
begin
  ReadTimer.Enabled := False;
  if FConnected then
    begin
      for i := 1 to 16 do
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
          if WinCCItemHandle[i + 16] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 16], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FConv1[i] := True else FConv1[i] := False;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 32] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 32], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FAssigned[i] := StrToInt(ItemValue);
                  except
//                    FAssigned[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 48] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 48], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FEnable[i] := True else FEnable[i] := False;
                end else FConnected := False;
            end;
        end;
      if WinCCItemHandle[65] <> 0 then
        begin
          HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[65], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              if ItemValue = '0' then FCalibration := False else FCalibration := True;
            end else FConnected := False;
        end;
      if WinCCItemHandle[66] <> 0 then
        begin
          HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[66], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              if ItemValue = '0' then FAssemblyConv := False else FAssemblyConv := True;
            end else FConnected := False;
        end;
      if not FConnected then Disconnect;
    end;
  ReadTimer.Enabled := True;
end;

procedure TWinCCOPCClient2.ConnectTimerTimer(Sender: TObject);
begin
  Connect;
end;

procedure TWinCCOPCClient2.Connect;
var
  i : byte;
  Powersock1 : TPowersock;
  ItemType : TVarType;    //Формат данных тега
  HR : HResult;         //Результат OLE-операции
begin
  ConnectTimer.Enabled := False;
  Powersock1 := TPowersock.Create(Self);
  Powersock1.Host := 'KHP2';
  Powersock1.Port := 7;
  Powersock1.ReportLevel := 1;
  Powersock1.Timeout := 3000;
 // try Powersock1.Connect; except end;
  if not Powersock1.BeenTimedOut then
    begin
      try
        WinCCServerIf := CreateRemoteComObject('KHP2', ProgIDToClassID(WinCCServerProgID)) as IOPCServer;
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
          for i := 1 to 16 do
            begin
              GroupAddItem(WinCCGroupIf, 'Recommend_' + IntToStr(i), 0, VT_BSTR, WinCCItemHandle[i], ItemType);
              GroupAddItem(WinCCGroupIf, 'Pulses_En_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 16], ItemType);
              GroupAddItem(WinCCGroupIf, 'Set_Val_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 32], ItemType);
              GroupAddItem(WinCCGroupIf, 'Start_En_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 48], ItemType);
            end;
          GroupAddItem(WinCCGroupIf, 'JCalibration', 0, VT_BSTR, WinCCItemHandle[65], ItemType);
          GroupAddItem(WinCCGroupIf, 'Y-32', 0, VT_BSTR, WinCCItemHandle[66], ItemType);
          StartTime := Now;
          while (Now - StartTime) < OneSecond do Application.ProcessMessages;
          ReadTimer.Enabled := True;
          FConnected := True;
          Calibration := False;
        end;
    end;
end;

procedure TWinCCOPCClient2.Disconnect;
begin
  if WinCCServerIf <> nil then WinCCServerIf.RemoveGroup(WinCCGroupHandle, False);
  WinCCGroupIf := nil;
  WinCCServerIf := nil;
  FConnected := False;
  ConnectTimer.Enabled := True;
end;

function TWinCCOPCClient2.GetRecommend(Index : byte) : single;
begin
  Result := FRecommend[Index];
end;

procedure TWinCCOPCClient2.SetRecommend(Index : byte; Value : single);
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

procedure TWinCCOPCClient2.SetEnable(Index : byte; Value : boolean);
begin
  FEnable[Index] := Value;
end;

procedure TWinCCOPCClient2.SetCalibration(Value : boolean);
var
  HR : HResult;         //Результат OLE-операции
begin
  FCalibration := Value;
  if WinCCItemHandle[51] <> 0 then
    begin
      if FCalibration then
        HR :=  WriteOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[65], '1') else
        HR :=  WriteOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[65], '0');
      if not Succeeded(HR) then FConnected := False;
    end;
end;

function TWinCCOPCClient2.GetAssigned(Index : byte) : single;
begin
  Result := FAssigned[Index];
end;

function TWinCCOPCClient2.GetConv1(Index : byte) : boolean;
begin
  Result := FConv1[Index];
end;

function TWinCCOPCClient2.GetEnable(Index : byte) : boolean;
begin
  Result := FEnable[Index];
end;

procedure TWinCCOPCClient2.SetConnected(Value : boolean);
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
unit WinCCClient2;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdCtrls, ExtCtrls,
  OPCDA, OPCutils, ComObj, ActiveX, Types, OPCTypes, PSock;

type
  TWinCCOPCClient2 = class(TComponent)
  private
    FRecommend : array[1..16] of single;      //Рекомендуемые значения производительности
    FAssigned : array[1..16] of single;       //Заданные значения производительности
    FConv1 : array[1..16] of boolean;         //Флаги работы питателей
    FEnable : array[1..16] of boolean;        //Флаги разрешения совместной работы
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
    function GetEnable(Index : byte) : boolean;
    procedure SetEnable(Index : byte; Value : boolean);
    procedure SetConnected(Value : boolean);
    procedure SetCalibration(Value : boolean);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    property Recommend[Index : byte] : single read GetRecommend write SetRecommend;
    property Assigned[Index : byte] : single read GetAssigned;
    property Conv1[Index : byte] : boolean read GetConv1;
    property Enable[Index : byte] : boolean read GetEnable write SetEnable;
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
  WinCCItemHandle : array[1..66] of OPCHANDLE;           //Массив указателей на теги OPCServer.WinCC
  StartTime : TDateTime;

implementation

constructor TWinCCOPCClient2.Create(AOwner : TComponent);
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

  for i := 1 to 16 do
    begin
      FRecommend[i] := 0;
      FAssigned[i] := 0;
      FConv1[i] := False;
      FEnable[i] := False;
    end;

  FConnected := False;
  FAssemblyConv := True;
end;

procedure TWinCCOPCClient2.ReadTimerTimer(Sender: TObject);
begin
  Read;
end;

procedure TWinCCOPCClient2.Read;
var
  i : byte;
  ItemValue : string;   //Значение тега с виде строки
  ItemQuality : Word;   //Тачество тега
  HR : HResult;         //Результат OLE-операции
begin
  ReadTimer.Enabled := False;
  if FConnected then
    begin
      for i := 1 to 16 do
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
          if WinCCItemHandle[i + 16] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 16], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FConv1[i] := True else FConv1[i] := False;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 32] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 32], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  try
                    FAssigned[i] := StrToInt(ItemValue);
                  except
//                    FAssigned[i] := 0;
                  end;
                end else FConnected := False;
            end;

          if WinCCItemHandle[i + 48] <> 0 then
            begin
              HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[i + 48], ItemValue, ItemQuality);
              if Succeeded(HR) then
                begin
                  if ItemValue <> '0' then FEnable[i] := True else FEnable[i] := False;
                end else FConnected := False;
            end;
        end;
      if WinCCItemHandle[65] <> 0 then
        begin
          HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[65], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              if ItemValue = '0' then FCalibration := False else FCalibration := True;
            end else FConnected := False;
        end;
      if WinCCItemHandle[66] <> 0 then
        begin
          HR := ReadOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[66], ItemValue, ItemQuality);
          if Succeeded(HR) then
            begin
              if ItemValue = '0' then FAssemblyConv := False else FAssemblyConv := True;
            end else FConnected := False;
        end;
      if not FConnected then Disconnect;
    end;
  ReadTimer.Enabled := True;
end;

procedure TWinCCOPCClient2.ConnectTimerTimer(Sender: TObject);
begin
  Connect;
end;

procedure TWinCCOPCClient2.Connect;
var
  i : byte;
  Powersock1 : TPowersock;
  ItemType : TVarType;    //Формат данных тега
  HR : HResult;         //Результат OLE-операции
begin
  ConnectTimer.Enabled := False;
  Powersock1 := TPowersock.Create(Self);
  Powersock1.Host := 'KHP2';
  Powersock1.Port := 7;
  Powersock1.ReportLevel := 1;
  Powersock1.Timeout := 3000;
 // try Powersock1.Connect; except end;
  if not Powersock1.BeenTimedOut then
    begin
      try
        WinCCServerIf := CreateRemoteComObject('KHP2', ProgIDToClassID(WinCCServerProgID)) as IOPCServer;
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
          for i := 1 to 16 do
            begin
              GroupAddItem(WinCCGroupIf, 'Recommend_' + IntToStr(i), 0, VT_BSTR, WinCCItemHandle[i], ItemType);
              GroupAddItem(WinCCGroupIf, 'Pulses_En_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 16], ItemType);
              GroupAddItem(WinCCGroupIf, 'Set_Val_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 32], ItemType);
              GroupAddItem(WinCCGroupIf, 'Start_En_' + Format('%0.2d',[i]), 0, VT_BSTR, WinCCItemHandle[i + 48], ItemType);
            end;
          GroupAddItem(WinCCGroupIf, 'JCalibration', 0, VT_BSTR, WinCCItemHandle[65], ItemType);
          GroupAddItem(WinCCGroupIf, 'Y-32', 0, VT_BSTR, WinCCItemHandle[66], ItemType);
          StartTime := Now;
          while (Now - StartTime) < OneSecond do Application.ProcessMessages;
          ReadTimer.Enabled := True;
          FConnected := True;
          Calibration := False;
        end;
    end;
end;

procedure TWinCCOPCClient2.Disconnect;
begin
  if WinCCServerIf <> nil then WinCCServerIf.RemoveGroup(WinCCGroupHandle, False);
  WinCCGroupIf := nil;
  WinCCServerIf := nil;
  FConnected := False;
  ConnectTimer.Enabled := True;
end;

function TWinCCOPCClient2.GetRecommend(Index : byte) : single;
begin
  Result := FRecommend[Index];
end;

procedure TWinCCOPCClient2.SetRecommend(Index : byte; Value : single);
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

procedure TWinCCOPCClient2.SetEnable(Index : byte; Value : boolean);
begin
  FEnable[Index] := Value;
end;

procedure TWinCCOPCClient2.SetCalibration(Value : boolean);
var
  HR : HResult;         //Результат OLE-операции
begin
  FCalibration := Value;
  if WinCCItemHandle[51] <> 0 then
    begin
      if FCalibration then
        HR :=  WriteOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[65], '1') else
        HR :=  WriteOPCGroupItemValue(WinCCGroupIf, WinCCItemHandle[65], '0');
      if not Succeeded(HR) then FConnected := False;
    end;
end;

function TWinCCOPCClient2.GetAssigned(Index : byte) : single;
begin
  Result := FAssigned[Index];
end;

function TWinCCOPCClient2.GetConv1(Index : byte) : boolean;
begin
  Result := FConv1[Index];
end;

function TWinCCOPCClient2.GetEnable(Index : byte) : boolean;
begin
  Result := FEnable[Index];
end;

procedure TWinCCOPCClient2.SetConnected(Value : boolean);
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
