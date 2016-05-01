object DubForm: TDubForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Dub'
  ClientHeight = 173
  ClientWidth = 635
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
    635
    173)
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressLabel: TLabel
    Left = 8
    Top = 119
    Width = 619
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'FFMpeg output'
  end
  object Label1: TLabel
    Left = 45
    Top = 12
    Width = 30
    Height = 13
    Caption = 'Video:'
  end
  object Label2: TLabel
    Left = 44
    Top = 39
    Width = 31
    Height = 13
    Caption = 'Audio:'
  end
  object Label3: TLabel
    Left = 8
    Top = 66
    Width = 67
    Height = 13
    Caption = 'Output name:'
  end
  object Label4: TLabel
    Left = 24
    Top = 93
    Width = 51
    Height = 13
    Caption = 'Container:'
  end
  object OutputEdit: TEdit
    Left = 81
    Top = 62
    Width = 546
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
  object ContainerList: TComboBox
    Left = 81
    Top = 89
    Width = 145
    Height = 21
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Items.Strings = (
      'AVI'
      'MPEG'
      'MP4'
      'MOV'
      'MKV'
      'FLV'
      'WMV'
      'WEBM'
      '3GP')
  end
  object StopBtn: TBitBtn
    Left = 421
    Top = 140
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 0
    OnClick = StopBtnClick
  end
  object StartBtn: TBitBtn
    Left = 527
    Top = 140
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    TabOrder = 2
    OnClick = StartBtnClick
  end
  object VideoEdit: TJvFilenameEdit
    Left = 81
    Top = 8
    Width = 546
    Height = 21
    TabOrder = 4
    Text = ''
  end
  object AudioEdit: TJvFilenameEdit
    Left = 81
    Top = 35
    Width = 546
    Height = 21
    TabOrder = 5
    Text = ''
  end
  object PosTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PosTimerTimer
    Left = 312
    Top = 88
  end
end
