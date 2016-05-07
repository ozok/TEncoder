object InfoForm: TInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Properties'
  ClientHeight = 320
  ClientWidth = 604
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
  OnResize = FormResize
  DesignSize = (
    604
    320)
  PixelsPerInch = 96
  TextHeight = 13
  object OkBtn: TButton
    Left = 496
    Top = 287
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = OkBtnClick
  end
  object Infos: TListView
    Left = 8
    Top = 8
    Width = 588
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Field'
        Width = 200
      end
      item
        Caption = 'Value'
        Width = 350
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    ShowWorkAreas = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object SaveBtn: TButton
    Left = 8
    Top = 287
    Width = 100
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save'
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object SaveDialog1: TSaveDialog
    FileName = 'TEncoderFileInfo.txt'
    Filter = 'Text Files|*.txt'
    Left = 176
    Top = 104
  end
end
