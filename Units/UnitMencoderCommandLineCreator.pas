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
unit UnitMencoderCommandLineCreator;

interface

uses Classes, Windows, SysUtils, Messages, Dialogs, StrUtils, UnitEffects, UnitSubtitleTypes;

type
  TMencoderCommandLine = record
    SinglePassCMD: string;
    FirstPassCMD: string;
    SeconPassCMD: string;
  end;

const
  Mencoder1stPass = ':vpass=1:turbo';
  Mencoder2ndPass = ':vpass=2';
  MencoderXvid1stPass = ':pass=1:turbo';
  MencoderXvid2ndPass = ':pass=2';

type
  TMencoderCommandLineCreator = class(TObject)
  private
    FFileName: string;
    FPassStr: string;
    FOutputFile: string;
    FFileIndex: integer;
    function CreateCommandline(): TMencoderCommandLine;
    function CreateFileName(const FileName: string; const Extension: string): string;
    function GetFileFolderName(const FileName: string): string;
    function CreateRangeCMD(StartTime, EndTime: Integer): string;
    function GetSubtitleEncoding(EncodingIndex: Integer): string;
    function CreateAdvancedOptions(): string;
  public

    property CommandLines: TMencoderCommandLine read CreateCommandline;
    property OutputFile: string read FOutputFile;
    constructor Create(const FileIndex: integer);
    destructor Destroy; override;
  end;

implementation

uses UnitAdvancedOptions, UnitMain, UnitSettings;

{ TMencoderCommandLineCreator }

constructor TMencoderCommandLineCreator.Create(const FileIndex: integer);
begin
  inherited Create;
  FFileIndex := FileIndex;
  FFileName := MainForm.FMasterFileInfoList[FileIndex].FilePath;
end;

function TMencoderCommandLineCreator.CreateAdvancedOptions: string;
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
                AdvancedCMD := AdvancedCMD + ':profile=baseline';
              2:
                AdvancedCMD := AdvancedCMD + ':profile=main';
              3:
                AdvancedCMD := AdvancedCMD + ':profile=high';
              4:
                AdvancedCMD := AdvancedCMD + ':profile=high10';
              5:
                AdvancedCMD := AdvancedCMD + ':profile=high422';
              6:
                AdvancedCMD := AdvancedCMD + ':profile=high444';
            end;

            // presets
            case x264PresetList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ':preset=ultrafast';
              2:
                AdvancedCMD := AdvancedCMD + ':preset=superfast';
              3:
                AdvancedCMD := AdvancedCMD + ':preset=veryfast';
              4:
                AdvancedCMD := AdvancedCMD + ':preset=faster';
              5:
                AdvancedCMD := AdvancedCMD + ':preset=fast';
              6:
                AdvancedCMD := AdvancedCMD + ':preset=medium';
              7:
                AdvancedCMD := AdvancedCMD + ':preset=slow';
              8:
                AdvancedCMD := AdvancedCMD + ':preset=slower';
              9:
                AdvancedCMD := AdvancedCMD + ':preset=veryslow';
              10:
                AdvancedCMD := AdvancedCMD + ':preset=placebo';
            end;

            // tune
            case x264TuneList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ':tune=film';
              2:
                AdvancedCMD := AdvancedCMD + ':tune=animation';
              3:
                AdvancedCMD := AdvancedCMD + ':tune=grain';
              4:
                AdvancedCMD := AdvancedCMD + ':tune=stillimage';
              5:
                AdvancedCMD := AdvancedCMD + ':tune=psnr';
              6:
                AdvancedCMD := AdvancedCMD + ':tune=ssim';
              7:
                AdvancedCMD := AdvancedCMD + ':tune=fastdecode';
              8:
                AdvancedCMD := AdvancedCMD + ':tune=zerolatency';
            end;

            // level
            if x264LevelList.ItemIndex > 0 then
            begin
              AdvancedCMD := AdvancedCMD + ':level=' + ReplaceStr(x264LevelList.Text, '.', '');
            end;
            Delete(AdvancedCMD, 1, 1);
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
        AdvancedCMD := '';
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

function TMencoderCommandLineCreator.CreateCommandline: TMencoderCommandLine;
var
  VBitrate: string;
  // VSize: string;
  VCodecPart1: string;
  VCodecPart2: string;
  VFPS: string;
  VAspect: string;
  Abitrate: string;
  ACodec: string;
  ASR: string;
  AChan: string;
  SubtitleCMD: string;
  OutExtension: string;
  SubEncoding: string;
  AudioCMD: string;
  PassFile: string;
  OutName: string;
  Container: string;
  AudioDelayCMD: string;
  FilterCMD: string;
  LVolumeCMD: string;
  CustomAudioArg, CustomVideoArg, CustomArg: string;
  LVideoID: string;
begin

  if AdvancedOptionsForm.CustomMEncoderVideoBtn.Checked then
  begin
    CustomVideoArg := AdvancedOptionsForm.CustomMEncoderVideoEdit.Text;
  end
  else
  begin
    CustomVideoArg := '';
  end;
  if AdvancedOptionsForm.CustomMEncoderAudioBtn.Checked then
  begin
    CustomAudioArg := AdvancedOptionsForm.CustomMEncoderAudioEdit.Text;
  end
  else
  begin
    CustomAudioArg := '';
  end;

  CustomArg := CustomArg + ' ' + AdvancedOptionsForm.CustomMencoderEdit.Text;

  with MainForm do
  begin

    if FMasterFileInfoList[FFileIndex].MEncoderVideoID > -1 then
    begin
      LVideoID := ' -vid ' + FloatToStr(FMasterFileInfoList[FFileIndex].MEncoderVideoID) + ' '
    end;

    // output extension and container options
    Container := 'avi';
    OutExtension := '.avi';

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
          // mp4
          Container := 'matroska ';
          OutExtension := '.avi';
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

    // direct copy
    if VideoEncoderList.ItemIndex = 10 then
    begin
      case ContainerList.ItemIndex of
        0:
          begin
            OutExtension := '.avi'; // avi
          end;
        1:
          begin
            OutExtension := '.mpeg';
          end;
        2:
          begin
            OutExtension := '.avi'; // mp4
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

    // avi, mpeg and rest for mencoder
    case ContainerList.ItemIndex of
      0:
        Container := ' -of avi ';
      1:
        Container := ' -of mpeg ';
    else
      begin
        // wmv
        if ContainerList.ItemIndex = 6 then
        begin
          Container := '';
        end
        // mp4 and webm
        else if (ContainerList.ItemIndex = 2) or (ContainerList.ItemIndex = 7) then
        begin
          Container := ' -of avi ' // mp4
        end
        else
        begin
          Container := ' -of lavf -lavfopts format=' + Container + ' ';
        end;
      end;
    end;

    // audio options
    Abitrate := AdvancedOptionsForm.AudioBitrateList.Text;

    if AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 7 then
    begin
      ASR := ' -srate ' + AdvancedOptionsForm.AudioSampleRateList.Text
    end
    else
    begin
      ASR := ' ';
    end;

    AudioDelayCMD := ' -delay ' + StringReplace(FloatToStr(FMasterFileInfoList[FFileIndex].AudioDelay), ',', '.', []) + ' ';

    // audio channels
    case AdvancedOptionsForm.AudioChannelsList.ItemIndex of
      0:
        begin
          AChan := ' -channels 1 '
        end;
      1:
        begin
          AChan := ' -channels 2 '
        end;
      2:
        begin
          AChan := ' -channels 6 '
        end;
      3:
        begin
          AChan := ' '
        end;
    end;

    // codec
    if EffectForm.VolumeEnableBtn.Checked then
    begin
      LVolumeCMD := ' -af-add volume=' + EffectForm.VolumeMencoderEdit.Text + ':0';
    end;

    case AudioEncoderList.ItemIndex of
      0: // copy
        begin
          ACodec := ' -oac  copy ' + CustomAudioArg + AudioDelayCMD;
        end;
      1: // mp3
        begin
          ACodec := ASR + ' -oac  mp3lame -lameopts cbr:br=' + Abitrate + ':' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
        end;
      2: // aac
        begin
          ACodec := ASR + ' -oac lavc -lavcopts acodec=libfdk_aac:abitrate=' + Abitrate + ':' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
        end;
      3: // ogg
        begin
          // ACodec := ASR + ' -oac  lavc -lavcopts acodec=libvorbis:abitrate=' + Abitrate + ':' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
          ACodec := ASR + ' -oac  pcm ' + AudioDelayCMD + LVolumeCMD;
        end;
      4: // wav
        begin
          ACodec := ASR + ' -oac  pcm ' + AudioDelayCMD + LVolumeCMD;
        end;
      5: // ac3
        begin
          ACodec := ASR + ' -oac  lavc -lavcopts acodec=ac3:abitrate=' + Abitrate + ':' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
        end;
      6: // mp2
        begin
          ACodec := ASR + ' -oac  lavc -lavcopts acodec=mp2:abitrate=' + Abitrate + ':' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
        end;
      7: // wmav2
        begin
          ACodec := ASR + ' -oac  lavc -lavcopts acodec=wmav2:abitrate=' + Abitrate + ':' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
        end;
      8: // speex
        begin
          ACodec := ASR + ' ' + LVolumeCMD;
        end;
      10: // none
        begin
          ACodec := ' -nosound ';
        end;
      11: // flac
        begin
          ACodec := ASR + ' -oac  lavc -lavcopts acodec=flac:' + CustomAudioArg + AChan + AudioDelayCMD + LVolumeCMD;
        end;
    end;

    // Video Options

    // bitrate
    VBitrate := AdvancedOptionsForm.VideobitrateList.Text;

    FilterCMD := '';
    // crop
    if EffectForm.CropEnable.Checked then
    begin
      FilterCMD := FilterCMD + ' -vf-add crop=' + EffectForm.CropWidthEdit.Text + ':' + EffectForm.CropHeightEdit.Text + ':' + EffectForm.CropXEdit.Text + ':' + EffectForm.CropYEdit.Text;
    end;

    // video size
    if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := ' -vf-add scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := ' -vf-add scale=' + AdvancedOptionsForm.WidthEdit.Text + ':-2';
      end;
    end
    else
    begin
      FilterCMD := ' '
    end;

    // rotate
    if EffectForm.RotateList.ItemIndex > 0 then
    begin
      FilterCMD := FilterCMD + ' -vf-add rotate=' + FloatToStr(EffectForm.RotateList.ItemIndex - 1);
    end;

    // deint
    if EffectForm.DeintEnblBtn.Checked then
    begin
      if Length(CreateDeintCMD(False)) > 0 then
      begin
        FilterCMD := FilterCMD + ' -vf-add ' + CreateDeintCMD(False);
      end;
    end;

    // comamnd line for FPS
    if AdvancedOptionsForm.VideoFPSList.ItemIndex = 0 then
    begin
      VFPS := ''; // auto
    end
    else
    begin
      VFPS := ' -ofps ' + AdvancedOptionsForm.VideoFPSList.Text;
    end;

    // command line for aspect ratio
    case AdvancedOptionsForm.VideoAspectRatioList.ItemIndex of
      0:
        VAspect := '';
      1:
        VAspect := ':aspect=4/3';
      2:
        VAspect := ':aspect=16/9';
      3:
        VAspect := ':aspect=1.85/1';
      4:
        VAspect := ':aspect=2.35/1';
      5:
        VAspect := ':aspect=1.3333/1';
      6:
        VAspect := ':aspect=1.7777/1';
    end;

    // command line for video encoder
    case VideoEncoderList.ItemIndex of
      0: // mpeg 1
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc lavc -lavcopts vcodec=mpeg1video:vbitrate=' + VBitrate + MainForm.ThreadCMD(0);
          VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      1: // mpeg 2
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=mpeg2video:vbitrate=' + VBitrate + MainForm.ThreadCMD(0);
          VCodecPart2 := VAspect + ':vrc_buf_size=1835:vstrict=0' + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      2: // xvid
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc xvid -xvidencopts bitrate=' + VBitrate + MainForm.ThreadCMD(0);
          if (Length(VAspect) > 0) or (Length(CustomVideoArg) > 0) then
            VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      3: // mpeg 4
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=mpeg4:vbitrate=' + VBitrate + MainForm.ThreadCMD(0);
          VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
          // ' -of lavf -lavfopts format=mp4 ';
        end;
      4: // h264
        begin
          if AdvancedOptionsForm.x264CRFBtn.Checked and AdvancedOptionsForm.x264Btn.Checked then
          begin
            VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc x264 -x264encopts crf=' + StringReplace(AdvancedOptionsForm.x264CRFEdit.Text, ',', '.', []) + MainForm.ThreadCMD(0);
            VCodecPart2 := '' + ':' + CustomVideoArg + CreateAdvancedOptions;
          end
          else
          begin
            VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc x264 -x264encopts bitrate=' + VBitrate + MainForm.ThreadCMD(0);
            VCodecPart2 := '' + ':' + CustomVideoArg + CreateAdvancedOptions;
          end;
          // ' -of lavf -lavfopts format=mp4 ';
        end;
      5: // flv
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=flv:vbitrate=' + VBitrate;
          VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      6: // wmv
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=wmv2:vbitrate=' + VBitrate;
          VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      7: // vp8
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ffourcc VP80 -ovc lavc -lavcopts  vcodec=libvpx:vbitrate=' + VBitrate + MainForm.ThreadCMD(0);
          VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      8: // huffyuv
        begin
          VCodecPart1 := LVideoID + FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=ffvhuff' + MainForm.ThreadCMD(0);
          VCodecPart2 := VAspect + ':' + CustomVideoArg + CreateAdvancedOptions;
        end;
      10: // copy
        begin
          VCodecPart1 := LVideoID + ' -ovc copy ' + CustomVideoArg + CreateAdvancedOptions;
        end;
    end;

    if DoTwoPassBtn.Checked then
    begin
      OutName := CreateFileName(FFileName, OutExtension);
      // create temp folder for x264
      // if VideoEncoderList.ItemIndex = 4 then
      if ContainerList.ItemIndex = 2 then
      begin
        CreateDir(ExtractFileDir(OutName));
        OutName := ExtractFileDir(OutName) + '\' + ExtractFileName(OutName);
      end;

      // pass log file
      PassFile := FAppDataFolder + ExtractFileName(ChangeFileExt(FFileName, '.log'));

      // subtitle options
      if EnableSubBtn.Checked then
      begin
        case FMasterFileInfoList[FFileIndex].SelectedSubtitleType of
          subfile:
            begin
              if FileExists(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile) then
              begin
                // char encoding
                SubEncoding := GetSubtitleEncoding(SettingsForm.LangIdList.ItemIndex);
                // if user selects to use ass or ssa styles instead of options
                if SettingsForm.SubSSABtn.Checked and ((LowerCase(ExtractFileExt(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile)) = '.ass') or
                  (LowerCase(ExtractFileExt(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile)) = '.ssa')) then
                begin
                  SubtitleCMD := ' -ass -sub "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '" -ass-styles "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '"'
                end
                else
                begin
                  SubtitleCMD := ' -subfont-autoscale ' + FloatToStr(SettingsForm.AutoScaleList.ItemIndex) + ' -subfont-blur 2 -subfont-outline 2 -subfont "' +
                    SettingsForm.FFontInfos[SettingsForm.FontList.ItemIndex].FontFilePath + '" -subcp ' + SubEncoding + ' -subpos ' + FloatToStr(SettingsForm.SubposBar.Position) +
                    ' -subfont-text-scale ' + SettingsForm.DefScaleEdit.Text + ' -sub "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '"';

                  // subtitle delay
                  if FMasterFileInfoList[FFileIndex].SubtitleDelay <> 0 then
                  begin
                    SubtitleCMD := SubtitleCMD + ' -subdelay ' + FloatToStr(FMasterFileInfoList[FFileIndex].SubtitleDelay);
                  end;
                end;
              end
              else
              begin
                SubtitleCMD := ' -nosub ';
              end;
            end;
          embedded:
            begin
              if FMasterFileInfoList[FFileIndex].SubtitleTrackIndex > -1 then
              begin
                SubtitleCMD := ' -sid ' + FMasterFileInfoList[FFileIndex].SelectedSubtitleTrack
              end
              else
              begin
                SubtitleCMD := ' -nosub '
              end;
            end;
        end;
      end
      else
      begin
        SubtitleCMD := ' -nosub ';
      end;

      if (VideoEncoderList.ItemIndex = 2) or (VideoEncoderList.ItemIndex = 4) then
      begin
        FPassStr := MencoderXvid1stPass
      end
      else
      begin
        FPassStr := Mencoder1stPass
      end;
      Result.FirstPassCMD := CreateRangeCMD(FMasterFileInfoList[FFileIndex].StartPosition, FMasterFileInfoList[FFileIndex].EndPosition) + ' -mc 0 -priority idle ' + VCodecPart1 + FPassStr +
        VCodecPart2 + Container + ' -passlogfile "' + PassFile + '" -nosound -o NUL "' + FFileName + '"';

      OutName := CreateFileName(FFileName, OutExtension);
      // create temp folder for x264
      // if VideoEncoderList.ItemIndex = 4 then
      if ContainerList.ItemIndex = 2 then
      begin
        CreateDir(ExtractFileDir(OutName));
        OutName := ExtractFileDir(OutName) + '\' + ExtractFileName(OutName);
      end;

      // pass log file
      PassFile := FAppDataFolder + ExtractFileName(ChangeFileExt(FFileName, '.log'));

      // audio track selection
      if FMasterFileInfoList[FFileIndex].AudioIndex < 0 then
      begin
        AudioCMD := ' ';
      end
      else
      begin
        AudioCMD := ' -aid ' + FMasterFileInfoList[FFileIndex].SelectedMEncoderAudio + ' ';
      end;

      if AdvancedOptionsForm.MPEGAudioIDBtn.Checked and ((LowerCase(ExtractFileExt(FFileName)) = '.mpeg') or (LowerCase(ExtractFileExt(FFileName)) = '.mpg') or
        (LowerCase(ExtractFileExt(FFileName)) = '.vob')) then
      begin
        AudioCMD := ' ';
      end;

      // subtitle options
      if EnableSubBtn.Checked then
      begin
        case FMasterFileInfoList[FFileIndex].SelectedSubtitleType of
          subfile:
            begin
              if FileExists(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile) then
              begin
                // char encoding
                SubEncoding := GetSubtitleEncoding(SettingsForm.LangIdList.ItemIndex);
                // if user selects to use ass or ssa styles instead of options
                if SettingsForm.SubSSABtn.Checked and ((LowerCase(ExtractFileExt(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile)) = '.ass') or
                  (LowerCase(ExtractFileExt(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile)) = '.ssa')) then
                begin
                  SubtitleCMD := ' -ass -sub "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '" -ass-styles "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '"'
                end
                else
                begin
                  SubtitleCMD := ' -subfont-autoscale ' + FloatToStr(SettingsForm.AutoScaleList.ItemIndex) + ' -subfont-blur 2 -subfont-outline 2 -subfont "' +
                    SettingsForm.FFontInfos[SettingsForm.FontList.ItemIndex].FontFilePath + '" -subcp ' + SubEncoding + ' -subpos ' + FloatToStr(SettingsForm.SubposBar.Position) +
                    ' -subfont-text-scale ' + SettingsForm.DefScaleEdit.Text + ' -sub "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '"';

                  // subtitle delay
                  if FMasterFileInfoList[FFileIndex].SubtitleDelay <> 0 then
                  begin
                    SubtitleCMD := SubtitleCMD + ' -subdelay ' + FloatToStr(FMasterFileInfoList[FFileIndex].SubtitleDelay);
                  end;
                end;
              end
              else
              begin
                SubtitleCMD := ' -nosub ';
              end;
            end;
          embedded:
            begin
              if FMasterFileInfoList[FFileIndex].SubtitleTrackIndex > -1 then
              begin
                SubtitleCMD := ' -sid ' + FMasterFileInfoList[FFileIndex].SelectedSubtitleTrack
              end
              else
              begin
                SubtitleCMD := ' -nosub '
              end;
            end;
        end;
      end
      else
      begin
        SubtitleCMD := ' -nosub ';
      end;

      if (VideoEncoderList.ItemIndex = 2) or (VideoEncoderList.ItemIndex = 4) then
      begin
        FPassStr := MencoderXvid2ndPass
      end
      else
      begin
        FPassStr := Mencoder2ndPass
      end;

      Result.SeconPassCMD := CreateRangeCMD(FMasterFileInfoList[FFileIndex].StartPosition, FMasterFileInfoList[FFileIndex].EndPosition) + ' -mc 0 -priority idle ' + AudioCMD + VCodecPart1 + FPassStr +
        VCodecPart2 + Container + ACodec + SubtitleCMD + ' -passlogfile "' + PassFile + '" -o "' + OutName + '" "' + FFileName + '"';
    end
    else
    begin
      OutName := CreateFileName(FFileName, OutExtension);
      // create temp folder for x264
      // if VideoEncoderList.ItemIndex = 4 then
      if ContainerList.ItemIndex = 2 then
      begin
        CreateDir(ExtractFileDir(OutName));
        OutName := ExtractFileDir(OutName) + '\' + ExtractFileName(OutName);
      end;

      // audio track selection
      if FMasterFileInfoList[FFileIndex].AudioIndex < 0 then
      begin
        AudioCMD := ' ';
      end
      else
      begin
        AudioCMD := ' -aid ' + FMasterFileInfoList[FFileIndex].SelectedMEncoderAudio + ' ';
      end;

      if AdvancedOptionsForm.MPEGAudioIDBtn.Checked and ((LowerCase(ExtractFileExt(FFileName)) = '.mpeg') or (LowerCase(ExtractFileExt(FFileName)) = '.mpg') or
        (LowerCase(ExtractFileExt(FFileName)) = '.vob')) then
      begin
        AudioCMD := ' ';
      end;

      // subtitle options
      if EnableSubBtn.Checked then
      begin
        case FMasterFileInfoList[FFileIndex].SelectedSubtitleType of
          subfile:
            begin
              if FileExists(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile) then
              begin
                // char encoding
                SubEncoding := GetSubtitleEncoding(SettingsForm.LangIdList.ItemIndex);
                // if user selects to use ass or ssa styles instead of options
                if SettingsForm.SubSSABtn.Checked and ((LowerCase(ExtractFileExt(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile)) = '.ass') or
                  (LowerCase(ExtractFileExt(FMasterFileInfoList[FFileIndex].SelectedSubtitleFile)) = '.ssa')) then
                begin
                  SubtitleCMD := ' -ass -sub "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '" -ass-styles "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '"'
                end
                else
                begin
                  SubtitleCMD := ' -subfont-autoscale ' + FloatToStr(SettingsForm.AutoScaleList.ItemIndex) + ' -subfont-blur 2 -subfont-outline 2 -subfont "' +
                    SettingsForm.FFontInfos[SettingsForm.FontList.ItemIndex].FontFilePath + '" -subcp ' + SubEncoding + ' -subpos ' + FloatToStr(SettingsForm.SubposBar.Position) +
                    ' -subfont-text-scale ' + SettingsForm.DefScaleEdit.Text + ' -sub "' + FMasterFileInfoList[FFileIndex].SelectedSubtitleFile + '"';

                  // subtitle delay
                  if FMasterFileInfoList[FFileIndex].SubtitleDelay <> 0 then
                  begin
                    SubtitleCMD := SubtitleCMD + ' -subdelay ' + FloatToStr(FMasterFileInfoList[FFileIndex].SubtitleDelay);
                  end;
                end;
              end
              else
              begin
                SubtitleCMD := ' -nosub ';
              end;
            end;
          embedded:
            begin
              if FMasterFileInfoList[FFileIndex].SubtitleTrackIndex > -1 then
              begin
                SubtitleCMD := ' -sid ' + FMasterFileInfoList[FFileIndex].SelectedSubtitleTrack
              end
              else
              begin
                SubtitleCMD := ' -nosub '
              end;
            end;
        end;
      end
      else
      begin
        SubtitleCMD := ' -nosub ';
      end;

      Result.SinglePassCMD := CreateRangeCMD(FMasterFileInfoList[FFileIndex].StartPosition, FMasterFileInfoList[FFileIndex].EndPosition) + ' -mc 0 -priority idle ' + AudioCMD + VCodecPart1 +
        VCodecPart2 + Container + SubtitleCMD + ACodec + ' -o "' + OutName + '" "' + FFileName + '"';
    end;

  end;

end;

function TMencoderCommandLineCreator.CreateFileName(const FileName, Extension: string): string;
var
  FileIndex: Integer;
  OutFileName: string;
  TmpStr: string;
begin

  OutFileName := ChangeFileExt(FFileName, Extension);

  // same as source
  if not MainForm.UseSourceChkBtn.Checked then
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
      OutFileName := ChangeFileExt(OutFileName, '_' + FloatToStr(FileIndex) + Extension);
    end;
  end;

  FOutputFile := OutFileName;
  Result := OutFileName;
end;

function TMencoderCommandLineCreator.CreateRangeCMD(StartTime, EndTime: Integer): string;
begin
  Result := ' ';
  if not SettingsForm.DontTrimBtn.Checked then
  begin
    if EndTime <> StartTime then
      Result := ' -ss ' + IntToStr(StartTime) + ' -endpos ' + IntToStr(EndTime - StartTime);
  end;
end;

destructor TMencoderCommandLineCreator.Destroy;
begin
  inherited;

end;

function TMencoderCommandLineCreator.GetFileFolderName(const FileName: string): string;
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

function TMencoderCommandLineCreator.GetSubtitleEncoding(EncodingIndex: Integer): string;
begin

  Result := 'Unicode';
  // Language option
  case EncodingIndex of
    0:
      Result := 'Unicode';
    1:
      Result := 'UTF-8';
    2:
      Result := 'ISO-8859-1';
    3:
      Result := 'ISO-8859-15';
    4:
      Result := 'ISO-8859-2';
    5:
      Result := 'ISO-8859-3';
    6:
      Result := 'ISO-8859-4';
    7:
      Result := 'ISO-8859-5';
    8:
      Result := 'ISO-8859-6';
    9:
      Result := 'ISO-8859-7';
    10:
      Result := 'ISO-8859-9';
    11:
      Result := 'ISO-8859-13';
    12:
      Result := 'ISO-8859-14';
    13:
      Result := 'ISO-8859-8';
    14:
      Result := 'KO18-R';
    15:
      Result := 'KO18-U/RU';
    16:
      Result := 'CP936';
    17:
      Result := 'BIG5';
    18:
      Result := 'SHIFT-JIS';
    19:
      Result := 'CP949';
    20:
      Result := 'CP874';
    21:
      Result := 'CP1251';
    22:
      Result := 'CP1250';
    23:
      Result := 'CP1256';
  end;

end;

end.
