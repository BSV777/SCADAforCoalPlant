unit Backup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TBackupForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BackupForm: TBackupForm;

implementation

{$R *.DFM}

procedure TBackupForm.Timer1Timer(Sender: TObject);
var
  CommandString : array[0..200] of char;
  si : Tstartupinfo;
  p : Tprocessinformation;
begin
  Timer1.Enabled := False;
  FillChar(Si, SizeOf(Si), 0);
  with Si do
  begin
    cb := SizeOf(Si);
    dwFlags := startf_UseShowWindow;
    wShowWindow := SW_MINIMIZE;
  end;
  StrPCopy(CommandString, 'c:\Program Files\WinRAR\Rar.exe a E:\Database\DB_BACKUP.rar E:\Database\KHP_SQL.db');
  CreateProcess(nil, CommandString, nil, nil, false, Create_default_error_mode, nil, nil, si, p);
  WaitForSingleObject(p.hProcess, infinite);
  Close;
end;

end.
