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
unit UnitDVDJob;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Generics.Collections, UnitDVDRipperProcess;

type
  TDVDJob = class
    CMDs: TStringlist;
    Infos: TStringList;
    EncoderPaths: TStringList;
    FilePaths: TStringList;
    OutputFiles: TStringList;
    ProcessTypes: TList<TDVDProcessType>;
    TempFiles: TStringList;
    FilesToCheck: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TDVDJobs = TList<TDVDJob>;

implementation

{ TDVDJob }

constructor TDVDJob.Create;
begin
  CMDs := TStringlist.Create;
  Infos := TStringList.Create;
  EncoderPaths := TStringList.Create;
  FilePaths := TStringList.Create;
  OutputFiles := TStringList.Create;
  TempFiles := TStringList.Create;
  FilesToCheck := TStringList.Create;
  ProcessTypes := TList<TDVDProcessType>.Create;
end;

destructor TDVDJob.Destroy;
begin
  inherited;
  CMDs.Free;
  ProcessTypes.Free;
  Infos.Free;
  EncoderPaths.Free;
  FilePaths.Free;
  OutputFiles.Free;
  TempFiles.Free;
  FilesToCheck.Free;
end;

end.
