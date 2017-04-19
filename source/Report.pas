unit Report;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, TeEngine, Series, TeeProcs, Chart, DBChart, 
  ExtCtrls, Db, DBTables, QrTee;

type
  TPrintForm = class(TForm)
    QuickRep1: TQuickRep;
    TitleBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRDBChart1: TQRDBChart;
    QRChart1: TQRChart;
    QRLabel2: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintForm: TPrintForm;
  QRDBChart : TQRDBChart;

implementation

{$R *.DFM}

end.
unit Report;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, TeEngine, Series, TeeProcs, Chart, DBChart, 
  ExtCtrls, Db, DBTables, QrTee;

type
  TPrintForm = class(TForm)
    QuickRep1: TQuickRep;
    TitleBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRDBChart1: TQRDBChart;
    QRChart1: TQRChart;
    QRLabel2: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintForm: TPrintForm;
  QRDBChart : TQRDBChart;

implementation

{$R *.DFM}

end.
