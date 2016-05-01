{ *
  * Copyright (C) 2011-2014 ozok <ozok26@gmail.com>
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
unit UnitDownloadProcess;

interface

uses
  Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, UnitSettings,
  ComCtrls, Generics.Collections, Graphics;

// current state of the process
type
  TProcessState = (esEncoding, esStopped, esDone);

type
  TProcessType = (youtubedl, ffmpeg, mp4box, subrenamer);

type
  TRenameJob = record
    AudioFilePath: string;
    VideoFilePath: string;
    TempMuxedFilePath: string;
  end;

type
  TDownloadJob = class
    ApplicationPath: string;
    CommandLine: string;
    FileName: string;
    ProcessType: TProcessType;
    ProcessInfo: string;
    FileIndex: integer;
    RenameJob: TRenameJob;
    SubtitleFilePath: string;
    IsWebm: Boolean;
    constructor Create();
  end;

  TDownloadJobs = TList<TDownloadJob>;

type
  TDownloadProcess = class(TObject)
  private
    // process
    FProcess: TJvCreateProcess;
    FDownloadJobs: TDownloadJobs;
    // index of current command line. Also progress.
    FCommandIndex: integer;
    // encoder's state
    FEncoderStatus: TProcessState;
    // flag to indicate if encoding is stopped by user
    FStoppedByUser: Boolean;
    FErrorLog: TStringList;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    // updates progress information shown in the list item
    procedure UpdateMainFormItem(const ProgressStr: string; const Progress: integer);

    // field variable read funcs
    function GetProcessID: integer;
    function GetFileName: string;
    function GetCurrentProcessType: TProcessType;
    function GetInfo: string;
    function GetCommandCount: integer;
    function GetExeName: string;
    function GetFileIndex: Integer;
    function GetProgress(const ConsoleOutput: string): Integer;
    procedure ProcessSubtitleFile(const FilePath: string);
  public
    property EncoderStatus: TProcessState read FEncoderStatus;
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CurrentFile: string read GetFileName;
    property CurrentProcessType: TProcessType read GetCurrentProcessType;
    property Info: string read GetInfo;
    property CommandCount: integer read GetCommandCount;
    property ExeName: string read GetExeName;
    property FileIndex: Integer read GetFileIndex;
    property DownloadJobs: TDownloadJobs read FDownloadJobs write FDownloadJobs;
    constructor Create();
    destructor Destroy(); override;
    procedure Start();
    procedure Stop();
    procedure ResetValues();
    function GetConsoleOutput(): TStrings;
  end;

implementation

{ TDownloadProcess }

uses
  UnitMain;

constructor TDownloadProcess.Create;
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

  FDownloadJobs := TDownloadJobs.Create;
  FEncoderStatus := esStopped;
  FStoppedByUser := False;
  FCommandIndex := 0;
  FErrorLog := TStringList.Create;
end;

destructor TDownloadProcess.Destroy;
begin
  inherited Destroy;
  FDownloadJobs.Free;
  FProcess.Free;
  FErrorLog.Free;
end;

function TDownloadProcess.GetCommandCount: integer;
begin
  Result := FDownloadJobs.Count;
end;

function TDownloadProcess.GetConsoleOutput: TStrings;
begin
  Result := FErrorLog;
end;

function TDownloadProcess.GetCurrentProcessType: TProcessType;
begin
  Result := ffmpeg;
  if FCommandIndex < FDownloadJobs.Count then
    Result := FDownloadJobs[FCommandIndex].ProcessType;
end;

function TDownloadProcess.GetExeName: string;
begin
  if FCommandIndex < FDownloadJobs.Count then
    Result := FDownloadJobs[FCommandIndex].ApplicationPath;
end;

function TDownloadProcess.GetFileIndex: Integer;
begin
  Result := -1;
  if FCommandIndex < FDownloadJobs.Count then
    Result := FDownloadJobs[FCommandIndex].FileIndex;
end;

function TDownloadProcess.GetFileName: string;
begin
  if FCommandIndex < FDownloadJobs.Count then
    Result := FDownloadJobs[FCommandIndex].FileName;
end;

function TDownloadProcess.GetInfo: string;
begin
  if FCommandIndex < FDownloadJobs.Count then
    Result := FDownloadJobs[FCommandIndex].ProcessInfo;
end;

function TDownloadProcess.GetProcessID: integer;
begin
  Result := FProcess.ProcessInfo.hProcess;
end;

function TDownloadProcess.GetProgress(const ConsoleOutput: string): Integer;
var
  StrPos1, StrPos2: Integer;
  TmpStr: string;
  TmpInt: Integer;
begin
  Result := 0;
  TmpStr := ConsoleOutput;
  StrPos1 := Pos('[download] ', TmpStr);
  StrPos2 := Pos('%', TmpStr);
  TmpStr := Trim(copy(TmpStr, StrPos1 + 10, StrPos2 - StrPos1 - 12));
  if TryStrToInt(TmpStr, TmpInt) then
  begin
    Result := TmpInt;
  end;
end;

procedure TDownloadProcess.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
begin
  UpdateMainFormItem(GetInfo + ' ' + S.Replace('[download]', '').Trim, GetProgress(S));
end;

procedure TDownloadProcess.ProcessSubtitleFile(const FilePath: string);
const
  START_FLAG = 'Language:';
var
  LFileContent: TStringList;
  LOutputFile: TStringList;
  LOutputFilePath: string;
  LLine: string;
  I: integer;
  LStartIndex: integer;
begin
  try
    if FileExists(FilePath) then
    begin
      try
        LFileContent := TStringList.Create;

        LFileContent.LoadFromFile(FilePath, TEncoding.UTF8);
        if LFileContent.Count > 0 then
        begin
          LStartIndex := -1;
          for I := 0 to LFileContent.Count - 1 do
          begin
            LLine := Trim(LFileContent[i]);
            if LLine.StartsWith(START_FLAG) then
            begin
              LStartIndex := i;
              Break;
            end;
          end;
          // means found start
          if LStartIndex > -1 then
          begin
            LOutputFile := TStringList.Create;
            try
              for I := LStartIndex + 1 to LFileContent.Count - 1 do
              begin
                LLine := Trim(LFileContent[i]);
                LOutputFile.Add(LLine);
              end;

              try
                LOutputFilePath := ChangeFileExt(FilePath, '.srt');
                LOutputFile.SaveToFile(LOutputFilePath, TEncoding.UTF8);
                DeleteFile(FilePath);
                ExitCode := 0;
              except
                on E: Exception do
                begin
                  MainForm.AddToLog(0, E.ClassName + ': ' + E.Message);
                  ExitCode := 1;
                end;
              end;
            finally
              LOutputFile.Free;
            end;
          end
          else
          begin
            MainForm.AddToLog(0, 'Unable to find subtitle file start flag');
          end;
        end;
      finally
        LFileContent.Free;
      end;
    end
    else
    begin
      MainForm.AddToLog(0, 'File not found: ' + FilePath);
    end;
  except
    on E: Exception do
    begin
      MainForm.AddToLog(0, E.ClassName + ': ' + E.Message);
    end;
  end;
end;

procedure TDownloadProcess.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  FEncoderStatus := esStopped;
  if FDownloadJobs[FCommandIndex].RenameJob.AudioFilePath <> '' then
  begin
    if FileExists(FDownloadJobs[FCommandIndex].RenameJob.AudioFilePath) then
    begin
      if not DeleteFile(FDownloadJobs[FCommandIndex].RenameJob.AudioFilePath) then
      begin
        MainForm.AddToLog(0, 'Unable to delete ' + ExtractFileName(FDownloadJobs[FCommandIndex].RenameJob.AudioFilePath));
      end;
    end;
    if FileExists(FDownloadJobs[FCommandIndex].RenameJob.VideoFilePath) then
    begin
      if not DeleteFile(FDownloadJobs[FCommandIndex].RenameJob.VideoFilePath) then
      begin
        MainForm.AddToLog(0, 'Unable to delete ' + ExtractFileName(FDownloadJobs[FCommandIndex].RenameJob.VideoFilePath));
      end;
    end;
    if not RenameFile(FDownloadJobs[FCommandIndex].RenameJob.TempMuxedFilePath, FDownloadJobs[FCommandIndex].RenameJob.VideoFilePath) then
    begin
      MainForm.AddToLog(0, 'Unable to rename ' + ExtractFileName(FDownloadJobs[FCommandIndex].RenameJob.TempMuxedFilePath) + ' to ' + ExtractFileName(FDownloadJobs[FCommandIndex].RenameJob.VideoFilePath));
    end;
  end;

  if FileExists(FDownloadJobs[FCommandIndex].SubtitleFilePath) then
  begin
    ProcessSubtitleFile(FDownloadJobs[FCommandIndex].SubtitleFilePath);
  end;

  // if user has stopped downloading do not try the next item
  if FStoppedByUser then
  begin
    UpdateMainFormItem('Stopped', 0);
    FEncoderStatus := esStopped;
  end
  else
  begin
    // if process has not exited properly, add it to the log
    MainForm.AddToLog(0, ExtractFileName(FDownloadJobs[FCommandIndex].ApplicationPath) + ' has exited with ' + FloatToStr(ExitCode) + '.');
    FErrorLog.AddStrings(FProcess.ConsoleOutput);
    FProcess.ConsoleOutput.Clear;
    if ExitCode <> 0 then
    begin
      UpdateMainFormItem('Error code: ' + FloatToStr(ExitCode), 0);
//      Inc(MainForm.FProcessErrorCount);
    end
    else
    begin
      UpdateMainFormItem('Done', 100);
    end;

    // run next command
    inc(FCommandIndex);
    if FCommandIndex < FDownloadJobs.Count then
    begin
      FProcess.CommandLine := FDownloadJobs[FCommandIndex].CommandLine;
      FProcess.ApplicationName := FDownloadJobs[FCommandIndex].ApplicationPath;
      FEncoderStatus := esEncoding;
      UpdateMainFormItem('Starting...', 0);
      FProcess.Run;
    end
    else
    begin
      // done
      FEncoderStatus := esDone;
    end;
  end;
end;

procedure TDownloadProcess.ResetValues;
begin
  // reset all lists, indexes etc
  FDownloadJobs.Clear;
  FCommandIndex := 0;
  FProcess.ConsoleOutput.Clear;
  FStoppedByUser := False;
  FErrorLog.Clear;
end;

procedure TDownloadProcess.Start;
begin
  // start with the first item if download is not already started
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    if FDownloadJobs.Count > 0 then
    begin
      FProcess.ApplicationName := FDownloadJobs[0].ApplicationPath;
      FProcess.CommandLine := FDownloadJobs[0].CommandLine;
      FEncoderStatus := esEncoding;
      UpdateMainFormItem('Starting...', 0);
      FProcess.Run;
    end
  end
end;

procedure TDownloadProcess.Stop;
begin
  // terminate running process unless it's already stopped
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0);
    UpdateMainFormItem('Stopped', 0);
    FEncoderStatus := esStopped;
    FStoppedByUser := true;
  end;
end;

procedure TDownloadProcess.UpdateMainFormItem(const ProgressStr: string; const Progress: integer);
begin
  if GetFileIndex < MainForm.FVideoDownloadListItems.Count then
  begin
    MainForm.FVideoDownloadListItems[GetFileIndex].ProgressLabel.Caption := ProgressStr;
    MainForm.FVideoDownloadListItems[GetFileIndex].ProgressBar.Progress := Progress;
  end;
end;

{ TDownloadJob }

constructor TDownloadJob.Create;
begin
  inherited;
  ApplicationPath := '';
  CommandLine := '';
  FileName := '';
  ProcessType := TProcessType.youtubedl;
  ProcessInfo := '';
  FileIndex := -1;
  SubtitleFilePath := '';
  IsWebm := false;
end;

end.

