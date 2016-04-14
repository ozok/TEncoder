object DownloadUIItem: TDownloadUIItem
  Left = 0
  Top = 0
  Width = 1116
  Height = 141
  Anchors = [akLeft, akTop, akRight]
  TabOrder = 0
  object sBevel1: TsBevel
    Left = 0
    Top = 138
    Width = 1116
    Height = 3
    Align = alBottom
    Shape = bsBottomLine
    ExplicitTop = 91
  end
  object sPanel1: TsPanel
    Left = 227
    Top = 0
    Width = 889
    Height = 138
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    ExplicitHeight = 141
    DesignSize = (
      889
      138)
    object ProgressLabel: TsLabel
      Left = 55
      Top = 93
      Width = 67
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'ProgressLabel'
      ExplicitTop = 95
    end
    object ProgressBar: TsGauge
      Left = 6
      Top = 110
      Width = 791
      Height = 19
      Anchors = [akLeft, akRight, akBottom]
      Animated = False
      SkinData.SkinSection = 'GAUGE'
      ForeColor = clBlack
      Progress = 0
      Suffix = '%'
      ExplicitTop = 109
      ExplicitWidth = 564
    end
    object FileNameLabel: TsLabel
      Left = 6
      Top = 22
      Width = 68
      Height = 13
      Caption = 'FileNameLabel'
    end
    object LinkLabel: TsLabel
      Left = 6
      Top = 3
      Width = 43
      Height = 13
      Cursor = crHandPoint
      Caption = 'LinkLabel'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
    end
    object FormatList: TsComboBox
      Left = 55
      Top = 41
      Width = 817
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Alignment = taLeftJustify
      BoundLabel.Active = True
      BoundLabel.Caption = 'Format:'
      VerticalAlignment = taAlignTop
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 0
    end
    object SubtitleList: TsComboBox
      Left = 55
      Top = 68
      Width = 817
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Alignment = taLeftJustify
      BoundLabel.Active = True
      BoundLabel.Caption = 'Subtitles:'
      VerticalAlignment = taAlignTop
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 1
    end
    object DeleteButton: TsButton
      Left = 803
      Top = 107
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Remove'
      TabOrder = 2
      ExplicitTop = 110
    end
  end
  object sPanel2: TsPanel
    Left = 0
    Top = 0
    Width = 227
    Height = 138
    Align = alLeft
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    ExplicitHeight = 141
    object PrevievImg: TsImage
      Left = 1
      Top = 1
      Width = 225
      Height = 136
      Align = alClient
      Center = True
      Picture.Data = {07544269746D617000000000}
      Proportional = True
      Transparent = True
      SkinData.SkinSection = 'CHECKBOX'
      ExplicitWidth = 110
      ExplicitHeight = 110
    end
  end
end
