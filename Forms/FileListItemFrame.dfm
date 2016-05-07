object FileListFrame: TFileListFrame
  Left = 0
  Top = 0
  Width = 1098
  Height = 120
  Align = alTop
  AutoSize = True
  DoubleBuffered = True
  ParentDoubleBuffered = False
  TabOrder = 0
  ExplicitWidth = 451
  object FileImage: TImage
    Left = 0
    Top = 0
    Width = 120
    Height = 117
    Align = alLeft
    Center = True
    Proportional = True
    Transparent = True
    ExplicitHeight = 120
  end
  object Bevel1: TBevel
    Left = 0
    Top = 117
    Width = 1098
    Height = 3
    Align = alBottom
    Shape = bsBottomLine
    ExplicitTop = 70
    ExplicitWidth = 991
  end
  object Panel1: TPanel
    Left = 120
    Top = 0
    Width = 978
    Height = 117
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      978
      117)
    object FileNameLabel: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 972
      Height = 13
      Align = alTop
      Caption = 'File name'
      ExplicitWidth = 45
    end
    object Label1: TLabel
      Left = 6
      Top = 47
      Width = 74
      Height = 13
      Caption = 'Subtitle Tracks:'
    end
    object Label2: TLabel
      Left = 15
      Top = 77
      Width = 65
      Height = 13
      Caption = 'Audio Tracks:'
    end
    object FileInfoLabel: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 972
      Height = 13
      Align = alTop
      Caption = 'File Info label'
      ExplicitWidth = 64
    end
    object SubtitleList: TComboBox
      Left = 237
      Top = 44
      Width = 635
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object AudioList: TComboBox
      Left = 86
      Top = 73
      Width = 787
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object ProgressBar: TProgressBar
      Left = 0
      Top = 100
      Width = 978
      Height = 17
      Align = alBottom
      TabOrder = 2
      ExplicitWidth = 100
    end
    object RemoveBtn: TButton
      Left = 940
      Top = 41
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'RemoveBtn'
      TabOrder = 3
    end
    object PreviewBtn: TButton
      Left = 940
      Top = 69
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'PreviewBtn'
      TabOrder = 4
    end
    object RangeBtn: TButton
      Left = 909
      Top = 69
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'RangeBtn'
      TabOrder = 5
    end
    object SubtitleTypeList: TComboBox
      Left = 86
      Top = 44
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 6
      Text = 'Subtitle Files'
      Items.Strings = (
        'Embedded Subtitles'
        'Subtitle Files')
    end
    object FileInfoBtn: TButton
      Left = 909
      Top = 41
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'FileInfoBtn'
      TabOrder = 7
    end
    object OpenFolderBtn: TButton
      Left = 878
      Top = 41
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OpenFolderBtn'
      TabOrder = 8
    end
  end
end
