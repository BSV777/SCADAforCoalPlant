object PrintForm: TPrintForm
  Left = 252
  Top = 366
  Width = 645
  Height = 296
  Caption = 'PrintForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object QuickRep1: TQuickRep
    Left = -2
    Top = -14
    Width = 674
    Height = 476
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poLandscape
    Page.PaperSize = A4Small
    Page.Values = (
      50
      2100
      100
      2970
      50
      100
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = Auto
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 60
    object TitleBand1: TQRBand
      Left = 11
      Top = 23
      Width = 640
      Height = 42
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        185.208333333333
        2822.22222222222)
      BandType = rbTitle
      object QRLabel1: TQRLabel
        Left = 0
        Top = 2
        Width = 641
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          57.3263888888889
          0
          8.81944444444444
          2826.63194444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Отчет'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object QRLabel2: TQRLabel
        Left = -1
        Top = 19
        Width = 641
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          57.3263888888889
          -4.40972222222222
          83.7847222222222
          2826.63194444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Отчет'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
    end
    object QRChart1: TQRChart
      Left = 12
      Top = 56
      Width = 637
      Height = 407
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        1794.75694444444
        52.9166666666667
        246.944444444444
        2808.99305555556)
      object QRDBChart1: TQRDBChart
        Left = -1
        Top = -1
        Width = 1
        Height = 1
        MarginBottom = 1
        MarginLeft = 1
        MarginRight = 0
        MarginTop = 0
        Title.AdjustFrame = False
        Title.Text.Strings = (
          'TQRChart')
        Title.Visible = False
        DepthAxis.Automatic = False
        DepthAxis.AutomaticMaximum = False
        DepthAxis.AutomaticMinimum = False
        DepthAxis.Maximum = 0.5
        DepthAxis.Minimum = -0.5
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 400
        Legend.Alignment = laBottom
        Legend.ColorWidth = 0
        Legend.CurrentPage = False
        Legend.DividingLines.Width = 5
        Legend.Font.Charset = RUSSIAN_CHARSET
        Legend.FontSeriesColor = True
        Legend.Frame.Visible = False
        Legend.LegendStyle = lsSeries
        Legend.ResizeChart = False
        Legend.ShadowSize = 0
        Legend.Symbol.Width = 0
        RightAxis.Automatic = False
        RightAxis.AutomaticMaximum = False
        RightAxis.AutomaticMinimum = False
        RightAxis.Visible = False
        ScaleLastPage = False
        TopAxis.Automatic = False
        TopAxis.AutomaticMaximum = False
        TopAxis.AutomaticMinimum = False
        TopAxis.Visible = False
        View3D = False
        View3DWalls = False
        PrintMargins = (
          15
          22
          15
          22)
      end
    end
  end
end
