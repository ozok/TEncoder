object AddForm: TAddForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'TEncoder'
  ClientHeight = 65
  ClientWidth = 658
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLabel: TLabel
    Left = 8
    Top = 8
    Width = 642
    Height = 13
    Hint = 'What'#39's going on?'
    AutoSize = False
    Caption = 'Adding files please wait...'
  end
  object AbortBtn: TButton
    Left = 550
    Top = 27
    Width = 100
    Height = 30
    Hint = 'Abort current progress'
    Caption = 'Abort'
    TabOrder = 0
    OnClick = AbortBtnClick
  end
end
