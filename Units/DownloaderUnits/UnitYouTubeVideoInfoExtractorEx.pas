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
unit UnitYouTubeVideoInfoExtractorEx;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Generics.Collections, UnitYouTubeVideoInfoExtractor;

type
  TStatusEx = (stReadingEx, stDoneEx);

type
  TJob = record
    Url: string;
    Playlist: boolean;
  end;

type
  TYouTubeVideoInfoExtractorEx = class(TObject)
  private
    FJobs: TList<TJob>;
    FYIE: TYouTubeVideoInfoExtractor;
    FYouTubeDlPath: string;
    FTempFolder: string;
    FStatus: TStatusEx;
  public
    property Jobs: TList<TJob> read FJobs write FJobs;
    property Status: TStatusEx read FStatus;

    constructor Create(const YouTubeDlPath: string; const TempFolder: string);
    destructor Destroy(); override;

    procedure Start();
  end;

implementation

{ TYouTubeVideoInfoExtractorEx }

constructor TYouTubeVideoInfoExtractorEx.Create(const YouTubeDlPath: string; const TempFolder: string);
begin
  inherited Create;
  FStatus := stReadingEx;
  FJobs := TList<TJob>.Create;
  FYouTubeDlPath := YouTubeDlPath;
  FTempFolder := TempFolder;
end;

destructor TYouTubeVideoInfoExtractorEx.Destroy;
begin
  inherited Destroy;
  FJobs.Free;
end;

procedure TYouTubeVideoInfoExtractorEx.Start;
begin
  while FJobs.Count > 0 do
  begin
    FYIE := TYouTubeVideoInfoExtractor.Create(FJobs[0].Url, FYouTubeDlPath, FTempFolder);
//    if FJobs[0].Playlist then
//    begin
//      FYIE.GetPlayListInfo;
//    end
//    else
//    begin
      FYIE.Start;
//    end;
    while (FYIE.FormatStatus = stReading) or (FYIE.ThumbStatus = stReading) or (FYIE.TitleStatus = stReading) or (FYIE.SubtitleStatus = stReading) do
    begin
      Sleep(100);
    end;
    FJobs.Delete(0);
  end;
  FStatus := stDoneEx;
end;

end.
