object WatermarkForm: TWatermarkForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Watermark'
  ClientHeight = 170
  ClientWidth = 645
  Color = 16708071
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    645
    170)
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel1: TLabel
    Left = 8
    Top = 142
    Width = 404
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 
      'Video/audio options set in the main window will be used (except ' +
      'for encoder option).'
    ExplicitTop = 320
  end
  object ProgressLabel: TLabel
    Left = 601
    Top = 116
    Width = 36
    Height = 13
    Alignment = taCenter
    Anchors = [akRight, akBottom]
    AutoSize = False
    Caption = '0%'
    ExplicitTop = 294
  end
  object PositionList: TComboBox
    Left = 56
    Top = 89
    Width = 121
    Height = 21
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = PositionListChange
    Items.Strings = (
      'Top left'
      'Top centre'
      'Top right'
      'Centre left'
      'Centre'
      'Centre right'
      'Bottom left'
      'Bottom centre'
      'Bottom right'
      'Custom')
  end
  object XEdit: TJvSpinEdit
    Left = 232
    Top = 89
    Width = 75
    Height = 21
    Color = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object YEdit: TJvSpinEdit
    Left = 328
    Top = 89
    Width = 75
    Height = 21
    Color = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object OutputEdit: TEdit
    Left = 56
    Top = 62
    Width = 581
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object StartBtn: TBitBtn
    Left = 537
    Top = 137
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    TabOrder = 5
    OnClick = StartBtnClick
  end
  object StopBtn: TBitBtn
    Left = 431
    Top = 137
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 3
    OnClick = StopBtnClick
  end
  object VideoPathEdit: TJvFilenameEdit
    Left = 56
    Top = 8
    Width = 581
    Height = 21
    TabOrder = 7
    Text = 'VideoPathEdit'
  end
  object ImagePathEdit: TJvFilenameEdit
    Left = 56
    Top = 35
    Width = 581
    Height = 21
    TabOrder = 6
    Text = 'ImagePathEdit'
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 114
    Width = 587
    Height = 17
    TabOrder = 8
  end
  object PosTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PosTimerTimer
    Left = 448
    Top = 56
  end
end
