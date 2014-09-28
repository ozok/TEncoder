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
unit UnitRangeEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvCreateProcess, sSkinProvider, StdCtrls, Buttons,
  sBitBtn, ComCtrls, JvExComCtrls, JvComCtrls, ExtCtrls, sPanel, sEdit, sGauge,
  UnitPlayer,
  acPNG, ImgList, acAlphaImageList;

type
  TRangeEditorForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    DisplayPanel: TsPanel;
    PlayBtn: TsBitBtn;
    StartBtn: TsBitBtn;
    EndBtn: TsBitBtn;
    ClearBtn: TsBitBtn;
    SaveBtn: TsBitBtn;
    StartBar: TsGauge;
    EndBar: TsGauge;
    Label1: TLabel;
    Label2: TLabel;
    StartEdit: TsEdit;
    EndEdit: TsEdit;
    StartForwardBtn: TsBitBtn;
    EndForwardBtn: TsBitBtn;
    EndBackBtn: TsBitBtn;
    StartBackBtn: TsBitBtn;
    PositionBar: TsGauge;
    PositionEdit: TsEdit;
    VolumeBar: TsGauge;
    Image1: TImage;
    PositionTimer: TTimer;
    StepSecondBackBtn: TsBitBtn;
    StepSecondForwardBtn: TsBitBtn;
    ImageList: TsAlphaImageList;
    VolumeUpBtn: TsBitBtn;
    VolumeDownBtn: TsBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlayBtnClick(Sender: TObject);

    procedure CloseBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PositionTimerTimer(Sender: TObject);
    procedure StepSecondForwardBtnClick(Sender: TObject);
    procedure StepSecondBackBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure EndBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure StartBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EndBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PositionBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SaveBtnClick(Sender: TObject);
    procedure StartForwardBtnClick(Sender: TObject);
    procedure StartBackBtnClick(Sender: TObject);
    procedure EndForwardBtnClick(Sender: TObject);
    procedure EndBackBtnClick(Sender: TObject);
    procedure VolumeUpBtnClick(Sender: TObject);
    procedure VolumeDownBtnClick(Sender: TObject);
    procedure VolumeBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }

    // mplayer
    Player: TPlayer;
  public
    { Public declarations }
    VideoName: string;
    VideoIndex: Integer;
    SubtitleIndex: Integer;
    StartValue: Integer;
    EndValue: Integer;
    ConstStartValue: Integer;
    ConstEndValue: Integer;
  end;

var
  RangeEditorForm: TRangeEditorForm;

implementation

uses UnitMain, UnitEffects, UnitSettings, UnitLogs, UnitAdvancedOptions;

{$R *.dfm}

procedure TRangeEditorForm.ClearBtnClick(Sender: TObject);
begin
  StartBar.Progress := 0;
  StartBar.MaxValue := MainForm.ConvertItems[VideoIndex].ConstDuration;
  EndBar.MaxValue := MainForm.ConvertItems[VideoIndex].ConstDuration;
  EndBar.Progress := MainForm.ConvertItems[VideoIndex].ConstDuration;

  StartValue := 0;
  EndValue := EndBar.MaxValue;

  StartEdit.Text := '00:00:00';
  EndEdit.Text := MainForm.IntegerToTime(EndBar.MaxValue);
end;

procedure TRangeEditorForm.CloseBtnClick(Sender: TObject);
begin
  RangeEditorForm.Close;
end;

procedure TRangeEditorForm.EndBackBtnClick(Sender: TObject);
begin

  if EndBar.Progress + -1 > StartBar.Progress then
  begin
    EndBar.Progress := EndBar.Progress - 1;
    EndEdit.Text := MainForm.IntegerToTime(EndBar.Progress);
    EndValue := EndBar.Progress;
  end;

end;

procedure TRangeEditorForm.EndBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin

  if (Button = mbLeft) then
  begin

    // Calculate the position
    NewTractBarPosition := Round((X * EndBar.MaxValue) / EndBar.ClientWidth);

    if (NewTractBarPosition > StartBar.Progress) then
    begin
      EndBar.Progress := NewTractBarPosition;
      EndEdit.Text := MainForm.IntegerToTime(EndBar.Progress);
      EndValue := EndBar.Progress;
    end;

  end;

end;

procedure TRangeEditorForm.EndBtnClick(Sender: TObject);
begin

  if PositionBar.Progress > StartBar.Progress then
  begin
    EndBar.Progress := PositionBar.Progress;
    EndEdit.Text := MainForm.IntegerToTime(EndBar.Progress);
    EndValue := EndBar.Progress;
  end;

end;

procedure TRangeEditorForm.EndForwardBtnClick(Sender: TObject);
begin

  if EndBar.Progress < EndBar.MaxValue then
  begin
    EndBar.Progress := EndBar.Progress + 1;
    EndEdit.Text := MainForm.IntegerToTime(EndBar.Progress);
    EndValue := EndBar.Progress;
  end;

end;

procedure TRangeEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
  Player.Stop();
  if (EndValue <> MainForm.ConvertItems[VideoIndex].EndPosition) or (StartValue <> MainForm.ConvertItems[VideoIndex].StartPosition) then
  begin
    if ID_YES = Application.MessageBox('Values changed. Would you like to save them?', 'Confirm', MB_ICONQUESTION or MB_YESNO) then
    begin
      SaveBtn.OnClick(Self);
    end;
  end;
  // update main form
  MainForm.FileList.Items[VideoIndex].SubItems[0] := MainForm.IntegerToTime(EndValue - StartValue);
  LogForm.MPlayerLogList.Lines.AddStrings(Player.MplayerConsoleOutput);
end;

procedure TRangeEditorForm.FormCreate(Sender: TObject);
begin
  Player := TPlayer.Create(DisplayPanel.Handle, MainForm.MplayerPath);;
end;

procedure TRangeEditorForm.FormDestroy(Sender: TObject);
begin
  Player.Free;
end;

procedure TRangeEditorForm.FormShow(Sender: TObject);
begin
  StartBar.MaxValue := PositionBar.MaxValue;
  EndBar.MaxValue := PositionBar.MaxValue;

  PositionBar.Progress := StartValue;
  StartBar.Progress := StartValue;
  EndBar.Progress := EndValue;

  StartEdit.Text := MainForm.IntegerToTime(StartValue);
  EndEdit.Text := MainForm.IntegerToTime(EndValue);
  PositionEdit.Text := MainForm.IntegerToTime(PositionBar.Progress) + '/' + MainForm.IntegerToTime(PositionBar.MaxValue);

  ConstStartValue := StartValue;
  ConstEndValue := EndValue;
end;

procedure TRangeEditorForm.PlayBtnClick(Sender: TObject);
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
      VideoVolumeLevel := VolumeBar.Progress;
      EnableDeint := EffectForm.DeintEnblBtn.Checked;
      DeintMethodIndex := EffectForm.DeintMethodList.ItemIndex;
      AudioDelay := MainForm.ConvertItems[VideoIndex].AudioDelay;
      StartTime := MainForm.ConvertItems[VideoIndex].StartPosition;
      EndTime := MainForm.ConvertItems[VideoIndex].EndPosition;
      RotateMode := EffectForm.RotateList.ItemIndex;

      // subtitle options
      with SubtitleOptions do
      begin
        EnableSubtitle := MainForm.EnableSubBtn.Checked;
        EncodingIndex := SettingsForm.LangIdList.ItemIndex;
        FontPath := MainForm.Info.Folders.Fonts + '\' + SettingsForm.FontList.Text + '.ttf';
        FontAutoScale := FloatToStr(SettingsForm.AutoScaleList.ItemIndex);
        TextScale := SettingsForm.DefScaleEdit.Text;
        SubtilePosition := FloatToStr(SettingsForm.SubposBar.Position);
        Delay := MainForm.ConvertItems[VideoIndex].SubtitleDelay;
      end;
    end;

    // pass options and start playing
    Player.Options := PlayerOptions;
    Player.KeepMplayerOutput := True;
    Player.StartPlaying();

    PositionTimer.Enabled := True;
    ImageList.GetBitmap32(0, PlayBtn.Glyph);
  end
  else
  begin
    Player.Pause();
    ImageList.GetBitmap32(1, PlayBtn.Glyph);
  end;

end;

procedure TRangeEditorForm.PositionBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TRangeEditorForm.PositionTimerTimer(Sender: TObject);
begin

  if (Player.MplayerStatus = psPlaying) or (Player.MplayerStatus = psPaused) then
  begin
    PositionBar.Progress := Player.MplayerProgress;
    PositionEdit.Text := MainForm.IntegerToTime(PositionBar.Progress) + '/' + MainForm.IntegerToTime(PositionBar.MaxValue);

  end
  else if Player.MplayerStatus = psStopped then
  begin
    PositionBar.Progress := 0;
    PositionEdit.Text := '00:00:00/00:00:00';

    PositionTimer.Enabled := False;
    ImageList.GetBitmap32(1, PlayBtn.Glyph);
  end;

  if Player.MplayerStatus = psPlaying then
  begin
    ImageList.GetBitmap32(0, PlayBtn.Glyph);
  end
  else if Player.MplayerStatus = psPaused then
  begin
    ImageList.GetBitmap32(1, PlayBtn.Glyph);
  end;

end;

procedure TRangeEditorForm.SaveBtnClick(Sender: TObject);
begin

  with MainForm do
  begin
    ConvertItems[VideoIndex].StartPosition := StartValue;
    ConvertItems[VideoIndex].EndPosition := EndValue;
  end;

end;

procedure TRangeEditorForm.StartBackBtnClick(Sender: TObject);
begin
  if StartBar.Progress > 0 then
  begin
    StartBar.Progress := StartBar.Progress - 1;
    StartEdit.Text := MainForm.IntegerToTime(StartBar.Progress);
    StartValue := StartBar.Progress;
  end;
end;

procedure TRangeEditorForm.StartBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewTractBarPosition: Integer;
begin

  if (Button = mbLeft) then
  begin

    // Calculate the position
    NewTractBarPosition := Round((X * StartBar.MaxValue) / StartBar.ClientWidth);

    if (NewTractBarPosition < EndBar.Progress) then
    begin
      StartBar.Progress := NewTractBarPosition;
      StartEdit.Text := MainForm.IntegerToTime(StartBar.Progress);
      StartValue := StartBar.Progress;
    end;

  end;

end;

procedure TRangeEditorForm.StartBtnClick(Sender: TObject);
begin

  if PositionBar.Progress < EndBar.Progress then
  begin
    StartBar.Progress := PositionBar.Progress;
    StartEdit.Text := MainForm.IntegerToTime(StartBar.Progress);
    StartValue := StartBar.Progress;
  end;

end;

procedure TRangeEditorForm.StartForwardBtnClick(Sender: TObject);
begin
  if (StartBar.Progress < EndBar.Progress) and ((StartBar.Progress + 1) < EndBar.Progress) then
  begin
    StartBar.Progress := StartBar.Progress + 1;
    StartEdit.Text := MainForm.IntegerToTime(StartBar.Progress);
    StartValue := StartBar.Progress;
  end;
end;

procedure TRangeEditorForm.StepSecondBackBtnClick(Sender: TObject);
var
  Status: TPlayerStatus;
begin

  Status := Player.MplayerStatus;

  Player.SeekBack(1);

  if Status = psPlaying then
  begin
    Player.Pause;
  end;

end;

procedure TRangeEditorForm.StepSecondForwardBtnClick(Sender: TObject);
var
  Status: TPlayerStatus;
begin

  Status := Player.MplayerStatus;

  Player.SeekForward(1);

  if Status = psPlaying then
  begin
    Player.Pause;
  end;

end;

procedure TRangeEditorForm.VolumeBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TRangeEditorForm.VolumeDownBtnClick(Sender: TObject);
begin

  if VolumeBar.Progress > 0 then
  begin

    if Player.VolumeDown then
    begin
      VolumeBar.Progress := VolumeBar.Progress - 1;
    end;

  end;

end;

procedure TRangeEditorForm.VolumeUpBtnClick(Sender: TObject);
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
