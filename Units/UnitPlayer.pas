{ *
  * Copyright (C) 2011-2015 ozok <ozok26@gmail.com>
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
unit UnitPlayer;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, UnitEffects, dialogs, UnitSubtitleTypes;

type
  TPlayerStatus = (psPlaying, psPaused, psStopped, psFontCache);

type
  TSubtitleInfo = record
    UseSSAStyle: Boolean;
    EnableSubtitle: Boolean; // enable/disable subtitles
    EncodingIndex: Integer; // subtitle encoding index
    FontPath: string; // full path to font file
    FontAutoScale: string; // font auto scaling method
    TextScale: string; // text auto scaling method
    SubtilePosition: string; // position of the subtitle on the screen
    Delay: Extended;
  end;

type
  TPlayerOptions = record
    FileName: string; // full path to media file
    FileIndex: integer;
    VWidth: string;
    VHeight: string;
    VideoSizeIndex: Integer;
    VideoAspectIndex: Integer; // index of video aspect ratio
    ForceAspect: Boolean;
    VideoVolumeLevel: Integer; // startup volume level
    EnableDeint: Boolean; // enable/disable deinterlacing
    DeintMethodIndex: Integer; // index of deinterlacing method
    Crop: Boolean;
    CropW: string;
    CropH: string;
    CropX: string;
    Cropy: string;
    AudioDelay: Extended;
    _AudioStream: string;
    SubtitleOptions: TSubtitleInfo; // subtitle options
    StartTime: integer;
    EndTime: integer;
    RotateMode: Integer;
  end;

type
  TPlayer = class(TObject)
  private
    FConsoleOutput: TStringList;
    FPlayerOptions: TPlayerOptions;
    FDisplayHandle: THandle;
    FMPlayer: TJvCreateProcess;
    FPlayerStatus: TPlayerStatus;
    FKeepMplayerOutput: Boolean;
    FMplayerOutput: string;
    FProgress: Integer;

    // creates command lines that will be passed to Mplayer.exe
    function CreatePlayerCommandLine(Options: TPlayerOptions): string;
    // checks if MPlayer is still runing
    function IsMplayerAlive(): Boolean;
    // checks if given string is numeric
    function IsStringNumeric(Str: String): Boolean;
    // create range CMD
    function MPlayerRangeCMD(Options: TPlayerOptions): string;

    // ---JvCreateProcess events---//
    // read output event
    procedure MplayerRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    // event of termination
    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
  public
    // must be set!!!
    property Options: TPlayerOptions read FPlayerOptions write FPlayerOptions;
    property KeepMplayerOutput: Boolean read FKeepMplayerOutput write FKeepMplayerOutput;
    property MplayerStatus: TPlayerStatus read FPlayerStatus;
    property MplayerProgress: Integer read FProgress;
    property MplayerConsoleOutput: TStringList read FConsoleOutput;
    property MplayerOutput: string read FMplayerOutput;

    constructor Create(DisplayHandle: THandle; MplayerPath: string);
    destructor Destroy(); override;

    // ---Player controls---//
    // starts Mplayer for the first time
    procedure StartPlaying();
    // pauses/resumes mplayer
    procedure Pause();
    // stops mplayer
    procedure Stop();
    // set mplayer volume
    function SetVolume(VolumeLevel: Integer): Boolean;
    // jumps to given position
    function Seek(Position: Integer): Boolean;
    // go back
    procedure SeekBack(Sec: Integer);
    // go forward
    procedure SeekForward(Sec: Integer);
    // volume lvl one up
    function VolumeUp(): Boolean;
    // volume lvl one down
    function VolumeDown(): Boolean;
    // subtitle delay
    function SubtitleDelayUp(Count: Integer): Boolean;
    function SubtitleDelaYDown(Count: Integer): Boolean;
    // audio delay
    function AudioDelayUp(Count: Integer): Boolean;
    function AudioDelayDown(Count: Integer): Boolean;
    function SetAudioDelay(Count: Integer): Boolean;

    // returns mplayer's commandline
    function GetCommandLine: string;

  end;

implementation

uses UnitMain;

{ TPlayer }

function TPlayer.AudioDelayDown(Count: Integer): Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(' audio_delay +0.1 0');
  end;

end;

function TPlayer.AudioDelayUp(Count: Integer): Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(' audio_delay -0.1 0');
  end;

end;

constructor TPlayer.Create(DisplayHandle: THandle; MplayerPath: string);
begin

  inherited Create;

  FMPlayer := TJvCreateProcess.Create(nil);
  with FMPlayer do
  begin
    OnRead := MplayerRead;
    OnTerminate := ProcessTerminate;

    ApplicationName := MplayerPath;
    ConsoleOptions := [coRedirect, coSeparateError];
    CreationFlags := [cfNewConsole, cfUnicode];

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := False;
  end;

  FDisplayHandle := DisplayHandle;
  FConsoleOutput := TStringList.Create;
  FPlayerStatus := psStopped;
  FProgress := 0;

end;

function TPlayer.CreatePlayerCommandLine(Options: TPlayerOptions): string;
var
  Params: string;
  VAspect: string;
  SubEncoding: string;
  SubtitleCMD: string;
  DeintCMD: string;
  VideoSize: string;
  CropCMD: string;
begin

  Result := '';

  if FileExists(FMPlayer.ApplicationName) then
  begin

    // aspect ratio
    case Options.VideoAspectIndex of
      0:
        VAspect := '-keepaspect';
      1:
        VAspect := '-aspect 4/3';
      2:
        VAspect := '-aspect 16/9';
      3:
        VAspect := '-aspect 1.85/1';
      4:
        VAspect := '-aspect 2.35/1';
      5:
        VAspect := '-aspect 1.3333/1';
      6:
        VAspect := '-aspect 1.7777/1';
    end;

    // subtitle encoding
    SubEncoding := 'Unicode';
    case Options.SubtitleOptions.EncodingIndex of
      0:
        SubEncoding := 'Unicode';
      1:
        SubEncoding := 'UTF-8';
      2:
        SubEncoding := 'ISO-8859-1';
      3:
        SubEncoding := 'ISO-8859-15';
      4:
        SubEncoding := 'ISO-8859-2';
      5:
        SubEncoding := 'ISO-8859-3';
      6:
        SubEncoding := 'ISO-8859-4';
      7:
        SubEncoding := 'ISO-8859-5';
      8:
        SubEncoding := 'ISO-8859-6';
      9:
        SubEncoding := 'ISO-8859-7';
      10:
        SubEncoding := 'ISO-8859-9';
      11:
        SubEncoding := 'ISO-8859-13';
      12:
        SubEncoding := 'ISO-8859-14';
      13:
        SubEncoding := 'ISO-8859-8';
      14:
        SubEncoding := 'KO18-R';
      15:
        SubEncoding := 'KO18-U/RU';
      16:
        SubEncoding := 'CP936';
      17:
        SubEncoding := 'BIG5';
      18:
        SubEncoding := 'SHIFT-JIS';
      19:
        SubEncoding := 'CP949';
      20:
        SubEncoding := 'CP874';
      21:
        SubEncoding := 'CP1251';
      22:
        SubEncoding := 'CP1250';
      23:
        SubEncoding := 'CP1256';
      24:
        SubEncoding := '';
    end;

    // deinterlacing
    if Options.EnableDeint then
    begin

      case Options.DeintMethodIndex of
        0:
          DeintCMD := 'yadif=0,';
        1:
          DeintCMD := 'yadif=1:1,';
        2:
          DeintCMD := 'yadif=3:1,';
        3:
          DeintCMD := 'pp=lb,';
        4:
          DeintCMD := 'pp=li,';
        5:
          DeintCMD := 'pp=md,';
        6:
          DeintCMD := 'pp=ci,';
        7:
          DeintCMD := 'kerndeint,';
        8:
          DeintCMD := 'lavcdeint,';
      end;

    end
    else
    begin
      DeintCMD := '';
    end;

    // cropping
    if Options.Crop then
    begin
      CropCMD := 'crop=' + Options.CropW + ':' + Options.CropH + ':' + Options.CropX + ':' + Options.Cropy + ',';
    end
    else
    begin
      CropCMD := '';
    end;

    // subtitle options
    // only if mencoder is used
    if Options.SubtitleOptions.EnableSubtitle and (MainForm.EncoderList.ItemIndex = 0) then
    begin
      with MainForm do
      begin
        case FMasterFileInfoList[Options.FileIndex].SelectedSubtitleType of
          embedded:
            begin
              if MainForm.EnableSubBtn.Checked then
              begin
                if FMasterFileInfoList[Options.FileIndex].SubtitleTrackIndex > -1 then
                begin
                  SubtitleCMD := ' -sid ' + FMasterFileInfoList[Options.FileIndex].SelectedSubtitleTrack;
                end;
              end;
            end;
          subfile:
            begin
              with Options.SubtitleOptions do
              begin
                if FileExists(FMasterFileInfoList[Options.FileIndex].SelectedSubtitleFile) then
                begin
                  if UseSSAStyle and ((LowerCase(ExtractFileExt(FMasterFileInfoList[Options.FileIndex].SelectedSubtitleFile)) = '.ass') or
                    (LowerCase(ExtractFileExt(FMasterFileInfoList[Options.FileIndex].SelectedSubtitleFile)) = '.ssa')) then
                  begin
                    SubtitleCMD := ' -ass -sub "' + FMasterFileInfoList[Options.FileIndex].SelectedSubtitleFile + '" -ass-styles "' + FMasterFileInfoList[Options.FileIndex].SelectedSubtitleFile + '"'
                  end
                  else
                  begin
                    SubtitleCMD := ' -subfont-autoscale ' + FontAutoScale + ' -subfont-blur 2 -subfont-outline 2 -subfont "' + FontPath + '" -subcp ' + SubEncoding + ' -subfont-text-scale ' +
                      TextScale + ' -sub "' + FMasterFileInfoList[Options.FileIndex].SelectedSubtitleFile + '"';

                    if length(SubEncoding) > 0 then
                    begin
                      SubtitleCMD := SubtitleCMD + ' -subcp ' + SubEncoding;
                    end;
                    SubtitleCMD := SubtitleCMD + ' -subpos ' + SubtilePosition + ' -subdelay ' + FloatToStr(Delay);
                  end;
                end
                else
                begin
                  SubtitleCMD := ' -noautosub ';
                end;
              end;
            end;
        end;
      end;
    end
    else
    begin
      SubtitleCMD := ' -noautosub ';
    end;

    // video size
    if Options.VideoSizeIndex = 0 then
    begin
      VideoSize := '';
    end
    else
    begin
      // force aspect ratio, calc. height
      if Options.ForceAspect then
      begin
        VideoSize := ' -vf ' + CropCMD + 'scale=' + Options.VWidth + ':-2';
      end
      else
      begin
        // resize video
        VideoSize := ' -vf ' + CropCMD + 'scale=' + Options.VWidth + ':' + Options.VHeight;
      end;
    end;

    // rotation
    if Options.RotateMode > 0 then
    begin
      VideoSize := VideoSize + ' -vf-add rotate=' + FloatToStr(Options.RotateMode - 1);
    end;

    // audio stream
    if (Options._AudioStream <> '-1') and (length(Options._AudioStream) > 0) then
    begin
      VideoSize := VideoSize + ' -aid ' + (Options._AudioStream)
    end;

    Params := ' -nofs -slave -noquiet -nomouseinput -identify -idx -osdlevel 1 ' + VideoSize + ' -colorkey 0x101010 ' + SubtitleCMD + ' -delay ' +
      StringReplace(FloatToStr(Options.AudioDelay), ',', '.', []) + ' ' + MPlayerRangeCMD(Options) + ' -wid ' + FloatToStr(FDisplayHandle) + ' -vo direct3d  ' + VAspect + ' -softvol -softvol-max 300 '
      + ' -volume ' + FloatToStr(Options.VideoVolumeLevel) + ' "' + Options.FileName + '"';;

    Result := Params;

  end;

end;

destructor TPlayer.Destroy;
begin

  inherited Destroy;
  FreeAndNil(FConsoleOutput);
  FMPlayer.Free;

end;

procedure TPlayer.SeekForward(Sec: Integer);
begin

  if IsMplayerAlive then
  begin
    FMPlayer.WriteLn(' seek +' + FloatToStr(Sec) + ' 0');
  end;

end;

function TPlayer.GetCommandLine: string;
begin

  Result := FMPlayer.CommandLine;

end;

function TPlayer.IsMplayerAlive: Boolean;
begin

  Result := FMPlayer.ProcessInfo.hProcess <> 0;

end;

function TPlayer.IsStringNumeric(Str: String): Boolean;
var
  p: PChar;
begin

  if length(Str) < 1 then
  begin
    Result := False;
    Exit;
  end;

  p := PChar(Str);
  Result := False;

  while p^ <> #0 do
  begin

    if (Not CharInSet(p^, ['0' .. '9'])) then
    begin
      Exit;
    end;

    Inc(p);
  end;

  Result := True;
end;

function TPlayer.MPlayerRangeCMD(Options: TPlayerOptions): string;
begin

  Result := ' -ss ' + FloatToStr(Options.StartTime) + ' -endpos ' + IntToStr(Options.EndTime - Options.StartTime);

end;

procedure TPlayer.MplayerRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
const
  ScanFile = 'Scanning file';
  ScanDir = 'Scanning dir';
var
  TmpStr: string;
  Pos1: Integer;
  Pos2: Integer;
  Positionstr: string;
begin

  if FKeepMplayerOutput then
  begin
    FConsoleOutput.Add(S);
  end;

  if (Copy(S, 1, length(ScanDir)) = ScanDir) or (Copy(S, 1, length(ScanFile)) = ScanFile) then
  begin
    FPlayerStatus := psFontCache;
    Exit;
  end;

  FMplayerOutput := S;

  // if video position fails
  // try audio

  if length(FMplayerOutput) > 0 then
  begin
    TmpStr := FMplayerOutput;

    // video position
    Pos1 := Pos('V:', TmpStr);
    Pos2 := Pos('A-V:', TmpStr);

    if Pos2 > Pos1 then
    begin
      Positionstr := Trim(Copy(TmpStr, Pos1 + 2, (Pos2 - Pos1 - 2)));
      Delete(Positionstr, length(Positionstr) - 1, 2);

      if IsStringNumeric(Positionstr) then
      begin
        FProgress := StrToInt(Positionstr);
      end;

    end
    else
    begin
      // video position failed.
      // try audio only
      Pos1 := Pos('A:', TmpStr);
      Pos2 := Pos('(', TmpStr);

      if Pos2 > Pos1 then
      begin
        Positionstr := Trim(Copy(TmpStr, Pos1 + 2, (Pos2 - Pos1 - 2)));
        Delete(Positionstr, length(Positionstr) - 1, 2);

        if IsStringNumeric(Positionstr) then
        begin
          FProgress := StrToInt(Positionstr);
        end;

      end
      else
      begin
        // audio only failed
        // try video only
        Pos1 := Pos('V:', TmpStr);
        Pos2 := Pos('0/', TmpStr);

        if Pos2 > Pos1 then
        begin
          Positionstr := Trim(Copy(TmpStr, Pos1 + 2, (Pos2 - Pos1 - 2)));
          Delete(Positionstr, length(Positionstr) - 1, 2);

          if IsStringNumeric(Positionstr) then
          begin
            FProgress := StrToInt(Positionstr);
          end;

        end;

      end;

    end;

  end
  else
  begin
    FMplayerOutput := 'N/A';
  end;

end;

procedure TPlayer.Pause;
begin

  if IsMplayerAlive then
  begin
    FMPlayer.WriteLn(' pause ');

    // change status
    if FPlayerStatus = psPlaying then
    begin
      FPlayerStatus := psPaused;
    end
    else
    begin
      FPlayerStatus := psPlaying;
    end;

  end;

end;

procedure TPlayer.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin

  // change status
  FPlayerStatus := psStopped;

  if FKeepMplayerOutput then
  begin
    FConsoleOutput.Add(FMPlayer.CommandLine);
  end;

end;

procedure TPlayer.SeekBack(Sec: Integer);
begin

  if IsMplayerAlive then
  begin
    FMPlayer.WriteLn(' seek -' + FloatToStr(Sec) + ' 0');
  end;

end;

function TPlayer.Seek(Position: Integer): Boolean;
begin

  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(AnsiString(' seek ' + FloatToStr(Position) + ' 2'));
  end;

end;

function TPlayer.SetAudioDelay(Count: Integer): Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(' audio_delay ' + FloatToStr(Count * 0.5) + ' 1');
  end;

end;

function TPlayer.SetVolume(VolumeLevel: Integer): Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(' volume ' + FloatToStr(VolumeLevel) + ' 2');
  end;
end;

procedure TPlayer.StartPlaying;
begin

  if not IsMplayerAlive then
  begin

    // command lines
    FMPlayer.CommandLine := CreatePlayerCommandLine(FPlayerOptions);

    if length(FMPlayer.CommandLine) > 0 then
    begin
      FMPlayer.Run;
      // change status
      FPlayerStatus := psPlaying;
    end;

  end;

end;

procedure TPlayer.Stop;
begin

  if IsMplayerAlive then
  begin
    FMPlayer.WriteLn(' quit ');
    // change status
    FPlayerStatus := psStopped;
  end;

end;

function TPlayer.SubtitleDelaYDown(Count: Integer): Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(' sub_delay -0.1 0');
  end;

end;

function TPlayer.SubtitleDelayUp(Count: Integer): Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn(' sub_delay +0.1 0');
  end;

end;

function TPlayer.VolumeDown: Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn('volume -1 0');
  end;

end;

function TPlayer.VolumeUp: Boolean;
begin
  Result := False;
  if IsMplayerAlive then
  begin
    Result := FMPlayer.WriteLn('volume +1 0');
  end;

end;

end.
