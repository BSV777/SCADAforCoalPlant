object DO2Form: TDO2Form
  Left = 251
  Top = 64
  BorderStyle = bsDialog
  Caption = 'Мнемосхема дозировочного отделения №2'
  ClientHeight = 708
  ClientWidth = 1015
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 283
    Height = 22
    Caption = 'Дозировочное отделение №2'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 10
    Top = 364
    Width = 286
    Height = 14
    Caption = 'Суммарная фактическая производительность, (т/ч):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrTotal: TLabel
    Left = 334
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 394
    Top = 364
    Width = 181
    Height = 14
    Caption = 'сборного конвейера нечетного:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrTot1: TLabel
    Left = 595
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label25: TLabel
    Left = 649
    Top = 364
    Width = 47
    Height = 14
    Caption = 'четного:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrTot2: TLabel
    Left = 708
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label27: TLabel
    Left = 764
    Top = 364
    Width = 146
    Height = 14
    Caption = 'Суммарная масса угля, (т):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbWeight: TLabel
    Left = 937
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label30: TLabel
    Left = 10
    Top = 594
    Width = 269
    Height = 14
    Caption = 'Производительность сборного конвейера, (т/ч):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrU: TLabel
    Left = 334
    Top = 592
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 572
    Top = 594
    Width = 330
    Height = 14
    Caption = 'Суммарная масса угля по данным сборного конвейера, (т):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbWeightU: TLabel
    Left = 937
    Top = 592
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDelay: TLabel
    Left = 10
    Top = 618
    Width = 291
    Height = 14
    Caption = 'Производительность дозаторов с запаздыванием, (т/ч):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lbPrDelay: TLabel
    Left = 334
    Top = 616
    Width = 9
    Height = 18
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object sgGradesTh: TStringGrid
    Left = 0
    Top = 49
    Width = 1013
    Height = 81
    TabStop = False
    ColCount = 2
    DefaultRowHeight = 25
    RowCount = 3
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = sgGradesThDrawCell
    RowHeights = (
      25
      25
      25)
  end
  object btResAllSumm2: TBitBtn
    Left = 16
    Top = 649
    Width = 260
    Height = 41
    Caption = 'Обнулить сумму на всех дозаторах'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btResAllSumm2Click
  end
  object btCalibrAll2: TBitBtn
    Left = 288
    Top = 649
    Width = 357
    Height = 41
    Caption = 'Автоматическое обнуление тары на всех дозаторах'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btCalibrAll2Click
    Glyph.Data = {
      36010000424D3601000000000000760000002800000013000000100000000100
      040000000000C000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800888888888
      888888800000BB80088888888888888CCCCC88BB800888888888888333338888
      BB808888888888800000888888B800888888888CCCCC8888888BB80088888883
      3333888888888BB800888880000088888888888BB800888CCCCC888888800000
      0BB008833333888888BBBBBBBBBB888000008888888BB8008888888CCCCC8888
      88888BB800888887333388888888888BB800888000008888888888888BB8008C
      CCCC888888888888888BB803333388888888888888888B800000}
  end
  object BitBtn1: TBitBtn
    Left = 664
    Top = 648
    Width = 137
    Height = 41
    Caption = 'Общий экран'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object CalibrationTimer: TTimer
    Enabled = False
    OnTimer = CalibrationTimerTimer
    Left = 368
    Top = 16
  end
end
object DO2Form: TDO2Form
  Left = 251
  Top = 64
  BorderStyle = bsDialog
  Caption = 'Мнемосхема дозировочного отделения №2'
  ClientHeight = 708
  ClientWidth = 1015
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 283
    Height = 22
    Caption = 'Дозировочное отделение №2'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 10
    Top = 364
    Width = 286
    Height = 14
    Caption = 'Суммарная фактическая производительность, (т/ч):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrTotal: TLabel
    Left = 334
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 394
    Top = 364
    Width = 181
    Height = 14
    Caption = 'сборного конвейера нечетного:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrTot1: TLabel
    Left = 595
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label25: TLabel
    Left = 649
    Top = 364
    Width = 47
    Height = 14
    Caption = 'четного:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrTot2: TLabel
    Left = 708
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label27: TLabel
    Left = 764
    Top = 364
    Width = 146
    Height = 14
    Caption = 'Суммарная масса угля, (т):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbWeight: TLabel
    Left = 937
    Top = 361
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label30: TLabel
    Left = 10
    Top = 594
    Width = 269
    Height = 14
    Caption = 'Производительность сборного конвейера, (т/ч):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrU: TLabel
    Left = 334
    Top = 592
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 572
    Top = 594
    Width = 330
    Height = 14
    Caption = 'Суммарная масса угля по данным сборного конвейера, (т):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbWeightU: TLabel
    Left = 937
    Top = 592
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDelay: TLabel
    Left = 10
    Top = 618
    Width = 291
    Height = 14
    Caption = 'Производительность дозаторов с запаздыванием, (т/ч):'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lbPrDelay: TLabel
    Left = 334
    Top = 616
    Width = 9
    Height = 18
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object sgGradesTh: TStringGrid
    Left = 0
    Top = 49
    Width = 1013
    Height = 81
    TabStop = False
    ColCount = 2
    DefaultRowHeight = 25
    RowCount = 3
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = sgGradesThDrawCell
    RowHeights = (
      25
      25
      25)
  end
  object btResAllSumm2: TBitBtn
    Left = 16
    Top = 649
    Width = 260
    Height = 41
    Caption = 'Обнулить сумму на всех дозаторах'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btResAllSumm2Click
  end
  object btCalibrAll2: TBitBtn
    Left = 288
    Top = 649
    Width = 357
    Height = 41
    Caption = 'Автоматическое обнуление тары на всех дозаторах'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btCalibrAll2Click
    Glyph.Data = {
      36010000424D3601000000000000760000002800000013000000100000000100
      040000000000C000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800888888888
      888888800000BB80088888888888888CCCCC88BB800888888888888333338888
      BB808888888888800000888888B800888888888CCCCC8888888BB80088888883
      3333888888888BB800888880000088888888888BB800888CCCCC888888800000
      0BB008833333888888BBBBBBBBBB888000008888888BB8008888888CCCCC8888
      88888BB800888887333388888888888BB800888000008888888888888BB8008C
      CCCC888888888888888BB803333388888888888888888B800000}
  end
  object BitBtn1: TBitBtn
    Left = 664
    Top = 648
    Width = 137
    Height = 41
    Caption = 'Общий экран'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object CalibrationTimer: TTimer
    Enabled = False
    OnTimer = CalibrationTimerTimer
    Left = 368
    Top = 16
  end
end
