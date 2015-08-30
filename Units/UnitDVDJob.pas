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
unit UnitDVDJob;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Generics.Collections, UnitDVDRipperProcess;

type
  TDVDJob = class
    CMDs: TStringlist;
    Infos: TStringlist;
    EncoderPaths: TStringlist;
    FilePaths: TStringlist;
    OutputFiles: TStringlist;
    ProcessTypes: TList<TDVDProcessType>;
    ListItemIndexes: TList<integer>;
    TempFiles: TStringlist;
    FilesToCheck: TStringlist;
    constructor Create;
    destructor Destroy; override;
  end;

  TDVDJobs = TList<TDVDJob>;

implementation

{ TDVDJob }

constructor TDVDJob.Create;
begin
  CMDs := TStringlist.Create;
  Infos := TStringlist.Create;
  EncoderPaths := TStringlist.Create;
  FilePaths := TStringlist.Create;
  OutputFiles := TStringlist.Create;
  TempFiles := TStringlist.Create;
  FilesToCheck := TStringlist.Create;
  ProcessTypes := TList<TDVDProcessType>.Create;
  ListItemIndexes := TList<Integer>.Create;
end;

destructor TDVDJob.Destroy;
begin
  CMDs.Free;
  ProcessTypes.Free;
  Infos.Free;
  EncoderPaths.Free;
  FilePaths.Free;
  OutputFiles.Free;
  TempFiles.Free;
  FilesToCheck.Free;
  ListItemIndexes.Free;
  inherited;
end;

end.
