{ *
  * Copyright (C) 2011-2016 ozok <ozok26@gmail.com>
  *
  * This file is part of TEncoder.
  *
  * TEncoder is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License.
  * 
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
unit UnitPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvComCtrls, ExtCtrls, StdCtrls, Buttons,
  JvComponentBase, JvCreateProcess, JvExStdCtrls, JvListBox, Menus,
  IniFiles, UnitPlayer, Vcl.Samples.Gauges;

type
  TPreviewForm = class(TForm)
    DisplayPanel: TPanel;
    PlayBtn: TBitBtn;
    PauseBtn: TBitBtn;
    StopBtn: TBitBtn;
    BackBtn: TBitBtn;
    ForwardBtn: TBitBtn;
    PositionTimer: TTimer;
    PositionBar: TGauge;
    VolumeBar: TGauge;
    Image1: TImage;
    FullscreenBtn: TBitBtn;
    VolumeDownBtn: TBitBtn;
    VolumeUpBtn: TBitBtn;
    DisplayMenu: TPopupMenu;
    PausePlay1: TMenuItem;
    Stop1: TMenuItem;
    Fullscreen1: TMenuItem;
    N10secforward1: TMenuItem;
    N10secBackward1: TMenuItem;
    Close1: TMenuItem;
    HideCursorTimer: TTimer;
    SubDelayUpBtn: TBitBtn;
    SubDelayDownBtn: TBitBtn;
    PositionEdit: TEdit;
    AudioDelayDownBtn: TBitBtn;
    AudioDelayUpBtn: TBitBtn;
    SaveDelaysBtn: TBitBtn;
    DelaysEdit: TEdit;
    ResetBtn: TBitBtn;
    MusicImage: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure ForwardBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure PositionBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PositionTimerTimer(Sender: TObject);
    procedure VolumeBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure DisplayPanelDblClick(Sender: TObject);
    procedure FullscreenBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VolumeUpBtnClick(Sender: TObject);
    procedure VolumeDownBtnClick(Sender: TObject);
    procedure HideCursorTimerTimer(Sender: TObject);
    procedure DisplayPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure SubDelayUpBtnClick(Sender: TObject);
    procedure SubDelayDownBtnClick(Sender: TObject);
    procedure PositionBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure AudioDelayUpBtnClick(Sender: TObject);
    procedure AudioDelayDownBtnClick(Sender: TObject);
    procedure SaveDelaysBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
  private
    { Private declarations }
    function GetNewDimentions(var VWidth: string): string;
  public
    { Public declarations }
    // will be received from main form
    VideoIndex, SubIndex: Integer;
    VideoName: string;
    // if true from mainform otherwise from effects
    FromMainForm: Boolean;
    // in order to resize preview window
    NewWidth, NewHeight: string;
    // subtitle delay value
    SubDelayValue: Extended;
    AudioDelayValue: Extended;
    // audio only
    AudioOnly: Boolean;
    AudioStream: string;

    // mplayer
    Player: TPlayer;
  end;

var
  PreviewForm: TPreviewForm;
  MouseOnPosBar: Boolean;
  tmp: TStringList;
  MplayerPosition: string;
  MplayerOutput: string;
  FormHeight, FormWidth, FormTop, FormLeft: Integer;
  PanelWidth, PanelHeight: Integer;
  CursorTime: Integer; // max 20 (20X100=2000)

implementation

uses
  UnitMain, UnitEffects, UnitSettings, UnitLogs, UnitAdvancedOptions;

{$R *.dfm}

procedure TPreviewForm.AudioDelayDownBtnClick(Sender: TObject);
begin

  if Player.AudioDelayUp(1) then
  begin
    AudioDelayValue := AudioDelayValue + 0.1;
    DelaysEdit.Text := FloatToStr(SubDelayValue) + '/' + FloatToStr(AudioDelayValue);
  end;

end;

procedure TPreviewForm.AudioDelayUpBtnClick(Sender: TObject);
begin

  if Player.AudioDelayDown(1) then
  begin
    AudioDelayValue := AudioDelayValue - 0.1;
    DelaysEdit.Text := FloatToStr(SubDelayValue) + '/' + FloatToStr(AudioDelayValue);
  end;

end;

procedure TPreviewForm.BackBtnClick(Sender: TObject);
begin

  Player.SeekBack(10);

end;

procedure TPreviewForm.CloseBtnClick(Sender: TObject);
begin

  LogForm.MPlayerLogList.Lines.AddStrings(tmp);
  PreviewForm.Close;

end;

procedure TPreviewForm.DisplayPanelDblClick(Sender: TObject);
begin

  if AudioOnly then
    Exit;

  if Player.MplayerStatus <> psStopped then
  begin
    if PreviewForm.BorderStyle = bsSizeable then
    begin

      with PreviewForm do
      begin
        // store this values to use them later
        FormHeight := Height;
        FormWidth := Width;
        FormTop := Top;
        FormLeft := Left;
        PanelWidth := DisplayPanel.Width;
        PanelHeight := DisplayPanel.Height;

        // full screen
        BorderStyle := bsNone;
        Width := Screen.Width;
        Height := Screen.Height;
        Top := 0;
        Left := 0;
      end;

      DisplayPanel.Align := alClient;

      HideCursorTimer.Enabled := True;

      PositionBar.Visible := False;
      VolumeBar.Visible := False;
      PlayBtn.Visible := False;
      PauseBtn.Visible := False;
      StopBtn.Visible := False;
      BackBtn.Visible := False;
      ForwardBtn.Visible := False;
      Image1.Visible := False;
      FullscreenBtn.Visible := False;
      VolumeUpBtn.Visible := False;
      VolumeDownBtn.Visible := False;
      SubDelayUpBtn.Visible := False;
      SubDelayDownBtn.Visible := False;
      PositionEdit.Visible := False;
      AudioDelayDownBtn.Visible := False;
      AudioDelayUpBtn.Visible := False;
      SaveDelaysBtn.Visible := False;
      ResetBtn.Visible := False;
      DelaysEdit.Visible := False;

    end
    else
    begin

      // restore values
      with PreviewForm do
      begin
        Width := FormWidth;
        Height := FormHeight;
        Top := FormTop;
        Left := FormLeft;

        BorderStyle := bsSizeable;
        // Top := 0;
        // Left := 0;
      end;

      DisplayPanel.Width := PanelWidth;
      DisplayPanel.Height := PanelHeight;
      DisplayPanel.Align := alNone;
      DisplayPanel.Anchors := [akLeft, akTop, akRight, akBottom];

      PositionBar.Visible := True;
      VolumeBar.Visible := True;
      PlayBtn.Visible := True;
      PauseBtn.Visible := True;
      StopBtn.Visible := True;
      BackBtn.Visible := True;
      ForwardBtn.Visible := True;
      Image1.Visible := True;
      FullscreenBtn.Visible := True;
      VolumeUpBtn.Visible := True;
      VolumeDownBtn.Visible := True;
      SubDelayUpBtn.Visible := True;
      SubDelayDownBtn.Visible := True;
      PositionEdit.Visible := True;
      AudioDelayDownBtn.Visible := True;
      AudioDelayUpBtn.Visible := True;
      SaveDelaysBtn.Visible := True;
      ResetBtn.Visible := True;
      DelaysEdit.Visible := True;

      PositionBar.Repaint;
      VolumeBar.Repaint;
      Image1.Repaint;

    end;

  end;

end;

procedure TPreviewForm.DisplayPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

  HideCursorTimer.Enabled := True;
  DisplayPanel.Cursor := crArrow;

  // if x < 20 then
  // begin
  // sPanel1.Visible := true;
  // sPanel1.BringToFront;
  // end
  // else
  // begin
  // sPanel1.Visible := False;
  // sPanel1.SendToBack;
  // end;

end;

procedure TPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  SettingsFile: TIniFile;
begin

  // load volume lvl
  SettingsFile := TIniFile.Create(MainForm.FAppDataFolder + 'Settings.ini');
  try
    SettingsFile.WriteInteger('Options', 'Player', VolumeBar.Progress);
  finally
    SettingsFile.Free;
  end;
  LogForm.MPlayerLogList.Lines.AddStrings(tmp);

  // stop player
  Player.Stop();

  PositionTimer.Enabled := False;
  HideCursorTimer.Enabled := False;
  CursorTime := 0;
  PositionBar.Progress := 0;
  PositionEdit.Text := '00:00:00/00:00:00';

  if (SubDelayValue <> MainForm.FMasterFileInfoList[VideoIndex].SelectedSubTrackDelayAsExtended) or (AudioDelayValue <> MainForm.FMasterFileInfoList[VideoIndex].SelectedAudioTrackDelayAsExtended) then
  begin

    if ID_YES = Application.MessageBox('Delay values for this video has been changed. Would you like to save it?', 'Confirm', MB_ICONQUESTION or MB_YESNO) then
    begin

      with MainForm do
      begin
        FMasterFileInfoList[VideoIndex].SetSelectedSubTrackDelay(SubDelayValue);
        FMasterFileInfoList[VideoIndex].SetSelectedAudioTrackDelay(AudioDelayValue);
      end;

    end;

  end;

  // update main form file list
  // todo: show on ui
//  MainForm.FileList.Items[VideoIndex].SubItems[1] := FloatToStr(AudioDelayValue);
//  MainForm.FileList.Items[VideoIndex].SubItems[2] := FloatToStr(SubDelayValue);

  if FromMainForm then
  begin
    MainForm.Enabled := True;
  end
  else
  begin
    EffectForm.Enabled := True;
  end;

  LogForm.MPlayerLogList.Lines.AddStrings(Player.MplayerConsoleOutput);
  LogForm.MPlayerLogList.Lines.Add('');
  LogForm.MPlayerLogList.Lines.Add('');

  MainForm.Caption := 'TEncoder';
  MainForm.SetPreviewProgress(0, 1000);

end;

procedure TPreviewForm.FormCreate(Sender: TObject);
var
  SettingsFile: TIniFile;
begin

  // load volume lvl
  SettingsFile := TIniFile.Create(MainForm.FAppDataFolder + 'Settings.ini');
  try
    VolumeBar.Progress := SettingsFile.ReadInteger('Options', 'Player', 20);
  finally
    SettingsFile.Free;
  end;

  tmp := TStringList.Create;
  // default values
  NewWidth := IntToStr(PreviewForm.Width);
  NewHeight := IntToStr(PreviewForm.Height);

  Player := TPlayer.Create(DisplayPanel.Handle, MainForm.FMPlayerPath);

end;

procedure TPreviewForm.FormDestroy(Sender: TObject);
begin

  FreeAndNil(tmp);
  Player.Destroy;

end;

procedure TPreviewForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if Key = VK_RIGHT then
  begin
    ForwardBtn.OnClick(self);
  end
  else if Key = VK_LEFT then
  begin
    BackBtn.OnClick(self);
  end
  else if Key = VK_UP then
  begin
    VolumeUpBtn.OnClick(self);
  end
  else if Key = VK_DOWN then
  begin
    VolumeDownBtn.OnClick(self);
  end
  else if Key = VK_RETURN then
  begin
    DisplayPanel.OnDblClick(self);
  end
  else if Key = ord('F') then
  begin
    DisplayPanel.OnDblClick(self);
  end
  else if Key = VK_SPACE then
  begin
    PauseBtn.OnClick(self);
  end
  else if Key = ord('S') then
  begin
    StopBtn.OnClick(self);
  end;

end;

procedure TPreviewForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin

  if VolumeBar.Progress > 0 then
  begin

    if Player.VolumeDown then
    begin
      VolumeBar.Progress := VolumeBar.Progress - 1;
    end;

  end;

end;

procedure TPreviewForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin

  if VolumeBar.Progress < VolumeBar.MaxValue then
  begin

    if Player.VolumeUp then
    begin
      VolumeBar.Progress := VolumeBar.Progress + 1;
    end;

  end;

end;

procedure TPreviewForm.FormShow(Sender: TObject);
begin
  PreviewForm.Width := 735;
  PreviewForm.Height := 400;
  SubDelayValue := MainForm.FMasterFileInfoList[VideoIndex].SelectedSubTrackDelayAsExtended;
  AudioDelayValue := MainForm.FMasterFileInfoList[VideoIndex].SelectedAudioTrackDelayAsExtended;

  if AudioOnly then
  begin
    MusicImage.Visible := True;
    MusicImage.BringToFront;
    DisplayPanel.Visible := False;
    DisplayPanel.SendToBack;
  end
  else
  begin
    MusicImage.Visible := False;
    MusicImage.SendToBack;
    DisplayPanel.Visible := True;
    DisplayPanel.BringToFront;
  end;

end;

procedure TPreviewForm.ForwardBtnClick(Sender: TObject);
begin

  Player.SeekForward(10);

end;

procedure TPreviewForm.FullscreenBtnClick(Sender: TObject);
begin

  DisplayPanel.OnDblClick(self);

end;

function TPreviewForm.GetNewDimentions(var VWidth: string): string;
begin

  VWidth := AdvancedOptionsForm.WidthEdit.Text;
  Result := AdvancedOptionsForm.HeightEdit.Text;

end;

procedure TPreviewForm.HideCursorTimerTimer(Sender: TObject);
begin

  inc(CursorTime);

  if CursorTime >= 20 then
  begin
    DisplayPanel.Cursor := crNone;
    CursorTime := 0;
    HideCursorTimer.Enabled := False;
  end;

end;

procedure TPreviewForm.PauseBtnClick(Sender: TObject);
begin

  Player.Pause();

end;

procedure TPreviewForm.PlayBtnClick(Sender: TObject);
var
  PlayerOptions: TPlayerOptions;
begin

  if Player.MplayerStatus = psStopped then
  begin

    // options
    with PlayerOptions do
    begin
      // video/audio options
      FileName := VideoName;
      FileIndex := VideoIndex;
      VideoSizeIndex := AdvancedOptionsForm.VideoSizeList.ItemIndex;
      VideoAspectIndex := AdvancedOptionsForm.VideoAspectRatioList.ItemIndex;
      VHeight := AdvancedOptionsForm.HeightEdit.Text;
      VWidth := AdvancedOptionsForm.WidthEdit.Text;
      ForceAspect := AdvancedOptionsForm.ForceASRBtn.Checked;
      VideoVolumeLevel := VolumeBar.Progress;
      EnableDeint := EffectForm.DeintEnblBtn.Checked;
      DeintMethodIndex := EffectForm.DeintMethodList.ItemIndex;
      AudioDelay := MainForm.FMasterFileInfoList[VideoIndex].SelectedAudioTrackDelayAsExtended;
      StartTime := MainForm.FMasterFileInfoList[VideoIndex].StartPosition;
      EndTime := MainForm.FMasterFileInfoList[VideoIndex].EndPosition;
      ;
      Crop := EffectForm.CropEnable.Checked;
      CropW := EffectForm.CropWidthEdit.Text;
      CropH := EffectForm.CropHeightEdit.Text;
      CropX := EffectForm.CropXEdit.Text;
      CropY := EffectForm.CropYEdit.Text;
      RotateMode := EffectForm.RotateList.ItemIndex;
      _AudioStream := AudioStream;

      // subtitle options
      with SubtitleOptions do
      begin
        EnableSubtitle := MainForm.EnableSubBtn.Checked;
        EncodingIndex := SettingsForm.LangIdList.ItemIndex;
        FontPath := SettingsForm.FFontInfos[SettingsForm.FontList.ItemIndex].FontFilePath;
        FontAutoScale := FloatToStr(SettingsForm.AutoScaleList.ItemIndex);
        TextScale := SettingsForm.DefScaleEdit.Text;
        SubtilePosition := FloatToStr(SettingsForm.SubposBar.Position);
        Delay := MainForm.FMasterFileInfoList[VideoIndex].SelectedAudioTrackDelayAsExtended;
        UseSSAStyle := SettingsForm.SubSSABtn.Checked;
      end;

    end;

    // pass options and start playing
    Player.Options := PlayerOptions;
    Player.KeepMplayerOutput := True;
    Player.StartPlaying();

    PositionTimer.Enabled := True;

    // if audio only then reset to default size
    if AudioOnly then
    begin
      PreviewForm.Width := 735;
      PreviewForm.Height := 400;
    end
    else
    begin
      // original size
      if AdvancedOptionsForm.VideoSizeList.ItemIndex = 0 then
      begin
        NewWidth := MainForm.GetHeight(VideoName);
        NewHeight := MainForm.GetWidth(VideoName);
      end
      else
      begin
        // resized
        NewHeight := GetNewDimentions(NewWidth);
      end;

      // if new size is bigger than screen
      // place preview window so user can resize/move it
      if (StrToInt(NewWidth) >= Screen.Width) or (StrToInt(NewHeight) >= Screen.Height) then
      begin
        PreviewForm.Top := 10;
        PreviewForm.Left := 10;
      end;

      if PreviewForm.Width < StrToInt(NewWidth) then
      begin
        PreviewForm.Width := StrToInt(NewWidth);
      end;

      PreviewForm.Height := StrToInt(NewHeight);
    end;

  end
  else
  begin
    PauseBtn.OnClick(self);
  end;

end;

procedure TPreviewForm.PositionBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin

  if (Button = mbLeft) then
  begin
    PositionTimer.Enabled := False;
    // Calculate the position
    NewTractBarPosition := Round((X * PositionBar.MaxValue) / PositionBar.ClientWidth);

    if (NewTractBarPosition <> PositionBar.Progress) then
    begin

      if Player.Seek(NewTractBarPosition) then
      begin
        PositionBar.Progress := NewTractBarPosition;
      end;

    end;

    PositionTimer.Enabled := True;
  end;

end;

procedure TPreviewForm.PositionBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin

  if Player.MplayerStatus <> psStopped then
  begin
    NewTractBarPosition := Round((X * PositionBar.MaxValue) / PositionBar.ClientWidth);

    PositionBar.Hint := MainForm.IntegerToTime(NewTractBarPosition);
  end
  else
  begin
    PositionBar.Hint := 'Position';
  end;

end;

procedure TPreviewForm.PositionTimerTimer(Sender: TObject);
begin
  if (Player.MplayerStatus = psPlaying) or (Player.MplayerStatus = psPaused) then
  begin
    PositionBar.Progress := Player.MplayerProgress;
    PositionEdit.Text := MainForm.IntegerToTime(PositionBar.Progress) + '/' + MainForm.IntegerToTime(PositionBar.MaxValue);
    MainForm.Caption := PositionEdit.Text;
    MainForm.SetPreviewProgress(PositionBar.Progress, PositionBar.MaxValue);
    self.Caption := 'Preview [' + ExtractFileName(VideoName) + ']';

    if Player.MplayerStatus = psPaused then
    begin
      MainForm.SetPaused;
    end
    else
    begin
      MainForm.SetPlaying;
    end;

  end
  else if Player.MplayerStatus = psStopped then
  begin
    HideCursorTimer.Enabled := False;
    CursorTime := 0;
    PositionBar.Progress := 0;
    PositionEdit.Text := '00:00:00/00:00:00';
    MainForm.Caption := 'TEncoder';
    MainForm.SetPreviewProgress(0, 1000);

    // if it was in fs mode when finished
    // restore to normal
    if BorderStyle = bsNone then
    begin

      // restore values
      with PreviewForm do
      begin
        Width := FormWidth;
        Height := FormHeight;
        Top := FormTop;
        Left := FormLeft;

        BorderStyle := bsSizeable;
        // Top := 0;
        // Left := 0;
      end;

      DisplayPanel.Width := PanelWidth;
      DisplayPanel.Height := PanelHeight;
      DisplayPanel.Align := alNone;
      DisplayPanel.Anchors := [akLeft, akTop, akRight, akBottom];

      PositionBar.Visible := True;
      VolumeBar.Visible := True;
      PlayBtn.Visible := True;
      PauseBtn.Visible := True;
      StopBtn.Visible := True;
      BackBtn.Visible := True;
      ForwardBtn.Visible := True;
      Image1.Visible := True;
      FullscreenBtn.Visible := True;
      VolumeUpBtn.Visible := True;
      VolumeDownBtn.Visible := True;
      SubDelayUpBtn.Visible := True;
      SubDelayDownBtn.Visible := True;
      PositionEdit.Visible := True;
      AudioDelayDownBtn.Visible := True;
      AudioDelayUpBtn.Visible := True;
      SaveDelaysBtn.Visible := True;
      ResetBtn.Visible := True;
      DelaysEdit.Visible := True;

      PositionBar.Repaint;
      VolumeBar.Repaint;
      Image1.Repaint;
    end
    else if Player.MplayerStatus = psFontCache then
    begin
      self.Caption := 'MPlayer is creating font chache please wait...';
    end;

    PositionTimer.Enabled := False;
    DisplayPanel.Cursor := crArrow;

    PreviewForm.Width := 735;
    PreviewForm.Height := 400;
    SubDelayValue := MainForm.FMasterFileInfoList[VideoIndex].SelectedSubTrackDelayAsExtended;
    AudioDelayValue := MainForm.FMasterFileInfoList[VideoIndex].SelectedAudioTrackDelayAsExtended;

  end;

end;

procedure TPreviewForm.ResetBtnClick(Sender: TObject);
begin

  AudioDelayValue := 0.0;
  SubDelayValue := 0.0;
  DelaysEdit.Text := '0/0';
  with MainForm do
  begin
    FMasterFileInfoList[VideoIndex].SetSelectedAudioTrackDelay(0);
    FMasterFileInfoList[VideoIndex].SetSelectedSubTrackDelay(0);
  end;

end;

procedure TPreviewForm.SaveDelaysBtnClick(Sender: TObject);
begin
  with MainForm do
  begin
    FMasterFileInfoList[VideoIndex].SetSelectedSubTrackDelay(SubDelayValue);
    FMasterFileInfoList[VideoIndex].SetSelectedAudioTrackDelay(AudioDelayValue);
  end;
end;

procedure TPreviewForm.StopBtnClick(Sender: TObject);
begin
  Player.Stop();
end;

procedure TPreviewForm.SubDelayDownBtnClick(Sender: TObject);
begin

  if Player.SubtitleDelayDown(1) then
  begin
    SubDelayValue := SubDelayValue - 0.1;
    DelaysEdit.Text := FloatToStr(SubDelayValue) + '/' + FloatToStr(AudioDelayValue);
  end;

end;

procedure TPreviewForm.SubDelayUpBtnClick(Sender: TObject);
begin

  if Player.SubtitleDelayUp(1) then
  begin
    SubDelayValue := SubDelayValue + 0.1;
    DelaysEdit.Text := FloatToStr(SubDelayValue) + '/' + FloatToStr(AudioDelayValue);
  end;

end;

procedure TPreviewForm.VolumeBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin

  if (Button = mbLeft) then
  begin

    // Calculate the position
    NewTractBarPosition := Round((X * VolumeBar.MaxValue) / VolumeBar.ClientWidth);

    if (NewTractBarPosition <> VolumeBar.Progress) then
    begin

      if Player.SetVolume(NewTractBarPosition) then
      begin
        VolumeBar.Progress := NewTractBarPosition;
      end;

    end;

  end;

end;

procedure TPreviewForm.VolumeDownBtnClick(Sender: TObject);
begin

  if VolumeBar.Progress > 0 then
  begin

    if Player.VolumeDown then
    begin
      VolumeBar.Progress := VolumeBar.Progress - 1;
    end;

  end;

end;

procedure TPreviewForm.VolumeUpBtnClick(Sender: TObject);
begin

  if VolumeBar.Progress < VolumeBar.MaxValue then
  begin

    if Player.VolumeUp then
    begin
      VolumeBar.Progress := VolumeBar.Progress + 1;
    end;

  end;

end;

end.

