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
unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, JvComponentBase, Mask, ComCtrls, JvComputerInfoEx,
  JvThreadTimer, ShellAPI, IniFiles, JvBaseDlg, JvBrowseFolder, JvSearchFiles,
  Menus, MediaInfoDll, Buttons, sBitBtn, sListBox,
  sComboBox, sEdit, sButton, sCheckBox, sLabel, AppEvnts, ExtCtrls,
  sPanel, windows7taskbar, acPNG, sGauge, JvDragDrop,
  sSkinProvider, sSkinManager, JvFormPlacement, JvAppStorage, JvAppIniStorage,
  JvSpin, StrUtils, UnitFFmpegCommandLineCreator,
  UnitMencoderCommandLineCreator, JvTimer, acTitleBar, JvTrayIcon, JvSimScope, UnitEncoder, sTreeView, sSpinEdit,
  sPageControl, Vcl.XPMan, Vcl.ToolWin, sToolBar, sListView, Vcl.ImgList,
  acAlphaImageList, acProgressBar, Generics.Collections, DateUtils, System.Zip, System.Types,
  sScrollBox, UnitYouTubeVideoInfoExtractor, UnitCommonTypes, acImage, UnitFileNameExtractor, Jpeg, Winapi.MMSystem,
  sMaskEdit, sCustomComboEdit, sToolEdit, sGroupBox, UnitDVDReader,
  JvUrlListGrabber, JvUrlGrabbers, JvThread, sStatusBar, UnitDownloadProcess, UnitDVDRipperProcess, UnitFileInfoExtractor,
  sDialogs, UnitDVDJob;

type
  TFileInfoForAdding = packed record
    VideoStr: string;
    AudioStr: string;
    DurationStr: string;
    AudioDelay: string;
    SubDelay: string;
  end;

type
  TFileDatePair = record
    CreateDate: TDateTime;
    ModifiedDate: TDateTime;
  end;

type
  TSubtitleType = (embedded = 0, subfile = 1);

type
  TSubtitleTrack = packed record
    Info: string;
    ID: integer;
  end;

  // holds information about a file in the file list
type
  TFileInfoItem = class(TObject)
    // Video ids
    FFMmpegVideoID: integer;
    MEncoderVideoID: integer;
    // subtitle
    SubtitleFiles: TStringList;
    SubtitleIndex: integer;
    SubtitleDelay: Extended;
    SubtitleTracks: TStringList;
    SubtitleTrackIndex: integer;
    SubtitleTrackIndexes: TList<Integer>;
    SelectedSubtitleType: TSubtitleType;
    // audio
    AudioTracks: TStringList;
    AudioIndex: integer;
    AudioIDs: TList<Integer>;
    AudioMencoderIDs: TList<Integer>;
    AudioExtensions: TStringList;
    AudioDelay: Extended;
    // range
    StartPosition: integer;
    EndPosition: integer;
    ConstDuration: integer;
    // general
    FilePath: string;
    FileDate: TFileDatePair;
  private
    function GetSubtitle: string;
    function GetAudioID: string;
    function GetAudioExt: string;
    function GetMencoderAudioID: string;
    function GetSubtitleTrackID: string;
  public
    property SelectedSubtitleFile: string read GetSubtitle;
    property SelectedSubtitleTrack: string read GetSubtitleTrackID;
    property SelectedAudio: string read GetAudioID;
    property SelectedMEncoderAudio: string read GetMencoderAudioID;
    property SelectedAudioExt: string read GetAudioExt;

    constructor Create;
    destructor Destroy; override;
  end;

  TFileInfoList = TList<TFileInfoItem>;

  // control for video downloader that has thumbnail, formatlist etc
type
  TVideoDownloaderItem = class(TCustomControl)
    Panel: TsPanel;
    Panel2: TsPanel;
    Panel3: TsPanel;
    LinkLabel: TsLabel;
    ProgressLabel: TsLabel;
    PrevievImg: TsImage;
    DeleteButton: TsButton;
    FileNameLabel: TsLabel;
    FormatList: TsComboBox;
    SubtitleList: TsComboBox;
    ProgressBar: TsProgressBar;
    procedure ResetProgressLabel;
    constructor Create(const ParentControl: TsScrollBox; const _Index: integer; const PreviousBottom: Integer);
    Destructor Destroy; override;
  end;

  TMyListItemList = TList<TVideoDownloaderItem>;

  // dvd ripper command line
type
  TCommandLine = record
    SinglePassCMD: string;
    FirstPassCMD: string;
    SeconPassCMD: string;
    OutputFile: string;
  end;

type
  TMainForm = class(TForm)
{$REGION 'controls'}
    Info: TJvComputerInfoEx;
    SearchVideo: TJvSearchFiles;
    SelectDirectoryDialog: TJvBrowseForFolderDialog;
    ListMenu: TPopupMenu;
    AddFiles1: TMenuItem;
    AddFolder1: TMenuItem;
    AddFolderTree1: TMenuItem;
    Remove1: TMenuItem;
    RemoveAll1: TMenuItem;
    Up1: TMenuItem;
    Down1: TMenuItem;
    OpenDirectory1: TMenuItem;
    Properties1: TMenuItem;
    DirectoryEdit: TsEdit;
    SelectBtn: TsBitBtn;
    EncoderList: TsComboBox;
    Preview1: TMenuItem;
    ProfileList: TsComboBox;
    ApplyProfileBtn: TsBitBtn;
    NewProfileBtn: TsBitBtn;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    AddFile1: TMenuItem;
    AddFolder2: TMenuItem;
    AddFolderTree2: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    RemoveAll2: TMenuItem;
    RemoveAll3: TMenuItem;
    Up2: TMenuItem;
    Down2: TMenuItem;
    SubtitleOptions1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    SelectNone1: TMenuItem;
    ReverseSelection1: TMenuItem;
    SubtitleOptions2: TMenuItem;
    SelectAll1: TMenuItem;
    SelectNone2: TMenuItem;
    ReverseSelection2: TMenuItem;
    AddMenu: TPopupMenu;
    AddFile2: TMenuItem;
    AddFolder3: TMenuItem;
    AddFolderTree3: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    ContainerList: TsComboBox;
    OpenOutDirBtn: TsBitBtn;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    AppIniFileStorage: TJvAppIniFileStorage;
    FormStorage: TJvFormStorage;
    DoTwoPassBtn: TsCheckBox;
    EnableSubBtn: TsCheckBox;
    ExportScriptBtn: TsCheckBox;
    ConvertingPanel: TsPanel;
    TotalProgress: TsProgressBar;
    DragDrop: TJvDragDrop;
    UseSourceChkBtn: TsCheckBox;
    PositionTimer: TTimer;
    NormalPanel: TsPanel;
    Timer: TTimer;
    TrayIcon: TJvTrayIcon;
    SeeChangeLog1: TMenuItem;
    SummaryView: TsTreeView;
    V1: TMenuItem;
    XPManifest1: TXPManifest;
    S1: TMenuItem;
    M1: TMenuItem;
    VideoEncoderList: TsComboBox;
    VideoSettingsBtn: TsBitBtn;
    AudioEncoderList: TsComboBox;
    T1: TMenuItem;
    F1: TMenuItem;
    T2: TMenuItem;
    D1: TMenuItem;
    E1: TMenuItem;
    C1: TMenuItem;
    ProgressList: TsListView;
    ProgressImages: TsAlphaImageList;
    S2: TMenuItem;
    ToolsMenu: TPopupMenu;
    Scriptsfolder1: TMenuItem;
    VideoEffects1: TMenuItem;
    Delays1: TMenuItem;
    rim1: TMenuItem;
    FileInfo1: TMenuItem;
    SubOptionsBtn: TsButton;
    MainSummaryList: TsTreeView;
    ProgressLabel: TsLabel;
    I1: TMenuItem;
    ImageandAudiotoVideo1: TMenuItem;
    DummyList: TsAlphaImageList;
    D2: TMenuItem;
    R1: TMenuItem;
    M2: TMenuItem;
    G1: TMenuItem;
    V2: TMenuItem;
    FuncPages: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    FileList: TsListView;
    SubtitleTracksList: TsComboBox;
    AudioTracksList: TsComboBox;
    sToolBar1: TsPanel;
    AddFileBtn: TsBitBtn;
    UpBtn: TsBitBtn;
    DownBtn: TsBitBtn;
    RemoveBtn: TsBitBtn;
    RemoveAllBtn: TsBitBtn;
    ToolsBtn: TsBitBtn;
    PreviewBtn: TsBitBtn;
    StartBtn: TsBitBtn;
    DonateBtn: TsBitBtn;
    SettingsBtn: TsBitBtn;
    LogsBtn: TsBitBtn;
    VideoDownloadToolBarPanel: TsPanel;
    AddLinkBtn: TsBitBtn;
    ClearLinksBtn: TsBitBtn;
    DownloadSettingsBtn: TsBitBtn;
    StartDownloadBtn: TsBitBtn;
    StopDownloadBtn: TsBitBtn;
    PageImgs: TsAlphaImageList;
    VideoDownloaderList: TsScrollBox;
    AddLinkMenu: TPopupMenu;
    A3: TMenuItem;
    Batchaddlinks1: TMenuItem;
    A2: TMenuItem;
    Batchaddplaylists1: TMenuItem;
    TotalBar: TsProgressBar;
    VideoDownloaderPosTimer: TTimer;
    ConvertDownloadedBtn: TsCheckBox;
    U1: TMenuItem;
    sTabSheet3: TsTabSheet;
    sGroupBox1: TsGroupBox;
    DVDFolderEdit: TsDirectoryEdit;
    ReadDVDBtn: TsBitBtn;
    OutputFileNameEdit: TsEdit;
    sGroupBox2: TsGroupBox;
    DVDAudioTracksList: TsComboBox;
    DisableAudioBtn: TsCheckBox;
    DisableSubBtn: TsCheckBox;
    DVDSubtitleTracksList: TsComboBox;
    TitlesList: TsComboBox;
    StartChaperList: TsComboBox;
    EndChapterList: TsComboBox;
    DVDLoadPnl: TsPanel;
    ProgressBar1: TsProgressBar;
    sPanel1: TsPanel;
    OpenDVDBtn: TsBitBtn;
    DVDConsoleEdit: TsEdit;
    DVDProgressBar: TsProgressBar;
    sImage1: TsImage;
    DVDPosTimer: TTimer;
    DVDStopBtn: TsBitBtn;
    VideoDownloaderProgressLabel: TsLabel;
    S3: TMenuItem;
    CheckUpdateThread: TJvThread;
    UpdateChecker: TJvHttpUrlGrabber;
    W1: TMenuItem;
    sPanel2: TsPanel;
    sPanel3: TsPanel;
    PostEncodeList2: TsComboBox;
    sPanel4: TsPanel;
    StopBtn: TsBitBtn;
    OpenOutDirBtn2: TsBitBtn;
    Log2Btn: TsBitBtn;
    PostEncodeList: TsComboBox;
    sBitBtn1: TsBitBtn;
    RightPnl: TsPanel;
    BottomPnl: TsPanel;
    sPanel5: TsPanel;
    PassBtn: TsBitBtn;
    PassPnl: TsPanel;
    UserEdit: TsEdit;
    PassEdit: TsEdit;
    sLabel1: TsLabel;
    sPanel6: TsPanel;
    sLabelFX1: TsLabel;
    sLabelFX2: TsLabel;
    sLabelFX3: TsLabel;
    TimeLabel: TsLabel;
    sStatusBar1: TsStatusBar;
    FBImg: TsImage;
    TrayBtn: TsBitBtn;
    DVDInfoLabel: TsLabel;
    DVDTotalProgressBar: TsProgressBar;
    PostEncodeList3: TsComboBox;
    DVDFilterBtn: TsBitBtn;
    SubtitleTypesList: TsComboBox;
    DVDPages: TsPageControl;
    sTabSheet4: TsTabSheet;
    sTabSheet5: TsTabSheet;
    DVDAddtoBatchBtn: TsBitBtn;
    sPanel7: TsPanel;
    DVDBatchRemoveBtn: TsBitBtn;
    DVDBatchStartBtn: TsBitBtn;
    DVDBatchStopBtn: TsBitBtn;
    DVDBatchClearBtn: TsBitBtn;
    DVDJobList: TsListView;
    DVDPreTitleBtn: TsButton;
    DVDNextTitleBtn: TsButton;
    sPanel8: TsPanel;
    LinkEdit: TsEdit;
    LinkTypeList: TsComboBox;
    AddSingleLinkBtn: TsBitBtn;
    StartDVDBatchBtn: TsBitBtn;
    procedure RemoveBtnClick(Sender: TObject);
    procedure RemoveAllBtnClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure PositionTimerTimer(Sender: TObject);
    procedure OpenOutDirBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SearchVideoFindFile(Sender: TObject; const AName: string);
    procedure SearchVideoProgress(Sender: TObject);
    procedure OpenDirectory1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure FileListDblClick(Sender: TObject);
    procedure OpenScriptDirBtnClick(Sender: TObject);
    procedure LogsBtnClick(Sender: TObject);
    procedure NewProfileBtnClick(Sender: TObject);
    procedure ProfileListChange(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SubtitleOptions1Click(Sender: TObject);
    procedure SelectNone1Click(Sender: TObject);
    procedure ReverseSelection1Click(Sender: TObject);
    procedure SubtitleOptions2Click(Sender: TObject);
    procedure SubSettingsBtnClick(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure AddFile2Click(Sender: TObject);
    procedure AddFolder3Click(Sender: TObject);
    procedure AddFolderTree3Click(Sender: TObject);
    procedure AddFileBtnClick(Sender: TObject);
    procedure ApplicationEventsShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: Controls.THintInfo);
    procedure VideoEncoderListChange(Sender: TObject);
    procedure EffectsBtnClick(Sender: TObject);
    procedure FileListClick(Sender: TObject);
    procedure AudioTracksListChange(Sender: TObject);
    procedure SubtitleTracksListChange(Sender: TObject);
    procedure OpenScriptFolderBtnClick(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure FileListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AudioEncoderListChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure OpenOutDirBtn2Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
    procedure EditRangeBtnClick(Sender: TObject);
    procedure EditDelaysBtnClick(Sender: TObject);
    procedure UseSourceChkBtnClick(Sender: TObject);
    procedure ExOptionBtnClick(Sender: TObject);
    procedure TrayIconBalloonClick(Sender: TObject);
    procedure VideoSettingsBtnClick(Sender: TObject);
    procedure SeeChangeLog1Click(Sender: TObject);
    procedure HomepageBtnClick(Sender: TObject);
    procedure DonateBtnClick(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure ToolsBtnClick(Sender: TObject);
    procedure SubOptionsBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure EnableSubBtnClick(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure M2Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure V2Click(Sender: TObject);
    procedure AddLinkBtnClick(Sender: TObject);
    procedure ClearLinksBtnClick(Sender: TObject);
    procedure A3Click(Sender: TObject);
    procedure Batchaddlinks1Click(Sender: TObject);
    procedure A2Click(Sender: TObject);
    procedure Batchaddplaylists1Click(Sender: TObject);
    procedure StartDownloadBtnClick(Sender: TObject);
    procedure VideoDownloaderPosTimerTimer(Sender: TObject);
    procedure StopDownloadBtnClick(Sender: TObject);
    procedure DownloadSettingsBtnClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure U1Click(Sender: TObject);
    procedure EncoderListChange(Sender: TObject);
    procedure ReadDVDBtnClick(Sender: TObject);
    procedure TitlesListChange(Sender: TObject);
    procedure DisableAudioBtnClick(Sender: TObject);
    procedure DisableSubBtnClick(Sender: TObject);
    procedure StartChaperListChange(Sender: TObject);
    procedure EndChapterListChange(Sender: TObject);
    procedure OpenDVDBtnClick(Sender: TObject);
    procedure DVDPosTimerTimer(Sender: TObject);
    procedure DVDStopBtnClick(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure CheckUpdateThreadExecute(Sender: TObject; Params: Pointer);
    procedure UpdateCheckerDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
    procedure W1Click(Sender: TObject);
    procedure PassBtnClick(Sender: TObject);
    procedure sLabelFX1Click(Sender: TObject);
    procedure sLabelFX2Click(Sender: TObject);
    procedure sLabelFX3Click(Sender: TObject);
    procedure sStatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure FBImgClick(Sender: TObject);
    procedure TrayBtnClick(Sender: TObject);
    procedure DVDFilterBtnClick(Sender: TObject);
    procedure DVDFolderEditAfterDialog(Sender: TObject; var Name: string; var Action: Boolean);
    procedure FuncPagesChange(Sender: TObject);
    procedure SubtitleTypesListChange(Sender: TObject);
    procedure DVDAddtoBatchBtnClick(Sender: TObject);
    procedure DVDPreTitleBtnClick(Sender: TObject);
    procedure DVDNextTitleBtnClick(Sender: TObject);
    procedure AddSingleLinkBtnClick(Sender: TObject);
    procedure LinkEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DVDBatchRemoveBtnClick(Sender: TObject);
    procedure DVDBatchClearBtnClick(Sender: TObject);
    procedure DVDBatchStartBtnClick(Sender: TObject);
    procedure DVDEncodeBtnClick(Sender: TObject);
{$ENDREGION}
  private
    { Private declarations }
    // ===general===
    FMyDocFolder: string;
    FLastOpenedDir: string;
    FTempFilesToDelete: TStringList;
    FFileInfo: TFileInfoExtractor;
    FEncodeProcessCount: integer;
    FConstEncoderIndex: integer;
    FConstTwoPassMode: Boolean;

    // list of files to be checked after an encode or download
    FFilesToCheck: TStringList;

    // ===video/audio converter ===
    FConverterTotalCMDCount: integer;

    // ===downloader===
    FDownloadItems: TDownloadItemList;
    // download processes
    FVideoDownloadProcesses: array [0 .. 7] of TDownloadProcess;
    FProgressStrs: array [0 .. 7] of string;
    // total download cmd
    FVideoDownloadTotalCMDCount: Integer;
    // time passed downloading
    // todo: use this
    FVideoDownloaderTime: Integer;
    FSkippedVideoCount: integer;

    // ===dvd ripper===
    // list of titles of current DVD
    FTitles: TList<TTitle>;
    // currently selected title
    FCurrentTitle: TTitle;
    FDVDJobs: TDVDJobs;

    // removes temp files created during encoding.
    // list is populated by TEncoder.
    procedure DeleteTempFiles();
    procedure ClearDownloadImages();

    procedure FillSummary();
    // load/save settings from/to ini file
    procedure SaveOptions();
    procedure LoadOptions();

    function ShutDown(RebootParam: Longword): Boolean;

    procedure GetFileInfo(FileName: string);
    // stops all encoding processes
    procedure CloseProcesses();
    // gets videoindex's duration using convertitems
    function GetFileDuration(VideoIndex: Integer): integer;
    // gets duration of a file in seconds using mediainfo
    function GetDurationEx(const FileName: string): integer;
    // makes date suitable for file name for script file
    function CorrectFileName(FileName: string): string;
    // removes all .log files from appdata folder
    procedure RemoveLogs();

    procedure ApplyProfile(ProfileName: string);

    procedure LoadSkin();
    // adds a file to the list and convertitems
    // also gets related information
    procedure AddFile(const FileName: string);
    // adds files from a text file.
    // not an exposed feature that may be used to automate TEncoder in the
    // future
    procedure AddFilesForQueue(const FileListName: string);
    // enable/disable controls according to encoding state
    procedure SwitchToEncoding();
    procedure SwitchToNormal();
    // used when copy source date to output option is selected
    procedure WriteOutputFileDates;
    // checks if given file has only audio stream
    function IsAudioOnly(const FileName: string): Boolean;
    // gets given files parent folder's name, not whole path to it
    function GetFileFolderName(const FileName: string): string;
    // creates output file name, adding index etc to prevent overwrites
    function CreateFileName(const FileName: string; const Extension: string): string;

    // file date copy related funcs
    function ReadFileDate(const FileName: string): TFileDatePair;
    function GetModifiedDate(const FileName: string): TDateTime;
    procedure SetFileCreationTime(const FileName: string; const DateTime: TFileDatePair);
    // listview item up/down
    procedure ExchangeItems(lv: TsListView; const i, j: Integer);
    // adds command line to TEncoder object
    procedure CreateEncodingCommands(FileIndex: Integer; const EncoderIndex: integer);

    // video download fncs.
    // download link
    procedure AddURL(const Url: string);
    function HasAudio(const FileName: string): Boolean;
    // download item events
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormatListChange(Sender: TObject);
    procedure SubListChange(Sender: TObject);
    procedure LabelClick(Sender: TObject);
    function CreateTempName: string;
    procedure ClearTempFolderEx(const DeleteOnlyText: Boolean);
    procedure DownloadState;
    procedure DownloadNormalState;
    function VideoTypeToAudio(const TypeStr: string): string;
    function VideoTypeToAudioCode(const TypeStr: string): string;
    function VideoTypeToVideo(const TypeStr: string): string;
    function CreateDownloadConvertCMD(const SourcePath: string): string;
    // check output files and report broken/missing ones.
    // returns true if everything is OK
    function CheckOutputFiles(out MissingFiles: TStringList): Boolean;
    function GetFileSize(const FilePath: string): Int64;
    // create dvd command line
    function CreateDVDCMD: TCommandLine;
    function CreateDVDAdvancedCMD: string;
    function DVDThreadCMD: string;
    // dvd UI funcs
    procedure DVDRipUI;
    procedure DVDDoneUI;
    procedure DVDBatchRipUI;
    procedure DVDBatchDoneUI;
    function CreateDVDFileName(const FileName: string; const Extension: string): string;
  public
    { Public declarations }
    // true when user stops a file adding method
    FFileAddingStoppedByUser: Boolean;
    // folder where settings are saved.
    // app folder when portable mode is active.
    FAppDataFolder: string;
    // folder where logs are saved
    FLogFolder: string;
    // backend paths
    FMencoderPath, FFFMpegPath, FMPlayerPath, FMp4BoxPath, FMpeCreatorPath: string;
    FMEncoder64Path: string;
    FYoutubedlPath: string;
    FRenamePath: string;
    FDVDRenamePath: string;
    FTempFolder: string;
    // process objects
    FEncoders: array [0 .. 15] of TMyProcess;
    // video download list items
    FVideoDownloadListItems: TMyListItemList;
    // dvd ripper process
    FDVDRipperProcess: TDVDRipProcess;
    FStopAddingLink: Boolean;

    FTimePassed: Integer;
    // list that holds all the informaiton about files to be converted
    FMasterFileInfoList: TFileInfoList;
    procedure LoadProfiles(ProfilesList: TsComboBox);
    // removes two pass information from appdata folder
    procedure ClearTempFolder();
    // converts integer to hh:mm:ss
    function IntegerToTime(Time: Integer): string;
    // get file dimensions.
    // used to resize preview window.
    function GetWidth(FileName: string): string;
    function GetHeight(FileName: string): string;
    // preview progress related
    procedure SetPreviewProgress(const Progress: integer; const Total: integer);
    procedure SetPaused();
    procedure SetPlaying();
    // writes encoder logs to logfolder
    procedure SaveEncoderLogs();
    // changes summary according to settings
    procedure UpdateSummary();
    // converts hh:mm:ss to integer
    function TimeToInt(TimeStr: string): Integer;
    // converts hh:mm:ss.ms to integer
    // function TimeToIntEx(TimeStr: string): Integer;
    // checks if a given string is numeric
    function IsStringNumeric(Str: String): Boolean;
    // backend progress related
    function GetMencoderPosition(MencoderOutPut: String): String;
    function GetFFmpegPosition(FFmpegOutput: string; Duration: integer): string;
    function GetMp4Progress(const Mp4Output: string): string;
    // adds given links to the lists
    procedure BatchAdd(const Links: TStrings; const SingleLink: Boolean);
    // enable/disable mainmenu items
    procedure MenuState(const _Enabled: Boolean);
    // writes download logs to the disk
    procedure SaveDownloadLogs;
    // add a line to log
    procedure AddToLog(const LogID: Integer; const Msg: string);
    // increment video encoding progress by one and update UI accordingly
    procedure UpdateProgress;
    // deinterlacing command lines.
    // for both mencoder and ffmpeg
    function CreateDeintCMD(const Preview: Boolean): string;
    // ffmpeg and mencoder thread commands
    function ThreadCMD(const EncoderIndex: integer): string;
  end;

var
  MainForm: TMainForm;

implementation

uses UnitAbout, UnitAdd, UnitProperties, UnitLogs,
  UnitProfileEditor, UnitSettings, UnitEffects, UnitRangeEditor, UnitPreview, UnitAdvancedOptions, UnitImageAudioMerger, UnitDub,
  UnitVideotoGIF, UnitBatchAdd, UnitWatermark, VideoAdding;

const
  Portable = False;
  Build = 5086;

{$R *.dfm}

procedure TMainForm.A2Click(Sender: TObject);
Var
  LURL: string;
  LYIE: TYouTubeVideoInfoExtractor;
  I: Integer;
  LPass: TUserPass;
begin
  LURL := InputBox('Playlist', 'Enter the URL:', '');
  if Length(LURL) > 0 then
  begin
    LPass.UserName := UserEdit.Text;
    LPass.Password := PassEdit.Text;
    LYIE := TYouTubeVideoInfoExtractor.Create(LURL, FYoutubedlPath, FTempFolder, LPass, not SettingsForm.DontPreviewImgBtn.Checked);
    LYIE.GetPlayListInfo;
    Self.Enabled := False;
    VideoAddingForm.Show;
    MenuState(False);
    FStopAddingLink := False;
    try
      VideoAddingForm.InfoLabel.Caption := 'Extracting video links from playlist, this may take a while...';
      while LYIE.PlaylistStatus = stReading do
      begin
        if FStopAddingLink then
        begin
          LYIE.StopAll;
          Break;
        end;
        Application.ProcessMessages;
        Sleep(100);
      end;
      if not FStopAddingLink then
      begin
        if LYIE.PlayListVideoLinks.Count > 0 then
        begin
          AddToLog(0, '');
          AddToLog(0, 'Found ' + FloatToStr(LYIE.PlayListVideoLinks.Count) + ' videos.');
          AddToLog(0, '');
          for I := 0 to LYIE.PlayListVideoLinks.Count - 1 do
          begin
            if FStopAddingLink then
            begin
              Break;
            end;
            VideoAddingForm.InfoLabel.Caption := 'Adding videos to the list...(' + FloatToStr(i + 1) + '/' + FloatToStr(LYIE.PlayListVideoLinks.Count) + ')';
            AddURL('http://www.youtube.com/watch?v=' + LYIE.PlayListVideoLinks[i]);
          end;
        end
        else
        begin
          Application.MessageBox('Could not get any links from playlist.', 'Error', MB_ICONERROR);
        end;
      end;
    finally
      LYIE.Free;
      Self.Enabled := True;
      VideoAddingForm.Close;
      // SendMessage(LinkList.Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(VideoDownloaderList.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
      MenuState(True);
    end;
  end;
end;

procedure TMainForm.A3Click(Sender: TObject);
var
  LURL: string;
begin
  LURL := InputBox('Enter URL', 'Enter URL:', '');
  LURL := ReplaceText(LURL, 'https://', 'http://');

  if Length(Trim(LURL)) > 0 then
  begin
    VideoAddingForm.InfoLabel.Caption := 'Please wait...';
    Self.Enabled := False;
    VideoAddingForm.Show;
    MenuState(False);
    FStopAddingLink := False;
    // SendMessage(LinkList.Handle, WM_SETREDRAW, 0, 0);
    try
      VideoAddingForm.InfoLabel.Caption := 'Adding given URL to list...';
      AddURL(Trim(LURL));
    finally
      Self.Enabled := True;
      VideoAddingForm.Close;
      // SendMessage(LinkList.Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(VideoDownloaderList.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
      MenuState(True);
    end;
  end;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.CreateEncodingCommands(FileIndex: Integer; const EncoderIndex: integer);
var
  LSourceFileNamePath: string;
  LMEncoderCMD: TMencoderCommandLineCreator;
  LMp4MuxingCMD: string;
  LFFMpegCMD: TFFMpegCommandLineCreator;
  LExtractedAudioFileName: string;
  LMEncoderMp4MuxExt: string;
  LOggRemuxExtension: string;
  LOggAudioCMD: string;
  LRenameFile: TStringList;
  LMencoderFinalFileName: string;
  LEncoderIndex: integer;
  LEncodeJobs: TEncodeJobs;
  LEncodeJob: TEncodeJob;
begin

  // if audio only then we must use ffmpeg and do single pass
  if FMasterFileInfoList[FileIndex].FFMmpegVideoID = -1 then
  begin
    LEncoderIndex := 1;
    DoTwoPassBtn.Checked := False;
  end
  else
  begin
    // else use users choise
    LEncoderIndex := FConstEncoderIndex;
    DoTwoPassBtn.Checked := FConstTwoPassMode;
  end;

  // decide which encoder to use
  case LEncoderIndex of
    0: // mencoder
      begin
        // raw temp video extension
        if VideoEncoderList.ItemIndex = 4 then
        begin
          // h264
          LMEncoderMp4MuxExt := '_.h264'
        end
        else if VideoEncoderList.ItemIndex = 3 then
        begin
          // mpeg4
          LMEncoderMp4MuxExt := '_.m4v'
        end
        else if VideoEncoderList.ItemIndex = 2 then
        begin
          LMEncoderMp4MuxExt := '_.h263';
        end
        else
        begin
          LMEncoderMp4MuxExt := '_.avi'
        end;

        if DoTwoPassBtn.Checked then
        begin
          LSourceFileNamePath := FMasterFileInfoList[FileIndex].FilePath;
          AddForm.StatusLabel.Caption := 'Creating command lines (' + ExtractFileName(LSourceFileNamePath) + ')';
          // add to infos
          // create command line
          LMEncoderCMD := TMencoderCommandLineCreator.Create(FileIndex);
          try
            LEncodeJob.CommandLine := LMEncoderCMD.CommandLines.FirstPassCMD;
            LEncodeJob.ProcessType := mencoder;
            LEncodeJob.ProcessPath := FMencoderPath;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.FileListIndex := FileIndex;
            LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
            LEncodeJob.EncodingInformation := ' 1st pass of 2';
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
          finally
            LMEncoderCMD.Free;
          end;
          // create command line
          LMEncoderCMD := TMencoderCommandLineCreator.Create(FileIndex);
          try
            LEncodeJob.CommandLine := LMEncoderCMD.CommandLines.SeconPassCMD;
            LEncodeJob.ProcessType := mencoder;
            LEncodeJob.ProcessPath := FMencoderPath;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.FileListIndex := FileIndex;
            LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
            LEncodeJob.EncodingInformation := ' 2nd pass of 2';
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
            // mux to mp4 using mp4box
            if ContainerList.ItemIndex = 2 then
            begin
              // extract audio
              if (FMasterFileInfoList[FileIndex].AudioIndex <> -1) and (AudioEncoderList.ItemIndex <> 10) then
              begin
                LMp4MuxingCMD := ' -y -i "' + ExtractFileDir(LMEncoderCMD.OutputFile) + '\' + ExtractFileName(LMEncoderCMD.OutputFile) + '" -vn -f mp4 ';
{$REGION 'extracted audio track file extension'}
                case AudioEncoderList.ItemIndex of
                  1:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.mp3');
                  2:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.m4a');
                  3:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.ogg');
                  4:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.wav');
                  5:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.ac3');
                  6:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.mp2');
                  7:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.wma');
                  8:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.spx');
                  9:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.opus');
                  11:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.flac');
                end;
{$ENDREGION}
                LMp4MuxingCMD := LMp4MuxingCMD + ' "' + ExtractFileDir(LExtractedAudioFileName) + '\' + ExtractFileName(LExtractedAudioFileName) + '"';
                LEncodeJob.CommandLine := LMp4MuxingCMD;
                LEncodeJob.ProcessType := ffmpeg;
                LEncodeJob.EncodingInformation := 'Extracting audio';
                LEncodeJob.ProcessPath := FFFMpegPath;
                LEncodeJob.SourceFileName := LSourceFileNamePath;
                LEncodeJob.SourceDuration := GetFileDuration(FileIndex);
                LEncodeJob.FileListIndex := FileIndex;
                LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
                FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
              end;

              // extract video
              LMp4MuxingCMD := ' -of rawvideo -ovc copy -nosound "' + ExtractFileDir(LMEncoderCMD.OutputFile) + '\' + ExtractFileName(LMEncoderCMD.OutputFile) + '" -o "' +
                ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '"';
              LEncodeJob.CommandLine := LMp4MuxingCMD;
              LEncodeJob.ProcessType := mencoder;
              LEncodeJob.EncodingInformation := 'Extracting video';
              LEncodeJob.ProcessPath := FMencoderPath;
              LEncodeJob.SourceFileName := LSourceFileNamePath;
              LEncodeJob.FileListIndex := FileIndex;
              LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
              FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
              // muxing all
              if (FMasterFileInfoList[FileIndex].AudioIndex <> -1) and (AudioEncoderList.ItemIndex <> 10) then
              begin
                // with audio
                LMp4MuxingCMD := ' -add "' + ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' +
                  ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -add "' + ExtractFileDir(LExtractedAudioFileName) + '\' + ExtractFileName(LExtractedAudioFileName) +
                  '" -new "' + CreateFileName(LMEncoderCMD.OutputFile, '.mp4') + '"';
              end
              else
              begin
                // without audio
                LMp4MuxingCMD := ' -add "' + ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' +
                  ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -new "' + CreateFileName(LMEncoderCMD.OutputFile, '.mp4') + '"';
              end;
              LEncodeJob.CommandLine := LMp4MuxingCMD;
              LEncodeJob.ProcessType := mp4box;
              LEncodeJob.EncodingInformation := 'Muxing';
              LEncodeJob.ProcessPath := FMp4BoxPath;
              LEncodeJob.SourceFileName := LSourceFileNamePath;
              LEncodeJob.SourceDuration := GetFileDuration(FileIndex);
              LEncodeJob.FileListIndex := FileIndex;
              LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
              FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
              // temp files to be deleted
              FTempFilesToDelete.Add(ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)));
              FTempFilesToDelete.Add(ExtractFileDir(LExtractedAudioFileName) + '\' + ExtractFileName(LExtractedAudioFileName));
              FTempFilesToDelete.Add(ExtractFileDir(LMEncoderCMD.OutputFile) + '\' + ExtractFileName(LMEncoderCMD.OutputFile));
              FTempFilesToDelete.Add(ExtractFileDir(LExtractedAudioFileName) + '\');
              // output file to be checked
              FFilesToCheck.Add(CreateFileName(LMEncoderCMD.OutputFile, '.mp4'));
              LMencoderFinalFileName := CreateFileName(LMEncoderCMD.OutputFile, '.mp4');
            end
            else
            begin
              // output file to be checked
              // other than mp4 mode
              FFilesToCheck.Add(LMEncoderCMD.OutputFile);
              LMencoderFinalFileName := LMEncoderCMD.OutputFile;
            end;
          finally
            LMEncoderCMD.Free;
          end;
        end
        else
        begin
          // do a single pass
          LSourceFileNamePath := FMasterFileInfoList[FileIndex].FilePath;
          AddForm.StatusLabel.Caption := 'Creating command lines (' + ExtractFileName(LSourceFileNamePath) + ')';
          // create command line
          LMEncoderCMD := TMencoderCommandLineCreator.Create(FileIndex);
          try
            LEncodeJob.CommandLine := LMEncoderCMD.CommandLines.SinglePassCMD;
            LEncodeJob.ProcessType := mencoder;
            LEncodeJob.EncodingInformation := ' Encoding';
            LEncodeJob.ProcessPath := FMencoderPath;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.FileListIndex := FileIndex;
            LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
            // mp4box for mp4
            if ContainerList.ItemIndex = 2 then
            begin
              // extract audio
              if (FMasterFileInfoList[FileIndex].AudioIndex <> -1) and (AudioEncoderList.ItemIndex <> 10) then
              begin
                LMp4MuxingCMD := ' -y -i "' + ExtractFileDir(LMEncoderCMD.OutputFile) + '\' + ExtractFileName(LMEncoderCMD.OutputFile) + '" -vn -f mp4 ';
                case AudioEncoderList.ItemIndex of
                  1:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.mp3');
                  2:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.m4a');
                  3:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.ogg');
                  4:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.wav');
                  5:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.ac3');
                  6:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.mp2');
                  7:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.wma');
                  8:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.spx');
                  9:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.opus');
                  11:
                    LExtractedAudioFileName := ChangeFileExt(LMEncoderCMD.OutputFile, '_.opus');
                end;
                LMp4MuxingCMD := LMp4MuxingCMD + ' "' + ExtractFileDir(LExtractedAudioFileName) + '\' + ExtractFileName(LExtractedAudioFileName) + '"';
                LEncodeJob.CommandLine := LMp4MuxingCMD;
                LEncodeJob.ProcessType := ffmpeg;
                LEncodeJob.EncodingInformation := 'Extracting audio';
                LEncodeJob.ProcessPath := FFFMpegPath;
                LEncodeJob.SourceFileName := LSourceFileNamePath;
                LEncodeJob.SourceDuration := GetFileDuration(FileIndex);
                LEncodeJob.FileListIndex := FileIndex;
                LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
                FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
              end;

              // extract video
              LMp4MuxingCMD := ' -of rawvideo -ovc copy -nosound "' + ExtractFileDir(LMEncoderCMD.OutputFile) + '\' + ExtractFileName(LMEncoderCMD.OutputFile) + '" -o "' +
                ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '"';
              LEncodeJob.CommandLine := LMp4MuxingCMD;
              LEncodeJob.ProcessType := mencoder;
              LEncodeJob.EncodingInformation := 'Extracting video';
              LEncodeJob.ProcessPath := FMencoderPath;
              LEncodeJob.SourceFileName := LSourceFileNamePath;
              LEncodeJob.FileListIndex := FileIndex;
              LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
              FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
              if (FMasterFileInfoList[FileIndex].AudioIndex <> -1) and (AudioEncoderList.ItemIndex <> 10) then
              begin
                LMp4MuxingCMD := ' -add "' + ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' +
                  ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -add "' + ExtractFileDir(LExtractedAudioFileName) + '\' + ExtractFileName(LExtractedAudioFileName) +
                  '" -new "' + CreateFileName(LMEncoderCMD.OutputFile, '.mp4') + '"';
              end
              else
              begin
                LMp4MuxingCMD := ' -add "' + ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' +
                  ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -new "' + CreateFileName(LMEncoderCMD.OutputFile, '.mp4') + '"';
              end;
              LEncodeJob.CommandLine := LMp4MuxingCMD;
              LEncodeJob.ProcessType := mp4box;
              LEncodeJob.EncodingInformation := 'Muxing';
              LEncodeJob.ProcessPath := FMp4BoxPath;
              LEncodeJob.SourceFileName := LSourceFileNamePath;
              LEncodeJob.SourceDuration := GetFileDuration(FileIndex);
              LEncodeJob.FileListIndex := FileIndex;
              LEncodeJob.EncodingOutputFilePath := LMEncoderCMD.OutputFile;
              FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
              // delete temp files
              FTempFilesToDelete.Add(ExtractFileDir(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LMEncoderCMD.OutputFile, LMEncoderMp4MuxExt)));
              FTempFilesToDelete.Add(ExtractFileDir(LExtractedAudioFileName) + '\' + ExtractFileName(LExtractedAudioFileName));
              FTempFilesToDelete.Add(ExtractFileDir(LMEncoderCMD.OutputFile) + '\' + ExtractFileName(LMEncoderCMD.OutputFile));
              FTempFilesToDelete.Add(ExtractFileDir(LExtractedAudioFileName) + '\');
              // output file to be checked
              FFilesToCheck.Add(CreateFileName(LMEncoderCMD.OutputFile, '.mp4'));
              LMencoderFinalFileName := CreateFileName(LMEncoderCMD.OutputFile, '.mp4');
            end
            else
            begin
              // output file to be checked
              // other than mp4 mode
              FFilesToCheck.Add(LMEncoderCMD.OutputFile);
              LMencoderFinalFileName := LMEncoderCMD.OutputFile;
            end;
          finally
            LMEncoderCMD.Free;
          end;
        end;

        // mencoder doesn't seem to be able produce valid ogg streams.
        // first convert to flac then to ogg using ffmpeg
        if AudioEncoderList.ItemIndex = 3 then
        begin
          // convert flac audio to ogg using ffmpeg
          LOggRemuxExtension := ExtractFileExt(LMencoderFinalFileName);
          LOggAudioCMD := '-y -i "' + LMencoderFinalFileName + '" -c:v copy -c:a libvorbis -ab ' + AdvancedOptionsForm.AudioBitrateList.Text + 'k "' +
            ChangeFileExt(LMencoderFinalFileName, '_temp' + LOggRemuxExtension) + '"';
          LEncodeJob.CommandLine := LOggAudioCMD;
          LEncodeJob.ProcessType := ffmpeg;
          LEncodeJob.ProcessPath := FFFMpegPath;
          LEncodeJob.SourceFileName := LSourceFileNamePath;
          LEncodeJob.EncodingInformation := 'Encoding';
          FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
          AddToLog(6, 'Ogg encoding command: ' + LOggAudioCMD);
          // rename converted file to original output file name
          LRenameFile := TStringList.Create;
          try
            LRenameFile.Add(LMencoderFinalFileName);
            LRenameFile.Add(ChangeFileExt(LMencoderFinalFileName, '_temp' + LOggRemuxExtension));
            LRenameFile.SaveToFile(FTempFolder + '\' + FloatToStr(FileIndex) + '.txt', TEncoding.UTF8);
            LEncodeJob.CommandLine := '"' + FDVDRenamePath + '" "' + FTempFolder + '\' + FloatToStr(FileIndex) + '.txt"';
            LEncodeJob.ProcessType := renametool;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.ProcessPath := '';
            LEncodeJob.EncodingInformation := 'Renaming';
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
            AddToLog(6, 'Renaming command: "' + FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt"');
            FTempFilesToDelete.Add(FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt');
          finally
            LRenameFile.Free;
          end;
        end;

      end;
    1: // ffmpeg
      begin
        if DoTwoPassBtn.Checked then
        begin
          // do two passes
          // first pass
          LSourceFileNamePath := FMasterFileInfoList[FileIndex].FilePath;
          AddForm.StatusLabel.Caption := 'Creating command lines (' + ExtractFileName(LSourceFileNamePath) + ')';
          // create command line
          LFFMpegCMD := TFFMpegCommandLineCreator.Create(FileIndex);
          try
            LEncodeJob.CommandLine := LFFMpegCMD.FMpegCommandLine.FirstPassCMD;
            LEncodeJob.SourceDuration := FMasterFileInfoList[FileIndex].EndPosition - FMasterFileInfoList[FileIndex].StartPosition;
            LEncodeJob.ProcessType := ffmpeg;
            LEncodeJob.ProcessPath := FFFMpegPath;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.EncodingInformation := ' 1st pass of 2';
            LEncodeJob.FileListIndex := FileIndex;
            LEncodeJob.EncodingOutputFilePath := LFFMpegCMD.OutputFile;
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
          finally
            LFFMpegCMD.Free;
          end;
          // second pass
          LSourceFileNamePath := FMasterFileInfoList[FileIndex].FilePath;
          // create command line
          LFFMpegCMD := TFFMpegCommandLineCreator.Create(FileIndex);
          try
            LEncodeJob.CommandLine := LFFMpegCMD.FMpegCommandLine.SeconPassCMD;
            LEncodeJob.SourceDuration := FMasterFileInfoList[FileIndex].EndPosition - FMasterFileInfoList[FileIndex].StartPosition;
            LEncodeJob.ProcessType := ffmpeg;
            LEncodeJob.ProcessPath := FFFMpegPath;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.EncodingInformation := ' 2nd pass of 2';
            LEncodeJob.FileListIndex := FileIndex;
            LEncodeJob.EncodingOutputFilePath := LFFMpegCMD.OutputFile;
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
            // output file to be checked
            FFilesToCheck.Add(LFFMpegCMD.OutputFile);
          finally
            LFFMpegCMD.Free;
          end;
        end
        else
        begin
          // do single pass
          LSourceFileNamePath := FMasterFileInfoList[FileIndex].FilePath;
          AddForm.StatusLabel.Caption := 'Creating command lines (' + ExtractFileName(LSourceFileNamePath) + ')';
          // create command line
          LFFMpegCMD := TFFMpegCommandLineCreator.Create(FileIndex);
          try
            LEncodeJob.CommandLine := LFFMpegCMD.FMpegCommandLine.SinglePassCMD;
            LEncodeJob.SourceDuration := FMasterFileInfoList[FileIndex].EndPosition - FMasterFileInfoList[FileIndex].StartPosition;
            LEncodeJob.ProcessType := ffmpeg;
            LEncodeJob.ProcessPath := FFFMpegPath;
            LEncodeJob.SourceFileName := LSourceFileNamePath;
            LEncodeJob.EncodingInformation := ' Encoding';
            LEncodeJob.FileListIndex := FileIndex;
            LEncodeJob.EncodingOutputFilePath := LFFMpegCMD.OutputFile;
            FEncoders[EncoderIndex].EncodeJobs.Add(LEncodeJob);
            // output file to be checked
            FFilesToCheck.Add(LFFMpegCMD.OutputFile);
          finally
            LFFMpegCMD.Free;
          end;
        end;
      end;
  end;
end;

procedure TMainForm.AddFile(const FileName: string);
var
  LItem: TListItem;
  LConvertItem: TFileInfoItem;
  LTmpList: TStringList;
  I: integer;
  j: integer;
label
  SubDefTrackSelect, AudDefTrackSelect;

begin
  if (FileExists(FileName)) then
  begin
    LTmpList := TStringList.Create;
    try
      LTmpList.StrictDelimiter := True;
      LTmpList.Delimiter := ';';
      // start file info processes and wait for them to finish
      FFileInfo.Start(FileName);
      while FFileInfo.IsBusy do
      begin
        Application.ProcessMessages;
        Sleep(50);
      end;
      // file info list
      LConvertItem := TFileInfoItem.Create;
      with LConvertItem do
      begin
        StartPosition := 0;
        if Length(FFileInfo.DurationStr) > 0 then
        begin
          EndPosition := TimeToInt(FFileInfo.DurationStr);
        end
        else
        begin
          EndPosition := GetDurationEx(FileName)
        end;
        if EndPosition > 0 then
        begin
          // subtitle files
          SubtitleFiles.AddStrings(FFileInfo.SubtitleFiles);
          if SubtitleFiles.Count > 0 then
          begin
            SubtitleIndex := 0;
          end
          else
          begin
            SubtitleIndex := -1;
          end;
          SubtitleDelay := 0;
          // subtitle tracks
          SubtitleTracks.AddStrings(FFileInfo.SubtitleTracks);
          SubtitleTrackIndexes.AddRange(FFileInfo.SubtitleTrackIndexes.ToArray);
          if SubtitleTrackIndexes.Count > 0 then
          begin
            SubtitleTrackIndex := 0;
            LTmpList.DelimitedText := SettingsForm.DefaultSubLangEdit.Text;
            for I := 0 to LTmpList.Count - 1 do
            begin
              for j := 0 to FFileInfo.SubtitleTracks.Count - 1 do
              begin
                if FFileInfo.SubtitleTracks[j].Contains(UpperCase(LTmpList[i])) then
                begin
                  SubtitleTrackIndex := j;
                  goto SubDefTrackSelect;
                end;
              end;
            end;
          SubDefTrackSelect:
          end
          else
          begin
            SubtitleTrackIndex := -1;
          end;
          if SubtitleFiles.Count > 0 then
          begin
            SubtitleIndex := 0;
          end
          else
          begin
            SubtitleIndex := -1;
          end;
          if SubtitleFiles.Count > 0 then
          begin
            SelectedSubtitleType := subfile;
          end
          else
          begin
            SelectedSubtitleType := embedded;
          end;
          // audio streams
          AudioTracks.AddStrings(FFileInfo.AudioStreams);
          AudioIDs.AddRange(FFileInfo.AudioIndexes.ToArray);
          AudioMencoderIDs.AddRange(FFileInfo.AudioMencoderIndexes.ToArray);
          if AudioTracks.Count > 0 then
          begin
            AudioIndex := 0;
            LTmpList.DelimitedText := SettingsForm.DefaultAudioLangEdit.Text;
            for I := 0 to LTmpList.Count - 1 do
            begin
              for j := 0 to FFileInfo.AudioStreams.Count - 1 do
              begin
                if FFileInfo.AudioStreams[j].Contains(UpperCase(LTmpList[i])) then
                begin
                  AudioIndex := j;
                  goto AudDefTrackSelect;
                end;
              end;
            end;
          AudDefTrackSelect:
          end
          else
          begin
            AudioIndex := -1;
          end;
          AudioExtensions.AddStrings(FFileInfo.AudioExtensions);
          ConstDuration := EndPosition;
          FilePath := FileName;
          FileDate := ReadFileDate(FileName);
          FFMmpegVideoID := FFileInfo.FFmpegVideoID;
          MEncoderVideoID := FFileInfo.MEncoderVideoID;
        end
        else
        begin
          AddToLog(0, 'Duration is zero: ' + ExtractFileName(FileName));
          LConvertItem.Free;
          Exit;
        end;
      end;
      FMasterFileInfoList.Add(LConvertItem);
      // interface
      LItem := FileList.Items.Add;
      with LItem do
      begin
        Caption := ExtractFileName(FileName);
        if Length(FFileInfo.DurationStr) > 0 then
        begin
          SubItems.Add(FFileInfo.DurationStr);
        end
        else
        begin
          SubItems.Add(IntegerToTime(LConvertItem.EndPosition))
        end;
        SubItems.Add('0');
        SubItems.Add('0');
      end;
    finally
      LTmpList.Free;
    end;
  end;
end;

procedure TMainForm.AddFile2Click(Sender: TObject);
var
  OpenVideo: TsOpenDialog;
  i: Integer;
begin
  OpenVideo := TsOpenDialog.Create(MainForm);
  try
    if DirectoryExists(FLastOpenedDir) then
    begin
      OpenVideo.InitialDir := FLastOpenedDir;
    end;
    OpenVideo.Options := OpenVideo.Options + [ofAllowMultiSelect];
    OpenVideo.Filter := 'All Supported|*.flv;*.m2v;*.avi;*.mkv;*.mpeg;*.mpg;*.mov;*.wmv;*.mp4;' +
      '*.m4v;*.dat;*.vob;*.mp3;*.wav;*.aac;*.m4a;*.m4b;*.ac3;*.ogg;*.flac;*.mp2;*.webm;*.m2ts;*.avs;*.rmvb;*.spx;*.mts;*.mxf;*.ts;' +
      '|Video Files|*.flv;*.m2v;*.avi;*.mkv;*.mpeg;*.mpg;*.mov;*.wmv;*.mp4;' + '*.m4v;*.dat;*.vob;*.rmvb;*.mts;*.mxf' +
      '|Audio Files|*.mp3;*.wav;*.aac;*.m4a;*.m4b;*.ac3;*.ogg;*.flac;*.mp2;*.opus;*.spx' + '|All Files|*.*';

    if OpenVideo.Execute then
    begin
      FileList.Items.BeginUpdate;
      AddForm.StatusLabel.Caption := 'Adding files, please wait...';
      AddForm.AbortBtn.Enabled := True;
      AddForm.Show;
      MainForm.Enabled := False;
      FFileAddingStoppedByUser := False;
      for i := 0 to OpenVideo.Files.Count - 1 do
      begin
        Application.ProcessMessages;
        if FFileAddingStoppedByUser then
        begin
          Break;
        end
        else
        begin
          AddForm.StatusLabel.Caption := ExtractFileName(OpenVideo.Files[i]);
          AddFile(OpenVideo.Files[i]);
        end;
      end;
      FLastOpenedDir := ExtractFileDir(OpenVideo.Files.Strings[OpenVideo.Files.Count - 1]);
    end;
  finally
    OpenVideo.Free;
    AddForm.Close;
    MainForm.Enabled := True;
    FileList.Items.EndUpdate;
    FFileAddingStoppedByUser := False;
  end;
end;

procedure TMainForm.AddFileBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := AddFileBtn.ClientToScreen(Point(0, 0));

  AddMenu.Popup(P.X, P.Y + AddFileBtn.Height)
end;

procedure TMainForm.AddFilesForQueue(const FileListName: string);
var
  FilesToAdd: TStringList;
  i: integer;
begin
  if FileExists(FileListName) then
  begin
    FileList.Items.BeginUpdate;
    AddForm.StatusLabel.Caption := 'Adding files please wait...';
    AddForm.AbortBtn.Enabled := True;
    AddForm.Show;
    MainForm.Enabled := False;
    FFileAddingStoppedByUser := False;
    FilesToAdd := TStringList.Create;
    try
      FilesToAdd.LoadFromFile(FileListName);
      for I := 0 to FilesToAdd.Count - 1 do
      begin
        Application.ProcessMessages;
        if FFileAddingStoppedByUser then
        begin
          Break
        end
        else
        begin
          AddForm.StatusLabel.Caption := ExtractFileName(FilesToAdd[i]);
          AddFile(FilesToAdd[i]);
        end;
      end;
    finally
      AddForm.Close;
      MainForm.Enabled := True;
      MainForm.BringToFront;
      FFileAddingStoppedByUser := False;
      FileList.Items.EndUpdate;
      FreeAndNil(FilesToAdd);
      FLastOpenedDir := SelectDirectoryDialog.Directory;
    end;
  end;
end;

procedure TMainForm.AddFolder3Click(Sender: TObject);
var
  Search: TSearchRec;
  FileName: String;
  Extension: String;
  FilesToAdd: TStringList;
  i: integer;
begin
  if DirectoryExists(FLastOpenedDir) then
  begin
    SelectDirectoryDialog.Directory := FLastOpenedDir;
  end;
  if SelectDirectoryDialog.Execute then
  begin
    FileList.Items.BeginUpdate;
    AddForm.StatusLabel.Caption := 'Adding files please wait...';
    AddForm.AbortBtn.Enabled := True;
    AddForm.Show;
    MainForm.Enabled := False;
    FFileAddingStoppedByUser := False;
    FilesToAdd := TStringList.Create;
    try
      if (FindFirst(SelectDirectoryDialog.Directory + '\*.*', faAnyFile, Search) = 0) then
      Begin
        repeat
          Application.ProcessMessages;
          FileName := SelectDirectoryDialog.Directory + '\' + Search.Name;
          if FFileAddingStoppedByUser then
          begin
            Break;
          end
          else
          begin
            Extension := LowerCase(ExtractFileExt(FileName));
            if (Extension = '.avi') or (Extension = '.wmv') or (Extension = '.vob') or (Extension = '.dat') or (Extension = '.mp4') or (Extension = '.mpeg') or (Extension = '.mpg') or
              (Extension = '.mov') or (Extension = '.mkv') or (Extension = '.flv') or (Extension = '.m4v') or (Extension = '.m2v') or (Extension = '.mp3') or (Extension = '.wav') or
              (Extension = '.aac') or (Extension = '.m4a') or (Extension = '.m4b') or (Extension = '.ac3') or (Extension = '.ogg') or (Extension = '.flac') or (Extension = '.mp2') or
              (Extension = '.webm') or (Extension = '.m2ts') or (Extension = '.mts') or (Extension = '.rmvb') or (Extension = '.opus') or (Extension = '.spx') or (Extension = '.mxf') or
              (Extension = '.ts') then
            begin
              FilesToAdd.Add(FileName);
            end;
          end;
        until (FindNext(Search) <> 0);
        FindClose(Search);
      end;

      for I := 0 to FilesToAdd.Count - 1 do
      begin
        Application.ProcessMessages;
        if FFileAddingStoppedByUser then
        begin
          Break
        end
        else
        begin
          AddForm.StatusLabel.Caption := ExtractFileName(FilesToAdd[i]);
          AddFile(FilesToAdd[i]);
        end;
      end;

    finally
      AddForm.Close;
      MainForm.Enabled := True;
      MainForm.BringToFront;
      FFileAddingStoppedByUser := False;
      FileList.Items.EndUpdate;
      FreeAndNil(FilesToAdd);

      FLastOpenedDir := SelectDirectoryDialog.Directory;
    end;
  end;
end;

procedure TMainForm.AddFolderTree3Click(Sender: TObject);
begin
  if DirectoryExists(FLastOpenedDir) then
  begin
    SelectDirectoryDialog.Directory := FLastOpenedDir;
  end;
  if SelectDirectoryDialog.Execute then
  begin
    FileList.Items.BeginUpdate;
    AddForm.StatusLabel.Caption := 'Adding files please wait...';
    AddForm.AbortBtn.Enabled := True;
    AddForm.Show;
    MainForm.Enabled := False;
    try
      FLastOpenedDir := SelectDirectoryDialog.Directory;
      SearchVideo.RootDirectory := SelectDirectoryDialog.Directory;
      SearchVideo.Search;
    finally
      AddForm.Close;
      MainForm.Enabled := True;
      MainForm.BringToFront;
      FileList.Items.EndUpdate;
    end;
  end;
end;

procedure TMainForm.AddLinkBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := AddLinkBtn.ClientToScreen(Point(0, 0));

  AddLinkMenu.Popup(P.X, P.Y + AddLinkBtn.Height)
end;

procedure TMainForm.AddSingleLinkBtnClick(Sender: TObject);
var
  LURL: string;
  LYIE: TYouTubeVideoInfoExtractor;
  I: Integer;
  LPass: TUserPass;
begin
  LURL := Trim(LinkEdit.Text);
  if Length(LURL) > 0 then
  begin
    case LinkTypeList.ItemIndex of
      0: // single link
        begin
          VideoAddingForm.InfoLabel.Caption := 'Please wait...';
          Self.Enabled := False;
          VideoAddingForm.Show;
          MenuState(False);
          FStopAddingLink := False;
          // SendMessage(LinkList.Handle, WM_SETREDRAW, 0, 0);
          try
            VideoAddingForm.InfoLabel.Caption := 'Adding given URL to list...';
            AddURL(Trim(LURL));
          finally
            Self.Enabled := True;
            VideoAddingForm.Close;
            // SendMessage(LinkList.Handle, WM_SETREDRAW, 1, 0);
            RedrawWindow(VideoDownloaderList.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
            MenuState(True);
            Self.Width := Self.Width + 1;
            Self.Width := Self.Width - 1;
          end;
        end;
      1: // playlist/user
        begin
          LPass.UserName := UserEdit.Text;
          LPass.Password := PassEdit.Text;
          LYIE := TYouTubeVideoInfoExtractor.Create(LURL, FYoutubedlPath, FTempFolder, LPass, not SettingsForm.DontPreviewImgBtn.Checked);
          LYIE.GetPlayListInfo;
          VideoAddingForm.InfoLabel.Caption := 'Please wait...';
          Self.Enabled := False;
          VideoAddingForm.Show;
          MenuState(False);
          FStopAddingLink := False;
          try
            VideoAddingForm.InfoLabel.Caption := 'Extracting video links from playlist, this may take a while...';
            while LYIE.PlaylistStatus = stReading do
            begin
              if FStopAddingLink then
              begin
                LYIE.StopAll;
                Break;
              end;
              Application.ProcessMessages;
              Sleep(100);
            end;
            if not FStopAddingLink then
            begin
              if LYIE.PlayListVideoLinks.Count > 0 then
              begin
                if LogForm.DownloadLog.Lines.Count > 0 then
                begin
                  AddToLog(0, '');
                end;
                AddToLog(0, 'Found ' + FloatToStr(LYIE.PlayListVideoLinks.Count) + ' videos.');
                AddToLog(0, '');
                for I := 0 to LYIE.PlayListVideoLinks.Count - 1 do
                begin
                  if FStopAddingLink then
                  begin
                    Break;
                  end;
                  VideoAddingForm.InfoLabel.Caption := 'Adding videos to the list...(' + FloatToStr(i + 1) + '/' + FloatToStr(LYIE.PlayListVideoLinks.Count) + ')';
                  AddURL('http://www.youtube.com/watch?v=' + LYIE.PlayListVideoLinks[i]);
                end;
              end
              else
              begin
                Application.MessageBox('Could not get any links from playlist.', 'Error', MB_ICONERROR);
              end;
            end;
          finally
            LYIE.Free;
            Self.Enabled := True;
            VideoAddingForm.Close;
            // SendMessage(LinkList.Handle, WM_SETREDRAW, 1, 0);
            RedrawWindow(VideoDownloaderList.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
            MenuState(True);
            Self.Width := Self.Width + 1;
            Self.Width := Self.Width - 1;
          end;
        end;
    end;
  end;
end;

procedure TMainForm.AddToLog(const LogID: Integer; const Msg: string);
begin
  case LogID of
    0: // main log
      begin
        if Length(Msg) > 0 then
        begin
          LogForm.MainLog.Lines.Add('[' + DateTimeToStr(Now) + '] ' + Msg);
        end
        else
        begin
          LogForm.MainLog.Lines.Add('');
        end;
      end;
    6: // dvd cmd log
      begin
        if Length(Msg) > 0 then
        begin
          LogForm.DVDCMDLog.Lines.Add('[' + DateTimeToStr(Now) + '] ' + Msg);
        end
        else
        begin
          LogForm.DVDCMDLog.Lines.Add('');
        end;
      end;
  end;
end;

procedure TMainForm.AddURL(const Url: string);
var
  YIE: TYouTubeVideoInfoExtractor;
  I: Integer;
  LDownloadItem: TDownloadItem;
  LVideoDownloaderItem: TVideoDownloaderItem;
  LPass: TUserPass;
begin
  if Length(Url) > 0 then
  begin
    LPass.UserName := UserEdit.Text;
    LPass.Password := PassEdit.Text;
    YIE := TYouTubeVideoInfoExtractor.Create(Url, FYoutubedlPath, FTempFolder, LPass, not SettingsForm.DontPreviewImgBtn.Checked);
    try
      // read info from link
      YIE.Start;
      while (YIE.FormatStatus = stReading) or (YIE.ThumbStatus = stReading) or (YIE.TitleStatus = stReading) or (YIE.SubtitleStatus = stReading) do
      begin
        if FStopAddingLink then
        begin
          YIE.StopAll;
          Break;
        end;
        Application.ProcessMessages;
        Sleep(100);
      end;
      if not FStopAddingLink then
      begin
        if YIE.FormatList.Count > 0 then
        begin
          LDownloadItem := TDownloadItem.Create;
          LDownloadItem.Formats.AddStrings(YIE.FormatList);
          for I := 0 to LDownloadItem.Formats.Count - 1 do
          begin
            Application.ProcessMessages;
            // select the one meets user's selection
            if ContainsText(LDownloadItem.Formats[i], SettingsForm.PreferedFormatEdit.Text) then
            begin
              LDownloadItem.FormatIndex := i;
              Break;
            end;
          end;
          LDownloadItem.FormatIntegers.AddStrings(YIE.FormatInts);
          // that means couldnt find format given by user.
          // select the last item
          if LDownloadItem.FormatIndex = -1 then
          begin
            LDownloadItem.FormatIndex := YIE.FormatList.Count - 1;
          end;
          LDownloadItem.ImagePath := YIE.ImageName;
          LDownloadItem.OutputExtensions.AddStrings(YIE.OutExt);
          LDownloadItem.OutputExtensionIndex := 0;
          LDownloadItem.OutputFileName := YIE.FileName;
          LDownloadItem.Subtitles.AddStrings(YIE.Subtitles);
          LDownloadItem.SubIndex := 0;
          LDownloadItem.LinkType := YIE.LinkType;
          FDownloadItems.Add(LDownloadItem);
          LVideoDownloaderItem := TVideoDownloaderItem.Create(VideoDownloaderList, FVideoDownloadListItems.Count, FVideoDownloadListItems.Count * 110);
          LVideoDownloaderItem.LinkLabel.Caption := Url;
          LVideoDownloaderItem.FileNameLabel.Caption := YIE.FileName;
          LVideoDownloaderItem.FileNameLabel.Hint := LVideoDownloaderItem.FileNameLabel.Caption;
          // load program icon if download of thumb fails or user selected not to load it
          if FileExists(YIE.ImageName) then
          begin
            try
              LVideoDownloaderItem.PrevievImg.Picture.LoadFromFile(YIE.ImageName);
            except
              // load default image in case of an error
              if FileExists(ExtractFileDir(Application.ExeName) + '\icon.ico') then
              begin
                LVideoDownloaderItem.PrevievImg.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\icon.ico');
              end;
            end;
          end
          else
          begin
            if FileExists(ExtractFileDir(Application.ExeName) + '\icon.ico') then
            begin
              LVideoDownloaderItem.PrevievImg.Picture.LoadFromFile(ExtractFileDir(Application.ExeName) + '\icon.ico');
            end;
          end;
          LVideoDownloaderItem.DeleteButton.OnClick := DeleteBtnClick;
          LVideoDownloaderItem.ProgressLabel.Caption := 'Waiting...';
          VideoDownloaderList.InsertControl(LVideoDownloaderItem.Panel);
          LVideoDownloaderItem.FormatList.Items.AddStrings(YIE.FormatList);
          LVideoDownloaderItem.FormatList.ItemIndex := LDownloadItem.FormatIndex;
          LVideoDownloaderItem.FormatList.OnChange := FormatListChange;
          LVideoDownloaderItem.SubtitleList.Items.AddStrings(YIE.Subtitles);
          LVideoDownloaderItem.SubtitleList.ItemIndex := LDownloadItem.SubIndex;
          LVideoDownloaderItem.SubtitleList.OnChange := SubListChange;
          LVideoDownloaderItem.LinkLabel.OnClick := LabelClick;
          FVideoDownloadListItems.Add(LVideoDownloaderItem);
        end
        else
        begin
          AddToLog(0, 'Unable to add ' + Url + '. (Couldn''t find any formats)');
        end;
      end;
    finally
      YIE.Free;
    end;
  end;
end;

procedure TMainForm.VideoSettingsBtnClick(Sender: TObject);
begin
  Self.Enabled := False;
  AdvancedOptionsForm.Show;
end;

function TMainForm.VideoTypeToAudio(const TypeStr: string): string;
const
  // video types.
  MP4 = 'MP4';
  WEBM = 'WEBM';
  _3GP = '3GP';
  FLV = 'FLV';
begin
  Result := '.m4a';
  if MP4 = copy(TypeStr, 1, Length(MP4)) then
  begin
    Result := '.m4a';
  end
  else if _3GP = copy(TypeStr, 1, Length(_3GP)) then
  begin
    Result := '.m4a'
  end
  else if WEBM = copy(TypeStr, 1, Length(WEBM)) then
  begin
    Result := '.ogg';
  end
  else if FLV = copy(TypeStr, 1, Length(FLV)) then
  begin
    Result := '.mp3';
  end;
end;

function TMainForm.VideoTypeToAudioCode(const TypeStr: string): string;
const
  // video types.
  MP4 = 'MP4';
  WEBM = 'WEBM';
  _3GP = '3GP';
  FLV = 'FLV';
begin
  // flv and 3gp DASH
  Result := '140';
  if MP4 = copy(TypeStr, 1, Length(MP4)) then
  begin
    Result := '140';
  end
  else if _3GP = copy(TypeStr, 1, Length(_3GP)) then
  begin
    Result := '140'
  end
  else if WEBM = copy(TypeStr, 1, Length(WEBM)) then
  begin
    Result := '171';
  end
  else if FLV = copy(TypeStr, 1, Length(FLV)) then
  begin
    Result := '140';
  end;
end;

function TMainForm.VideoTypeToVideo(const TypeStr: string): string;
const
  // video types.
  MP4 = 'MP4';
  WEBM = 'WEBM';
  _3GP = '3GP';
  FLV = 'FLV';
begin
  Result := '.mp4';
  if MP4 = copy(TypeStr, 1, Length(MP4)) then
  begin
    Result := '.mp4';
  end
  else if _3GP = copy(TypeStr, 1, Length(_3GP)) then
  begin
    Result := '.3gp'
  end
  else if WEBM = copy(TypeStr, 1, Length(WEBM)) then
  begin
    Result := '.webm';
  end
  else if FLV = copy(TypeStr, 1, Length(FLV)) then
  begin
    Result := '.flv';
  end;
end;

procedure TMainForm.W1Click(Sender: TObject);
begin
  Self.Enabled := False;
  WatermarkForm.Show;
end;

procedure TMainForm.WriteOutputFileDates;
var
  I: Integer;
  j: Integer;
begin
  if SettingsForm.CopyDateBtn.Checked then
  begin
    for I := Low(FEncoders) to High(FEncoders) do
    begin
      for j := 0 to FEncoders[i].EncodeJobs.Count - 1 do
      begin
        if FileExists(FEncoders[i].EncodeJobs[j].EncodingOutputFilePath) then
        begin
          SetFileCreationTime(FEncoders[i].EncodeJobs[j].EncodingOutputFilePath, FMasterFileInfoList[FEncoders[i].EncodeJobs[j].FileListIndex].FileDate);
        end;
      end;
    end;
  end;
end;

procedure TMainForm.ApplicationEventsShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: Controls.THintInfo);
begin
  if HintInfo.HintControl = FileList then
  begin
    HintStr := 'List of files (' + IntToStr(FileList.Items.Count) + ' files)';
  end;
end;

procedure TMainForm.ApplyProfile(ProfileName: string);
const
  UserStr = '[User]';
var
  ProfileFilePath: string;
  ProfileFile: TIniFile;
begin
  if copy(ProfileList.Text, 1, Length(UserStr)) = UserStr then
  begin
    // user created profile
    ProfileFilePath := MainForm.FAppDataFolder + ProfileList.Text + '.pdo';
  end
  else
  begin
    // edited profile
    ProfileFilePath := ExtractFileDir(Application.ExeName) + '\Profiles\' + ProfileList.Text + '.pdo';
  end;

  if FileExists(ProfileFilePath) then
  begin
    ProfileFile := TIniFile.Create(ProfileFilePath);
    try
      with ProfileFile do
      begin
        // video
        VideoEncoderList.ItemIndex := ReadInteger('Main', 'VCodec', 2);
        AdvancedOptionsForm.VideobitrateList.Text := ReadString('Main', 'VBitrate', '1024');
        AdvancedOptionsForm.VideoSizeList.Text := ReplaceText(ReadString('Main', 'VideoSize', '512x384'), '(PAL)', '');
        AdvancedOptionsForm.WidthEdit.Text := ReplaceText(ReadString('Main', 'Width', '512'), '(PAL)', '');
        AdvancedOptionsForm.HeightEdit.Text := ReplaceText(ReadString('Main', 'Height', '320'), '(PAL)', '');
        AdvancedOptionsForm.VideoFPSList.Text := ReadString('Main', 'FPS', '25');
        AdvancedOptionsForm.VideoAspectRatioList.ItemIndex := ReadInteger('Main', 'VAR', 1);

        // audio
        AudioEncoderList.ItemIndex := ReadInteger('Main', 'ACodec', 1);
        AdvancedOptionsForm.AudioBitrateList.Text := ReadString('Main', 'ABitrate', '128');
        AdvancedOptionsForm.AudioSampleRateList.ItemIndex := ReadInteger('Main', 'ASR', 5);
        AdvancedOptionsForm.AudioChannelsList.ItemIndex := ReadInteger('Main', 'AChan', 1);

        EncoderList.ItemIndex := ReadInteger('Main', 'Encoder', 1);
        ContainerList.ItemIndex := ReadInteger('Main', 'Container', 2);

        // custom args
        with AdvancedOptionsForm do
        begin
          if EncoderList.ItemIndex = 0 then
          begin
            // mencoder
            CustomMEncoderAudioEdit.Text := ReadString('Main', 'CustomAudio', '');
            CustomMEncoderVideoEdit.Text := ReadString('Main', 'CustomVideo', '');
          end
          else
          begin
            // ffmpeg
            CustomFFMpegAudioEdit.Text := ReadString('Main', 'CustomAudio', '');
            CustomFFMpegVideoEdit.Text := ReadString('Main', 'CustomVideo', '');
          end;
        end;
      end;

    finally
      ProfileFile.Free;
      // AdvancedOptionsForm.VideoSizeListChange(Self);

      // disable/enable
      if (VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11) then
      begin
        AdvancedOptionsForm.VideobitrateList.Enabled := False;
        AdvancedOptionsForm.VideoSizeList.Enabled := False;
        AdvancedOptionsForm.VideoFPSList.Enabled := False;
        AdvancedOptionsForm.VideoAspectRatioList.Enabled := False;
        AdvancedOptionsForm.WidthEdit.Enabled := False;
        AdvancedOptionsForm.HeightEdit.Enabled := False;
        AdvancedOptionsForm.ForceASRBtn.Enabled := False;
        AdvancedOptionsForm.VideoCBrBtn.Enabled := False;
      end
      else if (VideoEncoderList.ItemIndex = 8) or (VideoEncoderList.ItemIndex = 9) then
      begin
        AdvancedOptionsForm.VideobitrateList.Enabled := False;
        AdvancedOptionsForm.VideoSizeList.Enabled := True;
        AdvancedOptionsForm.VideoFPSList.Enabled := True;
        AdvancedOptionsForm.VideoAspectRatioList.Enabled := True;
        AdvancedOptionsForm.WidthEdit.Enabled := True;
        AdvancedOptionsForm.HeightEdit.Enabled := True;
        AdvancedOptionsForm.ForceASRBtn.Enabled := True;
        AdvancedOptionsForm.VideoCBrBtn.Enabled := True;
      end
      else
      begin
        AdvancedOptionsForm.VideobitrateList.Enabled := True;
        AdvancedOptionsForm.VideoSizeList.Enabled := True;
        AdvancedOptionsForm.VideoFPSList.Enabled := True;
        AdvancedOptionsForm.VideoAspectRatioList.Enabled := True;
        AdvancedOptionsForm.WidthEdit.Enabled := True;
        AdvancedOptionsForm.HeightEdit.Enabled := True;
        AdvancedOptionsForm.ForceASRBtn.Enabled := True;
        AdvancedOptionsForm.VideoCBrBtn.Enabled := True;
      end;

      // enable/disable
      if (AudioEncoderList.ItemIndex = 10) or (AudioEncoderList.ItemIndex = 0) then
      begin
        AdvancedOptionsForm.AudioBitrateList.Enabled := False;
        AdvancedOptionsForm.AudioSampleRateList.Enabled := False;
        AdvancedOptionsForm.AudioChannelsList.Enabled := False;
      end
      else
      begin
        AdvancedOptionsForm.AudioBitrateList.Enabled := True;
        AdvancedOptionsForm.AudioSampleRateList.Enabled := True;
        AdvancedOptionsForm.AudioChannelsList.Enabled := True;
      end;
    end;
  end
  else
    Application.MessageBox('Cannot find profile file!', 'Error', MB_ICONERROR);
end;

procedure TMainForm.AudioEncoderListChange(Sender: TObject);
begin
  // enable/disable
  if (AudioEncoderList.ItemIndex = 10) or (AudioEncoderList.ItemIndex = 0) then
  begin
    AdvancedOptionsForm.AudioBitrateList.Enabled := False;
    AdvancedOptionsForm.AudioSampleRateList.Enabled := False;
    AdvancedOptionsForm.AudioChannelsList.Enabled := False;
  end
  else
  begin
    AdvancedOptionsForm.AudioBitrateList.Enabled := True;
    AdvancedOptionsForm.AudioSampleRateList.Enabled := True;
    AdvancedOptionsForm.AudioChannelsList.Enabled := True;
  end;
  UpdateSummary;
end;

procedure TMainForm.AudioTracksListChange(Sender: TObject);
var
  index: Integer;
begin
  index := FileList.ItemIndex;
  if index > -1 then
  begin
    if (AudioTracksList.Items.Count > 0) or (Length(AudioTracksList.Text) > 0) then
    begin
      if AudioTracksList.Text = '1. No audio' then
      begin
        FMasterFileInfoList[Index].AudioIndex := -1;
      end
      else
      begin
        FMasterFileInfoList[Index].AudioIndex := AudioTracksList.ItemIndex;
      end;
    end
    else
    begin
      FMasterFileInfoList[Index].AudioIndex := -1;
    end;
  end;
end;

procedure TMainForm.BatchAdd(const Links: TStrings; const SingleLink: Boolean);
Var
  LURL: string;
  LYIE: TYouTubeVideoInfoExtractor;
  I, j: Integer;
  LPass: TUserPass;
begin
  if Links.Count > 0 then
  begin
    VideoAddingForm.InfoLabel.Caption := 'Please wait...';
    Self.Enabled := False;
    VideoAddingForm.Show;
    MenuState(False);
    FStopAddingLink := False;
    // SendMessage(LinkList.Handle, WM_SETREDRAW, 0, 0);
    try
      for I := 0 to Links.Count - 1 do
      begin
        if FStopAddingLink then
        begin
          Break;
        end;
        Application.ProcessMessages;
        LURL := Trim(Links[i]);
        if Length(LURL) > 0 then
        begin
          if SingleLink then
          begin
            // normal link
            VideoAddingForm.InfoLabel.Caption := 'Adding videos to the list...(' + FloatToStr(i + 1) + '/' + FloatToStr(Links.Count) + ')';
            AddURL(LURL);
          end
          else
          begin
            // playlist
            VideoAddingForm.InfoLabel.Caption := 'Extracting video links from playlist, this may take a while...';
            LPass.UserName := UserEdit.Text;
            LPass.Password := PassEdit.Text;
            LYIE := TYouTubeVideoInfoExtractor.Create(LURL, FYoutubedlPath, FTempFolder, LPass, not SettingsForm.DontPreviewImgBtn.Checked);
            try
              LYIE.GetPlayListInfo;
              while (LYIE.PlaylistStatus = stReading) and (not FStopAddingLink) do
              begin
                Application.ProcessMessages;
                Sleep(10);
              end;
              if LYIE.PlayListVideoLinks.Count > 0 then
              begin
                for j := 0 to LYIE.PlayListVideoLinks.Count - 1 do
                begin
                  VideoAddingForm.InfoLabel.Caption := 'Adding videos to the list...(' + FloatToStr(j + 1) + '/' + FloatToStr(LYIE.PlayListVideoLinks.Count) + ')';
                  AddURL('http://www.youtube.com/watch?v=' + LYIE.PlayListVideoLinks[j]);
                end;
              end
              else
              begin
                if not FStopAddingLink then
                begin
                  Application.MessageBox('Could not get any links from playlist.', 'Error', MB_ICONERROR);
                end;
              end;
            finally
              LYIE.Free;
            end;
          end;
        end;
      end;
    finally
      Self.Enabled := True;
      VideoAddingForm.Close;
      // SendMessage(LinkList.Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(VideoDownloaderList.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
      MenuState(True);
    end;
  end;
end;

procedure TMainForm.Batchaddlinks1Click(Sender: TObject);
begin
  Self.Enabled := False;
  BatchAddForm.PMode := SingleLink;
  BatchAddForm.Show;
end;

procedure TMainForm.Batchaddplaylists1Click(Sender: TObject);
begin
  Self.Enabled := False;
  BatchAddForm.PMode := Playlist;
  BatchAddForm.Show;
end;

function TMainForm.CheckOutputFiles(out MissingFiles: TStringList): Boolean;
var
  I: Integer;
begin
  for I := 0 to FFilesToCheck.Count - 1 do
  begin
    // if output doesnt exist
    if not FileExists(FFilesToCheck[i]) then
    begin
      MissingFiles.Add(FFilesToCheck[i]);
      AddToLog(0, 'Missing output file ' + FFilesToCheck[i] + '.');
    end
    else
    begin
      // if file is empty
      if GetFileSize(FFilesToCheck[i]) < 1 then
      begin
        MissingFiles.Add(FFilesToCheck[i]);
        AddToLog(0, 'Output file ' + FFilesToCheck[i] + ' is empty.');
      end;
    end;
  end;
  Result := 0 <> MissingFiles.Count;
end;

procedure TMainForm.CheckUpdateThreadExecute(Sender: TObject; Params: Pointer);
begin
  UpdateChecker.Url := 'http://sourceforge.net/projects/tencoder/files/version.txt/download';
  UpdateChecker.FileName := MainForm.FAppDataFolder + '\version.txt';
  UpdateChecker.Start;

  CheckUpdateThread.CancelExecute;
end;

procedure TMainForm.ClearDownloadImages;
var
  lSearchRec: TSearchRec;
  lFind: integer;
  lPath: string;
  LType: string;
begin
  lPath := IncludeTrailingPathDelimiter(FTempFolder);
  LType := '*.jpg';
  lFind := FindFirst(lPath + LType, faAnyFile, lSearchRec);
  while lFind = 0 do
  begin
    DeleteFile(lPath + lSearchRec.Name);

    lFind := SysUtils.FindNext(lSearchRec);
  end;
  FindClose(lSearchRec);
end;

procedure TMainForm.ClearLinksBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    FVideoDownloadListItems[i].Panel.Visible := False;
    FVideoDownloadListItems[i].Free;
  end;
  FVideoDownloadListItems.Clear;
  for I := 0 to FDownloadItems.Count - 1 do
  begin
    FDownloadItems[i].Free;
  end;
  FDownloadItems.Clear;
end;

procedure TMainForm.ClearTempFolder;
var
  Search: TSearchRec;
  FileName: string;
  Extension: string;
begin
  if (FindFirst(FAppDataFolder + '\*.*', faAnyFile, Search) = 0) then
  Begin
    repeat
      Application.ProcessMessages;
      FileName := FAppDataFolder + '\' + Search.Name;
      Extension := LowerCase(ExtractFileExt(FileName));
      if (Extension = '.log') or (Extension = '.mbtree') or (Extension = '.temp') or (Extension = '.tmp') then
      begin
        DeleteFile(FileName);
      end;
    until (FindNext(Search) <> 0);
    FindClose(Search);
  end;
end;

procedure TMainForm.ClearTempFolderEx(const DeleteOnlyText: Boolean);
var
  lSearchRec: TSearchRec;
  lFind: integer;
  lPath: string;
  LType: string;
begin
  lPath := IncludeTrailingPathDelimiter(FTempFolder);
  if DeleteOnlyText then
  begin
    LType := '*.txt';
  end
  else
  begin
    LType := '*.*';
  end;
  try
    lFind := FindFirst(lPath + LType, faAnyFile, lSearchRec);
    while lFind = 0 do
    begin
      DeleteFile(lPath + lSearchRec.Name);

      lFind := SysUtils.FindNext(lSearchRec);
    end;
  finally
    FindClose(lSearchRec);
  end;
end;

procedure TMainForm.CloseProcesses;
var
  i: integer;
begin
  for I := Low(FEncoders) to High(FEncoders) do
    if FEncoders[i].ProcessID > 0 then
      FEncoders[i].Stop;
end;

function TMainForm.CorrectFileName(FileName: string): string;
var
  i: Integer;
  Tmp: string;
begin

  Result := FileName;

  for i := 1 to Length(FileName) do
  begin
    Application.ProcessMessages;

    if (FileName[i] <> ':') and (FileName[i] <> ' ') and (FileName[i] <> '\') and (FileName[i] <> '/') then
    begin
      Tmp := Tmp + FileName[i];
    end;

  end;

  if Length(Tmp) > 0 then
  begin
    Result := Tmp;
  end;

end;

function TMainForm.CreateDeintCMD(const Preview: Boolean): string;
begin
  if (EncoderList.ItemIndex = 0) or Preview then
  begin
    // mencoder
    case EffectForm.DeintMethodList.ItemIndex of
      0:
        Result := 'yadif=0,';
      1:
        Result := 'yadif=1:1,';
      2:
        Result := 'yadif=3:1,';
      3:
        Result := 'pp=lb,';
      4:
        Result := 'pp=li,';
      5:
        Result := 'pp=md,';
      6:
        Result := 'pp=ci,';
      7:
        Result := 'kerndeint,';
      8:
        Result := 'lavcdeint,';
    end;
  end
  else
  begin
    Result := ' -deinterlace ';
  end;
end;

function TMainForm.CreateDownloadConvertCMD(const SourcePath: string): string;
var
  VBitrate: string;
  VCodec: string;
  VFPS: string;
  VAspect: string;
  VHeight: string;
  VWidth: string;
  ABitrate: string;
  ACodec: string;
  ASR: string;
  AChan: string;
  OutExtension: string;
  AudioCMD: string;
  OutName: string;
  Container: string;
  FilterCMD: string;
  LVolumeCMD: string;
  CustomAudioArg: string;
  CustomVideoArg: string;
  CustomArgs: string;
begin

  // output extension and container options
  Container := 'avi';
  OutExtension := '.avi';

  case MainForm.ContainerList.ItemIndex of
    0:
      begin
        Container := 'avi ';
        OutExtension := '.avi';
      end;
    1:
      begin
        Container := 'mpeg ';
        OutExtension := '.mpeg';
      end;
    2:
      begin
        Container := 'mp4 ';
        OutExtension := '.mp4';
      end;
    3:
      begin
        Container := 'mov ';
        OutExtension := '.mov';
      end;
    4:
      begin
        Container := 'matroska ';
        OutExtension := '.mkv';
      end;
    5:
      begin
        Container := 'flv ';
        OutExtension := '.flv';
      end;
    6:
      begin
        Container := '';
        OutExtension := '.wmv';
      end;
    7:
      begin
        Container := 'webm ';
        OutExtension := '.webm';
      end;
    8:
      begin
        Container := '3gp ';
        OutExtension := '.3gp';
      end;
  end;

  // wmv
  if (MainForm.ContainerList.ItemIndex = 6) or (MainForm.VideoEncoderList.ItemIndex = 11) then
  begin
    Container := '';
  end
  else
  begin
    Container := ' -f ' + Container;
  end;

  ABitrate := AdvancedOptionsForm.AudioBitrateList.Text;

  if AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 7 then
  begin
    ASR := ' -af aresample=resampler=soxr -ar ' + AdvancedOptionsForm.AudioSampleRateList.Text
  end
  else
  begin
    ASR := ' ';
  end;

  // audio channels
  case AdvancedOptionsForm.AudioChannelsList.ItemIndex of
    0:
      begin
        AChan := ' -ac 1 '
      end;
    1:
      begin
        AChan := ' -ac 2 '
      end;
    2:
      begin
        AChan := ' -ac 6 '
      end;
    3:
      begin
        AChan := ' '
      end;
  end;

  if EffectForm.VolumeEnableBtn.Checked then
  begin
    LVolumeCMD := ' -af volume=' + StringReplace(FloatToStr(EffectForm.VolumeFFMpegEdit.Value / 100), ',', '.', [rfReplaceAll]);
  end
  else
  begin
    LVolumeCMD := ' ';
  end;

  if AdvancedOptionsForm.CustomFFMpegAudioBtn.Checked then
  begin
    CustomAudioArg := AdvancedOptionsForm.CustomFFMpegAudioEdit.Text;
  end;

  // codec
  case MainForm.AudioEncoderList.ItemIndex of
    0: // copy
      begin
        ACodec := ' -c:a copy' + CustomAudioArg;
      end;
    1: // mp3
      begin
        ACodec := ' -c:a libmp3lame -ab ' + ABitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    2: // aac
      begin
        ACodec := ' -strict experimental -c:a aac -ab ' + ABitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    3: // ogg
      begin
        ACodec := ' -c:a libvorbis -ab ' + ABitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    4: // wav
      begin
        ACodec := ' -c:a pcm_alaw';
      end;
    5: // ac3
      begin
        ACodec := ' -c:a ac3 -ab ' + ABitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    6: // mp2
      begin
        ACodec := ' -c:a mp2 -ab ' + ABitrate + 'k  ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    7: // wma2
      begin
        ACodec := ' -c:a wmav2 -ab ' + ABitrate + 'k  ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    8: // speex
      begin
        ACodec := ' -f ogg -c:a libspeex -ab ' + ABitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    9: // opus
      begin
        ACodec := ' -c:a libopus -ab ' + ABitrate + 'k ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
    11: // flac
      begin
        ACodec := ' -c:a flac -compression_level ' + AdvancedOptionsForm.FlacCompEdit.Text + ' ' + ASR + AChan + LVolumeCMD + ' ' + CustomAudioArg;
      end;
  end;

  // Video Options

  // bitrate
  VBitrate := AdvancedOptionsForm.VideobitrateList.Text + '000 ';

  // do cbr encoding
  if AdvancedOptionsForm.VideoCBrBtn.Checked then
  begin
    VBitrate := VBitrate + ' -minrate ' + VBitrate + ' -maxrate ' + VBitrate + ' -bufsize ' + IntToStr(StrToInt(Trim(VBitrate)) * 2) + ' -muxrate ' + IntToStr(StrToInt(Trim(VBitrate)) * 2) + ' ';
  end;

  // video size
  if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
  begin
    VHeight := AdvancedOptionsForm.WidthEdit.Text;
    VWidth := AdvancedOptionsForm.HeightEdit.Text;
  end;

  FilterCMD := '';
  // crop
  if EffectForm.CropEnable.Checked then
  begin
    FilterCMD := FilterCMD + ' -vf crop=' + EffectForm.CropWidthEdit.Text + ':' + EffectForm.CropHeightEdit.Text + ':' + EffectForm.CropXEdit.Text + ':' + EffectForm.CropYEdit.Text;
  end;

  // video size
  if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
  begin
    if Length(FilterCMD) > 0 then
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := FilterCMD + ',scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := FilterCMD + ',scale=' + AdvancedOptionsForm.WidthEdit.Text + ':trunc(ow/a/2)*2';
      end;
    end
    else
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := ' -vf scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := ' -vf scale=' + AdvancedOptionsForm.WidthEdit.Text + ':trunc(ow/a/2)*2';
      end;
    end;
  end;

  // rotate
  if EffectForm.RotateList.ItemIndex > 0 then
  begin
    if Length(FilterCMD) > 0 then
    begin
      FilterCMD := FilterCMD + ',transpose=' + FloatToStr(EffectForm.RotateList.ItemIndex - 1)
    end
    else
    begin
      FilterCMD := '-vf transpose=' + FloatToStr(EffectForm.RotateList.ItemIndex - 1)
    end;
  end;

  // FPS
  if AdvancedOptionsForm.VideoFPSList.ItemIndex = 0 then
  begin
    VFPS := ' '; // auto
  end
  else
  begin
    VFPS := ' -r ' + AdvancedOptionsForm.VideoFPSList.Text;
  end;

  if AdvancedOptionsForm.CustomFFMpegVideoBtn.Checked then
  begin
    CustomVideoArg := ' ' + AdvancedOptionsForm.CustomFFMpegVideoEdit.Text;
  end;
  if AdvancedOptionsForm.CustomFFMpegAudioBtn.Checked then
  begin
    CustomAudioArg := ' ' + AdvancedOptionsForm.CustomFFMpegAudioEdit.Text;
  end;

  // command line for aspect ratio
  case AdvancedOptionsForm.VideoAspectRatioList.ItemIndex of
    0:
      VAspect := '';
    1:
      VAspect := '-aspect 4:3';
    2:
      VAspect := '-aspect 16:9';
    3:
      VAspect := '-aspect 1.85';
    4:
      VAspect := '-aspect 2.35';
    5:
      VAspect := '-aspect 1.3333';
    6:
      VAspect := '-aspect 1.7777';
  end;

  // command line for video encoder
  case MainForm.VideoEncoderList.ItemIndex of
    0: // mpeg 1
      begin
        VCodec := ' -c:v mpeg1video ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    1: // mpeg 2
      begin
        VCodec := ' -c:v mpeg2video ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg
      end;
    2: // xvid
      begin
        VCodec := ' -c:v libxvid ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    3: // mpeg 4
      begin
        VCodec := ' -c:v mpeg4 ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    4: // h264
      begin
        if AdvancedOptionsForm.x264CRFBtn.Checked and AdvancedOptionsForm.x264Btn.Checked then
        begin
          VCodec := ' -c:v libx264 ' + ' -crf ' + AdvancedOptionsForm.x264CRFEdit.Text + ' ' + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' +
            CustomVideoArg;
        end
        else
        begin
          VCodec := ' -c:v libx264 ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg
        end;
      end;
    5: // flv
      begin
        VCodec := ' -c:v flv ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    6: // wmv
      begin
        VCodec := VFPS + ' -c:v wmv2 ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    7: // vp8
      begin
        VCodec := ' -c:v libvpx ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    8: // huffyuv
      begin
        VCodec := ' -c:v huffyuv ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    9: // prores
      begin
        VCodec := ' -c:v prores ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg;
      end;
    10:
      begin
        VCodec := ' -c:v copy ';
        OutExtension := ExtractFileExt(SourcePath);
      end;
    11:
      begin
        VCodec := ' -vn ';
        case MainForm.AudioEncoderList.ItemIndex of
          0: // copy
            begin
              OutExtension := ''
            end;
          1: // mp3
            begin
              OutExtension := '.mp3'
            end;
          2: // aac
            begin
              OutExtension := '.m4a'
            end;
          3: // ogg
            begin
              OutExtension := '.ogg'
            end;
          4: // wav
            begin
              OutExtension := '.wav'
            end;
          5: // ac3
            begin
              OutExtension := '.ac3'
            end;
          6: // mp2
            begin
              OutExtension := '.mp2'
            end;
          7: // wma2
            begin
              OutExtension := '.wma'
            end;
          8: // speex
            begin
              OutExtension := '.spx'
            end;
          9: // opus
            begin
              OutExtension := '.opus'
            end;
          11: // opus
            begin
              OutExtension := '.opus'
            end;
        end;
      end;
    12: // h265
      begin
        VCodec := ' -c:v libx265 ' + ' -b:v ' + VBitrate + ' ' + VAspect + ' ' + VFPS + ' ' + FilterCMD + ' ' + ImageAudiotoVideoForm.CreateAdvancedOptions + ' ' + CustomVideoArg
      end;
  end;

  OutName := ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\' + ExtractFileName(SourcePath);
  OutName := ChangeFileExt(OutName, OutExtension);
  CustomArgs := AdvancedOptionsForm.CustomFFmpegEdit.Text;

  Result := ' -y -threads 0 -i "' + SourcePath + '" ' + CustomArgs + VCodec + Container + AudioCMD + ACodec + ' "' + OutName + '"';
end;

function TMainForm.CreateDVDAdvancedCMD: string;
var
  AdvancedCMD: string;
begin

  Result := '';

  // mencoder
  case VideoEncoderList.ItemIndex of
    0: // mpeg 1
      begin
        AdvancedCMD := '';
      end;
    1: // mpeg 2
      begin
        AdvancedCMD := '';
      end;
    2: // xvid
      begin
        AdvancedCMD := '';
      end;
    3: // mpeg 4
      begin
        AdvancedCMD := '';
      end;
    4: // h264
      begin
        AdvancedCMD := '';

        with AdvancedOptionsForm do
        begin

          if x264Btn.Checked then
          begin
            // profile
            case x264ProfileList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ':profile=baseline';
              2:
                AdvancedCMD := AdvancedCMD + ':profile=main';
              3:
                AdvancedCMD := AdvancedCMD + ':profile=high';
              4:
                AdvancedCMD := AdvancedCMD + ':profile=high10';
              5:
                AdvancedCMD := AdvancedCMD + ':profile=high422';
              6:
                AdvancedCMD := AdvancedCMD + ':profile=high444';
            end;

            // presets
            case x264PresetList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ':preset=ultrafast';
              2:
                AdvancedCMD := AdvancedCMD + ':preset=superfast';
              3:
                AdvancedCMD := AdvancedCMD + ':preset=veryfast';
              4:
                AdvancedCMD := AdvancedCMD + ':preset=faster';
              5:
                AdvancedCMD := AdvancedCMD + ':preset=fast';
              6:
                AdvancedCMD := AdvancedCMD + ':preset=medium';
              7:
                AdvancedCMD := AdvancedCMD + ':preset=slow';
              8:
                AdvancedCMD := AdvancedCMD + ':preset=slower';
              9:
                AdvancedCMD := AdvancedCMD + ':preset=veryslow';
              10:
                AdvancedCMD := AdvancedCMD + ':preset=placebo';
            end;

            // tune
            case x264TuneList.ItemIndex of
              1:
                AdvancedCMD := AdvancedCMD + ':tune=film';
              2:
                AdvancedCMD := AdvancedCMD + ':tune=animation';
              3:
                AdvancedCMD := AdvancedCMD + ':tune=grain';
              4:
                AdvancedCMD := AdvancedCMD + ':tune=stillimage';
              5:
                AdvancedCMD := AdvancedCMD + ':tune=psnr';
              6:
                AdvancedCMD := AdvancedCMD + ':tune=ssim';
              7:
                AdvancedCMD := AdvancedCMD + ':tune=fastdecode';
              8:
                AdvancedCMD := AdvancedCMD + ':tune=zerolatency';
            end;

            // level
            if x264LevelList.ItemIndex > 0 then
            begin
              AdvancedCMD := AdvancedCMD + ':level=' + ReplaceStr(x264LevelList.Text, '.', '');
            end;
            // Delete(AdvancedCMD, 1, 1);
          end;

        end;
      end;
    5: // flv
      begin
        AdvancedCMD := '';
      end;
    6: // wmv
      begin
        AdvancedCMD := '';
      end;
    7: // vp8
      begin
        AdvancedCMD := '';
      end;
    8: // huffyuv
      begin
        AdvancedCMD := '';
      end;
    9: // prores
      begin
        AdvancedCMD := '';
      end;
    10: // copy
      begin
        AdvancedCMD := '';
      end;
    11: // none
      begin
        AdvancedCMD := '';
      end;
    12: // h265
      begin
        AdvancedCMD := '';
      end;
  end;
  if EncoderList.ItemIndex = 0 then
  begin
    if Length(AdvancedCMD) > 0 then
    begin
      if ':' <> copy(AdvancedCMD, 1, 1) then
      begin
        AdvancedCMD := ':' + AdvancedCMD;
      end;
    end;
  end;
  Result := AdvancedCMD;
end;

function TMainForm.CreateDVDCMD: TCommandLine;
const
  Mencoder1stPass = ':vpass=1:turbo';
  Mencoder2ndPass = ':vpass=2';
  MencoderXvid1stPass = ':pass=1:turbo';
  MencoderXvid2ndPass = ':pass=2';
var
  VBitrate: string;
  // VSize: string;
  VCodecPart1: string;
  VCodecPart2: string;
  VFPS: string;
  VAspect: string;
  ABitrate: string;
  ACodec: string;
  ASR: string;
  AChan: string;
  SubtitleCMD: string;
  OutExtension: string;
  AudioCMD: string;
  PassFile: string;
  OutName: string;
  Container: string;
  FilterCMD: string;
  LVolumeCMD: string;
  FPassStr: string;
begin

  // output extension and container options
  Container := 'avi';
  OutExtension := '.avi';
{$REGION 'container block'}
  case ContainerList.ItemIndex of
    0:
      begin
        Container := 'avi ';
        OutExtension := '.avi';
      end;
    1:
      begin
        Container := 'mpeg ';
        OutExtension := '.mpeg';
      end;
    2:
      begin
        Container := 'mp4 ';
        OutExtension := '.avi';
      end;
    3:
      begin
        Container := 'mov ';
        OutExtension := '.mov';
      end;
    4:
      begin
        Container := 'matroska ';
        OutExtension := '.mkv';
      end;
    5:
      begin
        Container := 'flv ';
        OutExtension := '.flv';
      end;
    6:
      begin
        Container := '';
        OutExtension := '.wmv';
      end;
    7:
      begin
        Container := 'webm ';
        OutExtension := '.webm';
      end;
    8:
      begin
        Container := '3gp ';
        OutExtension := '.3gp';
      end;
  end;
{$ENDREGION}
{$REGION 'outextension block'}
  if VideoEncoderList.ItemIndex = 10 then
  begin
    case ContainerList.ItemIndex of
      0:
        begin
          OutExtension := '.avi';
        end;
      1:
        begin
          OutExtension := '.mpeg';
        end;
      2:
        begin
          OutExtension := '.avi'; // mp4
        end;
      3:
        begin
          OutExtension := '.mov';
        end;
      4:
        begin
          OutExtension := '.mkv';
        end;
      5:
        begin
          OutExtension := '.flv';
        end;
      6:
        begin
          OutExtension := '.wmv';
        end;
      7:
        begin
          OutExtension := '.webm';
        end;
      8:
        begin
          OutExtension := '.avi';
        end;
    end;
  end;
{$ENDREGION}
{$REGION 'format block'}
  // avi, mpeg and rest for mencoder
  case ContainerList.ItemIndex of
    0:
      Container := ' -of avi ';
    1:
      Container := ' -of mpeg ';
  else
    begin
      // wmv
      if ContainerList.ItemIndex = 6 then
      begin
        Container := '';
      end
      // mp4 and webm
      else if (ContainerList.ItemIndex = 2) or (ContainerList.ItemIndex = 7) then
      begin
        Container := ' -of avi '
      end
      else
      begin
        Container := ' -of lavf -lavfopts format=' + Container + ' ';
      end;
    end;
  end;
{$ENDREGION}
  // audio options
  ABitrate := AdvancedOptionsForm.AudioBitrateList.Text;

  if AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 7 then
  begin
    ASR := ' -srate ' + AdvancedOptionsForm.AudioSampleRateList.Text
  end
  else
  begin
    ASR := ' ';
  end;

  // audio channels
  case AdvancedOptionsForm.AudioChannelsList.ItemIndex of
    0:
      begin
        AChan := ' -channels 1 '
      end;
    1:
      begin
        AChan := ' -channels 2 '
      end;
    2:
      begin
        AChan := ' -channels 6 '
      end;
    3:
      begin
        AChan := ' '
      end;
  end;

  // codec
  if EffectForm.VolumeEnableBtn.Checked then
  begin
    LVolumeCMD := ' -af-add volume=' + EffectForm.VolumeMencoderEdit.Text + ':0';
  end;

  case AudioEncoderList.ItemIndex of
    0: // copy
      begin
        ACodec := ' -oac  copy ';
      end;
    1: // mp3
      begin
        ACodec := ASR + ' -oac  mp3lame -lameopts cbr:br=' + ABitrate + ':' + AChan + LVolumeCMD;
      end;
    2: // aac
      begin
        ACodec := ASR + ' -oac faac -faacopts br=' + ABitrate + '' + ':' + AChan + LVolumeCMD;
      end;
    3: // ogg
      begin
        // will use ffmpeg for audio encoding
        // ACodec := ASR + ' -oac  lavc -lavcopts acodec=libvorbis:abitrate=' + ABitrate + ':' + AChan + LVolumeCMD;
        ACodec := ASR + ' -oac  pcm ' + AChan + LVolumeCMD;
      end;
    4: // wav
      begin
        ACodec := ASR + ' -oac  pcm ' + LVolumeCMD;
      end;
    5: // ac3
      begin
        ACodec := ASR + ' -oac  lavc -lavcopts acodec=ac3:abitrate=' + ABitrate + ':' + AChan + LVolumeCMD;
      end;
    6: // mp2
      begin
        ACodec := ASR + ' -oac  lavc -lavcopts acodec=mp2:abitrate=' + ABitrate + ':' + AChan + LVolumeCMD;
      end;
    7: // wmav2
      begin
        ACodec := ASR + ' -oac  lavc -lavcopts acodec=wmav2:abitrate=' + ABitrate + ':' + AChan + LVolumeCMD;
      end;
    8: // speex
      begin
        ACodec := ASR + ' ' + LVolumeCMD;
      end;
    10: // none
      begin
        ACodec := ' -nosound ';
      end;
    11: // flac
      begin
        ACodec := ' -oac  lavc -lavcopts acodec=flac ';
      end;
  end;

  // Video Options

  // bitrate
  VBitrate := AdvancedOptionsForm.VideobitrateList.Text;

  FilterCMD := '';
  // crop
  if EffectForm.CropEnable.Checked then
  begin
    FilterCMD := FilterCMD + ' -vf crop=' + EffectForm.CropWidthEdit.Text + ':' + EffectForm.CropHeightEdit.Text + ':' + EffectForm.CropXEdit.Text + ':' + EffectForm.CropYEdit.Text;
  end;

  // video size
  if AdvancedOptionsForm.VideoSizeList.ItemIndex <> 0 then
  begin
    if Length(FilterCMD) > 0 then
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := FilterCMD + ',scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := FilterCMD + ',scale=' + AdvancedOptionsForm.WidthEdit.Text + ':-2';
      end;
    end
    else
    begin
      // copy aspect ratio from source
      if not AdvancedOptionsForm.ForceASRBtn.Checked then
      begin
        FilterCMD := ' -vf scale=' + AdvancedOptionsForm.WidthEdit.Text + ':' + AdvancedOptionsForm.HeightEdit.Text;
      end
      else
      begin
        FilterCMD := ' -vf scale=' + AdvancedOptionsForm.WidthEdit.Text + ':-2';
      end;
    end;
  end
  else
  begin
    FilterCMD := ' -vf-add scale'
  end;

  // rotate
  if EffectForm.RotateList.ItemIndex > 0 then
  begin
    FilterCMD := FilterCMD + ' -vf-add rotate=' + FloatToStr(EffectForm.RotateList.ItemIndex - 1);
  end;

  // deint
  if EffectForm.DeintEnblBtn.Checked then
  begin
    if Length(CreateDeintCMD(True)) > 0 then
    begin
      FilterCMD := ' -vf-add ' + CreateDeintCMD(True);
    end;
  end;

  // comamnd line for FPS
  if AdvancedOptionsForm.VideoFPSList.ItemIndex = 0 then
  begin
    VFPS := ''; // auto
  end
  else
  begin
    VFPS := ' -ofps ' + AdvancedOptionsForm.VideoFPSList.Text;
  end;

  // command line for aspect ratio
  case AdvancedOptionsForm.VideoAspectRatioList.ItemIndex of
    0:
      VAspect := '';
    1:
      VAspect := ':aspect=4/3';
    2:
      VAspect := ':aspect=16/9';
    3:
      VAspect := ':aspect=1.85/1';
    4:
      VAspect := ':aspect=2.35/1';
    5:
      VAspect := ':aspect=1.3333/1';
    6:
      VAspect := ':aspect=1.7777/1';
  end;

  // command line for video encoder
  case VideoEncoderList.ItemIndex of
    0: // mpeg 1
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc lavc -lavcopts vcodec=mpeg1video:vbitrate=' + VBitrate;
        VCodecPart2 := VAspect + CreateDVDAdvancedCMD + DVDThreadCMD;
      end;
    1: // mpeg 2
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=mpeg2video:vbitrate=' + VBitrate;
        VCodecPart2 := VAspect + ':vrc_buf_size=1835:vstrict=0' + CreateDVDAdvancedCMD + DVDThreadCMD;
      end;
    2: // xvid
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc xvid -xvidencopts bitrate=' + VBitrate + CreateDVDAdvancedCMD + DVDThreadCMD;
        if (Length(VAspect) > 0) then
          VCodecPart2 := VAspect;
      end;
    3: // mpeg 4
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=mpeg4:vbitrate=' + VBitrate;
        VCodecPart2 := VAspect + CreateDVDAdvancedCMD + DVDThreadCMD;
        // ' -of lavf -lavfopts format=mp4 ';
      end;
    4: // h264
      begin
        if AdvancedOptionsForm.x264CRFBtn.Checked then
        begin
          VCodecPart1 := FilterCMD + VFPS + ' -ovc x264 -x264encopts crf=' + AdvancedOptionsForm.x264CRFEdit.Text;
          VCodecPart2 := CreateDVDAdvancedCMD + DVDThreadCMD;
        end
        else
        begin
          VCodecPart1 := FilterCMD + VFPS + ' -ovc x264 -x264encopts bitrate=' + VBitrate;
          VCodecPart2 := CreateDVDAdvancedCMD + DVDThreadCMD;
        end;
        // ' -of lavf -lavfopts format=mp4 ';
      end;
    5: // flv
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=flv:vbitrate=' + VBitrate;
        VCodecPart2 := VAspect + CreateDVDAdvancedCMD + DVDThreadCMD;
      end;
    6: // wmv
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=wmv2:vbitrate=' + VBitrate;
        VCodecPart2 := VAspect + CreateDVDAdvancedCMD + DVDThreadCMD;
      end;
    7: // vp8
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ffourcc VP80 -ovc lavc -lavcopts  vcodec=libvpx:vbitrate=' + VBitrate;
        VCodecPart2 := VAspect + CreateDVDAdvancedCMD + DVDThreadCMD;
      end;
    8: // huffyuv
      begin
        VCodecPart1 := FilterCMD + VFPS + ' -ovc lavc -lavcopts  vcodec=ffvhuff';
        VCodecPart2 := VAspect + CreateDVDAdvancedCMD + DVDThreadCMD;
      end;
    10: // copy
      begin
        VCodecPart1 := ' -ovc copy ';
      end;
  end;

  if DoTwoPassBtn.Checked then
  begin
    // two passes encoding

    // first pass
    OutName := CreateDVDFileName(ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\' + OutputFileNameEdit.Text, OutExtension);

    // pass log file
    PassFile := FAppDataFolder + '\dvd.log';

    // audio track selection
    if not DisableAudioBtn.Checked then
    begin
      if FCurrentTitle.AudioStreams.Count > 0 then
      begin
        if (FCurrentTitle.AudioStreams[DVDAudioTracksList.ItemIndex].ID = '-1') then
        begin
          AudioCMD := ' -nosound ';
        end
        else
        begin
          AudioCMD := ' -aid ' + FCurrentTitle.AudioStreams[DVDAudioTracksList.ItemIndex].ID + ' ';
        end;
      end
      else
      begin
        AudioCMD := ' -nosound '
      end;
    end
    else
    begin
      AudioCMD := ' -nosound '
    end;

    // subtitle options
    if not DisableSubBtn.Checked then
    begin
      if FCurrentTitle.SubtitleStreams.Count > 0 then
      begin
        if (FCurrentTitle.SubtitleStreams[DVDSubtitleTracksList.ItemIndex].ID = '-1') then
        begin
          SubtitleCMD := ' -nosub ';
        end
        else
        begin
          SubtitleCMD := ' -sid ' + FCurrentTitle.SubtitleStreams[DVDSubtitleTracksList.ItemIndex].ID + ' ';
        end;
      end
      else
      begin
        SubtitleCMD := ' -nosub '
      end;
    end
    else
    begin
      SubtitleCMD := ' -nosub ';
    end;

    if (VideoEncoderList.ItemIndex = 2) or (VideoEncoderList.ItemIndex = 4) then
    begin
      FPassStr := MencoderXvid1stPass
    end
    else
    begin
      FPassStr := Mencoder1stPass
    end;
    Result.FirstPassCMD := ' -mc 0 -priority idle ' + VCodecPart1 + FPassStr + VCodecPart2 + Container + ' -passlogfile "' + PassFile + '" -nosound -o NUL dvd://' +
      FloatToStr(TitlesList.ItemIndex + 1) + ' -dvd-device "' + DVDFolderEdit.Text + '"';

    // second pass
    OutName := CreateDVDFileName(ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\' + OutputFileNameEdit.Text, OutExtension);

    // pass log file
    PassFile := FAppDataFolder + '\dvd.log';

    // audio track selection
    if not DisableAudioBtn.Checked then
    begin
      if FCurrentTitle.AudioStreams.Count > 0 then
      begin
        if (FCurrentTitle.AudioStreams[DVDAudioTracksList.ItemIndex].ID = '-1') then
        begin
          AudioCMD := ' -nosound ';
        end
        else
        begin
          AudioCMD := ' -aid ' + FCurrentTitle.AudioStreams[DVDAudioTracksList.ItemIndex].ID + ' ';
        end;
      end
      else
      begin
        AudioCMD := ' -nosound '
      end;
    end
    else
    begin
      AudioCMD := ' -nosound '
    end;

    // subtitle options
    if not DisableSubBtn.Checked then
    begin
      if FCurrentTitle.SubtitleStreams.Count > 0 then
      begin
        if (FCurrentTitle.SubtitleStreams[DVDSubtitleTracksList.ItemIndex].ID = '-1') then
        begin
          SubtitleCMD := ' -nosub ';
        end
        else
        begin
          SubtitleCMD := ' -sid ' + FCurrentTitle.SubtitleStreams[DVDSubtitleTracksList.ItemIndex].ID + ' ';
        end;
      end
      else
      begin
        SubtitleCMD := ' -nosub '
      end;
    end
    else
    begin
      SubtitleCMD := ' -nosub ';
    end;

    if (VideoEncoderList.ItemIndex = 2) or (VideoEncoderList.ItemIndex = 4) then
    begin
      FPassStr := MencoderXvid2ndPass
    end
    else
    begin
      FPassStr := Mencoder2ndPass
    end;

    Result.SeconPassCMD := ' -mc 0 -priority idle ' + AudioCMD + VCodecPart1 + FPassStr + VCodecPart2 + Container + ACodec + SubtitleCMD + ' -passlogfile "' + PassFile + '" -o "' + OutName +
      '" dvd://' + FloatToStr(TitlesList.ItemIndex + 1) + ' -dvd-device "' + DVDFolderEdit.Text + '"';

  end
  else
  begin
    // single pass encoding

    OutName := CreateDVDFileName(ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\' + OutputFileNameEdit.Text, OutExtension);

    // audio track selection
    if not DisableAudioBtn.Checked then
    begin
      if FCurrentTitle.AudioStreams.Count > 0 then
      begin
        if (FCurrentTitle.AudioStreams[DVDAudioTracksList.ItemIndex].ID = '-1') then
        begin
          AudioCMD := ' -nosound ';
        end
        else
        begin
          AudioCMD := ' -aid ' + FCurrentTitle.AudioStreams[DVDAudioTracksList.ItemIndex].ID + ' ';
        end;
      end
      else
      begin
        AudioCMD := ' -nosound '
      end;
    end
    else
    begin
      AudioCMD := ' -nosound '
    end;

    // subtitle options
    if not DisableSubBtn.Checked then
    begin
      if FCurrentTitle.SubtitleStreams.Count > 0 then
      begin
        if (FCurrentTitle.SubtitleStreams[DVDSubtitleTracksList.ItemIndex].ID = '-1') then
        begin
          SubtitleCMD := ' -nosub ';
        end
        else
        begin
          SubtitleCMD := ' -sid ' + FCurrentTitle.SubtitleStreams[DVDSubtitleTracksList.ItemIndex].ID + ' ';
        end;
      end
      else
      begin
        SubtitleCMD := ' -nosub '
      end;
    end
    else
    begin
      SubtitleCMD := ' -nosub ';
    end;

    Result.SinglePassCMD := ' -mc 0 -priority idle ' + AudioCMD + VCodecPart1 + VCodecPart2 + Container + SubtitleCMD + ACodec + ' -o "' + OutName + '" dvd://' + FloatToStr(TitlesList.ItemIndex + 1) +
      ' -dvd-device "' + DVDFolderEdit.Text + '"';
  end;
  Result.OutputFile := OutName;
end;

function TMainForm.CreateDVDFileName(const FileName, Extension: string): string;
var
  FileIndex: Integer;
  OutFileName: string;
  TmpStr: string;
begin
  OutFileName := ChangeFileExt(FileName, Extension);
  TmpStr := OutFileName;
  FileIndex := 0;
  if FileExists(OutFileName) then
  begin
    while FileExists(OutFileName) do
    begin
      OutFileName := TmpStr;
      Inc(FileIndex);
      OutFileName := ChangeFileExt(OutFileName, '_' + FloatToStr(FileIndex) + Extension);
    end;
  end;
  Result := OutFileName;
end;

function TMainForm.CreateFileName(const FileName, Extension: string): string;
var
  FileIndex: Integer;
  OutFileName: string;
  TmpStr: string;
begin
  OutFileName := ChangeFileExt(FileName, Extension);
  // same as source
  if not UseSourceChkBtn.Checked then
  begin
    if DirectoryExists(DirectoryEdit.Text + '\' + GetFileFolderName(FileName)) then
    begin
      OutFileName := DirectoryEdit.Text + '\' + GetFileFolderName(FileName) + '\' + ExtractFileName(OutFileName);
    end
    else
    begin
      if CreateDir(DirectoryEdit.Text + '\' + GetFileFolderName(FileName)) then
      begin
        OutFileName := DirectoryEdit.Text + '\' + GetFileFolderName(FileName) + '\' + ExtractFileName(OutFileName);
      end
      else
      begin
        OutFileName := DirectoryEdit.Text + '\' + ExtractFileName(OutFileName);
      end;
    end;
  end
  else
  begin
    OutFileName := ChangeFileExt(ExtractFileDir(FileName) + '\' + ExtractFileName(OutFileName), Extension);
  end;

  TmpStr := OutFileName;
  FileIndex := 0;
  if FileExists(OutFileName) then
  begin
    while FileExists(OutFileName) do
    begin
      OutFileName := TmpStr;
      Inc(FileIndex);
      OutFileName := ChangeFileExt(OutFileName, '_' + FloatToStr(FileIndex) + Extension);
    end;
  end;
  Result := OutFileName;
end;

function TMainForm.CreateTempName: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := GUIDToString(LGUID);
end;

procedure TMainForm.D2Click(Sender: TObject);
begin
  Enabled := False;
  DubForm.Show;
end;

procedure TMainForm.DeleteBtnClick(Sender: TObject);
var
  LItemIndex, i: integer;
begin
  LItemIndex := (Sender as TsButton).Tag;
  FVideoDownloadListItems[LItemIndex].Panel.Visible := False;
  FVideoDownloadListItems.Delete(LItemIndex);
  FDownloadItems.Delete(LItemIndex);
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    if FVideoDownloadListItems[i].DeleteButton.Tag > LItemIndex then
    begin
      FVideoDownloadListItems[i].DeleteButton.Tag := FVideoDownloadListItems[i].DeleteButton.Tag - 1;
    end;
  end;
end;

procedure TMainForm.DeleteTempFiles;
var
  i: integer;
begin
  ClearDownloadImages;

  for I := 0 to FTempFilesToDelete.Count - 1 do
  begin
    Application.ProcessMessages;
    if Length(ExtractFileExt(FTempFilesToDelete[i])) > 0 then
    begin
      if FileExists(FTempFilesToDelete[i]) then
      begin
        if DeleteFile(FTempFilesToDelete[i]) then
        begin
          AddToLog(0, 'Deleted temp file ' + FTempFilesToDelete[i]);
        end;
      end
      else
      begin
        AddToLog(0, 'Unable to find temp file ' + FTempFilesToDelete[i]);
      end;
    end
    else
    begin
      if DirectoryExists(FTempFilesToDelete[i]) then
      begin
        if RemoveDir(FTempFilesToDelete[i]) then
        begin
          AddToLog(0, 'Deleted temp directory ' + FTempFilesToDelete[i]);
        end;
      end
      else
      begin
        AddToLog(0, 'Unable to find temp directory ' + FTempFilesToDelete[i]);
      end;
    end;
  end;
end;

procedure TMainForm.DisableAudioBtnClick(Sender: TObject);
begin
  DVDAudioTracksList.Enabled := not DisableAudioBtn.Checked
end;

procedure TMainForm.DisableSubBtnClick(Sender: TObject);
begin
  DVDSubtitleTracksList.Enabled := not DisableSubBtn.Checked;
end;

procedure TMainForm.DonateBtnClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QX8G3B2A4VRJG', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DownBtnClick(Sender: TObject);
var
  index, i: Integer;
  lv, lv2: TListItem;
  SelectedItems: TStringList;
begin

  try
    SelectedItems := TStringList.Create;

    i := FileList.Items.Count - 1;

    while i > -1 do
    begin
      Application.ProcessMessages;

      if FileList.Items.Item[i].Selected then
      begin
        index := i;
        SelectedItems.Add(FloatToStr(i + 1));
        if (index >= 0) and (index < FileList.Items.Count - 1) then
        begin
          lv2 := FileList.Items[index];
          try
            // queue list
            lv := FileList.Items.Insert(Index + 2);
            lv.Assign(lv2);
            lv2.Delete;

            FMasterFileInfoList.Exchange(i, i + 1);

            ExchangeItems(FileList, i, i + 1);
            ExchangeItems(FileList, i, i + 1);
          finally

          end;
        end;
      end
      else
      begin
        Dec(i);
      end;
    end;

    if SelectedItems.Count > 0 then
    begin
      for i := 0 to SelectedItems.Count - 1 do
      begin
        Index := StrToInt(SelectedItems.Strings[i]);
        if Index < FileList.Items.Count then
        begin
          FileList.Items.Item[Index].Selected := True;
          FileList.Items.Item[Index].Focused := True;
        end;
      end;
    end;
  finally
    FreeAndNil(SelectedItems);
  end;
end;

procedure TMainForm.DownloadNormalState;
var
  I: Integer;
  j: Integer;
begin
  FuncPages.Pages[0].Enabled := True;
  FuncPages.Pages[2].Enabled := True;
  StartDownloadBtn.Enabled := True;
  AddLinkBtn.Enabled := True;
  DirectoryEdit.Enabled := True;
  ClearLinksBtn.Enabled := True;
  StopDownloadBtn.Enabled := False;
  SettingsBtn.Enabled := True;
  DownloadSettingsBtn.Enabled := True;
  ProfileList.Enabled := True;
  ApplyProfileBtn.Enabled := True;
  NewProfileBtn.Enabled := True;
  SelectBtn.Enabled := True;
  UseSourceChkBtn.Enabled := True;
  DoTwoPassBtn.Enabled := True;
  EnableSubBtn.Enabled := True;
  ExportScriptBtn.Enabled := True;
  EncoderList.Enabled := True;
  VideoEncoderList.Enabled := True;
  AudioEncoderList.Enabled := True;
  ContainerList.Enabled := True;
  SubOptionsBtn.Enabled := True;
  VideoSettingsBtn.Enabled := True;
  ConvertDownloadedBtn.Enabled := True;
  PassBtn.Enabled := True;
  LinkEdit.Enabled := True;
  LinkTypeList.Enabled := True;
  AddSingleLinkBtn.Enabled := True;
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    for j := 0 to FVideoDownloadListItems[i].Panel.ControlCount - 1 do
    begin
      if (FVideoDownloadListItems[i].Panel.Controls[j] is TsComboBox) or (FVideoDownloadListItems[i].Panel.Controls[j] is TsButton) then
        FVideoDownloadListItems[i].Panel.Controls[j].Enabled := True;
    end;
    for j := 0 to FVideoDownloadListItems[i].Panel2.ControlCount - 1 do
    begin
      if (FVideoDownloadListItems[i].Panel2.Controls[j] is TsComboBox) or (FVideoDownloadListItems[i].Panel2.Controls[j] is TsButton) then
        FVideoDownloadListItems[i].Panel2.Controls[j].Enabled := True;
    end;
    for j := 0 to FVideoDownloadListItems[i].Panel3.ControlCount - 1 do
    begin
      if (FVideoDownloadListItems[i].Panel3.Controls[j] is TsComboBox) or (FVideoDownloadListItems[i].Panel3.Controls[j] is TsButton) then
        FVideoDownloadListItems[i].Panel3.Controls[j].Enabled := True;
    end;
  end;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := True;
  end;
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    for j := 0 to FVideoDownloadListItems[i].Panel.ControlCount - 1 do
    begin
      FVideoDownloadListItems[i].Panel.Controls[j].Enabled := True;
      if FVideoDownloadListItems[i].Panel.Controls[j] is TsProgressBar then
      begin
        TsProgressBar(FVideoDownloadListItems[i].Panel.Controls[j]).Position := 0;
      end;
      FVideoDownloadListItems[i].ResetProgressLabel;
    end;
  end;
  for I := 0 to FuncPages.Pages[0].ControlCount - 1 do
  begin
    FuncPages.Pages[0].Controls[i].Enabled := True;
  end;
  for I := 0 to FuncPages.Pages[2].ControlCount - 1 do
  begin
    FuncPages.Pages[2].Controls[i].Enabled := True;
  end;
  Self.Caption := 'TEncoder';
  TotalBar.Position := 0;
  VideoDownloaderProgressLabel.Caption := 'Progress: 0/0';
  SetProgressValue(Handle, 0, MaxInt);
  FuncPagesChange(Self);
end;

procedure TMainForm.DownloadSettingsBtnClick(Sender: TObject);
begin
  SettingsForm.SettingsList.ActivePageIndex := 4;
  SettingsForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.DownloadState;
var
  I: Integer;
  j: Integer;
begin
  FuncPages.Pages[0].Enabled := False;
  FuncPages.Pages[2].Enabled := False;
  StartDownloadBtn.Enabled := False;
  AddLinkBtn.Enabled := False;
  DirectoryEdit.Enabled := False;
  ClearLinksBtn.Enabled := False;
  StopDownloadBtn.Enabled := True;
  SettingsBtn.Enabled := False;
  DownloadSettingsBtn.Enabled := False;
  ProfileList.Enabled := False;
  ApplyProfileBtn.Enabled := False;
  NewProfileBtn.Enabled := False;
  SelectBtn.Enabled := False;
  UseSourceChkBtn.Enabled := False;
  DoTwoPassBtn.Enabled := False;
  EnableSubBtn.Enabled := False;
  ExportScriptBtn.Enabled := False;
  EncoderList.Enabled := False;
  VideoEncoderList.Enabled := False;
  AudioEncoderList.Enabled := False;
  ContainerList.Enabled := False;
  SubOptionsBtn.Enabled := False;
  VideoSettingsBtn.Enabled := False;
  ConvertDownloadedBtn.Enabled := False;
  PassBtn.Enabled := False;
  LinkEdit.Enabled := False;
  LinkTypeList.Enabled := False;
  AddSingleLinkBtn.Enabled := False;
  if PassPnl.Visible then
  begin
    PassPnl.Visible := False;
  end;
  if PassBtn.Down then
  begin
    PassBtn.Down := False;
  end;
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    for j := 0 to FVideoDownloadListItems[i].Panel.ControlCount - 1 do
    begin
      if (FVideoDownloadListItems[i].Panel.Controls[j] is TsComboBox) or (FVideoDownloadListItems[i].Panel.Controls[j] is TsButton) then
        FVideoDownloadListItems[i].Panel.Controls[j].Enabled := False;
    end;
    for j := 0 to FVideoDownloadListItems[i].Panel2.ControlCount - 1 do
    begin
      if (FVideoDownloadListItems[i].Panel2.Controls[j] is TsComboBox) or (FVideoDownloadListItems[i].Panel2.Controls[j] is TsButton) then
        FVideoDownloadListItems[i].Panel2.Controls[j].Enabled := False;
    end;
    for j := 0 to FVideoDownloadListItems[i].Panel3.ControlCount - 1 do
    begin
      if (FVideoDownloadListItems[i].Panel3.Controls[j] is TsComboBox) or (FVideoDownloadListItems[i].Panel3.Controls[j] is TsButton) then
        FVideoDownloadListItems[i].Panel3.Controls[j].Enabled := False;
    end;
  end;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := False;
  end;
  for I := 0 to FuncPages.Pages[0].ControlCount - 1 do
  begin
    FuncPages.Pages[0].Controls[i].Enabled := False;
  end;
  for I := 0 to FuncPages.Pages[2].ControlCount - 1 do
  begin
    FuncPages.Pages[2].Controls[i].Enabled := False;
  end;
end;

procedure TMainForm.DragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
var
  FileName: string;
  I: Integer;
  Extension: string;
begin
  inherited;

  AddForm.StatusLabel.Caption := 'Adding files please wait...';
  AddForm.AbortBtn.Enabled := True;
  AddForm.Show;
  MainForm.Enabled := False;
  FFileAddingStoppedByUser := False;

  try

    // Get name of each file dropped and process it
    for I := 0 to Value.Count - 1 do
    begin

      FileName := Value.Strings[i];

      if FFileAddingStoppedByUser then
      begin
        Break;
      end
      else
      begin
        Extension := LowerCase(ExtractFileExt(FileName));

        if (Extension = '.avi') or (Extension = '.wmv') or (Extension = '.vob') or (Extension = '.dat') or (Extension = '.mp4') or (Extension = '.mpeg') or (Extension = '.mpg') or
          (Extension = '.mov') or (Extension = '.mkv') or (Extension = '.flv') or (Extension = '.m4v') or (Extension = '.m2v') or (Extension = '.mp3') or (Extension = '.wav') or
          (Extension = '.aac') or (Extension = '.m4a') or (Extension = '.m4b') or (Extension = '.ac3') or (Extension = '.ogg') or (Extension = '.flac') or (Extension = '.mp2') or
          (Extension = '.webm') or (Extension = '.m2ts') or (Extension = '.mts') or (Extension = '.rmvb') or (Extension = '.opus') or (Extension = '.spx') or (Extension = '.mxf') or (Extension = '.ts')
        then
        begin

          if FFileAddingStoppedByUser then
          begin
            Break;
          end
          else
          begin
            AddForm.StatusLabel.Caption := ExtractFileName(FileName);
            AddFile(FileName);
          end;

        end;

      end;

    end;

  finally

    AddForm.Close;
    MainForm.Enabled := True;
    MainForm.BringToFront;
    FFileAddingStoppedByUser := False;

    FLastOpenedDir := ExtractFileDir(FileName);
  end;
end;

procedure TMainForm.DVDAddtoBatchBtnClick(Sender: TObject);
var
  LCMD: TCommandLine;
  LMp4CMD: string;
  LExtractAudioFile: string;
  LMEncoderMp4MuxExt: string;
  LOggAudioCMD: string;
  LOggRemuxExtension: string;
  LRenameFile: TStringList;
  LDVDJob: TDVDJob;
  LItem: TListItem;
  LOutputFileName: string;
  LListItemIndex: integer;
begin
{$REGION 'Codec checks etc'}
  // must choose a video codec
  if (VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11) then
  begin
    Application.MessageBox('Select a video codec.', 'Error', MB_ICONERROR);
    Exit;
  end;
  // must choose an audio codec
  if (AudioEncoderList.ItemIndex = 0) or (AudioEncoderList.ItemIndex = 10) then
  begin
    Application.MessageBox('Select an audio codec.', 'Error', MB_ICONERROR);
    Exit;
  end;
  // mencoder does not support speex encoding
  if (AudioEncoderList.ItemIndex = 8) then
  begin
    Application.MessageBox('Mencoder does not support encoding audio with Speex codec!', 'Error', MB_ICONERROR);
    Exit;
  end;
  // mencoder does not support opus encoding
  if (AudioEncoderList.ItemIndex = 9) then
  begin
    Application.MessageBox('Mencoder does not support encoding audio with Opus codec!', 'Error', MB_ICONERROR);
    Exit;
  end;
  // mencoder does not support prores encoding
  if (VideoEncoderList.ItemIndex = 9) then
  begin
    Application.MessageBox('Mencoder does not support encoding video with ProRes codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // mencoder does not support x265 encoding
  if (VideoEncoderList.ItemIndex = 12) then
  begin
    Application.MessageBox('Mencoder does not support encoding video with x265 codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // check if given birate values are valid
  if (VideoEncoderList.ItemIndex <> 9) and (VideoEncoderList.ItemIndex <> 10) then
  begin
    if not IsStringNumeric(AdvancedOptionsForm.VideobitrateList.Text) then
    begin
      Application.MessageBox('Please enter a valid video bitrate value!', 'Error', MB_ICONERROR);
    end;
  end;
  if (AudioEncoderList.ItemIndex <> 9) and (AudioEncoderList.ItemIndex <> 0) then
  begin
    if not IsStringNumeric(AdvancedOptionsForm.AudioBitrateList.Text) then
    begin
      Application.MessageBox('Please enter a valid audio bitrate value!', 'Error', MB_ICONERROR);
    end;
  end;
  // crf and two pass wont work
  if (VideoEncoderList.ItemIndex = 4) and (AdvancedOptionsForm.x264Btn.Checked) and (AdvancedOptionsForm.x264CRFBtn.Checked) and (DoTwoPassBtn.Checked) then
  begin
    Application.MessageBox('CRF is incompatible with two pass!', 'Warning', MB_ICONWARNING);
    Exit;
  end;
  // vp8 & mencoder & two pass
  if DoTwoPassBtn.Checked and (VideoEncoderList.ItemIndex = 7) then
  begin
    if ID_YES = Application.MessageBox('Two pass VP8 encoding with Mencoder is problematic at the moment. Would you like to do a single pass?', 'Warning', MB_ICONWARNING or MB_YESNO) then
    begin
      DoTwoPassBtn.Checked := False;
    end;
  end;
  // vp8 ogg vorbis webm
  if (VideoEncoderList.ItemIndex = 7) and ((AudioEncoderList.ItemIndex <> 3) or (ContainerList.ItemIndex <> 7)) then
  begin
    Application.MessageBox('VP8 video codec works with only OggVorbis as audio codec and Webm as container.', 'Error', MB_ICONERROR);
    Exit;
  end;
{$ENDREGION}
  // a title must be selected
  if FCurrentTitle <> nil then
  begin
    if Length(OutputFileNameEdit.Text) > 0 then
    begin
      LDVDJob := TDVDJob.Create;
      LOutputFileName := '"' + DVDFolderEdit.Text + '"';

      // create command lines
      LCMD := CreateDVDCMD;

      LListItemIndex := FDVDJobs.Count;
      if DoTwoPassBtn.Checked then
      begin
        // two pass
        // first pass
        LDVDJob.CMDs.Add(LCMD.FirstPassCMD);
        LDVDJob.ProcessTypes.Add(dvdmencoder);
        LDVDJob.EncoderPaths.Add(FMEncoder64Path);
        LDVDJob.FilePaths.Add(DVDFolderEdit.Text);
        LDVDJob.Infos.Add('First pass');
        AddToLog(6, '1st pass command: ' + LCMD.FirstPassCMD);
        // second pass
        LDVDJob.CMDs.Add(LCMD.SeconPassCMD);
        LDVDJob.ProcessTypes.Add(dvdmencoder);
        LDVDJob.EncoderPaths.Add(FMEncoder64Path);
        LDVDJob.FilePaths.Add(DVDFolderEdit.Text);
        LDVDJob.Infos.Add('Second pass');
        AddToLog(6, '2nd pass command: ' + LCMD.SeconPassCMD);
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
      end
      else
      begin
        // single pass
        LDVDJob.CMDs.Add(LCMD.SinglePassCMD);
        LDVDJob.ProcessTypes.Add(dvdmencoder);
        LDVDJob.EncoderPaths.Add(FMEncoder64Path);
        LDVDJob.FilePaths.Add(DVDFolderEdit.Text);
        LDVDJob.Infos.Add('Encoding');
        AddToLog(6, 'Single pass command: ' + LCMD.SinglePassCMD);
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
      end;
      // mencoder doesn't seem to be able produce valid ogg streams.
      // we first convert to flac then to ogg using ffmpeg
      if AudioEncoderList.ItemIndex = 3 then
      begin
        // convert flac audio to ogg usingffmpeg
        LOggRemuxExtension := ExtractFileExt(LCMD.OutputFile);
        LOggAudioCMD := '-y -i "' + LCMD.OutputFile + '" -c:v copy -c:a libvorbis -ab ' + AdvancedOptionsForm.AudioBitrateList.Text + 'k "' +
          ChangeFileExt(LCMD.OutputFile, '_temp' + LOggRemuxExtension) + '"';
        LDVDJob.CMDs.Add(LOggAudioCMD);
        LDVDJob.ProcessTypes.Add(dvdffmpeg);
        LDVDJob.EncoderPaths.Add(FFFMpegPath);
        LDVDJob.FilePaths.Add(DVDFolderEdit.Text);
        LDVDJob.Infos.Add('Encoding');
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
        AddToLog(6, 'Ogg encoding command: ' + LOggAudioCMD);
        // rename converted file to original output file name
        LRenameFile := TStringList.Create;
        try
          LRenameFile.Add(LCMD.OutputFile);
          LRenameFile.Add(ChangeFileExt(LCMD.OutputFile, '_temp' + LOggRemuxExtension));
          LRenameFile.SaveToFile(FTempFolder + '\dvdogg.txt', TEncoding.UTF8);
          LDVDJob.CMDs.Add('"' + FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt"');
          LDVDJob.ProcessTypes.Add(dvdrenametool);
          LDVDJob.EncoderPaths.Add('');
          LDVDJob.Infos.Add('Renaming');
          LDVDJob.ListItemIndexes.Add(LListItemIndex);
          AddToLog(6, 'Renaming command: "' + FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt"');
          LDVDJob.TempFiles.Add(FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt');
        finally
          LRenameFile.Free;
        end;
      end;

      // mux to mp4
      // I don't know how but this seems to work.
      if ContainerList.ItemIndex = 2 then
      begin
        // raw temp video extension
        if VideoEncoderList.ItemIndex = 4 then
        begin
          // h264
          LMEncoderMp4MuxExt := '_.h264'
        end
        else if VideoEncoderList.ItemIndex = 3 then
        begin
          // mpeg4
          LMEncoderMp4MuxExt := '_.m4v'
        end
        else if VideoEncoderList.ItemIndex = 2 then
        begin
          LMEncoderMp4MuxExt := '_.h263';
        end
        else
        begin
          LMEncoderMp4MuxExt := '_.avi'
        end;
        LMp4CMD := ' -y -i "' + LCMD.OutputFile + '" -vn -f mp4 ';
        case AudioEncoderList.ItemIndex of
          1:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.mp3');
          2:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.m4a');
          3:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.ogg');
          4:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.wav');
          5:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.ac3');
          6:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.mp2');
          7:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.wma');
          8:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.spx');
          9:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.opus');
          11:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.flac');
        end;
        LMp4CMD := LMp4CMD + ' "' + ExtractFileDir(LExtractAudioFile) + '\' + ExtractFileName(LExtractAudioFile) + '"';
        LDVDJob.CMDs.Add(LMp4CMD);
        LDVDJob.ProcessTypes.Add(dvdffmpeg);
        LDVDJob.Infos.Add('Extracting audio');
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
        LDVDJob.EncoderPaths.Add(FFFMpegPath);
        LDVDJob.OutputFiles.Add(LCMD.OutputFile);
        AddToLog(6, 'Audio extraction command: ' + LMp4CMD);

        // extract video
        LMp4CMD := ' -of rawvideo -ovc copy -nosound "' + ExtractFileDir(LCMD.OutputFile) + '\' + ExtractFileName(LCMD.OutputFile) + '" -o "' +
          ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '"';
        LDVDJob.CMDs.Add(LMp4CMD);
        LDVDJob.ProcessTypes.Add(dvdmencoder);
        LDVDJob.Infos.Add('Extracting video');
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
        LDVDJob.EncoderPaths.Add(FMEncoder64Path);
        LDVDJob.OutputFiles.Add(LCMD.OutputFile);
        AddToLog(6, 'Video extraction command: ' + LMp4CMD);
        if (not DisableAudioBtn.Checked) and (DVDAudioTracksList.ItemIndex > -1) then
        begin
          LMp4CMD := ' -add "' + ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -add "' +
            ExtractFileDir(LExtractAudioFile) + '\' + ExtractFileName(LExtractAudioFile) + '" -new "' + CreateDVDFileName(LCMD.OutputFile, '.mp4') + '"';
        end
        else
        begin
          LMp4CMD := ' -add "' + ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -new "' +
            CreateDVDFileName(LCMD.OutputFile, '.mp4') + '"';
        end;
        LDVDJob.CMDs.Add(LMp4CMD);
        LDVDJob.ProcessTypes.Add(dvdmp4box);
        LDVDJob.Infos.Add('Muxing');
        LDVDJob.ListItemIndexes.Add(LListItemIndex);
        LDVDJob.EncoderPaths.Add(FMp4BoxPath);
        LDVDJob.OutputFiles.Add(LCMD.OutputFile);
        AddToLog(6, 'MP4 muxing command: ' + LMp4CMD);
        // delete temp files
        LDVDJob.TempFiles.Add(ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)));
        LDVDJob.TempFiles.Add(ExtractFileDir(LExtractAudioFile) + '\' + ExtractFileName(LExtractAudioFile));
        LDVDJob.TempFiles.Add(ExtractFileDir(LCMD.OutputFile) + '\' + ExtractFileName(LCMD.OutputFile));
        LDVDJob.TempFiles.Add(ExtractFileDir(LExtractAudioFile) + '\');
        // output file to be checked
        LDVDJob.FilesToCheck.Add(CreateDVDFileName(LCMD.OutputFile, '.mp4'));
        LOutputFileName := LOutputFileName + ' ' + TitlesList.Text + ' to "' + ExtractFileName(CreateDVDFileName(LCMD.OutputFile, '.mp4')) + '"';
      end
      else if ContainerList.ItemIndex = 7 then
      begin

      end
      else
      begin
        // output file to be checked
        LDVDJob.FilesToCheck.Add(LCMD.OutputFile);
        LOutputFileName := LOutputFileName + ' ' + TitlesList.Text + ' to "' + ExtractFileName(LCMD.OutputFile) + '"';
      end;
      FDVDJobs.Add(LDVDJob);
      LItem := DVDJobList.Items.Add;
      LItem.Caption := LOutputFileName;
      LItem.SubItems.Add('Waiting');
      LItem.StateIndex := 1;
    end
    else
    begin
      Application.MessageBox('Please enter a valid output file name.', 'Error', MB_ICONERROR);
    end;
  end
  else
  begin
    Application.MessageBox('Please select a title.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.DVDBatchClearBtnClick(Sender: TObject);
var
  I: Integer;
begin
  if ID_YES = Application.MessageBox('Remove all from batch DVD rip list?', 'Remove All', MB_ICONQUESTION or MB_YESNO) then
  begin
    DVDJobList.Items.Clear;
    for I := 0 to FDVDJobs.Count - 1 do
    begin
      FDVDJobs[i].Free;
    end;
    FDVDJobs.Clear;
  end;
end;

procedure TMainForm.DVDBatchDoneUI;
var
  I: Integer;
begin
  FuncPages.Pages[0].Enabled := True;
  FuncPages.Pages[1].Enabled := True;
  DVDBatchRemoveBtn.Enabled := True;
  DVDBatchClearBtn.Enabled := True;
  DVDBatchStartBtn.Enabled := True;
  DVDBatchStopBtn.Enabled := False;
  DVDNextTitleBtn.Enabled := True;
  DVDPreTitleBtn.Enabled := True;
  DVDConsoleEdit.Clear;
  DVDInfoLabel.Caption := '';
  DVDProgressBar.Position := 0;
  DVDTotalProgressBar.Position := 0;
  SetProgressValue(Handle, 0, 100);
  Self.Caption := 'TEncoder';
  VideoSettingsBtn.Enabled := True;

  SettingsBtn.Enabled := True;
  DirectoryEdit.Enabled := True;
  ProfileList.Enabled := True;
  ApplyProfileBtn.Enabled := True;
  NewProfileBtn.Enabled := True;
  SelectBtn.Enabled := True;
  UseSourceChkBtn.Enabled := True;
  DoTwoPassBtn.Enabled := True;
  EnableSubBtn.Enabled := True;
  ExportScriptBtn.Enabled := True;
  EncoderList.Enabled := True;
  VideoEncoderList.Enabled := True;
  AudioEncoderList.Enabled := True;
  ContainerList.Enabled := True;
  SubOptionsBtn.Enabled := True;
  VideoSettingsBtn.Enabled := False;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := True;
  end;
  for I := 0 to FuncPages.Pages[0].ControlCount - 1 do
  begin
    FuncPages.Pages[0].Controls[i].Enabled := True;
  end;
  for I := 0 to FuncPages.Pages[1].ControlCount - 1 do
  begin
    FuncPages.Pages[1].Controls[i].Enabled := True;
  end;
  for I := 0 to DVDPages.Pages[0].ControlCount - 1 do
  begin
    DVDPages.Pages[0].Controls[i].Enabled := True;
  end;
  VideoSettingsBtn.Enabled := True;
end;

procedure TMainForm.DVDBatchRemoveBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := DVDJobList.Items.Count - 1 downto 0 do
  begin
    if DVDJobList.Items[i].Selected then
    begin
      DVDJobList.Items.Delete(i);
      FDVDJobs.Delete(i);
    end;
  end;
end;

procedure TMainForm.DVDBatchRipUI;
var
  I: Integer;
begin
  FuncPages.Pages[0].Enabled := False;
  FuncPages.Pages[1].Enabled := False;
  DVDBatchRemoveBtn.Enabled := False;
  DVDBatchClearBtn.Enabled := False;
  DVDBatchStartBtn.Enabled := False;
  DVDBatchStopBtn.Enabled := True;
  DVDNextTitleBtn.Enabled := False;
  DVDPreTitleBtn.Enabled := False;

  SettingsBtn.Enabled := False;
  DirectoryEdit.Enabled := False;
  ProfileList.Enabled := False;
  ApplyProfileBtn.Enabled := False;
  NewProfileBtn.Enabled := False;
  SelectBtn.Enabled := False;
  UseSourceChkBtn.Enabled := False;
  DoTwoPassBtn.Enabled := False;
  EnableSubBtn.Enabled := False;
  ExportScriptBtn.Enabled := False;
  EncoderList.Enabled := False;
  VideoEncoderList.Enabled := False;
  AudioEncoderList.Enabled := False;
  ContainerList.Enabled := False;
  SubOptionsBtn.Enabled := False;
  VideoSettingsBtn.Enabled := False;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := False;
  end;
  for I := 0 to FuncPages.Pages[0].ControlCount - 1 do
  begin
    FuncPages.Pages[0].Controls[i].Enabled := False;
  end;
  for I := 0 to FuncPages.Pages[1].ControlCount - 1 do
  begin
    FuncPages.Pages[1].Controls[i].Enabled := False;
  end;
  for I := 0 to DVDPages.Pages[0].ControlCount - 1 do
  begin
    DVDPages.Pages[0].Controls[i].Enabled := False;
  end;
end;

procedure TMainForm.DVDBatchStartBtnClick(Sender: TObject);
var
  LCMD: TCommandLine;
  LMp4CMD: string;
  LExtractAudioFile: string;
  LMEncoderMp4MuxExt: string;
  LOggAudioCMD: string;
  LOggRemuxExtension: string;
  LRenameFile: TStringList;
  I: Integer;
begin
  if FDVDJobs.Count > 0 then
  begin
    // reset
    FDVDRipperProcess.ResetValues;
    FTimePassed := 0;
    FTempFilesToDelete.Clear;
    FFilesToCheck.Clear;

    for I := 0 to FDVDJobs.Count - 1 do
    begin
      FDVDRipperProcess.CommandLines.AddStrings(FDVDJobs[i].CMDs);
      FDVDRipperProcess.EncoderPaths.AddStrings(FDVDJobs[i].EncoderPaths);
      FDVDRipperProcess.FileNames.AddStrings(FDVDJobs[i].FilePaths);
      FDVDRipperProcess.OutputFiles.AddStrings(FDVDJobs[i].OutputFiles);
      FDVDRipperProcess.ProcessTypes.AddRange(FDVDJobs[i].ProcessTypes.ToArray);
      FDVDRipperProcess.Infos.AddStrings(FDVDJobs[i].Infos);
      FDVDRipperProcess.ListItemIndexes.AddRange(FDVDJobs[i].ListItemIndexes.ToArray);

      FTempFilesToDelete.AddStrings(FDVDJobs[i].TempFiles);
      FFilesToCheck.AddStrings(FDVDJobs[i].FilesToCheck);
    end;
    if FDVDRipperProcess.CommandLines.Count > 0 then
    begin
      for I := 0 to DVDJobList.Items.Count - 1 do
      begin
        with DVDJobList.Items[i] do
        begin
          StateIndex := 1;
          SubItems[0] := 'Waiting...';
        end;
      end;

      AddToLog(6, '');
      DVDBatchRipUI;
      AddToLog(0, 'Starting to rip DVDs.');
      FDVDRipperProcess.Start;
      DVDPosTimer.Enabled := True;
      Timer.Enabled := True;
      DVDBatchStopBtn.Enabled := True;
      DVDPages.ActivePageIndex := 1;
    end;
  end
  else
  begin
    Application.MessageBox('Please create DVD jobs first.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.DVDDoneUI;
var
  I: Integer;
  j: Integer;
begin
  FuncPages.Pages[0].Enabled := True;
  FuncPages.Pages[1].Enabled := True;
  StartDownloadBtn.Enabled := True;
  OpenDVDBtn.Enabled := True;
  DVDStopBtn.Enabled := False;
  DVDFolderEdit.Enabled := True;
  ReadDVDBtn.Enabled := True;
  OutputFileNameEdit.Enabled := True;
  StartChaperList.Enabled := True;
  EndChapterList.Enabled := True;
  DisableAudioBtn.Enabled := True;
  DisableSubBtn.Enabled := True;
  TitlesList.Enabled := True;
  DisableAudioBtnClick(Self);
  DisableSubBtnClick(Self);
  DVDFilterBtn.Enabled := True;
  DVDNextTitleBtn.Enabled := True;
  DVDPreTitleBtn.Enabled := True;
  DVDInfoLabel.Caption := '';
  DVDProgressBar.Position := 0;
  DVDTotalProgressBar.Position := 0;
  SetProgressValue(Handle, 0, 100);
  Self.Caption := 'TEncoder';

  SettingsBtn.Enabled := True;
  DirectoryEdit.Enabled := True;
  ProfileList.Enabled := True;
  ApplyProfileBtn.Enabled := True;
  NewProfileBtn.Enabled := True;
  SelectBtn.Enabled := True;
  UseSourceChkBtn.Enabled := True;
  DoTwoPassBtn.Enabled := True;
  EnableSubBtn.Enabled := True;
  ExportScriptBtn.Enabled := True;
  EncoderList.Enabled := True;
  VideoEncoderList.Enabled := True;
  AudioEncoderList.Enabled := True;
  ContainerList.Enabled := True;
  SubOptionsBtn.Enabled := True;
  VideoSettingsBtn.Enabled := True;
  ConvertDownloadedBtn.Enabled := True;
  PassBtn.Enabled := True;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := True;
  end;
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    for j := 0 to FVideoDownloadListItems[i].Panel.ControlCount - 1 do
    begin
      FVideoDownloadListItems[i].Panel.Controls[j].Enabled := True;
      if FVideoDownloadListItems[i].Panel.Controls[j] is TsProgressBar then
      begin
        TsProgressBar(FVideoDownloadListItems[i].Panel.Controls[j]).Position := 0;
      end;
      FVideoDownloadListItems[i].ResetProgressLabel;
    end;
  end;
  for I := 0 to FuncPages.Pages[0].ControlCount - 1 do
  begin
    FuncPages.Pages[0].Controls[i].Enabled := True;
  end;
  for I := 0 to FuncPages.Pages[1].ControlCount - 1 do
  begin
    FuncPages.Pages[1].Controls[i].Enabled := True;
  end;
  Self.Caption := 'TEncoder';
  DVDProgressBar.Position := 0;
  DVDTotalProgressBar.Position := 0;
  DVDConsoleEdit.Text := '';
  DVDInfoLabel.Caption := '';
  SetProgressValue(Handle, 0, MaxInt);
  FuncPagesChange(Self);
  VideoSettingsBtn.Enabled := True;
end;

procedure TMainForm.DVDEncodeBtnClick(Sender: TObject);
var
  LCMD: TCommandLine;
  LMp4CMD: string;
  LExtractAudioFile: string;
  LMEncoderMp4MuxExt: string;
  LOggAudioCMD: string;
  LOggRemuxExtension: string;
  LRenameFile: TStringList;
begin
{$REGION 'codec checks'}
  // must choose a video codec
  if (VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11) then
  begin
    Application.MessageBox('Select a video codec.', 'Error', MB_ICONERROR);
    Exit;
  end;
  // must choose an audio codec
  if (AudioEncoderList.ItemIndex = 0) or (AudioEncoderList.ItemIndex = 10) then
  begin
    Application.MessageBox('Select an audio codec.', 'Error', MB_ICONERROR);
    Exit;
  end;
  // mencoder does not support speex encoding
  if (AudioEncoderList.ItemIndex = 8) then
  begin
    Application.MessageBox('Mencoder does not support encoding audio with Speex codec!', 'Error', MB_ICONERROR);
    Exit;
  end;
  // mencoder does not support opus encoding
  if (AudioEncoderList.ItemIndex = 9) then
  begin
    Application.MessageBox('Mencoder does not support encoding audio with Opus codec!', 'Error', MB_ICONERROR);
    Exit;
  end;
  // mencoder does not support prores encoding
  if (VideoEncoderList.ItemIndex = 9) then
  begin
    Application.MessageBox('Mencoder does not support encoding video with ProRes codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // mencoder does not support x265 encoding
  if (VideoEncoderList.ItemIndex = 12) and (EncoderList.ItemIndex = 0) then
  begin
    Application.MessageBox('Mencoder does not support encoding video with x265 codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // check if given birate values are valid
  if (VideoEncoderList.ItemIndex <> 9) and (VideoEncoderList.ItemIndex <> 10) then
  begin
    if not IsStringNumeric(AdvancedOptionsForm.VideobitrateList.Text) then
    begin
      Application.MessageBox('Please enter a valid video bitrate value!', 'Error', MB_ICONERROR);
    end;
  end;
  if (AudioEncoderList.ItemIndex <> 9) and (AudioEncoderList.ItemIndex <> 0) then
  begin
    if not IsStringNumeric(AdvancedOptionsForm.AudioBitrateList.Text) then
    begin
      Application.MessageBox('Please enter a valid audio bitrate value!', 'Error', MB_ICONERROR);
    end;
  end;
  // crf and two pass wont work
  if (VideoEncoderList.ItemIndex = 4) and (AdvancedOptionsForm.x264Btn.Checked) and (AdvancedOptionsForm.x264CRFBtn.Checked) and (DoTwoPassBtn.Checked) then
  begin
    Application.MessageBox('CRF is incompatible with two pass!', 'Warning', MB_ICONWARNING);
    Exit;
  end;
  // vp8 & mencoder & two pass
  if DoTwoPassBtn.Checked and (VideoEncoderList.ItemIndex = 7) then
  begin
    if ID_YES = Application.MessageBox('Two pass VP8 encoding with Mencoder is problematic at the moment. Would you like to do a single pass?', 'Warning', MB_ICONWARNING or MB_YESNO) then
    begin
      DoTwoPassBtn.Checked := False;
    end;
  end;
  // vp8 ogg vorbis webm
  if (VideoEncoderList.ItemIndex = 7) and ((AudioEncoderList.ItemIndex <> 3) or (ContainerList.ItemIndex <> 7)) then
  begin
    Application.MessageBox('VP8 video codec works with only OggVorbis as audio codec and Webm as container.', 'Error', MB_ICONERROR);
    Exit;
  end;
{$ENDREGION}
  // a title must be selected
  if FCurrentTitle <> nil then
  begin
    if Length(OutputFileNameEdit.Text) > 0 then
    begin
      // reset
      FDVDRipperProcess.ResetValues;
      FTimePassed := 0;
      FTempFilesToDelete.Clear;
      FFilesToCheck.Clear;

      // create command lines
      LCMD := CreateDVDCMD;

      if DoTwoPassBtn.Checked then
      begin
        // two pass
        // first pass
        FDVDRipperProcess.CommandLines.Add(LCMD.FirstPassCMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdmencoder);
        FDVDRipperProcess.EncoderPaths.Add(FMEncoder64Path);
        FDVDRipperProcess.FileNames.Add(DVDFolderEdit.Text);
        FDVDRipperProcess.Infos.Add('First pass');
        AddToLog(6, '1st pass command: ' + LCMD.FirstPassCMD);
        // second pass
        FDVDRipperProcess.CommandLines.Add(LCMD.SeconPassCMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdmencoder);
        FDVDRipperProcess.EncoderPaths.Add(FMEncoder64Path);
        FDVDRipperProcess.FileNames.Add(DVDFolderEdit.Text);
        FDVDRipperProcess.Infos.Add('Second pass');
        AddToLog(6, '2nd pass command: ' + LCMD.SeconPassCMD);
      end
      else
      begin
        // single pass
        FDVDRipperProcess.CommandLines.Add(LCMD.SinglePassCMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdmencoder);
        FDVDRipperProcess.EncoderPaths.Add(FMEncoder64Path);
        FDVDRipperProcess.FileNames.Add(DVDFolderEdit.Text);
        FDVDRipperProcess.Infos.Add('Encoding');
        AddToLog(6, 'Single pass command: ' + LCMD.SinglePassCMD);
      end;
      // mencoder doesn't seem to be able produce valid ogg streams.
      // we first convert to flac then to ogg using ffmpeg
      if AudioEncoderList.ItemIndex = 3 then
      begin
        // convert flac audio to ogg usingffmpeg
        LOggRemuxExtension := ExtractFileExt(LCMD.OutputFile);
        LOggAudioCMD := '-y -i "' + LCMD.OutputFile + '" -c:v copy -c:a libvorbis -ab ' + AdvancedOptionsForm.AudioBitrateList.Text + 'k "' +
          ChangeFileExt(LCMD.OutputFile, '_temp' + LOggRemuxExtension) + '"';
        FDVDRipperProcess.CommandLines.Add(LOggAudioCMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdffmpeg);
        FDVDRipperProcess.EncoderPaths.Add(FFFMpegPath);
        FDVDRipperProcess.FileNames.Add(DVDFolderEdit.Text);
        FDVDRipperProcess.Infos.Add('Encoding');
        AddToLog(6, 'Ogg encoding command: ' + LOggAudioCMD);
        // rename converted file to original output file name
        LRenameFile := TStringList.Create;
        try
          LRenameFile.Add(LCMD.OutputFile);
          LRenameFile.Add(ChangeFileExt(LCMD.OutputFile, '_temp' + LOggRemuxExtension));
          LRenameFile.SaveToFile(FTempFolder + '\dvdogg.txt', TEncoding.UTF8);
          FDVDRipperProcess.CommandLines.Add('"' + FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt"');
          FDVDRipperProcess.ProcessTypes.Add(dvdrenametool);
          FDVDRipperProcess.EncoderPaths.Add('');
          FDVDRipperProcess.Infos.Add('Renaming');
          AddToLog(6, 'Renaming command: "' + FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt"');
          FTempFilesToDelete.Add(FDVDRenamePath + '" "' + FTempFolder + '\dvdogg.txt');
        finally
          LRenameFile.Free;
        end;
      end;

      // mux to mp4
      if ContainerList.ItemIndex = 2 then
      begin
        // raw temp video extension
        if VideoEncoderList.ItemIndex = 4 then
        begin
          // h264
          LMEncoderMp4MuxExt := '_.h264'
        end
        else if VideoEncoderList.ItemIndex = 3 then
        begin
          // mpeg4
          LMEncoderMp4MuxExt := '_.m4v'
        end
        else if VideoEncoderList.ItemIndex = 2 then
        begin
          LMEncoderMp4MuxExt := '_.h263';
        end
        else
        begin
          LMEncoderMp4MuxExt := '_.avi'
        end;
        LMp4CMD := ' -y -i "' + LCMD.OutputFile + '" -vn -f mp4 ';
        case AudioEncoderList.ItemIndex of
          1:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.mp3');
          2:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.m4a');
          3:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.ogg');
          4:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.wav');
          5:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.ac3');
          6:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.mp2');
          7:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.wma');
          8:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.spx');
          9:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.opus');
          11:
            LExtractAudioFile := ChangeFileExt(LCMD.OutputFile, '_.flac');
        end;
        LMp4CMD := LMp4CMD + ' "' + ExtractFileDir(LExtractAudioFile) + '\' + ExtractFileName(LExtractAudioFile) + '"';
        FDVDRipperProcess.CommandLines.Add(LMp4CMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdffmpeg);
        FDVDRipperProcess.Infos.Add('Extracting audio');
        FDVDRipperProcess.EncoderPaths.Add(FFFMpegPath);
        FDVDRipperProcess.OutputFiles.Add(LCMD.OutputFile);
        AddToLog(6, 'Audio extraction command: ' + LMp4CMD);

        // extract video
        LMp4CMD := ' -of rawvideo -ovc copy -nosound "' + ExtractFileDir(LCMD.OutputFile) + '\' + ExtractFileName(LCMD.OutputFile) + '" -o "' +
          ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '"';
        FDVDRipperProcess.CommandLines.Add(LMp4CMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdmencoder);
        FDVDRipperProcess.Infos.Add('Extracting video');
        FDVDRipperProcess.EncoderPaths.Add(FMEncoder64Path);
        FDVDRipperProcess.OutputFiles.Add(LCMD.OutputFile);
        AddToLog(6, 'Video extraction command: ' + LMp4CMD);
        if (not DisableAudioBtn.Checked) and (DVDAudioTracksList.ItemIndex > -1) then
        begin
          LMp4CMD := ' -add "' + ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -add "' +
            ExtractFileDir(LExtractAudioFile) + '\' + ExtractFileName(LExtractAudioFile) + '" -new "' + CreateDVDFileName(LCMD.OutputFile, '.mp4') + '"';
        end
        else
        begin
          LMp4CMD := ' -add "' + ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '" -new "' +
            CreateDVDFileName(LCMD.OutputFile, '.mp4') + '"';
        end;
        FDVDRipperProcess.CommandLines.Add(LMp4CMD);
        FDVDRipperProcess.ProcessTypes.Add(dvdmp4box);
        FDVDRipperProcess.Infos.Add('Muxing');
        FDVDRipperProcess.EncoderPaths.Add(FMp4BoxPath);
        FDVDRipperProcess.OutputFiles.Add(LCMD.OutputFile);
        AddToLog(6, 'MP4 muxing command: ' + LMp4CMD);
        // delete temp files
        FTempFilesToDelete.Add(ExtractFileDir(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)) + '\' + ExtractFileName(ChangeFileExt(LCMD.OutputFile, LMEncoderMp4MuxExt)));
        FTempFilesToDelete.Add(ExtractFileDir(LExtractAudioFile) + '\' + ExtractFileName(LExtractAudioFile));
        FTempFilesToDelete.Add(ExtractFileDir(LCMD.OutputFile) + '\' + ExtractFileName(LCMD.OutputFile));
        FTempFilesToDelete.Add(ExtractFileDir(LExtractAudioFile) + '\');
        // output file to be checked
        FFilesToCheck.Add(CreateDVDFileName(LCMD.OutputFile, '.mp4'));
      end
      else if ContainerList.ItemIndex = 7 then
      begin

      end
      else
      begin
        // output file to be checked
        FFilesToCheck.Add(LCMD.OutputFile);
      end;

      AddToLog(6, '');
      DVDRipUI;
      AddToLog(0, 'Starting to rip DVD.');
      FDVDRipperProcess.Start;
      DVDPosTimer.Enabled := True;
      Timer.Enabled := True;
      DVDStopBtn.Enabled := True;
    end
    else
    begin
      Application.MessageBox('Please enter a valid output file name.', 'Error', MB_ICONERROR);
    end;
  end
  else
  begin
    Application.MessageBox('Please select a title.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.DVDFilterBtnClick(Sender: TObject);
begin
  EffectForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.DVDFolderEditAfterDialog(Sender: TObject; var Name: string; var Action: Boolean);
begin
  FTitles.Clear;
  TitlesList.Items.Clear;
  DVDAudioTracksList.Items.Clear;
  DVDSubtitleTracksList.Items.Clear;
  FCurrentTitle := nil;
  OutputFileNameEdit.Text := '';
end;

procedure TMainForm.DVDNextTitleBtnClick(Sender: TObject);
begin
  if TitlesList.Items.Count > 0 then
  begin
    if TitlesList.ItemIndex < TitlesList.Items.Count - 1 then
    begin
      TitlesList.ItemIndex := TitlesList.ItemIndex + 1;
      TitlesListChange(Self);
    end;
  end;
end;

procedure TMainForm.DVDPosTimerTimer(Sender: TObject);
var
  LProgressStr: string;
  LProgressInt: integer;
  LMissingFileList: TStringList;
  LTotalProgress: integer;
begin
  if FDVDRipperProcess.FilesDone = FDVDRipperProcess.CommandCount then
  begin
    // done
    DVDPosTimer.Enabled := False;
    Timer.Enabled := False;
    DeleteTempFiles;
    DVDBatchDoneUI;

    if SettingsForm.PlaySoundBtn.Checked then
    begin
      if FileExists(ExtractFileDir(Application.ExeName) + '\done.wav') then
      begin
        sndPlaySound('done.wav', SND_ASYNC);
      end;
    end;

    AddToLog(0, 'Ripping took ' + IntegerToTime(FTimePassed) + '.');
    AddToLog(0, '');

    // post-encode action
    case PostEncodeList3.ItemIndex of
      0:
        begin
          // check output files
          LMissingFileList := TStringList.Create;
          try
            if CheckOutputFiles(LMissingFileList) then
            begin
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder failed to rip DVD. Please check logs.', btError, 5000, True);
            end
            else
            begin
              AddToLog(0, 'TEncoder could locate all output files.');
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder finished ripping DVD.', btInfo, 5000, True);
            end;
            TrayIcon.ShowApplication;
          finally
            LMissingFileList.Free;
          end;
          SaveOptions;
        end;
      1:
        begin
          SaveOptions;
          Application.Terminate;
        end;
      2:
        begin
          // check output files
          LMissingFileList := TStringList.Create;
          try
            if CheckOutputFiles(LMissingFileList) then
            begin
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder failed to rip DVD. Please check logs.', btError, 5000, True);
            end
            else
            begin
              AddToLog(0, 'TEncoder could locate all output files.');
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder finished ripping DVD.', btInfo, 5000, True);
            end;
            TrayIcon.ShowApplication;
          finally
            LMissingFileList.Free;
          end;
          SaveOptions;
          if not UseSourceChkBtn.Checked then
          begin
            if (DirectoryExists(DirectoryEdit.Text)) then
            begin
              ShellExecute(Application.Handle, 'open', PChar(DirectoryEdit.Text), nil, nil, SW_SHOWNORMAL);
            end
            else
            begin
              Application.MessageBox('Cannot open output folder because it does not exist!', 'Error', MB_ICONERROR);
            end;
          end;
        end;
      3:
        begin
          SaveOptions;
          ShutDown(EWX_SHUTDOWN or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
      4:
        begin
          SaveOptions;
          ShutDown(EWX_REBOOT or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
      5:
        begin
          SaveOptions;
          ShutDown(EWX_LOGOFF or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
    end;
  end
  else
  begin
    // console output
    DVDConsoleEdit.Text := FDVDRipperProcess.ConsoleOutput;
    // current step progress
    case FDVDRipperProcess.CurrentProcessType of
      dvdmencoder:
        LProgressStr := GetMencoderPosition(FDVDRipperProcess.ConsoleOutput);
      dvdffmpeg:
        LProgressStr := '0';
      dvdmp4box:
        LProgressStr := GetMp4Progress(FDVDRipperProcess.ConsoleOutput);
      dvdrenametool:
        LProgressStr := '0';
    end;
    if TryStrToInt(LProgressStr, LProgressInt) then
    begin
      if LProgressInt > DVDProgressBar.Position then
      begin
        DVDProgressBar.Position := LProgressInt;
      end;
    end;
    // step info
    DVDInfoLabel.Caption := FDVDRipperProcess.Info + ' [' + IntegerToTime(FTimePassed) + ']';
    // total progress
    LTotalProgress := ((100 * FDVDRipperProcess.FilesDone) div FDVDRipperProcess.CommandCount) + (DVDProgressBar.Position div FDVDRipperProcess.CommandCount);;
    if LTotalProgress > DVDTotalProgressBar.Position then
    begin
      DVDTotalProgressBar.Position := LTotalProgress;
    end;
    SetProgressValue(Handle, DVDTotalProgressBar.Position, DVDTotalProgressBar.Max);
    Self.Caption := FloatToStr(DVDTotalProgressBar.Position) + '% TEncoder';
  end;
end;

procedure TMainForm.DVDPreTitleBtnClick(Sender: TObject);
begin
  if TitlesList.Items.Count > 0 then
  begin
    if TitlesList.ItemIndex > 0 then
    begin
      TitlesList.ItemIndex := TitlesList.ItemIndex - 1;
      TitlesListChange(Self);
    end;
  end;
end;

procedure TMainForm.DVDRipUI;
var
  I: Integer;
begin
  FuncPages.Pages[0].Enabled := False;
  FuncPages.Pages[1].Enabled := False;
  StartDownloadBtn.Enabled := False;
  OpenDVDBtn.Enabled := False;
  DVDStopBtn.Enabled := True;
  DVDFolderEdit.Enabled := False;
  ReadDVDBtn.Enabled := False;
  OutputFileNameEdit.Enabled := False;
  DVDAudioTracksList.Enabled := False;
  DVDSubtitleTracksList.Enabled := False;
  StartChaperList.Enabled := False;
  EndChapterList.Enabled := False;
  DisableAudioBtn.Enabled := False;
  DisableSubBtn.Enabled := False;
  TitlesList.Enabled := False;
  DVDFilterBtn.Enabled := False;
  DVDNextTitleBtn.Enabled := True;
  DVDPreTitleBtn.Enabled := True;

  SettingsBtn.Enabled := False;
  DirectoryEdit.Enabled := False;
  ProfileList.Enabled := False;
  ApplyProfileBtn.Enabled := False;
  NewProfileBtn.Enabled := False;
  SelectBtn.Enabled := False;
  UseSourceChkBtn.Enabled := False;
  DoTwoPassBtn.Enabled := False;
  EnableSubBtn.Enabled := False;
  ExportScriptBtn.Enabled := False;
  EncoderList.Enabled := False;
  VideoEncoderList.Enabled := False;
  AudioEncoderList.Enabled := False;
  ContainerList.Enabled := False;
  SubOptionsBtn.Enabled := False;
  VideoSettingsBtn.Enabled := False;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := False;
  end;
  for I := 0 to FuncPages.Pages[0].ControlCount - 1 do
  begin
    FuncPages.Pages[0].Controls[i].Enabled := False;
  end;
  for I := 0 to FuncPages.Pages[1].ControlCount - 1 do
  begin
    FuncPages.Pages[1].Controls[i].Enabled := False;
  end;
end;

procedure TMainForm.DVDStopBtnClick(Sender: TObject);
begin
  if ID_YES <> Application.MessageBox('Do you want to stop DVD ripping?', 'Stop', MB_ICONQUESTION or MB_YESNO) then
    Exit;
  if FDVDRipperProcess.ProcessID > 0 then
  begin
    FDVDRipperProcess.Stop;
    DVDPosTimer.Enabled := False;
    Timer.Enabled := False;
    DeleteTempFiles;
    DVDBatchDoneUI;
  end;
end;

function TMainForm.DVDThreadCMD: string;
begin
  Result := ':threads=' + FloatToStr(CPUCount);
end;

procedure TMainForm.EditDelaysBtnClick(Sender: TObject);
begin

  FileList.OnDblClick(Self);

end;

procedure TMainForm.EditRangeBtnClick(Sender: TObject);
var
  index: integer;
begin
  index := FileList.ItemIndex;
  if index > -1 then
  begin
    MainForm.Enabled := False;
    with RangeEditorForm do
    begin
      VideoName := FMasterFileInfoList[Index].FilePath;
      VideoIndex := index;
      SubtitleIndex := FMasterFileInfoList[index].SubtitleIndex;
      StartValue := FMasterFileInfoList[Index].StartPosition;
      EndValue := FMasterFileInfoList[Index].EndPosition;
      PositionBar.MaxValue := FMasterFileInfoList[index].ConstDuration;
      if EndValue > StartValue then
      begin
        Show;
      end
      else
      begin
        Application.MessageBox('Invalid range values!', 'Error', MB_ICONERROR);
      end;
    end;
  end;
end;

procedure TMainForm.EffectsBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FileList.Items.Count - 1 do
  begin
    EffectForm.PreviewList.Items.Add(ExtractFileName(FMasterFileInfoList[I].FilePath));
  end;

  if EffectForm.PreviewList.Items.Count > 0 then
    EffectForm.PreviewList.ItemIndex := 0;

  EffectForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.EnableSubBtnClick(Sender: TObject);
begin
  UpdateSummary;
end;

procedure TMainForm.EncoderListChange(Sender: TObject);
begin
  UpdateSummary;
end;

procedure TMainForm.EndChapterListChange(Sender: TObject);
begin
  if EndChapterList.ItemIndex < StartChaperList.ItemIndex then
  begin
    StartChaperList.ItemIndex := EndChapterList.ItemIndex
  end;

  // output file name
  OutputFileNameEdit.Text := ExtractFileName(ChangeFileExt(DVDFolderEdit.Text, '')) + '_title' + FloatToStr(TitlesList.ItemIndex + 1) + '_chapters' + FloatToStr(StartChaperList.ItemIndex + 1) + '-' +
    FloatToStr(EndChapterList.ItemIndex + 1);
end;

procedure TMainForm.ExchangeItems(lv: TsListView; const i, j: Integer);
var
  tempLI: TListItem;
begin
  lv.Items.BeginUpdate;
  try
    tempLI := TListItem.Create(lv.Items);
    tempLI.Assign(lv.Items.Item[i]);
    lv.Items.Item[i].Assign(lv.Items.Item[j]);
    lv.Items.Item[j].Assign(tempLI);
    tempLI.Free;
  finally
    lv.Items.EndUpdate
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin

  Application.Terminate;

end;

procedure TMainForm.ExOptionBtnClick(Sender: TObject);
begin

  AdvancedOptionsForm.Show;
  Self.Enabled := False;

end;

procedure TMainForm.FBImgClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.facebook.com/tencoder', nil, nil, SW_NORMAL);
end;

procedure TMainForm.FileListClick(Sender: TObject);
var
  i: Integer;
begin
  if FileList.ItemIndex > -1 then
  begin
    // audio tracks
    AudioTracksList.Items.Clear;
    AudioTracksList.Items.AddStrings(FMasterFileInfoList[FileList.ItemIndex].AudioTracks);
    for i := 0 to AudioTracksList.Items.Count - 1 do
    begin
      AudioTracksList.Items[i] := FloatToStr(FMasterFileInfoList[FileList.ItemIndex].AudioIDs[i]) + '. ' + AudioTracksList.Items[i]
    end;
    if FMasterFileInfoList[FileList.ItemIndex].AudioIndex < AudioTracksList.Items.Count then
    begin
      AudioTracksList.ItemIndex := FMasterFileInfoList[FileList.ItemIndex].AudioIndex;
    end;

    // subtitles
    SubtitleTracksList.Items.Clear;
    case FMasterFileInfoList[FileList.ItemIndex].SelectedSubtitleType of
      embedded:
        begin
          SubtitleTypesList.ItemIndex := 0;
          SubtitleTracksList.Items.AddStrings(FMasterFileInfoList[FileList.ItemIndex].SubtitleTracks);
          if SubtitleTracksList.Items.Count > 0 then
          begin
            SubtitleTracksList.ItemIndex := FMasterFileInfoList[FileList.ItemIndex].SubtitleTrackIndex;
          end;
        end;
      subfile:
        begin
          SubtitleTypesList.ItemIndex := 1;
          SubtitleTracksList.Items.AddStrings(FMasterFileInfoList[FileList.ItemIndex].SubtitleFiles);
          if SubtitleTracksList.Items.Count > 0 then
          begin
            SubtitleTracksList.ItemIndex := FMasterFileInfoList[FileList.ItemIndex].SubtitleIndex;
          end;
        end;
    end;
    SubtitleTypesListChange(Self);
  end
  else
  begin
    AudioTracksList.Items.Clear;
    SubtitleTracksList.Items.Clear;
  end;
end;

procedure TMainForm.FileListDblClick(Sender: TObject);
var
  Index: Integer;
  FileName: string;
begin
  Index := FileList.ItemIndex;
  if Index > -1 then
  begin
    FMPlayerPath := ExtractFileDir(Application.ExeName) + '\MEncoder\Mplayer.exe';
    if FileExists(FMPlayerPath) then
    begin
      FileName := FMasterFileInfoList[Index].FilePath;
      // pass info
      with PreviewForm do
      begin
        VideoName := FileName;
        VideoIndex := Index;
        SubIndex := FMasterFileInfoList[index].SubtitleIndex;
        AudioOnly := IsAudioOnly(FileName);
        AudioStream := FMasterFileInfoList[Index].SelectedMEncoderAudio;
      end;
      MainForm.Enabled := False;
      PreviewForm.FromMainForm := True;
      PreviewForm.PositionBar.MaxValue := FMasterFileInfoList[Index].ConstDuration;
      PreviewForm.DelaysEdit.Text := FloatToStr(MainForm.FMasterFileInfoList[Index].SubtitleDelay) + '/' + FloatToStr(MainForm.FMasterFileInfoList[Index].AudioDelay);
      PreviewForm.Caption := 'Preview [' + ExtractFileName(FileName) + ']';
      PreviewForm.Show;
    end
    else
    begin
      Application.MessageBox('Cannot find Mplayer.exe!', 'Error', MB_ICONERROR);
    end;
  end;
end;

procedure TMainForm.FileListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if FileList.Items.Count > 0 then
  begin

    if (Key = VK_UP) or (Key = VK_DOWN) then
    begin
      FileList.OnClick(Self);
    end;

  end;

end;

procedure TMainForm.FillSummary;
var
  NwNode: TTreeNode;
  SizeStr: string;
begin

  SummaryView.Items.Clear;
  with SummaryView.Items do
  begin
    NwNode := AddChild(nil, 'Video');
    if AdvancedOptionsForm.VideoSizeList.ItemIndex = 0 then
    begin
      SizeStr := ' Original '
    end
    else
    begin
      SizeStr := AdvancedOptionsForm.WidthEdit.Text + 'x' + AdvancedOptionsForm.HeightEdit.Text;
    end;
    AddChild(NwNode, 'Codec: ' + VideoEncoderList.Text);
    if (VideoEncoderList.ItemIndex = 4) and (AdvancedOptionsForm.x264Btn.Checked) and (AdvancedOptionsForm.x264CRFBtn.Checked) then
    begin
      AddChild(NwNode, 'CRF: ' + AdvancedOptionsForm.x264CRFEdit.Text);
    end
    else
    begin
      AddChild(NwNode, 'Bitrate: ' + AdvancedOptionsForm.VideobitrateList.Text + ' kbps');
    end;
    AddChild(NwNode, 'Size: ' + SizeStr);

    if (VideoEncoderList.ItemIndex = 10) then
    begin
      AddChild(NwNode, 'Codec: Direct Stream Copy');
    end
    else if (VideoEncoderList.ItemIndex = 11) then
    begin
      AddChild(NwNode, 'Method: Audio-only encoding');
    end
    else
    begin
      AddChild(NwNode, 'Aspect ratio: ' + AdvancedOptionsForm.VideoAspectRatioList.Text);
      AddChild(NwNode, 'Force aspect ratio: ' + BoolToStr(AdvancedOptionsForm.ForceASRBtn.Checked, True));
      AddChild(NwNode, 'FPS: ' + AdvancedOptionsForm.VideoFPSList.Text);
      AddChild(NwNode, 'Container: ' + ContainerList.Text);
    end;

    NwNode := AddChild(nil, 'Audio');
    if (AudioEncoderList.ItemIndex = 0) then
    begin
      AddChild(NwNode, 'Codec: Direct Stream Copy');
    end
    else if (AudioEncoderList.ItemIndex = 10) then
    begin
      AddChild(NwNode, 'Method: Video-only encoding');
    end
    else
    begin
      AddChild(NwNode, 'Codec: ' + AudioEncoderList.Text);
      if AudioEncoderList.ItemIndex <> 11 then
      begin
        AddChild(NwNode, 'Bitrate: ' + AdvancedOptionsForm.AudioBitrateList.Text + ' kbps');
        AddChild(NwNode, 'Sample rate: ' + AdvancedOptionsForm.AudioSampleRateList.Text);
        AddChild(NwNode, 'Channels: ' + AdvancedOptionsForm.AudioChannelsList.Text);
      end;
    end;

    NwNode := AddChild(nil, 'Subtitle');
    if EnableSubBtn.Checked then
    begin
      // dont show if ffmpeg is selected
      if EncoderList.ItemIndex = 0 then
      begin
        AddChild(NwNode, 'Language: ' + SettingsForm.LangIdList.Text);
        AddChild(NwNode, 'Font: ' + SettingsForm.FontList.Text);
        AddChild(NwNode, SettingsForm.AutoScaleList.Text);
        AddChild(NwNode, 'Default scale: ' + SettingsForm.DefScaleEdit.Text);
        AddChild(NwNode, 'Position: ' + SettingsForm.SubPosEdit.Text);
      end
      else
      begin
        AddChild(NwNode, 'Disabled')
      end;
    end
    else
    begin
      AddChild(NwNode, 'Disabled')
    end;
  end;
  SummaryView.FullExpand;

end;

procedure TMainForm.FormatListChange(Sender: TObject);
var
  LItemIndex: Integer;
  LTmp: TDownloadItem;
begin
  LItemIndex := (Sender as TsComboBox).Tag;
  LTmp := FDownloadItems[LItemIndex];
  LTmp.FormatIndex := (Sender as TsComboBox).ItemIndex;
  FDownloadItems[LItemIndex] := LTmp;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  CloseProcesses;
  if FDVDRipperProcess.ProcessID > 0 then
  begin
    FDVDRipperProcess.Stop;
  end;
  for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
  begin
    if FVideoDownloadProcesses[i].ProcessID > 0 then
    begin
      FVideoDownloadProcesses[i].Stop;
    end;
  end;
  for I := 0 to FVideoDownloadListItems.Count - 1 do
  begin
    FVideoDownloadListItems[i].Free;
  end;
  for I := 0 to FDownloadItems.Count - 1 do
  begin
    FDownloadItems[i].Free;
  end;

  ClearDownloadImages;
  RemoveLogs;
  SaveEncoderLogs;
  DeleteTempFiles;
  SaveOptions;
  ClearTempFolder;
  if FileExists(FTempFolder + '\dvdogg.txt') then
  begin
    DeleteFile(FTempFolder + '\dvdogg.txt')
  end;
  if DirectoryExists(Info.Folders.Temp + '\TEncoder\') then
  begin
    RemoveDir(Info.Folders.Temp + '\TEncoder\')
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AdvancedOptionsForm.SaveSettings;
  FStopAddingLink := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin

{$REGION 'file, dir checks'}
  FFFMpegPath := ExtractFileDir(Application.ExeName) + '\FFmpeg\ffmpeg.exe';
  FMencoderPath := ExtractFileDir(Application.ExeName) + '\MEncoder\Mencoder.exe';
{$IFDEF WIN64}
  FMEncoder64Path := ExtractFileDir(Application.ExeName) + '\MEncoder\MEncoder64\Mencoder.exe';
{$ELSE}
  FMEncoder64Path := FMencoderPath;
{$ENDIF}
  FMPlayerPath := ExtractFileDir(Application.ExeName) + '\MEncoder\Mplayer.exe';
  FMp4BoxPath := ExtractFileDir(Application.ExeName) + '\Mp4Box.exe';
  FMpeCreatorPath := ExtractFileDir(Application.ExeName) + '\mp4creator.exe';
  FYoutubedlPath := ExtractFileDir(Application.ExeName) + '\youtube-dl\youtube-dl.exe';
  FTempFolder := Info.Folders.Temp + '\TEncoder\';
  FRenamePath := ExtractFileDir(Application.ExeName) + '\renametool.exe';
  FDVDRenamePath := ExtractFileDir(Application.ExeName) + '\dvdrenametool.exe';

  // directory and file checks
  if not Portable then
  begin
    FAppDataFolder := Info.Folders.AppData + '\VC\';
    FMyDocFolder := Info.Folders.Personal + '\TEncoder\';
  end
  else
  begin
    FAppDataFolder := ExtractFileDir(Application.ExeName) + '\';
    FMyDocFolder := FAppDataFolder;
  end;

  FLogFolder := FAppDataFolder + '\logs\';
  if not DirectoryExists(FLogFolder) then
  begin
    ForceDirectories(FLogFolder)
  end;

  AppIniFileStorage.FileName := FAppDataFolder + 'TEncoderFormPos6.ini';

  if not FileExists(FMencoderPath) then
  begin
    Application.MessageBox('Cannot find Mencoder.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(FMPlayerPath) then
  begin
    Application.MessageBox('Cannot find Mplayer.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(FFFMpegPath) then
  begin
    Application.MessageBox('Cannot find FFMpeg.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(FMp4BoxPath) then
  begin
    Application.MessageBox('Cannot find Mp4Box.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(FYoutubedlPath) then
  begin
    Application.MessageBox('Cannot find youtube-dl.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(FRenamePath) then
  begin
    Application.MessageBox('Cannot find renametool.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(FDVDRenamePath) then
  begin
    Application.MessageBox('Cannot find dvdrenametool.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not FileExists(ExtractFileDir(Application.ExeName) + '\convert.exe') then
  begin
    Application.MessageBox('Cannot find convert.exe!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

  if not DirectoryExists(FAppDataFolder) then
  begin
    if not CreateDir(FAppDataFolder) then
    begin
      Application.MessageBox('Creating application data folder failed!', 'Fatal Error', MB_ICONERROR);
      Application.Terminate;
    end;
  end;

  if not DirectoryExists(FTempFolder) then
  begin
    if not CreateDir(FTempFolder) then
    begin
      Application.MessageBox('Creating temp failed!', 'Fatal Error', MB_ICONERROR);
      Application.Terminate;
    end;
  end;

  if not DirectoryExists(FMyDocFolder) then
  begin

    if not CreateDir(FMyDocFolder) then
    begin
      Application.MessageBox('Creating my documents folder failed!', 'Fatal Error', MB_ICONERROR);
      Application.Terminate;
    end;

  end;

  if not DirectoryExists(FAppDataFolder) then
  begin
    if not CreateDir(FAppDataFolder + 'Script\') then
    begin
      Application.MessageBox('Creating script folder failed!', 'Error', MB_ICONERROR);
    end;
  end;

  if not MediaInfoDLL_Load(ExtractFileDir(Application.ExeName) + '\MediaInfo.dll') then
  begin
    Application.MessageBox('Cannot load MediaInfo.dll!', 'Fatal Error', MB_ICONERROR);
    Application.Terminate;
  end;

{$ENDREGION}
  // default values
  FFileAddingStoppedByUser := False;
  FFileAddingStoppedByUser := False;

  for I := Low(FEncoders) to High(FEncoders) do
    FEncoders[i] := TMyProcess.Create;

  ClearTempFolder;
  FTimePassed := 0;
  FDownloadItems := TDownloadItemList.Create;
  FVideoDownloadListItems := TMyListItemList.Create;
  for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
    FVideoDownloadProcesses[i] := TDownloadProcess.Create;
  FDVDRipperProcess := TDVDRipProcess.Create;
  FDVDJobs := TDVDJobs.Create;

  FTempFilesToDelete := TStringList.Create;
  FFilesToCheck := TStringList.Create;
  FTitles := TList<TTitle>.Create;
  FMasterFileInfoList := TFileInfoList.Create;
  FFileInfo := TFileInfoExtractor.Create(FFFMpegPath, FMPlayerPath);

  AudioTracksList.Items.StrictDelimiter := True;
  AudioTracksList.Items.Delimiter := '|';
  SubtitleTracksList.Items.StrictDelimiter := True;
  SubtitleTracksList.Items.Delimiter := '|';

  FBImg.Parent := sStatusBar1;

  // windows 7 taskbar
  if CheckWin32Version(6, 1) then
  begin
    if not InitializeTaskbarAPI then
    begin
      Application.MessageBox('You seem to have Windows 7 but program can''t start taskbar progressbar!', 'Error', MB_ICONERROR);
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FreeAndNil(FTempFilesToDelete);
  FreeAndNil(FFilesToCheck);
  for I := 0 to FTitles.Count - 1 do
  begin
    FTitles[i].Free;
  end;
  FreeAndNil(FTitles);
  for I := Low(FEncoders) to High(FEncoders) do
    FEncoders[i].Free;
  FDownloadItems.Free;
  FVideoDownloadListItems.Free;
  for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
    FVideoDownloadProcesses[i].Free;
  FDVDRipperProcess.Free;
  for I := 0 to FMasterFileInfoList.Count - 1 do
    FMasterFileInfoList[i].Free;
  for I := 0 to FDVDJobs.Count - 1 do
    FDVDJobs[i].Free;
  FMasterFileInfoList.Free;
  FFileInfo.Free;
end;

procedure TMainForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if not MainSummaryList.Focused then
  begin
    if FuncPages.ActivePageIndex = 1 then
    begin
      VideoDownloaderList.Perform(WM_VSCROLL, 1, 0)
    end;
  end;
end;

procedure TMainForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if not MainSummaryList.Focused then
  begin
    if FuncPages.ActivePageIndex = 1 then
    begin
      VideoDownloaderList.Perform(WM_VSCROLL, 0, 0)
    end;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  ProgressList.Columns[0].Width := ProgressList.ClientWidth - ProgressList.Columns[1].Width - ProgressList.Columns[2].Width - 20;
  FileList.Columns[0].Width := FileList.ClientWidth - FileList.Columns[1].Width - FileList.Columns[2].Width - FileList.Columns[3].Width - 20;
  sStatusBar1.Panels[0].Width := sStatusBar1.ClientWidth - sStatusBar1.Panels[1].Width;
  DVDJobList.Columns[0].Width := DVDJobList.ClientWidth - DVDJobList.Columns[1].Width - 20;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  FilesListFile: string;
begin
  // get profiles
  LoadProfiles(ProfileList);

  // get options
  LoadOptions;

  ClearDownloadImages;

  UseSourceChkBtn.OnClick(Self);

  // load skin
  LoadSkin();

  // disable/enable
  if (VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11) then
  begin
    AdvancedOptionsForm.VideobitrateList.Enabled := False;
    AdvancedOptionsForm.VideoSizeList.Enabled := False;
    AdvancedOptionsForm.VideoFPSList.Enabled := False;
    AdvancedOptionsForm.VideoAspectRatioList.Enabled := False;
    AdvancedOptionsForm.WidthEdit.Enabled := False;
    AdvancedOptionsForm.HeightEdit.Enabled := False;
    AdvancedOptionsForm.ForceASRBtn.Enabled := False;
    AdvancedOptionsForm.VideoCBrBtn.Enabled := False;
  end
  else if (VideoEncoderList.ItemIndex = 8) or (VideoEncoderList.ItemIndex = 9) then
  begin
    AdvancedOptionsForm.VideobitrateList.Enabled := False;
    AdvancedOptionsForm.VideoSizeList.Enabled := True;
    AdvancedOptionsForm.VideoFPSList.Enabled := True;
    AdvancedOptionsForm.VideoAspectRatioList.Enabled := True;
    AdvancedOptionsForm.WidthEdit.Enabled := True;
    AdvancedOptionsForm.HeightEdit.Enabled := True;
    AdvancedOptionsForm.ForceASRBtn.Enabled := True;
    AdvancedOptionsForm.VideoCBrBtn.Enabled := True;
  end
  else
  begin
    AdvancedOptionsForm.VideobitrateList.Enabled := True;
    AdvancedOptionsForm.VideoSizeList.Enabled := True;
    AdvancedOptionsForm.VideoFPSList.Enabled := True;
    AdvancedOptionsForm.VideoAspectRatioList.Enabled := True;
    AdvancedOptionsForm.WidthEdit.Enabled := True;
    AdvancedOptionsForm.HeightEdit.Enabled := True;
    AdvancedOptionsForm.ForceASRBtn.Enabled := True;
    AdvancedOptionsForm.VideoCBrBtn.Enabled := True;
  end;

  // enable/disable
  if (AudioEncoderList.ItemIndex = 10) or (AudioEncoderList.ItemIndex = 0) then
  begin
    AdvancedOptionsForm.AudioBitrateList.Enabled := False;
    AdvancedOptionsForm.AudioSampleRateList.Enabled := False;
    AdvancedOptionsForm.AudioChannelsList.Enabled := False;
  end
  else
  begin
    AdvancedOptionsForm.AudioBitrateList.Enabled := True;
    AdvancedOptionsForm.AudioSampleRateList.Enabled := True;
    AdvancedOptionsForm.AudioChannelsList.Enabled := True;
  end;

  if AdvancedOptionsForm.VideoSizeList.ItemIndex = 0 then
  begin
    AdvancedOptionsForm.WidthEdit.Enabled := False;
    AdvancedOptionsForm.HeightEdit.Enabled := False;
  end;

  FilesListFile := ParamStr(1);
  if FileExists(FilesListFile) and (LowerCase(ExtractFileExt(FilesListFile)) = '.txt') then
  begin
    AddFilesForQueue(FilesListFile);
  end;

  if LowerCase(ParamStr(2)) = 'runasap' then
  begin
    StartBtn.OnClick(Self);
  end;
  UpdateSummary;

  AddToLog(0, 'Version: ' + AboutForm.Label2.Caption);
  AddToLog(0, 'Portable: ' + BoolToStr(Portable, True));
  AddToLog(0, 'OS: ' + Trim(Info.OS.ProductName));
  AddToLog(0, 'CPU: ' + Trim(Info.CPU.Name));
  AddToLog(0, '');

  Self.Width := Self.Width + 1;
  Self.Width := Self.Width - 1;
  Self.BringToFront;
end;

procedure TMainForm.FuncPagesChange(Sender: TObject);
begin
  if (not PositionTimer.Enabled) and (not VideoDownloaderPosTimer.Enabled) and (not DVDPosTimer.Enabled) then
  begin
    case FuncPages.ActivePageIndex of
      0: // converter
        begin
          UseSourceChkBtn.Enabled := True;
          ExportScriptBtn.Enabled := True;
          EnableSubBtn.Enabled := True;
          SubOptionsBtn.Enabled := True;
          EncoderList.Enabled := True;
        end;
      1: // downloader
        begin
          UseSourceChkBtn.Enabled := False;
          ExportScriptBtn.Enabled := False;
          EnableSubBtn.Enabled := False;
          SubOptionsBtn.Enabled := False;
          EncoderList.Enabled := False;
        end;
      2: // dvd ripper
        begin
          UseSourceChkBtn.Enabled := False;
          ExportScriptBtn.Enabled := False;
          EnableSubBtn.Enabled := False;
          SubOptionsBtn.Enabled := False;
          EncoderList.Enabled := False;
        end;
    end;
  end;
end;

procedure TMainForm.G1Click(Sender: TObject);
var
  LZip: TZipFile;
  LBMP: TBitmap;
  LJpg: TJPEGImage;
  I: integer;
begin
  LZip := TZipFile.Create;
  try
    if FileExists(Info.Folders.Desktop + '\TEncoder_log.zip') then
    begin
      DeleteFile(Info.Folders.Desktop + '\TEncoder_log.zip')
    end;

    LZip.Open(Info.Folders.Desktop + '\TEncoder_log.zip', zmWrite);

    // save logs to files
    with LogForm do
    begin
      MainLog.Lines.SaveToFile(info.Folders.Temp + '\main.txt', TEncoding.UTF8);
      for I := Low(FEncoderLogs) to High(FEncoderLogs) do
      begin
        FEncoderLogs[i].SaveToFile(Info.Folders.Temp + '\enc_log' + FloatToStr(i + 1) + '.txt', TEncoding.UTF8);
      end;
      MPlayerLogList.Lines.SaveToFile(Info.Folders.Temp + '\mplayer.txt', TEncoding.UTF8);
      OtherLog.Lines.SaveToFile(Info.Folders.Temp + '\other.txt', TEncoding.UTF8);
      DownloadLog.Lines.SaveToFile(Info.Folders.Temp + '\downloader.txt', TEncoding.UTF8);
      DVDLog.Lines.SaveToFile(Info.Folders.Temp + '\dvdlog.txt', TEncoding.UTF8);
      DVDCMDLog.Lines.SaveToFile(Info.Folders.Temp + '\dvdcmd.txt', TEncoding.UTF8);
    end;
    // save options to ini file
    SaveOptions;

    // get main form screenshot
    LBMP := TBitmap.Create;
    try
      LBMP.SetSize(ClientWidth, ClientHeight);
      BitBlt(LBMP.Canvas.Handle, 0, 0, ClientWidth, ClientHeight, Canvas.Handle, 0, 0, SRCCOPY);

      LJpg := TJPEGImage.Create;
      try
        LJpg.Assign(LBMP);
        LJpg.ProgressiveEncoding := True;
        LJpg.ProgressiveDisplay := True;
        LJpg.CompressionQuality := 85;
        LJpg.Compress;
        LJpg.SaveToFile(Info.Folders.Temp + '\ss.jpg');
      finally
        LJpg.Free;
      end;
    finally
      LBMP.Free;
    end;

    // add to zip
    LZip.Add(info.Folders.Temp + '\main.txt');
    for I := Low(LogForm.FEncoderLogs) to High(LogForm.FEncoderLogs) do
    begin
      LZip.Add(Info.Folders.Temp + '\enc_log' + FloatToStr(i + 1) + '.txt');
    end;
    LZip.Add(Info.Folders.Temp + '\mplayer.txt');
    LZip.Add(Info.Folders.Temp + '\other.txt');
    LZip.Add(Info.Folders.Temp + '\downloader.txt');
    LZip.Add(Info.Folders.Temp + '\dvdlog.txt');
    LZip.Add(Info.Folders.Temp + '\dvdcmd.txt');
    LZip.Add(FAppDataFolder + 'settings.ini');
    LZip.Add(Info.Folders.Temp + '\ss.jpg');
  finally
    FreeAndNil(LZip);

    // delete temp files
    DeleteFile(info.Folders.Temp + '\main.txt');
    for I := Low(LogForm.FEncoderLogs) to High(LogForm.FEncoderLogs) do
    begin
      DeleteFile(Info.Folders.Temp + '\enc_log' + FloatToStr(i + 1) + '.txt');
    end;
    DeleteFile(Info.Folders.Temp + '\mplayer.txt');
    DeleteFile(Info.Folders.Temp + '\other.txt');
    DeleteFile(Info.Folders.Temp + '\downloader.txt');
    DeleteFile(Info.Folders.Temp + '\dvdlog.txt');
    DeleteFile(Info.Folders.Temp + '\dvdcmd.txt');
    DeleteFile(FAppDataFolder + 'settings.ini');
    DeleteFile(Info.Folders.Temp + '\ss.jpg');

    if FileExists(Info.Folders.Desktop + '\TEncoder_log.zip') then
    begin
      Application.MessageBox('"TEncoder_log.zip" is created at your desktop.', 'Info', MB_ICONINFORMATION);
    end
    else
    begin
      Application.MessageBox('Cannot create error log. Please, errrr, report that to the author.', 'Error', MB_ICONERROR);
    end;
  end;
end;

function TMainForm.GetDurationEx(const FileName: string): integer;
var
  MediaInfoHandle: Cardinal;
  VDuration: string;
begin
  Result := 0;
  if (FileExists(FileName)) then
  begin
    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();
    if MediaInfoHandle <> 0 then
    begin
      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PwideChar(FileName));
        MediaInfo_Option(0, 'Complete', '1');
        // get length
        VDuration := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'Duration', Info_Text, Info_Name);
        if Length(VDuration) < 1 then
        begin
          if Length(Trim(VDuration)) < 1 then
          begin
            VDuration := MediaInfo_Get(MediaInfoHandle, Stream_General, 0, 'Duration', Info_Text, Info_Name);
            if Length(VDuration) < 1 then
            begin
              VDuration := '0';
            end;
          end
          else
          begin
            VDuration := '0';
          end;
        end;
        Result := StrToInt64(VDuration);
      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

function TMainForm.GetFFmpegPosition(FFmpegOutput: string; Duration: integer): string;
var
  pos1: Integer;
  pos2: Integer;
  Text: String;
  prog: String;
  last: String;
  PositionInt: Integer;
begin
  Text := FFmpegOutput;
  if Length(FFmpegOutput) > 0 then
  begin
    pos1 := Pos('time=', FFmpegOutput);
    pos2 := Pos('bitrate=', FFmpegOutput);
    prog := copy(Text, pos1 + 1, (pos2 - pos1 - 1));
    last := copy(prog, 5, Length(prog) - 4);

    PositionInt := TimeToInt(LeftBStr(Trim(last), 8));

    if Duration > 0 then
    begin
      Result := IntToStr((100 * PositionInt) div Duration);
    end;
  end;
end;

function TMainForm.GetFileDuration(VideoIndex: integer): integer;
begin
  Result := FMasterFileInfoList[VideoIndex].EndPosition - FMasterFileInfoList[VideoIndex].StartPosition;
end;

function TMainForm.GetFileFolderName(const FileName: string): string;
var
  TmpStr: string;
  i: integer;
  FolderName: string;
begin

  Result := '';

  TmpStr := ReverseString(ExtractFileDir(FileName));
  if TmpStr[1] = '\' then
  begin
    Delete(TmpStr, 1, 1);
  end;
  FolderName := '';
  for I := 1 to Length(TmpStr) do
  begin
    Application.ProcessMessages;
    if TmpStr[i] <> '\' then
    begin
      FolderName := FolderName + TmpStr[i];
    end
    else
    begin
      Break;
    end;
  end;
  if Length(FolderName) > 0 then
  begin
    Result := ReverseString(FolderName);
  end;

end;

procedure TMainForm.GetFileInfo(FileName: string);
var
  MediaInfoHandle: Cardinal;
  i: Integer;
  DotPos: Integer;
  NewItem: TListItem;
  Line: string;
begin

  if (FileExists(FileName)) then
  begin

    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();

    if MediaInfoHandle <> 0 then
    begin

      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PwideChar(FileName));
        MediaInfo_Option(0, 'Complete', '');

        InfoForm.InfoList.Text := string(MediaInfo_Inform(MediaInfoHandle, 0));

        if InfoForm.InfoList.Count > 0 then
        begin

          for I := 0 to InfoForm.InfoList.Count - 1 do
          begin
            Application.ProcessMessages;

            Line := InfoForm.InfoList.Strings[i];

            DotPos := Pos(':', Line);

            if DotPos > 0 then
            begin

              NewItem := InfoForm.Infos.Items.Add;

              with NewItem do
              begin
                Caption := copy(Line, 1, DotPos - 1);
                SubItems.Add(copy(Line, DotPos + 1, MaxInt));
              end;

            end
            else
            begin

              if Length(Line) > 0 then
              begin
                NewItem := InfoForm.Infos.Items.Add;

                with NewItem do
                begin
                  Caption := Line;
                  SubItems.Add('');
                end;

              end;

            end;

          end;

        end;

      finally
        MediaInfo_Close(MediaInfoHandle);
        // UpdateListboxScrollBox(InfoForm.InfoList);
      end;

    end;

  end;

end;

function TMainForm.GetFileSize(const FilePath: string): Int64;
var
  LFS: TFileStream;
begin
  Result := 0;
  if FileExists(FilePath) then
  begin
    try
      LFS := TFileStream.Create(FilePath, fmOpenRead and fmShareDenyNone);
      try
        try
          Result := LFS.Size;
        except
          on E: EFOpenError do
            AddToLog(0, 'Unable to check file size for ' + ExtractFileName(FilePath) + ' because it is in use.');
        end;
      finally
        LFS.Free;
      end;
    except
      on E: EFOpenError do
        AddToLog(0, 'Unable to check file size for ' + ExtractFileName(FilePath) + ' because it is in use.');
    end;
  end;
end;

function TMainForm.GetHeight(FileName: string): string;
var
  MediaInfoHandle: Cardinal;
  VWidth: string;
  VideoCount: string;
begin

  if (FileExists(FileName)) then
  begin

    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();

    if MediaInfoHandle <> 0 then
    begin

      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PwideChar(FileName));
        MediaInfo_Option(0, 'Complete', '1');

        // get length
        VWidth := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'Width', Info_Text, Info_Name);

        // get video track count
        // if zero that means audio only source
        // vduration gets to be audio duration
        VideoCount := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'StreamCount', Info_Text, Info_Name);

        if not IsStringNumeric(VideoCount) then
        begin
          VideoCount := '0';
        end;

        // if no video tracks general duration is first audio track's
        // duration
        if VideoCount = '0' then
        begin
          VWidth := '600'
        end;

        if IsStringNumeric(VWidth) then
        begin
          Result := VWidth;
        end
        else
        begin
          Result := '600';
        end;

      finally
        MediaInfo_Close(MediaInfoHandle);
      end;

    end;

  end;

end;

function TMainForm.GetMencoderPosition(MencoderOutPut: String): String;
var
  pos1: Integer;
  pos2: Integer;
  Text: String;
  prog: String;
begin
  Result := '0';
  if Length(MencoderOutPut) > 0 then
  begin
    Text := MencoderOutPut;
    pos1 := Pos('(', MencoderOutPut);
    pos2 := Pos('%', MencoderOutPut);
    prog := copy(Text, pos1 + 1, (pos2 - pos1 - 1));
    prog := Trim(prog);

    if IsStringNumeric(prog) and (prog <> '0') then
    begin
      Result := Trim(prog);
    end;
  end;
end;

function TMainForm.GetModifiedDate(const FileName: string): TDateTime;
var
  SystemTime, LocalTime: TSystemTime;
  fad: TWin32FileAttributeData;
begin
  Result := Now;
  if not GetFileAttributesEx(PChar(FileName), GetFileExInfoStandard, @fad) then
    RaiseLastOSError;
  if not FileTimeToSystemTime(fad.ftLastWriteTime, SystemTime) then
    RaiseLastOSError;
  if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
    RaiseLastOSError;
  Result := SystemTimeToDateTime(LocalTime);
end;

function TMainForm.GetMp4Progress(const Mp4Output: string): string;
const
  Line = 'ISO File Writing';
var
  LPos1, LPos2: Integer;
  LTmp: string;
begin
  Result := '0';
  if Length(Mp4Output) > 0 then
  begin
    if Line = copy(Mp4Output, 1, Length(Line)) then
    begin
      LPos1 := PosEx('| (', Mp4Output);
      LPos2 := PosEx('/100', Mp4Output);
      if LPos2 > LPos1 then
      begin
        LTmp := Trim(copy(Mp4Output, LPos1 + 3, LPos2 - LPos1 - 3));
        if IsStringNumeric(LTmp) then
        begin
          Result := LTmp
        end
        else
        begin
          Result := '0';
        end;
      end
      else
      begin
        Result := '0'
      end;
    end;
  end
  else
  begin
    Result := '0'
  end;
end;

function TMainForm.GetWidth(FileName: string): string;
var
  MediaInfoHandle: Cardinal;
  VHeight: string;
  VideoCount: string;
begin

  if (FileExists(FileName)) then
  begin

    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();

    if MediaInfoHandle <> 0 then
    begin

      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PwideChar(FileName));
        MediaInfo_Option(0, 'Complete', '1');

        // get length
        VHeight := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'Height', Info_Text, Info_Name);

        // get video track count
        // if zero that means audio only source
        // vduration gets to be audio duration
        VideoCount := MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'StreamCount', Info_Text, Info_Name);

        if not IsStringNumeric(VideoCount) then
        begin
          VideoCount := '0';
        end;

        // if no video tracks general duration is first audio track's
        // duration
        if VideoCount = '0' then
        begin
          VHeight := '292'
        end;

        if IsStringNumeric(VHeight) then
        begin
          Result := VHeight
        end
        else
        begin
          Result := '292';
        end;

      finally
        MediaInfo_Close(MediaInfoHandle);
      end;

    end;

  end;

end;

function TMainForm.HasAudio(const FileName: string): Boolean;
var
  MediaInfoHandle: Cardinal;
  LAudioCount: string;
  LAudioCountInt: Integer;
begin
  Result := False;
  if (FileExists(FileName)) then
  begin
    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();
    if MediaInfoHandle <> 0 then
    begin
      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PwideChar(FileName));
        MediaInfo_Option(0, 'Complete', '1');

        // get length
        LAudioCount := MediaInfo_Get(MediaInfoHandle, Stream_Audio, 0, 'Count', Info_Text, Info_Name);

        if Length(LAudioCount) > 0 then
        begin
          if TryStrToInt(LAudioCount, LAudioCountInt) then
          begin
            if LAudioCountInt > 0 then
            begin
              Result := True;
            end;
          end;
        end;
      finally
        MediaInfo_Close(MediaInfoHandle);
      end;
    end;
  end;
end;

procedure TMainForm.HomepageBtnClick(Sender: TObject);
const
  NewLine = '%0D%0A';
var
  mail: PChar;
  mailbody: string;
begin

  mailbody := AboutForm.Label2.Caption + NewLine + NewLine + 'Bugs: ' + NewLine + NewLine + NewLine + 'Suggestions: ' + NewLine + NewLine + NewLine;
  mail := PwideChar('mailto:ozok26@gmail.com?subject=TEncoder&body=' + mailbody);

  ShellExecute(0, 'open', mail, nil, nil, SW_SHOWNORMAL);

end;

procedure TMainForm.I1Click(Sender: TObject);
begin
  ImageAudiotoVideoForm.Show;
end;

function TMainForm.IntegerToTime(Time: Integer): string;
var
  hour: Integer;
  second: Integer;
  minute: Integer;
  strhour: string;
  strminute: string;
  strsecond: String;
begin

  if (Time > 0) then
  begin

    hour := Time div 3600;
    minute := (Time div 60) - (hour * 60);
    second := (Time mod 60);

    if (second < 10) then
    begin
      strsecond := '0' + FloatToStr(second);
    end
    else
    begin
      strsecond := FloatToStr(second);
    end;

    if (minute < 10) then
    begin
      strminute := '0' + FloatToStr(minute);
    end
    else
    begin
      strminute := FloatToStr(minute);
    end;

    if (hour < 10) then
    begin
      strhour := '0' + FloatToStr(hour);
    end
    else
    begin
      strhour := FloatToStr(hour);
    end;

    Result := strhour + ':' + strminute + ':' + strsecond;
  end
  else
  begin
    Result := '00:00:00';
  end;

end;

function TMainForm.IsAudioOnly(const FileName: string): Boolean;
var
  MediaInfoHandle: Cardinal;
  VideoCount: string;
begin

  Result := False;

  if (FileExists(FileName)) then
  begin

    // New handle for mediainfo
    MediaInfoHandle := MediaInfo_New();

    if MediaInfoHandle <> 0 then
    begin

      try
        // Open a file in complete mode
        MediaInfo_Open(MediaInfoHandle, PwideChar(FileName));
        MediaInfo_Option(0, 'Complete', '1');

        VideoCount := Trim(MediaInfo_Get(MediaInfoHandle, Stream_Video, 0, 'Count', Info_Text, Info_Name));

        if IsStringNumeric(VideoCount) then
        begin
          if StrToInt(VideoCount) > 0 then
          begin
            Result := False;
          end
          else
          begin
            Result := True;
          end;
        end
        else
        begin
          Result := True;
        end;

      finally
        MediaInfo_Close(MediaInfoHandle);
      end;

    end;

  end;

end;

function TMainForm.IsStringNumeric(Str: String): Boolean;
var
  P: PChar;
begin

  if Length(Str) < 1 then
  begin
    Result := False;
    Exit;
  end;

  P := PChar(Str);
  Result := False;

  while P^ <> #0 do
  begin
    Application.ProcessMessages;

    if (Not CharInSet(P^, ['0' .. '9'])) then
    begin
      Exit;
    end;

    Inc(P);
  end;

  Result := True;
end;

procedure TMainForm.LabelClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PwideChar(TsLabel(Sender).Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.LinkEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    AddSingleLinkBtnClick(Self);
  end;
end;

procedure TMainForm.LoadOptions;
var
  OptionFile: TIniFile;
begin

  OptionFile := TIniFile.Create(FAppDataFolder + 'Settings.ini');
  try

    with OptionFile do
    begin
      VideoEncoderList.ItemIndex := ReadInteger('Options', 'VEncoder', 2);

      ContainerList.ItemIndex := ReadInteger('Options', 'Container', 0);

      AudioEncoderList.ItemIndex := ReadInteger('Options', 'AEncoder', 1);

      EnableSubBtn.Checked := ReadBool('Options', 'Sub', True);
      ExportScriptBtn.Checked := ReadBool('Options', 'Script', False);
      DoTwoPassBtn.Checked := ReadBool('Options', 'TwoPass', False);

      DirectoryEdit.Text := ReadString('Options', 'Out', FMyDocFolder);
      FLastOpenedDir := ReadString('Options', 'LastDir', Info.Folders.Personal);

      EncoderList.ItemIndex := ReadInteger('Options', 'Encoder', 0);
      ProfileList.ItemIndex := ReadInteger('Options', 'Profile', -1);

      UseSourceChkBtn.Checked := ReadBool('Options', 'Source', False);
      rim1.Enabled := not ReadBool('options', 'trim', True);
      T2.Enabled := not ReadBool('options', 'trim', True);

      ConvertDownloadedBtn.Checked := ReadBool('options', 'convertdownloaded', True);

      FuncPages.ActivePageIndex := ReadInteger('options', 'func', 0);
      PostEncodeList3.ItemIndex := ReadInteger('dvd', 'postencode', 0);

      if ReadBool('Options', 'Update', True) then
      begin
        CheckUpdateThread.Execute(nil);
      end;
    end;

  finally
    OptionFile.Free;
    FuncPagesChange(Self);
  end;
end;

procedure TMainForm.LoadProfiles(ProfilesList: TsComboBox);
var
  lSearchRec: TSearchRec;
begin

  if DirectoryExists(ExtractFileDir(Application.ExeName) + '\Profiles') then
  begin

    ProfilesList.Items.Clear;

    // search for built in profiles
    if (FindFirst(ExtractFileDir(Application.ExeName) + '\Profiles\*.pdo', faAnyFile, lSearchRec) = 0) then
    Begin
      repeat
        Application.ProcessMessages;
        ProfilesList.Items.Add(ChangeFileExt(lSearchRec.Name, ''));
      until (FindNext(lSearchRec) <> 0);
      FindClose(lSearchRec);
    end;

    // search for user created profiles
    if (FindFirst(FAppDataFolder + '\*.pdo', faAnyFile, lSearchRec) = 0) then
    Begin
      repeat
        Application.ProcessMessages;
        ProfilesList.Items.Add(ChangeFileExt(lSearchRec.Name, ''));
      until (FindNext(lSearchRec) <> 0);
      FindClose(lSearchRec);
    end;

  end
  else
  begin
    Application.MessageBox('Cannot load profiles!', 'Error', MB_ICONERROR);
  end;

end;

procedure TMainForm.LoadSkin;
var
  IniFile: TIniFile;
  SkinIndex: Integer;
  SkinName: string;
  Saturation: Integer;
  Hue: Integer;
  i: integer;
begin

  { Load skin using info from settings file }
  if not SettingsForm.SkinEnableBtn.Checked then
  begin

    IniFile := TIniFile.Create(FAppDataFolder + 'Settings.ini');
    try
      SkinIndex := IniFile.ReadInteger('Options', 'Skins2', 92);
      Saturation := IniFile.ReadInteger('Options', 'Sat', 0);
      Hue := IniFile.ReadInteger('Options', 'Hue', 0);

      if (SkinIndex > sSkinManager1.InternalSkins.Count) or (SkinIndex < 0) then
      begin
        SkinIndex := 16;
      end;

      SkinName := sSkinManager1.InternalSkins.Items[SkinIndex].Name;

      sSkinManager1.SkinName := SkinName;
      // sSkinManager1.RepaintForms(True);
      sSkinManager1.Saturation := Saturation;
      sSkinManager1.HueOffset := Hue;

    finally
      IniFile.Free;
    end;

    for I := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TJvSpinEdit then
      begin
        (Self.Components[i] as TJvSpinEdit).Color := DirectoryEdit.Color;
        (Self.Components[i] as TJvSpinEdit).Font := DirectoryEdit.Font;
      end;
    end;
  end
  else
  begin
    sSkinManager1.Active := False;
  end;

end;

procedure TMainForm.M2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('https://sourceforge.net/p/tencoder/feature-requests/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.MenuState(const _Enabled: Boolean);
var
  I: Integer;
begin
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := _Enabled;
  end;
  if _Enabled then
  begin
    VideoAddingForm.VideoAddBar.Style := pbstNormal;
  end
  else
  begin
    VideoAddingForm.VideoAddBar.Style := pbstMarquee;
  end;
end;

procedure TMainForm.NewProfileBtnClick(Sender: TObject);
begin

  ProfileForm.Show;
  MainForm.Enabled := False;

end;

procedure TMainForm.OpenDirectory1Click(Sender: TObject);
var
  FileDir: string;
  index: Integer;
begin
  index := FileList.ItemIndex;
  if index > -1 then
  begin
    FileDir := ExtractFileDir(FMasterFileInfoList[Index].FilePath);
    if DirectoryExists(FileDir) then
    begin
      ShellExecute(Handle, 'open', 'explorer', PChar(' /n,/select, ' + '"' + FMasterFileInfoList[Index].FilePath + '"'), nil, SW_SHOWNORMAL);
    end;
  end;
end;

procedure TMainForm.OpenDVDBtnClick(Sender: TObject);
begin
  if SelectDirectoryDialog.Execute then
  begin
    DVDFolderEdit.Text := SelectDirectoryDialog.Directory;
    ReadDVDBtnClick(Self);
  end;
end;

procedure TMainForm.OpenOutDirBtn2Click(Sender: TObject);
begin

  OpenOutDirBtn.OnClick(Self);

end;

procedure TMainForm.OpenOutDirBtnClick(Sender: TObject);
begin

  if (DirectoryExists(DirectoryEdit.Text)) then
  begin
    ShellExecute(Application.Handle, 'open', PChar(DirectoryEdit.Text), nil, nil, SW_SHOWNORMAL);
  end
  else
  begin
    Application.MessageBox('Cannot open output folder because it does not exist!', 'Error', MB_ICONERROR);
  end;

end;

procedure TMainForm.PassBtnClick(Sender: TObject);
begin
  if PassPnl.Visible then
  begin
    // hide
    PassPnl.Visible := False;
    PassBtn.Down := False;
  end
  else
  begin
    // show
    PassPnl.Visible := True;
    PassBtn.Down := True;
  end;
end;

procedure TMainForm.PositionTimerTimer(Sender: TObject);
var
  DoneSoFar: integer;
  i: integer;
  LMissingFileList: TStringList;
begin

  // calculate files done so far
  DoneSoFar := 0;
  for I := Low(FEncoders) to High(FEncoders) do
  begin
    if FEncoders[i].CommandCount > 0 then
    begin
      DoneSoFar := DoneSoFar + FEncoders[i].FilesDone;
    end;
  end;
  // finished
  if DoneSoFar = FConverterTotalCMDCount then
  begin
    SwitchToNormal;
    DeleteTempFiles;
    WriteOutputFileDates;
    StartBtn.Enabled := True;
    PositionTimer.Enabled := False;
    Self.Caption := 'TEncoder';
    SetProgressValue(Handle, 0, MaxInt);

    if SettingsForm.PlaySoundBtn.Checked then
    begin
      if FileExists(ExtractFileDir(Application.ExeName) + '\done.wav') then
      begin
        sndPlaySound('done.wav', SND_ASYNC);
      end;
    end;
    AddToLog(0, 'Encoding took ' + IntegerToTime(FTimePassed) + '.');
    AddToLog(0, '');

    // post-encode action
    case PostEncodeList.ItemIndex of
      0:
        begin
          // check output files
          LMissingFileList := TStringList.Create;
          try
            if CheckOutputFiles(LMissingFileList) then
            begin
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder failed to convert ' + FloatToStr(LMissingFileList.Count) + ' files. Please check logs.', btError, 5000, True);
            end
            else
            begin
              AddToLog(0, 'TEncoder could locate all output files.');
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder finished converting your files.', btInfo, 5000, True);
            end;
            if Self.Visible = False then
            begin
              TrayIcon.ShowApplication;
            end;
            TrayIcon.Hint := '';
          finally
            LMissingFileList.Free;
          end;
          SaveOptions;
        end;
      1:
        begin
          SaveOptions;
          Application.Terminate;
        end;
      2:
        begin
          SaveOptions;
          // check output files
          LMissingFileList := TStringList.Create;
          try
            if CheckOutputFiles(LMissingFileList) then
            begin
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder failed to convert ' + FloatToStr(LMissingFileList.Count) + ' files. Please check logs.', btError, 5000, True);
            end
            else
            begin
              AddToLog(0, 'TEncoder could locate all output files.');
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder finished converting your files.', btInfo, 5000, True);
            end;
            if Self.Visible = False then
            begin
              TrayIcon.ShowApplication;
            end;
            TrayIcon.Hint := '';
          finally
            LMissingFileList.Free;
          end;
          if not UseSourceChkBtn.Checked then
          begin
            if (DirectoryExists(DirectoryEdit.Text)) then
            begin
              ShellExecute(Application.Handle, 'open', PChar(DirectoryEdit.Text), nil, nil, SW_SHOWNORMAL);
            end
            else
            begin
              Application.MessageBox('Cannot open output folder because it does not exist!', 'Error', MB_ICONERROR);
            end;
          end;
        end;
      3:
        begin
          SaveOptions;
          ShutDown(EWX_SHUTDOWN or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
      4:
        begin
          SaveOptions;
          ShutDown(EWX_REBOOT or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
      5:
        begin
          SaveOptions;
          ShutDown(EWX_LOGOFF or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
    end;
  end
  else
  begin
    SetProgressValue(Handle, TotalProgress.Position, TotalProgress.Max);
    TrayIcon.Hint := FloatToStr((TotalProgress.Position * 100) div TotalProgress.Max) + '%';
  end;

end;

procedure TMainForm.VideoDownloaderPosTimerTimer(Sender: TObject);
var
  LTotalFilesDone: integer;
  I: Integer;
  LMissingFileList: TStringList;
begin
  LTotalFilesDone := 0;
  for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
  begin
    if FVideoDownloadProcesses[i].CommandCount > 0 then
    begin
      Inc(LTotalFilesDone, FVideoDownloadProcesses[i].FilesDone);
    end;
  end;

  if LTotalFilesDone = FVideoDownloadTotalCMDCount then
  begin
    VideoDownloaderPosTimer.Enabled := False;
    // TimeTimer.Enabled := False;
    ClearTempFolderEx(True);
    DownloadNormalState;
    if SettingsForm.PlaySoundBtn.Checked then
    begin
      if FileExists(ExtractFileDir(Application.ExeName) + '\done.wav') then
      begin
        sndPlaySound('done.wav', SND_ASYNC);
      end;
    end;
    // save logs
    SaveDownloadLogs;
    AddToLog(0, 'Downloading took ' + IntegerToTime(FTimePassed) + '.');
    AddToLog(0, '');

    // post-encode action
    case PostEncodeList2.ItemIndex of
      0:
        begin
          // check output files
          LMissingFileList := TStringList.Create;
          try
            if CheckOutputFiles(LMissingFileList) then
            begin
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder failed to download ' + FloatToStr(LMissingFileList.Count) + ' files. Please check logs.', btError, 5000, True);
            end
            else
            begin
              AddToLog(0, 'TEncoder could locate all output files.');
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder finished downloading.', btInfo, 5000, True);
            end;
            TrayIcon.ShowApplication;
          finally
            LMissingFileList.Free;
          end;
          SaveOptions;
        end;
      1:
        begin
          SaveOptions;
          Application.Terminate;
        end;
      2:
        begin
          SaveOptions;
          // check output files
          LMissingFileList := TStringList.Create;
          try
            if CheckOutputFiles(LMissingFileList) then
            begin
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder failed to download ' + FloatToStr(LMissingFileList.Count) + ' files. Please check logs.', btError, 5000, True);
            end
            else
            begin
              AddToLog(0, 'TEncoder could locate all output files.');
              TrayIcon.Active := True;
              TrayIcon.BalloonHint('TEncoder', 'TEncoder finished downloading.', btInfo, 5000, True);
            end;
            TrayIcon.ShowApplication;
          finally
            LMissingFileList.Free;
          end;
          if not UseSourceChkBtn.Checked then
          begin
            if (DirectoryExists(DirectoryEdit.Text)) then
            begin
              ShellExecute(Application.Handle, 'open', PChar(DirectoryEdit.Text), nil, nil, SW_SHOWNORMAL);
            end
            else
            begin
              Application.MessageBox('Cannot open output folder because it does not exist!', 'Error', MB_ICONERROR);
            end;
          end;
        end;
      3:
        begin
          SaveOptions;
          ShutDown(EWX_SHUTDOWN or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
      4:
        begin
          SaveOptions;
          ShutDown(EWX_REBOOT or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
      5:
        begin
          SaveOptions;
          ShutDown(EWX_LOGOFF or EWX_FORCE or EWX_FORCEIFHUNG);
        end;
    end;
  end
  else
  begin
    TotalProgress.Max := FVideoDownloadTotalCMDCount + FSkippedVideoCount;
    TotalBar.Position := LTotalFilesDone + FSkippedVideoCount;
    VideoDownloaderProgressLabel.Caption := 'Progress: ' + FloatToStr(LTotalFilesDone + FSkippedVideoCount) + '/' + FloatToStr(FVideoDownloadTotalCMDCount + FSkippedVideoCount);
    if FVideoDownloadTotalCMDCount > 0 then
    begin
      MainForm.Caption := FloatToStr((100 * (LTotalFilesDone + FSkippedVideoCount)) div (FVideoDownloadTotalCMDCount + FSkippedVideoCount)) + '% TEncoder';
      SetProgressValue(Handle, LTotalFilesDone + FSkippedVideoCount, FVideoDownloadTotalCMDCount + FSkippedVideoCount);
    end;
  end;
end;

procedure TMainForm.ProfileListChange(Sender: TObject);
var
  ProfileText: string;
begin

  // apply selected profile
  // exit;
  ProfileText := ProfileList.Text;

  if Length(ProfileText) > 0 then
  begin
    ApplyProfile(ProfileText);
  end;
  UpdateSummary;

end;

procedure TMainForm.Properties1Click(Sender: TObject);
var
  Index: Integer;
  FileName: string;
begin
  Index := FileList.ItemIndex;
  if Index > -1 then
  begin
    FileName := FMasterFileInfoList[Index].FilePath;
    try
      GetFileInfo(FileName);
    finally
      InfoForm.Show;
      MainForm.Enabled := False;
    end;
  end;
end;

procedure TMainForm.R1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('https://sourceforge.net/p/tencoder/bugs/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.ReadDVDBtnClick(Sender: TObject);
var
  LDTE: TDVDTitleCountExtractor;
  LDE: TDVDTitleInfoExtractor;
  I: Integer;
begin
  if DirectoryExists(DVDFolderEdit.Text) then
  begin
    // reset all
    FTitles.Clear;
    TitlesList.Items.Clear;
    DVDAudioTracksList.Items.Clear;
    DVDSubtitleTracksList.Items.Clear;
    FCurrentTitle := nil;
    OutputFileNameEdit.Text := '';

    LDTE := TDVDTitleCountExtractor.Create(DVDFolderEdit.Text, FMPlayerPath);
    DVDLoadPnl.Caption := 'Reading title count';
    DVDLoadPnl.Left := (ClientWidth div 2) - (DVDLoadPnl.Width div 2);
    DVDLoadPnl.Top := (ClientHeight div 2) - (DVDLoadPnl.Height div 2);
    DVDLoadPnl.Visible := True;
    ProgressBar1.Style := pbstMarquee;
    DVDLoadPnl.BringToFront;
    Self.Enabled := False;
    try
      // get title count
      LDTE.Start;
      while LDTE.Status = fsReading do
      begin
        Application.ProcessMessages;
        Sleep(10);
      end;
      // get audio&sub for each title
      if LDTE.TitleCount > 0 then
      begin
        for I := 1 to LDTE.TitleCount do
        begin
          Application.ProcessMessages;
          DVDLoadPnl.Caption := 'Reading title ' + FloatToStr(i) + '/' + FloatToStr(LDTE.TitleCount);
          LDE := TDVDTitleInfoExtractor.Create(DVDFolderEdit.Text, FMPlayerPath, I);
          try
            LDE.Start;
            while LDE.Status = fsReading do
            begin
              Application.ProcessMessages;
              Sleep(10);
            end;
          finally
            // add to titles
            FTitles.Add(LDE.Title);
            LDE.Free;
          end;
        end;
      end;

      // fill lists
      if FTitles.Count > 0 then
      begin
        for I := 0 to FTitles.Count - 1 do
        begin
          TitlesList.Items.Add('Title ' + FloatToStr(i + 1) + ', Duration: ' + FTitles[i].DurationFormatedStr);
        end;
        TitlesList.ItemIndex := 0;
        FCurrentTitle := FTitles[0];
        TitlesListChange(Self);

        // output file name
        OutputFileNameEdit.Text := ExtractFileName(ChangeFileExt(DVDFolderEdit.Text, '')) + '_title' + FloatToStr(TitlesList.ItemIndex + 1) + '_chapters' + FloatToStr(StartChaperList.ItemIndex + 1) +
          '-' + FloatToStr(EndChapterList.ItemIndex + 1);
      end;
    finally
      LDTE.Free;
      DVDLoadPnl.Visible := False;
      ProgressBar1.Style := pbstNormal;
      Self.Enabled := True;
      TitlesList.Refresh;
      DVDAudioTracksList.Refresh;
      DVDSubtitleTracksList.Refresh;
    end;
  end
  else
  begin
    Application.MessageBox('Selected DVD folder doesn''t exist.', 'Error', MB_ICONERROR)
  end;
end;

function TMainForm.ReadFileDate(const FileName: string): TFileDatePair;
var
  LSearch: TSearchRec;
begin
  Result.CreateDate := Now;
  Result.ModifiedDate := Now;
  if FindFirst(FileName, faAnyFile, LSearch) >= 0 then
  begin
    Result.CreateDate := LSearch.TimeStamp;
  end;
  FindClose(LSearch);
  Result.ModifiedDate := GetModifiedDate(FileName);
end;

procedure TMainForm.RemoveAllBtnClick(Sender: TObject);
begin
  if ID_YES = Application.MessageBox('Remove all from file list?', 'Remove All', MB_ICONQUESTION or MB_YESNO) then
  begin
    FileList.Items.Clear;
    FMasterFileInfoList.Clear;
    AudioTracksList.Items.Clear;
    SubtitleTracksList.Items.Clear;
  end;
end;

procedure TMainForm.RemoveBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := FileList.Items.Count - 1 downto 0 do
  begin
    if FileList.Items[i].Selected then
    begin
      FileList.Items.Delete(i);
      FMasterFileInfoList.Delete(i);
    end;
  end;
  FileList.OnClick(Self);
end;

procedure TMainForm.RemoveLogs;
var
  Search: TSearchRec;
begin
  if (FindFirst(FAppDataFolder + '\*.log', faAnyFile, Search) = 0) then
  Begin
    repeat
      Application.ProcessMessages;
      DeleteFile(FAppDataFolder + '\' + Search.Name);
    until (FindNext(Search) <> 0);
    FindClose(Search);
  end;
end;

procedure TMainForm.ReverseSelection1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FileList.Items.Count - 1 do
  begin
    FileList.Items[i].Selected := not FileList.Items[i].Selected;
  end;
end;

procedure TMainForm.S3Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://rg3.github.io/youtube-dl/supportedsites.html'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.SaveDownloadLogs;
var
  LStreamWriter: TStreamWriter;
  i: integer;
  j: Integer;
  LContinue: Boolean;
begin

  LContinue := True;
  if not DirectoryExists(FLogFolder) then
  begin
    if not ForceDirectories(FLogFolder) then
    begin
      LContinue := False;
    end;
  end;
  if LContinue then
  begin
    for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
    begin
      Application.ProcessMessages;
      LStreamWriter := TStreamWriter.Create(FLogFolder + '\' + FloatToStr(i + 1) + 'log.txt', False, TEncoding.UTF8);
      try
        for j := 0 to FVideoDownloadProcesses[i].GetConsoleOutput.Count - 1 do
        begin
          Application.ProcessMessages;
          LStreamWriter.WriteLine(FVideoDownloadProcesses[i].GetConsoleOutput[j]);
        end;
      finally
        LStreamWriter.Close;
        LStreamWriter.Free;
      end;
    end;
  end;
end;

procedure TMainForm.SaveEncoderLogs;
var
  LContinue: Boolean;
  i: integer;
begin
  with LogForm do
  begin
    LContinue := True;
    if not DirectoryExists(FLogFolder) then
    begin
      if not ForceDirectories(FLogFolder) then
      begin
        LContinue := False;
      end;
    end;
    if LContinue then
    begin
      for I := Low(FEncoderLogs) to High(FEncoderLogs) do
      begin
        FEncoderLogs[i].SaveToFile(Info.Folders.Temp + '\Encoder' + FloatToStr(i + 1) + '.txt');
      end;
    end;
  end;
end;

procedure TMainForm.SaveOptions;
var
  OptionFile: TIniFile;
begin

  OptionFile := TIniFile.Create(FAppDataFolder + 'Settings.ini');
  try

    with OptionFile do
    begin
      WriteInteger('Options', 'VEncoder', VideoEncoderList.ItemIndex);

      WriteInteger('Options', 'AEncoder', AudioEncoderList.ItemIndex);

      WriteInteger('Options', 'Container', ContainerList.ItemIndex);

      WriteBool('Options', 'Sub', EnableSubBtn.Checked);
      WriteBool('Options', 'Script', ExportScriptBtn.Checked);
      WriteBool('Options', 'TwoPass', DoTwoPassBtn.Checked);

      WriteString('Options', 'Out', DirectoryEdit.Text);
      WriteString('Options', 'LastDir', FLastOpenedDir);
      WriteInteger('Options', 'Encoder', EncoderList.ItemIndex);
      WriteInteger('Options', 'Profile', ProfileList.ItemIndex);
      WriteBool('Options', 'Source', UseSourceChkBtn.Checked);

      WriteBool('options', 'convertdownloaded', ConvertDownloadedBtn.Checked);

      WriteInteger('options', 'func', FuncPages.ActivePageIndex);
      WriteInteger('dvd', 'postencode', PostEncodeList3.ItemIndex);
    end;

  finally
    OptionFile.Free
  end;

end;

procedure TMainForm.LogsBtnClick(Sender: TObject);
begin
  LogForm.Show;
end;

procedure TMainForm.sBitBtn2Click(Sender: TObject);
begin
  SettingsForm.SettingsList.ActivePageIndex := 1;
  SettingsForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.SubOptionsBtnClick(Sender: TObject);
begin
  SettingsForm.SettingsList.ActivePageIndex := 1;
  SettingsForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.OpenScriptDirBtnClick(Sender: TObject);
var
  ScriptDir: string;
begin

  ScriptDir := FAppDataFolder + 'Script\';

  if not DirectoryExists(ScriptDir) then
  begin

    if not CreateDir(ScriptDir) then
    begin
      Application.MessageBox('Cannot find or create script folder!', 'Error', MB_ICONERROR);
    end;

  end;

  ShellExecute(Handle, 'open', PChar(ScriptDir), nil, nil, SW_SHOWNORMAL);

end;

procedure TMainForm.OpenScriptFolderBtnClick(Sender: TObject);
var
  ScriptDir: string;
begin

  ScriptDir := FAppDataFolder + 'Script\';

  if not DirectoryExists(ScriptDir) then
  begin

    if not CreateDir(ScriptDir) then
    begin
      Application.MessageBox('Cannot find or create script folder!', 'Error', MB_ICONERROR);
    end;

  end;

  ShellExecute(Handle, 'open', PChar(ScriptDir), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.SearchVideoFindFile(Sender: TObject; const AName: string);
begin

  AddForm.StatusLabel.Caption := ExtractFileName(AName);
  AddFile(AName);

end;

procedure TMainForm.SearchVideoProgress(Sender: TObject);
begin

  Application.ProcessMessages;

end;

procedure TMainForm.SeeChangeLog1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar(ExtractFileDir(Application.ExeName) + '\ChangeLog.txt'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.SelectAll1Click(Sender: TObject);
begin

  FileList.SelectAll;

end;

procedure TMainForm.SelectBtnClick(Sender: TObject);
begin

  if DirectoryExists(DirectoryEdit.Text) then
  begin
    SelectDirectoryDialog.Directory := DirectoryEdit.Text;
  end;

  if SelectDirectoryDialog.Execute then
  begin
    DirectoryEdit.Text := SelectDirectoryDialog.Directory;
  end;

end;

procedure TMainForm.SelectNone1Click(Sender: TObject);
var
  i: Integer;
begin

  for i := 0 to FileList.Items.Count - 1 do
  begin
    FileList.Items[i].Selected := False;
  end;

end;

procedure TMainForm.SetFileCreationTime(const FileName: string; const DateTime: TFileDatePair);
var
  Handle: THandle;
  SystemTime: TSystemTime;
  FileTime: TFileTime;
begin
  Handle := CreateFile(PChar(FileName), FILE_WRITE_ATTRIBUTES, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if Handle = INVALID_HANDLE_VALUE then
    RaiseLastOSError;
  try

    DateTimeToSystemTime(TTimeZone.Local.ToUniversalTime(DateTime.CreateDate), SystemTime);
    if not SystemTimeToFileTime(SystemTime, FileTime) then
      RaiseLastOSError;
    if not SetFileTime(Handle, @FileTime, nil, nil) then
      RaiseLastOSError;
  finally
    CloseHandle(Handle);
  end;
  FileSetDate(FileName, DateTimeToFileDate(DateTime.ModifiedDate));
end;

procedure TMainForm.SetPaused;
begin
  SetProgressState(Handle, tbpsPaused)
end;

procedure TMainForm.SetPlaying;
begin
  SetProgressState(Handle, tbpsNormal)
end;

procedure TMainForm.SetPreviewProgress(const Progress, Total: integer);
begin
  SetProgressValue(Handle, Progress, Total);
end;

function TMainForm.ShutDown(RebootParam: Longword): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := Sizeof(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        AdjustTokenPrivileges(TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;

procedure TMainForm.sLabelFX1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://www.fosshub.com/TAudioConverter.html'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.sLabelFX2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://sourceforge.net/projects/instagramsaver/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.sLabelFX3Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('https://sourceforge.net/projects/tebookconverter/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.sStatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel = sStatusBar1.Panels[1] then
  begin
    with FBImg do
    begin
      Top := Rect.Top;
      Left := Rect.Left;
      Width := Rect.Right - Rect.Left - 15;
      Height := Rect.Bottom - Rect.Top;
    end;
  end;
end;

procedure TMainForm.StartBtnClick(Sender: TObject);
var
  i: Integer;
  Date: TDateTime;
  ScriptFile: TStringList;
  NumberOfProcesses: integer;
  j: Integer;
begin

{$REGION 'codec checks'}
  // if none is selected as both video and audio codec
  if (VideoEncoderList.ItemIndex = 11) and (AudioEncoderList.ItemIndex = 10) then
  begin
    Application.MessageBox('Please select at a video or audio codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // mencoder does not support speex encoding
  if (AudioEncoderList.ItemIndex = 8) and (EncoderList.ItemIndex = 0) then
  begin
    Application.MessageBox('Mencoder does not support encoding audio with Speex codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // mencoder does not support opus encoding
  if (AudioEncoderList.ItemIndex = 9) and (EncoderList.ItemIndex = 0) then
  begin
    Application.MessageBox('Mencoder does not support encoding audio with Opus codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // mencoder does not support prores encoding
  if (VideoEncoderList.ItemIndex = 9) and (EncoderList.ItemIndex = 0) then
  begin
    Application.MessageBox('Mencoder does not support encoding video with ProRes codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // mencoder does not support x265 encoding
  if (VideoEncoderList.ItemIndex = 12) and (EncoderList.ItemIndex = 0) then
  begin
    Application.MessageBox('Mencoder does not support encoding video with x265 codec!', 'Error', MB_ICONERROR);
    Exit;
  end;

  // speex sample rate limit
  if (AudioEncoderList.ItemIndex = 8) and ((AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 0) and (AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 2) and
    (AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 4) and (AdvancedOptionsForm.AudioSampleRateList.ItemIndex <> 7)) then
  begin
    Application.MessageBox('Selected sample rate is not supported by Speex! Speex supports 8000Hz, 16000Hz and 32000Hz sampling rates.', 'Error', MB_ICONERROR);
    Exit;
  end;

  // check if given birate values are valid
  if (VideoEncoderList.ItemIndex <> 9) and (VideoEncoderList.ItemIndex <> 10) then
  begin
    if not IsStringNumeric(AdvancedOptionsForm.VideobitrateList.Text) then
    begin
      Application.MessageBox('Please enter a valid video bitrate value!', 'Error', MB_ICONERROR);
    end;
  end;
  if (AudioEncoderList.ItemIndex <> 9) and (AudioEncoderList.ItemIndex <> 0) then
  begin
    if not IsStringNumeric(AdvancedOptionsForm.AudioBitrateList.Text) then
    begin
      Application.MessageBox('Please enter a valid audio bitrate value!', 'Error', MB_ICONERROR);
    end;
  end;
  // crf and two pass wont work
  if (VideoEncoderList.ItemIndex = 4) and (AdvancedOptionsForm.x264Btn.Checked) and (AdvancedOptionsForm.x264CRFBtn.Checked) and (DoTwoPassBtn.Checked) then
  begin
    Application.MessageBox('CRF is incompatible with two pass!', 'Warning', MB_ICONWARNING);
    Exit;
  end;

  // for audio mode,
  // ffmpeg is best encoder
  // no two passes
  if VideoEncoderList.ItemIndex = 11 then
  begin
    EncoderList.ItemIndex := 1;
    DoTwoPassBtn.Checked := False;
  end;

  // for video copy use ffmpeg
  // no two pass
  if VideoEncoderList.ItemIndex = 10 then
  begin
    EncoderList.ItemIndex := 1;
    DoTwoPassBtn.Checked := False;
  end;

  // try to create scripts folder
  if not DirectoryExists(FAppDataFolder + '\Script\') then
  begin
    ForceDirectories(FAppDataFolder + '\Script\')
  end;

  // audio copy
  // ffmpeg
  if (AudioEncoderList.ItemIndex = 0) and (EncoderList.ItemIndex = 0) then
  begin
    if not(ID_YES = Application.MessageBox('Directly copying audio stream only works with FFMpeg. Do you want to change encoder to it?', 'Audio direct copy', MB_ICONQUESTION or MB_YESNO)) then
    begin
      Exit;
    end
    else
    begin
      EncoderList.ItemIndex := 1;
    end;
  end;
{$ENDREGION}
  // remove files that dont exist
  for i := FileList.Items.Count - 1 downto 0 do
  begin
    if not FileExists(FMasterFileInfoList[I].FilePath) then
    begin
      AddToLog(0, 'Removing ' + FMasterFileInfoList[I].FilePath + ' from list, because it does not exist.');
      FileList.Items.Delete(i);
      FMasterFileInfoList.Delete(i);
    end;
  end;

  // vp8 & mencoder & two pass
  if DoTwoPassBtn.Checked and (VideoEncoderList.ItemIndex = 7) and (EncoderList.ItemIndex = 0) then
  begin
    if ID_YES = Application.MessageBox('Two pass VP8 encoding with Mencoder is problematic at the moment. Would you like to do a single pass?', 'Warning', MB_ICONWARNING or MB_YESNO) then
    begin
      DoTwoPassBtn.Checked := False;
    end;
  end;

  // vp8 ogg vorbis webm
  if (VideoEncoderList.ItemIndex = 7) and ((AudioEncoderList.ItemIndex <> 3) or (ContainerList.ItemIndex <> 7)) then
  begin
    Application.MessageBox('VP8 video codec works with only OggVorbis as audio codec and Webm as container.', 'Error', MB_ICONERROR);
    Exit;
  end;

  // create log folder
  ForceDirectories(FLogFolder);

  if (FileList.Items.Count > 0) and (Length(DirectoryEdit.Text) > 0) then
  begin

    if Not DirectoryExists(DirectoryEdit.Text) then
    begin
      if not CreateDir(DirectoryEdit.Text) then
      begin
        Application.MessageBox('Can''t create output folder!', 'Error', MB_ICONERROR);
      end;
    end;

    // ffmpeg and subtitle
    if (EncoderList.ItemIndex = 1) and EnableSubBtn.Checked then
    begin
      if ID_YES = Application.MessageBox
        ('You enabled subtitles but selected FFmpeg as encoder. FFmpeg cannot hard-code subtitles to videos. Mencoder can do that. Change encoder to Mencoder from FFmpeg?',
        'Subtitles, FFmpeg and Mencoder', MB_ICONQUESTION or MB_YESNO) then
      begin
        EncoderList.ItemIndex := 0;
      end;
    end;

    AddForm.StatusLabel.Caption := 'Creating command lines...';
    AddForm.AbortBtn.Enabled := False;
    AddForm.Show;
    MainForm.Enabled := False;
    try

      // reset
      TotalProgress.Position := 0;
      TrayIcon.Active := False;
      DeleteTempFiles;
      FTempFilesToDelete.Clear;
      ProgressList.Items.Clear;
      for i := low(FProgressStrs) to High(FProgressStrs) do
      begin
        FProgressStrs[i] := '';
      end;
      FFileAddingStoppedByUser := False;
      for I := Low(FEncoders) to High(FEncoders) do
        FEncoders[i].ResetValues;
      FTimePassed := 0;
      FFilesToCheck.Clear;

      // decide number of processes
      if (SettingsForm.NumberOfThreadsList.ItemIndex + 1) > FileList.Items.Count then
      begin
        NumberOfProcesses := FileList.Items.Count;
      end
      else
      begin
        NumberOfProcesses := SettingsForm.NumberOfThreadsList.ItemIndex + 1;
      end;
      if NumberOfProcesses > Info.CPU.ProcessorCount then
      begin
        AddToLog(0, '[Warning] Number of parallel processes is greater than CPU core count.');
      end;
      FEncodeProcessCount := NumberOfProcesses;
      // if video codec is x264 and user wants to run single ffmpeg instance
      if (VideoEncoderList.ItemIndex = 4) then
      begin
        If SettingsForm.x264Btn.Checked Then
        begin
          NumberOfProcesses := 1;
        end;
      end;

      FConstEncoderIndex := EncoderList.ItemIndex;
      FConstTwoPassMode := DoTwoPassBtn.Checked;
      // add commands
      for I := 0 to FileList.Items.Count - 1 do
      begin
        Application.ProcessMessages;

        CreateEncodingCommands(i, (i mod NumberOfProcesses));
      end;

      FConverterTotalCMDCount := 0;
      for I := Low(FEncoders) to High(FEncoders) do
        inc(FConverterTotalCMDCount, FEncoders[i].CommandCount);

      TotalProgress.Max := 100;
      FillSummary;
      // FillProgressList;
      if FConverterTotalCMDCount > 0 then
      begin
        if LogForm.MainLog.Lines.Count > 0 then
        begin
          AddToLog(0, '');
        end;
        for I := Low(FEncoders) to High(FEncoders) do
        begin
          if FEncoders[i].CommandCount > 0 then
          begin
            AddToLog(0, 'Starting process ' + FloatToStr(i) + ' with ' + FloatToStr(FEncoders[i].CommandCount) + ' command lines.');
            FEncoders[i].Start;
          end;
        end;
        Self.Caption := '0% TEncoder';
        TotalProgress.Max := FConverterTotalCMDCount;
        TrayIcon.Active := True;
      end;

    finally

      // save script
      if ExportScriptBtn.Checked then
      begin
        Date := Now;

        ScriptFile := TStringList.Create;
        try

          case EncoderList.ItemIndex of
            0: // mencoder
              begin

                for i := Low(FEncoders) to High(FEncoders) do
                begin
                  Application.ProcessMessages;

                  if FEncoders[i].CommandCount > 0 then
                  begin
                    for j := 0 to FEncoders[i].CommandCount - 1 do
                    begin
                      ScriptFile.Add('"' + FEncoders[i].EncodeJobs[j].ProcessPath + '" ' + FEncoders[i].EncodeJobs[j].CommandLine);
                    end;
                  end;

                end;

                ScriptFile.SaveToFile(FAppDataFolder + 'Script\(Mencoder)' + CorrectFileName(DateTimeToStr(Date)) + '.bat');
              end;
            1: // ffmpeg
              begin

                for i := Low(FEncoders) to High(FEncoders) do
                begin
                  Application.ProcessMessages;

                  if FEncoders[i].CommandCount > 0 then
                  begin
                    for j := 0 to FEncoders[i].CommandCount - 1 do
                    begin
                      ScriptFile.Add('"' + FEncoders[i].EncodeJobs[j].ProcessPath + '" ' + FEncoders[i].EncodeJobs[j].CommandLine);
                    end;
                  end;
                end;

                ScriptFile.SaveToFile(FAppDataFolder + 'Script\(FFMpeg)' + CorrectFileName(DateTimeToStr(Date)) + '.bat');
              end;
          end;

        finally
          FreeAndNil(ScriptFile);
        end;

      end;

      AddForm.AbortBtn.Enabled := True;
      AddForm.Close;
      PositionTimer.Enabled := True;
      Timer.Enabled := True;
      SwitchToEncoding();

      ProgressLabel.Caption := '0/' + IntToStr(FConverterTotalCMDCount);
    end;
  end;
end;

procedure TMainForm.StartChaperListChange(Sender: TObject);
begin
  if EndChapterList.ItemIndex < StartChaperList.ItemIndex then
  begin
    EndChapterList.ItemIndex := StartChaperList.ItemIndex
  end;

  // output file name
  OutputFileNameEdit.Text := ExtractFileName(ChangeFileExt(DVDFolderEdit.Text, '')) + '_title' + FloatToStr(TitlesList.ItemIndex + 1) + '_chapters' + FloatToStr(StartChaperList.ItemIndex + 1) + '-' +
    FloatToStr(EndChapterList.ItemIndex + 1);
end;

procedure TMainForm.StartDownloadBtnClick(Sender: TObject);
var
  i: Integer;
  LSelectedFormatStr: string;
  LStreamWriter: TStreamWriter;
  j: Integer;
  LDownloadedVideoName: string;
  LCMD: string;
  LDownloadSub: Boolean;
  LRenameFile: TStringList;
  LOutputFile: string;
  // LFileNameExtractor: TFileNameExtractor;
  LDASHAudioExt: string;
  LDASHAudioCode: string;
  LDASHVideoExt: string;
  LPos1: integer;
  LPass: string;
begin
  if FVideoDownloadListItems.Count > 0 then
  begin
    AddForm.StatusLabel.Caption := 'Creating command lines...';
    AddForm.AbortBtn.Enabled := False;
    AddForm.Show;
    MainForm.Enabled := False;
    try
      LRenameFile := TStringList.Create;
      try
{$REGION 'Dir checks block'}
        if not DirectoryExists(DirectoryEdit.Text) then
        begin
          if ForceDirectories(DirectoryEdit.Text) then
          begin
            if not(ForceDirectories(ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\Downloaded')) then
            begin
              Application.MessageBox('Cannot create output folder.', 'Error', MB_ICONERROR);
              Exit;
            end;
            if not CreateDir(ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\Converted') then
            begin
              Application.MessageBox('Cannot create output folder.', 'Error', MB_ICONERROR);
              Exit;
            end;
          end
          else
          begin
            Application.MessageBox('Cannot create output folder.', 'Error', MB_ICONERROR);
            Exit;
          end;
        end;
{$ENDREGION}
{$REGION 'reset block'}
        // reset
        for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
        begin
          FVideoDownloadProcesses[i].ResetValues;
          FProgressStrs[i] := '';
        end;
        for I := 0 to FVideoDownloadListItems.Count - 1 do
        begin
          FVideoDownloadListItems[i].ProgressLabel.Caption := 'Waiting...';
        end;
        FVideoDownloadTotalCMDCount := 0;
        FVideoDownloaderTime := 0;
        // remove cmd log from last time
        if FileExists(FLogFolder + '\cmd.txt') then
        begin
          DeleteFile(FLogFolder + '\cmd.txt')
        end;
        FSkippedVideoCount := 0;
{$ENDREGION}
        if ((AudioEncoderList.ItemIndex = 10) and (VideoEncoderList.ItemIndex = 11)) or ((AudioEncoderList.ItemIndex = 0) and ((VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11)))
        then
        begin
          AddToLog(0, 'Skipping downloaded video encoding. Selected audio and video codec combination cannot be used.');
        end;
        // create command line
        for i := 0 to FVideoDownloadListItems.Count - 1 do
        begin
          Application.ProcessMessages;
          // reset it for each file
          LRenameFile.Clear;

          LDownloadedVideoName := FVideoDownloadListItems[i].FileNameLabel.Caption;
          if SettingsForm.DashVideoBtn.Checked then
          begin
            if ContainsText(LSelectedFormatStr, 'DASH, video') then
            begin
              LDownloadedVideoName := CreateTempName;
            end;
          end;
          // get file name
          LPos1 := PosEx(',', FVideoDownloadListItems[i].FormatList.Text);
          if LPos1 > 1 then
          begin
            LOutputFile := FVideoDownloadListItems[i].FileNameLabel.Caption + '.' + LowerCase(copy(FVideoDownloadListItems[i].FormatList.Text, 1, LPos1 - 1));
          end;
          // don't download twice
          if SettingsForm.DontDoubleDownloadBtn.Checked then
          begin
            if FileExists(DirectoryEdit.Text + '\Downloaded\' + LOutputFile) then
            begin
              if HasAudio(DirectoryEdit.Text + '\Downloaded\' + LOutputFile) then
              begin
                AddToLog(0, 'Ignoring "' + LOutputFile + '" because it contains audio.');
                FVideoDownloadListItems[i].ProgressLabel.Caption := 'Already downloaded';
                FVideoDownloadListItems[i].ProgressBar.Position := 100;
                Inc(FSkippedVideoCount);
                Continue;
              end;
            end;
          end;
          if (Length(UserEdit.Text) > 0) and (Length(PassEdit.Text) > 0) then
          begin
            LPass := ' -u ' + UserEdit.Text + ' -p ' + PassEdit.Text;
          end;
          // youtube-dl command line
          case FDownloadItems[i].LinkType of
            general:
              begin
                LCMD := ' ' + LPass + ' -o "' + ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\Downloaded\%(uploader)s - %(title)s.%(ext)s" -i --no-playlist -f ' +
                  FDownloadItems[i].FormatIntegers[FDownloadItems[i].FormatIndex];
              end;
            soundcloud:
              begin
                LCMD := ' ' + LPass + ' -o "' + ExcludeTrailingPathDelimiter(DirectoryEdit.Text) + '\Downloaded\%(uploader)s - %(title)s.%(ext)s" -i --no-playlist -x --audio-format ' +
                  FDownloadItems[i].FormatIntegers[FDownloadItems[i].FormatIndex];
              end;
          end;
          LDownloadSub := False;
          if FDownloadItems[i].SubIndex > 0 then
          begin
            LCMD := LCMD + ' --write-sub --sub-lang ' + LowerCase(FVideoDownloadListItems[i].SubtitleList.Text);
            LDownloadSub := True;
          end;
          LCMD := LCMD + ' -v -c -w ' + FVideoDownloadListItems[i].LinkLabel.Caption;
          FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add(LCMD);
          FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('5');
          FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add(FYoutubedlPath);
          FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
          FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Downloading]');
          Inc(FVideoDownloadTotalCMDCount);
          // if dash video selected
          // detect if selected format is indeed dash video only
          LSelectedFormatStr := FVideoDownloadListItems[i].FormatList.Text;
          if SettingsForm.DashVideoBtn.Checked and ContainsText(LSelectedFormatStr, 'DASH, video') then
          begin
            // audio extension and code
            LDASHAudioExt := VideoTypeToAudio(LSelectedFormatStr);
            LDASHVideoExt := VideoTypeToVideo(LSelectedFormatStr);
            LDASHAudioCode := VideoTypeToAudioCode(LSelectedFormatStr);
            // get audio
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add(' -o "' + ExcludeTrailingPathDelimiter(DirectoryEdit.Text) +
              '\Downloaded\%(uploader)s - %(title)s.%(ext)s" -i --no-playlist -f ' + LDASHAudioCode + ' -c -w ' + FVideoDownloadListItems[i].LinkLabel.Caption);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('5');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add(FYoutubedlPath);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Downloading]');
            Inc(FVideoDownloadTotalCMDCount);
            // mux both into video file
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add(' -y -i "' + DirectoryEdit.Text + '\Downloaded\' + FVideoDownloadListItems[i].FileNameLabel.Caption +
              LDASHVideoExt + '" -i "' + DirectoryEdit.Text + '\Downloaded\' + FVideoDownloadListItems[i].FileNameLabel.Caption + LDASHAudioExt + '" -c:a copy -c:v copy "' + DirectoryEdit.Text +
              '\Downloaded\' + FVideoDownloadListItems[i].FileNameLabel.Caption + '_muxed' + LDASHVideoExt + '"');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add(FFFMpegPath);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Muxing]');
            Inc(FVideoDownloadTotalCMDCount);
            // delete downloaded video and audio files
            // rename muxed video to normal
            LRenameFile.Add(DirectoryEdit.Text + '\Downloaded\' + FVideoDownloadListItems[i].FileNameLabel.Caption + LDASHAudioExt);
            LRenameFile.Add(DirectoryEdit.Text + '\Downloaded\' + LOutputFile);
            LRenameFile.Add(DirectoryEdit.Text + '\Downloaded\' + FVideoDownloadListItems[i].FileNameLabel.Caption + '_muxed' + LDASHVideoExt);
            LRenameFile.SaveToFile(FTempFolder + '\' + FloatToStr(i) + '.txt', TEncoding.UTF8);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add('"' + FRenamePath + '" "' + FTempFolder + '\' + FloatToStr(i) + '.txt"');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('6');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add('');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Renaming]');
            Inc(FVideoDownloadTotalCMDCount);
          end;
          // file check
          FFilesToCheck.Add(DirectoryEdit.Text + '\Downloaded\' + LOutputFile);

          // convert
          if ConvertDownloadedBtn.Checked then
          begin
            if not(((AudioEncoderList.ItemIndex = 10) and (VideoEncoderList.ItemIndex = 11)) or
              ((AudioEncoderList.ItemIndex = 0) and ((VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11)))) then
            begin
              LCMD := CreateDownloadConvertCMD(DirectoryEdit.Text + '\Downloaded\' + LOutputFile);
              FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add(LCMD);
              FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('7');
              FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add(FFFMpegPath);
              FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
              FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Converting]');
              Inc(FVideoDownloadTotalCMDCount);
            end;
          end;

          // remux dash m4a to mp4 audio
          if ContainsText(LSelectedFormatStr, 'M4A, AUDIO, ONLY, DASH') then
          begin
            LCMD := ' -add "' + DirectoryEdit.Text + '\Downloaded\' + LOutputFile + '" -new "' + DirectoryEdit.Text + '\Downloaded\' + LOutputFile + '"';
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add(LCMD);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('1');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add(FMp4BoxPath);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Remuxing]');
            Inc(FVideoDownloadTotalCMDCount);
          end;

          // extract ogg file from webm
          if ContainsText(LSelectedFormatStr, 'WEBM, AUDIO, ONLY, DASH') then
          begin
            LCMD := ' -y -i "' + DirectoryEdit.Text + '\Downloaded\' + LOutputFile + '" -vn -f ogg "' + DirectoryEdit.Text + '\Downloaded\' + ChangeFileExt(LOutputFile, '.ogg') + '"';
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].CommandLines.Add(LCMD);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].ProcessTypes.Add('1');
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].EncoderPaths.Add(FFFMpegPath);
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].FileIndexes.Add(FloatToStr(i));
            FVideoDownloadProcesses[i mod SettingsForm.ProcessCountBar.Position].Infos.Add('[Extracting audio]');
            Inc(FVideoDownloadTotalCMDCount);
            FFilesToCheck.Add(DirectoryEdit.Text + '\Downloaded\' + ChangeFileExt(LOutputFile, '.ogg'));
          end;
        end;

        // add commands to log
        with LogForm.DownloadLog do
        begin
          Lines.Clear;
          for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
          begin
            Lines.Add('Command lines' + FloatToStr(i + 1) + ':');
            Lines.AddStrings(FVideoDownloadProcesses[i].CommandLines);
          end;
        end;

        AddToLog(0, 'Ignoring ' + FloatToStr(FSkippedVideoCount) + ' files.');

        // start downloading
        if FVideoDownloadTotalCMDCount > 0 then
        begin
          // write commands to text file
          if FileExists(FLogFolder + '\cmd.txt') then
          begin
            DeleteFile(FLogFolder + '\cmd.txt')
          end;
          for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
          begin
            Application.ProcessMessages;
            LStreamWriter := TStreamWriter.Create(FLogFolder + '\cmd.txt', True, TEncoding.UTF8);
            try
              LStreamWriter.WriteLine('Download process' + FloatToStr(i + 1) + ': ');
              for j := 0 to FVideoDownloadProcesses[i].CommandLines.Count - 1 do
              begin
                Application.ProcessMessages;
                LStreamWriter.WriteLine(FVideoDownloadProcesses[i].CommandLines[j]);
              end;
            finally
              LStreamWriter.Close;
              LStreamWriter.Free;
            end;
          end;
          TotalBar.Max := FVideoDownloadTotalCMDCount + FSkippedVideoCount;
          for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
          begin
            if FVideoDownloadProcesses[i].CommandCount > 0 then
            begin
              FVideoDownloadProcesses[i].Start;
            end;
          end;
          VideoDownloaderPosTimer.Enabled := True;
          Timer.Enabled := True;
          TrayIcon.Active := True;
          DownloadState();
          SetProgressState(Handle, tbpsNormal);
        end
        else
        begin
          Application.MessageBox('Did not create any commands. Perhaps you already downloaded all videos? Check logs pls.', 'Info', MB_ICONINFORMATION);
        end;
      finally
        LRenameFile.Free;
      end;
    finally
      AddForm.AbortBtn.Enabled := True;
      AddForm.Close;
      Self.Enabled := True;
    end;
  end
  else
  begin
    Application.MessageBox('Please add links first.', 'Error', MB_ICONERROR);
  end;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
begin
  if ID_YES = Application.MessageBox('Stop encoding process?', 'Confirm', MB_ICONQUESTION or MB_YESNO) then
  begin
    PositionTimer.Enabled := False;

    CloseProcesses();
    DeleteTempFiles;

    StartBtn.Enabled := True;
    // todo: save logs properly. like in tac
    SwitchToNormal;
    Self.Caption := 'TEncoder';
    SetProgressValue(Handle, 0, MaxInt);
    AddToLog(0, 'Encoding stopped by user.');
    AddToLog(0, '');
    TrayIcon.Hint := '';
    TrayIcon.Active := False;
  end;
end;

procedure TMainForm.StopDownloadBtnClick(Sender: TObject);
var
  i: integer;
begin
  if ID_YES = Application.MessageBox('Stop downloading?', 'Stop', MB_ICONQUESTION or MB_YESNO) then
  begin
    VideoDownloaderPosTimer.Enabled := False;
    // TimeTimer.Enabled := False;
    for I := Low(FVideoDownloadProcesses) to High(FVideoDownloadProcesses) do
      FVideoDownloadProcesses[i].Stop;
    ClearTempFolderEx(True);
    DownloadNormalState;
  end;
end;

procedure TMainForm.SubListChange(Sender: TObject);
var
  LItemIndex: Integer;
  LTmp: TDownloadItem;
begin
  LItemIndex := (Sender as TsComboBox).Tag;
  LTmp := FDownloadItems[LItemIndex];
  LTmp.SubIndex := (Sender as TsComboBox).ItemIndex;
  FDownloadItems[LItemIndex] := LTmp;
end;

procedure TMainForm.SubSettingsBtnClick(Sender: TObject);
begin

  AdvancedOptionsForm.Show;
  MainForm.Enabled := False;

end;

procedure TMainForm.SubtitleOptions1Click(Sender: TObject);
begin

  FileList.SelectAll;

end;

procedure TMainForm.SubtitleOptions2Click(Sender: TObject);
begin
  SettingsForm.Show;
  MainForm.Enabled := False;
end;

procedure TMainForm.SubtitleTracksListChange(Sender: TObject);
var
  index: Integer;
begin
  index := FileList.ItemIndex;
  if index > -1 then
  begin
    case SubtitleTypesList.ItemIndex of
      0: // embedded
        begin
          if SubtitleTracksList.Items.Count > 0 then
          begin
            FMasterFileInfoList[index].SubtitleTrackIndex := SubtitleTracksList.ItemIndex;
          end
          else
          begin
            FMasterFileInfoList[index].SubtitleTrackIndex := -1;
          end;
        end;
      1: // sub file
        begin
          if SubtitleTracksList.Items.Count > 0 then
          begin
            FMasterFileInfoList[index].SubtitleIndex := SubtitleTracksList.ItemIndex;
          end
          else
          begin
            FMasterFileInfoList[index].SubtitleIndex := -1;
          end;
        end;
    end;
  end;
end;

procedure TMainForm.SubtitleTypesListChange(Sender: TObject);
var
  LConvertItem: TFileInfoItem;
begin
  if FileList.ItemIndex > -1 then
  begin
    LConvertItem := FMasterFileInfoList[FileList.ItemIndex];
    SubtitleTracksList.Items.Clear;
    case SubtitleTypesList.ItemIndex of
      0: // embedded
        begin
          SubtitleTracksList.Items.AddStrings(LConvertItem.SubtitleTracks);
          SubtitleTracksList.ItemIndex := LConvertItem.SubtitleTrackIndex;
          LConvertItem.SelectedSubtitleType := embedded;
        end;
      1: // files
        begin
          SubtitleTracksList.Items.AddStrings(LConvertItem.SubtitleFiles);
          SubtitleTracksList.ItemIndex := LConvertItem.SubtitleIndex;
          LConvertItem.SelectedSubtitleType := subfile;
        end;
    end;
    FMasterFileInfoList[FileList.ItemIndex] := LConvertItem;
  end;
end;

procedure TMainForm.SwitchToEncoding;
var
  i: integer;
begin
  ConvertingPanel.Visible := True;
  ConvertingPanel.BringToFront;
  NormalPanel.Visible := False;
  NormalPanel.SendToBack;
  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := False;
  end;
  MainForm.Height := MainForm.Height + 1;
  MainForm.Height := MainForm.Height - 1;
end;

procedure TMainForm.SwitchToNormal;
var
  i: integer;
begin
  ConvertingPanel.Visible := False;
  ConvertingPanel.SendToBack;
  NormalPanel.Visible := True;
  NormalPanel.BringToFront;

  for I := 0 to MainMenu1.Items.Count - 1 do
  begin
    MainMenu1.Items[i].Enabled := True;
  end;
  TotalProgress.Position := 0;
  ProgressLabel.Caption := '0/0';

  SettingsForm.PostEncodeActionList.ItemIndex := PostEncodeList.ItemIndex;
  FuncPagesChange(Self);
end;

function TMainForm.ThreadCMD(const EncoderIndex: integer): string;
var
  NumberOfCores: Integer; // system value
  NumberOfThreads: Integer; // resultant value
  NumberOfSelectedThreads: Integer;
begin
  case EncoderIndex of
    0:
      Result := '';
    1:
      Result := ' ';
  end;
  NumberOfCores := Info.CPU.ProcessorCount;
  NumberOfSelectedThreads := SettingsForm.NumberOfThreadsList.ItemIndex + 1;
  if FileList.Items.Count >= NumberOfCores then
  begin
    // if user selected less then available cores
    if NumberOfCores > NumberOfSelectedThreads then
    begin
      if NumberOfSelectedThreads < 0 then
        NumberOfSelectedThreads := 1;
      NumberOfThreads := NumberOfCores div NumberOfSelectedThreads;
      if NumberOfThreads > 1 then
      begin
        case EncoderIndex of
          0: // mencoder
            begin
              Result := ':threads=' + IntToStr(NumberOfThreads);
            end;
          1: // ffmpeg
            begin
              Result := ' -threads ' + IntToStr(NumberOfThreads) + ' ';
            end;
        end;
      end;
    end;
  end
  else
  begin
    if (FileList.Items.Count < NumberOfCores) then
    begin
      NumberOfThreads := NumberOfCores div FileList.Items.Count;
      if NumberOfThreads > 1 then
      begin
        // in any case
        if NumberOfThreads > 8 then
        begin
          NumberOfThreads := 8;
        end;
        case EncoderIndex of
          0: // mencoder
            begin
              Result := ':threads=' + IntToStr(NumberOfThreads);
            end;
          1: // ffmpeg
            begin
              Result := ' -threads ' + IntToStr(NumberOfThreads) + ' ';
            end;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  Inc(FTimePassed);
  if PositionTimer.Enabled then
  begin
    TimeLabel.Caption := IntegerToTime(FTimePassed);
  end;
end;

function TMainForm.TimeToInt(TimeStr: string): Integer;
var
  TimeList: TStringList;
  hour: Integer;
  minute: Integer;
  second: Integer;
begin

  Result := 0;

  if Length(TimeStr) = 8 then
  begin

    TimeList := TStringList.Create;
    try
      TimeList.Delimiter := ':';
      TimeList.StrictDelimiter := True;
      TimeList.DelimitedText := TimeStr;

      hour := 0;
      minute := 0;
      second := 0;

      if TimeList.Count = 3 then
      begin

        if IsStringNumeric(TimeList[0]) then
        begin
          hour := StrToInt(TimeList[0]);
        end;

        if IsStringNumeric(TimeList[1]) then
        begin
          minute := StrToInt(TimeList[1]);
        end;

        if IsStringNumeric(TimeList[2]) then
        begin
          second := StrToInt(TimeList[2]);
        end;

        Result := (hour * 3600) + (minute * 60) + second;

      end;

    finally
      FreeAndNil(TimeList);
    end;

  end;

end;

procedure TMainForm.TitlesListChange(Sender: TObject);
var
  i: Integer;
begin
  if TitlesList.ItemIndex > -1 then
  begin
    FCurrentTitle := FTitles[TitlesList.ItemIndex];

    // load audio streams
    DVDAudioTracksList.Items.Clear;
    for I := 0 to FCurrentTitle.AudioStreams.Count - 1 do
    begin
      DVDAudioTracksList.Items.Add(FCurrentTitle.AudioStreams[i].ID + ', ' + FCurrentTitle.AudioStreams[i].Name);
    end;
    if DVDAudioTracksList.Items.Count > 0 then
    begin
      DVDAudioTracksList.ItemIndex := 0;
    end;

    // load audio streams
    DVDSubtitleTracksList.Items.Clear;
    for I := 0 to FCurrentTitle.SubtitleStreams.Count - 1 do
    begin
      DVDSubtitleTracksList.Items.Add(FCurrentTitle.SubtitleStreams[i].ID + ', ' + FCurrentTitle.SubtitleStreams[i].Name);
    end;
    if DVDSubtitleTracksList.Items.Count > 0 then
    begin
      DVDSubtitleTracksList.ItemIndex := 0;
    end;

    // chapters
    StartChaperList.Items.Clear;
    EndChapterList.Items.Clear;
    for I := 0 to FCurrentTitle.Chapters.Count - 1 do
    begin
      StartChaperList.Items.Add(FloatToStr(i + 1) + ', ' + FCurrentTitle.Chapters[i]);
      EndChapterList.Items.Add(FloatToStr(i + 1) + ', ' + FCurrentTitle.Chapters[i]);
    end;
    if StartChaperList.Items.Count > 0 then
    begin
      StartChaperList.ItemIndex := 0;
    end;
    EndChapterList.ItemIndex := EndChapterList.Items.Count - 1;

    DVDAudioTracksList.Refresh;
    DVDSubtitleTracksList.Refresh;
    // output file name
    OutputFileNameEdit.Text := ExtractFileName(ChangeFileExt(DVDFolderEdit.Text, '')) + '_title' + FloatToStr(TitlesList.ItemIndex + 1) + '_chapters' + FloatToStr(StartChaperList.ItemIndex + 1) + '-'
      + FloatToStr(EndChapterList.ItemIndex + 1);
  end;
end;

procedure TMainForm.ToolsBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := ToolsBtn.ClientToScreen(Point(0, 0));

  ToolsMenu.Popup(P.X, P.Y + ToolsBtn.Height)
end;

procedure TMainForm.TrayBtnClick(Sender: TObject);
begin
  TrayIcon.HideApplication;
end;

procedure TMainForm.TrayIconBalloonClick(Sender: TObject);
begin
  TrayIcon.ShowApplication;
  TrayIcon.Active := False;
end;

procedure TMainForm.U1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar(ExtractFileDir(Application.ExeName) + '\youtube-dl\youtube-dl.exe'), '-U', nil, SW_SHOWNORMAL);
end;

procedure TMainForm.UpBtnClick(Sender: TObject);
var
  i: Integer;
  lv, lv2: TListItem;
begin
  for i := 0 to FileList.Items.Count - 1 do
  begin
    Application.ProcessMessages;
    if FileList.Items.Item[i].Selected then
    begin
      if i > 0 then
      begin
        lv2 := FileList.Items[i];
        try
          lv := FileList.Items.Insert(i - 1);
          lv.Assign(lv2);
          lv2.Delete;
          FMasterFileInfoList.Exchange(i, i - 1);
        finally
          lv.Selected := True;
          lv.Focused := True;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.UpdateCheckerDoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
var
  VersionFile: TStringList;
  LatestVersion: Integer;
begin
  VersionFile := TStringList.Create;
  try
    VersionFile.LoadFromStream(Stream);
    if VersionFile.Count = 1 then
    begin
      if MainForm.IsStringNumeric(VersionFile.Strings[0]) then
      begin
        LatestVersion := StrToInt(VersionFile.Strings[0]);
        if LatestVersion > Build then
        begin
          if ID_YES = Application.MessageBox('There is a new version. Would you like to download it?', 'New Version', MB_ICONQUESTION or MB_YESNO) then
          begin
            ShellExecute(0, 'open', 'http://www.fosshub.com/TEncoder-Video-Converter.html', nil, nil, SW_SHOWNORMAL);
          end;

        end;
      end;
    end;
  finally
    FreeAndNil(VersionFile);
  end;
end;

procedure TMainForm.UpdateProgress;
begin
  TotalProgress.Position := TotalProgress.Position + 1;
  ProgressLabel.Caption := FloatToStr(TotalProgress.Position) + '/' + FloatToStr(FConverterTotalCMDCount);
  Self.Caption := FloatToStr((100 * TotalProgress.Position) div TotalProgress.Max) + '% TEncoder';
end;

procedure TMainForm.UpdateSummary;
var
  NwNode: TTreeNode;
  SizeStr: string;
begin

  MainSummaryList.Items.Clear;
  with MainSummaryList.Items do
  begin
    NwNode := AddChild(nil, 'Video');
    if AdvancedOptionsForm.VideoSizeList.ItemIndex = 0 then
    begin
      SizeStr := ' Original '
    end
    else
    begin
      SizeStr := AdvancedOptionsForm.WidthEdit.Text + 'x' + AdvancedOptionsForm.HeightEdit.Text;
    end;
    AddChild(NwNode, 'Codec: ' + VideoEncoderList.Text);
    if (VideoEncoderList.ItemIndex <> 10) and (VideoEncoderList.ItemIndex <> 11) then
    begin
      if (VideoEncoderList.ItemIndex = 4) and (AdvancedOptionsForm.x264Btn.Checked) and (AdvancedOptionsForm.x264CRFBtn.Checked) then
      begin
        AddChild(NwNode, 'CRF: ' + AdvancedOptionsForm.x264CRFEdit.Text);
      end
      else
      begin
        AddChild(NwNode, 'Bitrate: ' + AdvancedOptionsForm.VideobitrateList.Text + ' kbps');
      end;
      AddChild(NwNode, 'Size: ' + SizeStr);
    end;

    if (VideoEncoderList.ItemIndex = 11) then
    begin
      AddChild(NwNode, 'Method: Audio-only encoding');
    end
    else if (VideoEncoderList.ItemIndex <> 10) then
    begin
      AddChild(NwNode, 'Aspect ratio: ' + AdvancedOptionsForm.VideoAspectRatioList.Text);
      AddChild(NwNode, 'Force aspect ratio: ' + BoolToStr(AdvancedOptionsForm.ForceASRBtn.Checked, True));
      AddChild(NwNode, 'FPS: ' + AdvancedOptionsForm.VideoFPSList.Text);
      AddChild(NwNode, 'Container: ' + ContainerList.Text);
    end;

    NwNode := AddChild(nil, 'Audio');
    if (AudioEncoderList.ItemIndex = 0) then
    begin
      AddChild(NwNode, 'Codec: Direct Stream Copy');
    end
    else if (AudioEncoderList.ItemIndex = 10) then
    begin
      AddChild(NwNode, 'Method: Video-only encoding');
    end
    else
    begin
      AddChild(NwNode, 'Codec: ' + AudioEncoderList.Text);
      // flac
      if AudioEncoderList.ItemIndex <> 11 then
      begin
        AddChild(NwNode, 'Bitrate: ' + AdvancedOptionsForm.AudioBitrateList.Text + ' kbps');
        AddChild(NwNode, 'Sample rate: ' + AdvancedOptionsForm.AudioSampleRateList.Text);
        AddChild(NwNode, 'Channels: ' + AdvancedOptionsForm.AudioChannelsList.Text);
      end;
    end;

    NwNode := AddChild(nil, 'Subtitle');
    if EnableSubBtn.Checked then
    begin
      // dont show if ffmpeg is selected
      if EncoderList.ItemIndex = 0 then
      begin
        AddChild(NwNode, 'Language: ' + SettingsForm.LangIdList.Text);
        AddChild(NwNode, 'Font: ' + SettingsForm.FontList.Text);
        AddChild(NwNode, SettingsForm.AutoScaleList.Text);
        AddChild(NwNode, 'Default scale: ' + SettingsForm.DefScaleEdit.Text);
        AddChild(NwNode, 'Position: ' + SettingsForm.SubPosEdit.Text);
      end
      else
      begin
        AddChild(NwNode, 'Disabled')
      end;
    end
    else
    begin
      AddChild(NwNode, 'Disabled')
    end;
  end;
  MainSummaryList.FullExpand;
end;

procedure TMainForm.UseSourceChkBtnClick(Sender: TObject);
begin

  DirectoryEdit.Enabled := not UseSourceChkBtn.Checked;
  OpenOutDirBtn.Enabled := DirectoryEdit.Enabled;
  SelectBtn.Enabled := DirectoryEdit.Enabled;

end;

procedure TMainForm.V1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://www.fosshub.com/TEncoder-Video-Converter.html'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.V2Click(Sender: TObject);
begin
  Self.Enabled := False;
  VideoToGIFForm.FFMpegPath := FFFMpegPath;
  VideoToGIFForm.Show;
end;

procedure TMainForm.VideoEncoderListChange(Sender: TObject);
begin

  { decide container according to the selected video codec }

  case VideoEncoderList.ItemIndex of
    0:
      begin
        ContainerList.ItemIndex := 1;
        EncoderList.ItemIndex := 0;
      end;
    1:
      begin
        ContainerList.ItemIndex := 1;
        EncoderList.ItemIndex := 0;
      end;
    2:
      begin
        ContainerList.ItemIndex := 0;
        EncoderList.ItemIndex := 0;
      end;
    3:
      begin
        ContainerList.ItemIndex := 2;
        EncoderList.ItemIndex := 1;
      end;
    4:
      begin
        ContainerList.ItemIndex := 2;
        EncoderList.ItemIndex := 1;
      end;
    5:
      begin
        ContainerList.ItemIndex := 5;
        EncoderList.ItemIndex := 1;
      end;
    6:
      begin
        ContainerList.ItemIndex := 6;
        EncoderList.ItemIndex := 1;
      end;
    7:
      begin
        ContainerList.ItemIndex := 7;
        EncoderList.ItemIndex := 1;
      end;
    8:
      begin
        ContainerList.ItemIndex := 0;
        EncoderList.ItemIndex := 1;
      end;
    9:
      begin
        ContainerList.ItemIndex := 3;
        EncoderList.ItemIndex := 1;
      end;
    13:
      begin
        ContainerList.ItemIndex := 2;
        EncoderList.ItemIndex := 1;
      end;
  end;

  // disable/enable
  if (VideoEncoderList.ItemIndex = 10) or (VideoEncoderList.ItemIndex = 11) then
  begin
    AdvancedOptionsForm.VideobitrateList.Enabled := False;
    AdvancedOptionsForm.VideoSizeList.Enabled := False;
    AdvancedOptionsForm.VideoFPSList.Enabled := False;
    AdvancedOptionsForm.VideoAspectRatioList.Enabled := False;
    AdvancedOptionsForm.WidthEdit.Enabled := False;
    AdvancedOptionsForm.HeightEdit.Enabled := False;
    AdvancedOptionsForm.ForceASRBtn.Enabled := False;
    AdvancedOptionsForm.VideoCBrBtn.Enabled := False;
  end
  else if (VideoEncoderList.ItemIndex = 8) or (VideoEncoderList.ItemIndex = 9) then
  begin
    AdvancedOptionsForm.VideobitrateList.Enabled := False;
    AdvancedOptionsForm.VideoSizeList.Enabled := True;
    AdvancedOptionsForm.VideoFPSList.Enabled := True;
    AdvancedOptionsForm.VideoAspectRatioList.Enabled := True;
    AdvancedOptionsForm.WidthEdit.Enabled := True;
    AdvancedOptionsForm.HeightEdit.Enabled := True;
    AdvancedOptionsForm.ForceASRBtn.Enabled := True;
    AdvancedOptionsForm.VideoCBrBtn.Enabled := True;
  end
  else
  begin
    AdvancedOptionsForm.VideobitrateList.Enabled := True;
    AdvancedOptionsForm.VideoSizeList.Enabled := True;
    AdvancedOptionsForm.VideoFPSList.Enabled := True;
    AdvancedOptionsForm.VideoAspectRatioList.Enabled := True;
    AdvancedOptionsForm.WidthEdit.Enabled := True;
    AdvancedOptionsForm.HeightEdit.Enabled := True;
    AdvancedOptionsForm.ForceASRBtn.Enabled := True;
    AdvancedOptionsForm.VideoCBrBtn.Enabled := True;
  end;
  UpdateSummary;
end;

{ TVideoDownloaderItem }

constructor TVideoDownloaderItem.Create(const ParentControl: TsScrollBox; const _Index, PreviousBottom: Integer);
begin
  Panel := TsPanel.Create(nil);
  Panel2 := TsPanel.Create(nil);
  Panel3 := TsPanel.Create(nil);
  LinkLabel := TsLabel.Create(nil);
  ProgressLabel := TsLabel.Create(nil);
  PrevievImg := TsImage.Create(nil);
  DeleteButton := TsButton.Create(nil);
  DeleteButton.Tag := _Index;
  DeleteButton.AlignWithMargins := True;
  FileNameLabel := TsLabel.Create(nil);
  FormatList := TsComboBox.Create(nil);
  ProgressBar := TsProgressBar.Create(nil);
  SubtitleList := TsComboBox.Create(nil);
  Panel.ParentColor := False;
  Panel.Color := clGray;
  LinkLabel.Font.Color := clBlue;
  LinkLabel.Cursor := crHandPoint;
  LinkLabel.Font.Style := [fsUnderline];
  ProgressBar.Smooth := True;

  Panel.InsertControl(PrevievImg);
  Panel.InsertControl(Panel2);

  Panel2.InsertControl(LinkLabel);
  Panel2.InsertControl(FileNameLabel);
  Panel2.InsertControl(FormatList);
  Panel2.InsertControl(SubtitleList);
  Panel2.InsertControl(ProgressLabel);
  Panel2.InsertControl(ProgressBar);
  Panel2.InsertControl(Panel3);

  Panel3.InsertControl(DeleteButton);

  Panel2.BorderStyle := bsNone;
  Panel3.BorderStyle := bsNone;
  Panel2.BevelOuter := bvNone;
  Panel3.BevelOuter := bvNone;

  Panel.Align := alTop;
  Panel.Height := 150;
  Panel.Top := PreviousBottom;

  PrevievImg.Width := Panel.Height;
  PrevievImg.Height := Panel.Height;
  PrevievImg.AutoSize := False;
  PrevievImg.Center := True;
  PrevievImg.Transparent := True;
  PrevievImg.Align := alLeft;

  Panel2.Align := alClient;
  Panel3.Align := alBottom;
  Panel3.Height := 30;

  LinkLabel.Align := alTop;
  LinkLabel.AlignWithMargins := True;
  FileNameLabel.Align := alTop;
  FileNameLabel.AlignWithMargins := True;
  FormatList.Align := alTop;
  SubtitleList.Align := alTop;
  ProgressLabel.Align := alBottom;
  ProgressLabel.AlignWithMargins := True;
  ProgressBar.Align := alBottom;
  ProgressBar.Height := 10;
  FormatList.Style := csDropDownList;
  SubtitleList.Style := csDropDownList;

  DeleteButton.Width := 100;
  DeleteButton.Height := 30;
  DeleteButton.Caption := 'Remove';
  DeleteButton.Align := alRight;
end;

destructor TVideoDownloaderItem.Destroy;
begin

  inherited;
end;

procedure TVideoDownloaderItem.ResetProgressLabel;
begin
  ProgressLabel.Caption := '';
  ProgressBar.Position := 0;
end;

{ TConverterItem }

constructor TFileInfoItem.Create;
begin
  inherited;
  SubtitleFiles := TStringList.Create;
  AudioTracks := TStringList.Create;
  AudioIDs := TList<Integer>.Create;
  AudioExtensions := TStringList.Create;
  SubtitleTracks := TStringList.Create;
  AudioMencoderIDs := TList<Integer>.Create;
  SubtitleTrackIndexes := TList<Integer>.Create;
end;

destructor TFileInfoItem.Destroy;
begin
  inherited;
  SubtitleFiles.Free;
  AudioTracks.Free;
  AudioIDs.Free;
  AudioExtensions.Free;
  SubtitleTracks.Free;
  AudioMencoderIDs.Free;
  SubtitleTrackIndexes.Free;
end;

function TFileInfoItem.GetAudioExt: string;
begin
  Result := '.wav';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioExtensions.Count then
    begin
      Result := AudioExtensions[AudioIndex];
    end;
  end;
end;

function TFileInfoItem.GetAudioID: string;
begin
  Result := '1';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioIDs.Count then
    begin
      Result := FloatToStr(AudioIDs[AudioIndex]);
    end;
  end;
end;

function TFileInfoItem.GetMencoderAudioID: string;
begin
  Result := '1';
  if AudioIndex > -1 then
  begin
    if AudioIndex < AudioMencoderIDs.Count then
    begin
      Result := FloatToStr(AudioMencoderIDs[AudioIndex]);
    end;
  end;
end;

function TFileInfoItem.GetSubtitle: string;
begin
  Result := '';
  if SubtitleIndex > -1 then
  begin
    if SubtitleIndex < SubtitleFiles.Count then
    begin
      Result := SubtitleFiles[SubtitleIndex];
    end;
  end;
end;

function TFileInfoItem.GetSubtitleTrackID: string;
begin
  Result := '';
  if SubtitleTrackIndex > -1 then
  begin
    if SubtitleTrackIndex < SubtitleTrackIndexes.Count then
    begin
      Result := FloatToStr(SubtitleTrackIndexes[SubtitleTrackIndex]);
    end;
  end;
end;

end.
