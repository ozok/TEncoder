object EffectForm: TEffectForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Filters'
  ClientHeight = 217
  ClientWidth = 576
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
  DesignSize = (
    576
    217)
  PixelsPerInch = 96
  TextHeight = 13
  object CloseBtn: TButton
    Left = 448
    Top = 184
    Width = 120
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = CloseBtnClick
  end
  object PreviewBtn: TButton
    Left = 8
    Top = 184
    Width = 100
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Preview'
    TabOrder = 1
    OnClick = PreviewBtnClick
  end
  object PreviewList: TComboBox
    Left = 168
    Top = 185
    Width = 274
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object sPageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 560
    Height = 170
    ActivePage = sTabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object sTabSheet1: TTabSheet
      Caption = 'Deinterlace'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sLabel1: TLabel
        Left = 3
        Top = 72
        Width = 361
        Height = 13
        Caption = 
          'This options is for MEncoder. FFmpeg has only one option for dei' +
          'nterlacing.'
      end
      object sLabel2: TLabel
        Left = 3
        Top = 91
        Width = 289
        Height = 13
        Caption = 'Preview may be different if you choose FFmpeg as encoder.'
      end
      object Label1: TLabel
        Left = 14
        Top = 43
        Width = 40
        Height = 13
        Caption = 'Method:'
      end
      object DeintEnblBtn: TCheckBox
        Left = 10
        Top = 16
        Width = 58
        Height = 19
        Caption = 'Enable'
        TabOrder = 0
        OnClick = DeintEnblBtnClick
      end
      object DeintMethodList: TComboBox
        Left = 60
        Top = 41
        Width = 145
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
        Text = 'Yadif=0'
        Items.Strings = (
          'Yadif=0'
          'Yadif=1:1'
          'Yadif=3:1'
          'Linear Blend'
          'Linear Interpole'
          'Median Interlacer'
          'Cubic Interpole'
          'Kernel Deinterlace'
          'Lavcdeint')
      end
    end
    object sTabSheet2: TTabSheet
      Caption = 'Crop'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 10
        Top = 68
        Width = 370
        Height = 13
        Caption = 
          'Make sure width and height values match with  the values from ma' +
          'in window.'
      end
      object Label2: TLabel
        Left = 8
        Top = 45
        Width = 32
        Height = 13
        Caption = 'Width:'
      end
      object Label3: TLabel
        Left = 115
        Top = 45
        Width = 35
        Height = 13
        Caption = 'Height:'
      end
      object Label4: TLabel
        Left = 224
        Top = 45
        Width = 10
        Height = 13
        Caption = 'X:'
      end
      object Label6: TLabel
        Left = 304
        Top = 45
        Width = 10
        Height = 13
        Caption = 'Y:'
      end
      object CropEnable: TCheckBox
        Left = 10
        Top = 16
        Width = 58
        Height = 19
        Caption = 'Enable'
        TabOrder = 0
        OnClick = CropEnableClick
      end
      object CropHeightEdit: TJvSpinEdit
        Left = 156
        Top = 41
        Width = 50
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
      object CropWidthEdit: TJvSpinEdit
        Left = 46
        Top = 41
        Width = 50
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
      object CropXEdit: TJvSpinEdit
        Left = 239
        Top = 41
        Width = 50
        Height = 21
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
      object CropYEdit: TJvSpinEdit
        Left = 330
        Top = 41
        Width = 50
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
    end
    object sTabSheet3: TTabSheet
      Caption = 'Rotate'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RotateList: TComboBox
        Left = 45
        Top = 16
        Width = 276
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
        Text = 'Do not rotate'
        Items.Strings = (
          'Do not rotate'
          'Rotate by 90 degrees clockwise and flip (default).'
          'Rotate by 90 degrees clockwise.'
          'Rotate by 90 degrees counterclockwise.'
          'Rotate by 90 degrees counterclockwise and flip.'
          'Rotate by 180 degrees clockwise and flip (default).'
          'Rotate by 180 degrees clockwise.'
          'Rotate by 180 degrees counterclockwise.'
          'Rotate by 180 degrees counterclockwise and flip.')
      end
    end
    object sTabSheet4: TTabSheet
      Caption = 'Volume'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 17
        Top = 44
        Width = 177
        Height = 13
        Caption = 'MEncoder volume level (-200/60 dB):'
      end
      object Label8: TLabel
        Left = 68
        Top = 71
        Width = 126
        Height = 13
        Caption = 'FFmpeg volume level (%):'
      end
      object VolumeEnableBtn: TCheckBox
        Left = 10
        Top = 16
        Width = 58
        Height = 19
        Caption = 'Enable'
        TabOrder = 0
        OnClick = VolumeEnableBtnClick
      end
      object VolumeMencoderEdit: TJvSpinEdit
        Left = 200
        Top = 40
        Width = 75
        Height = 21
        MaxValue = 60.000000000000000000
        MinValue = -200.000000000000000000
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object VolumeFFMpegEdit: TJvSpinEdit
        Left = 200
        Top = 67
        Width = 75
        Height = 21
        MaxValue = 100.000000000000000000
        Value = 100.000000000000000000
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
  end
end
