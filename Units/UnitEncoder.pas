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
unit UnitEncoder;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, UnitSettings, ComCtrls, Generics.Collections;

// current state of the process
type
  TEncoderStatus = (esEncoding, esStopped, esDone);

type
  TProcessType = (mencoder, ffmpeg, mp4box, renametool, imagemagick);

type
  TEncodeJob = packed record
    CommandLine: string;
    ProcessPath: string;
    ProcessType: TProcessType;
    SourceFileName: string;
    SourceDuration: integer;
    EncodingInformation: string;
    FileListIndex: integer;
    EncodingOutputFilePath: string;
    FinalFilePath: string;
    IsMergeJob: Boolean;
  end;

type
  TEncodeJobs = TList<TEncodeJob>;

type
  TEncodingProcess = class(TObject)
  private
    // process
    FProcess: TJvCreateProcess;
    FEncodeJobs: TEncodeJobs;
    // index of current command line. Also progress.
    FCommandIndex: integer;
    // last line backend has written to console
    FConsoleOutput: string;
    // encoder's state
    FEncoderStatus: TEncoderStatus;
    // flag to indicate if encoding is stopped by user
    FStoppedByUser: Boolean;
    // index of currently used duration
    FDurationIndex: integer;
    FItem: TListItem;
    FTerminateCounter: integer;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);

    procedure UpdateProgressItem(const Msg: string; const Progress: string; const StateIndex: integer);

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
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CurrentFile: string read GetFileName;
    property CurrentProcessType: TProcessType read GetCurrentProcessType;
    property CurrentDuration: integer read GetCurrentDuration;
    property Info: string read GetInfo;
    property CommandCount: integer read GetCommandCount;
    property ExeName: string read GetExeName;
    property FileIndex: Integer read GetFileIndex;
    property EncodeJobs: TEncodeJobs read FEncodeJobs write FEncodeJobs;

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

constructor TEncodingProcess.Create;
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

  FEncodeJobs := TEncodeJobs.Create;
  FEncoderStatus := esStopped;
  FStoppedByUser := False;
  FDurationIndex := 0;
  FCommandIndex := 0;
end;

destructor TEncodingProcess.Destroy;
begin
  FreeAndNil(FEncodeJobs);
  FProcess.Free;
  inherited Destroy;

end;

function TEncodingProcess.GetCommandCount: integer;
begin
  Result := FEncodeJobs.Count;
end;

function TEncodingProcess.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TEncodingProcess.GetCurrentDuration: integer;
begin
  if FCommandIndex < FEncodeJobs.Count then
    Result := FEncodeJobs[FDurationIndex].SourceDuration;
end;

function TEncodingProcess.GetCurrentProcessType: TProcessType;
begin
  Result := ffmpeg;
  if FCommandIndex < FEncodeJobs.Count then
    Result := FEncodeJobs[FCommandIndex].ProcessType;
end;

function TEncodingProcess.GetExeName: string;
begin
  if FCommandIndex < FEncodeJobs.Count then
    Result := FEncodeJobs[FCommandIndex].ProcessPath;
end;

function TEncodingProcess.GetFileIndex: Integer;
begin
  Result := 0;
  if FCommandIndex < FEncodeJobs.Count then
    Result := FEncodeJobs[FCommandIndex].FileListIndex;
end;

function TEncodingProcess.GetFileName: string;
begin
  if FCommandIndex < FEncodeJobs.Count then
    Result := FEncodeJobs[FCommandIndex].SourceFileName;
end;

function TEncodingProcess.GetInfo: string;
begin
  if FCommandIndex < FEncodeJobs.Count then
    Result := FEncodeJobs[FCommandIndex].EncodingInformation;
end;

function TEncodingProcess.GetPercentage: integer;
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

function TEncodingProcess.GetProcessID: integer;
begin
  Result := FProcess.ProcessInfo.hProcess;
end;

procedure TEncodingProcess.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
var
  LCurrVal: integer;
begin
  Inc(FTerminateCounter);
  if (FTerminateCounter mod 5) = 0 then
  begin
    FConsoleOutput := Trim(S);
    try
      if Assigned(FItem) then
      begin
        if TryStrToInt(FItem.SubItems[1], LCurrVal) then
        begin
          if GetPercentage > LCurrVal then
          begin
            UpdateProgressItem(FItem.SubItems[0], FloatToStr(GetPercentage), FItem.StateIndex);
          end;
        end;
      end;
    except
      on E: Exception do
        // ignored
    end;
  end;
end;

procedure TEncodingProcess.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  FEncoderStatus := esStopped;
  if FStoppedByUser then
  begin
    UpdateProgressItem('Stopped', '0', 3);
    FEncoderStatus := esStopped;
    // delete unfinished files.
    if SettingsForm.DeleteUnfinBtn.Checked then
    begin
      if FCommandIndex < FEncodeJobs.Count then
      begin
        if FileExists(FEncodeJobs[FCommandIndex].EncodingOutputFilePath) then
        begin
          if not DeleteFile(FEncodeJobs[FCommandIndex].EncodingOutputFilePath) then
          begin
            RaiseLastOSError;
          end
          else
          begin
            MainForm.AddToLog(0, 'Deleted unfinished file: ' + ExtractFileName(FEncodeJobs[FCommandIndex].EncodingOutputFilePath));
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
    UpdateProgressItem('Done', '100', 2);
    if FCommandIndex < FEncodeJobs.Count then
    begin
      FProcess.CommandLine := FEncodeJobs[FCommandIndex].CommandLine;
      FProcess.ApplicationName := FEncodeJobs[FCommandIndex].ProcessPath;
      FEncoderStatus := esEncoding;
      FConsoleOutput := '';
      try
        FItem := MainForm.ProgressList.Items.Add;
        if Assigned(FItem) then
        begin
          FItem.Caption := ExtractFileName(FEncodeJobs[FCommandIndex].SourceFileName);
          FItem.SubItems.Add(FEncodeJobs[FCommandIndex].EncodingInformation);
          FItem.SubItems.Add('0');
          FItem.StateIndex := 0;
          FItem.MakeVisible(False);
        end;
      except
        on E: Exception do
          // ignored
      end;
      FProcess.Run;
    end
    else
    begin
      // done
      FEncoderStatus := esDone;
    end;
  end;
end;

procedure TEncodingProcess.ResetValues;
begin
  // reset all lists, indexes etc
  FEncodeJobs.Clear;
  FCommandIndex := 0;
  FDurationIndex := 0;
  FConsoleOutput := '';
  FProcess.ConsoleOutput.Clear;
  FStoppedByUser := False;
  FItem := nil;
  FTerminateCounter := 0;
end;

procedure TEncodingProcess.Start;
begin
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    if FEncodeJobs.Count > 0 then
    begin
      if FileExists(FEncodeJobs[0].ProcessPath) then
      begin
        FProcess.ApplicationName := FEncodeJobs[0].ProcessPath;
        FProcess.CommandLine := FEncodeJobs[0].CommandLine;
        FEncoderStatus := esEncoding;
        try
          FItem := MainForm.ProgressList.Items.Add;
          if Assigned(FItem) then
          begin
            FItem.Caption := ExtractFileName(GetFileName);
            FItem.SubItems.Add(GetInfo);
            FItem.SubItems.Add('0');
            FItem.StateIndex := 0;
            FItem.MakeVisible(False);
          end;
        except
          on E: Exception do
            // ignored
        end;
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

procedure TEncodingProcess.Stop;
begin
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0);
    FEncoderStatus := esStopped;
    FStoppedByUser := true;
  end;
end;

procedure TEncodingProcess.UpdateProgressItem(const Msg: string; const Progress: string; const StateIndex: integer);
begin
  try
    if Assigned(FItem) then
    begin
      FItem.SubItems[0] := Msg;
      FItem.SubItems[1] := Progress;
      FItem.StateIndex := StateIndex;
    end;
  except
    on E: Exception do
      // ignore
  end;
end;

end.
