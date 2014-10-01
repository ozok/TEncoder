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
unit UnitDVDRipperProcess;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, UnitSettings, Generics.Collections;

// current state of the process
type
  TEncoderStatus = (esEncoding, esStopped, esDone);

type
  TDVDProcessType = (dvdmencoder, dvdffmpeg, dvdmp4box, dvdrenametool);

type
  TDVDRipProcess = class(TObject)
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
    FProcessTypes: TList<TDVDProcessType>;
    // index of currently used duration
    FDurationIndex: integer;
    // list of informations about steps.
    FInfos: TStringList;
    // a list of output files. generally to check if they are created.
    FOutputFiles: TStringList;

    // process events
    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);

    // field variable read funcs
    function GetProcessID: integer;
    function GetFileName: string;
    function GetCurrentProcessType: TDVDProcessType;
    function GetInfo: string;
    function GetCommandCount: integer;
    function GetExeName: string;
  public
    property ConsoleOutput: string read FConsoleOutput;
    property EncoderStatus: TEncoderStatus read FEncoderStatus;
    property CommandLines: TStringList read FCommandLines write FCommandLines;
    property EncoderPaths: TStringList read FPaths write FPaths;
    property FileNames: TStringList read FFileNames;
    property FilesDone: integer read FCommandIndex;
    property ProcessID: integer read GetProcessID;
    property CurrentFile: string read GetFileName;
    property ProcessTypes: TList<TDVDProcessType> read FProcessTypes write FProcessTypes;
    property CurrentProcessType: TDVDProcessType read GetCurrentProcessType;
    property Info: string read GetInfo;
    property Infos: TStringList read FInfos write FInfos;
    property CommandCount: integer read GetCommandCount;
    property ExeName: string read GetExeName;
    property OutputFiles: TStringList read FOutputFiles write FOutputFiles;

    constructor Create();
    destructor Destroy(); override;

    procedure Start();
    procedure Stop();
    procedure ResetValues();
    function GetConsoleOutput(): TStrings;
  end;

implementation

{ TEncoder }

uses UnitMain;

constructor TDVDRipProcess.Create;
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
  FProcessTypes := TList<TDVDProcessType>.Create;
  FInfos := TStringList.Create;
  FDurationIndex := 0;
  FCommandIndex := 0;
  FOutputFiles := TStringList.Create;
end;

destructor TDVDRipProcess.Destroy;
begin

  inherited Destroy;
  FreeAndNil(FCommandLines);
  FreeAndNil(FPaths);
  FreeAndNil(FInfos);
  FreeAndNil(FFileNames);
  FreeAndNil(FProcessTypes);
  FreeAndNil(FOutputFiles);
  FProcess.Free;

end;

function TDVDRipProcess.GetCommandCount: integer;
begin
  Result := FCommandLines.Count;
end;

function TDVDRipProcess.GetConsoleOutput: TStrings;
begin
  Result := FProcess.ConsoleOutput;
end;

function TDVDRipProcess.GetCurrentProcessType: TDVDProcessType;
begin
  Result := dvdmencoder;
  if FCommandIndex < FProcessTypes.Count then
    Result := FProcessTypes[FCommandIndex];
end;

function TDVDRipProcess.GetExeName: string;
begin
  if FCommandIndex < FPaths.Count then
    Result := FPaths[FCommandIndex];
end;

function TDVDRipProcess.GetFileName: string;
begin
  if FCommandIndex < FFileNames.Count then
    Result := FFileNames[FCommandIndex];
end;

function TDVDRipProcess.GetInfo: string;
begin
  if FCommandIndex < FInfos.Count then
    Result := FInfos[FCommandIndex];
end;

function TDVDRipProcess.GetProcessID: integer;
begin
  Result := FProcess.ProcessInfo.hProcess;
end;

procedure TDVDRipProcess.ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
begin
  FConsoleOutput := Trim(S);
end;

procedure TDVDRipProcess.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  FEncoderStatus := esStopped;
  MainForm.DVDProgressBar.Position := 0;
  if FStoppedByUser then
  begin
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
    if GetCurrentProcessType = dvdffmpeg then
    begin
      Inc(FDurationIndex);
    end;

    // run next command
    inc(FCommandIndex);
    if FCommandIndex < FCommandLines.Count then
    begin
      FProcess.CommandLine := FCommandLines[FCommandIndex];
      FProcess.ApplicationName := FPaths[FCommandIndex];
      FEncoderStatus := esEncoding;
      FConsoleOutput := '';
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

procedure TDVDRipProcess.ResetValues;
begin
  // reset all lists, indexes etc
  FCommandLines.Clear;
  FPaths.Clear;
  FCommandIndex := 0;
  FDurationIndex := 0;
  FConsoleOutput := '';
  FProcess.ConsoleOutput.Clear;
  FProcessTypes.Clear;
  FStoppedByUser := False;
  FInfos.Clear;
end;

procedure TDVDRipProcess.Start;
begin
  if FProcess.ProcessInfo.hProcess = 0 then
  begin
    if FCommandLines.Count > 0 then
    begin
      FProcess.ApplicationName := FPaths[0];
      FProcess.CommandLine := FCommandLines[0];
      FEncoderStatus := esEncoding;
      FProcess.Run;
    end
    else
      FConsoleOutput := '0 cmd'
  end
  else
    FConsoleOutput := 'not 0'
end;

procedure TDVDRipProcess.Stop;
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
