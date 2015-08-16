program TEncoder;

uses
  madExcept,
  madLinkDisAsm,
  madListModules,
  Forms,
  UnitMain in 'Forms\UnitMain.pas' {MainForm} ,
  UnitAbout in 'Forms\UnitAbout.pas' {AboutForm} ,
  UnitAdd in 'Forms\UnitAdd.pas' {AddForm} ,
  UnitProperties in 'Forms\UnitProperties.pas' {InfoForm} ,
  UnitLogs in 'Forms\UnitLogs.pas' {LogForm} ,
  UnitProfileEditor in 'Forms\UnitProfileEditor.pas' {ProfileForm} ,
  UnitSettings in 'Forms\UnitSettings.pas' {SettingsForm} ,
  windows7taskbar in 'Units\windows7taskbar.pas',
  UnitEffects in 'Forms\UnitEffects.pas' {EffectForm} ,
  UnitRangeEditor in 'Forms\UnitRangeEditor.pas' {RangeEditorForm} ,
  UnitPreview in 'Forms\UnitPreview.pas' {PreviewForm} ,
  UnitPlayer in 'Units\UnitPlayer.pas',
  UnitFFmpegCommandLineCreator in 'Units\UnitFFmpegCommandLineCreator.pas',
  UnitMencoderCommandLineCreator in 'Units\UnitMencoderCommandLineCreator.pas',
  MediaInfoDLL in 'Units\MediaInfoDLL.pas',
  UnitAdvancedOptions in 'Forms\UnitAdvancedOptions.pas' {AdvancedOptionsForm} ,
  UnitEncoder in 'Units\UnitEncoder.pas',
  UnitFileItem in 'Units\UnitFileItem.pas',
  UnitImageAudioMerger in 'Forms\UnitImageAudioMerger.pas' {ImageAudiotoVideoForm} ,
  UnitDub in 'Forms\UnitDub.pas' {DubForm} ,
  UnitVideotoGIF in 'Forms\UnitVideotoGIF.pas' {VideoToGIFForm} ,
  UnitCommonTypes in 'Units\DownloaderUnits\UnitCommonTypes.pas',
  UnitImageResize in 'Units\DownloaderUnits\UnitImageResize.pas',
  UnitYouTubeVideoInfoExtractor in 'Units\DownloaderUnits\UnitYouTubeVideoInfoExtractor.pas',
  UnitBatchAdd in 'Forms\UnitBatchAdd.pas' {BatchAddForm} ,
  UnitFileNameExtractor in 'Units\DownloaderUnits\UnitFileNameExtractor.pas',
  UnitImageTypeExtractor in 'Units\DownloaderUnits\UnitImageTypeExtractor.pas',
  UnitDVDReader in 'Units\UnitDVDReader.pas',
  UnitWatermark in 'Forms\UnitWatermark.pas' {WatermarkForm} ,
  UnitDownloadProcess in 'Units\UnitDownloadProcess.pas',
  UnitDVDRipperProcess in 'Units\UnitDVDRipperProcess.pas',
  UnitFileInfoExtractor in 'Units\UnitFileInfoExtractor.pas',
  UnitDVDJob in 'Units\UnitDVDJob.pas',
  VideoAdding in 'Forms\VideoAdding.pas' {VideoAddingForm} ,
  DownloadItemFrame in 'Forms\DownloadItemFrame.pas' {DownloadUIItem: TFrame};

{$R *.res}

begin

  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.Title := 'TEncoder';

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TAddForm, AddForm);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.CreateForm(TProfileForm, ProfileForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TEffectForm, EffectForm);
  Application.CreateForm(TRangeEditorForm, RangeEditorForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TAdvancedOptionsForm, AdvancedOptionsForm);
  Application.CreateForm(TImageAudiotoVideoForm, ImageAudiotoVideoForm);
  Application.CreateForm(TDubForm, DubForm);
  Application.CreateForm(TVideoToGIFForm, VideoToGIFForm);
  Application.CreateForm(TBatchAddForm, BatchAddForm);
  Application.CreateForm(TWatermarkForm, WatermarkForm);
  Application.CreateForm(TVideoAddingForm, VideoAddingForm);
  Application.Run;

end.
