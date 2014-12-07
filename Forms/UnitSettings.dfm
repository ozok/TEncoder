object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 267
  ClientWidth = 465
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    465
    267)
  PixelsPerInch = 96
  TextHeight = 13
  object ResetBtn: TsBitBtn
    Left = 8
    Top = 234
    Width = 120
    Height = 25
    Hint = 'Reset settings to their default values'
    Anchors = [akLeft, akBottom]
    Caption = 'Reset'
    Glyph.Data = {
      C6070000424DC607000000000000360000002800000016000000160000000100
      2000000000009007000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000060000000F000000180000
      00200000002900000029000000230000001B0000001200000007000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000100000011000000290000003A00000048100C0D5C3024287F49373DA44030
      3598261C1F7B0101015C00000052000000450000003500000019000000040000
      0000000000000000000000000000000000000000000600000020000000360000
      004C35282C856F5062E6815B75FD7D5474FF7B5074FF7B5074FF7C5374FF7D57
      72FC6B4C5FE7150F117B0000005B00000047000000310000000E000000000000
      000000000000000000020000001B000000330B0809506B4C60DB7D5475FEAA8C
      A8FFCCB5CDFFD7C3D8FFD8C5DAFFD8C5DAFFD7C3D8FFCCB5CDFFAA8CA8FF7C53
      74FE624458D60202025F000000460000002E0000000C00000000000000000000
      000700000020302428547B576FF49B7897FFD2BED4FFD9CED9FFE2DFE2FFEDED
      EDFFEEEFEEFFEFF0F0FFEFEFEFFFD9D2D7FFCFBFCDFFD2BED4FF9B7897FF7552
      6BF0140F1158000000340000001A0000000000000000000000010B08091B7B56
      6FEEAA8CA8FFD8C5DAFFE0DCDFFFF1F1F1FFE4E6E6FFE2E3E3FFBDC3C0FFCACF
      CDFFE3E4E4FFE6E8E8FFF0F1F1FFDBD5D9FFD8C5DAFFAA8CA8FF74506AE70000
      002C0000001300000000000000000000000077546BB79B7897FFD8C5DAFFE5E4
      E5FFE5E7E7FFE2E4E4FFE1E3E3FFE1E3E3FFDADDDCFFDEE1E0FFDFE1E1FFDDDF
      DFFFDCDEDEFFEFF0F0FFE6E3E6FFD8C5DAFF9B7897FF6F4C65A3000000010000
      000000000000755961277D5475FDD2BED4FFD3CED1FFE7E9E9FFE3E5E5FFE4E6
      E6FFB5B7B7FFE4E6E6FFE4E6E6FFE3E5E5FFE2E4E4FFE0E2E2FFDFE1E1FFDCDE
      DEFFEFF0F0FFD6CFD3FFD2BED4FF7C5374FC7357600F00000000000000007A57
      6DC4AA8CA8FFC8B9C7FFEAEBEBFFE6E8E8FFE6E8E8FFE7E9E9FF000000FF0000
      00FFE7E9E9FFE6E8E8FFE5E7E7FFE3E5E5FFE1E3E3FFDFE1E1FFDCDEDEFFE8E9
      E9FFC3B1C0FFAA8CA8FF76526BA80000000000000000805A75F2CCB5CDFFC9C3
      C5FFE8EAEAFFE8EAEAFFE9EBEBFFEAECECFFE2E4E4FF000000FF000000FFE9EB
      EBFFE8EAEAFFE6E8E8FFE4E6E6FFE1E3E3FFDEE0E0FFE6E7E7FFE0DBDEFFCCB5
      CDFF7A5371EA00000000735760017E5576FCD7C3D8FFD8D7D7FFEAECECFFEAEC
      ECFFECEEEEFFEEF0F0FFEEF0F0FFCED0D0FF000000FF000000FFB0B2B2FFE8EA
      EAFFE6E8E8FFE3E5E5FFE0E2E2FFDDDFDFFFE9E7E8FFD7C3D8FF7C5274FA0000
      0000735760107B5175FFD8C5DAFFE1E2E2FFB5BCBAFFE0E3E2FFEFF1F1FFF1F3
      F3FFF2F4F4FFE8EAEAFF000000FFD7D7D7FF000000FFEAECECFFE8EAEAFFE5E7
      E7FFC9CECDFFC0C6C4FFE4E3E3FFD8C5DAFF7B5075FE00000000735760047B51
      75FFD8C5DAFFDBDADBFFD1D6D5FFEBEDEDFFF1F3F3FFF4F6F6FFF5F7F7FFA8C9
      D1FF000000FF000000FFAAABABFFECEEEEFFE9EBEBFFE6E8E8FFDADDDDFFD2D6
      D5FFD8D4D6FFD8C5DAFF7B5074FE00000000000000007E5577FBD7C3D8FFC0BC
      BCFFF0F2F2FFF0F2F2FFF3F5F5FFF0F6F7FFCDDBDEFF000000FF3CB5D1FF4BBA
      D3FFF1F3F3FFEEF0F0FFEAECECFFE7E9E9FFE4E6E6FFDAE4E4FFCDCED0FFD4BF
      D4FF7B5274F800000000000000007E5874E8CCB5CDFFBBB1B5FFF1F3F3FFF3F5
      F5FFE5EFF1FFC8D6D9FF000000FF5BC1D8FF4CBBD4FF5BC0D7FFF1F3F3FFEEF0
      F0FFEBEDEDFFE6EAEAFFA6EBEEFF80EDF2FF85DCE3FFA3B4C6FF755976DB0000
      0000000000007A556F97AA8CA8FFC5B2BEFFDEDDDDFFE6F1F3FFF4F6F6FF0000
      00FF86D1E2FF6CC8DCFF5CC1D9FF5DC0D7FFF1F3F3FFEEF0F0FFEBEDEDFFAEEC
      EFFF83F3F7FF63F3FAFF58E7F0FF48D5E2FE41B7C9BE21F7FF10000000000000
      00007C5375F7D2BED4FFB7ABAEFFEFF4F5FF000000FFADDEE8FF86D0E1FF7CCD
      DFFF6CC6DAFF57BED6FFF0F2F2FFEDEFEFFFE8ECECFFA5F2F5FF5FF3FBFF87F2
      F7FFB9F5F9FF7BE9F2F81FF4FFD320F5FF4B00000000000000007A51726D9B78
      97FFD8C5DAFFB6AEAFFFF1F3F3FFCBEAF1FF80CDDFFF88D0E0FF8CC1CAFF54BA
      D2FFEFF1F1FFECEEEEFFE9EFEFFF9BEBF0FF32EBF4FF97F1F7FFD9F7F9FE89F6
      FCF01FF5FEDB1FF3FF630000000000000000000000007A5271B8AA8CA8FFD8C5
      DAFFB8A9ABFFE0DFDFFFF5F9FAFFA5DCE8FFA7D9E4FFAADBE6FFF7F8F8FFEBEC
      ECFFC4BFC0FF78B0B6FF46D4DCFF53EAF1FE70F3F9F045F7FFE71FF5FFB221F5
      FF3F000000000000000000000000000000007B5272AD9B7897FFD2BED4FFC7B2
      BEFFB4A4A7FFB4AAAAFFBEB8B8FFBAB3B3FFAFA5A6FFAA999EFFBDA8B6FFC1B3
      C4FE64A3AFE928E4EFB81FF5FFBE1FF4FFA520F5FF6726FFFF09000000000000
      00000000000000000000000000007A5074637B5174F3AA8CA8FFCCB5CDFFD7C3
      D8FFD8C5DAFFD8C5DAFFD7C3D8FFCCB5CDFFAA8CA8FF7A5073EC6D69885720F3
      FF3F21F5FF4E1EF6FF3B2AFFFF08000000000000000000000000000000000000
      00000000000000000000000000007A5074637B5372D47B5174F37B5075FE7B50
      75FD7B5173F27A5172C67A507462000000000000000000000000000000000000
      00000000000000000000}
    TabOrder = 1
    OnClick = ResetBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object CloseBtn: TsBitBtn
    Left = 337
    Top = 234
    Width = 120
    Height = 25
    Hint = 'Close this window'
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    Glyph.Data = {
      C6070000424DC607000000000000360000002800000016000000160000000100
      2000000000009007000000000000000000000000000000000000000000000000
      000000000000000000010000000B00000018000000270000003A0000004C0000
      00600000007000000075000000690000005A0000004800000036000000250000
      00170000000700000000000000000000000000000000000000000000000B0000
      0028000000420000005D000056B4000084FB000084FC000083FD000083FE0000
      82FF000083FE000083FD000084FC00005ED30000007D00000062000000480000
      00280000000500000000000000000000000000000000000000050000001C0000
      6E900D0D99F94545E4FF5656E9FF6262EAFF5F5FE8FF5D5DE8FF5B5BE7FF5858
      E6FF6262E5FF0F0FA2FA000074BB000002360000002000000009000000000000
      000000000000000000000000000000000000000087760F0F9BF64B4BE9FF1D1D
      D1FF0505C3FF0505C2FF0505C0FF0404BFFF0404BDFF0404BBFF2424C8FF5454
      E4FF0F0FA8F7000088AD00008603000000000000000000000000000000000000
      0000000000000000887810109CF65252EAFF1E1ED3FF0000C5FF0000C3FF0000
      C1FF0000C0FF0000BEFF0000BDFF0000BBFF0000BAFF2020C6FF5454E4FF1111
      ACF8000088B800008606000000000000000000000000000000000000887A1212
      9DF65656EBFF1F1FD5FF0000C8FF0000C6FF0000C5FF0000C3FF0000C2FF0000
      C0FF0000BEFF0000BDFF0000BBFF0000BAFF2020C5FF5454E4FF2828B7FA0000
      88C30000860900000000000000000000887B14149FF65D5DEDFF2020D8FF0000
      CBFF1616CBFF4545C0FF3030BFFF0000C5FF0000C3FF0000C2FF0000C0FF0606
      B3FF5656C5FF3C3CC8FF0000BAFF1F1FC3FF5353E4FF2929BBFA000088CD0000
      000000000000040489FF6666EFFF2A2AD9FF1010CFFF0B0BCBFF4747C1FFA2A2
      D9FF5757C0FF1D1DBAFF0000C5FF0000C3FF1C1CBAFF6666C8FFBCBCE4FF4444
      BDFF0000B9FF0000BAFF1D1DC2FF7272EAFF000086FF00000000000000000707
      8CFF8989F4FF3D3DD8FF3E3ED8FF3F3FD1FF5555C1FFD6D6E6FFDFDFE8FF6767
      C6FF4444C4FF0606B5FF6464C7FFEAEAF6FFE6E6F5FF3535B6FF0000B5FF0000
      BBFF1616BFFF5A5AE9FF000086FF000000000000000007078CFF8C8CF5FF3F3F
      D8FF4141D9FF4242D9FF4545CCFF5151C0FFD5D5E5FFE2E2EAFF7676CCFF6363
      C6FFE4E4F0FFE3E3F1FF4444BBFF2E2EBEFF0000BFFF0000BDFF0000BBFF4D4D
      EAFF000086FF000000000000000007078CFF8D8DF5FF4242D9FF4343D9FF4545
      D9FF4545D9FF4848CCFF5353C1FFD6D6E5FFECECEDFFEEEEF0FFE3E3EEFF6262
      C6FF5F5FCEFF3131CDFF2C2CCAFF2727C8FF2929C7FF6C6CEDFF050588FF0000
      00000000000007078CFF8E8EF5FF4444D9FF4646DAFF4747DAFF4848DAFF4949
      DAFF4B4BC4FF8888CFFFEBEBEBFFEEEEEEFF9595D5FF4343C1FF3D3DD2FF3B3B
      D1FF3838CFFF3636CDFF3333CBFF6666EDFF070789FF00000000000000000707
      8CFF8F8FF5FF4646DAFF4949DAFF4A4ADAFF4B4BDBFF4F4FCCFF5F5FC4FFD8D8
      E2FFE2E2E6FFE4E4E9FFE3E3EBFF5F5FC5FF4343C5FF3C3CD2FF3A3AD1FF3737
      CFFF3434CCFF6969EFFF070789FF000000000000000007078CFF9090F6FF4848
      DAFF4B4BDBFF4D4DDBFF5151CCFF6262C5FFD4D4DEFFD5D5DFFF5C5CC3FF5757
      C2FFD9D9E6FFE3E3EBFF5D5DC5FF4242C5FF3B3BD2FF3838D0FF3535CEFF6C6C
      EFFF080889FF0000000000000000040489FF8F8FF4FF6161E3FF4C4CDBFF4F4F
      D4FF5555C2FFD3D3DDFFD3D3DDFF5F5FC4FF4E4ECDFF4C4CCEFF5555C1FFD8D8
      E6FFE2E2EAFF4747BDFF3B3BCBFF3939D1FF4C4CDAFF6A6AECFF09098AFF0000
      0000000000000000889B3232AFF69393F4FF6464E3FF5050DAFF5959C9FF7C7C
      CBFF6363C5FF5252CEFF4D4DDBFF4A4ADAFF4949CDFF5454C0FF7B7BCCFF4646
      C2FF3C3CD4FF4F4FDDFF6F6FECFF2A2AA9F60000888E00000000000000000000
      0000000088973535AFF69494F4FF6868E4FF5353DBFF5B5BCBFF5555D0FF5050
      DCFF4D4DDBFF4A4ADAFF4747DAFF4646CDFF4949C5FF3F3FD7FF5252DFFF7676
      EFFF2B2BA9F60000889300000000000000000000000000000000000000000000
      88933939B0F69595F4FF6A6AE5FF5252DCFF5151DCFF4F4FDBFF4C4CDBFF4A4A
      DAFF4747DAFF4444D9FF4141D9FF5555E1FF7B7BF1FF2E2EACF6000089980000
      00000000000000000000000000000000000000000000000000000000888F3B3B
      B0F79494F4FF6A6AE5FF4F4FDBFF4D4DDBFF4B4BDBFF4949DAFF4646DAFF4343
      D9FF5757E1FF8181F2FF2B2BABF70000899D0000000000000000000000000000
      000000000000000000000000000000000000000000000000898B3E3EB1F79494
      F4FF9B9BF7FF9A9AF7FF9999F7FF9898F7FF9696F6FF9292F6FF8888F2FF2A2A
      ACF7000089A00000860100000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008987000088F9000089F60000
      89F6000089F6000089F6000089F6000089F6000088F8000089A5000086010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000086170000861800008618000086180000
      8618000086180000861800008618000086020000000000000000000000000000
      00000000000000000000}
    TabOrder = 0
    OnClick = CloseBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object SettingsList: TsPageControl
    Left = 8
    Top = 8
    Width = 449
    Height = 220
    ActivePage = sTabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    SkinData.SkinSection = 'PAGECONTROL'
    object sTabSheet1: TsTabSheet
      Caption = 'General'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GeneralPanel: TsPanel
        Left = 0
        Top = 0
        Width = 441
        Height = 192
        Align = alClient
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 0
        SkinData.SkinSection = 'CHECKBOX'
        object CheckUpdatesChckBtn: TsCheckBox
          Left = 16
          Top = 16
          Width = 150
          Height = 19
          Hint = 'Check updates when TEncoder is run'
          Caption = 'Check updates on startup'
          Checked = True
          Color = clWhite
          ParentColor = False
          State = cbChecked
          TabOrder = 0
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object ClearTempFolderBtn: TsBitBtn
          Left = 16
          Top = 49
          Width = 169
          Height = 30
          Caption = 'Clear temporary files folder'
          Glyph.Data = {
            C6070000424DC607000000000000360000002800000016000000160000000100
            2000000000009007000000000000000000000000000000000000FFFFFF000000
            00030000000A000000130000001B000000230000002C000000350000003E0000
            004800000051000000540000004E000000460000003C000000330000002A0000
            0022000000190000000F0000000600000001FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF001E399D2A2D39CF71313BD98D2A32D6A32128
            CBA3161FBA8D0D1AAD71001B852AFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001220
            B3461F22D6D32B2BE9FF3636F4FF3939F8FF2E2EEDFF2424E1FF1919D6FF0F0F
            CCFF0404C1FF0205B8D30412A146FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000A0AC54A1616D3FD2121DEFF2B2B
            E9FF3636F4FF3939F8FF2E2EEDFF2424E1FF1919D6FF0F0FCCFF0404C1FF0303
            BFFF0303BFFD0404BC48FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000C0CC8B11616D3FF2121DEFF2B2BE9FF3333EFFF3333
            F3FF2A2AEAFF2424E0FF2C2CC1FF0F0FCCFF0404C1FF0303BFFF0303BFFF0303
            BFAAFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF000C0CC8C61616D3FF2121DCFF7272BEFFDEDEF2FFECECFBFF7E7EE7FF3737
            D4FFEDEDF7FFB8B8DAFF6B6BB1FF0303BAFF0303BFFF0303BFBEFFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000C0CC8D21616
            D3FF3636AFFFCDCDE3FF4343DCFF3F3FEDFF2E2EE8FF2323DFFF5151C1FF3434
            B9FFC1C1D9FF36369AFF0303BFFF0303BFCAFFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000B0BC8DF1616D3FF2525B3FFEFEF
            F6FF4141CFFF3939F8FF2E2EEDFF2424E1FF1919D6FF1414C1FFE4E4EDFF4242
            9FFF0303BFFF0404BFD7FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000C0CC8EC1616D3FF2727BDFFE3E3EFFF7979D8FF3939
            F8FF2E2EEDFF2424E1FF1919D6FF6E6EC1FFD5D5E4FF0404B0FF0303BFFF0303
            BFE4FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF000C0CC8F91616D3FF1E1ECFFF2D2DCBFF3D3DDAFF4242EEFF2E2EEDFF2424
            E0FF1919CBFF2A2AB6FF4141A9FF0303BFFF0303BFFF0303C0F1FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000CC050C0CC8FF1616
            D3FF2121DEFF2B2BE9FF9F9FDDFFBEBEF2FF2B2BEAFF2F2FCFFFF1F1F9FF7373
            C1FF0404C1FF0303BFFF0303BFFF0303C0FDFFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000B8120C0CC8FF1616D3FF2121DEFF2B2B
            E9FF3B3BDEFFF1F1FCFF7070E6FF8181DCFFCFCFEAFF3434AFFF0404C0FF0303
            BFFF0303BFFF0303BFFF0000B30AFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF000000BD1F0C0CC8FF1616D3FF2121DEFF2B2BE9FF3636F4FF6565
            E8FFF0F0FCFFE6E6F7FF3131C8FF0F0FCCFF0404C1FF0303BFFF0303BFFF0303
            BFFF0000BC17FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000606
            BE2B0C0CC8FF1616D3FF2121DEFF2B2BE9FF3636F4FF3939F8FF2A2AE8FF2020
            DCFF1919D6FF0F0FCCFF0404C1FF0303BFFF0303BFFF0303BFFF0000BD23FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000505BF380C0CC8FF1616
            D2FF1F1FDBFF2929E4FF3333EFFF3636F1FF2B2BE6FF2222DBFF1818D2FF0F0F
            C8FF0505BEFF0303BEFF0303BEFF0303BFFF0505BF30FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000404C0450C0CC7FF1515D1FF2727DFFF4343
            EBFF6060F3FF7171F1FF7878DDFF7676DAFF6565E7FF5050E2FF2C2CD2FF0C0C
            C4FF0303BEFF0303BEFF0404C03DFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF000303BE521212CCFF3737CFFF3F3F9DFF383883FF30306DFF3131
            69FF32326CFF32326CFF313169FF30306DFF383883FF3F3F9DFF3232CBFF0A0A
            C4FF0303BD4AFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000707
            C3692C2CB3FF22227BFF19197BFF1D1D7DFF22227EFF272780FF2C2C81FF2C2C
            81FF272780FF22227EFF1D1D7DFF19197BFF21217CFF2C2CB5FF0808C361FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001616D54D151573FF1111
            83FF18188DFF1D1D8EFF22228FFF272791FF2C2C92FF2C2C92FF272791FF2222
            8FFF1D1D8EFF18188DFF12128CFF1B1B9AFF1616D44CFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002525BEA9151576FF141481FF1D1D
            9CFF22229FFF2727A1FF2C2CA2FF2C2CA2FF2727A1FF22229FFF1D1D9EFF1818
            9CFF1D1DA8FF2727C7A6FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF004444E43B4141C7AC4545B9EC4949B8FF4848
            B6FF4242B1FF4444B7FF4D4DC7FF5252CFFF4E4ED1EA4545D2A94444E43BFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007E7EF2179191F72EA4A4FB44A4A4
            FB449090F72E7D7DF217FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00}
          TabOrder = 1
          OnClick = ClearTempFolderBtnClick
          SkinData.SkinSection = 'BUTTON'
        end
      end
    end
    object sTabSheet2: TsTabSheet
      Caption = 'Subtitle'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SubtitlePanel: TsPanel
        Left = 0
        Top = 0
        Width = 441
        Height = 192
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        SkinData.SkinSection = 'CHECKBOX'
        object sLabel1: TsLabel
          Left = 35
          Top = 130
          Width = 80
          Height = 13
          Caption = 'Subtitle position:'
          ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2171169
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object AutoScaleList: TsComboBox
          Left = 120
          Top = 70
          Width = 310
          Height = 21
          Hint = 'How to size subtitle'
          Alignment = taLeftJustify
          BoundLabel.Active = True
          BoundLabel.Caption = 'Auto-scale method:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = 2171169
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          VerticalAlignment = taAlignTop
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = 3
          ParentFont = False
          TabOrder = 0
          Text = 'Proportinal to video diagonal'
          Items.Strings = (
            'No Autoscale'
            'Proportinal to video height'
            'Proportinal to video width'
            'Proportinal to video diagonal')
        end
        object LangIdList: TsComboBox
          Left = 120
          Top = 15
          Width = 310
          Height = 21
          Hint = 'Character encoding of subtitle'
          Alignment = taLeftJustify
          BoundLabel.Active = True
          BoundLabel.Caption = 'Language:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = 2171169
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          VerticalAlignment = taAlignTop
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
          Text = 'Unicode (Unicode)'
          Items.Strings = (
            'Unicode (Unicode)'
            'UTF-8 (UTF-8)'
            'Western European Languages (ISO-8859-1)'
            'Western European Languages with Euro (ISO-8859-15)'
            'Slavic/Central European Languages (ISO-8859-2)'
            'Turkish, Esperanto, Galician, Maltese (ISO-8859-3)'
            'Old Baltic Charset (ISO-8859-4)'
            'Cyrillic (ISO-8859-5)'
            'Arabic (ISO-8850-6)'
            'Modern Greek (ISO-8859-7)'
            'Turkish (ISO-8859-9)'
            'Baltic (ISO-8859-13)'
            'Celtic (ISO-8859-14)'
            'Herbew (ISO-8859-8)'
            'Russian (KO18-R)'#39
            'Ukrainian, Belarusian (KO18-U/RU)'
            'Simplified Chinese Charset (CP936)'
            'Traditional Chinese Charset (BIG5)'
            'Japanese Charset (SHIFT-JIS)'
            'Korean Charset (CP949)'
            'Thai Charset (CP874)'
            'Cyrillic Windows (CP1251)'
            'Slavic/Central European Languages Windows (CP1250)'
            'Arabic Windows (CP1256)'
            'None')
        end
        object SubposBar: TsTrackBar
          Left = 121
          Top = 125
          Width = 238
          Height = 23
          Hint = 'Position of the subtitle'
          Max = 100
          Position = 100
          ShowSelRange = False
          TabOrder = 2
          TickMarks = tmBoth
          TickStyle = tsNone
          OnChange = SubposBarChange
          SkinData.SkinSection = 'TRACKBAR'
          BarOffsetV = 0
          BarOffsetH = 0
        end
        object SubPosEdit: TsEdit
          Left = 365
          Top = 125
          Width = 65
          Height = 21
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
        end
        object FontList: TsComboBox
          Left = 121
          Top = 43
          Width = 309
          Height = 21
          Alignment = taLeftJustify
          BoundLabel.Active = True
          BoundLabel.Caption = 'Fonts:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = 2171169
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          VerticalAlignment = taAlignTop
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          ParentFont = False
          TabOrder = 4
        end
        object DefScaleEdit: TsSpinEdit
          Left = 121
          Top = 99
          Width = 100
          Height = 21
          Hint = 'Default scale value of subtitle'
          Alignment = taCenter
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          NumbersOnly = True
          ParentFont = False
          TabOrder = 5
          Text = '10'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Active = True
          BoundLabel.Caption = 'Default scale:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 0
          MinValue = 0
          Value = 10
        end
        object SubSSABtn: TsCheckBox
          Left = 3
          Top = 160
          Width = 220
          Height = 19
          Caption = 'Don'#39't override SSA or ASS subtitle styles'
          Checked = True
          State = cbChecked
          TabOrder = 6
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
      end
    end
    object Encoding: TsTabSheet
      Caption = 'Encoding'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object EncodingPanel: TsPanel
        Left = 0
        Top = 0
        Width = 441
        Height = 192
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        SkinData.SkinSection = 'CHECKBOX'
        object sLabel2: TsLabel
          Left = 428
          Top = 16
          Width = 5
          Height = 13
          Cursor = crHandPoint
          Caption = '?'
          OnClick = sLabel2Click
        end
        object NumberOfThreadsList: TsComboBox
          Left = 120
          Top = 15
          Width = 49
          Height = 21
          Hint = 'Number of processes that will be run at the same time'
          Alignment = taLeftJustify
          BoundLabel.Active = True
          BoundLabel.Caption = 'Number of processes:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clBlack
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          VerticalAlignment = taAlignTop
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
          Text = '1'
          Items.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12'
            '13'
            '14'
            '15'
            '16')
        end
        object ResetThreadBtn: TsButton
          Left = 175
          Top = 11
          Width = 90
          Height = 25
          Hint = 'Reset value to number of CPU cores'
          Caption = 'Reset'
          TabOrder = 1
          OnClick = ResetThreadBtnClick
          SkinData.SkinSection = 'BUTTON'
        end
        object ThreadChkBtn: TsCheckBox
          Left = 271
          Top = 16
          Width = 151
          Height = 19
          Hint = 'Use extra option to improve encoding performance'
          Caption = 'Use extra threads options'
          TabOrder = 2
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object PostEncodeActionList: TsComboBox
          Left = 120
          Top = 42
          Width = 145
          Height = 21
          Alignment = taLeftJustify
          BoundLabel.Active = True
          BoundLabel.Caption = 'Post-encode action:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clBlack
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          VerticalAlignment = taAlignTop
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = 0
          ParentFont = False
          TabOrder = 3
          Text = 'Nothing'
          OnChange = PostEncodeActionListChange
          Items.Strings = (
            'Nothing'
            'Close TEncoder'
            'Open output folder'
            'Shutdown PC'
            'Log Off'
            'Restart')
        end
        object DeleteUnfinBtn: TsCheckBox
          Left = 12
          Top = 70
          Width = 131
          Height = 19
          Caption = 'Delete unfinished files'
          Checked = True
          State = cbChecked
          TabOrder = 4
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object x264Btn: TsCheckBox
          Left = 12
          Top = 95
          Width = 236
          Height = 19
          Caption = 'Use single process for x264 (recommended)'
          Checked = True
          State = cbChecked
          TabOrder = 5
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object FolderStructBtn: TsCheckBox
          Left = 12
          Top = 120
          Width = 216
          Height = 19
          Caption = 'Do not create folder structure in output'
          TabOrder = 6
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object CopyDateBtn: TsCheckBox
          Left = 271
          Top = 74
          Width = 157
          Height = 19
          Caption = 'Copy date info from source'
          TabOrder = 7
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object DontTrimBtn: TsCheckBox
          Left = 12
          Top = 145
          Width = 121
          Height = 19
          Caption = 'Do not use trimming'
          Checked = True
          State = cbChecked
          TabOrder = 8
          OnClick = DontTrimBtnClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object PlaySoundBtn: TsCheckBox
          Left = 271
          Top = 97
          Width = 160
          Height = 19
          Caption = 'Play a sound after encoding'
          TabOrder = 9
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
      end
    end
    object sTabSheet4: TsTabSheet
      Caption = 'Skin'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SkinPanel: TsPanel
        Left = 0
        Top = 0
        Width = 441
        Height = 192
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        SkinData.SkinSection = 'CHECKBOX'
        object Label1: TLabel
          Left = 12
          Top = 49
          Width = 54
          Height = 13
          Caption = 'Saturation:'
        end
        object SaturationLabel: TLabel
          Left = 311
          Top = 49
          Width = 6
          Height = 13
          Caption = '0'
        end
        object sLabel3: TsLabel
          Left = 43
          Top = 76
          Width = 23
          Height = 13
          Caption = 'Hue:'
          ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object HueLabel: TsLabel
          Left = 311
          Top = 76
          Width = 6
          Height = 13
          Caption = '0'
          ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object SaturationBar: TsTrackBar
          Left = 72
          Top = 41
          Width = 233
          Height = 23
          Max = 100
          Min = -100
          Position = -100
          ShowSelRange = False
          TabOrder = 0
          TickMarks = tmBoth
          TickStyle = tsNone
          OnChange = SaturationBarChange
          SkinData.SkinSection = 'TRACKBAR'
          BarOffsetV = 0
          BarOffsetH = 0
        end
        object SkinList: TsComboBox
          Left = 72
          Top = 15
          Width = 193
          Height = 21
          Alignment = taLeftJustify
          BoundLabel.Active = True
          BoundLabel.Caption = 'Skins:'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clBlack
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          VerticalAlignment = taAlignTop
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          ParentFont = False
          TabOrder = 1
          OnChange = SkinListChange
        end
        object HueTrackBar: TsTrackBar
          Left = 72
          Top = 70
          Width = 233
          Height = 23
          Max = 360
          ShowSelRange = False
          TabOrder = 2
          TickMarks = tmBoth
          TickStyle = tsNone
          OnChange = HueTrackBarChange
          SkinData.SkinSection = 'TRACKBAR'
          BarOffsetV = 0
          BarOffsetH = 0
        end
        object SkinEnableBtn: TsCheckBox
          Left = 271
          Top = 16
          Width = 101
          Height = 19
          Caption = 'Disable skinning'
          TabOrder = 3
          OnClick = SkinEnableBtnClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
      end
    end
    object sTabSheet3: TsTabSheet
      Caption = 'Video Downloader'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PreferedFormatEdit: TsEdit
        Left = 100
        Top = 3
        Width = 338
        Height = 21
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'mp4, 1080p, DASH, video'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Active = True
        BoundLabel.Caption = 'Preferred format:'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
      end
      object DashVideoBtn: TsCheckBox
        Left = 3
        Top = 30
        Width = 280
        Height = 19
        Caption = 'When a "DASH" video is selected download audio too'
        Checked = True
        State = cbChecked
        TabOrder = 1
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
      object ProcessCountEdit: TsEdit
        Left = 121
        Top = 55
        Width = 49
        Height = 21
        Alignment = taCenter
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = '4'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Active = True
        BoundLabel.Caption = 'Parallel download count:'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
      end
      object ProcessCountBar: TsTrackBar
        Left = 176
        Top = 56
        Width = 114
        Height = 23
        Max = 8
        Min = 1
        Position = 4
        ShowSelRange = False
        TabOrder = 3
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = ProcessCountBarChange
        SkinData.SkinSection = 'TRACKBAR'
        BarOffsetV = 0
        BarOffsetH = 0
      end
      object DontDoubleDownloadBtn: TsCheckBox
        Left = 3
        Top = 85
        Width = 254
        Height = 19
        Caption = 'Don'#39't download again if  local file contains audio'
        Checked = True
        State = cbChecked
        TabOrder = 4
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
      object DontPreviewImgBtn: TsCheckBox
        Left = 3
        Top = 110
        Width = 112
        Height = 19
        Caption = 'Don'#39't load thumbs'
        TabOrder = 5
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
    end
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    UseGlobalColor = False
    Left = 352
    Top = 112
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [fdTrueTypeOnly, fdEffects]
    Left = 368
    Top = 56
  end
end
