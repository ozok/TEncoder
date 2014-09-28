unit UnitFileItem;

interface

uses Classes, Windows, SysUtils, Messages, StrUtils, Generics.Collections;

type
  TFileItem = class
  private
    function GetSelectedSub: string;
    function GetSelectedFFmpegAudio: Integer;
    function GetAudioDelayStr: string;
    function GetSubCount: Integer;
  public
    FullFilePath: string;
    FileDuration: Integer;
    StartPos: Integer;
    EndPos: Integer;
    SubtitleFiles: TStringList;
    SubtitleFileIndex: Integer;
    FFMpegAudioStreams: TStringList;
    FFMpegAudioStreamIndexList: TList<Integer>;
    FFMpegSelectedAudioStreamIndex: Integer;
    MEncoderAudioStreams: TStringList;
    MEncoderAudioStreamIndexList: TList<Integer>;
    MEncoderSelectedAudioStreamIndex: Integer;
    AudioDelay: Extended;
    SubtitleDelay: Extended;
    CopyID: string;
    CopyExt: string;
    AudioExt: string;
    property SelectedSubtitleFile: string read GetSelectedSub;
    property SelectedFFmpegAudio: Integer read GetSelectedFFmpegAudio;
    property AudioDelayStr: string read GetAudioDelayStr;
    property SubtitleCount: Integer read GetSubCount;

    constructor Create;
    destructor Destroy; override;
  end;

  PFileItem = ^TFileItem;
  TFileItemList = TList<TFileItem>;

implementation

{ TFileItem }

constructor TFileItem.Create;
begin
  SubtitleFiles := TStringList.Create;
  FFMpegAudioStreams := TStringList.Create;
  FFMpegAudioStreamIndexList := TList<Integer>.Create;
  MEncoderAudioStreams := TStringList.Create;
  MEncoderAudioStreamIndexList := TList<Integer>.Create;
  FFMpegSelectedAudioStreamIndex := -1;
  MEncoderSelectedAudioStreamIndex := -1;
  SubtitleFileIndex := -1;
end;

destructor TFileItem.Destroy;
begin
  inherited;
  SubtitleFiles.Free;
  FFMpegAudioStreams.Free;
  FFMpegAudioStreamIndexList.Free;
  MEncoderAudioStreams.Free;
  MEncoderAudioStreamIndexList.Free;
end;

function TFileItem.GetAudioDelayStr: string;
begin
  Result := FloatToStr(AudioDelay);
end;

function TFileItem.GetSelectedFFmpegAudio: Integer;
begin
  Result := FFMpegAudioStreamIndexList[FFMpegSelectedAudioStreamIndex];
end;

function TFileItem.GetSelectedSub: string;
begin
  Result := SubtitleFiles[SubtitleFileIndex];
end;

function TFileItem.GetSubCount: Integer;
begin
  Result := SubtitleFiles.Count;
end;

end.
