object DownloadUIItem: TDownloadUIItem
  Left = 0
  Top = 0
  Width = 1116
  Height = 141
  Anchors = [akLeft, akTop, akRight]
  TabOrder = 0
  object sBevel1: TBevel
    Left = 0
    Top = 138
    Width = 1116
    Height = 3
    Align = alBottom
    Shape = bsBottomLine
    ExplicitTop = 91
  end
  object sPanel1: TPanel
    Left = 227
    Top = 0
    Width = 889
    Height = 138
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      889
      138)
    object ProgressLabel: TLabel
      Left = 55
      Top = 93
      Width = 67
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'ProgressLabel'
      ExplicitTop = 95
    end
    object ProgressBar: TGauge
      Left = 6
      Top = 110
      Width = 791
      Height = 19
      Anchors = [akLeft, akRight, akBottom]
      Progress = 0
      ExplicitTop = 109
      ExplicitWidth = 564
    end
    object FileNameLabel: TLabel
      Left = 6
      Top = 22
      Width = 68
      Height = 13
      Caption = 'FileNameLabel'
    end
    object LinkLabel: TLabel
      Left = 6
      Top = 3
      Width = 43
      Height = 13
      Cursor = crHandPoint
      Caption = 'LinkLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object FormatList: TComboBox
      Left = 55
      Top = 41
      Width = 817
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object SubtitleList: TComboBox
      Left = 55
      Top = 68
      Width = 817
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object DeleteButton: TButton
      Left = 803
      Top = 107
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Remove'
      TabOrder = 2
    end
  end
  object sPanel2: TPanel
    Left = 0
    Top = 0
    Width = 227
    Height = 138
    Align = alLeft
    TabOrder = 1
    object PrevievImg: TImage
      Left = 1
      Top = 1
      Width = 225
      Height = 136
      Align = alClient
      Center = True
      Picture.Data = {07544269746D617000000000}
      Proportional = True
      Transparent = True
      ExplicitWidth = 110
      ExplicitHeight = 110
    end
  end
end
