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
unit UnitEffects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, sBitBtn, sSkinProvider, ExtCtrls,
  sPanel,
  sComboBox, sCheckBox, sLabel, IniFiles, Vcl.Mask, JvExMask, JvSpin, sPageControl, sEdit, sSpinEdit;

type
  TEffectForm = class(TForm)
    CloseBtn: TsBitBtn;
    sSkinProvider1: TsSkinProvider;
    PreviewBtn: TsBitBtn;
    PreviewList: TsComboBox;
    DeintEnblBtn: TsCheckBox;
    DeintMethodList: TsComboBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    Label5: TsLabel;
    CropEnable: TsCheckBox;
    CropHeightEdit: TsSpinEdit;
    CropWidthEdit: TsSpinEdit;
    CropXEdit: TsSpinEdit;
    CropYEdit: TsSpinEdit;
    sTabSheet3: TsTabSheet;
    RotateList: TsComboBox;
    sTabSheet4: TsTabSheet;
    VolumeEnableBtn: TsCheckBox;
    VolumeMencoderEdit: TsSpinEdit;
    VolumeFFMpegEdit: TsSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeintEnblBtnClick(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    procedure CropEnableClick(Sender: TObject);
    procedure VolumeEnableBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveSettings();
    procedure LoadSettings();
  public
    { Public declarations }
  end;

var
  EffectForm: TEffectForm;

implementation

uses UnitMain, UnitPreview;

{$R *.dfm}

procedure TEffectForm.CloseBtnClick(Sender: TObject);
begin

  EffectForm.Close;

end;

procedure TEffectForm.CropEnableClick(Sender: TObject);
begin

  CropWidthEdit.Enabled := CropEnable.Checked;
  CropHeightEdit.Enabled := CropEnable.Checked;
  CropXEdit.Enabled := CropEnable.Checked;
  CropYEdit.Enabled := CropEnable.Checked;

end;

procedure TEffectForm.DeintEnblBtnClick(Sender: TObject);
begin

  DeintMethodList.Enabled := DeintEnblBtn.Checked;

end;

procedure TEffectForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  SaveSettings;

  PreviewList.Items.Clear;

  MainForm.Enabled := True;

end;

procedure TEffectForm.FormCreate(Sender: TObject);
begin

  sSkinProvider1.SkinData.SkinManager := MainForm.sSkinManager1;
  LoadSettings;

end;

procedure TEffectForm.LoadSettings;
var
  SettingsFile: TIniFile;
begin

  SettingsFile := TIniFile.Create(MainForm.FAppDataFolder + '\Settings.ini');
  try
    DeintEnblBtn.Checked := SettingsFile.ReadBool('Effect', 'Deint', False);
    DeintMethodList.ItemIndex := SettingsFile.ReadInteger('Effects', 'Deint2', 0);
    DeintMethodList.Enabled := DeintEnblBtn.Checked;

    CropEnable.Checked := SettingsFile.ReadBool('Effect', 'Crop', False);
    CropWidthEdit.Text := SettingsFile.ReadString('Effect', 'CropW', '0');
    CropHeightEdit.Text := SettingsFile.ReadString('Effect', 'CropH', '0');
    CropXEdit.Text := SettingsFile.ReadString('Effect', 'CropX', '0');
    CropYEdit.Text := SettingsFile.ReadString('Effect', 'CropY', '0');
    CropEnable.OnClick(Self);

    VolumeEnableBtn.Checked := SettingsFile.ReadBool('Effects', 'Vol', False);
    VolumeMencoderEdit.Text := SettingsFile.ReadString('Effects', 'VolM', '0');
    VolumeFFMpegEdit.Text := SettingsFile.ReadString('Effects', 'VolF', '100');
    VolumeEnableBtnClick(Self);

    RotateList.ItemIndex := SettingsFile.ReadInteger('effect', 'rotate', 0);
  finally
    SettingsFile.Free;
  end;

end;

procedure TEffectForm.PreviewBtnClick(Sender: TObject);
var
  FileIndex: Integer;
  FileName: string;
begin

  FileIndex := PreviewList.ItemIndex;

  if FileIndex >= 0 then
  begin

    if FileIndex < MainForm.FileList.Items.Count then
    begin
      FileName := MainForm.FMasterFileInfoList[FileIndex].FilePath;

      with PreviewForm do
      begin
        VideoName := FileName;
        VideoIndex := FileIndex;
        SubIndex := MainForm.FMasterFileInfoList[FileIndex].SubtitleIndex;
      end;

      EffectForm.Enabled := False;
      PreviewForm.FromMainForm := False;
      PreviewForm.Show;
    end;

  end;

end;

procedure TEffectForm.SaveSettings;
var
  SettingsFile: TIniFile;
begin

  SettingsFile := TIniFile.Create(MainForm.FAppDataFolder + '\Settings.ini');
  try
    SettingsFile.WriteBool('Effect', 'Deint', DeintEnblBtn.Checked);
    SettingsFile.WriteInteger('Effects', 'Deint2', DeintMethodList.ItemIndex);

    SettingsFile.WriteBool('Effect', 'Crop', CropEnable.Checked);
    SettingsFile.WriteString('Effect', 'CropW', CropWidthEdit.Text);
    SettingsFile.WriteString('Effect', 'CropH', CropHeightEdit.Text);
    SettingsFile.WriteString('Effect', 'CropX', CropXEdit.Text);
    SettingsFile.WriteString('Effect', 'CropY', CropYEdit.Text);

    SettingsFile.WriteBool('Effects', 'Vol', VolumeEnableBtn.Checked);
    SettingsFile.WriteString('Effects', 'VolM', VolumeMencoderEdit.Text);
    SettingsFile.WriteString('Effects', 'VolF', VolumeFFMpegEdit.Text);

    SettingsFile.WriteInteger('effect', 'rotate', RotateList.ItemIndex);
  finally
    SettingsFile.Free;
  end;

end;

procedure TEffectForm.VolumeEnableBtnClick(Sender: TObject);
begin
  VolumeMencoderEdit.Enabled := VolumeEnableBtn.Checked;
  VolumeFFMpegEdit.Enabled := VolumeEnableBtn.Checked;
end;

end.
