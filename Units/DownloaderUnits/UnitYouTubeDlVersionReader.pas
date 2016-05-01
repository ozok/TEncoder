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
unit UnitYouTubeDlVersionReader;

interface

uses
  Classes, Windows, SysUtils, JvCreateProcess, Messages;

type
  TYouTubedlVersionReader = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FYouTube_dlPath: string;
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    function GetIsRunning: Boolean;
  public
    property IsRunning: Boolean read GetIsRunning;
    constructor Create(const YouTube_dlPath: string);
    destructor Destroy(); override;
    procedure Start();
    procedure StopAll();
  end;

implementation

uses
  UnitMain, UnitYoutubedlUpdateChecker;

{ TYouTubedlVersionReader }

constructor TYouTubedlVersionReader.Create(const YouTube_dlPath: string);
begin
  inherited Create;

  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
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

  FYouTube_dlPath := YouTube_dlPath;
end;

destructor TYouTubedlVersionReader.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FProcess);
end;

function TYouTubedlVersionReader.GetIsRunning: Boolean;
begin
  Result := FProcess.ProcessInfo.hProcess > 0;
end;

procedure TYouTubedlVersionReader.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  YoutubedlUpdateChecker.LocalVersion := FProcess.ConsoleOutput.Text;
  YoutubedlUpdateChecker.Path := MainForm.FYoutubedlPath;
  YoutubedlUpdateChecker.Show;
  MainForm.Enabled := False;
end;

procedure TYouTubedlVersionReader.Start;
begin
  FProcess.ApplicationName := FYouTube_dlPath;
  FProcess.CommandLine := ' --version';
  FProcess.Run;
end;

procedure TYouTubedlVersionReader.StopAll;
begin
  if FProcess.ProcessInfo.hProcess > 0 then
  begin
    TerminateProcess(FProcess.ProcessInfo.hProcess, 0)
  end;
end;

end.

