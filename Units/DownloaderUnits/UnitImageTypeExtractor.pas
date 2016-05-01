{ *
  * Copyright (C) 2014 ozok <ozok26@gmail.com>
  *
  * This file is part of TFlickrDownloader.
  *
  * TFlickrDownloader is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License.
  * 
  *
  * TFlickrDownloader is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with TFlickrDownloader.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }

unit UnitImageTypeExtractor;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils;

type
  TImageType = class(TObject)
  private
    FType: string;

    function ReadType(const ImagePath: string): string;
  public
    property ImageType: string read FType;

    constructor Create(const ImagePath: string);
    destructor Destroy; override;
  end;

implementation

const
  // taken from http://www.delphipages.com/forum/showthread.php?t=174008
  JPG_HEADER: array [0 .. 2] of byte = ($FF, $D8, $FF);
  GIF_HEADER: array [0 .. 2] of byte = ($47, $49, $46);
  BMP_HEADER: array [0 .. 1] of byte = ($42, $4D);
  PNG_HEADER: array [0 .. 3] of byte = ($89, $50, $4E, $47);
  TIF_HEADER: array [0 .. 2] of byte = ($49, $49, $2A);

  { TImageType }

constructor TImageType.Create(const ImagePath: string);
begin
  if FileExists(ImagePath) then
  begin
    FType := ReadType(ImagePath);
  end
  else
  begin
    FType := '';
  end;
end;

destructor TImageType.Destroy;
begin

  inherited;
end;

function TImageType.ReadType(const ImagePath: string): string;
var
  LFS: TFileStream;
  LMS: TMemoryStream;
begin
  Result := '';
  LFS := TFileStream.Create(ImagePath, fmOpenRead);
  LMS := TMemoryStream.Create;
  try
    LMS.CopyFrom(LFS, 5);
    if LMS.Size > 4 then
    begin
      if CompareMem(LMS.Memory, @JPG_HEADER, SizeOf(JPG_HEADER)) then
        Result := '.jpg'
      else if CompareMem(LMS.Memory, @GIF_HEADER, SizeOf(GIF_HEADER)) then
        Result := '.gif'
      else if CompareMem(LMS.Memory, @PNG_HEADER, SizeOf(PNG_HEADER)) then
        Result := '.png'
      else if CompareMem(LMS.Memory, @BMP_HEADER, SizeOf(BMP_HEADER)) then
        Result := '.bmp'
      else if CompareMem(LMS.Memory, @TIF_HEADER, SizeOf(TIF_HEADER)) then
        Result := '.tiff';
    end;
  finally
    LFS.Free;
    LMS.Free;
  end;
end;

end.
