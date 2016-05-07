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
unit UnitImageAudioMerger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Mask, UnitEncoder, MediaInfoDll, StrUtils, Vcl.ExtCtrls,
  JvExMask, JvToolEdit, UnitCommonMethods;

type
  TImageAudiotoVideoForm = class(TForm)
    OutputEdit: TEdit;
    StartBtn: TBitBtn;
    StopBtn: TBitBtn;
    sLabel1: TLabel;
    ProgressBar: TProgressBar;
    ProgressLabel: TLabel;
    PosTimer: TTimer;
    AudioEdit: TJvFilenameEdit;
    ImageEdit: TJvFilenameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PosTimerTimer(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  private
    { Private declarations }
    FEncoder: TEncodingProcess;
    FDuration: string;
    FOutputFile: string;
    function CreateCMD: string;
    function GetDuration(const FileName: string): string;
    procedure EncodingState;
    procedure NormalState;
  public
    { Public declarations }

    function CreateFileName(const FileName: string; const Extension: string): string;
    function FFMpegPosition(const FFMpegOutput: string; const Duration: string): string;
    function CreateAdvancedOptions(): string;
  end;

var
  ImageAudiotoVideoForm: TImageAudiotoVideoForm;

implementation

{$R *.dfm}

uses
  UnitMain, UnitEffects, UnitAdvancedOptions, UnitLogs, UnitDub;

function TImageAudiotoVideoForm.CreateAdvancedOptions: string;
var
  AdvancedCMD: string;
begin
  case MainForm.VideoEncoderList.ItemIndex of
    0: // mpeg 1
      begin
        AdvancedCMD := '';
      end;
    1: // mpeg 2
      begin
        AdvancedCMD := '';
      end;
    2: // xvid
      begin
        AdvancedCMD := '';
      end;
    3: // mpeg 4
      begin
        AdvancedCMD := '';
      end;
    4: // h264
      begin
        AdvancedCMD := '';

        with AdvancedOptionsForm do
        begin

          if x264Btn.Checked then
          begin
            // profile
            case x264ProfileList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ' -profile:v baseline';
              2:
                AdvancedCMD := AdvancedCMD + ' -profile:v main';
              3:
                AdvancedCMD := AdvancedCMD + ' -profile:v high';
              4:
                AdvancedCMD := AdvancedCMD + ' -profile:v high10';
              5:
                AdvancedCMD := AdvancedCMD + ' -profile:v high422';
              6:
                AdvancedCMD := AdvancedCMD + ' -profile:v high444';
            end;

            // presets
            case x264PresetList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ' -preset ultrafast';
              2:
                AdvancedCMD := AdvancedCMD + ' -preset superfast';
              3:
                AdvancedCMD := AdvancedCMD + ' -preset veryfast';
              4:
                AdvancedCMD := AdvancedCMD + ' -preset faster';
              5:
                AdvancedCMD := AdvancedCMD + ' -preset fast';
              6:
                AdvancedCMD := AdvancedCMD + ' -preset medium';
              7:
                AdvancedCMD := AdvancedCMD + ' -preset slow';
              8:
                AdvancedCMD := AdvancedCMD + ' -preset slower';
              9:
                AdvancedCMD := AdvancedCMD + ' -preset veryslow';
              10:
                AdvancedCMD := AdvancedCMD + ' -preset placebo';
            end;

            // tune
            case x264TuneList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ' -tune film';
              2:
                AdvancedCMD := AdvancedCMD + ' -tune animation';
              3:
                AdvancedCMD := AdvancedCMD + ' -tune grain';
              4:
                AdvancedCMD := AdvancedCMD + ' -tune stillimage';
              5:
                AdvancedCMD := AdvancedCMD + ' -tune psnr';
              6:
                AdvancedCMD := AdvancedCMD + ' -tune ssim';
              7:
                AdvancedCMD := AdvancedCMD + ' -tune fastdecode';
              8:
                AdvancedCMD := AdvancedCMD + ' -tune zerolatency';
            end;

            // level
            if x264LevelList.ItemIndex > 0 then
            begin
              AdvancedCMD := AdvancedCMD + ' -level ' + ReplaceStr(x264LevelList.Text, '.', '');
            end;
          end;

        end;
      end;
    5: // flv
      begin
        AdvancedCMD := '';
      end;
    6: // wmv
      begin
        AdvancedCMD := '';
      end;
    7: // vp8
      begin
        AdvancedCMD := '';
      end;
    8: // huffyuv
      begin
        AdvancedCMD := '';
      end;
    9: // prores
      begin
        AdvancedCMD := ' -profile:v ' + FloatToStr(AdvancedOptionsForm.ProresProfileList.ItemIndex) + ' -qscale:v ' + AdvancedOptionsForm.ProresQualityEdit.Text;
      end;
    10: // copy
      begin
        AdvancedCMD := '';
      end;
    11: // none
      begin
        AdvancedCMD := '';
      end;
    12: // x265
      begin
        AdvancedCMD := '';
        with AdvancedOptionsForm do
        begin
          // presets
          case x265PresetsList.ItemIndex of
            1:
              AdvancedCMD := AdvancedCMD + ' -preset ultrafast';
            2:
              AdvancedCMD := AdvancedCMD + ' -preset superfast';
            3:
              AdvancedCMD := AdvancedCMD + ' -preset veryfast';
            4:
              AdvancedCMD := AdvancedCMD + ' -preset faster';
            5:
              AdvancedCMD := AdvancedCMD + ' -preset fast';
            6:
              AdvancedCMD := AdvancedCMD + ' -preset medium';
            7:
              AdvancedCMD := AdvancedCMD + ' -preset slow';
            8:
              AdvancedCMD := AdvancedCMD + ' -preset slower';
            9:
              AdvancedCMD := AdvancedCMD + ' -preset veryslow';
            10:
              AdvancedCMD := AdvancedCMD + ' -preset placebo';
          end;
        end;
      end;
  end;
  Result := AdvancedCMD;
end;

function TImageAudiotoVideoForm.CreateCMD: string;
var
  VBitrate: string;
  VSize: string;
  VCodec: string;
  VFPS: string;
  VAspect: string;
  VHeight: string;
  VWidth: string;
  Abitrate: string;
  ACodec: string;
  ASR: string;
  AChan: string;
  OutExtension: string;
  AudioCMD: string;
  OutName: string;
  Container: string;
  FilterCMD: string;
  LVolumeCMD: string;
  CustomAudioArg: string;
  CustomVideoArg: string;
  CustomArgs: string;
begin

  // output extension and container options
  Container := 'avi';
  OutExtension := '.avi';

  case MainForm.ContainerList.ItemIndex of
    0:
      begin
        Container := 'avi ';
        OutExtension := '.avi';
      end;
    1:
      begin
        Container := 'mpeg ';
        OutExtension := '.mpeg';
      end;
    2:
      begin
        Container := 'mp4 ';
        OutExtension := '.mp4';
      end;
    3:
      begin
        Container := 'mov ';
        OutExtension := '.mov';
      end;
    4:
      begin
        Container := 'matroska ';
        OutExtension := '.mkv';
      end;
    5:
      begin
        Container := 'flv ';
        OutExtension := '.flv';
      end;
    6:
      begin
        Container := '';
        OutExtension := '.wmv';
      end;
    7:
      begin
        Container := 'webm ';
        OutExtension := '.webm';
      end;
    8:
      begin
        Container := '3gp ';
        OutExtension := '.3gp';
      end;
  end;

  // wmv
  if (MainForm.ContainerList.ItemIndex = 6) or (MainForm.VideoEncoderList.ItemIndex = 11) then
  begin
    Container := '';
  end
  else
  begin
    Container := ' -f ' + Container;
  end;

  Abitrate := AdvancedOptionsForm.AudioBitrateList.Text;

  if AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 7 then
  begin
    ASR := ' -af aresample=resampler=soxr -ar ' + AdvancedOptionsForm.AudioSampleRateList.Text
  end
  else
  begin
    ASR := ' ';
  end;

  // audio channels
  case AdvancedOptionsForm.AudioChannelsList.ItemIndex of
    0:
      begin
        AChan := ' -ac 1 '
      end;
    1:
      begin
        AChan := ' -ac 2 '
      end;
    2:
      begin
        AChan := ' -ac 6 '
      end;
    3:
      begin
        AChan := ' '
      end;
  end;

  if EffectForm.VolumeEnableBtn.Checked then
  begin
    LVolumeCMD := ' -af volume=' + StringReplace(FloatToStr(EffectForm.VolumeFFMpegEdit.Value / 100), ',', '.', [rfReplaceAll]);
  end
  else
  begin
    LVolumeCMD := ' ';
  end;

  if AdvancedOptionsForm.CustomFFmpegAudioBtn.Checked then
  begin
    CustomAudioArg := AdvancedOptionsForm.CustomFFMpegAudioEdit.Text;
  end;

  // codec
  case MainForm.AudioEncoderList.ItemIndex of
    0: // copy
      begin
        ACodec := ' -c:a copy' + CustomAudioArg;
      end;
    1: // mp3
      begin
        ACodec := ' -c:a libmp3lame -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    2: // aac
      begin
        ACodec := ' -strict experimental -c:a aac -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
        // ACodec := ' -c:a libvo_aacenc -ab ' + Abitrate + 'k '
        // + ASR + AChan + ' ' + CustomAudioArg;
      end;
    3: // ogg
      begin
        ACodec := ' -c:a libvorbis -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    4: // wav
      begin
        ACodec := ' -c:a pcm_alaw';
      end;
    5: // ac3
      begin
        ACodec := ' -c:a ac3 -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    6: // mp2
      begin
        ACodec := ' -c:a mp2 -ab ' + Abitrate + 'k  ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    7: // wma2
      begin
        ACodec := ' -c:a wmav2 -ab ' + Abitrate + 'k  ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    8: // speex
      begin
        ACodec := ' -f ogg -c:a libspeex -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    9: // opus
      begin
        ACodec := ' -c:a libopus -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    11: // flac
      begin
        ACodec := ' -c:a flac -compression_level ' + AdvancedOptionsForm.FlacCompEdit.Text + ' ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
  end;

  // Video Options

  // bitrate
  VBitrate := AdvancedOptionsForm.VideobitrateList.Text + '000 ';

  // do cbr encoding
  if AdvancedOptionsForm.VideoCBrBtn.Checked then
  begin
    VBitrate := VBitrate + ' -minrate ' + VBitrate + ' -maxrate ' + VBitrate + ' -bufsize ' + IntToStr(StrToInt(Trim(VBitrate)) * 2) + ' -muxrate ' + IntToStr(StrToInt(Trim(VBitrate)) * 2) + ' ';
  end;

  // video size
  if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
  begin
    VHeight := AdvancedOptionsForm.WidthEdit.Text;
    VWidth := AdvancedOptionsForm.HeightEdit.Text;
  end;

  FilterCMD := '';
  // crop
  if EffectForm.CropEnable.Checked then
  begin
    FilterCMD := FilterCMD + ' -vf crop=' + EffectForm.CropWidthEdit.Text + ':' + EffectForm.CropHeightEdit.Text + ':' + EffectForm.CropXEdit.Text + ':' + EffectForm.CropYEdit.Text;
  end;

  // video size
  if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
  begin
    if Length(FilterCMD) > 0 then
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := FilterCMD + ',scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := FilterCMD + ',scale=' + AdvancedOptionsForm.WidthEdit.Text + ':trunc(ow/a/2)*2';
      end;
    end
    else
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := ' -vf scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := ' -vf scale=' + AdvancedOptionsForm.WidthEdit.Text + ':trunc(ow/a/2)*2';
      end;
    end;
  end;

  // rotate
  if EffectForm.RotateList.ItemIndex > 0 then
  begin
    if Length(FilterCMD) > 0 then
    begin
      FilterCMD := FilterCMD + ',transpose=' + FloatToStr(EffectForm.RotateList.ItemIndex - 1)
    end
    else
    begin
      FilterCMD := '-vf transpose=' + FloatToStr(EffectForm.RotateList.ItemIndex - 1)
    end;
  end;

  // FPS
  if AdvancedOptionsForm.VideoFPSList.ItemIndex = 0 then
  begin
    VFPS := ' '; // auto
  end
  else
  begin
    VFPS := ' -r ' + AdvancedOptionsForm.VideoFPSList.Text;
  end;

  if AdvancedOptionsForm.CustomFFmpegVideoBtn.Checked then
  begin
    CustomVideoArg := ' ' + AdvancedOptionsForm.CustomFFMpegVideoEdit.Text;
  end;
  if AdvancedOptionsForm.CustomFFmpegAudioBtn.Checked then
  begin
    CustomAudioArg := ' ' + AdvancedOptionsForm.CustomFFMpegAudioEdit.Text;
  end;

  // command line for aspect ratio
  case AdvancedOptionsForm.VideoAspectRatioList.ItemIndex of
    0:
      VAspect := '';
    1:
      VAspect := '-aspect 4:3';
    2:
      VAspect := '-aspect 16:9';
    3:
      VAspect := '-aspect 1.85';
    4:
      VAspect := '-aspect 2.35';
    5:
      VAspect := '-aspect 1.3333';
    6:
      VAspect := '-aspect 1.7777';
  end;

  // command line for video encoder
  case MainForm.VideoEncoderList.ItemIndex of
    0: // mpeg 1
      begin
        VCodec := ' -c:v mpeg1video ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    1: // mpeg 2
      begin
        VCodec := ' -c:v mpeg2video ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    2: // xvid
      begin
        VCodec := ' -c:v libxvid ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    3: // mpeg 4
      begin
        VCodec := ' -c:v mpeg4 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    4: // h264
      begin
        if AdvancedOptionsForm.x264CRFBtn.Checked and AdvancedOptionsForm.x264Btn.Checked then
        begin
          VCodec := ' -c:v libx264 ' + ' -crf ' + AdvancedOptionsForm.x264CRFEdit.Text + ' ' + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end
        else
        begin
          VCodec := ' -c:v libx264 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      end;
    5: // flv
      begin
        VCodec := ' -c:v flv ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    6: // wmv
      begin
        VCodec := VFPS + ' -c:v wmv2 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + VSize + CreateAdvancedOptions + CustomVideoArg;
      end;
    7: // vp8
      begin
        VCodec := ' -c:v libvpx ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    8: // huffyuv
      begin
        VCodec := ' -c:v huffyuv ' + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    9: // prores
      begin
        VCodec := ' -c:v prores ' + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
    12: // h265
      begin
        VCodec := ' -c:v libx265 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
      end;
  end;

  OutName := CreateFileName(OutputEdit.Text, OutExtension);
  FOutputFile := OutName;

  CustomArgs := AdvancedOptionsForm.CustomFFmpegEdit.Text;

  Result := ' -y -threads 0 -f image2 -loop 1 -i "' + ImageEdit.Text + '" -i "' + AudioEdit.Text + '" ' + CustomArgs + ' -t ' + GetDuration(AudioEdit.Text) + ' ' + VCodec + Container + AudioCMD + ACodec + ' "' + OutName + '"';

end;

function TImageAudiotoVideoForm.CreateFileName(const FileName, Extension: string): string;
var
  FileIndex: Integer;
  OutFileName: string;
  TmpStr: string;
begin

  OutFileName := ChangeFileExt(FileName, Extension);

  if DirectoryExists(MainForm.DirectoryEdit.Text + '\') then
  begin
    OutFileName := MainForm.DirectoryEdit.Text + '\' + ExtractFileName(OutFileName);
  end
  else
  begin
    if CreateDir(MainForm.DirectoryEdit.Text + '\') then
    begin
      OutFileName := MainForm.DirectoryEdit.Text + '\' + ExtractFileName(OutFileName);
    end
    else
    begin
      OutFileName := MainForm.DirectoryEdit.Text + '\' + ExtractFileName(OutFileName);
    end;
  end;

  TmpStr := OutFileName;

  FileIndex := 0;
  if FileExists(OutFileName) then
  begin
    while FileExists(OutFileName) do
    begin
      OutFileName := TmpStr;
      Inc(FileIndex);
      OutFileName := ChangeFileExt(TmpStr, '_' + FloatToStr(FileIndex) + Extension);
    end;
  end;

  Result := OutFileName;
end;

procedure TImageAudiotoVideoForm.EncodingState;
begin
  StartBtn.Enabled := False;
  StopBtn.Enabled := True;
  AudioEdit.Enabled := False;
  ImageEdit.Enabled := False;
  OutputEdit.Enabled := False;
end;

function TImageAudiotoVideoForm.FFMpegPosition(const FFMpegOutput, Duration: string): string;
var
  pos1: Integer;
  pos2: Integer;
  Text: string;
  prog: string;
  last: string;
  PositionInt: Integer;
begin
  Result := '0';
  Text := FFMpegOutput;

  if Length(FFMpegOutput) > 0 then
  begin
    pos1 := Pos('time=', FFMpegOutput);
    pos2 := Pos('bitrate=', FFMpegOutput);
    prog := Copy(Text, pos1 + 1, (pos2 - pos1 - 1));
    last := Copy(prog, 5, Length(prog) - 4);

    PositionInt := TimeToInt(LeftBStr(Trim(last), 8));
    if IsStringNumeric(Duration) and (Duration <> '0') then
    begin
      Result := IntToStr((100 * PositionInt) div StrToInt(Duration));
    end;
  end;
end;

procedure TImageAudiotoVideoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FEncoder.ProcessID > 0 then
  begin
    FEncoder.Stop;
  end;
end;

procedure TImageAudiotoVideoForm.FormCreate(Sender: TObject);
begin
  FEncoder := TEncodingProcess.Create;
  AudioEdit.Dialog.Filter := 'Audio Files|*.mp3;*.wav;*.aac;*.m4a;*.m4b;*.ac3;*.ogg;*.flac;*.mp2;*.opus;*.spx';
  ImageEdit.Dialog.Filter := 'Image Files|*.jpeg;*.jpg;*.bmp;*.gif;*.png';
end;

procedure TImageAudiotoVideoForm.FormDestroy(Sender: TObject);
begin
  FEncoder.Free;
end;

procedure TImageAudiotoVideoForm.FormShow(Sender: TObject);
begin
  // reset all
  FEncoder.ResetValues;
  AudioEdit.Text := '';
  ImageEdit.Text := '';
  OutputEdit.Text := '';
  ProgressBar.Position := 0;
  ProgressLabel.Caption := '0%';
  FDuration := '0';
end;

function TImageAudiotoVideoForm.GetDuration(const FileName: string): string;
var
  MediaInfoHandle: Cardinal;
begin

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

        FDuration := MediaInfo_Get(MediaInfoHandle, Stream_General, 0, 'Duration', Info_Text, Info_Name);
        if Length(FDuration) < 1 then
        begin
          FDuration := '0';
        end;
        FDuration := FloatToStr(StrToInt(FDuration) div 1000);
        Result := MediaInfo_Get(MediaInfoHandle, Stream_General, 0, 'Duration/String3', Info_Text, Info_Name);

      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

procedure TImageAudiotoVideoForm.NormalState;
begin
  StartBtn.Enabled := True;
  StopBtn.Enabled := False;
  AudioEdit.Enabled := True;
  ImageEdit.Enabled := True;
  OutputEdit.Enabled := True;
  LogForm.OtherLog.Lines.Add('Image+Audio=Video');
  if FEncoder.CommandCount > 0 then
  begin
    LogForm.OtherLog.Lines.AddStrings(FEncoder.GetConsoleOutput);
  end;
  LogForm.OtherLog.Lines.AddStrings(FEncoder.GetConsoleOutput);
end;

procedure TImageAudiotoVideoForm.PosTimerTimer(Sender: TObject);
begin
  if FEncoder.FilesDone = FEncoder.CommandCount then
  begin
    PosTimer.Enabled := False;
    ProgressBar.Position := 0;
    ProgressLabel.Caption := '0%';
    FDuration := '0';
    NormalState;
    Self.BringToFront;
    Application.MessageBox('Finished creating video from image and audio.', 'Info', MB_ICONINFORMATION);
  end
  else
  begin
    ProgressBar.Position := StrToInt(FFMpegPosition(FEncoder.ConsoleOutput, FDuration));
    ProgressLabel.Caption := FloatToStr(ProgressBar.Position) + '%';
  end;
end;

procedure TImageAudiotoVideoForm.StartBtnClick(Sender: TObject);
var
  LCMD: string;
  LEncodeJob: TEncodeJob;
begin
  if FileExists(AudioEdit.Text) then
  begin
    if FileExists(ImageEdit.Text) then
    begin
      if Length(OutputEdit.Text) > 0 then
      begin
        // todo: check file name for valid chars
        if MainForm.VideoEncoderList.ItemIndex < 10 then
        begin
          if (MainForm.AudioEncoderList.ItemIndex <> 10) then
          begin

            // reset
            FEncoder.ResetValues;
            ProgressBar.Position := 0;
            ProgressLabel.Caption := '0%';
            FDuration := '0';
            FOutputFile := '';
            GetDuration(AudioEdit.Text);

            // create command line
            LCMD := CreateCMD;
            if Length(LCMD) > 0 then
            begin
              LEncodeJob.CommandLine := LCMD;
              LEncodeJob.ProcessPath := MainForm.FFFMpegPath;
              LEncodeJob.ProcessType := ffmpeg;
              LEncodeJob.EncodingInformation := 'Image+Audio=Video';
              LEncodeJob.EncodingOutputFilePath := FOutputFile;
              LEncodeJob.SourceFileName := '';
              FEncoder.EncodeJobs.Add(LEncodeJob);
              FEncoder.Start;
              PosTimer.Enabled := True;
              EncodingState;
            end
            else
            begin
              Application.MessageBox('Cannot create command line.', 'Error', MB_ICONERROR)
            end;
          end
          else
          begin
            Application.MessageBox('Select an audio encoder.', 'Warning', MB_ICONWARNING)
          end;
        end
        else
        begin
          Application.MessageBox('Select an video encoder.', 'Warning', MB_ICONWARNING)
        end;

      end
      else
      begin
        Application.MessageBox('Enter a valid output name.', 'Error', MB_ICONERROR)
      end;
    end
    else
    begin
      Application.MessageBox('Cannot find the image file.', 'Error', MB_ICONERROR)
    end;
  end
  else
  begin
    Application.MessageBox('Cannot find the audio file.', 'Error', MB_ICONERROR)
  end;
end;

procedure TImageAudiotoVideoForm.StopBtnClick(Sender: TObject);
begin
  if FEncoder.ProcessID > 0 then
  begin
    FEncoder.Stop;
    PosTimer.Enabled := False;
    ProgressBar.Position := 0;
    ProgressLabel.Caption := '0%';
    FDuration := '0';
    NormalState;
  end;
end;

end.

