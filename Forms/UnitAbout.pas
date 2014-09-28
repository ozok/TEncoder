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
unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, acPNG, ShellAPI, Buttons, sBitBtn, sLabel,
  sCheckBox, IniFiles, JvComponentBase, JvThread, JvUrlListGrabber,
  JvUrlGrabbers, sSkinProvider, sPanel, Vcl.ComCtrls, sPageControl;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    OkBtn: TsBitBtn;
    HomepageBtn: TsBitBtn;
    sSkinProvider1: TsSkinProvider;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    Label1: TsLabel;
    Label2: TsLabel;
    Label3: TsLabel;
    Label4: TsLabel;
    Label13: TsLabel;
    Label10: TsLabel;
    Label11: TsLabel;
    Label12: TsLabel;
    Label5: TsLabel;
    Label6: TsLabel;
    Label7: TsLabel;
    Label8: TsLabel;
    Label9: TsLabel;
    sLabel4: TsLabel;
    sLabel6: TsLabel;
    procedure OkBtnClick(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure HomepageBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label14Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses UnitMain;

{$R *.dfm}

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  MainForm.Enabled := True;
  MainForm.BringToFront;

end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
{$IFDEF WIN32}
  Label2.Caption := Label2.Caption + ' Win32'
{$ELSE}
  Label2.Caption := Label2.Caption + ' Win64'
{$ENDIF}
end;

procedure TAboutForm.HomepageBtnClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://tencoder.sourceforge.net/', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label14Click(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar((Sender as TLabel).Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label6Click(Sender: TObject);
begin

  ShellExecute(0, 'open', PChar((Sender as TsLabel).Caption), nil, nil, SW_SHOWNORMAL);

end;

procedure TAboutForm.OkBtnClick(Sender: TObject);
begin

  AboutForm.Close;

end;

end.
