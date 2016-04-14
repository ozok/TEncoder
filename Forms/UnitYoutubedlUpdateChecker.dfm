object YoutubedlUpdateChecker: TYoutubedlUpdateChecker
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Youtube-dl Update Checker'
  ClientHeight = 172
  ClientWidth = 645
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    645
    172)
  PixelsPerInch = 96
  TextHeight = 13
  object OutputList: TsMemo
    Left = 8
    Top = 8
    Width = 629
    Height = 125
    Anchors = [akLeft, akTop, akRight, akBottom]
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
  object CloseBtn: TsButton
    Left = 562
    Top = 139
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = CloseBtnClick
  end
  object ProgressBar: TsProgressBar
    Left = 8
    Top = 139
    Width = 548
    Height = 25
    TabOrder = 2
  end
  object Downloader: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    OnWork = DownloaderWork
    OnWorkBegin = DownloaderWorkBegin
    OnWorkEnd = DownloaderWorkEnd
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/46.0.2490.86 Safari/537.36 OPR/33.0.1990.115'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 176
    Top = 16
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 56
    Top = 16
  end
  object UpdateThread: TJvThread
    Exclusive = True
    MaxCount = 0
    RunOnCreate = True
    FreeOnTerminate = True
    OnExecute = UpdateThreadExecute
    Left = 280
    Top = 24
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
    Left = 312
    Top = 88
  end
end
