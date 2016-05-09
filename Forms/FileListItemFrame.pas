unit FileListItemFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TFileListFrame = class(TFrame)
    FileImage: TImage;
    FileNameLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    SubtitleList: TComboBox;
    AudioList: TComboBox;
    ProgressBar: TProgressBar;
    Panel1: TPanel;
    RemoveBtn: TButton;
    PreviewBtn: TButton;
    RangeBtn: TButton;
    SubtitleTypeList: TComboBox;
    FileInfoLabel: TLabel;
    Bevel1: TBevel;
    FileInfoBtn: TButton;
    OpenFolderBtn: TButton;
    ImageList1: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
