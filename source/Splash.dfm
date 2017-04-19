object SplashForm: TSplashForm
  Left = 382
  Top = 510
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Запуск программы:'
  ClientHeight = 134
  ClientWidth = 244
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 240
    Height = 130
    Brush.Style = bsClear
    Pen.Color = clMaroon
    Pen.Width = 3
    Shape = stEllipse
  end
  object Label1: TLabel
    Left = 69
    Top = 100
    Width = 102
    Height = 13
    Cursor = crHandPoint
    Hint = ''
    Caption = 'Sergey V. Baykov'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = Label1Click
  end
  object Label2: TLabel
    Left = 47
    Top = 84
    Width = 164
    Height = 13
    Caption = 'Управление разработок АСУТП'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 122
    Top = 16
    Width = 57
    Height = 13
    Caption = 'КХП УПЦ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 45
    Top = 32
    Width = 164
    Height = 22
    Hint = 'Версия от 11 февраля 2004 г.'
    Caption = 'Весовая станция'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label5: TLabel
    Left = 46
    Top = 69
    Width = 95
    Height = 13
    Caption = 'ОАО "НЛМК" ДИТ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Shape2: TShape
    Left = 22
    Top = 56
    Width = 202
    Height = 3
    Brush.Color = clYellow
  end
  object ProgressBar1: TProgressBar
    Left = 22
    Top = 58
    Width = 203
    Height = 7
    Min = 0
    Max = 100
    TabOrder = 0
  end
end
