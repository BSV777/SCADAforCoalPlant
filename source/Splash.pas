unit Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, shellapi;

type
  TSplashForm = class(TForm)
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Shape2: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure SetPosition(Value : byte);
  private
    FPosition : byte;
  public
    property Position : byte read FPosition write SetPosition;
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.DFM}

procedure TSplashForm.FormCreate(Sender: TObject);
var
  hsWindowRegion : Integer;
begin
  hsWindowRegion := CreateEllipticRgn(0, 0, 242, 131);
  SetWindowRgn(Handle, hsWindowRegion, True);
end;

procedure TSplashForm.Label1Click(Sender: TObject);
var
  TempString : array[0..79] of char;
begin
  StrPCopy(TempString, 'mailto: ');
  ShellExecute(0, Nil, TempString, Nil, Nil, SW_NORMAL);
end;

procedure TSplashForm.SetPosition(Value : byte);
begin
  FPosition := Value;
  ProgressBar1.Position := FPosition;
end;

end.
