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
unit UnitDownloadProcess;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, UnitSettings, ComCtrls;

// current state of the process
type
  TEncoderStatus = (esEncoding, esStopped, esDone);

type
  TDownloadProcess = class(TObject)
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
    FProcessTypes: TStringList;
    // list of informations about steps.
    FInfos: TStringList;
    // a list of indexes indicating to the files in a list. to show progress in the list.
    FFileIndexes: TStringList;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);

    procedure UpdateMainFormItem(const ProgressStr: string; const Progress: integer);

    // field variable read funcs
    function GetProcessID: integer;
    function GetFileName: string;
    function GetCurrentProcessType: string;
    function GetInfo: string;
    function GetCommandCount: integer;
    function GetExeName: string;
    function GetFileIndex: Integer;
    function GetProgress(const ConsoleOutput: string): Integer;
  public
    property ConsoleOutput: string read FConsoleOutput;
    property EncoderStatus: TEncoderStatus read FEncoderStatus;
    property CommandLines: TStringList read FCommandLines write FCommandLines;
    property EncoderPaths: TStringList read FPaths write FPaths;
    property FileNames: TStringList read FFileNames;
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CurrentFile: string read GetFileName;
    property ProcessTypes: TStringList read FProcessTypes write FProcessTypes;
    property CurrentProcessType: string read GetCurrentProcessType;
    property Info: string read GetInfo;
    property Infos: TStringList read FInfos write FInfos;
    property CommandCount: integer read GetCommandCount;
    property ExeName: string read GetExeName;
    property FileIndexes: TStringList read FFileIndexes write FFileIndexes;
    property FileIndex: Integer read GetFileIndex;

    constructor Create();
    destructor Destroy(); override;

    procedure Start();
    procedure Stop();
    procedure ResetValues();
    function GetConsoleOutput(): TStrings;
  end;

implementation

{ TDownloadProcess }

uses UnitMain;

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

  FCommandLines := TStringList.Create;
  FPaths := TStringList.Create;
  FFileNames := TStringList.Create;
  FEncoderStatus := esStopped;
  FStoppedByUser := False;
  FProcessTypes := TStringList.Create;
  FInfos := TStringList.Create;
  FFileIndexes := TStringList.Create;
  FCommandIndex := 0;
end;

destructor TDownloadProcess.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FCommandLines);
  FreeAndNil(FPaths);
  FreeAndNil(FInfos);
  FreeAndNil(FFileNames);
  FreeAndNil(FProcessTypes);
  FreeAndNil(FFileIndexes);
  FProcess.Free;
end;

function TDownloadProcess.GetCommandCount: integer;
begin
  Result := FCommandLines.Count;
end;

function TDownloadProcess.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TDownloadProcess.GetCurrentProcessType: string;
begin
  if FCommandIndex < FProcessTypes.Count then
    Result := FProcessTypes[FCommandIndex];
end;

function TDownloadProcess.GetExeName: string;
begin
  if FCommandIndex < FPaths.Count then
    Result := FPaths[FCommandIndex];
end;

function TDownloadProcess.GetFileIndex: Integer;
begin
  if FCommandIndex < FFileIndexes.Count then
    Result := StrToInt(FFileIndexes[FCommandIndex]);
end;

function TDownloadProcess.GetFileName: string;
begin
  if FCommandIndex < FFileNames.Count then
    Result := FFileNames[FCommandIndex];
end;

function TDownloadProcess.GetInfo: string;
begin
  if FCommandIndex < FInfos.Count then
    Result := FInfos[FCommandIndex];
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
  FConsoleOutput := Trim(S);
  UpdateMainFormItem(S, GetProgress(S));
end;

procedure TDownloadProcess.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  FEncoderStatus := esStopped;
  if FStoppedByUser then
  begin
    UpdateMainFormItem('Stopped', 0);
    FEncoderStatus := esStopped;
  end
  else
  begin
    if ExitCode <> 0 then
    begin
      UpdateMainFormItem('Error code: ' + FloatToStr(ExitCode), 0);
    end
    else
    begin
      UpdateMainFormItem('Done', 100);
    end;

    // run next command
    inc(FCommandIndex);
    if FCommandIndex < FCommandLines.Count then
    begin
      FProcess.CommandLine := FCommandLines[FCommandIndex];
      FProcess.ApplicationName := FPaths[FCommandIndex];
      FEncoderStatus := esEncoding;
      FConsoleOutput := '';
      UpdateMainFormItem('Starting...', 0);
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

procedure TDownloadProcess.ResetValues;
begin
  // reset all lists, indexes etc
  FCommandLines.Clear;
  FPaths.Clear;
  FCommandIndex := 0;
  FConsoleOutput := '';
  FProcess.ConsoleOutput.Clear;
  FProcessTypes.Clear;
  FStoppedByUser := False;
  FInfos.Clear;
end;

procedure TDownloadProcess.Start;
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
        UpdateMainFormItem('Starting...', 0);
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

procedure TDownloadProcess.Stop;
begin
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0);
    UpdateMainFormItem('Stopped', 0);
    FFileNames.Clear;
    FEncoderStatus := esStopped;
    FStoppedByUser := true;
  end;
end;

procedure TDownloadProcess.UpdateMainFormItem(const ProgressStr: string; const Progress: integer);
begin
  if GetFileIndex < MainForm.FVideoDownloadListItems.Count then
  begin
    MainForm.FVideoDownloadListItems[GetFileIndex].ProgressLabel.Caption := ProgressStr;
    MainForm.FVideoDownloadListItems[GetFileIndex].ProgressBar.Position := Progress;
  end;
end;

end.
