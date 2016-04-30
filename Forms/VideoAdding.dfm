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
  object InfoLabel: TLabel
    Left = 8
    Top = 15
    Width = 66
    Height = 13
    Caption = 'Please wait...'
  end
  object AbortVideoAddBtn: TButton
    Left = 543
    Top = 8
    Width = 100
    Height = 30
    Caption = 'Abort'
    TabOrder = 0
    OnClick = AbortVideoAddBtnClick
  end
  object VideoAddBar: TProgressBar
    Left = 0
    Top = 47
    Width = 651
    Height = 10
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 40
  end
end
