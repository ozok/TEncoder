{ *
  * Copyright (C) 2011-2014 ozok <ozok26@gmail.com>
  *
  * This file is part of TEncoder.
  *
  * TEncoder is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * TEncoder is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with TEncoder.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }
unit UnitAdvancedOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sComboBox, sLabel,
  sSkinProvider, sCheckBox, IniFiles, Vcl.Buttons, sBitBtn, Vcl.ComCtrls,
  sPageControl, sEdit, sTrackBar, sSpinEdit, Vcl.ExtCtrls, sPanel, StrUtils,
  sGroupBox;

type
  TAdvancedOptionsForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    x264ProfileList: TsComboBox;
    x264PresetList: TsComboBox;
    x264LevelList: TsComboBox;
    x264TuneList: TsComboBox;
    x264Btn: TsCheckBox;
    CloseBtn: TsBitBtn;
    OptionPages: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    ProresProfileList: TsComboBox;
    ProresQualityBar: TsTrackBar;
    ProresQualityEdit: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    x264CRFBtn: TsCheckBox;
    x264CRFEdit: TsSpinEdit;
    sTabSheet3: TsTabSheet;
    MPEGAudioIDBtn: TsCheckBox;
    VideoSettingsPanel: TsPanel;
    ForceASRBtn: TsCheckBox;
    VideoAspectRatioList: TsComboBox;
    VideobitrateList: TsComboBox;
    VideoCBrBtn: TsCheckBox;
    VideoFPSList: TsComboBox;
    VideoSizeList: TsComboBox;
    WidthEdit: TsSpinEdit;
    HeightEdit: TsSpinEdit;
    AudioSettingsPanel: TsPanel;
    AudioBitrateList: TsComboBox;
    AudioChannelsList: TsComboBox;
    AudioSampleRateList: TsComboBox;
    GroupBox1: TsGroupBox;
    sGroupBox1: TsGroupBox;
    sGroupBox2: TsGroupBox;
    sLabelFX1: TsLabel;
    CustomFFmpegVideoBtn: TsCheckBox;
    CustomFFmpegAudioBtn: TsCheckBox;
    CustomFFMpegVideoEdit: TsEdit;
    CustomFFMpegAudioEdit: TsEdit;
    CustomMEncoderAudioEdit: TsEdit;
    CustomMEncoderVideoEdit: TsEdit;
    CustomMEncoderAudioBtn: TsCheckBox;
    CustomMEncoderVideoBtn: TsCheckBox;
    CustomFFmpegEdit: TsEdit;
    CustomMencoderEdit: TsEdit;
    sTabSheet4: TsTabSheet;
    FlacCompBar: TsTrackBar;
    FlacCompEdit: TsEdit;
    procedure x264BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ProresQualityBarChange(Sender: TObject);
    procedure x264CRFBtnClick(Sender: TObject);
    procedure VideoSizeListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CustomFFmpegAudioBtnClick(Sender: TObject);
    procedure CustomFFmpegVideoBtnClick(Sender: TObject);
    procedure CustomMEncoderAudioBtnClick(Sender: TObject);
    procedure CustomMEncoderVideoBtnClick(Sender: TObject);
    procedure FlacCompBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure SaveSettings();
    procedure LoadSettings();
  end;

var
  AdvancedOptionsForm: TAdvancedOptionsForm;

implementation

{$R *.dfm}

uses UnitMain, UnitProfileEditor;

procedure TAdvancedOptionsForm.CloseBtnClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TAdvancedOptionsForm.CustomFFmpegAudioBtnClick(Sender: TObject);
begin
  CustomFFMpegAudioEdit.Enabled := CustomFFmpegAudioBtn.Checked;
end;

procedure TAdvancedOptionsForm.CustomFFmpegVideoBtnClick(Sender: TObject);
begin
  CustomFFMpegVideoEdit.Enabled := CustomFFmpegVideoBtn.Checked;
end;

procedure TAdvancedOptionsForm.CustomMEncoderAudioBtnClick(Sender: TObject);
begin
  CustomMEncoderAudioEdit.Enabled := CustomMEncoderAudioBtn.Checked;
end;

procedure TAdvancedOptionsForm.CustomMEncoderVideoBtnClick(Sender: TObject);
begin
  CustomMEncoderVideoEdit.Enabled := CustomMEncoderVideoBtn.Checked;
end;

procedure TAdvancedOptionsForm.FlacCompBarChange(Sender: TObject);
begin
  FlacCompEdit.Text := FloatToStr(FlacCompBar.Position);
end;

procedure TAdvancedOptionsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
  MainForm.UpdateSummary;
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TAdvancedOptionsForm.FormCreate(Sender: TObject);
begin
  // load values from main window
  with ProfileForm do
  begin
    // video options
    VCodecList.Items.AddStrings(MainForm.VideoEncoderList.Items);
    VBitrateList.Items.AddStrings(VideobitrateList.Items);
    VSizeList.Items.AddStrings(VideoSizeList.Items);
    VFPSList.Items.AddStrings(VideoFPSList.Items);
    VASRList.Items.AddStrings(VideoAspectRatioList.Items);

    VCodecList.ItemIndex := MainForm.VideoEncoderList.ItemIndex;
    VBitrateList.ItemIndex := VideobitrateList.ItemIndex;
    VSizeList.ItemIndex := VideoSizeList.ItemIndex;
    VFPSList.ItemIndex := VideoFPSList.ItemIndex;
    VASRList.ItemIndex := VideoAspectRatioList.ItemIndex;

    // audio options
    ACodecList.Items.AddStrings(MainForm.AudioEncoderList.Items);
    ABitrateList.Items.AddStrings(AudioBitrateList.Items);
    ASampleRateList.Items.AddStrings(AudioSampleRateList.Items);
    AChanList.Items.AddStrings(AudioChannelsList.Items);

    ACodecList.ItemIndex := MainForm.AudioEncoderList.ItemIndex;
    ABitrateList.ItemIndex := AudioBitrateList.ItemIndex;
    ASampleRateList.ItemIndex := AudioSampleRateList.ItemIndex;
    AChanList.ItemIndex := AudioChannelsList.ItemIndex;

    ProfileForm.EncoderList.Items.AddStrings(MainForm.EncoderList.Items);
    ProfileForm.EncoderList.ItemIndex := MainForm.EncoderList.ItemIndex;
    LContainerList.Items.AddStrings(MainForm.ContainerList.Items);
    ProfileForm.LContainerList.ItemIndex := MainForm.ContainerList.ItemIndex;
  end;
  LoadSettings;
end;

procedure TAdvancedOptionsForm.FormShow(Sender: TObject);
begin
  // VideoSizeListChange(Self);
end;

procedure TAdvancedOptionsForm.LoadSettings;
var
  SettingsFile: TIniFile;
begin

  SettingsFile := TIniFile.Create(MainForm.AppDataFolder + '\Settings.ini');
  try
    with SettingsFile do
    begin
      VideobitrateList.Text := ReadString('Options', 'VBitrateStr', '512');
      VideoSizeList.ItemIndex := ReadInteger('Options', 'VSize', 6);
      // VideoSizeListChange(Self);
      VideoFPSList.ItemIndex := ReadInteger('Options', 'VFPS', 0);
      VideoAspectRatioList.ItemIndex := ReadInteger('Options', 'VAR', 1);
      WidthEdit.Text := ReadString('Options', 'Width', '352');
      HeightEdit.Text := ReadString('Options', 'Height', '288');
      ForceASRBtn.Checked := ReadBool('Options', 'ForceASR', False);
      AudioBitrateList.Text := ReadString('Options', 'ABitrateStr', '128');
      AudioSampleRateList.ItemIndex := ReadInteger('Options', 'ASR', 5);
      AudioChannelsList.ItemIndex := ReadInteger('Options', 'AChan', 1);

      VideoCBrBtn.Checked := ReadBool('Options', 'CBRVideo', False);

      x264ProfileList.ItemIndex := ReadInteger('x264', 'Profile', 0);
      x264PresetList.ItemIndex := ReadInteger('x264', 'Preset', 0);
      x264LevelList.ItemIndex := ReadInteger('x264', 'Level', 0);
      x264TuneList.ItemIndex := ReadInteger('x264', 'Tune', 0);
      x264Btn.Checked := ReadBool('x264', 'Enabled', False);
      x264CRFBtn.Checked := ReadBool('x264', 'crf', False);
      x264CRFEdit.Text := ReadString('x264', 'crf2', '23');

      ProresProfileList.ItemIndex := ReadInteger('prores', 'Profile', 0);
      ProresQualityBar.Position := ReadInteger('prores', 'Quality', 13);

      MPEGAudioIDBtn.Checked := ReadBool('mpeg', 'audioid2', True);

      CustomFFmpegVideoBtn.Checked := ReadBool('Options', 'FCustom', False);
      CustomFFMpegVideoEdit.Text := ReadString('Options', 'FCustom2', '');
      CustomFFMpegVideoEdit.Enabled := CustomFFmpegVideoBtn.Checked;
      CustomFFmpegAudioBtn.Checked := ReadBool('Options', 'FCustomA', False);
      CustomFFMpegAudioEdit.Text := ReadString('Options', 'FCustomA2', '');
      CustomFFMpegAudioEdit.Enabled := CustomFFmpegAudioBtn.Checked;

      CustomMEncoderVideoBtn.Checked := ReadBool('Options', 'MCustom', False);
      CustomMEncoderVideoEdit.Text := ReadString('Options', 'MCustom2', '');
      CustomMEncoderVideoEdit.Enabled := CustomMEncoderVideoBtn.Checked;
      CustomMEncoderAudioBtn.Checked := ReadBool('Options', 'MCustomA', False);
      CustomMEncoderAudioEdit.Text := ReadString('Options', 'MCustomA2', '');
      CustomMEncoderAudioEdit.Enabled := CustomMEncoderAudioBtn.Checked;

      CustomMencoderEdit.Text := ReadString('Options', 'Men', '');
      CustomFFmpegEdit.Text := ReadString('Options', 'FF', '');

      FlacCompBar.Position := ReadInteger('Options', 'FlacComp', 12);
    end;
  finally
    SettingsFile.Free;
    x264Btn.OnClick(Self);
    ProresQualityEdit.Text := FloatToStr(ProresQualityBar.Position);
    FlacCompBarChange(Self);
  end;
end;

procedure TAdvancedOptionsForm.ProresQualityBarChange(Sender: TObject);
begin

  ProresQualityEdit.Text := FloatToStr(ProresQualityBar.Position);

end;

procedure TAdvancedOptionsForm.SaveSettings;
var
  SettingsFile: TIniFile;
begin

  SettingsFile := TIniFile.Create(MainForm.AppDataFolder + '\Settings.ini');
  try
    with SettingsFile do
    begin
      WriteInteger('x264', 'Profile', x264ProfileList.ItemIndex);
      WriteInteger('x264', 'Preset', x264PresetList.ItemIndex);
      WriteInteger('x264', 'Level', x264LevelList.ItemIndex);
      WriteInteger('x264', 'Tune', x264TuneList.ItemIndex);
      WriteBool('x264', 'Enabled', x264Btn.Checked);
      WriteBool('x264', 'crf', x264CRFBtn.Checked);
      WriteString('x264', 'crf2', x264CRFEdit.Text);

      WriteInteger('prores', 'Profile', ProresProfileList.ItemIndex);
      WriteInteger('prores', 'Quality', ProresQualityBar.Position);

      WriteBool('mpeg', 'audioid2', MPEGAudioIDBtn.Checked);

      WriteString('Options', 'VBitrateStr', VideobitrateList.Text);
      WriteInteger('Options', 'VSize', VideoSizeList.ItemIndex);
      WriteInteger('Options', 'VFPS', VideoFPSList.ItemIndex);
      WriteInteger('Options', 'VAR', VideoAspectRatioList.ItemIndex);
      WriteString('Options', 'Width', WidthEdit.Text);
      WriteString('Options', 'Height', HeightEdit.Text);
      WriteBool('Options', 'ForceASR', ForceASRBtn.Checked);
      WriteBool('Options', 'CBRVideo', VideoCBrBtn.Checked);

      WriteString('Options', 'ABitrateStr', AudioBitrateList.Text);
      WriteInteger('Options', 'ASR', AudioSampleRateList.ItemIndex);
      WriteInteger('Options', 'AChan', AudioChannelsList.ItemIndex);

      WriteBool('Options', 'FCustom', CustomFFmpegVideoBtn.Checked);
      WriteString('Options', 'FCustom2', CustomFFMpegVideoEdit.Text);
      WriteBool('Options', 'FCustomA', CustomFFmpegAudioBtn.Checked);
      WriteString('Options', 'FCustomA2', CustomFFMpegAudioEdit.Text);

      WriteBool('Options', 'MCustom', CustomMEncoderVideoBtn.Checked);
      WriteString('Options', 'MCustom2', CustomMEncoderVideoEdit.Text);
      WriteBool('Options', 'MCustomA', CustomMEncoderAudioBtn.Checked);
      WriteString('Options', 'MCustomA2', CustomMEncoderAudioEdit.Text);

      WriteString('Options', 'Men', CustomMencoderEdit.Text);
      WriteString('Options', 'FF', CustomFFmpegEdit.Text);

      WriteInteger('Options', 'FlacComp', FlacCompBar.Position);
    end;
  finally
    SettingsFile.Free;
  end;
end;

procedure TAdvancedOptionsForm.VideoSizeListChange(Sender: TObject);
begin
  case VideoSizeList.ItemIndex of
    0:
      begin
        WidthEdit.Enabled := False;
        HeightEdit.Enabled := False;
      end;
    1:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '160';
        HeightEdit.Text := '112';
      end;
    2:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '176';
        HeightEdit.Text := '144';
      end;
    3:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '220';
        HeightEdit.Text := '176';
      end;
    4:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '320';
        HeightEdit.Text := '240';
      end;
    5:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '352';
        HeightEdit.Text := '240';
      end;
    6:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '352';
        HeightEdit.Text := '288';
      end;
    7:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '368';
        HeightEdit.Text := '208';
      end;
    8:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '480';
        HeightEdit.Text := '272';
      end;
    9:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '480';
        HeightEdit.Text := '320';
      end;
    10:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '480';
        HeightEdit.Text := '360';
      end;
    11:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '480';
        HeightEdit.Text := '480';
      end;
    12:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '480';
        HeightEdit.Text := '576';
      end;
    13:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '512';
        HeightEdit.Text := '384';
      end;
    14:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '640';
        HeightEdit.Text := '480';
      end;
    15:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '720';
        HeightEdit.Text := '480';
      end;
    16:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '720';
        HeightEdit.Text := '576';
      end;
    17:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '854';
        HeightEdit.Text := '480';
      end;
    18:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '960';
        HeightEdit.Text := '720';
      end;
    19:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '960';
        HeightEdit.Text := '540';
      end;
    20:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '1080';
        HeightEdit.Text := '720';
      end;
    21:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '1280';
        HeightEdit.Text := '720';
      end;
    22:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '1440';
        HeightEdit.Text := '1080';
      end;
    23:
      begin
        WidthEdit.Enabled := True;
        HeightEdit.Enabled := True;
        WidthEdit.Text := '1920';
        HeightEdit.Text := '1080';
      end;
  end;
end;

procedure TAdvancedOptionsForm.x264BtnClick(Sender: TObject);
begin

  x264ProfileList.Enabled := x264Btn.Checked;
  x264PresetList.Enabled := x264Btn.Checked;
  x264LevelList.Enabled := x264Btn.Checked;
  x264TuneList.Enabled := x264Btn.Checked;
  x264CRFBtn.Enabled := x264Btn.Checked;

  if x264Btn.Checked then
  begin
    x264CRFEdit.Enabled := x264CRFBtn.Checked;
  end
  else
  begin
    x264CRFEdit.Enabled := False;
  end;

end;

procedure TAdvancedOptionsForm.x264CRFBtnClick(Sender: TObject);
begin
  x264CRFEdit.Enabled := x264CRFBtn.Checked;
end;

end.
