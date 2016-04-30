object VideoToGIFForm: TVideoToGIFForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Video to GIF'
  ClientHeight = 270
  ClientWidth = 784
  Color = 16708071
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    784
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object WidthEdit: TJvSpinEdit
    Left = 64
    Top = 62
    Width = 75
    Height = 21
    Value = 320.000000000000000000
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object HeightEdit: TJvSpinEdit
    Left = 184
    Top = 62
    Width = 75
    Height = 21
    Value = 240.000000000000000000
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object KeepAspectBtn: TCheckBox
    Left = 265
    Top = 62
    Width = 110
    Height = 19
    Caption = 'Keep aspect ratio'
    TabOrder = 2
    OnClick = KeepAspectBtnClick
  end
  object DelayEdit: TJvSpinEdit
    Left = 701
    Top = 62
    Width = 75
    Height = 21
    Value = 20.000000000000000000
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Anchors = [akTop, akRight]
    ParentFont = False
    TabOrder = 3
  end
  object StartBar: TTrackBar
    Left = 145
    Top = 116
    Width = 631
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    ShowSelRange = False
    TabOrder = 4
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = StartBarChange
  end
  object EndBar: TTrackBar
    Left = 145
    Top = 147
    Width = 631
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    ShowSelRange = False
    TabOrder = 5
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = EndBarChange
  end
  object StartEdit: TEdit
    Left = 64
    Top = 118
    Width = 75
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    Text = '00:00:00.000'
  end
  object EndEdit: TEdit
    Left = 64
    Top = 149
    Width = 75
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    Text = '00:00:00.000'
  end
  object StartBtn: TButton
    Left = 676
    Top = 232
    Width = 100
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    TabOrder = 8
    OnClick = StartBtnClick
  end
  object StopBtn: TButton
    Left = 570
    Top = 232
    Width = 100
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 9
    OnClick = StopBtnClick
  end
  object ResetBtn: TButton
    Left = 8
    Top = 232
    Width = 100
    Height = 30
    Anchors = [akLeft, akBottom]
    Caption = 'Reset'
    TabOrder = 10
  end
  object DurationEdit: TEdit
    Left = 701
    Top = 178
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 11
    Text = '00:00:00.000'
  end
  object ConsoleEdit: TEdit
    Left = 8
    Top = 205
    Width = 768
    Height = 21
    Alignment = taCenter
    Anchors = [akLeft, akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 12
  end
  object InfoEdit: TEdit
    Left = 362
    Top = 237
    Width = 206
    Height = 21
    Alignment = taCenter
    Anchors = [akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 14
  end
  object MemoryEdit: TJvSpinEdit
    Left = 145
    Top = 89
    Width = 114
    Height = 21
    Value = 512.000000000000000000
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
  end
  object FPSEdit: TJvSpinEdit
    Left = 701
    Top = 89
    Width = 75
    Height = 21
    Value = 5.000000000000000000
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Anchors = [akTop, akRight]
    ParentFont = False
    TabOrder = 15
  end
  object SourceEdit: TJvFilenameEdit
    Left = 64
    Top = 8
    Width = 712
    Height = 21
    TabOrder = 17
    Text = 'SourceEdit'
  end
  object DestEdit: TJvFilenameEdit
    Left = 64
    Top = 35
    Width = 712
    Height = 21
    TabOrder = 16
    Text = 'DestEdit'
  end
  object ProgressBar1: TProgressBar
    Left = 114
    Top = 232
    Width = 242
    Height = 30
    TabOrder = 18
  end
  object PosTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PosTimerTimer
    Left = 408
    Top = 8
  end
end
