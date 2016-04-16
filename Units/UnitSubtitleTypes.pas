unit UnitSubtitleTypes;

interface
type
  TSubtitleType = (embedded = 0, subfile = 1);

type
  TSubtitleTrack = packed record
    Info: string;
    ID: integer;
  end;


implementation

end.
