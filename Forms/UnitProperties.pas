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
unit UnitProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Vcl.ComCtrls;

type
  TInfoForm = class(TForm)
    OkBtn: TButton;
    Infos: TListView;
    SaveBtn: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    InfoList: TStringList;
  end;

var
  InfoForm: TInfoForm;

implementation

uses UnitMain;

{$R *.dfm}

procedure TInfoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  InfoList.Clear;
  Infos.Items.Clear;

  MainForm.Enabled := True;
  MainForm.BringToFront;

end;

procedure TInfoForm.FormCreate(Sender: TObject);
begin

  InfoList := TStringList.Create;;
end;

procedure TInfoForm.FormDestroy(Sender: TObject);
begin

  FreeAndNil(InfoList);

end;

procedure TInfoForm.FormResize(Sender: TObject);
begin
  Infos.Columns[1].Width := Infos.ClientWidth - Infos.Columns[0].Width;
end;

procedure TInfoForm.OkBtnClick(Sender: TObject);
begin

  InfoForm.Close;

end;

procedure TInfoForm.SaveBtnClick(Sender: TObject);
begin

  if SaveDialog1.Execute then
  begin
    InfoList.SaveToFile(SaveDialog1.FileName);
  end;

end;

end.