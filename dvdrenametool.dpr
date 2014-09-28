program dvdrenametool;
{$IFOPT D-}{$WEAKLINKRTTI ON}{$ENDIF}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes;

var
  // old file (original)
  // new file (renamed to original)
  FRenameFile: TStringList;
begin
  WriteLn('DVDRenameTool 1.0');
  try
    if ParamCount = 1 then
    begin
      FRenameFile := TStringList.Create;
      try
        FRenameFile.LoadFromFile(ParamStr(1), TEncoding.UTF8);
        if FRenameFile.Count = 2 then
        begin
          if FileExists(FRenameFile[0]) and FileExists(FRenameFile[1]) then
          begin
            // delete original file
            if FileExists(FRenameFile[0]) then
            begin
              DeleteFile(FRenameFile[0]);
            end;
            if FileExists(FRenameFile[1]) then
            begin
              if RenameFile(FRenameFile[1], FRenameFile[0]) then
              begin
                Writeln('Successfully renamed.');
                ExitCode := 0;
              end
              else
              begin
                Writeln('Cannot rename');
                ExitCode := 5;
              end;
            end
            else
            begin
              Writeln('Dest doesnt exist.');
              ExitCode := 2;
            end;
          end;
        end
        else
        begin
          Writeln('Only 2 lines');
          ExitCode := 3;
        end;
      finally
        FRenameFile.Free;
      end;
    end
    else
    begin
      Writeln('Not enough params: ' + FloatToStr(ParamCount));
      ExitCode := 4;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
