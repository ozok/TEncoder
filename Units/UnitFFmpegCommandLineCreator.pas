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
unit UnitFFmpegCommandLineCreator;

interface

uses Classes, Windows, SysUtils, Dialogs, MediaInfoDLL, StrUtils, UnitEffects;

type
  TFFMpegCommandLine = record
    SinglePassCMD: string;
    FirstPassCMD: string;
    SeconPassCMD: string;
  end;

type
  TFFMpegCommandLineCreator = class(TObject)
  private
    FFileName: string;
    FOutputFileName: string;
    FFileIndex: integer;
    function CreateCommandline(): TFFMpegCommandLine;
    function CreateFileName(const FileName: string; const Extension: string): string;
    function GetFileFolderName(const FileName: string): string;
    function CreateRangeCMD(StartTime, EndTime: Integer): string;
    function IntegerToTime(Time: Integer): string;

    function IsStringNumeric(Str: String): Boolean;
    function IsAudioOnly(const FileName: string): Boolean;
    function CreateAdvancedOptions(): string;
  public

    function IsAudioFile: Boolean;
    property FMpegCommandLine: TFFMpegCommandLine read CreateCommandline;
    property OutputFile: string read FOutputFileName;
    property IsAudioOnlyfile: Boolean read IsAudioFile;
    constructor Create(const FileIndex: integer);
    destructor Destroy; override;
  end;

implementation

uses UnitAdvancedOptions, UnitMain, UnitSettings;

{ TFFMpegCommandLineCreator }

constructor TFFMpegCommandLineCreator.Create(const FileIndex: integer);
begin
  inherited Create;

  FFileName := MainForm.ConvertItems[FileIndex].FilePath;
  FFileIndex := FileIndex;
end;

function TFFMpegCommandLineCreator.CreateAdvancedOptions: string;
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
  end;

  Result := AdvancedCMD;
end;

function TFFMpegCommandLineCreator.CreateCommandline: TFFMpegCommandLine;
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
  PassFile: string;
  OutName: string;
  Container: string;
  AudioDelayCMD: string;
  FilterCMD: string;
  LVolumeCMD: string;
  CustomVideoArg: string;
  CustomAudioArg: string;
  CustomArgs: string;
begin
  // output extension and container options
  Container := 'avi';
  OutExtension := '.avi';
  if AdvancedOptionsForm.CustomFFMpegVideoBtn.Checked then
  begin
    CustomVideoArg := AdvancedOptionsForm.CustomFFMpegVideoEdit.Text;
  end
  else
  begin
    CustomVideoArg := '';
  end;
  if AdvancedOptionsForm.CustomFFMpegAudioBtn.Checked then
  begin
    CustomAudioArg := AdvancedOptionsForm.CustomFFMpegAudioEdit.Text;
  end
  else
  begin
    CustomAudioArg := '';
  end;

  CustomArgs := CustomArgs + ' ' + AdvancedOptionsForm.CustomFFmpegEdit.Text;

{$REGION 'container'}
  with MainForm do
  begin
    case ContainerList.ItemIndex of
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
{$ENDREGION}
    // wmv
    if (ContainerList.ItemIndex = 6) or (VideoEncoderList.ItemIndex = 11) then
    begin
      Container := '';
    end
    else
    begin
      Container := ' -f ' + Container;
    end;

{$REGION 'out ext'}
    if VideoEncoderList.ItemIndex = 10 then
    begin
      case ContainerList.ItemIndex of
        0:
          begin
            OutExtension := '.avi';
          end;
        1:
          begin
            OutExtension := '.mpeg';
          end;
        2:
          begin
            OutExtension := '.mp4';
          end;
        3:
          begin
            OutExtension := '.mov';
          end;
        4:
          begin
            OutExtension := '.mkv';
          end;
        5:
          begin
            OutExtension := '.flv';
          end;
        6:
          begin
            OutExtension := '.wmv';
          end;
        7:
          begin
            OutExtension := '.webm';
          end;
        8:
          begin
            OutExtension := '.avi';
          end;
      end;
    end;
{$ENDREGION}
{$REGION 'audio'}
    if ConvertItems[FFileIndex].AudioIndex > -1 then
    begin

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

      // codec
      case AudioEncoderList.ItemIndex of
        0: // copy
          begin
            ACodec := ' -acodec copy' + CustomAudioArg;
          end;
        1: // mp3
          begin
            ACodec := ' -acodec libmp3lame -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        2: // aac
          begin
            ACodec := ' -strict experimental -acodec aac -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
            // ACodec := ' -acodec libvo_aacenc -ab ' + Abitrate + 'k '
            // + ASR + AChan + ' ' + CustomAudioArg;
          end;
        3: // ogg
          begin
            ACodec := ' -acodec libvorbis -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        4: // wav
          begin
            ACodec := ' -acodec pcm_alaw';
          end;
        5: // ac3
          begin
            ACodec := ' -acodec ac3 -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        6: // mp2
          begin
            ACodec := ' -acodec mp2 -ab ' + Abitrate + 'k  ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        7: // wma2
          begin
            ACodec := ' -acodec wmav2 -ab ' + Abitrate + 'k  ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        8: // speex
          begin
            ACodec := ' -f ogg -acodec libspeex -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        9: // opus
          begin
            ACodec := ' -acodec libopus -ab ' + Abitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
        10: // none
          begin
            ACodec := ' -an ';
          end;
        11: // flac
          begin
            ACodec := ' -acodec flac -compression_level ' + AdvancedOptionsForm.FlacCompEdit.Text + ' ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
          end;
      end;
    end;
{$ENDREGION}
{$REGION 'video'}
    // if audio copy and video none
    // get file extension from file info
    if (VideoEncoderList.ItemIndex = 11) and (AudioEncoderList.ItemIndex = 0) then
    begin
      OutExtension := ConvertItems[FFileIndex].SelectedAudioExt;
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
      VHeight := AdvancedOptionsForm.HeightEdit.Text;
      VWidth := AdvancedOptionsForm.WidthEdit.Text;
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

    // deint
    if EffectForm.DeintEnblBtn.Checked then
    begin
      FilterCMD := FilterCMD + MainForm.CreateDeintCMD(False);
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

    CustomVideoArg := ' ' + CustomVideoArg;
    CustomAudioArg := ' ' + CustomAudioArg;

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
    case VideoEncoderList.ItemIndex of
      0: // mpeg 1
        begin
          VCodec := ' -vcodec mpeg1video ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      1: // mpeg 2
        begin
          VCodec := ' -vcodec mpeg2video ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      2: // xvid
        begin
          VCodec := ' -vcodec libxvid ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      3: // mpeg 4
        begin
          VCodec := ' -vcodec mpeg4 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      4: // h264
        begin
          if AdvancedOptionsForm.x264CRFBtn.Checked and AdvancedOptionsForm.x264Btn.Checked then
          begin
            VCodec := ' -vcodec libx264 ' + ' -crf ' + StringReplace(AdvancedOptionsForm.x264CRFEdit.Text, ',', '.', []) + ' ' + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
          end
          else
          begin
            VCodec := ' -vcodec libx264 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
          end;
        end;
      5: // flv
        begin
          VCodec := ' -vcodec flv ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      6: // wmv
        begin
          VCodec := VFPS + ' -vcodec wmv2 ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + VSize + CreateAdvancedOptions + CustomVideoArg;
        end;
      7: // vp8
        begin
          VCodec := ' -vcodec libvpx ' + ' -b:v ' + VBitrate + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      8: // huffyuv
        begin
          VCodec := ' -vcodec huffyuv ' + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      9: // prores
        begin
          VCodec := ' -vcodec prores ' + VAspect + VFPS + FilterCMD + CreateAdvancedOptions + CustomVideoArg;
        end;
      10: // copy
        begin
          VCodec := ' -vcodec copy' + CustomVideoArg;
        end;
      11: // none
        begin
          VCodec := ' -vn ';
        end;
    end;
{$ENDREGION}
    // audio only source
    if ConvertItems[FFileIndex].FFMmpegVideoID = -1 then
    begin
      VCodec := ' -vn ';

      case AudioEncoderList.ItemIndex of
        1:
          OutExtension := '.mp3';
        2:
          OutExtension := '.m4a';
        3:
          OutExtension := '.ogg';
        4:
          OutExtension := '.wav';
        5:
          OutExtension := '.ac3';
        6:
          OutExtension := '.mp2';
        7:
          OutExtension := '.wma';
        8:
          OutExtension := '.spx';
        9:
          OutExtension := '.opus';
        11:
          OutExtension := '.flac';
      end;
    end;

    if DoTwoPassBtn.Checked then
    begin
      // two passes encoding
      // first pass
      // for copy each extension must be defined
      // indivually
      if VideoEncoderList.ItemIndex = 9 then
      begin
        // OutExtension := ExtractFileExt(FFileName);
      end;

      OutName := CreateFileName(FFileName, OutExtension);

      // pass log file
      PassFile := AppDataFolder + ExtractFileName(ChangeFileExt(FFileName, '.log'));

      Result.FirstPassCMD := ' -y ' + AudioDelayCMD + MainForm.ThreadCMD + ' -i "' + FFileName + '" -pass 1 -passlogfile "' + PassFile + '" ' + CreateRangeCMD(ConvertItems[FFileIndex].StartPosition, ConvertItems[FFileIndex].EndPosition) +
        VCodec + Container + ' -an "' + OutName + '"';

      // second pass
      // for copy each extension must be defined
      // indivually
      if VideoEncoderList.ItemIndex = 9 then
      begin
        // OutExtension := ExtractFileExt(FFileName);
      end;

      OutName := CreateFileName(FFileName, OutExtension);

      // pass log file
      PassFile := AppDataFolder + ExtractFileName(ChangeFileExt(FFileName, '.log'));

      // audio track selection
      if ConvertItems[FFileIndex].AudioIndex < 0 then
      begin
        AudioCMD := ' ';
      end
      else
      begin
        // audio delay
        if VideoEncoderList.ItemIndex = 11 then
        begin
          AudioDelayCMD := ' ';
        end
        else
        begin
          AudioDelayCMD := ' -itsoffset ' + StringReplace(FloatToStr(ConvertItems[FFileIndex].AudioDelay), ',', '.', []);
        end;

        // if video is none or there are no video streams
        if (VideoEncoderList.ItemIndex = 11) or (ConvertItems[FFileIndex].FFMmpegVideoID = -1) then
        begin
          AudioCMD := ' -map 0:' + ConvertItems[FFileIndex].SelectedAudio + ' ';
        end
        else
        begin
          if ConvertItems[FFileIndex].FFMmpegVideoID > -1 then
          begin
            AudioCMD := ' -map 0:0 -map 0:' + ConvertItems[FFileIndex].SelectedAudio + ' ';
          end
          else
          begin
            AudioCMD := ' -map 0:' + FloatToStr(ConvertItems[FFileIndex].FFMmpegVideoID) + ' -map 0:' + ConvertItems[FFileIndex].SelectedAudio + ' ';
          end;
        end;
      end;
      Result.SeconPassCMD := ' -y ' + AudioDelayCMD + MainForm.ThreadCMD + ' -i "' + FFileName + '" -pass 2 -passlogfile "' + PassFile + '" ' + CreateRangeCMD(ConvertItems[FFileIndex].StartPosition, ConvertItems[FFileIndex].EndPosition) +
        VCodec + Container + AudioCMD + ACodec + ' "' + OutName + '"';
    end
    else
    begin
      // single pass encoding
      // for copy each extension must be defined
      // indivually
      if VideoEncoderList.ItemIndex = 9 then
      begin
        // OutExtension := ExtractFileExt(FFileName);
      end
      // for audio only mode
      else if VideoEncoderList.ItemIndex = 11 then
      begin
        case AudioEncoderList.ItemIndex of
          1:
            OutExtension := '.mp3';
          2:
            OutExtension := '.m4a';
          3:
            OutExtension := '.ogg';
          4:
            OutExtension := '.wav';
          5:
            OutExtension := '.ac3';
          6:
            OutExtension := '.mp2';
          7:
            OutExtension := '.wma';
          8:
            OutExtension := '.spx';
          9:
            OutExtension := '.opus';
          11:
            OutExtension := '.flac';
        end;
      end;

      OutName := CreateFileName(FFileName, OutExtension);
      // audio track selection
      if ConvertItems[FFileIndex].AudioIndex < 0 then
      begin
        AudioCMD := ' ';
      end
      else
      begin
        // audio delay
        if VideoEncoderList.ItemIndex = 11 then
        begin
          AudioDelayCMD := ' ';
        end
        else
        begin
          AudioDelayCMD := ' -itsoffset ' + StringReplace(FloatToStr(ConvertItems[FFileIndex].AudioDelay), ',', '.', []);
        end;

        // if video is none
        if (VideoEncoderList.ItemIndex = 11) or (ConvertItems[FFileIndex].FFMmpegVideoID = -1) then
        begin
          AudioCMD := ' -map 0:' + (ConvertItems[FFileIndex].SelectedAudio) + ' ';
        end
        else
        begin
          if ConvertItems[FFileIndex].FFMmpegVideoID > -1 then
          begin
            AudioCMD := ' -map 0:0 -map 0:' + ConvertItems[FFileIndex].SelectedAudio + ' ';
          end
          else
          begin
            AudioCMD := ' -map 0:' + FloatToStr(ConvertItems[FFileIndex].FFMmpegVideoID) + ' -map 0:' + ConvertItems[FFileIndex].SelectedAudio + ' ';
          end;
        end;
      end;
      Result.SinglePassCMD := ' -y ' + AudioDelayCMD + MainForm.ThreadCMD + ' -i "' + FFileName + '" ' + CustomArgs + ' ' + CreateRangeCMD(ConvertItems[FFileIndex].StartPosition, ConvertItems[FFileIndex].EndPosition) + VCodec + Container +
        AudioCMD + ACodec + ' "' + OutName + '"';
    end;
  end;
end;

function TFFMpegCommandLineCreator.CreateFileName(const FileName: string; const Extension: string): string;
var
  FileIndex: Integer;
  OutFileName: string;
  TmpStr: string;
begin

  OutFileName := ChangeFileExt(FFileName, Extension);

  // same as source
  if MainForm.UseSourceChkBtn.Checked = False then
  begin
    if DirectoryExists(MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName)) then
    begin
      OutFileName := MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName) + '\' + ExtractFileName(OutFileName);
    end
    else
    begin
      if CreateDir(MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName)) then
      begin
        OutFileName := MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName) + '\' + ExtractFileName(OutFileName);
      end
      else
      begin
        OutFileName := MainForm.DirectoryEdit.Text + '\' + ExtractFileName(OutFileName);
      end;
    end;
  end
  else
  begin
    OutFileName := ChangeFileExt(ExtractFileDir(FFileName) + '\' + ExtractFileName(OutFileName), Extension);
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

  FOutputFileName := OutFileName;
  Result := OutFileName;

end;

function TFFMpegCommandLineCreator.CreateRangeCMD(StartTime, EndTime: Integer): string;
begin

  Result := ' ';
  if not SettingsForm.DontTrimBtn.Checked then
  begin
    if EndTime <> StartTime then
      Result := ' -ss ' + IntegerToTime(StartTime) + ' -t ' + IntegerToTime(EndTime - StartTime);
  end;

end;

destructor TFFMpegCommandLineCreator.Destroy;
begin
  inherited;

end;

function TFFMpegCommandLineCreator.GetFileFolderName(const FileName: string): string;
var
  TmpStr: string;
  i: integer;
  FolderName: string;
begin

  Result := '';
  if FileExists(FileName) and (not SettingsForm.FolderStructBtn.Checked) then
  begin
    TmpStr := ReverseString(ExtractFileDir(FileName));
    if TmpStr[1] = '\' then
    begin
      Delete(TmpStr, 1, 1);
    end;
    FolderName := '';
    for I := 1 to Length(TmpStr) do
    begin
      if TmpStr[i] <> '\' then
      begin
        FolderName := FolderName + TmpStr[i];
      end
      else
      begin
        Break;
      end;
    end;
    if Length(FolderName) > 0 then
    begin
      Result := ReverseString(FolderName);
    end;
  end;

end;

function TFFMpegCommandLineCreator.IntegerToTime(Time: Integer): string;
var
  hour: Integer;
  second: Integer;
  minute: Integer;
  strhour: String;
  strminute: String;
  strsecond: String;
begin

  if (Time > 0) then
  begin

    hour := Time div 3600;
    minute := (Time div 60) - (hour * 60);
    second := (Time mod 60);

    if (second < 10) then
    begin
      strsecond := '0' + FloatToStr(second);
    end
    else
    begin
      strsecond := FloatToStr(second);
    end;

    if (minute < 10) then
    begin
      strminute := '0' + FloatToStr(minute);
    end
    else
    begin
      strminute := FloatToStr(minute);
    end;

    if (hour < 10) then
    begin
      strhour := '0' + FloatToStr(hour);
    end
    else
    begin
      strhour := FloatToStr(hour);
    end;

    Result := strhour + ':' + strminute + ':' + strsecond;
  end
  else
  begin
    Result := '00:00:00';
  end;

end;

function TFFMpegCommandLineCreator.IsAudioFile: Boolean;
begin

  Result := IsAudioOnly(FFileName);

end;

function TFFMpegCommandLineCreator.IsAudioOnly(const FileName: string): Boolean;
var
  MediaInfoHandle: Cardinal;
  VideoCount: string;
begin

  Result := False;

  if (FileExists(FileName)) then
  begin

    // avs file exception
    if LowerCase(ExtractFileExt(FileName)) = '.avs' then
    begin
      Result := False;
    end
    else
    begin
      // New handle for mediainfo
      MediaInfoHandle := MediaInfo_New();

      if MediaInfoHandle <> 0 then
      begin

        try
          // Open a file in complete mode
          MediaInfo_Open(MediaInfoHandle, PWideChar(FileName));
          MediaInfo_Option(0, 'Complete', '1');

          VideoCount := Trim(MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'Count', Info_Text, Info_Name));

          if IsStringNumeric(VideoCount) then
          begin
            if StrToInt(VideoCount) > 0 then
            begin
              Result := False;
            end
            else
            begin
              Result := True;
            end;
          end
          else
          begin
            Result := True;
          end;

        finally
          MediaInfo_Close(MediaInfoHandle);
        end;

      end;

    end;

  end;

end;

function TFFMpegCommandLineCreator.IsStringNumeric(Str: String): Boolean;
var
  p: PChar;
begin

  if Length(Str) < 1 then
  begin
    Result := False;
    Exit;
  end;

  p := PChar(Str);
  Result := False;

  while p^ <> #0 do
  begin

    if (Not CharInSet(p^, ['0' .. '9'])) then
    begin
      Exit;
    end;

    Inc(p);
  end;

  Result := True;
end;

end.
