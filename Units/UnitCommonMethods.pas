unit UnitCommonMethods;

interface

uses
  Classes, System.SysUtils;


// checks if a given string is numeric
function IsStringNumeric(const Str: string): Boolean;

// converts hh:mm:ss to integer
function TimeToInt(const TimeStr: string): Integer;

function GenGUID: string;

implementation

function GenGUID: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := GUIDToString(LGUID);
end;

function IsStringNumeric(const Str: string): Boolean;
var
  P: PChar;
begin
  if Length(Str) < 1 then
  begin
    Result := False;
    Exit;
  end;
  P := PChar(Str);
  Result := False;
  while P^ <> #0 do
  begin
    if (not CharInSet(P^, ['0'..'9'])) then
    begin
      Exit;
    end;
    Inc(P);
  end;
  Result := True;
end;

function TimeToInt(const TimeStr: string): Integer;
var
  LSplitList: TStringList;
  LHour: Integer;
  LMinute: Integer;
  LSecond: Integer;
begin
  Result := 0;
  if Length(TimeStr) = 8 then
  begin
    LSplitList := TStringList.Create;
    try
      LSplitList.Delimiter := ':';
      LSplitList.StrictDelimiter := True;
      LSplitList.DelimitedText := TimeStr;

      LHour := 0;
      LMinute := 0;
      LSecond := 0;

      if LSplitList.Count = 3 then
      begin
        if IsStringNumeric(LSplitList[0]) then
        begin
          LHour := StrToInt(LSplitList[0]);
        end;
        if IsStringNumeric(LSplitList[1]) then
        begin
          LMinute := StrToInt(LSplitList[1]);
        end;
        if IsStringNumeric(LSplitList[2]) then
        begin
          LSecond := StrToInt(LSplitList[2]);
        end;
        Result := (LHour * 3600) + (LMinute * 60) + LSecond;
      end;
    finally
      FreeAndNil(LSplitList);
    end;
  end;
end;

end.

