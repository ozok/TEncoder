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
unit UnitFileInfoExtractor;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, Generics.Collections, dialogs;

type
  TStatus = (Reading, Done);

type
  TFileInfoExtractor = class(TObject)
  private
    FMencoderProcess: TJvCreateProcess;
    FFFMpegProcess: TJvCreateProcess;
    FFFMpegStatus: TStatus;
    FMEncoderStatus: TStatus;
    FFileName: string;
    FSubtitleFiles: TStringList;
    FSubtitleTracks: TStringList;
    FSubtitleTrackIndexes: TList<Integer>;
    FAudioStreams: TStringList;
    FAudioIndexes: TList<Integer>;
    FAudioMencoderIndexes: TList<Integer>;
    FMencoderVideoIndex: integer;
    FFFmpegVideoIndex: integer;
    FMapStrSplit: TStringList;
    FDurationStr: string;
    FAudioExtensions: TStringList;

    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    procedure ProcessTerminate2(Sender: TObject; ExitCode: Cardinal);
    function CodecToExtension(const AudioCodec: string): string;
    function GetBusy: Boolean;
    procedure GetSubtitles;
  public
    property FFMpegStatus: TStatus read FFFMpegStatus;
    property MEncoderStatus: TStatus read FMEncoderStatus;
    property FileName: string read FFileName;
    property SubtitleFiles: TStringList read FSubtitleFiles;
    property SubtitleTracks: TStringList read FSubtitleTracks;
    property AudioStreams: TStringList read FAudioStreams;
    property AudioIndexes: TList<Integer> read FAudioIndexes;
    property AudioMencoderIndexes: TList<Integer> read FAudioMencoderIndexes;
    property IsBusy: Boolean read GetBusy;
    property DurationStr: string read FDurationStr;
    property AudioExtensions: TStringList read FAudioExtensions;
    property SubtitleTrackIndexes: TList<Integer> read FSubtitleTrackIndexes;
    property FFmpegVideoID: integer read FFFmpegVideoIndex;
    property MEncoderVideoID: integer read FMencoderVideoIndex;

    constructor Create(const FFmpegPath: string; const MEncoderPath: string);
    destructor Destroy(); override;

    procedure Start(const FileName: string);
    procedure Stop;
  end;

implementation

{ TFileInfoExtractor }

function TFileInfoExtractor.CodecToExtension(const AudioCodec: string): string;
var
  TmpStr: string;
begin
  TmpStr := Trim(AudioCodec);
  if ContainsText(TmpStr, 'vorbis') then
  begin
    Result := '.ogg';
  end
  else if ContainsText(TmpStr, 'mp3') or ContainsText(TmpStr, 'lame') or ContainsText(TmpStr, 'mpeg') or ContainsText(TmpStr, 'mpa1l3') then
  begin
    Result := '.mp3';
  end
  else if ContainsText(TmpStr, 'aac') then
  begin
    Result := '.m4a';
  end
  else if ContainsText(TmpStr, 'truehd') then
  begin
    Result := '.thd';
  end
  else if ContainsText(TmpStr, 'ac3') then
  begin
    Result := '.ac3';
  end
  else if ContainsText(TmpStr, 'wav') or ContainsText(TmpStr, 'pcm') then
  begin
    Result := '.wav';
  end
  else if ContainsText(TmpStr, 'mp2') then
  begin
    Result := '.mp2';
  end
  else if ContainsText(TmpStr, 'mpa1l2') then
  begin
    Result := '.mp2';
  end
  else if ContainsText(TmpStr, 'amr') then
  begin
    Result := '.amr';
  end
  else if ContainsText(TmpStr, 'flac') then
  begin
    Result := '.flac';
  end;
end;

constructor TFileInfoExtractor.Create(const FFmpegPath: string; const MEncoderPath: string);
begin
  inherited Create;

  FMencoderProcess := TJvCreateProcess.Create(nil);
  with FMencoderProcess do
  begin
    ApplicationName := MEncoderPath;
    OnTerminate := ProcessTerminate;
    ConsoleOptions := [coRedirect];
    CreationFlags := [cfUnicode];
    Priority := ppIdle;

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := true;
  end;

  FFFMpegProcess := TJvCreateProcess.Create(nil);
  with FFFMpegProcess do
  begin
    ApplicationName := FFmpegPath;
    OnTerminate := ProcessTerminate2;
    ConsoleOptions := [coRedirect];
    CreationFlags := [cfUnicode];
    Priority := ppIdle;

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := true;
  end;

  FFFMpegStatus := Reading;
  FMEncoderStatus := Reading;
  FSubtitleFiles := TStringList.Create;
  FSubtitleTracks := TStringList.Create;
  FAudioStreams := TStringList.Create;
  FAudioIndexes := TList<Integer>.Create;
  FMapStrSplit := TStringList.Create;
  FSubtitleTrackIndexes := TList<Integer>.Create;
  FMapStrSplit.StrictDelimiter := True;
  FMapStrSplit.Delimiter := ':';
  FAudioExtensions := TStringList.Create;
  FAudioMencoderIndexes := TList<Integer>.Create;
  FFFmpegVideoIndex := -1;
  FMencoderVideoIndex := -1;
  FDurationStr := '00:00:00.00';
end;

destructor TFileInfoExtractor.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FSubtitleFiles);
  FFFMpegProcess.Free;
  FMencoderProcess.Free;
  FSubtitleTracks.Free;
  FAudioStreams.Free;
  FAudioIndexes.Free;
  FMapStrSplit.Free;
  FSubtitleTrackIndexes.Free;
  FAudioExtensions.Free;
  FAudioMencoderIndexes.Free;
end;

function TFileInfoExtractor.GetBusy: Boolean;
begin
  Result := (FFMpegStatus = Reading) or (FMEncoderStatus = Reading);
end;

procedure TFileInfoExtractor.GetSubtitles;
var
  LFileName: String;
begin
  if (FileExists(FFileName)) then
  begin
    LFileName := ExtractFileName(FFileName);
    LFileName := ChangeFileExt(LFileName, '');
    if (FileExists(ExtractFileDir(FileName) + '\' + LFileName + '.srt')) then
    begin
      FSubtitleFiles.Add(ExtractFileDir(FileName) + '\' + LFileName + '.srt')
    end;
    if (FileExists(ExtractFileDir(FileName) + '\' + LFileName + '.idx')) then
    begin
      FSubtitleFiles.Add(ExtractFileDir(FileName) + '\' + LFileName + '.idx')
    end;
    if (FileExists(ExtractFileDir(FileName) + '\' + LFileName + '.ass')) then
    begin
      FSubtitleFiles.Add(ExtractFileDir(FileName) + '\' + LFileName + '.ass')
    end;
    if (FileExists(ExtractFileDir(FileName) + '\' + LFileName + '.sub')) then
    begin
      FSubtitleFiles.Add(ExtractFileDir(FileName) + '\' + LFileName + '.sub')
    end;
  end;
end;

procedure TFileInfoExtractor.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
const
  SUBTITLE_1_LINE = 'ID_SUBTITLE_ID=';
  AUDIO_LINE = 'ID_AUDIO_ID=';
  VIDEO_LINE = 'ID_VIDEO_ID=';
var
  I: Integer;
  LLine: string;
  LSubID: string;
  LAudioID: string;
  LSubLang: string;
  LSubTitle: string;
begin
//  FMencoderProcess.ConsoleOutput.SaveToFile('C:\mencoder.txt');
  FMEncoderStatus := Reading;
  try
    for I := 0 to FMencoderProcess.ConsoleOutput.Count - 1 do
    begin
      LSubLang := 'und';
      LSubTitle := 'und';
      LLine := Trim(FMencoderProcess.ConsoleOutput[i]);
      // found a subtitle stream
      if SUBTITLE_1_LINE = Copy(LLine, 1, Length(SUBTITLE_1_LINE)) then
      begin
        LSubID := Copy(LLine, Length(SUBTITLE_1_LINE) + 1, MaxInt);
        if (i + 1) < FMencoderProcess.ConsoleOutput.Count then
        begin
          LLine := Trim(FMencoderProcess.ConsoleOutput[i + 1]);
          if ('ID_SID_' + LSubID + '_LANG=') = Copy(LLine, 1, Length('ID_SID_' + LSubID + '_LANG=')) then
          begin
            LSubLang := Copy(LLine, Length('ID_SID_' + LSubID + '_LANG=') + 1, MaxInt);
            if (i + 2) < FMencoderProcess.ConsoleOutput.Count then
            begin
              LLine := Trim(FMencoderProcess.ConsoleOutput[i + 2]);
              if ('ID_SID_' + LSubID + '_NAME=') = Copy(LLine, 1, Length('ID_SID_' + LSubID + '_NAME=')) then
              begin
                LSubTitle := Copy(LLine, Length('ID_SID_' + LSubID + '_NAME=') + 1, MaxInt);
                FSubtitleTrackIndexes.Add(StrToInt(LSubID));
                FSubtitleTracks.Add(UpperCase(LSubLang + ', ' + LSubTitle));
              end;
            end;
          end;
        end;
      end
      // found an audio stream
      else if AUDIO_LINE = Copy(LLine, 1, Length(AUDIO_LINE)) then
      begin
        LAudioID := Copy(LLine, Length(AUDIO_LINE) + 1, MaxInt);
        FAudioMencoderIndexes.Add(StrToInt(LAudioID));
      end
      // found a video stream
      else if VIDEO_LINE = Copy(LLine, 1, Length(VIDEO_LINE)) then
      begin
        LAudioID := Copy(LLine, Length(VIDEO_LINE) + 1, MaxInt);
        FMencoderVideoIndex := StrToInt(LAudioID);
      end;
    end;
  finally
    FMEncoderStatus := Done;
  end;
end;

procedure TFileInfoExtractor.ProcessTerminate2(Sender: TObject; ExitCode: Cardinal);
const
  LINE_START = 'Stream #';
  AUDIO_LINE = 'Audio:';
  AUDIO_LINE2 = ': Audio:';
  DURATION_LINE = 'Duration: ';
  START_LINE = ', start:';
  VIDEO_LINE = ': Video:';
var
  LLine: string;
  I: Integer;
  LPos1, LPos2: integer;
  LMapStr: string;
  LLangStr: string;
  LCodec: string;
begin
  FFFMpegStatus := Reading;
  try
//    FFFMpegProcess.ConsoleOutput.SaveToFile('C:\ffmpeg.txt');
    for I := 0 to FFFMpegProcess.ConsoleOutput.Count - 1 do
    begin
      LLine := Trim(FFFMpegProcess.ConsoleOutput[i]);
      // detected a stream
      if LINE_START = Copy(LLine, 1, Length(LINE_START)) then
      begin
        // detected audio stream
        if ContainsText(LLine, AUDIO_LINE) then
        begin
          LLine := Copy(LLine, Length(LINE_START) + 1, MaxInt);
          LPos1 := Pos('(', LLine);
          LPos2 := Pos(')', LLine);
          LLangStr := UpperCase(Copy(LLine, LPos1 + 1, LPos2 - LPos1 - 1));
          LMapStr := Trim(Copy(LLine, 1, LPos1 - 1));
          if Length(LMapStr) > 0 then
          begin
            // video+audio
            FMapStrSplit.DelimitedText := LMapStr;
            if FMapStrSplit.Count >= 2 then
            begin
              LPos1 := Pos(AUDIO_LINE, LLine);
              LLine := UpperCase(Trim(Copy(LLine, LPos1 + 1 + Length(AUDIO_LINE), MaxInt)));
              LPos1 := Pos(',', LLine);
              if LPos1 > 0 then
              begin
                LPos1 := Pos(',', LLine);
                if LPos1 > 0 then
                begin
                  LCodec := Copy(LLine, 1, LPos1 - 1);
                  FAudioExtensions.Add(CodecToExtension(LowerCase(LCodec)));
                  LPos1 := Pos('[', FMapStrSplit[1]);
                  if LPos1 > 0 then
                  begin
                    FMapStrSplit[1] := Copy(FMapStrSplit[1], 1, LPos1-1);
                  end;
                  FAudioIndexes.Add(StrToInt(FMapStrSplit[1]));
                  FAudioStreams.Add(LLangStr + ', ' + LLine);
                end;
              end;
            end;
          end
          else
          begin
            // probably audio only
            LPos1 := Pos(AUDIO_LINE2, LLine);
            LPos2 := Pos(')', LLine);
            LLangStr := 'Und';
            LMapStr := Trim(Copy(LLine, 1, LPos1));
            if Length(LMapStr) > 0 then
            begin
              FMapStrSplit.DelimitedText := LMapStr;
              if FMapStrSplit.Count >= 2 then
              begin
                LPos1 := Pos(AUDIO_LINE, LLine);
                LLine := UpperCase(Trim(Copy(LLine, LPos1 + 1 + Length(AUDIO_LINE), MaxInt)));
                LPos1 := Pos(',', LLine);
                if LPos1 > 0 then
                begin
                  LPos1 := Pos(',', LLine);
                  if LPos1 > 0 then
                  begin
                    LCodec := Copy(LLine, 1, LPos1 - 1);
                    FAudioExtensions.Add(CodecToExtension(LowerCase(LCodec)));
                    LPos1 := Pos('[', FMapStrSplit[1]);
                    if LPos1 > 0 then
                    begin
                      FMapStrSplit[1] := Copy(FMapStrSplit[1], 1, LPos1-1);
                    end;
                    FAudioIndexes.Add(StrToInt(FMapStrSplit[1]));
                    FAudioStreams.Add(LLangStr + ', ' + LLine);
                  end;
                end;
              end;
            end
            else
            begin
              // todo: cant get file info error
            end;
          end;
        end
        // detected a video stream
        else if ContainsText(LLine, VIDEO_LINE) then
        begin
          LLine := Copy(LLine, Length(LINE_START) + 1, MaxInt);
          LPos1 := Pos(VIDEO_LINE, LLine);
          if LPos1 > 0 then
          begin
            LMapStr := Copy(LLine, 1, LPos1 - 1);
            FMapStrSplit.DelimitedText := LMapStr;
            if FMapStrSplit.Count = 2 then
            begin
              LPos1 := Pos('[', FMapStrSplit[1]);
              if LPos1 > 0 then
              begin
                FMapStrSplit[1] := Copy(FMapStrSplit[1], 1, LPos1-1);
              end;
              LPos1 := Pos('(', FMapStrSplit[1]);
              if LPos1 > 0 then
              begin
                FMapStrSplit[1] := Copy(FMapStrSplit[1], 1, LPos1-1);
              end;
              FFFmpegVideoIndex := StrToInt(FMapStrSplit[1]);
            end;
          end;
        end;
      end
      // duration information
      else if DURATION_LINE = Copy(LLine, 1, Length(DURATION_LINE)) then
      begin
        LLine := Copy(LLine, Length(DURATION_LINE) + 1, MaxInt);
        LPos1 := Pos(START_LINE, LLine);
        if LPos1 > 0 then
        begin
          FDurationStr := Copy(LLine, 1, LPos1 - 4);
        end
        else
        begin
          LPos1 := Pos(', bitrate', LLine);
          if LPos1 > 0 then
          begin
            FDurationStr := Copy(LLine, 1, LPos1 - 4);
          end;
        end;
      end;
    end;
  finally
    FFFMpegStatus := Done;
  end;
end;

procedure TFileInfoExtractor.Start(const FileName: string);
begin
  // reset
  FAudioStreams.Clear;
  FAudioIndexes.Clear;
  FSubtitleFiles.Clear;
  FSubtitleTracks.Clear;
  FFFMpegProcess.ConsoleOutput.Clear;
  FMencoderProcess.ConsoleOutput.Clear;
  FSubtitleTrackIndexes.Clear;
  FAudioExtensions.Clear;
  FAudioMencoderIndexes.Clear;
  FFFmpegVideoIndex := -1;
  FMencoderVideoIndex := -1;
  FDurationStr := '00:00:00.00';

  FFileName := FileName;
  GetSubtitles;
  FFFMpegProcess.CommandLine := '-y -i "' + FileName + '"';
  FMencoderProcess.CommandLine := ' -identify -frames 0 -vo null -ao null "' + FileName + '"';
  FFFMpegProcess.Run;
  FMencoderProcess.Run;
  FFFMpegStatus := Reading;
  FMEncoderStatus := Reading;
end;

procedure TFileInfoExtractor.Stop;
begin
  if FFFMpegProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FFFMpegProcess.ProcessInfo.hProcess, 0)
  end;
  if FMEncoderProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FMEncoderProcess.ProcessInfo.hProcess, 0)
  end;
end;

end.

