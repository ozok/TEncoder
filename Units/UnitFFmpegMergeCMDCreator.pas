{ *
  * Copyright (C) 2011-2015 ozok <ozok26@gmail.com>
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
unit UnitFFmpegMergeCMDCreator;

interface

uses
  Classes, Windows, SysUtils, Dialogs, MediaInfoDLL, StrUtils, UnitEffects, UnitFileInfoItem;

type
  TFFMpegMergeCMDCreator = class(TObject)
  private
    FOutputFileName: string;
    FFileList: TFileInfoList;
    function CreateCommandline(): string;
    function CreateFileName(const FileName: string; const Extension: string): string;
    function GetFileFolderName(const FileName: string): string;
    function IntegerToTime(Time: Integer): string;
    function IsStringNumeric(Str: string): Boolean;
    function CreateAdvancedOptions(): string;
  public
    property FMpegCommandLine: string read CreateCommandline;
    property OutputFile: string read FOutputFileName;
    constructor Create(const FileList: TFileInfoList; const OutputFilePath: string);
    destructor Destroy; override;
  end;

implementation

uses
  UnitAdvancedOptions, UnitMain, UnitSettings;

{ TFFMpegCommandLineCreator }

constructor TFFMpegMergeCMDCreator.Create(const FileList: TFileInfoList; const OutputFilePath: string);
begin
  inherited Create;

  FFileList := FileList;
  FOutputFileName := OutputFilePath;
end;

function TFFMpegMergeCMDCreator.CreateAdvancedOptions: string;
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
    12: // h265
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

function TFFMpegMergeCMDCreator.CreateCommandline: string;
var
  LVideoBitrate: string;
  LVideoDimensions: string;
  LVideoCodec: string;
  LVideoFPS: string;
  LVideoAspectRatio: string;
  LVideoHeight: string;
  LVideoWidth: string;
  LAudioBitrate: string;
  LAudioCodec: string;
  LAudioChannels: string;
  LOutputFileExtension: string;
  LAudioCommandLine: string;
  LPassFilePath: string;
  LOutputFileName: string;
  LContainer: string;
  LVolumeCMD: string;
  CustomVideoArg: string;
  CustomAudioArg: string;
  CustomArgs: string;
  LMergeCMD: string;
  LMergeVideoCMD: string;
  LMergeAudioCMD: string;
  LInputCMD: string;
  LConcatCMD: string;
  I: integer;
begin
  // output extension and container options
  LContainer := 'avi';
  LOutputFileExtension := '.avi';
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
          LContainer := 'avi ';
          LOutputFileExtension := '.avi';
        end;
      1:
        begin
          LContainer := 'mpeg ';
          LOutputFileExtension := '.mpeg';
        end;
      2:
        begin
          LContainer := 'mp4 ';
          LOutputFileExtension := '.mp4';
        end;
      3:
        begin
          LContainer := 'mov ';
          LOutputFileExtension := '.mov';
        end;
      4:
        begin
          LContainer := 'matroska ';
          LOutputFileExtension := '.mkv';
        end;
      5:
        begin
          LContainer := 'flv ';
          LOutputFileExtension := '.flv';
        end;
      6:
        begin
          LContainer := '';
          LOutputFileExtension := '.wmv';
        end;
      7:
        begin
          LContainer := 'webm ';
          LOutputFileExtension := '.webm';
        end;
      8:
        begin
          LContainer := '3gp ';
          LOutputFileExtension := '.3gp';
        end;
    end;
{$ENDREGION}
    // wmv
    if (ContainerList.ItemIndex = 6) or (VideoEncoderList.ItemIndex = 11) then
    begin
      LContainer := '';
    end
    else
    begin
      LContainer := ' -f ' + LContainer;
    end;

{$REGION 'out ext'}
    if VideoEncoderList.ItemIndex = 10 then
    begin
      case ContainerList.ItemIndex of
        0:
          begin
            LOutputFileExtension := '.avi';
          end;
        1:
          begin
            LOutputFileExtension := '.mpeg';
          end;
        2:
          begin
            LOutputFileExtension := '.mp4';
          end;
        3:
          begin
            LOutputFileExtension := '.mov';
          end;
        4:
          begin
            LOutputFileExtension := '.mkv';
          end;
        5:
          begin
            LOutputFileExtension := '.flv';
          end;
        6:
          begin
            LOutputFileExtension := '.wmv';
          end;
        7:
          begin
            LOutputFileExtension := '.webm';
          end;
        8:
          begin
            LOutputFileExtension := '.avi';
          end;
      end;
    end;
{$ENDREGION}
{$REGION 'audio'}
    LAudioBitrate := AdvancedOptionsForm.AudioBitrateList.Text;
      // audio channels
    case AdvancedOptionsForm.AudioChannelsList.ItemIndex of
      0:
        begin
          LAudioChannels := ' -ac 1 '
        end;
      1:
        begin
          LAudioChannels := ' -ac 2 '
        end;
      2:
        begin
          LAudioChannels := ' -ac 6 '
        end;
      3:
        begin
          LAudioChannels := ' '
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
          LAudioCodec := ' -c:a copy' + CustomAudioArg;
        end;
      1: // mp3
        begin
          LAudioCodec := ' -c:a libmp3lame -ab ' + LAudioBitrate + 'k ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      2: // aac
        begin
          LAudioCodec := ' -strict experimental -c:a aac -ab ' + LAudioBitrate + 'k ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
            // ACodec := ' -c:a libvo_aacenc -ab ' + Abitrate + 'k '
            // + ASR + AChan + ' ' + CustomAudioArg;
        end;
      3: // ogg
        begin
          LAudioCodec := ' -c:a libvorbis -ab ' + LAudioBitrate + 'k ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      4: // wav
        begin
          LAudioCodec := ' -c:a pcm_alaw';
        end;
      5: // ac3
        begin
          LAudioCodec := ' -c:a ac3 -ab ' + LAudioBitrate + 'k ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      6: // mp2
        begin
          LAudioCodec := ' -c:a mp2 -ab ' + LAudioBitrate + 'k  ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      7: // wma2
        begin
          LAudioCodec := ' -c:a wmav2 -ab ' + LAudioBitrate + 'k  ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      8: // speex
        begin
          LAudioCodec := ' -f ogg -c:a libspeex -ab ' + LAudioBitrate + 'k ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      9: // opus
        begin
          LAudioCodec := ' -c:a libopus -ab ' + LAudioBitrate + 'k ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
      10: // none
        begin
          LAudioCodec := ' -an ';
        end;
      11: // flac
        begin
          LAudioCodec := ' -c:a flac -compression_level ' + AdvancedOptionsForm.FlacCompEdit.Text + ' ' + LAudioChannels + LVolumeCMD + ' ' + CustomAudioArg;
        end;
    end;

{$ENDREGION}
{$REGION 'video'}

    // Video Options

    // bitrate
    LVideoBitrate := AdvancedOptionsForm.VideobitrateList.Text + 'k ';

    // do cbr encoding
    if AdvancedOptionsForm.VideoCBrBtn.Checked then
    begin
      LVideoBitrate := LVideoBitrate + ' -minrate ' + LVideoBitrate + ' -maxrate ' + LVideoBitrate + ' -bufsize ' + IntToStr(StrToInt(Trim(LVideoBitrate)) * 2) + ' -muxrate ' + IntToStr(StrToInt(Trim(LVideoBitrate)) * 2) + ' ';
    end;

    // video size
    if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
    begin
      LVideoHeight := AdvancedOptionsForm.HeightEdit.Text;
      LVideoWidth := AdvancedOptionsForm.WidthEdit.Text;
    end;

    // FPS
    if AdvancedOptionsForm.VideoFPSList.ItemIndex = 0 then
    begin
      LVideoFPS := ' '; // auto
    end
    else
    begin
      LVideoFPS := ' -r ' + AdvancedOptionsForm.VideoFPSList.Text;
    end;

    CustomVideoArg := ' ' + CustomVideoArg;
    CustomAudioArg := ' ' + CustomAudioArg;

    // command line for aspect ratio
    case AdvancedOptionsForm.VideoAspectRatioList.ItemIndex of
      0:
        LVideoAspectRatio := '';
      1:
        LVideoAspectRatio := '-aspect 4:3';
      2:
        LVideoAspectRatio := '-aspect 16:9';
      3:
        LVideoAspectRatio := '-aspect 1.85';
      4:
        LVideoAspectRatio := '-aspect 2.35';
      5:
        LVideoAspectRatio := '-aspect 1.3333';
      6:
        LVideoAspectRatio := '-aspect 1.7777';
    end;

    // command line for video encoder
    case VideoEncoderList.ItemIndex of
      0: // mpeg 1
        begin
          LVideoCodec := ' -c:v mpeg1video ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      1: // mpeg 2
        begin
          LVideoCodec := ' -c:v mpeg2video ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      2: // xvid
        begin
          LVideoCodec := ' -c:v libxvid ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      3: // mpeg 4
        begin
          LVideoCodec := ' -c:v mpeg4 ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      4: // h264
        begin
          if AdvancedOptionsForm.x264CRFBtn.Checked and AdvancedOptionsForm.x264Btn.Checked then
          begin
            LVideoCodec := ' -c:v libx264 ' + ' -crf ' + StringReplace(AdvancedOptionsForm.x264CRFEdit.Text, ',', '.', []) + ' ' + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
          end
          else
          begin
            LVideoCodec := ' -c:v libx264 ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
          end;
        end;
      5: // flv
        begin
          LVideoCodec := ' -c:v flv ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      6: // wmv
        begin
          LVideoCodec := LVideoFPS + ' -c:v wmv2 ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + LVideoDimensions + CreateAdvancedOptions + CustomVideoArg;
        end;
      7: // vp8
        begin
          LVideoCodec := ' -c:v libvpx ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      8: // huffyuv
        begin
          LVideoCodec := ' -c:v huffyuv ' + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      9: // prores
        begin
          LVideoCodec := ' -c:v prores ' + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
      10: // copy
        begin
          LVideoCodec := ' -c:v copy' + CustomVideoArg;
        end;
      11: // none
        begin
          LVideoCodec := ' -vn ';
        end;
      12: // h265
        begin
          LVideoCodec := ' -c:v libx265 ' + ' -b:v ' + LVideoBitrate + LVideoAspectRatio + LVideoFPS + CreateAdvancedOptions + CustomVideoArg;
        end;
    end;
{$ENDREGION}

    //[0:v:0] [0:a:0] [1:v:0] [1:a:0] concat=n=2:v=1:a=1 [v] [a]
    LInputCMD := '';
    for I := 0 to FFileList.Count - 1 do
    begin
      LInputCMD := LInputCMD + ' -i "' + FFileList[i].FilePath + '" ';
    end;

    //[0:v:0] [0:a:0] [1:v:0] [1:a:0] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]"
    LConcatCMD := '-filter_complex "';
    for I := 0 to FFileList.Count-1 do
    begin
      LConcatCMD := LConcatCMD + ' [' + i.ToString() + ':v:' + FFileList[i].FFMmpegVideoID.ToString() + '] [' + i.ToString() + ':a:0]';
    end;
    LConcatCMD := LConcatCMD + ' concat=n=' + FFileList.Count.ToString + ':v=1:a=1 [v] [a]" -map "[v]" -map "[a]" ';
      // single pass encoding
    LOutputFileName := CreateFileName(FOutputFileName, LOutputFileExtension);
    Result := ' -y ' + MainForm.ThreadCMD(1) + LInputCMD + CustomArgs + ' ' + LConcatCMD + ' ' + LVideoCodec + LContainer + LAudioCommandLine + LAudioCodec + ' "' + LOutputFileName + '"';
  end;
end;

function TFFMpegMergeCMDCreator.CreateFileName(const FileName: string; const Extension: string): string;
var
  FileIndex: Integer;
  LOutFileName: string;
  TmpStr: string;
begin
  LOutFileName := ChangeFileExt(FileName, Extension);

  // same as source
  if MainForm.UseSourceChkBtn.Checked = False then
  begin
    if DirectoryExists(MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName)) then
    begin
      LOutFileName := MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName) + '\' + ExtractFileName(LOutFileName);
    end
    else
    begin
      if CreateDir(MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName)) then
      begin
        LOutFileName := MainForm.DirectoryEdit.Text + '\' + GetFileFolderName(FileName) + '\' + ExtractFileName(LOutFileName);
      end
      else
      begin
        LOutFileName := MainForm.DirectoryEdit.Text + '\' + ExtractFileName(LOutFileName);
      end;
    end;
  end
  else
  begin
    LOutFileName := ChangeFileExt(ExtractFileDir(FileName) + '\' + ExtractFileName(LOutFileName), Extension);
  end;

  TmpStr := LOutFileName;

  FileIndex := 0;
  if FileExists(LOutFileName) then
  begin
    while FileExists(LOutFileName) do
    begin
      LOutFileName := TmpStr;
      Inc(FileIndex);
      LOutFileName := ChangeFileExt(TmpStr, '_' + FloatToStr(FileIndex) + Extension);
    end;
  end;

  FOutputFileName := LOutFileName;
  Result := LOutFileName.Replace('\\\', '\', [rfReplaceAll]);

end;

destructor TFFMpegMergeCMDCreator.Destroy;
begin
  inherited;

end;

function TFFMpegMergeCMDCreator.GetFileFolderName(const FileName: string): string;
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

function TFFMpegMergeCMDCreator.IntegerToTime(Time: Integer): string;
var
  hour: Integer;
  second: Integer;
  minute: Integer;
  strhour: string;
  strminute: string;
  strsecond: string;
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

function TFFMpegMergeCMDCreator.IsStringNumeric(Str: string): Boolean;
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

    if (not CharInSet(p^, ['0'..'9'])) then
    begin
      Exit;
    end;

    Inc(p);
  end;

  Result := True;
end;

end.

