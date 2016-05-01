{ *
  * Copyright (C) 2011-2016 ozok <ozok26@gmail.com>
  *
  * This file is part of TEncoder.
  *
  * TEncoder is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License.
  * 
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
unit UnitDub;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.Mask, UnitEncoder, Vcl.ExtCtrls, JvExMask, JvToolEdit;

type
  TDubForm = class(TForm)
    OutputEdit: TEdit;
    ProgressLabel: TLabel;
    ContainerList: TComboBox;
    StopBtn: TBitBtn;
    StartBtn: TBitBtn;
    PosTimer: TTimer;
    VideoEdit: TJvFilenameEdit;
    AudioEdit: TJvFilenameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartBtnClick(Sender: TObject);
    procedure PosTimerTimer(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  private
    { Private declarations }
    FEncoder: TEncodingProcess;
    FDuration: string;
    FOutputFile: string;
    procedure EncodingState;
    procedure NormalState;
    function CreateCMD: string;
    procedure DeleteTempFile;
  public
    { Public declarations }
  end;

var
  DubForm: TDubForm;

implementation

{$R *.dfm}

uses
  UnitLogs, UnitMain, UnitImageAudioMerger;

function TDubForm.CreateCMD: string;
var
  LExt: string;
  LCMD: string;
  LEncodeJob: TEncodeJob;
begin

  // get video without the audio
  LCMD := ' -y -i "' + VideoEdit.Text + '" -an -c:v copy "' + MainForm.DirectoryEdit.Text + '\TEncoder_temp.mkv"';
  LEncodeJob.CommandLine := LCMD;
  LEncodeJob.ProcessPath := MainForm.FFFMpegPath;
  LEncodeJob.ProcessType := ffmpeg;
  LEncodeJob.EncodingInformation := 'Dubbing';
  LEncodeJob.EncodingOutputFilePath := FOutputFile;
  LEncodeJob.SourceFileName := '';
  FEncoder.EncodeJobs.Add(LEncodeJob);

  LCMD := ' -y -i "' + AudioEdit.Text + '" -i "' + MainForm.DirectoryEdit.Text + '\TEncoder_temp.mkv" -c:v copy -c:a copy ';
  case ContainerList.ItemIndex of
    0:
      begin
        LCMD := LCMD + ' -f avi ';
        LExt := '.avi';
      end;
    1:
      begin
        LCMD := LCMD + ' -f mpeg ';
        LExt := '.mpeg';
      end;
    2:
      begin
        LCMD := LCMD + ' -f mp4 ';
        LExt := '.mp4';
      end;
    3:
      begin
        LCMD := LCMD + ' -f mov ';
        LExt := '.mov';
      end;
    4:
      begin
        LCMD := LCMD + ' -f matroska ';
        LExt := '.mkv';
      end;
    5:
      begin
        LCMD := LCMD + ' -f flv ';
        LExt := '.flv';
      end;
    6:
      begin
        LCMD := LCMD + ' -f wmv ';
        LExt := '.wmv';
      end;
    7:
      begin
        LCMD := LCMD + ' -f webm ';
        LExt := '.webm';
      end;
    8:
      begin
        Result := Result + ' -f 3gp ';
        LExt := '.3gp';
      end;
  end;
  LCMD := LCMD + ' "' + ImageAudiotoVideoForm.CreateFileName(OutputEdit.Text, LExt) + '"';
  LEncodeJob.CommandLine := LCMD;
  LEncodeJob.ProcessPath := MainForm.FFFMpegPath;
  LEncodeJob.ProcessType := ffmpeg;
  LEncodeJob.EncodingInformation := 'Dubbing';
  LEncodeJob.EncodingOutputFilePath := FOutputFile;
  LEncodeJob.SourceFileName := '';
  FEncoder.EncodeJobs.Add(LEncodeJob);
end;

procedure TDubForm.DeleteTempFile;
begin
  if FileExists(MainForm.DirectoryEdit.Text + '\TEncoder_temp.mkv') then
  begin
    DeleteFile(MainForm.DirectoryEdit.Text + '\TEncoder_temp.mkv')
  end;
end;

procedure TDubForm.EncodingState;
begin
  StartBtn.Enabled := False;
  StopBtn.Enabled := True;
  AudioEdit.Enabled := False;
  VideoEdit.Enabled := False;
  OutputEdit.Enabled := False;
end;

procedure TDubForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FEncoder.ProcessID > 0 then
  begin
    FEncoder.Stop;
  end;
  DeleteTempFile;
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TDubForm.FormCreate(Sender: TObject);
begin
  FEncoder := TEncodingProcess.Create;
  VideoEdit.Dialog.Filter := 'Video Files|*.flv;*.m2v;*.avi;*.mkv;*.mpeg;*.mpg;*.mov;*.wmv;*.mp4;' + '*.m4v;*.dat;*.vob;*.rmvb;*.mts;*.mxf';
  AudioEdit.Dialog.Filter := 'Audio Files|*.mp3;*.wav;*.aac;*.m4a;*.m4b;*.ac3;*.ogg;*.flac;*.mp2;*.opus;*.spx';
  DeleteTempFile;
end;

procedure TDubForm.FormDestroy(Sender: TObject);
begin
  FEncoder.Free;
end;

procedure TDubForm.FormShow(Sender: TObject);
begin
  FEncoder.ResetValues;
  AudioEdit.Text := '';
  VideoEdit.Text := '';
  OutputEdit.Text := '';
  ProgressLabel.Caption := 'FFMpeg output';
  FDuration := '0';
end;

procedure TDubForm.NormalState;
begin
  StartBtn.Enabled := True;
  StopBtn.Enabled := False;
  AudioEdit.Enabled := True;
  VideoEdit.Enabled := True;
  OutputEdit.Enabled := True;
  LogForm.OtherLog.Lines.Add('Dubbing:');
  if FEncoder.CommandCount > 0 then
  begin
    LogForm.OtherLog.Lines.AddStrings(FEncoder.GetConsoleOutput);
  end;
  LogForm.OtherLog.Lines.AddStrings(FEncoder.GetConsoleOutput);
end;

procedure TDubForm.PosTimerTimer(Sender: TObject);
begin
  if FEncoder.FilesDone = FEncoder.CommandCount then
  begin
    PosTimer.Enabled := False;
    ProgressLabel.Caption := 'FFMpeg output';
    FDuration := '0';
    DeleteTempFile;
    NormalState;
    Self.BringToFront;
    Application.MessageBox('Finished dubbing.', 'Info', MB_ICONINFORMATION);
  end
  else
  begin
    ProgressLabel.Caption := FEncoder.ConsoleOutput;
  end;
end;

procedure TDubForm.StartBtnClick(Sender: TObject);
var
  LCMD: string;
begin
  if FileExists(AudioEdit.Text) then
  begin
    if FileExists(VideoEdit.Text) then
    begin
      if Length(OutputEdit.Text) > 0 then
      begin
        // todo: check file name for valid chars
        if MainForm.VideoEncoderList.ItemIndex < 10 then
        begin
          if (MainForm.AudioEncoderList.ItemIndex <> 10) then
          begin

            // reset
            FEncoder.ResetValues;
            ProgressLabel.Caption := 'FFMpeg output';
            FDuration := '0';
            FOutputFile := '';
            DeleteTempFile;

            // create command line
            LCMD := CreateCMD;
            if FEncoder.CommandCount > 0 then
            begin
              FEncoder.Start;
              PosTimer.Enabled := True;
              EncodingState;
            end
            else
            begin
              Application.MessageBox('Cannot create command line.', 'Error', MB_ICONERROR)
            end;
          end
          else
          begin
            Application.MessageBox('Select an audio encoder.', 'Warning', MB_ICONWARNING)
          end;
        end
        else
        begin
          Application.MessageBox('Select an video encoder.', 'Warning', MB_ICONWARNING)
        end;

      end
      else
      begin
        Application.MessageBox('Enter a valid output name.', 'Error', MB_ICONERROR)
      end;
    end
    else
    begin
      Application.MessageBox('Cannot find the video file.', 'Error', MB_ICONERROR)
    end;
  end
  else
  begin
    Application.MessageBox('Cannot find the audio file.', 'Error', MB_ICONERROR)
  end;
end;

procedure TDubForm.StopBtnClick(Sender: TObject);
begin
  if FEncoder.ProcessID > 0 then
  begin
    FEncoder.Stop;
    PosTimer.Enabled := False;
    ProgressLabel.Caption := 'FFMpeg Output';
    FDuration := '0';
    DeleteTempFile;
    NormalState;
  end;
end;

end.

