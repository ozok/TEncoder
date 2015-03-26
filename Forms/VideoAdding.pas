unit VideoAdding;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sButton,
  sLabel, Vcl.ComCtrls, acProgressBar;

type
  TVideoAddingForm = class(TForm)
    sSkinProvider1: TsSkinProvider;
    VideoAddBar: TsProgressBar;
    InfoLabel: TsLabel;
    AbortVideoAddBtn: TsButton;
    procedure AbortVideoAddBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VideoAddingForm: TVideoAddingForm;

implementation

{$R *.dfm}

uses UnitMain;

procedure TVideoAddingForm.AbortVideoAddBtnClick(Sender: TObject);
begin
  MainForm.FStopAddingLink := True;
end;

procedure TVideoAddingForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
end;

end.
