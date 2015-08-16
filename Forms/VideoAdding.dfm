object VideoAddingForm: TVideoAddingForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 57
  ClientWidth = 651
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
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TsLabel
    Left = 8
    Top = 15
    Width = 66
    Height = 13
    Caption = 'Please wait...'
  end
  object VideoAddBar: TsProgressBar
    Left = 0
    Top = 47
    Width = 651
    Height = 10
    Align = alBottom
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 0
    SkinData.SkinSection = 'GAUGE'
  end
  object AbortVideoAddBtn: TsButton
    Left = 543
    Top = 8
    Width = 100
    Height = 30
    Caption = 'Abort'
    TabOrder = 1
    OnClick = AbortVideoAddBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    FormHeader.AdditionalHeight = 0
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 376
    Top = 65528
  end
end
