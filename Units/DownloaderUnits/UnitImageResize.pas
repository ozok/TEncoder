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
unit UnitImageResize;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Jpeg, Graphics;

type
  TImageResizer = class(TObject)
  private
    FWidth: Integer;
    FHeight: Integer;
    FSourcePath: string;
    FDestPath: string;

    function ResizeJpg(const inFile, outFile: TFileName; const aQuality: TJPEGQualityRange = 95): Boolean;
  public
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;

    constructor Create(const SourceImg: string; const DestImg: string);
    destructor Destroy; override;

    procedure Resize;
  end;

implementation

{ TImageResizer }

constructor TImageResizer.Create(const SourceImg, DestImg: string);
begin
  FSourcePath := SourceImg;
  FDestPath := DestImg;
end;

destructor TImageResizer.Destroy;
begin
  inherited;
end;

procedure TImageResizer.Resize;
var
  LExt: string;
begin
  if not FileExists(FSourcePath) then Exit;

  LExt := LowerCase(ExtractFileExt(FSourcePath));
  if (LExt = '.jpeg') or (LExt = '.jpg') then
  begin
    ResizeJpg(FSourcePath, FDestPath)
  end;
end;

// code is from http://jetcracker.wordpress.com/2012/03/05/my-old-trash-resizing-images-in-delphi/
function TImageResizer.ResizeJpg(const inFile, outFile: TFileName; const aQuality: TJPEGQualityRange): Boolean;
var
  Jpeg: TJPEGImage;
  BMP: TBitmap;
  LAR: double;
  LARHeight: integer;
begin
  Result := FileExists(inFile);
  if not Result then
    Exit;

  Jpeg := TJPEGImage.Create;
  BMP := TBitmap.Create;
  try
    try
      // Load
      Jpeg.LoadFromFile(inFile);
    except
      Result := False;
      Exit;
    end;
    if FHeight = -1 then
    begin
      // keep aspect ratio
      LAR := Jpeg.Height / Jpeg.Width;
      LARHeight := Round(FWidth * LAR);

      BMP.Width := FWidth;
      BMP.Height := LARHeight;
      BMP.PixelFormat := pf32bit;
      // Change size
      with BMP.Canvas do
        StretchDraw(ClipRect, Jpeg);
      // Move from Bitmap to Jpeg
      Jpeg.Assign(BMP);
      // Change quality
      Jpeg.CompressionQuality := aQuality;
      Jpeg.Compress;
      try
        // Save file
        Jpeg.SaveToFile(outFile);
      except
        Result := False;
      end;
    end
    else
    begin
      // dont keep aspect ratio
      BMP.Width := FWidth;
      BMP.Height := FHeight;
      BMP.PixelFormat := pf24bit;
      // Change size
      with BMP.Canvas do
        StretchDraw(ClipRect, Jpeg);
      // Move from Bitmap to Jpeg
      Jpeg.Assign(BMP);
      // Change quality
      Jpeg.CompressionQuality := aQuality;
      Jpeg.Compress;
      try
        // Save file
        Jpeg.SaveToFile(outFile);
      except
        Result := False;
      end;
    end;
  finally
    FreeAndNil(Jpeg);
    FreeAndNil(BMP);
  end;
end;

end.
