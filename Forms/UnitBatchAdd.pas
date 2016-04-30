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
unit UnitBatchAdd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMode = (singlelink, playlist);

type
  TBatchAddForm = class(TForm)
    LinksList: TMemo;
    Label1: TLabel;
    CancelBtn: TButton;
    OkBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PMode: TMode;
  end;

var
  BatchAddForm: TBatchAddForm;

implementation

{$R *.dfm}

uses
  UnitMain;

procedure TBatchAddForm.CancelBtnClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBatchAddForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TBatchAddForm.FormShow(Sender: TObject);
begin
  LinksList.Lines.Clear;
end;

procedure TBatchAddForm.OkBtnClick(Sender: TObject);
begin
  if LinksList.Lines.Count > 0 then
  begin
    Self.Close;
    case PMode of
      singlelink:
        MainForm.BatchAdd(LinksList.Lines, True);
      playlist:
        MainForm.BatchAdd(LinksList.Lines, False);
    end;
  end
  else
  begin
    Application.MessageBox('You need to add links to proceed.', 'Error', MB_ICONERROR);
  end;
end;

end.

