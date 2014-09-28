{*
 * Copyright (C) 2011-2013 ozok <ozok26@gmail.com>
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
 * along with TAudioConverter.  If not, see <http://www.gnu.org/licenses/>.
 *
 *}

unit UnitFileInfo;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils;

type
  TStatus = (dsReading, dsDone);

type
  TFileInfo = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FStatus: TStatus;
    FFileName: string;
    FFFMpegPath: string;
    FAudioTrackIndexes: TStringList;
    FVideoIndex: string;

    procedure ProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
  public
    property FileInfoStatus: TStatus read FStatus;
    property AudioStreamIndexes: TStringList read FAudioTrackIndexes;
    property VideoIndex: string read FVideoIndex;

    constructor Create(const FileName: string; const FFMpegPath: string);
    destructor Destroy(); override;

    procedure Start();
  end;

implementation

{ TFileInfo }

constructor TFileInfo.Create(const FileName: string; const FFMpegPath: string);
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

  FStatus := dsReading;
  FFileName := FileName;
  FFFMpegPath := FFMpegPath;
  FAudioTrackIndexes := TStringList.Create;

end;

destructor TFileInfo.Destroy;
begin
  inherited Destroy;
  FProcess.Free;
  FreeAndNil(FAudioTrackIndexes);
end;

procedure TFileInfo.ProcessRead(Sender: TObject; const S: string;
  const StartsOnNewLine: Boolean);
const
  Output = 'Output';
  Input = 'Input';
begin

end;

procedure TFileInfo.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
const
  InputStr = 'Input';
  StreamStr = 'Stream';
var
  I: Integer;
  FLine: string;
  FStartIndex: integer;
  FEndIndex: integer;
  TmpLst: TStringList;
  FInfoLine: string;
begin
  FStatus := dsReading;
  FStartIndex := -1;
  FEndIndex := -1;

  TmpLst := TStringList.Create;
  try
    TmpLst.Delimiter := ':';
    TmpLst.StrictDelimiter := true;
    if FProcess.ConsoleOutput.Count > 0 then
    begin
      for I := 0 to FProcess.ConsoleOutput.Count - 1 do
      begin
        FLine := Trim(FProcess.ConsoleOutput[i]);
        if InputStr = Copy(FLine, 1, Length(InputStr)) then
        begin
          FStartIndex := i;
          FEndIndex := FProcess.ConsoleOutput.Count - 1;
          Break;
        end;
      end;

      if (FStartIndex <> -1) and (FEndIndex <> -1) then
      begin
        // get audio streams
        for I := FStartIndex to FEndIndex do
        begin
          FLine := Trim(FProcess.ConsoleOutput[i]);

          if StreamStr = Copy(FLine, 1, Length(StreamStr)) then
          begin
            TmpLst.DelimitedText := FLine;

            if TmpLst.Count >= 4 then
            begin
              FInfoLine := Trim(TmpLst[2]);

              if FInfoLine = 'Audio' then
              begin
                FAudioTrackIndexes.Add(Trim(TmpLst[1]));
              end;
            end;

          end;

        end;

        // get video stream
        for I := FStartIndex to FEndIndex do
        begin
          FLine := Trim(FProcess.ConsoleOutput[i]);

          if StreamStr = Copy(FLine, 1, Length(StreamStr)) then
          begin
            TmpLst.DelimitedText := FLine;

            if TmpLst.Count >= 4 then
            begin
              FInfoLine := Trim(TmpLst[2]);

              if FInfoLine = 'Video' then
              begin
                FVideoIndex := Trim(TmpLst[1]);
                Break;
              end;
            end;

          end;

        end;
      end;

    end;
  finally
    TmpLst.Free;
    FStatus := dsDone;
  end;

end;

procedure TFileInfo.Start;
begin

  FProcess.ApplicationName := FFFMpegPath;
  FProcess.CommandLine := ' -i "' + FFileName + '"';
  FProcess.Run;

end;

end.
