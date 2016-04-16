unit UnitFileInfoItem;

interface
  uses Classes, Generics.Collections, System.SysUtils, UnitSubtitleTypes;


type
  TFileDatePair = record
    CreateDate: TDateTime;
    ModifiedDate: TDateTime;
  end;

type
  TFileInfoItem = class(TObject)
    // Video ids
    FFMmpegVideoID: integer;
    MEncoderVideoID: integer;
    // subtitle
    SubtitleFiles: TStringList;
    SubtitleIndex: integer;
    SubtitleDelay: Extended;
    SubtitleTracks: TStringList;
    SubtitleTrackIndex: integer;
    SubtitleTrackIndexes: TList<Integer>;
    SelectedSubtitleType: TSubtitleType;
    // audio
    AudioTracks: TStringList;
    AudioIndex: integer;
    AudioIDs: TList<Integer>;
    AudioMencoderIDs: TList<Integer>;
    AudioExtensions: TStringList;
    AudioDelay: Extended;
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
  public
    property SelectedSubtitleFile: string read GetSubtitle;
    property SelectedSubtitleTrack: string read GetSubtitleTrackID;
    property SelectedAudio: string read GetAudioID;
    property SelectedMEncoderAudio: string read GetMencoderAudioID;
    property SelectedAudioExt: string read GetAudioExt;
    constructor Create;
    destructor Destroy; override;
  end;

  TFileInfoList = TList<TFileInfoItem>;

implementation

{ TFileInfoItem }

constructor TFileInfoItem.Create;
begin
  inherited;
  SubtitleFiles := TStringList.Create;
  AudioTracks := TStringList.Create;
  AudioIDs := TList<Integer>.Create;
  AudioExtensions := TStringList.Create;
  SubtitleTracks := TStringList.Create;
  AudioMencoderIDs := TList<Integer>.Create;
  SubtitleTrackIndexes := TList<Integer>.Create;
end;

destructor TFileInfoItem.Destroy;
begin
  inherited;
  SubtitleFiles.Free;
  AudioTracks.Free;
  AudioIDs.Free;
  AudioExtensions.Free;
  SubtitleTracks.Free;
  AudioMencoderIDs.Free;
  SubtitleTrackIndexes.Free;

end;

function TFileInfoItem.GetAudioExt: string;
begin
  Result := '.wav';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioExtensions.Count then
    begin
      Result := AudioExtensions[AudioIndex];
    end;
  end;
end;

function TFileInfoItem.GetAudioID: string;
begin
  Result := '1';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioIDs.Count then
    begin
      Result := FloatToStr(AudioIDs[AudioIndex]);
    end;
  end;
end;

function TFileInfoItem.GetMencoderAudioID: string;
begin
  Result := '1';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioMencoderIDs.Count then
    begin
      Result := FloatToStr(AudioMencoderIDs[AudioIndex]);
    end;
  end;
end;

function TFileInfoItem.GetSubtitle: string;
begin
  Result := '';
  if SubtitleIndex > -1 then
  begin
    if SubtitleIndex < SubtitleFiles.Count then
    begin
      Result := SubtitleFiles[SubtitleIndex];
    end;
  end;
end;

function TFileInfoItem.GetSubtitleTrackID: string;
begin
  Result := '';
  if SubtitleTrackIndex > -1 then
  begin
    if SubtitleTrackIndex < SubtitleTrackIndexes.Count then
    begin
      Result := FloatToStr(SubtitleTrackIndexes[SubtitleTrackIndex]);
    end;
  end;
end;

end.

