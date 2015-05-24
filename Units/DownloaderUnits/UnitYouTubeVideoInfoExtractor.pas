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
unit UnitYouTubeVideoInfoExtractor;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, Generics.Collections, UnitImageResize, UnitCommonTypes, UnitImageTypeExtractor;

type
  TStatus = (stReading, stDone);

type
  TTypeInfo = record
    ID: string;
    Info: string;
  end;

type
  TYouTubeVideoInfoExtractor = class(TObject)
  private
    FFormatProcess: TJvCreateProcess;
    FThumbProcess: TJvCreateProcess;
    FTitleExtractProcess: TJvCreateProcess;
    FPlayListProcess: TJvCreateProcess;
    FSubtitleProcess: TJvCreateProcess;
    FThumbStatus: TStatus;
    FFormatStatus: TStatus;
    FTitleStatus: TStatus;
    FPlayListStatus: TStatus;
    FSubtitleStatus: TStatus;
    FURL: string;
    FYouTube_dlPath: string;
    FFormatList: TStringList;
    FFormatInts: TStringList;
    FImageName: string;
    FTempFolder: string;
    FMaxFormatLength: integer;
    FFileName: string;
    FOutExt: TStringList;
    FPlayListVideoLinks: TStringList;
    FSubtitles: TStringList;
    FURLType: TLinkType;
    FPass: TUserPass;
    FDownloadImg: Boolean;

    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    procedure ProcessTerminate2(Sender: TObject; ExitCode: Cardinal);
    procedure ProcessTerminate3(Sender: TObject; ExitCode: Cardinal);
    procedure ProcessTerminate4(Sender: TObject; ExitCode: Cardinal);
    procedure ProcessTerminate5(Sender: TObject; ExitCode: Cardinal);

    function LineToVideoTypeInfo(const Line: string): TTypeInfo;
    function LineToExtension(const Line: string): string;
    function SoundCloudLineToTypeInfo(const Line: string): TTypeInfo;
    function CreateTempFileName: string;
    procedure ResizeImg;
  public
    property FormatStatus: TStatus read FFormatStatus;
    property ThumbStatus: TStatus read FThumbStatus;
    property TitleStatus: TStatus read FTitleStatus;
    property PlaylistStatus: TStatus read FPlayListStatus;
    property FormatList: TStringList read FFormatList;
    property FormatInts: TStringList read FFormatInts;
    property ImageName: string read FImageName;
    property FileName: string read FFileName;
    property OutExt: TStringList read FOutExt;
    property PlayListVideoLinks: TStringList read FPlayListVideoLinks;
    property Subtitles: TStringList read FSubtitles;
    property SubtitleStatus: TStatus read FSubtitleStatus;
    property LinkType: TLinkType read FURLType;

    constructor Create(const URL: string; const YouTube_dlPath: string; const TempFolder: string; const UserPass: TUserPass; const DownloadImg: Boolean);
    destructor Destroy(); override;

    procedure Start();
    procedure Start2();
    procedure Start3();
    procedure Start4();
    procedure StopAll();
    procedure GetPlayListInfo();
  end;

implementation

{ TYouTubeVideoInfoExtractor }

constructor TYouTubeVideoInfoExtractor.Create(const URL: string; const YouTube_dlPath: string; const TempFolder: string; const UserPass: TUserPass; const DownloadImg: Boolean);
begin
  inherited Create;

  FFormatProcess := TJvCreateProcess.Create(nil);
  with FFormatProcess do
  begin
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

  FThumbProcess := TJvCreateProcess.Create(nil);
  with FThumbProcess do
  begin
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

  FTitleExtractProcess := TJvCreateProcess.Create(nil);
  with FTitleExtractProcess do
  begin
    OnTerminate := ProcessTerminate3;
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

  FPlayListProcess := TJvCreateProcess.Create(nil);
  with FPlayListProcess do
  begin
    OnTerminate := ProcessTerminate4;
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

  FSubtitleProcess := TJvCreateProcess.Create(nil);
  with FSubtitleProcess do
  begin
    OnTerminate := ProcessTerminate5;
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

    WaitForTerminate := False;
  end;

  FFormatStatus := stReading;
  FThumbStatus := stReading;
  FTitleStatus := stReading;
  FPlayListStatus := stReading;
  FSubtitleStatus := stReading;
  FURL := URL;
  FYouTube_dlPath := YouTube_dlPath;
  FFormatList := TStringList.Create;
  FFormatInts := TStringList.Create;
  FTempFolder := TempFolder;
  FPlayListVideoLinks := TStringList.Create;
  FOutExt := TStringList.Create;
  FSubtitles := TStringList.Create;
  FSubtitles.StrictDelimiter := true;
  FSubtitles.Add('Do not download subtitles');
  FPass := UserPass;
  FDownloadImg := DownloadImg;
end;

function TYouTubeVideoInfoExtractor.CreateTempFileName: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := GUIDToString(LGUID);
end;

destructor TYouTubeVideoInfoExtractor.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FFormatList);
  FreeAndNil(FFormatInts);
  FFormatProcess.Free;
  FThumbProcess.Free;
  FTitleExtractProcess.Free;
  FPlayListProcess.Free;
  FPlayListVideoLinks.Free;
  FSubtitleProcess.Free;
  FOutExt.Free;
  FSubtitles.Free;
end;

procedure TYouTubeVideoInfoExtractor.GetPlayListInfo;
var
  LPass: string;
begin
  FPlayListProcess.ApplicationName := FYouTube_dlPath;
  if (Length(FPass.UserName) > 0) and (Length(FPass.Password) > 0) then
  begin
    LPass := ' -u ' + FPass.UserName + ' -p ' + FPass.Password;
  end;
  FPlayListProcess.CommandLine := ' ' + LPass + ' -s --skip-download --get-id "' + FURL + '"';
  FPlayListProcess.Run;
end;

function TYouTubeVideoInfoExtractor.LineToExtension(const Line: string): string;
var
  LSplitList: TStringList;
begin
  LSplitList := TStringList.Create;
  try
    LSplitList.StrictDelimiter := true;
    LSplitList.Delimiter := ',';
    LSplitList.DelimitedText := Line;

    if LSplitList.Count > 1 then
    begin
      Result := LSplitList[0];
    end;
  finally
    FreeAndNil(LSplitList);
  end;
end;

function TYouTubeVideoInfoExtractor.LineToVideoTypeInfo(const Line: string): TTypeInfo;
var
  LSplitList: TStringList;
  I: Integer;
  LStr: string;
begin
  LSplitList := TStringList.Create;
  try
    LSplitList.StrictDelimiter := true;
    LSplitList.Delimiter := ' ';
    LSplitList.DelimitedText := Line;
    for I := LSplitList.Count - 1 downto 0 do
    begin
      if Length(LSplitList[i]) < 1 then
      begin
        LSplitList.Delete(i);
      end;
    end;
    if LSplitList.Count > 1 then
    begin
      Result.ID := LSplitList[0];
      for I := 1 to LSplitList.Count - 1 do
      begin
        if (Length(LSplitList[i]) > 0) and (',' <> LSplitList[i]) then
        begin
          if i = 1 then
          begin
            LStr := LSplitList[i];
          end
          else
          begin
            LStr := LStr + ', ' + LSplitList[i];
          end;
        end;
      end;
      Result.Info := LStr;
    end;
  finally
    FreeAndNil(LSplitList);
  end;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
const
  AvailFormat = 'format code  extension  resolution note';
//  SoundCloudStr = 'format code      extension resolution  note';
var
  I: Integer;
  LLine: string;
  LStartIndex: integer;
  // LSplitList: TStringList;
  LLine1, LLine2: string;
  LVideoTypeInfo: TTypeInfo;
begin
  FFormatStatus := stReading;
  // find start of avail. formats
  try
    LStartIndex := -1;
    for I := 0 to FFormatProcess.ConsoleOutput.Count - 1 do
    begin
      LLine := Trim(FFormatProcess.ConsoleOutput[i]);
      if AvailFormat = Copy(LLine, 1, Length(AvailFormat)) then
      begin
        // general video
        LStartIndex := i;
        FURLType := general;
        Break;
      end
//      else if SoundCloudStr = Copy(LLine, 1, Length(SoundCloudStr)) then
//      begin
//        // sound cloud
//        LStartIndex := i;
//        FURLType := soundcloud;
//        Break;
//      end;
    end;
    // extract avail. formats and their codes
    if LStartIndex > -1 then
    begin
      // general video link
      case FURLType of
        general:
          begin
            for I := LStartIndex + 1 to FFormatProcess.ConsoleOutput.Count - 1 do
            begin
              LLine := Trim(FFormatProcess.ConsoleOutput[i]);
              if (Length(LLine) > 0) and (LLine[1] <> '-') then
              begin
                // extract info from line
                LVideoTypeInfo := LineToVideoTypeInfo(LLine);
                FFormatList.Add(UpperCase(Trim(LVideoTypeInfo.Info)));
                FFormatInts.Add(LVideoTypeInfo.ID);
              end;
            end;
            if FFormatList.Count > 0 then
            begin
              FMaxFormatLength := Length(FFormatList[0]) - Pos('[', FFormatList[0]);
              for I := 0 to FFormatList.Count - 1 do
              begin
                if Length(FFormatList[i]) > FMaxFormatLength then
                begin
                  FMaxFormatLength := Length(FFormatList[i]) - Pos('[', FFormatList[i]) + 2;
                end;
              end;
              // get output extensions
              for I := 0 to FFormatList.Count - 1 do
              begin
                LLine1 := LineToExtension(FFormatList[i]);
                LLine2 := Trim(Copy(FFormatList[i], FMaxFormatLength + 1, MaxInt));
                FOutExt.Add('.' + Trim(LLine1));
              end;
            end;
          end;
        soundcloud:
          begin
            for I := LStartIndex + 1 to FFormatProcess.ConsoleOutput.Count - 1 do
            begin
              LLine := Trim(FFormatProcess.ConsoleOutput[i]);
              if (Length(LLine) > 0) and (LLine[1] <> '-') then
              begin
                // extract info from line
                LVideoTypeInfo := SoundCloudLineToTypeInfo(LLine);
                FFormatList.Add(UpperCase(Trim(LVideoTypeInfo.Info)));
                FFormatInts.Add(LVideoTypeInfo.ID);
              end;
            end;
            if FFormatList.Count > 0 then
            begin
              FMaxFormatLength := Length(FFormatList[0]) - Pos('[', FFormatList[0]);
              for I := 0 to FFormatList.Count - 1 do
              begin
                if Length(FFormatList[i]) > FMaxFormatLength then
                begin
                  FMaxFormatLength := Length(FFormatList[i]) - Pos('[', FFormatList[i]) + 2;
                end;
              end;
              // get output extensions
              for I := 0 to FFormatList.Count - 1 do
              begin
                LLine1 := LineToExtension(FFormatList[i]);
                LLine2 := Trim(Copy(FFormatList[i], FMaxFormatLength + 1, MaxInt));
                FOutExt.Add('.' + Trim(LLine1));
              end;
            end;
          end;
      end;
    end;
  finally
    FFormatStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate2(Sender: TObject; ExitCode: Cardinal);
var
  LImageTypeExt: TImageType;
begin
  FThumbStatus := stReading;
  LImageTypeExt := TImageType.Create(FImageName);
  try
    if LImageTypeExt.ImageType = '.jpg' then
    begin
      ResizeImg;
    end
    else
    begin
      FImageName := '';
    end;
  finally
    LImageTypeExt.Free;
    FThumbStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate3(Sender: TObject; ExitCode: Cardinal);
var
  I: Integer;
begin
  FTitleStatus := stReading;
  // remove empty lines
  for I := FTitleExtractProcess.ConsoleOutput.Count-1 downto 1 do
  begin
    if Length(Trim(FTitleExtractProcess.ConsoleOutput[i])) = 0 then
    begin
      FTitleExtractProcess.ConsoleOutput.Delete(i);
    end;
  end;
  try
    if FTitleExtractProcess.ConsoleOutput.Count > 0 then
    begin
      // if there are more than one line,
      // that means there are some warnings etc.
      // last line is probably the one that has the title.
      if FTitleExtractProcess.ConsoleOutput.Count > 1 then
      begin
        for I := FTitleExtractProcess.ConsoleOutput.Count-1 downto 1 do
        begin
          if Length(Trim(FTitleExtractProcess.ConsoleOutput[i])) > 0 then
          begin
            FFileName := (ChangeFileExt(FTitleExtractProcess.ConsoleOutput[i], ''));
          end;
        end;
      end
      else
      begin
        FFileName := (ChangeFileExt(FTitleExtractProcess.ConsoleOutput[0], ''));
      end;
    end;
  finally
    FTitleStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate4(Sender: TObject; ExitCode: Cardinal);
var
  i: integer;
begin
  FPlayListStatus := stReading;
  for I := 0 to FPlayListProcess.ConsoleOutput.Count-1 do
  begin
    if Length(Trim(FPlayListProcess.ConsoleOutput[i])) > 3 then
    begin
      FPlayListVideoLinks.Add(FPlayListProcess.ConsoleOutput[i]);
    end;
  end;
  FPlayListStatus := stDone;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate5(Sender: TObject; ExitCode: Cardinal);
const
  SUB_STR = 'Available subtitles for video:';
var
  LSubLine: string;
  i: integer;
  LPos: integer;
begin
  FSubtitleStatus := stReading;
  try
    if Assigned(FSubtitleProcess) then
    begin
      if Assigned(FSubtitleProcess.ConsoleOutput) then
      begin
        for I := 0 to FSubtitleProcess.ConsoleOutput.Count - 1 do
        begin
          LSubLine := Trim(FSubtitleProcess.ConsoleOutput[i]);
          if ContainsText(LSubLine, SUB_STR) then
          begin
            LPos := Pos(SUB_STR, LSubLine);
            LSubLine := Copy(LSubLine, LPos + Length(SUB_STR), MaxInt);
            if not ContainsText(LSubLine, 'Do not download subtitles') then
            begin
              FSubtitles.DelimitedText := LSubLine;
            end;
          end;
        end;
      end;
    end;
  finally
    if Assigned(FSubtitles) then
    begin
      for I := 0 to FSubtitles.Count - 1 do
      begin
        FSubtitles[i] := UpperCase(Trim(FSubtitles[i]));
      end;
      FSubtitles.Insert(0, 'Do not download subtitles');
    end;
    FSubtitleStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ResizeImg;
var
  LIR: TImageResizer;
begin
  LIR := TImageResizer.Create(FImageName, FImageName);
  try
    LIR.Resize;
  finally
    LIR.Free;
  end;
end;

function TYouTubeVideoInfoExtractor.SoundCloudLineToTypeInfo(const Line: string): TTypeInfo;
var
  LSplitList: TStringList;
  I: Integer;
  LStr: string;
begin
  LSplitList := TStringList.Create;
  try
    LSplitList.StrictDelimiter := true;
    LSplitList.Delimiter := ' ';
    LSplitList.DelimitedText := Line;
    // remove empty lines
    for I := LSplitList.Count - 1 downto 0 do
    begin
      if Length(LSplitList[i]) < 1 then
      begin
        LSplitList.Delete(i);
      end;
    end;
    if LSplitList.Count > 1 then
    begin
      Result.ID := LSplitList[1];
      for I := 1 to LSplitList.Count - 1 do
      begin
        if (Length(LSplitList[i]) > 0) and (',' <> LSplitList[i]) then
        begin
          if i = 1 then
          begin
            LStr := LSplitList[i];
          end
          else
          begin
            LStr := LStr + ', ' + LSplitList[i];
          end;
        end;
      end;
      Result.Info := LStr;
    end;
  finally
    FreeAndNil(LSplitList);
  end;
end;

procedure TYouTubeVideoInfoExtractor.Start;
var
  LPass: string;
begin
  FFormatProcess.ApplicationName := FYouTube_dlPath;
  if (Length(FPass.UserName) > 0) and (Length(FPass.Password) > 0) then
  begin
    LPass := ' -u ' + FPass.UserName + ' -p ' + FPass.Password;
  end;
  FFormatProcess.CommandLine := ' ' + LPass + ' -s --skip-download -i -F --no-playlist --playlist-start 1 --playlist-end 1 "' + FURL + '"';
  FFormatProcess.Run;
  Start2;
  Start3;
  Start4;
end;

procedure TYouTubeVideoInfoExtractor.Start2;
var
  LPass: string;
begin
  if FDownloadImg then
  begin
    FThumbProcess.ApplicationName := FYouTube_dlPath;
    if (Length(FPass.UserName) > 0) and (Length(FPass.Password) > 0) then
    begin
      LPass := ' -u ' + FPass.UserName + ' -p ' + FPass.Password;
    end;
    FImageName := FTempFolder + '\' + CreateTempFileName + '.jpg';
    FThumbProcess.ApplicationName := FYouTube_dlPath;
    FThumbProcess.CommandLine := ' ' + LPass + ' -i "' + FURL + '" --write-thumbnail -o "' + FImageName + '"  --no-playlist --playlist-start 1 --playlist-end 1';
    FThumbProcess.Run;
  end
  else
  begin
    FImageName := '';
    FThumbStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.Start3;
var
  LPass: string;
begin
  FTitleExtractProcess.ApplicationName := FYouTube_dlPath;
  if (Length(FPass.UserName) > 0) and (Length(FPass.Password) > 0) then
  begin
    LPass := ' -u ' + FPass.UserName + ' -p ' + FPass.Password;
  end;
  FTitleExtractProcess.CommandLine := ' ' + LPass + ' -s --skip-download -i --no-playlist --playlist-start 1 --playlist-end 1 --get-filename -o "%(uploader)s - %(title)s.%(ext)s" "' + FURL + '"';
  FTitleExtractProcess.Run;
end;

procedure TYouTubeVideoInfoExtractor.Start4;
var
  LPass: string;
begin
  FSubtitleProcess.ApplicationName := FYouTube_dlPath;
  if (Length(FPass.UserName) > 0) and (Length(FPass.Password) > 0) then
  begin
    LPass := ' -u ' + FPass.UserName + ' -p ' + FPass.Password;
  end;
  FSubtitleProcess.CommandLine := ' ' + LPass + ' -s --skip-download -i --list-subs --no-playlist --playlist-start 1 --playlist-end 1 "' + FURL + '"';
  FSubtitleProcess.Run;
end;

procedure TYouTubeVideoInfoExtractor.StopAll;
begin
  if FFormatProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FFormatProcess.ProcessInfo.hProcess, 0)
  end;
  if FThumbProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FThumbProcess.ProcessInfo.hProcess, 0)
  end;
  if FTitleExtractProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FTitleExtractProcess.ProcessInfo.hProcess, 0)
  end;
  if FPlayListProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FPlayListProcess.ProcessInfo.hProcess, 0)
  end;
  if FSubtitleProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FSubtitleProcess.ProcessInfo.hProcess, 0)
  end;
end;

end.
