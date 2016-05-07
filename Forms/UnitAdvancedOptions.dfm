object AdvancedOptionsForm: TAdvancedOptionsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Codec Options'
  ClientHeight = 537
  ClientWidth = 502
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
  OnShow = FormShow
  DesignSize = (
    502
    537)
  PixelsPerInch = 96
  TextHeight = 13
  object CloseBtn: TButton
    Left = 369
    Top = 504
    Width = 125
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = CloseBtnClick
  end
  object OptionPages: TPageControl
    Left = 8
    Top = 367
    Width = 486
    Height = 131
    ActivePage = sTabSheet3
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object sTabSheet3: TTabSheet
      Caption = 'General'
      object MPEGAudioIDBtn: TCheckBox
        Left = 8
        Top = 8
        Width = 447
        Height = 19
        Caption = 
          'No audio id option with MEncoder when converting from mpeg sourc' +
          'es (mpeg, vob, dat)'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
    end
    object sTabSheet1: TTabSheet
      Caption = 'x264'
      ExplicitLeft = 0
      ExplicitTop = 28
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 8
        Top = 33
        Width = 34
        Height = 13
        Caption = 'Profile:'
      end
      object Label4: TLabel
        Left = 114
        Top = 35
        Width = 29
        Height = 13
        Caption = 'Level:'
      end
      object Label5: TLabel
        Left = 220
        Top = 35
        Width = 35
        Height = 13
        Caption = 'Preset:'
      end
      object Label6: TLabel
        Left = 326
        Top = 33
        Width = 28
        Height = 13
        Caption = 'Tune:'
      end
      object x264Btn: TCheckBox
        Left = 8
        Top = 8
        Width = 159
        Height = 19
        Caption = 'Use advanced x264 options'
        TabOrder = 0
        OnClick = x264BtnClick
      end
      object x264LevelList: TComboBox
        Left = 114
        Top = 54
        Width = 100
        Height = 21
        Style = csDropDownList
        Color = clWhite
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'Auto'
        Items.Strings = (
          'Auto'
          '1'
          '1b'
          '1.1'
          '1.2'
          '1.3'
          '2'
          '2.1'
          '2.2'
          '3'
          '3.1'
          '3.2'
          '4'
          '4.1'
          '4.2'
          '5'
          '5.1')
      end
      object x264PresetList: TComboBox
        Left = 220
        Top = 52
        Width = 100
        Height = 21
        Style = csDropDownList
        Color = clWhite
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 2
        Text = 'Auto'
        Items.Strings = (
          'Auto'
          'Ultrafast'
          'Superfast'
          'Veryfast'
          'Faster'
          'Fast'
          'Medium'
          'Slow'
          'Slower'
          'Veryslow'
          'Placebo')
      end
      object x264ProfileList: TComboBox
        Left = 8
        Top = 54
        Width = 100
        Height = 21
        Style = csDropDownList
        Color = clWhite
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 3
        Text = 'Auto'
        Items.Strings = (
          'Auto'
          'Baseline'
          'Main'
          'High')
      end
      object x264TuneList: TComboBox
        Left = 326
        Top = 52
        Width = 100
        Height = 21
        Style = csDropDownList
        Color = clWhite
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 4
        Text = 'Auto'
        Items.Strings = (
          'Auto'
          'Film'
          'Animation'
          'Grain'
          'Stillimage'
          'PSNR'
          'SSIM'
          'Fastdecode'
          'Zerolatency')
      end
      object x264CRFBtn: TCheckBox
        Left = 8
        Top = 81
        Width = 153
        Height = 19
        Caption = 'Use CRF instead of bitrate'
        TabOrder = 5
        OnClick = x264CRFBtnClick
      end
      object x264CRFEdit: TJvSpinEdit
        Left = 167
        Top = 79
        Width = 76
        Height = 21
        MaxValue = 51.000000000000000000
        Value = 23.000000000000000000
        Color = clWhite
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
    end
    object sTabSheet2: TTabSheet
      Caption = 'ProRes'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sLabel1: TLabel
        Left = 3
        Top = 44
        Width = 73
        Height = 13
        Caption = '0 (Best quality)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2171169
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object sLabel2: TLabel
        Left = 342
        Top = 44
        Width = 87
        Height = 13
        Caption = '32 (Worst quality)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2171169
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 8
        Top = 7
        Width = 34
        Height = 13
        Caption = 'Profile:'
      end
      object ProresProfileList: TComboBox
        Left = 48
        Top = 3
        Width = 145
        Height = 21
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 0
        Text = 'Proxy'
        Items.Strings = (
          'Proxy'
          'LT'
          'Normal'
          'HQ')
      end
      object ProresQualityBar: TTrackBar
        Left = 3
        Top = 63
        Width = 386
        Height = 41
        Max = 32
        TabOrder = 1
        TickMarks = tmTopLeft
        OnChange = ProresQualityBarChange
      end
      object ProresQualityEdit: TEdit
        Left = 395
        Top = 63
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
        TabOrder = 2
        Text = '0'
      end
    end
    object sTabSheet4: TTabSheet
      Caption = 'FLAC'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label8: TLabel
        Left = 14
        Top = 12
        Width = 90
        Height = 13
        Caption = 'Compression level:'
      end
      object FlacCompBar: TTrackBar
        Left = 166
        Top = 4
        Width = 283
        Height = 29
        Max = 12
        Position = 12
        TabOrder = 0
        OnChange = FlacCompBarChange
      end
      object FlacCompEdit: TEdit
        Left = 110
        Top = 8
        Width = 50
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
        TabOrder = 1
        Text = '12'
      end
    end
    object sTabSheet5: TTabSheet
      Caption = 'x265'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 8
        Top = 33
        Width = 35
        Height = 13
        Caption = 'Preset:'
      end
      object x265Btn: TCheckBox
        Left = 8
        Top = 8
        Width = 159
        Height = 19
        Caption = 'Use advanced x265 options'
        TabOrder = 0
        OnClick = x265BtnClick
      end
      object x265PresetsList: TComboBox
        Left = 3
        Top = 52
        Width = 100
        Height = 21
        Style = csDropDownList
        Color = clWhite
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'Auto'
        Items.Strings = (
          'Auto'
          'Ultrafast'
          'Superfast'
          'Veryfast'
          'Faster'
          'Fast'
          'Medium'
          'Slow'
          'Slower'
          'Veryslow'
          'Placebo')
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 153
    Caption = 'Video Options'
    TabOrder = 2
    object VideoSettingsPanel: TPanel
      Left = 2
      Top = 15
      Width = 245
      Height = 136
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Label10: TLabel
        Left = 39
        Top = 3
        Width = 36
        Height = 13
        Caption = 'Bitrate:'
      end
      object Label11: TLabel
        Left = 5
        Top = 31
        Width = 71
        Height = 13
        Caption = 'Common sizes:'
      end
      object Label12: TLabel
        Left = 53
        Top = 59
        Width = 23
        Height = 13
        Caption = 'Size:'
      end
      object Label13: TLabel
        Left = 54
        Top = 85
        Width = 22
        Height = 13
        Caption = 'FPS:'
      end
      object Label14: TLabel
        Left = 11
        Top = 112
        Width = 65
        Height = 13
        Caption = 'Aspect Ratio:'
      end
      object ForceASRBtn: TCheckBox
        Left = 160
        Top = 108
        Width = 53
        Height = 19
        Hint = 
          'Width will be calculated according to given aspect ratio with re' +
          'spect to height'
        Caption = 'Force'
        TabOrder = 0
      end
      object VideoAspectRatioList: TComboBox
        Left = 82
        Top = 108
        Width = 73
        Height = 21
        Hint = 'Aspect ratio of video'
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'Keep'
        Items.Strings = (
          'Keep'
          '4/3'
          '16/9'
          '1.85'
          '2.35'
          '1.3333'
          '1.7777')
      end
      object VideobitrateList: TComboBox
        Left = 82
        Top = 0
        Width = 80
        Height = 21
        Hint = 'Video bitrate'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '512'
        Items.Strings = (
          '64'
          '96'
          '112'
          '128'
          '256'
          '384'
          '512'
          '768'
          '1024'
          '2000'
          '4000'
          '8000'
          '10000'
          '12000')
      end
      object VideoCBrBtn: TCheckBox
        Left = 168
        Top = 2
        Width = 46
        Height = 19
        Hint = 'Encoder will be force to use CBR encoding'
        Caption = 'CBR'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
      end
      object VideoFPSList: TComboBox
        Left = 82
        Top = 81
        Width = 128
        Height = 21
        Hint = 'Frames per second'
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 4
        Text = 'Same as source'
        Items.Strings = (
          'Same as source'
          '8'
          '10'
          '12'
          '15'
          '20'
          '23.976'
          '25'
          '29.97'
          '30'
          '50'
          '59.94'
          '60')
      end
      object VideoSizeList: TComboBox
        Left = 82
        Top = 27
        Width = 128
        Height = 21
        Hint = 'Video size'
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 5
        Text = 'Original'
        OnChange = VideoSizeListChange
        Items.Strings = (
          'Original'
          '160x112'
          '176x144'
          '220x176'
          '320x240'
          '352x240'
          '352x288'
          '368x208'
          '480x272'
          '480x320'
          '480x360'
          '480x480'
          '480x576'
          '512x384'
          '640x480'
          '720x480'
          '720x576'
          '854x480 '
          '960x720'
          '960x540'
          '1080x720'
          '1280x720'
          '1440x1080'
          '1920x1080')
      end
      object WidthEdit: TJvSpinEdit
        Left = 82
        Top = 54
        Width = 55
        Height = 21
        Value = 352.000000000000000000
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object HeightEdit: TJvSpinEdit
        Left = 155
        Top = 54
        Width = 55
        Height = 21
        Value = 288.000000000000000000
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
    end
  end
  object sGroupBox1: TGroupBox
    Left = 263
    Top = 8
    Width = 231
    Height = 153
    Caption = 'Audio Options'
    TabOrder = 3
    object AudioSettingsPanel: TPanel
      Left = 2
      Top = 15
      Width = 227
      Height = 136
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Label15: TLabel
        Left = 40
        Top = 3
        Width = 36
        Height = 13
        Caption = 'Bitrate:'
      end
      object Label16: TLabel
        Left = 28
        Top = 31
        Width = 48
        Height = 13
        Caption = 'Channels:'
      end
      object Label17: TLabel
        Left = 15
        Top = 57
        Width = 61
        Height = 13
        Caption = 'Sample rate:'
      end
      object AudioBitrateList: TComboBox
        Left = 82
        Top = 0
        Width = 80
        Height = 21
        Hint = 'Audio bitrate'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = '128'
        Items.Strings = (
          '12'
          '32'
          '48'
          '64'
          '80'
          '96'
          '112'
          '128'
          '160'
          '192'
          '224'
          '256'
          '320'
          '620')
      end
      object AudioChannelsList: TComboBox
        Left = 82
        Top = 27
        Width = 128
        Height = 21
        Hint = 'Number of audio channels'
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = '1'
        Items.Strings = (
          '1'
          '2'
          '5.1'
          'Same as source')
      end
      object AudioSampleRateList: TComboBox
        Left = 82
        Top = 54
        Width = 128
        Height = 21
        Hint = 'Audio sample rate'
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 2
        Text = '8000'
        Items.Strings = (
          '8000'
          '11025'
          '16000'
          '22050'
          '32000'
          '44100'
          '48000'
          'Same as source')
      end
    end
  end
  object sGroupBox2: TGroupBox
    Left = 8
    Top = 165
    Width = 486
    Height = 196
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Custom Options'
    TabOrder = 4
    DesignSize = (
      486
      196)
    object sLabelFX1: TLabel
      Left = 3
      Top = 180
      Width = 263
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      Caption = 'Please note that arguments above will not be checked!'
      ExplicitTop = 245
    end
    object Label1: TLabel
      Left = 65
      Top = 128
      Width = 115
      Height = 13
      Caption = 'Custom ffmpeg options:'
    end
    object Label2: TLabel
      Left = 52
      Top = 154
      Width = 128
      Height = 13
      Caption = 'Custom mencoder options:'
    end
    object CustomFFmpegVideoBtn: TCheckBox
      Left = 8
      Top = 17
      Width = 172
      Height = 19
      Caption = 'FFmpeg custom video options:'
      TabOrder = 0
      OnClick = CustomFFmpegVideoBtnClick
    end
    object CustomFFmpegAudioBtn: TCheckBox
      Left = 8
      Top = 44
      Width = 168
      Height = 19
      Caption = 'FFmpeg custom audio options:'
      TabOrder = 1
      OnClick = CustomFFmpegAudioBtnClick
    end
    object CustomFFMpegVideoEdit: TEdit
      Left = 186
      Top = 16
      Width = 290
      Height = 21
      Anchors = [akLeft, akTop, akRight]
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
    object CustomFFMpegAudioEdit: TEdit
      Left = 186
      Top = 43
      Width = 290
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CustomMEncoderAudioEdit: TEdit
      Left = 186
      Top = 97
      Width = 290
      Height = 21
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object CustomMEncoderVideoEdit: TEdit
      Left = 186
      Top = 70
      Width = 290
      Height = 21
      Color = clWhite
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object CustomMEncoderAudioBtn: TCheckBox
      Left = 8
      Top = 98
      Width = 181
      Height = 19
      Caption = 'MEncoder custom audio options:'
      TabOrder = 6
      OnClick = CustomMEncoderAudioBtnClick
    end
    object CustomMEncoderVideoBtn: TCheckBox
      Left = 8
      Top = 71
      Width = 181
      Height = 19
      Caption = 'MEncoder custom video options:'
      TabOrder = 7
      OnClick = CustomMEncoderVideoBtnClick
    end
    object CustomFFmpegEdit: TEdit
      Left = 186
      Top = 124
      Width = 290
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object CustomMencoderEdit: TEdit
      Left = 186
      Top = 151
      Width = 290
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
  end
end
