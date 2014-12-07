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
unit UnitProfileEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sSkinProvider, sComboBox, IniFiles,
  Vcl.Mask, JvExMask, JvSpin, sEdit, StrUtils, sSpinEdit;

type
  TProfileForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    CloseBtn: TsBitBtn;
    ProfileList: TsComboBox;
    SaveProfileBtn: TsBitBtn;
    NewProfileBtn: TsBitBtn;
    ResetBtn: TsBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    VCodecList: TsComboBox;
    VBitrateList: TsComboBox;
    VSizeList: TsComboBox;
    VASRList: TsComboBox;
    VFPSList: TsComboBox;
    ACodecList: TsComboBox;
    ABitrateList: TsComboBox;
    ASampleRateList: TsComboBox;
    AChanList: TsComboBox;
    RefreshBtn: TsBitBtn;
    EncoderList: TsComboBox;
    DeleteBtn: TsBitBtn;
    WidthEdit: TsSpinEdit;
    HeightEdit: TsSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    LContainerList: TsComboBox;
    CustomVideoEdit: TsEdit;
    CustomAudioEdit: TsEdit;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RefreshBtnClick(Sender: TObject);
    procedure NewProfileBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveProfileBtnClick(Sender: TObject);
    procedure VCodecListChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ProfileListChange(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure WidthEditChange(Sender: TObject);
    procedure HeightEditChange(Sender: TObject);
    procedure VideoArgsEditChange(Sender: TObject);
    procedure AudioArgsEditChange(Sender: TObject);

    // checks if given str is valid file name
    function IsValidFileName(const FileName: string): Boolean;
    procedure CustomVideoEditChange(Sender: TObject);
    procedure CustomAudioEditChange(Sender: TObject);
  private
    { Private declarations }

    procedure ApplyProfile(ProfileName: string);
  public
    { Public declarations }
  end;

var
  ProfileForm: TProfileForm;

implementation

uses UnitMain, UnitAdvancedOptions;

{$R *.dfm}

procedure TProfileForm.ApplyProfile(ProfileName: string);
const
  UserStr = '[User]';
var
  ProfileFilePath: string;
  ProfileFile: TIniFile;
begin

  if Copy(ProfileList.Text, 1, Length(UserStr)) = UserStr then
  begin
    // user created profile
    ProfileFilePath := MainForm.FAppDataFolder + ProfileList.Text + '.pdo';
  end
  else
  begin
    // edited profile
    ProfileFilePath := ExtractFileDir(Application.ExeName) + '\Profiles\' + ProfileList.Text + '.pdo';
  end;

  if FileExists(ProfileFilePath) then
  begin

    ProfileFile := TIniFile.Create(ProfileFilePath);
    try

      with ProfileFile do
      begin

        // video
        VCodecList.ItemIndex := ReadInteger('Main', 'VCodec', 2);
        VBitrateList.Text := ReadString('Main', 'VBitrate', '1024');
        VSizeList.Text := ReplaceText(ReadString('Main', 'VideoSize', '512x384'), '(PAL)', '');
        WidthEdit.Text := ReplaceText(ReadString('Main', 'Width', '512'), '(PAL)', '');
        HeightEdit.Text := ReplaceText(ReadString('Main', 'Height', '320'), '(PAL)', '');
        VFPSList.Text := ReadString('Main', 'FPS', '25');
        VASRList.ItemIndex := ReadInteger('Main', 'VAR', 1);

        // audio
        ACodecList.ItemIndex := ReadInteger('Main', 'ACodec', 1);
        ABitrateList.Text := ReadString('Main', 'ABitrate', '128');
        ASampleRateList.ItemIndex := ReadInteger('Main', 'ASR', 5);
        AChanList.ItemIndex := ReadInteger('Main', 'AChan', 1);

        EncoderList.ItemIndex := ReadInteger('Main', 'Encoder', 1);
        LContainerList.ItemIndex := ReadInteger('Main', 'Container', 2);

        // custom args
        CustomAudioEdit.Text := ReadString('Main', 'CustomAudio', '');
        CustomVideoEdit.Text := ReadString('Main', 'CustomVideo', '');

      end;

    finally
      ProfileFile.Free;
    end;

  end
  else
    Application.MessageBox('Cannot find profile file!', 'Error', MB_ICONERROR);

end;

procedure TProfileForm.CloseBtnClick(Sender: TObject);
begin

  ProfileForm.Close;

end;

procedure TProfileForm.CustomAudioEditChange(Sender: TObject);
begin
  SaveProfileBtn.Enabled := True;
end;

procedure TProfileForm.CustomVideoEditChange(Sender: TObject);
begin
  SaveProfileBtn.Enabled := True;
end;

procedure TProfileForm.DeleteBtnClick(Sender: TObject);
const
  USER_Pref = '[User]';
var
  ProfileNameToDelete: string;
  ProfileIndex: integer;
begin
  if USER_Pref = Copy(ProfileList.Text, 1, Length(USER_Pref)) then
  begin
    // user created profiles
    ProfileNameToDelete := MainForm.FAppDataFolder + '\' + ProfileList.Text + '.pdo';
  end
  else
  begin
    // normal profiles
    ProfileNameToDelete := ExtractFileDir(Application.ExeName) + '\Profiles\' + ProfileList.Text + '.pdo';
  end;

  if FileExists(ProfileNameToDelete) then
  begin
    try
      if not DeleteFile(ProfileNameToDelete) then
      begin
        Application.MessageBox('Selected profile somehow does not exist!', 'Error', MB_ICONERROR);
      end;
    finally
      ProfileIndex := ProfileForm.ProfileList.ItemIndex;
      ProfileForm.ProfileList.Items.Clear;
      MainForm.LoadProfiles(ProfileForm.ProfileList);
      MainForm.LoadProfiles(MainForm.ProfileList);

      if ProfileIndex < ProfileForm.ProfileList.Items.Count then
      begin
        MainForm.ProfileList.ItemIndex := ProfileIndex;
        ProfileForm.ProfileList.ItemIndex := ProfileIndex;
      end
      else
      begin
        MainForm.ProfileList.ItemIndex := ProfileIndex - 1;
        ProfileForm.ProfileList.ItemIndex := ProfileIndex - 1;
      end;
      SaveProfileBtn.Enabled := False;
    end;
  end
  else
  begin
    Application.MessageBox('Selected profile somehow does not exist!', 'Error', MB_ICONERROR);
  end;
end;

procedure TProfileForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  SaveProfileBtn.Enabled := False;
  MainForm.Enabled := True;

end;

procedure TProfileForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  if SaveProfileBtn.Enabled then
  begin

    if ID_YES = Application.MessageBox('You changed some values. Close anyway?', 'Confirm', MB_ICONQUESTION or MB_YESNO) then
    begin
      CanClose := True;
    end
    else
    begin
      CanClose := False;
    end;

  end
  else
  begin
    CanClose := True;
  end;

end;

procedure TProfileForm.FormCreate(Sender: TObject);
begin

  MainForm.LoadProfiles(ProfileList);

end;

procedure TProfileForm.FormShow(Sender: TObject);
begin
  if MainForm.ProfileList.ItemIndex < ProfileList.Items.Count then
  begin
    ProfileList.ItemIndex := MainForm.ProfileList.ItemIndex;

    ProfileList.OnChange(Self);
    SaveProfileBtn.Enabled := False;
  end;

end;

procedure TProfileForm.HeightEditChange(Sender: TObject);
begin
  SaveProfileBtn.Enabled := True;
end;

function TProfileForm.IsValidFileName(const FileName: string): Boolean;
const
  InvalidCharacters: set of char = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
var
  c: char;
begin
  // this function is copied from about.deplhi.com
  Result := FileName <> '';

  if Result then
  begin
    for c in FileName do
    begin
      Result := NOT(c in InvalidCharacters);
      if NOT Result then
        Break;
    end;
  end;
end;

procedure TProfileForm.NewProfileBtnClick(Sender: TObject);
var
  NewProfileName: string;
begin

  NewProfileName := InputBox('Please enter a name for new profile', 'Name', '');

  if Length(NewProfileName) > 0 then
  begin

    if IsValidFileName(NewProfileName) then
    begin
      ProfileList.Items.Add('[User] ' + NewProfileName);
      SaveProfileBtn.Enabled := True;
      ProfileList.ItemIndex := ProfileList.Items.Count - 1;
    end
    else
    begin
      Application.MessageBox('Given profile name is not valid!', 'Error', MB_ICONERROR);
    end;

  end;

end;

procedure TProfileForm.ProfileListChange(Sender: TObject);
var
  ProfileText: string;
begin

  // apply selected profile

  ProfileText := ProfileList.Text;

  if Length(ProfileText) > 0 then
  begin
    ApplyProfile(ProfileText);
  end;

end;

procedure TProfileForm.RefreshBtnClick(Sender: TObject);
var
  LastIndex: Integer;
begin

  LastIndex := ProfileList.ItemIndex;

  ProfileList.Items.Clear;
  MainForm.LoadProfiles(ProfileList);
  MainForm.LoadProfiles(MainForm.ProfileList);

  if LastIndex < ProfileList.Items.Count then
  begin
    ProfileList.ItemIndex := LastIndex;
  end;

end;

procedure TProfileForm.ResetBtnClick(Sender: TObject);
begin

  VCodecList.ItemIndex := 2;
  VBitrateList.ItemIndex := 6;
  VSizeList.ItemIndex := 6;
  VFPSList.ItemIndex := 0;
  VASRList.ItemIndex := 1;

  ACodecList.ItemIndex := 2;
  ABitrateList.ItemIndex := 7;
  ASampleRateList.ItemIndex := 5;
  AChanList.ItemIndex := 1;

  EncoderList.ItemIndex := 0;

end;

procedure TProfileForm.SaveProfileBtnClick(Sender: TObject);
const
  UserStr = '[User]';
var
  ProfileNameToSave: string;
  ProfileFile: TIniFile;
  ProfileIndex: integer;
begin
  if Length(ProfileList.Text) < 1 then
  begin
    Application.MessageBox('Please select an existing profile or create a new one using "New" button.', 'Error', MB_ICONERROR);
    Exit;
  end;

  if Copy(ProfileList.Text, 1, Length(UserStr)) = UserStr then
  begin
    // user created profile
    ProfileNameToSave := MainForm.FAppDataFolder + ProfileList.Text + '.pdo';
  end
  else
  begin
    // edited profile
    ProfileNameToSave := ExtractFileDir(Application.ExeName) + '\Profiles\' + ProfileList.Text + '.pdo';
  end;

  ProfileFile := TIniFile.Create(ProfileNameToSave);
  try

    with ProfileFile do
    begin

      // video
      WriteInteger('Main', 'VCodec', VCodecList.ItemIndex);
      WriteString('Main', 'VBitrate', VBitrateList.Text);
      WriteString('Main', 'VideoSize', VSizeList.Text);
      WriteString('Main', 'Width', WidthEdit.Text);
      WriteString('Main', 'Height', HeightEdit.Text);
      WriteString('Main', 'FPS', VFPSList.Text);
      WriteInteger('Main', 'VAR', VASRList.ItemIndex);

      // audio
      WriteInteger('Main', 'ACodec', ACodecList.ItemIndex);
      WriteString('Main', 'ABitrate', ABitrateList.Text);
      WriteInteger('Main', 'ASR', ASampleRateList.ItemIndex);
      WriteInteger('Main', 'AChan', AChanList.ItemIndex);

      WriteInteger('Main', 'Encoder', EncoderList.ItemIndex);
      WriteInteger('Main', 'Container', LContainerList.ItemIndex);

      // custom args
      WriteString('Main', 'CustomAudio', CustomAudioEdit.Text);
      WriteString('Main', 'CustomVideo', CustomVideoEdit.Text);
    end;

  finally
    ProfileFile.Free;

    ProfileIndex := ProfileList.ItemIndex;
    ProfileForm.ProfileList.Items.Clear;
    MainForm.LoadProfiles(ProfileForm.ProfileList);
    MainForm.LoadProfiles(MainForm.ProfileList);
    ProfileList.ItemIndex := ProfileIndex;
    MainForm.ProfileList.ItemIndex := ProfileIndex;

    SaveProfileBtn.Enabled := False;
  end;

end;

procedure TProfileForm.AudioArgsEditChange(Sender: TObject);
begin
  SaveProfileBtn.Enabled := True;
end;

procedure TProfileForm.VCodecListChange(Sender: TObject);
begin

  SaveProfileBtn.Enabled := True;

end;

procedure TProfileForm.VideoArgsEditChange(Sender: TObject);
begin
  SaveProfileBtn.Enabled := True;
end;

procedure TProfileForm.WidthEditChange(Sender: TObject);
begin
  SaveProfileBtn.Enabled := True;
end;

end.
