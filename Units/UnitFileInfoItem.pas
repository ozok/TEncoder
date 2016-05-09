unit UnitFileInfoItem;

interface

uses
  Classes, Generics.Collections, System.SysUtils, UnitSubtitleTypes;

type
  TFileDatePair = record
    CreateDate: TDateTime;
    ModifiedDate: TDateTime;
  end;

type
  TVideoStream = record
    FFmpegId: integer;
    MEncoderId: integer;
  end;

type
  TAudioStream = record
    TrackName: string;
    FFmpegId: integer;
    MEncoderId: integer;
    Extension: string;
    Delay: Extended;
  end;

type
  TSubtitleEmbeddedStream = record
    TrackName: string;
    Id: integer;
    Delay: Extended;
  end;

type
  TSubtitleFileStream = record
    Path: string;
  end;

type
  TFileInfoItem = class(TObject)
    // Video ids
    FFMmpegVideoID: integer;
    MEncoderVideoID: integer;

    // subtitle
    SubtitleFileIndex: integer;
    SubtitleTrackIndex: integer;
    SubtitleEmbeddedStreams: TList<TSubtitleEmbeddedStream>;
    SubtitleFileStreams: TList<TSubtitleFileStream>;
    SelectedSubtitleType: TSubtitleType;

    // audio
    AudioIndex: integer;
    AudioStreams: TList<TAudioStream>;

    // range
    StartPosition: integer;
    EndPosition: integer;
    ConstDuration: integer;
    // general
    FilePath: string;
    FileDate: TFileDatePair;
  private
    function GetSubtitle: string;
    function GetAudioID: string;
    function GetAudioExt: string;
    function GetMencoderAudioID: string;
    function GetSubtitleTrackID: string;
    function GetSubTrackDelay: string;
    function GetAudioTrackDelayAsExtended: Extended;
    function GetSubTrackDelayAsExtended: Extended;
    function GetAudioTrackDelay: string;
  public
    property SelectedSubtitleFile: string read GetSubtitle;
    property SelectedSubtitleTrack: string read GetSubtitleTrackID;
    property SelectedFFmpegAudio: string read GetAudioID;
    property SelectedMEncoderAudio: string read GetMencoderAudioID;
    property SelectedAudioExt: string read GetAudioExt;
    property SelectedSubTrackDelay: string read GetSubTrackDelay;
    property SelectedSubTrackDelayAsExtended: Extended read GetSubTrackDelayAsExtended;
    property SelectedAudioTrackDelayAsExtended: Extended read GetAudioTrackDelayAsExtended;
    property SelectedAudioTrackDelay: string read GetAudioTrackDelay;
    constructor Create;
    destructor Destroy; override;
    procedure SetSelectedAudioTrackDelay(const Value: Extended);
    procedure SetSelectedSubTrackDelay(const Value: Extended);
  end;

  TFileInfoList = TList<TFileInfoItem>;

implementation

{ TFileInfoItem }

constructor TFileInfoItem.Create;
begin
  inherited;
  SubtitleEmbeddedStreams := TList<TSubtitleEmbeddedStream>.Create;
  SubtitleFileStreams := TList<TSubtitleFileStream>.Create;
  AudioStreams := TList<TAudioStream>.Create;
end;

destructor TFileInfoItem.Destroy;
begin
  inherited;
  SubtitleEmbeddedStreams.Free;
  SubtitleFileStreams.Free;
  AudioStreams.Free;
end;

function TFileInfoItem.GetAudioExt: string;
begin
  Result := '.wav';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioStreams.Count then
    begin
      Result := AudioStreams[AudioIndex].Extension;
    end;
  end;
end;

function TFileInfoItem.GetAudioID: string;
begin
  Result := '1';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioStreams.Count then
    begin
      Result := FloatToStr(AudioStreams[AudioIndex].FFmpegId);
    end;
  end;
end;

function TFileInfoItem.GetAudioTrackDelay: string;
begin
  Result := '0';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioStreams.Count then
    begin
      Result := FloatToStr(AudioStreams[AudioIndex].Delay);
    end;
  end;
end;

function TFileInfoItem.GetAudioTrackDelayAsExtended: Extended;
begin
  Result := 0;
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioStreams.Count then
    begin
      Result := AudioStreams[AudioIndex].Delay;
    end;
  end;
end;

function TFileInfoItem.GetMencoderAudioID: string;
begin
  Result := '1';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioStreams.Count then
    begin
      Result := FloatToStr(AudioStreams[AudioIndex].MEncoderId);
    end;
  end;
end;

function TFileInfoItem.GetSubtitle: string;
begin
  Result := '';
  if SubtitleFileIndex > -1 then
  begin
    if SubtitleFileIndex < SubtitleFileStreams.Count then
    begin
      Result := SubtitleFileStreams[SubtitleFileIndex].Path;
    end;
  end;
end;

function TFileInfoItem.GetSubtitleTrackID: string;
begin
  Result := '';
  if SubtitleTrackIndex > -1 then
  begin
    if SubtitleTrackIndex < SubtitleEmbeddedStreams.Count then
    begin
      Result := FloatToStr(SubtitleEmbeddedStreams[SubtitleTrackIndex].Id);
    end;
  end;
end;

function TFileInfoItem.GetSubTrackDelay: string;
begin
  Result := '0';
  if SubtitleTrackIndex > -1 then
  begin
    if SubtitleTrackIndex < SubtitleEmbeddedStreams.Count then
    begin
      Result := FloatToStr(SubtitleEmbeddedStreams[SubtitleTrackIndex].Delay);
    end;
  end;
end;

function TFileInfoItem.GetSubTrackDelayAsExtended: Extended;
begin
  Result := 0;
  if SubtitleTrackIndex > -1 then
  begin
    if SubtitleTrackIndex < SubtitleEmbeddedStreams.Count then
    begin
      Result := SubtitleEmbeddedStreams[SubtitleTrackIndex].Delay;
    end;
  end;
end;

procedure TFileInfoItem.SetSelectedAudioTrackDelay(const Value: Extended);
var
  LTrack: TAudioStream;
begin
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioStreams.Count then
    begin
      LTrack := AudioStreams[AudioIndex];
      LTrack.Delay := Value;
      AudioStreams[AudioIndex] := LTrack;
    end;
  end;
end;

procedure TFileInfoItem.SetSelectedSubTrackDelay(const Value: Extended);
var
  LTrack: TSubtitleEmbeddedStream;
begin
  if SubtitleTrackIndex > -1 then
  begin
    if SubtitleTrackIndex < SubtitleEmbeddedStreams.Count then
    begin
      LTrack := SubtitleEmbeddedStreams[SubtitleTrackIndex];
      LTrack.Delay := Value;
      SubtitleEmbeddedStreams[SubtitleTrackIndex] := LTrack;
    end;
  end;
end;

end.

