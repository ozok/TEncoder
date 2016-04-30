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
unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ShellAPI, Buttons, IniFiles, JvComponentBase,
  JvThread, JvUrlListGrabber, JvUrlGrabbers, Vcl.ComCtrls;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    OkBtn: TBitBtn;
    HomepageBtn: TBitBtn;
                                   
    sPageControl1: TPageControl;
    sTabSheet1: TTabSheet;
    sTabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    sLabel4: TLabel;
    sLabel6: TLabel;
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
  ShellExecute(0, 'open', 'http://www.ozok26.com/tencoder-vdeo-converter-1', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label14Click(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar((Sender as TLabel).Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.Label6Click(Sender: TObject);
begin

  ShellExecute(0, 'open', PChar((Sender as TLabel).Caption), nil, nil, SW_SHOWNORMAL);

end;

procedure TAboutForm.OkBtnClick(Sender: TObject);
begin

  AboutForm.Close;

end;

end.