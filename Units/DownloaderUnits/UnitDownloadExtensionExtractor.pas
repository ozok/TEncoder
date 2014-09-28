unit UnitFileNameExtractor;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, Generics.Collections, UnitImageResize, UnitCommonTypes;

type
  TStatus = (stReading, stDone);

type
  TTypeInfo = record
    ID: string;
    Info: string;
  end;

type
  TExtensionExtractor = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FFormat: string;
    FStatus: TStatus;
    FExt: string;

    procedure ProcessTerminate3(Sender: TObject; ExitCode: Cardinal);
  public
    property Status: TStatus read FStatus;
    property Extension

    constructor Create(const URL: string; const YouTube_dlPath: string; const TempFolder: string);
    destructor Destroy(); override;

    procedure Start();
    procedure Start2();
    procedure Start3();
    procedure Start4();
    procedure GetPlayListInfo();
  end;

implementation

{ TYouTubeVideoInfoExtractor }

constructor TYouTubeVideoInfoExtractor.Create(const URL: string; const YouTube_dlPath: string; const TempFolder: string);
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

    WaitForTerminate := true;
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
  FOutExt.Free;
  FSubtitles.Free;
end;

procedure TYouTubeVideoInfoExtractor.GetPlayListInfo;
begin
  FPlayListProcess.ApplicationName := FYouTube_dlPath;
  FPlayListProcess.CommandLine := ' -s --skip-download --get-id "' + FURL + '"';
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
  AvailFormat = 'format code extension resolution  note';
  SoundCloudStr = 'format code      extension resolution  note';
var
  I: Integer;
  LLine: string;
  LStartIndex: integer;
  // LSplitList: TStringList;
  LLine1, LLine2: string;
  LVideoTypeInfo: TTypeInfo;
begin
  FFormatStatus := stReading;
  FFormatProcess.ConsoleOutput.SaveToFile('C:\format.txt');
  FFormatProcess.ConsoleOutput.Add(FFormatProcess.CommandLine);
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
      else if SoundCloudStr = Copy(LLine, 1, Length(SoundCloudStr)) then
      begin
        // sound cloud
        LStartIndex := i;
        FURLType := soundcloud;
        Break;
      end;
    end;
//    ShowMessage(FloatToStr(LStartIndex));
    // extract avail. formats and their codes
    if LStartIndex > -1 then
    begin
      // general video link
      case FURLType of
        general:
          begin
//            ShowMessage('1');
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
//            ShowMessage('2');
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
begin
  FThumbStatus := stReading;
  FThumbProcess.ConsoleOutput.SaveToFile('C:\thumb.txt');
  try
    ResizeImg;
  finally
    FThumbStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate3(Sender: TObject; ExitCode: Cardinal);
begin
  FTitleStatus := stReading;
  FTitleExtractProcess.ConsoleOutput.SaveToFile('C:\title.txt');
  try
    FTitleExtractProcess.ConsoleOutput.Add(FTitleExtractProcess.CommandLine);
    if FTitleExtractProcess.ConsoleOutput.Count > 0 then
    begin
      FFileName := Trim(FTitleExtractProcess.ConsoleOutput[0]);
    end;
  finally
    FTitleStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ProcessTerminate4(Sender: TObject; ExitCode: Cardinal);
begin
  FPlayListStatus := stReading;
  FPlayListProcess.ConsoleOutput.SaveToFile('C:\playlist.txt');
  FPlayListVideoLinks.AddStrings(FPlayListProcess.ConsoleOutput);
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
    FSubtitleProcess.ConsoleOutput.SaveToFile('C:\sub.txt');
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
  finally
    for I := 0 to FSubtitles.Count - 1 do
    begin
      FSubtitles[i] := UpperCase(Trim(FSubtitles[i]));
    end;
    FSubtitles.Insert(0, 'Do not download subtitles');
    FSubtitleStatus := stDone;
  end;
end;

procedure TYouTubeVideoInfoExtractor.ResizeImg;
var
  LIR: TImageResizer;
begin
  LIR := TImageResizer.Create(FImageName, FImageName);
  try
    LIR.Width := 110;
    LIR.Height := -1;
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
    LSplitList.SaveToFile('C:\sc.txt');
    FreeAndNil(LSplitList);
  end;
end;

procedure TYouTubeVideoInfoExtractor.Start;
begin
  FFormatProcess.ApplicationName := FYouTube_dlPath;
  FFormatProcess.CommandLine := ' -s --skip-download  -F --playlist-end 1 "' + FURL + '"';
  FFormatProcess.Run;
  Start2;
  Start3;
  Start4;
end;

procedure TYouTubeVideoInfoExtractor.Start2;
begin
  FImageName := FTempFolder + '\' + CreateTempFileName + '.jpg';
  FThumbProcess.ApplicationName := FYouTube_dlPath;
  FThumbProcess.CommandLine := ' -o "' + FImageName + '" --write-thumbnail --playlist-end 1 "' + FURL + '"';
  FThumbProcess.Run;
end;

procedure TYouTubeVideoInfoExtractor.Start3;
begin
  FTitleExtractProcess.ApplicationName := FYouTube_dlPath;
  FTitleExtractProcess.CommandLine := '  -s --skip-download --playlist-end 1 --get-filename -o "%(uploader)s - %(title)s.%(ext)s" "' + FURL + '"';
  FTitleExtractProcess.Run;
end;

procedure TYouTubeVideoInfoExtractor.Start4;
begin
  FSubtitleProcess.ApplicationName := FYouTube_dlPath;
  FSubtitleProcess.CommandLine := ' -s --skip-download --list-subs --no-playlist "' + FURL + '"';
  FSubtitleProcess.Run;
end;

end.
