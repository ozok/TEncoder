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
unit UnitLogs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sSkinProvider, ComCtrls, sListBox,
  sComboBox, Menus, sPageControl, acProgressBar, sMemo, System.Types;

type
  TLogForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    OkBtn: TsBitBtn;
    ClearBtn: TsBitBtn;
    SaveBtn: TsBitBtn;
    SaveDialog: TSaveDialog;
    ClearPopup: TPopupMenu;
    ClearSelected1: TMenuItem;
    ClearAll1: TMenuItem;
    VideoEncoderList: TsMemo;
    MPlayerLogList: TMemo;
    Logs: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet9: TsTabSheet;
    sTabSheet10: TsTabSheet;
    OtherLog: TsMemo;
    sTabSheet11: TsTabSheet;
    LogList: TsComboBox;
    DownloadLog: TsMemo;
    sTabSheet12: TsTabSheet;
    MainLog: TsMemo;
    VideoEncoderLogsList: TsComboBox;
    sTabSheet2: TsTabSheet;
    DVDPages: TsPageControl;
    sTabSheet3: TsTabSheet;
    sTabSheet4: TsTabSheet;
    DVDLog: TsMemo;
    DVDCMDLog: TsMemo;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ClearAll1Click(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearSelected1Click(Sender: TObject);
    procedure LogListChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VideoEncoderLogsListChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FEncoderLogs: array [0 .. 15] of TStringList;
  end;

var
  LogForm: TLogForm;

implementation

uses UnitMain;

{$R *.dfm}

procedure TLogForm.ClearAll1Click(Sender: TObject);
var
  I: Integer;
begin
  MainLog.Lines.Clear;
  for I := Low(FEncoderLogs) to High(FEncoderLogs) do
  begin
    FEncoderLogs[i].Clear;
  end;
  VideoEncoderList.Lines.Clear;
  MPlayerLogList.Lines.Clear;
  OtherLog.Lines.Clear;
  DownloadLog.Lines.Clear;
  DVDLog.Lines.Clear;
  DVDCMDLog.Lines.Clear;
end;

procedure TLogForm.ClearBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := ClearBtn.ClientToScreen(Point(0, 0));
  ClearPopup.Popup(P.X, P.Y + ClearBtn.Height)
end;

procedure TLogForm.ClearSelected1Click(Sender: TObject);
begin
  case Logs.ActivePageIndex - 1 of
    0:
      begin
        MainLog.Lines.Clear;
      end;
    1:
      begin
        FEncoderLogs[VideoEncoderLogsList.ItemIndex].Clear;
        VideoEncoderList.Lines.Clear;
      end;
    2:
      begin
        MPlayerLogList.Lines.Clear;
      end;
    3:
      begin
        OtherLog.Lines.Clear;
      end;
    4:
      begin
        DownloadLog.Lines.Clear;
      end;
    5:
      begin
        case DVDPages.ActivePageIndex of
          0:
            DVDLog.Lines.Clear;
          1:
            DVDCMDLog.Lines.Clear;
        end;
      end;
  end;
end;

procedure TLogForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  // encoder logs
  for I := Low(FEncoderLogs) to High(FEncoderLogs) do
  begin
    FEncoderLogs[i] := TStringList.Create;
    FEncoderLogs[i].Add(Format(' Encoder %d log', [i + 1]));
  end;

  MPlayerLogList.Lines.Add(' Mplayer Log');
end;

procedure TLogForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(FEncoderLogs) to High(FEncoderLogs) do
  begin
    FEncoderLogs[i].Free;
  end;
end;

procedure TLogForm.FormShow(Sender: TObject);
var
  I: Integer;
begin
  Logs.Enabled := False;
  try
    // reset
    for I := Low(FEncoderLogs) to High(FEncoderLogs) do
    begin
      FEncoderLogs[i].Clear;
    end;
    // load command lines and console output
    VideoEncoderLogsListChange(Self);

    // generate logs first
    MainForm.SaveDownloadLogs;
    // load selected log if it exists
    LogListChange(Self);

    // dvd encoder log
    DVDLog.Lines.Clear;
    DVDLog.Lines.AddStrings(MainForm.FDVDRipperProcess.GetConsoleOutput);
  finally
    Logs.Enabled := True;
    Self.Width := Self.Width + 1;
    Self.Width := Self.Width - 1;
  end;
end;

procedure TLogForm.LogListChange(Sender: TObject);
begin
  // load selected log
  DownloadLog.Lines.Clear;
  if LogList.ItemIndex = (LogList.Items.Count - 1) then
  begin
    if FileExists(MainForm.FLogFolder + '\cmd.txt') then
    begin
      DownloadLog.Lines.LoadFromFile(MainForm.FLogFolder + '\cmd.txt');
    end;
  end
  else
  begin
    if FileExists(MainForm.FLogFolder + '\' + FloatToStr(LogList.ItemIndex + 1) + 'log.txt') then
    begin
      DownloadLog.Lines.LoadFromFile(MainForm.FLogFolder + '\' + FloatToStr(LogList.ItemIndex + 1) + 'log.txt');
    end;
  end;
end;

procedure TLogForm.OkBtnClick(Sender: TObject);
begin
  LogForm.Close;
end;

procedure TLogForm.SaveBtnClick(Sender: TObject);
begin
  SaveDialog.FileName := 'EncoderLog' + FloatToStr(Logs.ActivePageIndex) + '.txt';
  if SaveDialog.Execute then
  begin
    case Logs.ActivePageIndex - 1 of
      0:
        begin
          MainLog.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
        end;
      1:
        begin
          FEncoderLogs[VideoEncoderLogsList.ItemIndex].SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
        end;
      2:
        begin
          SaveDialog.FileName := 'MPlayerLog.txt';
          MPlayerLogList.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
        end;
      3:
        begin
          OtherLog.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
        end;
      4:
        begin
          DownloadLog.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
        end;
      5:
        begin
          case DVDPages.ActivePageIndex of
            0:
              DVDLog.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
            1:
              DVDCMDLog.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
          end;
        end;
    end;
  end;
end;

procedure TLogForm.VideoEncoderLogsListChange(Sender: TObject);
var
  i: integer;
begin
  VideoEncoderList.Lines.Clear;
  VideoEncoderList.Lines.Add(Format('Encoder %d log', [VideoEncoderLogsList.ItemIndex + 1]));
  VideoEncoderList.Lines.Add(Format('Encoder %d command lines:', [VideoEncoderLogsList.ItemIndex + 1]));
  for I := 0 to MainForm.FEncoders[VideoEncoderLogsList.ItemIndex].EncodeJobs.Count - 1 do
  begin
    VideoEncoderList.Lines.Add(MainForm.FEncoders[VideoEncoderLogsList.ItemIndex].EncodeJobs[i].CommandLine);
  end;
  VideoEncoderList.Lines.Add('');
  VideoEncoderList.Lines.Add(Format('Encoder %d console outputs:', [VideoEncoderLogsList.ItemIndex + 1]));
  VideoEncoderList.Lines.AddStrings(MainForm.FEncoders[VideoEncoderLogsList.ItemIndex].GetConsoleOutput);
end;

end.
