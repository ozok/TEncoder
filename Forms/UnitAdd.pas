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
unit UnitAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, sSkinProvider, Buttons,
  sBitBtn;

type
  TAddForm = class(TForm)
    StatusLabel: TLabel;
    sSkinProvider1: TsSkinProvider;
    AbortBtn: TsBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AbortBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddForm: TAddForm;

implementation

uses UnitMain;

{$R *.dfm}

procedure TAddForm.AbortBtnClick(Sender: TObject);
begin

  if MainForm.SearchVideo.Searching then
  begin
    MainForm.SearchVideo.Abort;
  end
  else
  begin
    MainForm.FFileAddingStoppedByUser := True;
  end;

end;

procedure TAddForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  StatusLabel.Caption := 'Adding files, please wait...';

  MainForm.Enabled := True;
  MainForm.BringToFront;

end;

procedure TAddForm.FormCreate(Sender: TObject);
begin

  StatusLabel.Caption := 'Adding files, please wait...';

end;

end.
