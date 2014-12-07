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
unit UnitEncoder;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, UnitSettings, ComCtrls, Generics.Collections;

// current state of the process
type
  TEncoderStatus = (esEncoding, esStopped, esDone);

type
  TProcessType = (mencoder, ffmpeg, mp4box, renametool, imagemagick);

type
  TMyProcess = class(TObject)
  private
    // process
    FProcess: TJvCreateProcess;
    // list of command lines to be executed
    FCommandLines: TStringList;
    // list of executables
    FPaths: TStringList;
    // index of current command line. Also progress.
    FCommandIndex: integer;
    // last line backend has written to console
    FConsoleOutput: string;
    // encoder's state
    FEncoderStatus: TEncoderStatus;
    // flag to indicate if encoding is stopped by user
    FStoppedByUser: Boolean;
    // list of files to be processed.
    FFileNames: TStringList;
    // a list of types of encoders to be run.
    FProcessTypes: TList<TProcessType>;
    // a list of durations of files to be processed. generally to show progress.
    FDurations: TList<integer>;
    // index of currently used duration
    FDurationIndex: integer;
    // list of informations about steps.
    FInfos: TStringList;
    // a list of indexes indicating to the files in a list. to show progress in the list.
    FFileIndexes: TStringList;
    // a list of output files. generally to check if they are created.
    FOutputFiles: TStringList;
    FItem: TListItem;
    FTerminateCounter: integer;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);

    // field variable read funcs
    function GetProcessID: integer;
    function GetFileName: string;
    function GetCurrentProcessType: TProcessType;
    function GetCurrentDuration: integer;
    function GetInfo: string;
    function GetCommandCount: integer;
    function GetExeName: string;
    function GetFileIndex: Integer;
    function GetPercentage: integer;
  public
    property ConsoleOutput: string read FConsoleOutput;
    property EncoderStatus: TEncoderStatus read FEncoderStatus;
    property CommandLines: TStringList read FCommandLines write FCommandLines;
    property EncoderPaths: TStringList read FPaths write FPaths;
    property FileNames: TStringList read FFileNames;
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CurrentFile: string read GetFileName;
    property Durations: TList<integer> read FDurations write FDurations;
    property ProcessTypes: TList<TProcessType> read FProcessTypes write FProcessTypes;
    property CurrentProcessType: TProcessType read GetCurrentProcessType;
    property CurrentDuration: integer read GetCurrentDuration;
    property Info: string read GetInfo;
    property Infos: TStringList read FInfos write FInfos;
    property CommandCount: integer read GetCommandCount;
    property ExeName: string read GetExeName;
    property FileIndexes: TStringList read FFileIndexes write FFileIndexes;
    property FileIndex: Integer read GetFileIndex;
    property OutputFiles: TStringList read FOutputFiles write FOutputFiles;

    constructor Create();
    destructor Destroy(); override;

    procedure Start();
    procedure Stop();
    procedure ResetValues();
    function GetConsoleOutput(): TStrings;
  end;

implementation

{ TMyProcess }

uses UnitMain;

constructor TMyProcess.Create;
begin
  inherited Create;

  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
  begin
    OnRead := ProcessRead;
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

  FCommandLines := TStringList.Create;
  FPaths := TStringList.Create;
  FFileNames := TStringList.Create;
  FEncoderStatus := esStopped;
  FStoppedByUser := False;
  FProcessTypes := TList<TProcessType>.Create;
  FDurations := TList<integer>.Create;
  FInfos := TStringList.Create;
  FFileIndexes := TStringList.Create;
  FDurationIndex := 0;
  FCommandIndex := 0;
  FOutputFiles := TStringList.Create;
end;

destructor TMyProcess.Destroy;
begin

  inherited Destroy;
  FreeAndNil(FCommandLines);
  FreeAndNil(FPaths);
  FreeAndNil(FInfos);
  FreeAndNil(FFileNames);
  FreeAndNil(FProcessTypes);
  FreeAndNil(FDurations);
  FreeAndNil(FFileIndexes);
  FreeAndNil(FOutputFiles);
  FProcess.Free;

end;

function TMyProcess.GetCommandCount: integer;
begin
  Result := FCommandLines.Count;
end;

function TMyProcess.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TMyProcess.GetCurrentDuration: integer;
begin
  if FCommandIndex < FDurations.Count then
    Result := FDurations[FDurationIndex];
end;

function TMyProcess.GetCurrentProcessType: TProcessType;
begin
  Result := ffmpeg;
  if FCommandIndex < FProcessTypes.Count then
    Result := FProcessTypes[FCommandIndex];
end;

function TMyProcess.GetExeName: string;
begin
  if FCommandIndex < FPaths.Count then
    Result := FPaths[FCommandIndex];
end;

function TMyProcess.GetFileIndex: Integer;
begin
  Result := 0;
  if FCommandIndex < FFileIndexes.Count then
    Result := StrToInt(FFileIndexes[FCommandIndex]);
end;

function TMyProcess.GetFileName: string;
begin
  if FCommandIndex < FFileNames.Count then
    Result := FFileNames[FCommandIndex];
end;

function TMyProcess.GetInfo: string;
begin
  if FCommandIndex < FInfos.Count then
    Result := FInfos[FCommandIndex];
end;

function TMyProcess.GetPercentage: integer;
var
  LPercentageStr: string;
  LPercentageInt: Integer;
begin
  Result := 0;
  if Length(FConsoleOutput) > 0 then
  begin
    if FProcess.ProcessInfo.hProcess > 0 then
    begin
      // decide running process kind
      if (GetCurrentProcessType = ffmpeg) then
      begin
        LPercentageStr := MainForm.GetFFmpegPosition(FConsoleOutput, GetCurrentDuration);
      end
      else if GetCurrentProcessType = mencoder then
      begin
        LPercentageStr := MainForm.GetMencoderPosition(FConsoleOutput);
      end
      else if GetCurrentProcessType = mp4box then
      begin
        LPercentageStr := MainForm.GetMp4Progress(FConsoleOutput);
      end;
      // make sure str is actually a number
      if TryStrToInt(LPercentageStr, LPercentageInt) then
      begin
        Result := LPercentageInt;
      end;
    end;
  end;
end;

function TMyProcess.GetProcessID: integer;
begin
  Result := FProcess.ProcessInfo.hProcess;
end;

procedure TMyProcess.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
var
  LCurrVal: integer;
begin
  Inc(FTerminateCounter);
  if (FTerminateCounter mod 5) = 0 then
  begin
    FConsoleOutput := Trim(S);
    if TryStrToInt(FItem.SubItems[1], LCurrVal) then
    begin
      if GetPercentage > LCurrVal then
      begin
        FItem.SubItems[1] := FloatToStr(GetPercentage);
      end;
    end;
  end;
end;

procedure TMyProcess.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  FEncoderStatus := esStopped;
  if FStoppedByUser then
  begin
    FItem.SubItems[0] := 'Stopped';
    FItem.StateIndex := 3;
    FEncoderStatus := esStopped;
    // delete unfinished files.
    if SettingsForm.DeleteUnfinBtn.Checked then
    begin
      if FCommandIndex < FOutputFiles.Count then
      begin
        if FileExists(FOutputFiles[FCommandIndex]) then
        begin
          if not DeleteFile(FOutputFiles[FCommandIndex]) then
          begin
            RaiseLastOSError;
          end
          else
          begin
            MainForm.AddToLog(0, 'Deleted unfinished file: ' + ExtractFileName(FOutputFiles[FCommandIndex]));
          end;
        end;
      end;
    end;
  end
  else
  begin
    MainForm.UpdateProgress;
    // processed that need duration information
    if GetCurrentProcessType = ffmpeg then
    begin
      Inc(FDurationIndex);
    end;

    // run next command
    inc(FCommandIndex);
    FItem.SubItems[0] := 'Done';
    FItem.SubItems[1] := '100';
    FItem.StateIndex := 2;
    if FCommandIndex < FCommandLines.Count then
    begin
      FProcess.CommandLine := FCommandLines[FCommandIndex];
      FProcess.ApplicationName := FPaths[FCommandIndex];
      FEncoderStatus := esEncoding;
      FConsoleOutput := '';
      FItem := MainForm.ProgressList.Items.Add;
      FItem.Caption := ExtractFileName(GetFileName);
      FItem.SubItems.Add(GetInfo);
      FItem.SubItems.Add('0');
      FItem.StateIndex := 0;
      FItem.MakeVisible(False);
      FProcess.Run;
    end
    else
    begin
      // done
      FFileNames.Clear;
      FEncoderStatus := esDone;
    end;
  end;
end;

procedure TMyProcess.ResetValues;
begin
  // reset all lists, indexes etc
  FCommandLines.Clear;
  FPaths.Clear;
  FCommandIndex := 0;
  FDurationIndex := 0;
  FConsoleOutput := '';
  FProcess.ConsoleOutput.Clear;
  FProcessTypes.Clear;
  FDurations.Clear;
  FStoppedByUser := False;
  FInfos.Clear;
  FItem := nil;
  FTerminateCounter := 0;
end;

procedure TMyProcess.Start;
begin
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    if FCommandLines.Count > 0 then
    begin
      if FileExists(FPaths[0]) then
      begin
        FProcess.ApplicationName := FPaths[0];
        FProcess.CommandLine := FCommandLines[0];
        FEncoderStatus := esEncoding;
        FItem := MainForm.ProgressList.Items.Add;
        FItem.Caption := ExtractFileName(GetFileName);
        FItem.SubItems.Add(GetInfo);
        FItem.SubItems.Add('0');
        FItem.StateIndex := 0;
        FItem.MakeVisible(False);
        FProcess.Run;
      end
      else
        FConsoleOutput := 'encoder'
    end
    else
      FConsoleOutput := '0 cmd'
  end
  else
    FConsoleOutput := 'not 0'
end;

procedure TMyProcess.Stop;
begin
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0);
    FFileNames.Clear;
    FEncoderStatus := esStopped;
    FStoppedByUser := true;
  end;
end;

end.
