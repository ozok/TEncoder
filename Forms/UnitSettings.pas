{ *
  * Copyright (C) 2011-2016 ozok <ozok26@gmail.com>
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ShellAPI, IniFiles, 
  JvUrlListGrabber, JvUrlGrabbers, JvComponentBase, JvThread, JvDialogs,
  Generics.Collections, Vcl.Samples.Spin, Vcl.Mask, JvExMask, JvSpin;

type
  TFontInfoPair = record
    FontFilePath: string;
    FontName: string;
  end;

  TFontInfoPairList = TList<TFontInfoPair>;

function GetFontResourceInfo(lpszFilename: PChar; var cbBuffer: DWORD; lpBuffer: PChar; dwQueryType: DWORD): DWORD; stdcall; external 'gdi32.dll' name 'GetFontResourceInfoW';

type
  TSettingsForm = class(TForm)
                                   
    ResetBtn: TBitBtn;
    CloseBtn: TBitBtn;
    NumberOfThreadsList: TComboBox;
    ResetThreadBtn: TButton;
    LangIdList: TComboBox;
    AutoScaleList: TComboBox;
    sLabel1: TLabel;
    SubposBar: TTrackBar;
    SubPosEdit: TEdit;
    CheckUpdatesChckBtn: TCheckBox;
    ThreadChkBtn: TCheckBox;
    ClearTempFolderBtn: TBitBtn;
    sLabel2: TLabel;
    GeneralPanel: TPanel;
    SubtitlePanel: TPanel;
    FontDialog1: TFontDialog;
    EncodingPanel: TPanel;
    PostEncodeActionList: TComboBox;
    FontList: TComboBox;
    DeleteUnfinBtn: TCheckBox;
    x264Btn: TCheckBox;
    FolderStructBtn: TCheckBox;
    SettingsList: TPageControl;
    sTabSheet1: TTabSheet;
    sTabSheet2: TTabSheet;
    Encoding: TTabSheet;
    DefScaleEdit: TJvSpinEdit;
    CopyDateBtn: TCheckBox;
    DontTrimBtn: TCheckBox;
    sTabSheet3: TTabSheet;
    PreferedFormatEdit: TEdit;
    DashVideoBtn: TCheckBox;
    ProcessCountEdit: TEdit;
    ProcessCountBar: TTrackBar;
    PlaySoundBtn: TCheckBox;
    SubSSABtn: TCheckBox;
    DontDoubleDownloadBtn: TCheckBox;
    DontPreviewImgBtn: TCheckBox;
    OverwriteList: TComboBox;
    DefaultAudioLangEdit: TEdit;
    DefaultSubLangEdit: TEdit;
    CheckYoutubeDlUpdateBtn: TCheckBox;
    DownloaderSpeedLimitEdit: TJvSpinEdit;
    SubLangList: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ResetThreadBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SubposBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SubposBarChange(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure ClearTempFolderBtnClick(Sender: TObject);
    procedure sLabel2Click(Sender: TObject);
    procedure PostEncodeActionListChange(Sender: TObject);
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

  SubPosEdit.Text := FloatToStr(SubposBar.Position);

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

      WriteBool('Options', 'Update', CheckUpdatesChckBtn.Checked);

      WriteBool('Options', 'UseThreads', ThreadChkBtn.Checked);

      WriteBool('Options', 'Unfinished', DeleteUnfinBtn.Checked);
      WriteBool('Options', 'FolderStruct', FolderStructBtn.Checked);
      WriteBool('Options', 'copydate', CopyDateBtn.Checked);
      WriteBool('options', 'trim', DontTrimBtn.Checked);
      WriteBool('options', 'playsound', PlaySoundBtn.Checked);

      WriteString('options', 'downloadformat', PreferedFormatEdit.Text);
      WriteInteger('options', 'downloadcount', ProcessCountBar.Position);
      WriteBool('options', 'doubledownload', DontDoubleDownloadBtn.Checked);
      WriteBool('options', 'noimg', DontPreviewImgBtn.Checked);
      WriteBool('options', 'ytdlupdate', CheckYoutubeDlUpdateBtn.Checked);
      WriteString('options', 'dlspeedlmt', DownloaderSpeedLimitEdit.Text);
      WriteInteger('Options', 'SubLang', SubLangList.ItemIndex);

      WriteString('options', 'defaud', DefaultAudioLangEdit.Text);
      WriteString('options', 'defsub', DefaultSubLangEdit.Text);
    end;

  finally
    OptionFile.Free;
    DontTrimBtnClick(Self);
  end;

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

      x264Btn.Checked := ReadBool('Options', 'x264', True);
      // LangList.ItemIndex := ReadInteger('Options', 'Lang', 0);

      CheckUpdatesChckBtn.Checked := ReadBool('Options', 'Update', True);
      ThreadChkBtn.Checked := ReadBool('Options', 'UseThreads', False);
      DeleteUnfinBtn.Checked := ReadBool('Options', 'Unfinished', True);
      FolderStructBtn.Checked := ReadBool('Options', 'FolderStruct', False);
      CopyDateBtn.Checked := ReadBool('Options', 'copydate', False);
      DontTrimBtn.Checked := ReadBool('options', 'trim', True);
      PlaySoundBtn.Checked := ReadBool('options', 'playsound', True);

      PreferedFormatEdit.Text := ReadString('options', 'downloadformat', 'mp4, 1920x1080, DASH, video');
      ProcessCountBar.Position := ReadInteger('options', 'downloadcount', 1);
      DontDoubleDownloadBtn.Checked := ReadBool('options', 'doubledownload', True);
      DontPreviewImgBtn.Checked := ReadBool('options', 'noimg', False);
      CheckYoutubeDlUpdateBtn.Checked := ReadBool('options', 'ytdlupdate', False);
      DownloaderSpeedLimitEdit.Text := ReadString('options', 'dlspeedlmt', '0');
      SubLangList.ItemIndex := ReadInteger('Options', 'SubLang', 39);

      DefaultAudioLangEdit.Text := ReadString('options', 'defaud', 'english;eng;en');
      DefaultSubLangEdit.Text := ReadString('options', 'defsub', 'english;eng;en');
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

// todo: update this code
  if ID_YES = Application.MessageBox('Reset all settings to their default values?', 'Reset', MB_ICONQUESTION or MB_YESNO) then
  begin
    ResetThreadBtn.OnClick(Self);
    ThreadChkBtn.Checked := False;

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