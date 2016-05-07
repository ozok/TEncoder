object LogForm: TLogForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Encoder Logs'
  ClientHeight = 402
  ClientWidth = 784
  Color = 16708071
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    784
    402)
  PixelsPerInch = 96
  TextHeight = 13
  object OkBtn: TButton
    Left = 656
    Top = 369
    Width = 120
    Height = 30
    Hint = 'Close this window'
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = OkBtnClick
  end
  object ClearBtn: TButton
    Left = 530
    Top = 369
    Width = 120
    Height = 30
    Hint = 'Clear current log'
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 1
    OnClick = ClearBtnClick
  end
  object SaveBtn: TButton
    Left = 404
    Top = 369
    Width = 120
    Height = 30
    Hint = 'Save current log to a file'
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object Logs: TPageControl
    Left = 8
    Top = 8
    Width = 768
    Height = 355
    ActivePage = sTabSheet12
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object sTabSheet12: TTabSheet
      Caption = 'Main'
      object MainLog: TMemo
        Left = 0
        Top = 0
        Width = 760
        Height = 327
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object sTabSheet1: TTabSheet
      Caption = 'Video/Audio Converter'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object VideoEncoderList: TMemo
        Left = 0
        Top = 21
        Width = 760
        Height = 306
        Align = alClient
        BorderStyle = bsNone
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object VideoEncoderLogsList: TComboBox
        Left = 0
        Top = 0
        Width = 760
        Height = 21
        Align = alTop
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
        Text = 'Encoder 1'
        OnChange = VideoEncoderLogsListChange
        Items.Strings = (
          'Encoder 1'
          'Encoder 2'
          'Encoder 3'
          'Encoder 4'
          'Encoder 5'
          'Encoder 6'
          'Encoder 7'
          'Encoder 8'
          'Encoder 9'
          'Encoder 10'
          'Encoder 11'
          'Encoder 12'
          'Encoder 13'
          'Encoder 14'
          'Encoder 15'
          'Encoder 16')
      end
    end
    object sTabSheet9: TTabSheet
      Caption = 'MPlayer'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MPlayerLogList: TMemo
        Left = 0
        Top = 0
        Width = 760
        Height = 327
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object sTabSheet10: TTabSheet
      Caption = 'Others'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object OtherLog: TMemo
        Left = 0
        Top = 0
        Width = 760
        Height = 327
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object sTabSheet11: TTabSheet
      Caption = 'Video Downloader'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LogList: TComboBox
        Left = 0
        Top = 0
        Width = 760
        Height = 21
        Align = alTop
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = LogListChange
        Items.Strings = (
          'Download Process 1'
          'Download Process 2'
          'Download Process 3'
          'Download Process 4'
          'Download Process 5'
          'Download Process 6'
          'Download Process 7'
          'Download Process 8'
          'Command lines')
      end
      object DownloadLog: TMemo
        Left = 0
        Top = 21
        Width = 760
        Height = 306
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          'DownloadLog')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object sTabSheet2: TTabSheet
      Caption = 'DVD Ripper'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DVDPages: TPageControl
        Left = 0
        Top = 0
        Width = 760
        Height = 327
        ActivePage = sTabSheet3
        Align = alClient
        TabOrder = 0
        object sTabSheet3: TTabSheet
          Caption = 'Console Output'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object DVDLog: TMemo
            Left = 0
            Top = 0
            Width = 752
            Height = 299
            Align = alClient
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
        object sTabSheet4: TTabSheet
          Caption = 'Command lines'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object DVDCMDLog: TMemo
            Left = 0
            Top = 0
            Width = 752
            Height = 299
            Align = alClient
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 152
    Top = 200
  end
  object ClearPopup: TPopupMenu
    Left = 208
    Top = 104
    object ClearSelected1: TMenuItem
      Caption = 'Clear Selected'
      OnClick = ClearSelected1Click
    end
    object ClearAll1: TMenuItem
      Caption = 'Clear All'
      OnClick = ClearAll1Click
    end
  end
end
