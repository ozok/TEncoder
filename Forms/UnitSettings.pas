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
unit UnitSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinProvider, StdCtrls, Buttons, sBitBtn, ExtCtrls, sPanel,
  ComCtrls, ShellAPI,
  sComboBox, sEdit, sButton, sCheckBox, IniFiles, sLabel, sGauge,
  JvUrlListGrabber, JvUrlGrabbers, JvComponentBase, JvThread, JvDialogs,
  sListBox, sPageControl, sTrackBar, Generics.Collections, sSpinEdit;

type
  TFontInfoPair = record
    FontFilePath: string;
    FontName: string;
  end;

  TFontInfoPairList = TList<TFontInfoPair>;

function GetFontResourceInfo(lpszFilename: PChar; var cbBuffer: DWORD; lpBuffer: PChar; dwQueryType: DWORD): DWORD; stdcall; external 'gdi32.dll' name 'GetFontResourceInfoW';

type
  TSettingsForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    ResetBtn: TsBitBtn;
    CloseBtn: TsBitBtn;
    NumberOfThreadsList: TsComboBox;
    ResetThreadBtn: TsButton;
    LangIdList: TsComboBox;
    AutoScaleList: TsComboBox;
    sLabel1: TsLabel;
    SubposBar: TsTrackBar;
    SubPosEdit: TsEdit;
    CheckUpdatesChckBtn: TsCheckBox;
    ThreadChkBtn: TsCheckBox;
    ClearTempFolderBtn: TsBitBtn;
    sLabel2: TsLabel;
    GeneralPanel: TsPanel;
    SubtitlePanel: TsPanel;
    FontDialog1: TFontDialog;
    SkinList: TsComboBox;
    SaturationBar: TsTrackBar;
    Label1: TLabel;
    SaturationLabel: TLabel;
    EncodingPanel: TsPanel;
    PostEncodeActionList: TsComboBox;
    SkinPanel: TsPanel;
    HueTrackBar: TsTrackBar;
    sLabel3: TsLabel;
    HueLabel: TsLabel;
    SkinEnableBtn: TsCheckBox;
    FontList: TsComboBox;
    DeleteUnfinBtn: TsCheckBox;
    x264Btn: TsCheckBox;
    FolderStructBtn: TsCheckBox;
    SettingsList: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    Encoding: TsTabSheet;
    sTabSheet4: TsTabSheet;
    DefScaleEdit: TsSpinEdit;
    CopyDateBtn: TsCheckBox;
    DontTrimBtn: TsCheckBox;
    sTabSheet3: TsTabSheet;
    PreferedFormatEdit: TsEdit;
    DashVideoBtn: TsCheckBox;
    ProcessCountEdit: TsEdit;
    ProcessCountBar: TsTrackBar;
    PlaySoundBtn: TsCheckBox;
    SubSSABtn: TsCheckBox;
    DontDoubleDownloadBtn: TsCheckBox;
    DontPreviewImgBtn: TsCheckBox;
    OverwriteList: TsComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ResetThreadBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SubposBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SubposBarChange(Sender: TObject);
    procedure SaturationBarChange(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure ClearTempFolderBtnClick(Sender: TObject);
    procedure sLabel2Click(Sender: TObject);
    procedure SkinListChange(Sender: TObject);
    procedure PostEncodeActionListChange(Sender: TObject);
    procedure HueTrackBarChange(Sender: TObject);
    procedure SkinEnableBtnClick(Sender: TObject);
    procedure DontTrimBtnClick(Sender: TObject);
    procedure ProcessCountBarChange(Sender: TObject);
  private
    { Private declarations }

    procedure LoadOptions();
    procedure SaveOptions();

    // load font info pairs
    procedure LoadFonts;
  public
    { Public declarations }
    FFontInfos: TFontInfoPairList;
  end;

var
  SettingsForm: TSettingsForm;

implementation

uses UnitMain, UnitAbout, UnitAdvancedOptions;

{$R *.dfm}

procedure TSettingsForm.ClearTempFolderBtnClick(Sender: TObject);
begin

  MainForm.ClearTempFolder;

end;

procedure TSettingsForm.CloseBtnClick(Sender: TObject);
begin

  SettingsForm.Close;

end;

procedure TSettingsForm.DontTrimBtnClick(Sender: TObject);
begin
  MainForm.rim1.Enabled := not DontTrimBtn.Checked;
  MainForm.T2.Enabled := not DontTrimBtn.Checked;
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptions;
  if not AdvancedOptionsForm.Visible then
  begin
    MainForm.Enabled := True;
  end;
  MainForm.UpdateSummary;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  i: Integer;
  ProcessorCount: Integer;
begin
  ProcessorCount := MainForm.Info.CPU.ProcessorCount;

  if ProcessorCount <= 8 then
  begin
    NumberOfThreadsList.ItemIndex := ProcessorCount - 1;
  end
  else
  begin
    NumberOfThreadsList.ItemIndex := 7;
  end;

  for i := 0 to MainForm.sSkinManager1.InternalSkins.Count - 1 do
  begin
    SkinList.Items.Add(MainForm.sSkinManager1.InternalSkins.Items[i].Name);
  end;
  SkinList.ItemIndex := 12;

  SubPosEdit.Text := FloatToStr(SubposBar.Position);

  sSkinProvider1.SkinData.SkinManager := MainForm.sSkinManager1;

  FFontInfos := TFontInfoPairList.Create;
  LoadFonts;

  // get settings
  LoadOptions;

  SettingsList.ActivePAgeIndex := 0;
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin

  SaveOptions;
  FFontInfos.Free;

end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  PostEncodeActionList.ItemIndex := MainForm.PostEncodeList.ItemIndex;
end;

procedure TSettingsForm.HueTrackBarChange(Sender: TObject);
begin

  MainForm.sSkinManager1.HueOffset := HueTrackBar.Position;
  HueLabel.Caption := IntToStr(HueTrackBar.Position);

end;

procedure TSettingsForm.SaturationBarChange(Sender: TObject);
begin

  MainForm.sSkinManager1.Saturation := SaturationBar.Position;
  SaturationLabel.Caption := IntToStr(SaturationBar.Position);

end;

procedure TSettingsForm.SaveBtnClick(Sender: TObject);
begin

  SaveOptions;

end;

procedure TSettingsForm.SaveOptions;
var
  OptionFile: TIniFile;
begin

  OptionFile := TIniFile.Create(MainForm.FAppDataFolder + 'Settings.ini');
  try

    with OptionFile do
    begin
      WriteInteger('Options', 'ProcessNumber', NumberOfThreadsList.ItemIndex);

      WriteInteger('Options', 'LangID', LangIdList.ItemIndex);

      WriteInteger('Options', 'FontIndex', FontList.ItemIndex);
      WriteInteger('Options', 'Autoscale', AutoScaleList.ItemIndex);
      WriteString('Options', 'DefScale', DefScaleEdit.Text);
      WriteInteger('Options', 'SubPos', SubposBar.Position);
      WriteBool('Options', 'SubSSA', SubSSABtn.Checked);

      WriteBool('Options', 'x264', x264Btn.Checked);
      // WriteString('Options', 'LangStr', LangList.Text);
      // WriteInteger('Options', 'Lang', LangList.ItemIndex);

      WriteInteger('Options', 'Sat', SaturationBar.Position);
      WriteInteger('Options', 'Hue', HueTrackBar.Position);

      WriteInteger('Options', 'Skins2', SkinList.ItemIndex);

      WriteBool('Options', 'Update', CheckUpdatesChckBtn.Checked);

      WriteBool('Options', 'UseThreads', ThreadChkBtn.Checked);
      WriteInteger('Options', 'PostEncode', PostEncodeActionList.ItemIndex);

      WriteBool('Options', 'Skinning2', SkinEnableBtn.Checked);

      WriteBool('Options', 'Unfinished', DeleteUnfinBtn.Checked);
      WriteBool('Options', 'FolderStruct', FolderStructBtn.Checked);
      WriteBool('Options', 'copydate', CopyDateBtn.Checked);
      WriteBool('options', 'trim', DontTrimBtn.Checked);
      WriteBool('options', 'playsound', PlaySoundBtn.Checked);

      WriteString('options', 'downloadformat', PreferedFormatEdit.Text);
      WriteInteger('options', 'downloadcount', ProcessCountBar.Position);
      WriteBool('options', 'doubledownload', DontDoubleDownloadBtn.Checked);
      WriteBool('options', 'noimg', DontPreviewImgBtn.Checked);
    end;

  finally
    OptionFile.Free;
    DontTrimBtnClick(Self);
  end;

end;

procedure TSettingsForm.SkinEnableBtnClick(Sender: TObject);
begin

  if SkinEnableBtn.Checked then
  begin
    MainForm.sSkinManager1.Active := False;
  end
  else
  begin
    MainForm.sSkinManager1.Active := True;
    MainForm.sSkinManager1.SkinName := SkinList.Text;
    HueTrackBarChange(Self);
    SaturationBarChange(Self);
  end;

end;

procedure TSettingsForm.SkinListChange(Sender: TObject);
begin

  with MainForm do
  begin
    sSkinManager1.SkinName := sSkinManager1.InternalSkins.Items[SkinList.ItemIndex].Name;
    sSkinManager1.RepaintForms(False);
  end;

  SaturationBar.OnChange(Self);
  HueTrackBar.OnChange(Self);
  SendMessage(SaturationBar.Handle, CM_RecreateWnd, 0, 0);
  SendMessage(HueTrackBar.Handle, CM_RecreateWnd, 0, 0);

end;

procedure TSettingsForm.LoadFonts;
const
  QFR_DESCRIPTION = 1;
var
  Search: TSearchRec;
  ext: string;
  LFF: TFontInfoPair;
  cbBuffer: DWORD;
  lpBuffer: array [0 .. MAX_PATH - 1] of Char;
  I: Integer;
begin
  if (FindFirst(MainForm.Info.Folders.Fonts + '\*.*', faAnyFile, Search) = 0) then
  Begin
    repeat
      Application.ProcessMessages;

      if (Search.Name <> '.') and (Search.Name <> '..') then
      begin
        ext := LowerCase(ExtractFileExt(Search.Name));
        if ext = '.ttf' then
        begin
          LFF.FontFilePath := MainForm.Info.Folders.Fonts + '\' + Search.Name;

          cbBuffer := SizeOf(lpBuffer);
          GetFontResourceInfo(PWideChar(LFF.FontFilePath), cbBuffer, lpBuffer, QFR_DESCRIPTION);
          LFF.FontName := lpBuffer;

          FFontInfos.Add(LFF);
        end;
      end;

    until (FindNext(Search) <> 0);
    FindClose(Search);
  end;

  for I := 0 to FFontInfos.Count - 1 do
  begin
    FontList.Items.Add(FFontInfos[i].FontName);
  end;
  if FontList.Items.Count > 0 then
  begin
    FontList.ItemIndex := 0;
  end;
end;

procedure TSettingsForm.LoadOptions;
var
  OptionFile: TIniFile;
  NumberOfCores: Integer;
begin

  OptionFile := TIniFile.Create(MainForm.FAppDataFolder + 'Settings.ini');
  try

    NumberOfCores := MainForm.Info.CPU.ProcessorCount;
    if NumberOfCores > Length(MainForm.FEncoders) then
    begin
      NumberOfCores := Length(MainForm.FEncoders);
    end
    else if NumberOfCores < 1 then
    begin
      NumberOfCores := 1;
    end;

    with OptionFile do
    begin
      NumberOfThreadsList.ItemIndex := ReadInteger('Options', 'ProcessNumber', NumberOfCores - 1);

      LangIdList.ItemIndex := ReadInteger('Options', 'LangID', 0);

      FontList.ItemIndex := ReadInteger('Options', 'FontIndex', 0);

      AutoScaleList.ItemIndex := ReadInteger('Options', 'Autoscale', 3);
      DefScaleEdit.Text := ReadString('Options', 'DefScale', '15');
      SubposBar.Position := ReadInteger('Options', 'SubPos', 100);
      SubSSABtn.Checked := ReadBool('Options', 'SubSSA', True);

      SaturationBar.Position := ReadInteger('Options', 'Sat', 0);
      SaturationLabel.Caption := IntToStr(SaturationBar.Position);
      HueTrackBar.Position := ReadInteger('Options', 'Hue', 0);
      HueLabel.Caption := IntToStr(HueTrackBar.Position);
      x264Btn.Checked := ReadBool('Options', 'x264', True);
      // LangList.ItemIndex := ReadInteger('Options', 'Lang', 0);

      if ReadInteger('Options', 'Skins2', 92) > MainForm.sSkinManager1.InternalSkins.Count then
      begin
        SkinList.ItemIndex := 92;
      end
      else
      begin
        SkinList.ItemIndex := ReadInteger('Options', 'Skins2', 92);
      end;
      SkinEnableBtn.Checked := ReadBool('Options', 'Skinning2', True);

      CheckUpdatesChckBtn.Checked := ReadBool('Options', 'Update', True);
      ThreadChkBtn.Checked := ReadBool('Options', 'UseThreads', False);
      PostEncodeActionList.ItemIndex := ReadInteger('Options', 'PostEncode', 0);
      DeleteUnfinBtn.Checked := ReadBool('Options', 'Unfinished', True);
      FolderStructBtn.Checked := ReadBool('Options', 'FolderStruct', False);
      CopyDateBtn.Checked := ReadBool('Options', 'copydate', False);
      DontTrimBtn.Checked := ReadBool('options', 'trim', True);
      PlaySoundBtn.Checked := ReadBool('options', 'playsound', True);

      PreferedFormatEdit.Text := ReadString('options', 'downloadformat', 'mp4, 1920x1080, DASH, video');
      ProcessCountBar.Position := ReadInteger('options', 'downloadcount', 1);
      DontDoubleDownloadBtn.Checked := ReadBool('options', 'doubledownload', True);
      DontPreviewImgBtn.Checked := ReadBool('options', 'noimg', False);
    end;

  finally
    ProcessCountBarChange(Self);
    OptionFile.Free
  end;

end;

procedure TSettingsForm.PostEncodeActionListChange(Sender: TObject);
begin

  MainForm.PostEncodeList.ItemIndex := PostEncodeActionList.ItemIndex;

end;

procedure TSettingsForm.ProcessCountBarChange(Sender: TObject);
begin
  ProcessCountEdit.Text := FloatToStr(ProcessCountBar.Position);

end;

procedure TSettingsForm.ResetBtnClick(Sender: TObject);
begin

  if ID_YES = Application.MessageBox('Reset all settings to their default values?', 'Reset', MB_ICONQUESTION or MB_YESNO) then
  begin
    ResetThreadBtn.OnClick(Self);
    ThreadChkBtn.Checked := False;
    SkinList.ItemIndex := 6;
    SkinList.OnChange(Self);

    SaturationBar.Position := 0;
    SaturationLabel.Caption := '0';
    HueTrackBar.Position := 0;
    HueLabel.Caption := '0';
    MainForm.sSkinManager1.Saturation := 0;
    MainForm.sSkinManager1.HueOffset := 0;

    CheckUpdatesChckBtn.Checked := True;

    LangIdList.ItemIndex := 0;
    FontList.ItemIndex := 0;
    DefScaleEdit.Text := '15';
    SubposBar.Position := 100;
    SubPosEdit.Text := '100';

    PostEncodeActionList.ItemIndex := 0;

    SaveOptions();
  end;

end;

procedure TSettingsForm.ResetThreadBtnClick(Sender: TObject);
var
  NumOfCPU: Integer;
begin

  NumOfCPU := MainForm.Info.CPU.ProcessorCount;
  NumberOfThreadsList.ItemIndex := NumOfCPU - 1;
  NumberOfThreadsList.Refresh;

end;

procedure TSettingsForm.sLabel2Click(Sender: TObject);
begin

  Application.MessageBox('If you select this, TEncoder will try to use your PC''s all CPU power.', 'Info', MB_ICONINFORMATION);

end;

procedure TSettingsForm.SubposBarChange(Sender: TObject);
begin

  SubPosEdit.Text := FloatToStr(SubposBar.Position);

end;

procedure TSettingsForm.SubposBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin

  NewTractBarPosition := Round((X / SubposBar.ClientWidth) * MaxInt);

  SubposBar.Position := NewTractBarPosition;

  SubPosEdit.Text := FloatToStr(SubposBar.Position);

end;

end.
