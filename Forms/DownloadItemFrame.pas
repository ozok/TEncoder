{ *
  * Copyright (C) 2011-2016 ozok <ozok26@gmail.com>
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
unit DownloadItemFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, 
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, 
  Vcl.StdCtrls, Vcl.Samples.Gauges;

type
  TDownloadUIItem = class(TFrame)
    LinkLabel: TLabel;
    FileNameLabel: TLabel;
    FormatList: TComboBox;
    SubtitleList: TComboBox;
    ProgressLabel: TLabel;
    ProgressBar: TGauge;
    sPanel1: TPanel;
    DeleteButton: TButton;
    sPanel2: TPanel;
    PrevievImg: TImage;
    sBevel1: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ResetProgressLabel;
    procedure Disable;
    procedure Enable;
  end;

implementation

{$R *.dfm}
{ TDownloadUIItem }

procedure TDownloadUIItem.Disable;
begin
  LinkLabel.Enabled := False;
  FileNameLabel.Enabled := False;
  FormatList.Enabled := False;
  SubtitleList.Enabled := False;
  DeleteButton.Enabled := False;
end;

procedure TDownloadUIItem.Enable;
begin
  LinkLabel.Enabled := True;
  FileNameLabel.Enabled := True;
  FormatList.Enabled := True;
  SubtitleList.Enabled := True;
  DeleteButton.Enabled := True;
end;

procedure TDownloadUIItem.ResetProgressLabel;
begin
  ProgressLabel.Caption := '';
  ProgressBar.Progress := 0;
end;

end.