{
  Note: All Global Funtions Return Types are BOOLEAN.
  this will return TRUE or FALSE according to whether
  the function was succesful or insuccesful.

  -Captain Muscles.
}
unit windows7taskbar;

interface

uses Forms, Windows;

type
  THUMBBUTTON = record
    dwMask: DWORD;
    iId: UINT;
    iBitmap: UINT;
    hIcon: hIcon;
    szTip: packed array [0 .. 259] of WCHAR;
    dwFlags: DWORD;
  end;
{$EXTERNALSYM THUMBBUTTON}

  tagTHUMBBUTTON = THUMBBUTTON;
{$EXTERNALSYM tagTHUMBBUTTON}
  TThumbButton = THUMBBUTTON;
  PThumbButton = ^TThumbButton;

  // THUMBBUTTON flags
const
  THBF_ENABLED = $0000;
{$EXTERNALSYM THBF_ENABLED}
  THBF_DISABLED = $0001;
{$EXTERNALSYM THBF_DISABLED}
  THBF_DISMISSONCLICK = $0002;
{$EXTERNALSYM THBF_DISMISSONCLICK}
  THBF_NOBACKGROUND = $0004;
{$EXTERNALSYM THBF_NOBACKGROUND}
  THBF_HIDDEN = $0008;
{$EXTERNALSYM THBF_HIDDEN}
  THBF_NONINTERACTIVE = $10;
{$EXTERNALSYM THBF_NONINTERACTIVE}
  // THUMBBUTTON mask
  THB_BITMAP = $0001;
{$EXTERNALSYM THB_BITMAP}
  THB_ICON = $0002;
{$EXTERNALSYM THB_ICON}
  THB_TOOLTIP = $0004;
{$EXTERNALSYM THB_TOOLTIP}
  THB_FLAGS = $0008;
{$EXTERNALSYM THB_FLAGS}
  THBN_CLICKED = $1800;
{$EXTERNALSYM THBN_CLICKED}
  TBATF_USEMDITHUMBNAIL = $1;
{$EXTERNALSYM TBATF_USEMDITHUMBNAIL}
  TBATF_USEMDILIVEPREVIEW = $2;

const
  TBPF_NOPROGRESS = 0;
  TBPF_INDETERMINATE = $1;
  TBPF_NORMAL = 2;
  TBPF_ERROR = 4;
  TBPF_PAUSED = 8;

type
  TTaskBarProgressState = (tbpsNone, tbpsIndeterminate, tbpsNormal, tbpsError, tbpsPaused);

function SetProgressState(hwnd: THandle; const AState: TTaskBarProgressState): boolean;
function SetProgressValue(hwnd: THandle; const ACurrent, AMax: UInt64): boolean;
function AddTab(hwnd: THandle): boolean;
function deleteTab(hwnd: THandle): boolean;
function ThumbBarAddButtons(hwnd: THandle; cButtons: Cardinal; pButtons: PThumbButton): boolean;
function ThumbBarUpdateButtons(hwnd: THandle; cButtons: Cardinal; pButtons: PThumbButton): boolean;
function ThumbBarSetImageList(hwnd: THandle; himl: THandle): boolean;
function SetOverlayIcon(hwnd: THandle; hIcon: THandle; pszDescription: PChar): boolean;
function InitializeTaskbarAPI: boolean; stdcall;

implementation

uses
  ComObj, Types;

const
  TASKBAR_CID: TGUID = '{56FDF344-FD6D-11d0-958A-006097C9A090}';

type
  { Definition for Windows 7 ITaskBarList3 }
  ITaskBarList3 = interface(IUnknown)
    ['{EA1AFB91-9E28-4B86-90E9-9E9F8A5EEFAF}']
    procedure HrInit(); stdcall;
    procedure AddTab(hwnd: THandle); stdcall;
    procedure deleteTab(hwnd: THandle); stdcall;
    procedure ActivateTab(hwnd: THandle); stdcall;
    procedure SetActiveAlt(hwnd: THandle); stdcall;
    procedure MarkFullscreenWindow(hwnd: THandle; fFullscreen: boolean); stdcall;
    procedure SetProgressValue(hwnd: THandle; ullCompleted: UInt64; ullTotal: UInt64); stdcall;
    procedure SetProgressState(hwnd: THandle; tbpFlags: Cardinal); stdcall;
    procedure RegisterTab(hwnd: THandle; hwndMDI: THandle); stdcall;
    procedure UnregisterTab(hwndTab: THandle); stdcall;
    procedure SetTabOrder(hwndTab: THandle; hwndInsertBefore: THandle); stdcall;
    procedure SetTabActive(hwndTab: THandle; hwndMDI: THandle; tbatFlags: Cardinal); stdcall;
    procedure ThumbBarAddButtons(hwnd: THandle; cButtons: Cardinal; pButtons: PThumbButton); stdcall;
    procedure ThumbBarUpdateButtons(hwnd: THandle; cButtons: Cardinal; pButtons: PThumbButton); stdcall;
    procedure ThumbBarSetImageList(hwnd: THandle; himl: THandle); stdcall;
    procedure SetOverlayIcon(hwnd: THandle; hIcon: THandle; pszDescription: PChar); stdcall;
    procedure SetThumbnailTooltip(hwnd: THandle; pszDescription: PChar); stdcall;
    procedure SetThumbnailClip(hwnd: THandle; var prcClip: TRect); stdcall;
  end;

var
  { Global variable storing the COM interface }
  GlobalTaskBarInterface: ITaskBarList3;

  { TFormHelper }

function SetProgressState(hwnd: THandle; const AState: TTaskBarProgressState): boolean;
const
  Flags: array [TTaskBarProgressState] of Cardinal = (0, $1, 2, 4, 8);
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.SetProgressState(hwnd, Flags[AState]);
end;

function SetProgressValue(hwnd: THandle; const ACurrent, AMax: UInt64): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.SetProgressValue(hwnd, ACurrent, AMax);
end;

function AddTab(hwnd: THandle): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.AddTab(hwnd);
end;

function deleteTab(hwnd: THandle): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.deleteTab(hwnd);
end;

function ThumbBarAddButtons(hwnd: THandle; cButtons: Cardinal; pButtons: PThumbButton): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.ThumbBarAddButtons(hwnd, cButtons, pButtons);
end;

function ThumbBarUpdateButtons(hwnd: THandle; cButtons: Cardinal; pButtons: PThumbButton): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.ThumbBarUpdateButtons(hwnd, cButtons, pButtons);
end;

function ThumbBarSetImageList(hwnd: THandle; himl: THandle): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.ThumbBarSetImageList(hwnd, himl);
end;

function SetOverlayIcon(hwnd: THandle; hIcon: THandle; pszDescription: PChar): boolean;
begin
  result := true;
  if GlobalTaskBarInterface = nil then
    result := false;
  if result = true then
    GlobalTaskBarInterface.SetOverlayIcon(hwnd, hIcon, pszDescription);
end;

function InitializeTaskbarAPI(): boolean; stdcall;
var
  Unk: IInterface;

begin
  { Make sure that COM is initialized }
  CoInitializeEx(nil, 0);

  result := true;
  try
    { Obtain an IUnknown }
    Unk := CreateComObject(TASKBAR_CID);

    if Unk = nil then
      Exit;

    { Cast to the required interface }
    GlobalTaskBarInterface := Unk as ITaskBarList3;

    { Initialize }
    GlobalTaskBarInterface.HrInit();
  except
    GlobalTaskBarInterface := nil;
    result := false;
  end;

end;

end.
