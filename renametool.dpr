program renametool;
{$IFOPT D-}{$WEAKLINKRTTI ON}{$ENDIF}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Classes;

var
  // audio
  // video
  // muxed
  FRenameFile: TStringList;

begin
  WriteLn('RenameTool 1.1');
  try
    if ParamCount = 1 then
    begin
      FRenameFile := TStringList.Create;
      try
        if FileExists(ParamStr(1)) then
        begin
          FRenameFile.LoadFromFile(ParamStr(1), TEncoding.UTF8);
          if FRenameFile.Count = 3 then
          begin
            if FileExists(FRenameFile[0]) and FileExists(FRenameFile[1]) then
            begin
              // delete files
              if FileExists(FRenameFile[0]) then
              begin
                DeleteFile(FRenameFile[0]);
                Writeln('Deleted ' + FRenameFile[0]);
              end;
              if FileExists(FRenameFile[1]) then
              begin
                DeleteFile(FRenameFile[1]);
                Writeln('Deleted ' + FRenameFile[1]);
              end;
              if FileExists(FRenameFile[2]) then
              begin
                if RenameFile(FRenameFile[2], FRenameFile[1]) then
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
            Writeln('Only 3 lines');
            ExitCode := 3;
          end;
        end
        else
        begin
          Writeln('Unable to find rename text file');
          ExitCode := 4;
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
