object DO1DO2Form: TDO1DO2Form
  Left = 13
  Top = 102
  BorderStyle = bsDialog
  Caption = 'Шихтовки, диаграммы, отчеты'
  ClientHeight = 705
  ClientWidth = 1017
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 47
    Width = 1012
    Height = 300
    ActivePage = SheetTrends
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Style = tsButtons
    TabOrder = 0
    object SheetTrends: TTabSheet
      Caption = 'Диаграмма'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      object DBChart1: TDBChart
        Left = 0
        Top = 0
        Width = 1004
        Height = 267
        ShowGlassCursor = False
        AllowPanning = pmNone
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginBottom = 2
        MarginLeft = 1
        MarginRight = 1
        MarginTop = 2
        Title.AdjustFrame = False
        Title.Font.Charset = RUSSIAN_CHARSET
        Title.Font.Color = clNavy
        Title.Font.Height = -13
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '')
        Title.Visible = False
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.DateTimeFormat = 'hh:mm'
        BottomAxis.ExactDateTime = False
        DepthAxis.Automatic = False
        DepthAxis.AutomaticMaximum = False
        DepthAxis.AutomaticMinimum = False
        DepthAxis.Maximum = 0.5
        DepthAxis.Minimum = -0.5
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Axis.Width = 1
        LeftAxis.Axis.Visible = False
        LeftAxis.ExactDateTime = False
        LeftAxis.Maximum = 200
        Legend.Alignment = laLeft
        Legend.CheckBoxes = True
        Legend.Color = clBtnFace
        Legend.ColorWidth = 0
        Legend.Font.Charset = RUSSIAN_CHARSET
        Legend.FontSeriesColor = True
        Legend.Frame.Visible = False
        Legend.LegendStyle = lsSeries
        Legend.ShadowSize = 0
        Legend.Symbol.Width = 0
        RightAxis.Automatic = False
        RightAxis.AutomaticMaximum = False
        RightAxis.AutomaticMinimum = False
        RightAxis.Visible = False
        TopAxis.Automatic = False
        TopAxis.AutomaticMaximum = False
        TopAxis.AutomaticMinimum = False
        TopAxis.Visible = False
        View3D = False
        View3DWalls = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        PrintMargins = (
          15
          38
          15
          38)
        object lbChTime1: TLabel
          Left = 5
          Top = 226
          Width = 72
          Height = 16
          Caption = '00:00 - 00:00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lbChG: TLabel
          Left = 11
          Top = 1
          Width = 78
          Height = 14
          Caption = 'шихтогруппы:'
          Color = clBtnFace
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object UpDown1: TUpDown
          Left = 0
          Top = 244
          Width = 77
          Height = 20
          Min = 0
          Max = 23
          Orientation = udHorizontal
          Position = 0
          TabOrder = 0
          Wrap = False
          OnMouseDown = UpDown1MouseDown
        end
      end
    end
    object SheetAlarms1: TTabSheet
      Caption = 'Сообщения'
      ImageIndex = 1
      OnShow = SheetAlarms1Show
      object Label4: TLabel
        Left = 15
        Top = 8
        Width = 119
        Height = 13
        Caption = 'о работе дозаторов'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 15
        Top = 176
        Width = 56
        Height = 13
        Caption = 'за сутки:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgAlarms1: TStringGrid
        Left = 200
        Top = 1
        Width = 799
        Height = 232
        ColCount = 3
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ColWidths = (
          64
          64
          64)
      end
      object deAlarmsDate1: TDateEdit
        Left = 14
        Top = 200
        Width = 115
        Height = 21
        DirectInput = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GlyphKind = gkDropDown
        NumGlyphs = 1
        ParentFont = False
        YearDigits = dyFour
        TabOrder = 1
        OnChange = deAlarmsDate1Change
      end
      object clbAlarms1: TRxCheckListBox
        Left = 14
        Top = 36
        Width = 161
        Height = 133
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 2
        OnClickCheck = clbAlarms1ClickCheck
        InternalVersion = 202
      end
    end
    object SheetReport1: TTabSheet
      Caption = 'Отчеты'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImageIndex = 3
      ParentFont = False
      object GroupBox3: TGroupBox
        Left = 13
        Top = 4
        Width = 360
        Height = 181
        Caption = 'Отчетный период'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 291
          Top = 96
          Width = 6
          Height = 14
          Caption = 'с'
        end
        object Label8: TLabel
          Left = 285
          Top = 133
          Width = 14
          Height = 14
          Caption = 'по'
        end
        object deReportDate1: TDateEdit
          Left = 10
          Top = 24
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 0
          OnChange = deReportDate1Change
        end
        object rbDay1: TRadioButton
          Left = 24
          Top = 64
          Width = 113
          Height = 17
          Caption = '08:00 - 20:00'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rbNight1: TRadioButton
          Left = 24
          Top = 96
          Width = 113
          Height = 17
          Caption = '20:00 - 08:00'
          TabOrder = 2
        end
        object rbMonth1: TRadioButton
          Left = 24
          Top = 128
          Width = 113
          Height = 17
          Caption = 'месяц год'
          TabOrder = 3
        end
        object rbTime1: TRadioButton
          Left = 148
          Top = 64
          Width = 125
          Height = 17
          Caption = 'дата + время:'
          TabOrder = 4
        end
        object deBeginDate1: TDateEdit
          Left = 141
          Top = 94
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 5
          OnChange = deBeginDate1Change
        end
        object deEndDate1: TDateEdit
          Left = 141
          Top = 130
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 6
          OnChange = deEndDate1Change
        end
        object meBeginTime1: TMaskEdit
          Left = 307
          Top = 92
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 7
          Text = '00:00'
        end
        object meEndTime1: TMaskEdit
          Left = 307
          Top = 128
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 8
          Text = '23:59'
        end
      end
      object btMakeReport1: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать отчет'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btMakeReport1Click
        Glyph.Data = {
          76020000424D760200000000000076000000280000001A000000200000000100
          0400000000000002000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888877777777
          777777777777782F9000888777777777777777777777774F2400800000000000
          000000000007779F40910FFFFFFFFFFFFFFFFFFFFFF0773F80020FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF0000F000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000000FF000F0000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF00000F00FF00000F00FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000F00FF0000F000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0774066420FF00000000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FFFFFFFFFFFFFFFFFFFFFF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF000000000000000F00FF077D49D940FF000000000
          000000F00FF077B92B290FFFFFFFFFFFFFFFFFF00FF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92A380FFFFFFFFFFF
          FFFFFFFFFFF0776244600FFFFFFFFFFFFFFFFFFFFFF078D499D00FFFFFFFFFFF
          FFFFFFFFFFF088A833B080000000000000000000000888434462}
      end
      object rgReportCategory1: TRadioGroup
        Left = 383
        Top = 8
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 1
        Items.Strings = (
          'Дозаторы'
          'Шихтогруппы')
        ParentFont = False
        TabOrder = 2
        OnClick = rgReportCategory1Click
      end
      object btMakeTrends1: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать диаграмму'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btMakeTrends1Click
        Glyph.Data = {
          1E030000424D1E03000000000000760000002800000022000000220000000100
          040000000000A802000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000888777777777777777777777777777777800
          0000888777777777777777777777777777777800000088877777777777777777
          77777777777778000000800000000000000000000000000000777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF07778000000802FFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F2FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080F2FFFFFFFF
          FFFFFFFFFFFFFFFFF0777800000080F2FFFFFFFFFFFFFFFFFFFF111FF0777800
          000080F2FF8FF8FF8FF8FF8FF8118FF110777800000080F2FFFFFFFFFFFFFFFF
          F1FFFFFFF0777800000080F2FFFFFFFFFFFFFFFF1FFFFFFFF0777800000080F8
          2F8FF8FF8FF8FF81F8FF8FF8F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFF
          F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFFF0777800000080F82F8FF8FF
          8FF8F18FF8FF8FF8F0777800000080FF2FFFFFFFFFFFF1FFFFFFFFFFF0777800
          0000801FF2FFFFFFFFFFF1FFFFFFFFFFF0777800000080F1F28FF8FF82281F8F
          F8FF8FF8F0777800000080F1F2FFFFFF2FF21FFFFFF222FFF0777800000080FF
          12FFFFFF2FF12FFFFF2FFF2FF0777800000080CCCCCCCCCCCCCCCCCCCCCCCCCC
          C0777800000080FFF211FFF211FFF2FFF2FFFFF220777800000080FFFF2F1112
          FFFFFF222FFFFFFFF0777800000080F8FF2FFFF28FF8FF8FF8FF8FF8F0777800
          000080FFFFF2FF2FFFFFFFFFFFFFFFFFF0777800000080FFFFFF22FFFFFFFFFF
          FFFFFFFFF0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF0777800000080FFFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F08888000000800000000000
          0000000000000000008888000000888888888888888888888888888888888800
          0000}
      end
      object clbReportCategory1: TRxCheckListBox
        Left = 656
        Top = 8
        Width = 313
        Height = 217
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 4
        Visible = False
        InternalVersion = 202
      end
      object rgReportType1: TRadioGroup
        Left = 383
        Top = 72
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Отчет'
          'Диаграмма')
        ParentFont = False
        TabOrder = 5
        OnClick = rgReportType1Click
      end
    end
    object SheetGrades1: TTabSheet
      Caption = 'Шихтовка'
      ImageIndex = 4
    end
    object SheetSumm1: TTabSheet
      Caption = 'Сводка'
      ImageIndex = 6
      object lbPrT: TLabel
        Left = 10
        Top = 12
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
      object lbPrTotal1: TLabel
        Left = 334
        Top = 9
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
      object lbPr1: TLabel
        Left = 394
        Top = 12
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
      object lbPrTot11: TLabel
        Left = 595
        Top = 9
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
      object lbPr2: TLabel
        Left = 649
        Top = 12
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
      object lbPrTot21: TLabel
        Left = 708
        Top = 9
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
      object lbW: TLabel
        Left = 764
        Top = 12
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
      object lbWeight1: TLabel
        Left = 937
        Top = 9
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
      object lbTablePc: TLabel
        Left = 367
        Top = 70
        Width = 283
        Height = 14
        Caption = 'Соотношение шихтогрупп за последние 4 минуты.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 10
        Top = 42
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
      object lbPrU1: TLabel
        Left = 334
        Top = 40
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
      object Label7: TLabel
        Left = 572
        Top = 42
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
      object lbWeightU1: TLabel
        Left = 937
        Top = 40
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
      object sgGradesPc1: TStringGrid
        Left = 2
        Top = 90
        Width = 1000
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
        OnDrawCell = sgGradesPc1DrawCell
      end
    end
  end
  object PageControl2: TPageControl
    Left = 4
    Top = 400
    Width = 1012
    Height = 300
    ActivePage = SheetGrades2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Style = tsButtons
    TabOrder = 1
    object TabSheet2: TTabSheet
      Caption = 'Диаграмма'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      object DBChart2: TDBChart
        Left = 0
        Top = 0
        Width = 1004
        Height = 267
        ShowGlassCursor = False
        AllowPanning = pmNone
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginBottom = 2
        MarginLeft = 1
        MarginRight = 1
        MarginTop = 2
        Title.AdjustFrame = False
        Title.Font.Charset = RUSSIAN_CHARSET
        Title.Font.Color = clNavy
        Title.Font.Height = -13
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '')
        Title.Visible = False
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.DateTimeFormat = 'hh:mm'
        BottomAxis.ExactDateTime = False
        DepthAxis.Automatic = False
        DepthAxis.AutomaticMaximum = False
        DepthAxis.AutomaticMinimum = False
        DepthAxis.Maximum = 0.5
        DepthAxis.Minimum = -0.5
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Axis.Width = 1
        LeftAxis.Axis.Visible = False
        LeftAxis.ExactDateTime = False
        LeftAxis.Maximum = 400
        Legend.Alignment = laLeft
        Legend.CheckBoxes = True
        Legend.Color = clBtnFace
        Legend.ColorWidth = 0
        Legend.Font.Charset = RUSSIAN_CHARSET
        Legend.FontSeriesColor = True
        Legend.Frame.Visible = False
        Legend.LegendStyle = lsSeries
        Legend.ShadowSize = 0
        Legend.Symbol.Width = 0
        RightAxis.Automatic = False
        RightAxis.AutomaticMaximum = False
        RightAxis.AutomaticMinimum = False
        RightAxis.Visible = False
        TopAxis.Automatic = False
        TopAxis.AutomaticMaximum = False
        TopAxis.AutomaticMinimum = False
        TopAxis.Visible = False
        View3D = False
        View3DWalls = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        PrintMargins = (
          15
          38
          15
          38)
        object lbChTime2: TLabel
          Left = 5
          Top = 226
          Width = 72
          Height = 16
          Caption = '00:00 - 00:00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 11
          Top = 1
          Width = 78
          Height = 14
          Caption = 'шихтогруппы:'
          Color = clBtnFace
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object UpDown2: TUpDown
          Left = 0
          Top = 244
          Width = 77
          Height = 20
          Min = 0
          Max = 23
          Orientation = udHorizontal
          Position = 0
          TabOrder = 0
          Wrap = False
          OnMouseDown = UpDown2MouseDown
        end
      end
    end
    object SheetAlarms2: TTabSheet
      Caption = 'Сообщения'
      ImageIndex = 1
      OnShow = SheetAlarms2Show
      object Label12: TLabel
        Left = 15
        Top = 8
        Width = 119
        Height = 13
        Caption = 'о работе дозаторов'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 15
        Top = 176
        Width = 56
        Height = 13
        Caption = 'за сутки:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgAlarms2: TStringGrid
        Left = 200
        Top = 1
        Width = 799
        Height = 232
        ColCount = 3
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ColWidths = (
          64
          64
          64)
      end
      object deAlarmsDate2: TDateEdit
        Left = 14
        Top = 200
        Width = 115
        Height = 21
        DirectInput = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GlyphKind = gkDropDown
        NumGlyphs = 1
        ParentFont = False
        YearDigits = dyFour
        TabOrder = 1
        OnChange = deAlarmsDate2Change
      end
      object clbAlarms2: TRxCheckListBox
        Left = 14
        Top = 36
        Width = 161
        Height = 133
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 2
        OnClickCheck = clbAlarms2ClickCheck
        InternalVersion = 202
      end
    end
    object SheetReport2: TTabSheet
      Caption = 'Отчеты'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImageIndex = 3
      ParentFont = False
      object GroupBox4: TGroupBox
        Left = 13
        Top = 4
        Width = 360
        Height = 181
        Caption = 'Отчетный период'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label19: TLabel
          Left = 291
          Top = 96
          Width = 6
          Height = 14
          Caption = 'с'
        end
        object Label20: TLabel
          Left = 285
          Top = 133
          Width = 14
          Height = 14
          Caption = 'по'
        end
        object deReportDate2: TDateEdit
          Left = 10
          Top = 24
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 0
          OnChange = deReportDate2Change
        end
        object rbDay2: TRadioButton
          Left = 24
          Top = 64
          Width = 113
          Height = 17
          Caption = '08:00 - 20:00'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rbNight2: TRadioButton
          Left = 24
          Top = 96
          Width = 113
          Height = 17
          Caption = '20:00 - 08:00'
          TabOrder = 2
        end
        object rbMonth2: TRadioButton
          Left = 24
          Top = 128
          Width = 113
          Height = 17
          Caption = 'месяц год'
          TabOrder = 3
        end
        object meBeginTime2: TMaskEdit
          Left = 307
          Top = 92
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 4
          Text = '00:00'
        end
        object meEndTime2: TMaskEdit
          Left = 307
          Top = 128
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 5
          Text = '23:59'
        end
        object rbTime2: TRadioButton
          Left = 148
          Top = 64
          Width = 125
          Height = 17
          Caption = 'дата + время:'
          TabOrder = 6
        end
        object deBeginDate2: TDateEdit
          Left = 141
          Top = 94
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 7
          OnChange = deReportDate2Change
        end
        object deEndDate2: TDateEdit
          Left = 141
          Top = 130
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 8
          OnChange = deReportDate2Change
        end
      end
      object btMakeReport2: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать отчет'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btMakeReport2Click
        Glyph.Data = {
          76020000424D760200000000000076000000280000001A000000200000000100
          0400000000000002000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888877777777
          777777777777782F9000888777777777777777777777774F2400800000000000
          000000000007779F40910FFFFFFFFFFFFFFFFFFFFFF0773F80020FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF0000F000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000000FF000F0000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF00000F00FF00000F00FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000F00FF0000F000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0774066420FF00000000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FFFFFFFFFFFFFFFFFFFFFF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF000000000000000F00FF077D49D940FF000000000
          000000F00FF077B92B290FFFFFFFFFFFFFFFFFF00FF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92A380FFFFFFFFFFF
          FFFFFFFFFFF0776244600FFFFFFFFFFFFFFFFFFFFFF078D499D00FFFFFFFFFFF
          FFFFFFFFFFF088A833B080000000000000000000000888434462}
      end
      object rgReportCategory2: TRadioGroup
        Left = 383
        Top = 8
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 1
        Items.Strings = (
          'Дозаторы'
          'Шихтогруппы')
        ParentFont = False
        TabOrder = 2
        OnClick = rgReportCategory2Click
      end
      object btMakeTrends2: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать диаграмму'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btMakeTrends2Click
        Glyph.Data = {
          1E030000424D1E03000000000000760000002800000022000000220000000100
          040000000000A802000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000888777777777777777777777777777777800
          0000888777777777777777777777777777777800000088877777777777777777
          77777777777778000000800000000000000000000000000000777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF07778000000802FFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F2FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080F2FFFFFFFF
          FFFFFFFFFFFFFFFFF0777800000080F2FFFFFFFFFFFFFFFFFFFF111FF0777800
          000080F2FF8FF8FF8FF8FF8FF8118FF110777800000080F2FFFFFFFFFFFFFFFF
          F1FFFFFFF0777800000080F2FFFFFFFFFFFFFFFF1FFFFFFFF0777800000080F8
          2F8FF8FF8FF8FF81F8FF8FF8F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFF
          F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFFF0777800000080F82F8FF8FF
          8FF8F18FF8FF8FF8F0777800000080FF2FFFFFFFFFFFF1FFFFFFFFFFF0777800
          0000801FF2FFFFFFFFFFF1FFFFFFFFFFF0777800000080F1F28FF8FF82281F8F
          F8FF8FF8F0777800000080F1F2FFFFFF2FF21FFFFFF222FFF0777800000080FF
          12FFFFFF2FF12FFFFF2FFF2FF0777800000080CCCCCCCCCCCCCCCCCCCCCCCCCC
          C0777800000080FFF211FFF211FFF2FFF2FFFFF220777800000080FFFF2F1112
          FFFFFF222FFFFFFFF0777800000080F8FF2FFFF28FF8FF8FF8FF8FF8F0777800
          000080FFFFF2FF2FFFFFFFFFFFFFFFFFF0777800000080FFFFFF22FFFFFFFFFF
          FFFFFFFFF0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF0777800000080FFFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F08888000000800000000000
          0000000000000000008888000000888888888888888888888888888888888800
          0000}
      end
      object clbReportCategory2: TRxCheckListBox
        Left = 656
        Top = 8
        Width = 313
        Height = 217
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 4
        InternalVersion = 202
      end
      object rgReportType2: TRadioGroup
        Left = 383
        Top = 72
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Отчет'
          'Диаграмма')
        ParentFont = False
        TabOrder = 5
        OnClick = rgReportType2Click
      end
    end
    object SheetGrades2: TTabSheet
      Caption = 'Шихтовка'
      ImageIndex = 4
    end
    object SheetSumm2: TTabSheet
      Caption = 'Сводка'
      ImageIndex = 6
      object Label21: TLabel
        Left = 10
        Top = 12
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
      object lbPrTotal2: TLabel
        Left = 334
        Top = 9
        Width = 9
        Height = 19
        Caption = '0'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label23: TLabel
        Left = 394
        Top = 12
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
      object lbPrTot12: TLabel
        Left = 595
        Top = 9
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
        Top = 12
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
      object lbPrTot22: TLabel
        Left = 708
        Top = 9
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
        Top = 12
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
      object lbWeight2: TLabel
        Left = 937
        Top = 9
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
      object Label29: TLabel
        Left = 367
        Top = 70
        Width = 283
        Height = 14
        Caption = 'Соотношение шихтогрупп за последние 4 минуты.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label30: TLabel
        Left = 10
        Top = 42
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
      object lbPrU2: TLabel
        Left = 334
        Top = 40
        Width = 9
        Height = 19
        Caption = '0'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label1: TLabel
        Left = 572
        Top = 42
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
      object lbWeightU2: TLabel
        Left = 937
        Top = 40
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
      object sgGradesPc2: TStringGrid
        Left = 2
        Top = 90
        Width = 1000
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
        OnDrawCell = sgGradesPc2DrawCell
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 360
    Width = 305
    Height = 28
    Caption = 'Дозировочное отделение №2'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 8
    Top = 7
    Width = 305
    Height = 28
    Caption = 'Дозировочное отделение №1'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
end
object DO1DO2Form: TDO1DO2Form
  Left = 13
  Top = 102
  BorderStyle = bsDialog
  Caption = 'Шихтовки, диаграммы, отчеты'
  ClientHeight = 705
  ClientWidth = 1017
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 47
    Width = 1012
    Height = 300
    ActivePage = SheetTrends
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Style = tsButtons
    TabOrder = 0
    object SheetTrends: TTabSheet
      Caption = 'Диаграмма'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      object DBChart1: TDBChart
        Left = 0
        Top = 0
        Width = 1004
        Height = 267
        ShowGlassCursor = False
        AllowPanning = pmNone
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginBottom = 2
        MarginLeft = 1
        MarginRight = 1
        MarginTop = 2
        Title.AdjustFrame = False
        Title.Font.Charset = RUSSIAN_CHARSET
        Title.Font.Color = clNavy
        Title.Font.Height = -13
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '')
        Title.Visible = False
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.DateTimeFormat = 'hh:mm'
        BottomAxis.ExactDateTime = False
        DepthAxis.Automatic = False
        DepthAxis.AutomaticMaximum = False
        DepthAxis.AutomaticMinimum = False
        DepthAxis.Maximum = 0.5
        DepthAxis.Minimum = -0.5
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Axis.Width = 1
        LeftAxis.Axis.Visible = False
        LeftAxis.ExactDateTime = False
        LeftAxis.Maximum = 200
        Legend.Alignment = laLeft
        Legend.CheckBoxes = True
        Legend.Color = clBtnFace
        Legend.ColorWidth = 0
        Legend.Font.Charset = RUSSIAN_CHARSET
        Legend.FontSeriesColor = True
        Legend.Frame.Visible = False
        Legend.LegendStyle = lsSeries
        Legend.ShadowSize = 0
        Legend.Symbol.Width = 0
        RightAxis.Automatic = False
        RightAxis.AutomaticMaximum = False
        RightAxis.AutomaticMinimum = False
        RightAxis.Visible = False
        TopAxis.Automatic = False
        TopAxis.AutomaticMaximum = False
        TopAxis.AutomaticMinimum = False
        TopAxis.Visible = False
        View3D = False
        View3DWalls = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        PrintMargins = (
          15
          38
          15
          38)
        object lbChTime1: TLabel
          Left = 5
          Top = 226
          Width = 72
          Height = 16
          Caption = '00:00 - 00:00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lbChG: TLabel
          Left = 11
          Top = 1
          Width = 78
          Height = 14
          Caption = 'шихтогруппы:'
          Color = clBtnFace
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object UpDown1: TUpDown
          Left = 0
          Top = 244
          Width = 77
          Height = 20
          Min = 0
          Max = 23
          Orientation = udHorizontal
          Position = 0
          TabOrder = 0
          Wrap = False
          OnMouseDown = UpDown1MouseDown
        end
      end
    end
    object SheetAlarms1: TTabSheet
      Caption = 'Сообщения'
      ImageIndex = 1
      OnShow = SheetAlarms1Show
      object Label4: TLabel
        Left = 15
        Top = 8
        Width = 119
        Height = 13
        Caption = 'о работе дозаторов'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 15
        Top = 176
        Width = 56
        Height = 13
        Caption = 'за сутки:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgAlarms1: TStringGrid
        Left = 200
        Top = 1
        Width = 799
        Height = 232
        ColCount = 3
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ColWidths = (
          64
          64
          64)
      end
      object deAlarmsDate1: TDateEdit
        Left = 14
        Top = 200
        Width = 115
        Height = 21
        DirectInput = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GlyphKind = gkDropDown
        NumGlyphs = 1
        ParentFont = False
        YearDigits = dyFour
        TabOrder = 1
        OnChange = deAlarmsDate1Change
      end
      object clbAlarms1: TRxCheckListBox
        Left = 14
        Top = 36
        Width = 161
        Height = 133
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 2
        OnClickCheck = clbAlarms1ClickCheck
        InternalVersion = 202
      end
    end
    object SheetReport1: TTabSheet
      Caption = 'Отчеты'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImageIndex = 3
      ParentFont = False
      object GroupBox3: TGroupBox
        Left = 13
        Top = 4
        Width = 360
        Height = 181
        Caption = 'Отчетный период'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 291
          Top = 96
          Width = 6
          Height = 14
          Caption = 'с'
        end
        object Label8: TLabel
          Left = 285
          Top = 133
          Width = 14
          Height = 14
          Caption = 'по'
        end
        object deReportDate1: TDateEdit
          Left = 10
          Top = 24
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 0
          OnChange = deReportDate1Change
        end
        object rbDay1: TRadioButton
          Left = 24
          Top = 64
          Width = 113
          Height = 17
          Caption = '08:00 - 20:00'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rbNight1: TRadioButton
          Left = 24
          Top = 96
          Width = 113
          Height = 17
          Caption = '20:00 - 08:00'
          TabOrder = 2
        end
        object rbMonth1: TRadioButton
          Left = 24
          Top = 128
          Width = 113
          Height = 17
          Caption = 'месяц год'
          TabOrder = 3
        end
        object rbTime1: TRadioButton
          Left = 148
          Top = 64
          Width = 125
          Height = 17
          Caption = 'дата + время:'
          TabOrder = 4
        end
        object deBeginDate1: TDateEdit
          Left = 141
          Top = 94
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 5
          OnChange = deBeginDate1Change
        end
        object deEndDate1: TDateEdit
          Left = 141
          Top = 130
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 6
          OnChange = deEndDate1Change
        end
        object meBeginTime1: TMaskEdit
          Left = 307
          Top = 92
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 7
          Text = '00:00'
        end
        object meEndTime1: TMaskEdit
          Left = 307
          Top = 128
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 8
          Text = '23:59'
        end
      end
      object btMakeReport1: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать отчет'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btMakeReport1Click
        Glyph.Data = {
          76020000424D760200000000000076000000280000001A000000200000000100
          0400000000000002000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888877777777
          777777777777782F9000888777777777777777777777774F2400800000000000
          000000000007779F40910FFFFFFFFFFFFFFFFFFFFFF0773F80020FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF0000F000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000000FF000F0000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF00000F00FF00000F00FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000F00FF0000F000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0774066420FF00000000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FFFFFFFFFFFFFFFFFFFFFF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF000000000000000F00FF077D49D940FF000000000
          000000F00FF077B92B290FFFFFFFFFFFFFFFFFF00FF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92A380FFFFFFFFFFF
          FFFFFFFFFFF0776244600FFFFFFFFFFFFFFFFFFFFFF078D499D00FFFFFFFFFFF
          FFFFFFFFFFF088A833B080000000000000000000000888434462}
      end
      object rgReportCategory1: TRadioGroup
        Left = 383
        Top = 8
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 1
        Items.Strings = (
          'Дозаторы'
          'Шихтогруппы')
        ParentFont = False
        TabOrder = 2
        OnClick = rgReportCategory1Click
      end
      object btMakeTrends1: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать диаграмму'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btMakeTrends1Click
        Glyph.Data = {
          1E030000424D1E03000000000000760000002800000022000000220000000100
          040000000000A802000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000888777777777777777777777777777777800
          0000888777777777777777777777777777777800000088877777777777777777
          77777777777778000000800000000000000000000000000000777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF07778000000802FFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F2FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080F2FFFFFFFF
          FFFFFFFFFFFFFFFFF0777800000080F2FFFFFFFFFFFFFFFFFFFF111FF0777800
          000080F2FF8FF8FF8FF8FF8FF8118FF110777800000080F2FFFFFFFFFFFFFFFF
          F1FFFFFFF0777800000080F2FFFFFFFFFFFFFFFF1FFFFFFFF0777800000080F8
          2F8FF8FF8FF8FF81F8FF8FF8F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFF
          F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFFF0777800000080F82F8FF8FF
          8FF8F18FF8FF8FF8F0777800000080FF2FFFFFFFFFFFF1FFFFFFFFFFF0777800
          0000801FF2FFFFFFFFFFF1FFFFFFFFFFF0777800000080F1F28FF8FF82281F8F
          F8FF8FF8F0777800000080F1F2FFFFFF2FF21FFFFFF222FFF0777800000080FF
          12FFFFFF2FF12FFFFF2FFF2FF0777800000080CCCCCCCCCCCCCCCCCCCCCCCCCC
          C0777800000080FFF211FFF211FFF2FFF2FFFFF220777800000080FFFF2F1112
          FFFFFF222FFFFFFFF0777800000080F8FF2FFFF28FF8FF8FF8FF8FF8F0777800
          000080FFFFF2FF2FFFFFFFFFFFFFFFFFF0777800000080FFFFFF22FFFFFFFFFF
          FFFFFFFFF0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF0777800000080FFFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F08888000000800000000000
          0000000000000000008888000000888888888888888888888888888888888800
          0000}
      end
      object clbReportCategory1: TRxCheckListBox
        Left = 656
        Top = 8
        Width = 313
        Height = 217
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 4
        Visible = False
        InternalVersion = 202
      end
      object rgReportType1: TRadioGroup
        Left = 383
        Top = 72
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Отчет'
          'Диаграмма')
        ParentFont = False
        TabOrder = 5
        OnClick = rgReportType1Click
      end
    end
    object SheetGrades1: TTabSheet
      Caption = 'Шихтовка'
      ImageIndex = 4
    end
    object SheetSumm1: TTabSheet
      Caption = 'Сводка'
      ImageIndex = 6
      object lbPrT: TLabel
        Left = 10
        Top = 12
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
      object lbPrTotal1: TLabel
        Left = 334
        Top = 9
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
      object lbPr1: TLabel
        Left = 394
        Top = 12
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
      object lbPrTot11: TLabel
        Left = 595
        Top = 9
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
      object lbPr2: TLabel
        Left = 649
        Top = 12
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
      object lbPrTot21: TLabel
        Left = 708
        Top = 9
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
      object lbW: TLabel
        Left = 764
        Top = 12
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
      object lbWeight1: TLabel
        Left = 937
        Top = 9
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
      object lbTablePc: TLabel
        Left = 367
        Top = 70
        Width = 283
        Height = 14
        Caption = 'Соотношение шихтогрупп за последние 4 минуты.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 10
        Top = 42
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
      object lbPrU1: TLabel
        Left = 334
        Top = 40
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
      object Label7: TLabel
        Left = 572
        Top = 42
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
      object lbWeightU1: TLabel
        Left = 937
        Top = 40
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
      object sgGradesPc1: TStringGrid
        Left = 2
        Top = 90
        Width = 1000
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
        OnDrawCell = sgGradesPc1DrawCell
      end
    end
  end
  object PageControl2: TPageControl
    Left = 4
    Top = 400
    Width = 1012
    Height = 300
    ActivePage = SheetGrades2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Style = tsButtons
    TabOrder = 1
    object TabSheet2: TTabSheet
      Caption = 'Диаграмма'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      object DBChart2: TDBChart
        Left = 0
        Top = 0
        Width = 1004
        Height = 267
        ShowGlassCursor = False
        AllowPanning = pmNone
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        MarginBottom = 2
        MarginLeft = 1
        MarginRight = 1
        MarginTop = 2
        Title.AdjustFrame = False
        Title.Font.Charset = RUSSIAN_CHARSET
        Title.Font.Color = clNavy
        Title.Font.Height = -13
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '')
        Title.Visible = False
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.DateTimeFormat = 'hh:mm'
        BottomAxis.ExactDateTime = False
        DepthAxis.Automatic = False
        DepthAxis.AutomaticMaximum = False
        DepthAxis.AutomaticMinimum = False
        DepthAxis.Maximum = 0.5
        DepthAxis.Minimum = -0.5
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Axis.Width = 1
        LeftAxis.Axis.Visible = False
        LeftAxis.ExactDateTime = False
        LeftAxis.Maximum = 400
        Legend.Alignment = laLeft
        Legend.CheckBoxes = True
        Legend.Color = clBtnFace
        Legend.ColorWidth = 0
        Legend.Font.Charset = RUSSIAN_CHARSET
        Legend.FontSeriesColor = True
        Legend.Frame.Visible = False
        Legend.LegendStyle = lsSeries
        Legend.ShadowSize = 0
        Legend.Symbol.Width = 0
        RightAxis.Automatic = False
        RightAxis.AutomaticMaximum = False
        RightAxis.AutomaticMinimum = False
        RightAxis.Visible = False
        TopAxis.Automatic = False
        TopAxis.AutomaticMaximum = False
        TopAxis.AutomaticMinimum = False
        TopAxis.Visible = False
        View3D = False
        View3DWalls = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        PrintMargins = (
          15
          38
          15
          38)
        object lbChTime2: TLabel
          Left = 5
          Top = 226
          Width = 72
          Height = 16
          Caption = '00:00 - 00:00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 11
          Top = 1
          Width = 78
          Height = 14
          Caption = 'шихтогруппы:'
          Color = clBtnFace
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object UpDown2: TUpDown
          Left = 0
          Top = 244
          Width = 77
          Height = 20
          Min = 0
          Max = 23
          Orientation = udHorizontal
          Position = 0
          TabOrder = 0
          Wrap = False
          OnMouseDown = UpDown2MouseDown
        end
      end
    end
    object SheetAlarms2: TTabSheet
      Caption = 'Сообщения'
      ImageIndex = 1
      OnShow = SheetAlarms2Show
      object Label12: TLabel
        Left = 15
        Top = 8
        Width = 119
        Height = 13
        Caption = 'о работе дозаторов'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 15
        Top = 176
        Width = 56
        Height = 13
        Caption = 'за сутки:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgAlarms2: TStringGrid
        Left = 200
        Top = 1
        Width = 799
        Height = 232
        ColCount = 3
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ColWidths = (
          64
          64
          64)
      end
      object deAlarmsDate2: TDateEdit
        Left = 14
        Top = 200
        Width = 115
        Height = 21
        DirectInput = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GlyphKind = gkDropDown
        NumGlyphs = 1
        ParentFont = False
        YearDigits = dyFour
        TabOrder = 1
        OnChange = deAlarmsDate2Change
      end
      object clbAlarms2: TRxCheckListBox
        Left = 14
        Top = 36
        Width = 161
        Height = 133
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 2
        OnClickCheck = clbAlarms2ClickCheck
        InternalVersion = 202
      end
    end
    object SheetReport2: TTabSheet
      Caption = 'Отчеты'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImageIndex = 3
      ParentFont = False
      object GroupBox4: TGroupBox
        Left = 13
        Top = 4
        Width = 360
        Height = 181
        Caption = 'Отчетный период'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label19: TLabel
          Left = 291
          Top = 96
          Width = 6
          Height = 14
          Caption = 'с'
        end
        object Label20: TLabel
          Left = 285
          Top = 133
          Width = 14
          Height = 14
          Caption = 'по'
        end
        object deReportDate2: TDateEdit
          Left = 10
          Top = 24
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 0
          OnChange = deReportDate2Change
        end
        object rbDay2: TRadioButton
          Left = 24
          Top = 64
          Width = 113
          Height = 17
          Caption = '08:00 - 20:00'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rbNight2: TRadioButton
          Left = 24
          Top = 96
          Width = 113
          Height = 17
          Caption = '20:00 - 08:00'
          TabOrder = 2
        end
        object rbMonth2: TRadioButton
          Left = 24
          Top = 128
          Width = 113
          Height = 17
          Caption = 'месяц год'
          TabOrder = 3
        end
        object meBeginTime2: TMaskEdit
          Left = 307
          Top = 92
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 4
          Text = '00:00'
        end
        object meEndTime2: TMaskEdit
          Left = 307
          Top = 128
          Width = 41
          Height = 24
          EditMask = '!90:00;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 5
          ParentFont = False
          TabOrder = 5
          Text = '23:59'
        end
        object rbTime2: TRadioButton
          Left = 148
          Top = 64
          Width = 125
          Height = 17
          Caption = 'дата + время:'
          TabOrder = 6
        end
        object deBeginDate2: TDateEdit
          Left = 141
          Top = 94
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 7
          OnChange = deReportDate2Change
        end
        object deEndDate2: TDateEdit
          Left = 141
          Top = 130
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GlyphKind = gkDropDown
          NumGlyphs = 1
          ParentFont = False
          YearDigits = dyFour
          TabOrder = 8
          OnChange = deReportDate2Change
        end
      end
      object btMakeReport2: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать отчет'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btMakeReport2Click
        Glyph.Data = {
          76020000424D760200000000000076000000280000001A000000200000000100
          0400000000000002000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888877777777
          777777777777782F9000888777777777777777777777774F2400800000000000
          000000000007779F40910FFFFFFFFFFFFFFFFFFFFFF0773F80020FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF0000F000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000000FF000F0000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF00000F00FF00000F00FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FF000F0000FF00000000FF0776246420FFFFFFFFFFF
          FFFFFFFFFFF077D49D940FF00000F00FF0000F000FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0774066420FF00000000FF00F00000FF077D49D940FFFFFFFFFFF
          FFFFFFFFFFF077B92B290FFFFFFFFFFFFFFFFFFFFFF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92B290FFFFFFFFFFF
          FFFFFFFFFFF0776246420FF000000000000000F00FF077D49D940FF000000000
          000000F00FF077B92B290FFFFFFFFFFFFFFFFFF00FF0776246420FF000000000
          000000F00FF077D49D940FF000000000000000F00FF077B92A380FFFFFFFFFFF
          FFFFFFFFFFF0776244600FFFFFFFFFFFFFFFFFFFFFF078D499D00FFFFFFFFFFF
          FFFFFFFFFFF088A833B080000000000000000000000888434462}
      end
      object rgReportCategory2: TRadioGroup
        Left = 383
        Top = 8
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 1
        Items.Strings = (
          'Дозаторы'
          'Шихтогруппы')
        ParentFont = False
        TabOrder = 2
        OnClick = rgReportCategory2Click
      end
      object btMakeTrends2: TBitBtn
        Left = 383
        Top = 136
        Width = 257
        Height = 41
        Caption = 'Сформировать диаграмму'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btMakeTrends2Click
        Glyph.Data = {
          1E030000424D1E03000000000000760000002800000022000000220000000100
          040000000000A802000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000888777777777777777777777777777777800
          0000888777777777777777777777777777777800000088877777777777777777
          77777777777778000000800000000000000000000000000000777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF07778000000802FFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F2FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080F2FFFFFFFF
          FFFFFFFFFFFFFFFFF0777800000080F2FFFFFFFFFFFFFFFFFFFF111FF0777800
          000080F2FF8FF8FF8FF8FF8FF8118FF110777800000080F2FFFFFFFFFFFFFFFF
          F1FFFFFFF0777800000080F2FFFFFFFFFFFFFFFF1FFFFFFFF0777800000080F8
          2F8FF8FF8FF8FF81F8FF8FF8F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFF
          F0777800000080FF2FFFFFFFFFFFFF1FFFFFFFFFF0777800000080F82F8FF8FF
          8FF8F18FF8FF8FF8F0777800000080FF2FFFFFFFFFFFF1FFFFFFFFFFF0777800
          0000801FF2FFFFFFFFFFF1FFFFFFFFFFF0777800000080F1F28FF8FF82281F8F
          F8FF8FF8F0777800000080F1F2FFFFFF2FF21FFFFFF222FFF0777800000080FF
          12FFFFFF2FF12FFFFF2FFF2FF0777800000080CCCCCCCCCCCCCCCCCCCCCCCCCC
          C0777800000080FFF211FFF211FFF2FFF2FFFFF220777800000080FFFF2F1112
          FFFFFF222FFFFFFFF0777800000080F8FF2FFFF28FF8FF8FF8FF8FF8F0777800
          000080FFFFF2FF2FFFFFFFFFFFFFFFFFF0777800000080FFFFFF22FFFFFFFFFF
          FFFFFFFFF0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F0777800000080FF
          FFFFFFFFFFFFFFFFFFFFFFFFF0777800000080FFFFFFFFFFFFFFFFFFFFFFFFFF
          F0777800000080F8FF8FF8FF8FF8FF8FF8FF8FF8F08888000000800000000000
          0000000000000000008888000000888888888888888888888888888888888800
          0000}
      end
      object clbReportCategory2: TRxCheckListBox
        Left = 656
        Top = 8
        Width = 313
        Height = 217
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 4
        InternalVersion = 202
      end
      object rgReportType2: TRadioGroup
        Left = 383
        Top = 72
        Width = 257
        Height = 49
        Columns = 2
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Отчет'
          'Диаграмма')
        ParentFont = False
        TabOrder = 5
        OnClick = rgReportType2Click
      end
    end
    object SheetGrades2: TTabSheet
      Caption = 'Шихтовка'
      ImageIndex = 4
    end
    object SheetSumm2: TTabSheet
      Caption = 'Сводка'
      ImageIndex = 6
      object Label21: TLabel
        Left = 10
        Top = 12
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
      object lbPrTotal2: TLabel
        Left = 334
        Top = 9
        Width = 9
        Height = 19
        Caption = '0'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label23: TLabel
        Left = 394
        Top = 12
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
      object lbPrTot12: TLabel
        Left = 595
        Top = 9
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
        Top = 12
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
      object lbPrTot22: TLabel
        Left = 708
        Top = 9
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
        Top = 12
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
      object lbWeight2: TLabel
        Left = 937
        Top = 9
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
      object Label29: TLabel
        Left = 367
        Top = 70
        Width = 283
        Height = 14
        Caption = 'Соотношение шихтогрупп за последние 4 минуты.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label30: TLabel
        Left = 10
        Top = 42
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
      object lbPrU2: TLabel
        Left = 334
        Top = 40
        Width = 9
        Height = 19
        Caption = '0'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label1: TLabel
        Left = 572
        Top = 42
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
      object lbWeightU2: TLabel
        Left = 937
        Top = 40
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
      object sgGradesPc2: TStringGrid
        Left = 2
        Top = 90
        Width = 1000
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
        OnDrawCell = sgGradesPc2DrawCell
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 360
    Width = 305
    Height = 28
    Caption = 'Дозировочное отделение №2'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 8
    Top = 7
    Width = 305
    Height = 28
    Caption = 'Дозировочное отделение №1'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
end
