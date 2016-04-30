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
unit UnitVideotoGIF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ComCtrls, MediaInfoDll, UnitEncoder, Vcl.ExtCtrls, IniFiles, Vcl.Samples.Spin,
  JvSpin, JvExMask, JvToolEdit;

type
  TVideoToGIFForm = class(TForm)
    WidthEdit: TJvSpinEdit;
    HeightEdit: TJvSpinEdit;
    KeepAspectBtn: TCheckBox;
    DelayEdit: TJvSpinEdit;
    StartBar: TTrackBar;
    EndBar: TTrackBar;
    StartEdit: TEdit;
    EndEdit: TEdit;
    StartBtn: TButton;
    StopBtn: TButton;
    ResetBtn: TButton;
    DurationEdit: TEdit;
    PosTimer: TTimer;
    ConsoleEdit: TEdit;
    InfoEdit: TEdit;
    MemoryEdit: TJvSpinEdit;
    FPSEdit: TJvSpinEdit;
    SourceEdit: TJvFilenameEdit;
    DestEdit: TJvFilenameEdit;
    ProgressBar1: TProgressBar;
    procedure SourceEditAfterDialog(Sender: TObject; var Name: string; var Action: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartBarChange(Sender: TObject);
    procedure EndBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure KeepAspectBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure PosTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FDuration: Integer;
    FStart: Integer;
    FEnd: Integer;
    FConverter: TEncodingProcess;
    function GetDuration(const FileName: string): integer;
    function TimetoStrEx(const Time: Integer): string;
    procedure RemovePNGS;
    procedure ConvertState;
    procedure NormalState;
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
    FFMpegPath: string;
    ImageMagickPath: string;
  end;

var
  VideoToGIFForm: TVideoToGIFForm;

implementation

{$R *.dfm}

uses
  UnitMain, UnitLogs;

{ TFormVideoToGIF }

procedure TVideoToGIFForm.ConvertState;
begin
  SourceEdit.Enabled := False;
  DestEdit.Enabled := False;
  WidthEdit.Enabled := False;
  HeightEdit.Enabled := False;
  MemoryEdit.Enabled := False;
  DelayEdit.Enabled := False;
  StartEdit.Enabled := False;
  EndBar.Enabled := False;
  EndEdit.Enabled := False;
  StartBar.Enabled := False;
  DurationEdit.Enabled := False;
  StartBtn.Enabled := False;
  StopBtn.Enabled := True;
  ResetBtn.Enabled := False;
  KeepAspectBtn.Enabled := False;
  ProgressBar1.Visible := True;
end;

procedure TVideoToGIFForm.EndBarChange(Sender: TObject);
begin
  if EndBar.Position > StartBar.Position then
  begin
    EndEdit.Text := TimetoStrEx(EndBar.Position)
  end
  else
  begin
    EndBar.Position := StartBar.Position + 1;
  end;
  DurationEdit.Text := TimetoStrEx(EndBar.Position - StartBar.Position);
  FDuration := EndBar.Position - StartBar.Position;
  FStart := StartBar.Position;
  FEnd := EndBar.Position;
end;

procedure TVideoToGIFForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RemovePNGS;
  SaveSettings;
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TVideoToGIFForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not PosTimer.Enabled;
end;

procedure TVideoToGIFForm.FormCreate(Sender: TObject);
begin
  FConverter := TEncodingProcess.Create;
  ImageMagickPath := ExtractFileDir(Application.ExeName) + '\convert.exe';
  SourceEdit.Filter := 'Video Files|*.flv;*.m2v;*.avi;*.mkv;*.mpeg;*.mpg;*.mov;*.wmv;*.mp4;' + '*.m4v;*.dat;*.vob;*.rmvb;*.mts;*.mxf';
  LoadSettings;
end;

procedure TVideoToGIFForm.FormDestroy(Sender: TObject);
begin
  FConverter.Free;
end;

procedure TVideoToGIFForm.FormShow(Sender: TObject);
begin
  RemovePNGS;
end;

function TVideoToGIFForm.GetDuration(const FileName: string): integer;
var
  MediaInfoHandle: Cardinal;
  VDuration: string;
  VideoCount: string;
  LResult: Integer;
begin
  Result := 0;
  if (FileExists(FileName)) then
  begin
    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();
    if MediaInfoHandle <> 0 then
    begin
      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PWideChar(FileName));
        MediaInfo_Option(0, 'Complete', '1');
        // get length
        VDuration := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'Duration', Info_Text, Info_Name);
        // get video track count
        // if zero that means audio only source
        // vduration gets to be audio duration
        VideoCount := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'StreamCount', Info_Text, Info_Name);
        if not TryStrToInt(VideoCount, LResult) then
        begin
          VideoCount := '0';
        end;
        // if no video tracks general duration is first audio track's
        // duration
        if VideoCount = '0' then
        begin
          VDuration := MediaInfo_Get(MediaInfoHandle, Stream_General, 0, 'Duration', Info_Text, Info_Name);
        end;
        if Length(VDuration) < 1 then
        begin
          VDuration := '0';
        end;
        if Length(VDuration) < 1 then
        begin
          VDuration := '0';
        end;
        if TryStrToInt(VDuration, LResult) then
        begin
          Result := LResult;
        end;
      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

procedure TVideoToGIFForm.KeepAspectBtnClick(Sender: TObject);
begin
  HeightEdit.Enabled := not KeepAspectBtn.Checked;
end;

procedure TVideoToGIFForm.LoadSettings;
var
  LSet: TIniFile;
begin
  LSet := TIniFile.Create(MainForm.FAppDataFolder + '\settings.ini');
  try
    with LSet do
    begin
      WidthEdit.Text := ReadString('gif', 'width', '320');
      HeightEdit.Text := ReadString('gif', 'height', '240');
      KeepAspectBtn.Checked := ReadBool('gif', 'AR', False);
      MemoryEdit.Text := ReadString('gif', 'mem', '1024');
      DelayEdit.Text := ReadString('gif', 'fps', '5');
      FPSEdit.Text := ReadString('gif', 'fps2', '5');
    end;
  finally
    LSet.Free;
  end;
end;

procedure TVideoToGIFForm.NormalState;
begin
  SourceEdit.Enabled := True;
  DestEdit.Enabled := True;
  WidthEdit.Enabled := True;
  HeightEdit.Enabled := True;
  MemoryEdit.Enabled := True;
  DelayEdit.Enabled := True;
  StartEdit.Enabled := True;
  EndBar.Enabled := True;
  EndEdit.Enabled := True;
  StartBar.Enabled := True;
  DurationEdit.Enabled := True;
  StartBtn.Enabled := True;
  StopBtn.Enabled := False;
  ResetBtn.Enabled := True;
  ConsoleEdit.Text := '';
  InfoEdit.Text := '';
  ProgressBar1.Visible := False;
  KeepAspectBtn.Enabled := True;
  KeepAspectBtnClick(Self);
end;

procedure TVideoToGIFForm.PosTimerTimer(Sender: TObject);
var
  I: Integer;
begin
  if FConverter.FilesDone <> FConverter.CommandCount then
  begin
    ConsoleEdit.Text := FConverter.ConsoleOutput;
    InfoEdit.Text := FConverter.Info;
  end
  else
  begin
    PosTimer.Enabled := False;
    NormalState;
    LogForm.OtherLog.Lines.Add('Video to GIF:');
    LogForm.OtherLog.Lines.AddStrings(FConverter.GetConsoleOutput);
    for I := 0 to FConverter.EncodeJobs.Count - 1 do
    begin
      LogForm.OtherLog.Lines.Add(FConverter.EncodeJobs[i].CommandLine);
    end;
    Self.BringToFront;
    Application.MessageBox('Finished converting to gif.', 'Info', MB_ICONINFORMATION);
  end;
end;

procedure TVideoToGIFForm.RemovePNGS;
var
  lSearchRec: TSearchRec;
  lFind: integer;
  lPath: string;
begin
  lPath := IncludeTrailingPathDelimiter(MainForm.Info.Folders.Temp + '\TEncoder\');

  lFind := FindFirst(lPath + '*.png.', faAnyFile, lSearchRec);
  while lFind = 0 do
  begin
    DeleteFile(lPath + lSearchRec.Name);

    lFind := FindNext(lSearchRec);
  end;
  FindClose(lSearchRec);
end;

procedure TVideoToGIFForm.SaveSettings;
var
  LSet: TIniFile;
begin
  LSet := TIniFile.Create(MainForm.FAppDataFolder + '\settings.ini');
  try
    with LSet do
    begin
      WriteString('gif', 'width', WidthEdit.Text);
      WriteString('gif', 'height', HeightEdit.Text);
      WriteBool('gif', 'AR', KeepAspectBtn.Checked);
      WriteString('gif', 'mem', MemoryEdit.Text);
      WriteString('gif', 'delay', DelayEdit.Text);
      WriteString('gif', 'fps2', FPSEdit.Text);
    end;
  finally
    LSet.Free;
  end;
end;

procedure TVideoToGIFForm.SourceEditAfterDialog(Sender: TObject; var Name: string; var Action: Boolean);
begin
  Self.Caption := 'Reading file duration...';
  Self.Enabled := False;
  try
    FDuration := GetDuration(Name);
    FStart := 0;
    FEnd := FDuration;
    StartEdit.Text := '00:00:00.000';
    EndEdit.Text := TimetoStrEx(FDuration);
    DurationEdit.Text := EndEdit.Text;
    StartBar.Max := FDuration;
    EndBar.Max := FDuration;
    EndBar.Position := FDuration;
    DestEdit.Text := ChangeFileExt(Name, '.gif');
  finally
    Self.Caption := 'Video to GIF';
    Self.Enabled := True;
  end;
end;

procedure TVideoToGIFForm.StartBarChange(Sender: TObject);
begin
  if StartBar.Position < EndBar.Position then
  begin
    StartEdit.Text := TimetoStrEx(StartBar.Position)
  end
  else
  begin
    StartBar.Position := EndBar.Position - 1
  end;
  DurationEdit.Text := TimetoStrEx(EndBar.Position - StartBar.Position);
  FDuration := EndBar.Position - StartBar.Position;
  FStart := StartBar.Position;
  FEnd := EndBar.Position;
end;

procedure TVideoToGIFForm.StartBtnClick(Sender: TObject);
var
  LCMD: string;
  LEncodeJob: TEncodeJob;
begin
  if not DirectoryExists(MainForm.Info.Folders.Temp + '\TEncoder\') then
  begin
    if not CreateDir(MainForm.Info.Folders.Temp + '\TEncoder\') then
    begin
      Application.MessageBox('Cannot create temp folder.', 'Error', MB_ICONERROR);
      exit;
    end;
  end;
  if FileExists(SourceEdit.Text) then
  begin
    FConverter.ResetValues;
    RemovePNGS;
    // ffmepg video to pngs
    LCMD := ' -y -i "' + SourceEdit.Text + '"';
    if KeepAspectBtn.Checked then
    begin
      LCMD := LCMD + ' -vf scale=' + WidthEdit.Text + ':-1';
    end
    else
    begin
      LCMD := LCMD + ' -vf scale=' + WidthEdit.Text + ':' + HeightEdit.Text;
    end;
    LCMD := LCMD + ' -f image2 -r 10 -ss ' + TimetoStrEx(FStart) + ' -t ' + TimetoStrEx(FDuration) + ' "' + MainForm.Info.Folders.Temp + '\TEncoder\%05d.png"';
    LEncodeJob.CommandLine := LCMD;
    LEncodeJob.ProcessPath := FFMpegPath;
    LEncodeJob.EncodingOutputFilePath := 'Video to image sequence';
    LEncodeJob.SourceDuration := FDuration div 1000;
    LEncodeJob.ProcessType := ffmpeg;
    FConverter.EncodeJobs.Add(LEncodeJob);
    // convert pngs to gif
    LCMD := ' -monitor -limit memory ' + MemoryEdit.Text + 'MB -delay ' + DelayEdit.Text + ' +dither -layers optimizeplus -colors 32 "' + MainForm.Info.Folders.Temp + '\TEncoder\*.png" "' + DestEdit.Text + '"';
    LEncodeJob.CommandLine := LCMD;
    LEncodeJob.ProcessPath := ImageMagickPath;
    LEncodeJob.EncodingOutputFilePath := 'Image sequence to gif';
    LEncodeJob.SourceDuration := FDuration div 1000;
    LEncodeJob.ProcessType := imagemagick;
    FConverter.EncodeJobs.Add(LEncodeJob);

    FConverter.Start;
    PosTimer.Enabled := True;
    ConvertState;
  end
  else
  begin
    Application.MessageBox('Cannot find source file.', 'Error', MB_ICONERROR);
  end;
end;

procedure TVideoToGIFForm.StopBtnClick(Sender: TObject);
var
  I: Integer;
begin
  PosTimer.Enabled := False;
  FConverter.Stop;
  NormalState;
  LogForm.OtherLog.Lines.Add('Video to GIF:');
  LogForm.OtherLog.Lines.AddStrings(FConverter.GetConsoleOutput);
  for I := 0 to FConverter.EncodeJobs.Count - 1 do
  begin
    LogForm.OtherLog.Lines.Add(FConverter.EncodeJobs[i].CommandLine);
  end;
end;

function TVideoToGIFForm.TimetoStrEx(const Time: Integer): string;
var
  LHourInt, LMinInt, LSecInt, LMiliSecInt: integer;
  LHourStr, LMinStr, LSecStr, LMiliSecStr: string;
  LTimeAsSec: Integer;
begin
  Result := '00:00:00.000';
  if Time > 0 then
  begin
    LTimeAsSec := Time div 1000;

    LHourInt := LTimeAsSec div 3600;
    LMinInt := (LTimeAsSec div 60) - (LHourInt * 60);
    LSecInt := (LTimeAsSec mod 60);
    LMiliSecInt := Time mod 1000;
    if LHourInt < 10 then
    begin
      LHourStr := '0' + FloatToStr(LHourInt)
    end
    else
    begin
      LHourStr := FloatToStr(LHourInt)
    end;
    if LMinInt < 10 then
    begin
      LMinStr := '0' + FloatToStr(LMinInt)
    end
    else
    begin
      LMinStr := FloatToStr(LMinInt)
    end;
    if LSecInt < 10 then
    begin
      LSecStr := '0' + FloatToStr(LSecInt)
    end
    else
    begin
      LSecStr := FloatToStr(LSecInt)
    end;
    if LMiliSecInt < 10 then
    begin
      LMiliSecStr := '00' + FloatToStr(LMiliSecInt)
    end
    else if LMiliSecInt < 100 then
    begin
      LMiliSecStr := '0' + FloatToStr(LMiliSecInt)
    end
    else
    begin
      LMiliSecStr := FloatToStr(LMiliSecInt)
    end;
    Result := LHourStr + ':' + LMinStr + ':' + LSecStr + '.' + LMiliSecStr;
  end;
end;

end.

