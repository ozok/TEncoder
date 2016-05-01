{ *
  * Copyright (C) 2011-2016 ozok <ozok26@gmail.com>
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
unit UnitFileNameExtractor;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, Generics.Collections, UnitImageResize, UnitCommonTypes;

type
  TStatusEx = (stReadingEx, stDoneEx);

type
  TTypeInfo = record
    ID: string;
    Info: string;
  end;

type
  TFileNameExtractor = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FFormat: string;
    FStatus: TStatusEx;
    FFileName: string;
    FURL: string;
    FYouTubePath: string;
    FPass: TUserPass;

    procedure ProcessTerminate3(Sender: TObject; ExitCode: Cardinal);
  public
    property Status: TStatusEx read FStatus;
    property FileName: string read FFileName;
    property Format: string read FFormat write FFormat;

    constructor Create(const URL: string; const YouTube_dlPath: string; const UserPass: TUserPass);
    destructor Destroy(); override;

    procedure Start3();
  end;

implementation

{ TFileNameExtractor }

constructor TFileNameExtractor.Create(const URL: string; const YouTube_dlPath: string; const UserPass: TUserPass);
begin
  inherited Create;

  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
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

  FStatus := stReadingEx;
  FURL := URL;
  FYouTubePath := YouTube_dlPath;
  FPass := UserPass;
end;

destructor TFileNameExtractor.Destroy;
begin
  inherited Destroy;
  FProcess.Free;
end;

procedure TFileNameExtractor.ProcessTerminate3(Sender: TObject; ExitCode: Cardinal);
begin
  FStatus := stReadingEx;
  try
    FProcess.ConsoleOutput.Add(FProcess.CommandLine);
    if FProcess.ConsoleOutput.Count > 0 then
    begin
      FFileName := (FProcess.ConsoleOutput[0]);
    end;
  finally
    FStatus := stDoneEx;
  end;
end;

procedure TFileNameExtractor.Start3;
var
  LPass: string;
begin
  FProcess.ApplicationName := FYouTubePath;
  if (Length(FPass.UserName) > 0) and (Length(FPass.Password) > 0) then
  begin
    LPass := ' -u ' + FPass.UserName + ' -p ' + FPass.Password;
  end;
  FProcess.CommandLine := ' ' + LPass + ' -s --skip-download --no-playlist --get-filename -f ' + FFormat + ' -o "%(uploader)s - %(title)s.%(ext)s" "' + FURL + '"';
  FProcess.Run;
end;

end.
