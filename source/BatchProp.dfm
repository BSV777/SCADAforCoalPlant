object BatchPropForm: TBatchPropForm
  Left = 104
  Top = 340
  BorderStyle = bsDialog
  Caption = 'Просмотр и корректировка параметров дозатора'
  ClientHeight = 217
  ClientWidth = 802
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDeactivate = FormDeactivate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object lbN: TLabel
    Left = 16
    Top = 16
    Width = 64
    Height = 14
    Caption = 'Дозатор №:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrGrade: TLabel
    Left = 16
    Top = 60
    Width = 65
    Height = 14
    Caption = 'Марка угля:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 16
    Top = 136
    Width = 262
    Height = 13
    Caption = 'Рекомендуемая производительность, [т/ч]:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbRecommend: TLabel
    Left = 320
    Top = 125
    Width = 54
    Height = 37
    Alignment = taRightJustify
    Caption = '___'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbBatN: TLabel
    Left = 96
    Top = 5
    Width = 54
    Height = 37
    Alignment = taRightJustify
    Caption = '___'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbMount: TCheckBox
    Left = 240
    Top = 16
    Width = 137
    Height = 17
    Caption = 'дозатор в работе'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object cbPropGrade: TComboBox
    Left = 152
    Top = 56
    Width = 153
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 1
  end
  object btSaveConfig: TBitBtn
    Left = 16
    Top = 162
    Width = 199
    Height = 41
    Caption = 'Запись изменений'
    Default = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = btSaveConfigClick
    Glyph.Data = {
      B6010000424DB601000000000000760000002800000020000000140000000100
      0400000000004001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
      000000000000000000000F7777777777777777777777777777700FF777777777
      777777777777777777700FF888888888888888888888888887700FF888888888
      888888888888888887700FF888888888888888888888888887700FF87FFFFFFF
      FFFFFFFFFFFFFFFF87700FF87888AA88888888888877788F87700FF87888AA8F
      FFFFFFFFF8FF788F87700FF878FFFFF0000000000FFFFF8F87700FF878000000
      000000000000008F87700FF878888880000000000888888F87700FF878888888
      888888888888888F87700FF877777777777777777777777F87700FF888888888
      888888888888888887700FF888888888888888888888888887700FF888888888
      888888888888888887700FFFFFFFFFFFFFFFFFFFFFFFFFFFF7700FFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF7000000000000000000000000000000000}
  end
  object GroupBox1: TGroupBox
    Left = 400
    Top = 16
    Width = 393
    Height = 193
    Caption = 'Текущая мгновенная производительность дозатора, [т/ч]'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object lbCurrent: TLabel
      Left = 26
      Top = 32
      Width = 343
      Height = 153
      Alignment = taRightJustify
      AutoSize = False
      Caption = '____'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -107
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object edAddGrade: TEdit
    Left = 152
    Top = 96
    Width = 153
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object btAddGrade: TBitBtn
    Left = 16
    Top = 96
    Width = 113
    Height = 24
    Caption = 'Добавить'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
end
object BatchPropForm: TBatchPropForm
  Left = 104
  Top = 340
  BorderStyle = bsDialog
  Caption = 'Просмотр и корректировка параметров дозатора'
  ClientHeight = 217
  ClientWidth = 802
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDeactivate = FormDeactivate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object lbN: TLabel
    Left = 16
    Top = 16
    Width = 64
    Height = 14
    Caption = 'Дозатор №:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrGrade: TLabel
    Left = 16
    Top = 60
    Width = 65
    Height = 14
    Caption = 'Марка угля:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 16
    Top = 136
    Width = 262
    Height = 13
    Caption = 'Рекомендуемая производительность, [т/ч]:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbRecommend: TLabel
    Left = 320
    Top = 125
    Width = 54
    Height = 37
    Alignment = taRightJustify
    Caption = '___'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbBatN: TLabel
    Left = 96
    Top = 5
    Width = 54
    Height = 37
    Alignment = taRightJustify
    Caption = '___'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbMount: TCheckBox
    Left = 240
    Top = 16
    Width = 137
    Height = 17
    Caption = 'дозатор в работе'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object cbPropGrade: TComboBox
    Left = 152
    Top = 56
    Width = 153
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 1
  end
  object btSaveConfig: TBitBtn
    Left = 16
    Top = 162
    Width = 199
    Height = 41
    Caption = 'Запись изменений'
    Default = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = btSaveConfigClick
    Glyph.Data = {
      B6010000424DB601000000000000760000002800000020000000140000000100
      0400000000004001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
      000000000000000000000F7777777777777777777777777777700FF777777777
      777777777777777777700FF888888888888888888888888887700FF888888888
      888888888888888887700FF888888888888888888888888887700FF87FFFFFFF
      FFFFFFFFFFFFFFFF87700FF87888AA88888888888877788F87700FF87888AA8F
      FFFFFFFFF8FF788F87700FF878FFFFF0000000000FFFFF8F87700FF878000000
      000000000000008F87700FF878888880000000000888888F87700FF878888888
      888888888888888F87700FF877777777777777777777777F87700FF888888888
      888888888888888887700FF888888888888888888888888887700FF888888888
      888888888888888887700FFFFFFFFFFFFFFFFFFFFFFFFFFFF7700FFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF7000000000000000000000000000000000}
  end
  object GroupBox1: TGroupBox
    Left = 400
    Top = 16
    Width = 393
    Height = 193
    Caption = 'Текущая мгновенная производительность дозатора, [т/ч]'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object lbCurrent: TLabel
      Left = 26
      Top = 32
      Width = 343
      Height = 153
      Alignment = taRightJustify
      AutoSize = False
      Caption = '____'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -107
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object edAddGrade: TEdit
    Left = 152
    Top = 96
    Width = 153
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object btAddGrade: TBitBtn
    Left = 16
    Top = 96
    Width = 113
    Height = 24
    Caption = 'Добавить'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
end
