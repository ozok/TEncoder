object ImageAudiotoVideoForm: TImageAudiotoVideoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Image&Audio to Video'
  ClientHeight = 149
  ClientWidth = 645
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    645
    149)
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel1: TLabel
    Left = 8
    Top = 121
    Width = 404
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 
      'Video/audio options set in the main window will be used (except ' +
      'for encoder option).'
  end
  object ProgressLabel: TLabel
    Left = 601
    Top = 95
    Width = 36
    Height = 13
    Alignment = taCenter
    Anchors = [akRight, akBottom]
    AutoSize = False
    Caption = '0%'
  end
  object Label1: TLabel
    Left = 27
    Top = 12
    Width = 31
    Height = 13
    Caption = 'Audio:'
  end
  object Label2: TLabel
    Left = 24
    Top = 39
    Width = 34
    Height = 13
    Caption = 'Image:'
  end
  object Label3: TLabel
    Left = 20
    Top = 66
    Width = 38
    Height = 13
    Caption = 'Output:'
  end
  object OutputEdit: TEdit
    Left = 64
    Top = 62
    Width = 573
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object StartBtn: TBitBtn
    Left = 537
    Top = 116
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    TabOrder = 3
    OnClick = StartBtnClick
  end
  object StopBtn: TBitBtn
    Left = 431
    Top = 116
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 0
    OnClick = StopBtnClick
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 93
    Width = 587
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
  end
  object AudioEdit: TJvFilenameEdit
    Left = 64
    Top = 8
    Width = 573
    Height = 21
    TabOrder = 4
    Text = ''
  end
  object ImageEdit: TJvFilenameEdit
    Left = 64
    Top = 35
    Width = 573
    Height = 21
    TabOrder = 5
    Text = ''
  end
  object PosTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PosTimerTimer
    Left = 312
    Top = 72
  end
end
