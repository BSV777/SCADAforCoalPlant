program WStation;

uses
  Forms,
  Windows,
  MainF in 'MainF.pas' {WStationForm},
  Batcher in 'Batcher.pas',
  CoalGrade in 'CoalGrade.pas',
  Storage in 'Storage.pas',
  Report in 'Report.pas' {PrintForm},
  OPCDA in '..\..\Share\OPCDA.pas',
  OPCtypes in '..\..\Share\OPCtypes.pas',
  OPCutils in '..\..\Share\OPCutils.pas',
  SingleInst in '..\..\Share\SingleInst.pas',
  Splash in 'Splash.pas' {SplashForm},
  View in 'View.pas' {ViewForm},
  Summ in 'Summ.pas' {SummForm},
  Backup in 'Backup.pas' {BackupForm},
  MicroNetClient in '..\..\Share\MicroNetClient.pas',
  RecipeManager in 'RecipeManager.pas',
  DO1DO2 in 'DO1DO2.pas' {DO1DO2Form},
  DO1 in 'DO1.pas' {DO1Form},
  DO2 in 'DO2.pas' {DO2Form},
  BatchProp in 'BatchProp.pas' {BatchPropForm},
  Types in 'Types.pas',
  ReportSplash in 'ReportSplash.pas' {ReportSplashForm},
  WinCCClient1 in '..\..\Share\WinCCClient1.pas',
  WinCCClient2 in '..\..\Share\WinCCClient2.pas';

{$R *.RES}
{$R ..\..\Share\wmffiles.RES}
{$R ..\..\Share\wavfiles.RES}
{$R ..\..\Share\xlsfiles.RES}

var
  ExtendedStyle : integer;

begin
  if not ActivatePrevInstance(TWStationForm.ClassName, '') then
    begin
      Application.Initialize;
      ExtendedStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
      SetWindowLong(Application.Handle, GWL_EXSTYLE, ExtendedStyle or WS_EX_TOOLWINDOW);
      SplashForm := TSplashForm.Create(Application);
      SplashForm.Show;
      SplashForm.Update;
      Application.Title := 'WStation';
      DO1Form := TDO1Form.Create(Application);
      DO2Form := TDO2Form.Create(Application);
      DO1DO2Form := TDO1DO2Form.Create(Application);
      BatchPropForm := TBatchPropForm.Create(Application);
      Application.CreateForm(TWStationForm, WStationForm);
  Application.Run;
    end;
end.


program WStation;

uses
  Forms,
  Windows,
  MainF in 'MainF.pas' {WStationForm},
  Batcher in 'Batcher.pas',
  CoalGrade in 'CoalGrade.pas',
  Storage in 'Storage.pas',
  Report in 'Report.pas' {PrintForm},
  OPCDA in '..\..\Share\OPCDA.pas',
  OPCtypes in '..\..\Share\OPCtypes.pas',
  OPCutils in '..\..\Share\OPCutils.pas',
  SingleInst in '..\..\Share\SingleInst.pas',
  Splash in 'Splash.pas' {SplashForm},
  View in 'View.pas' {ViewForm},
  Summ in 'Summ.pas' {SummForm},
  Backup in 'Backup.pas' {BackupForm},
  MicroNetClient in '..\..\Share\MicroNetClient.pas',
  RecipeManager in 'RecipeManager.pas',
  DO1DO2 in 'DO1DO2.pas' {DO1DO2Form},
  DO1 in 'DO1.pas' {DO1Form},
  DO2 in 'DO2.pas' {DO2Form},
  BatchProp in 'BatchProp.pas' {BatchPropForm},
  Types in 'Types.pas',
  ReportSplash in 'ReportSplash.pas' {ReportSplashForm},
  WinCCClient1 in '..\..\Share\WinCCClient1.pas',
  WinCCClient2 in '..\..\Share\WinCCClient2.pas';

{$R *.RES}
{$R ..\..\Share\wmffiles.RES}
{$R ..\..\Share\wavfiles.RES}
{$R ..\..\Share\xlsfiles.RES}

var
  ExtendedStyle : integer;

begin
  if not ActivatePrevInstance(TWStationForm.ClassName, '') then
    begin
      Application.Initialize;
      ExtendedStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
      SetWindowLong(Application.Handle, GWL_EXSTYLE, ExtendedStyle or WS_EX_TOOLWINDOW);
      SplashForm := TSplashForm.Create(Application);
      SplashForm.Show;
      SplashForm.Update;
      Application.Title := 'WStation';
      DO1Form := TDO1Form.Create(Application);
      DO2Form := TDO2Form.Create(Application);
      DO1DO2Form := TDO1DO2Form.Create(Application);
      BatchPropForm := TBatchPropForm.Create(Application);
      Application.CreateForm(TWStationForm, WStationForm);
  Application.Run;
    end;
end.


