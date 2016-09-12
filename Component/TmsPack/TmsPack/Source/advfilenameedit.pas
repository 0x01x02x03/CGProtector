{*********************************************************************}
{ TAdvFilenameEdit                                                    }
{ for Delphi & C++Builder                                             }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright � 2002 - 2008                                            }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{                                                                     }
{ The source code is given as is. The author is not responsible       }
{ for any possible damage done due to the use of this code.           }
{ The component can be freely used in any application. The source     }
{ code remains property of the author and may not be distributed      }
{ freely as such.                                                     }
{*********************************************************************}

unit AdvFileNameEdit;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvEdit, AdvEdBtn
  {$IFDEF TMSDOTNET}
  , WinUtils
  {$ENDIF}
  ;

  // version history
  // v1.0.0.0  : first release
  // v1.1.0.0  : support for ShowURL added
  // v1.1.0.1  : Fixed issue with F4 hotkey handling 

type
  TFileDialogKind = (fdOpen, fdSave, fdOpenPicture, fdSavePicture);

  TDialogExitEvent = procedure(Sender: TObject; ExitOK: Boolean) of object;

  TAdvFileNameEdit = class(TAdvEditBtn)
  private
    { Private declarations }
    FDummy: Byte;
    FDefaultExt: string;
    FFilter: string;
    FFilterIndex: Integer;
    FInitialDir: string;
    FDialogOptions: TOpenOptions;
    FDialogTitle: string;
    FDialogKind: TFileDialogKind;
    FOnDialogExit: TDialogExitEvent;
    function GetFileName: TFileName;
    procedure SetFileName (const Value: TFileName);
  protected
    { Protected declarations }
    procedure BtnClick (Sender: TObject); override;
    //procedure ValueValidate(Sender: TObject; Value: String; Var IsValid: Boolean); Virtual;
    procedure ValidateEvent(Value:string; var IsValid: Boolean); override;
    procedure DialogExit(ExitOk: Boolean);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    function TestURL: Boolean; override;    
  public
    { Public declarations }
    procedure ClickButton;
    constructor Create(AOwner: TComponent); override;
  published
    {$IFNDEF TMSDOTNET}
    property AutoThousandSeparator: Byte read FDummy;
    property EditAlign: Byte read FDummy;
    property EditType: Byte read FDummy;
    property ExcelStyleDecimalSeparator: Byte read FDummy;
    property PasswordChar: Byte read FDummy;
    property Precision: Byte read FDummy;
    property Signed: Byte read FDummy;
    //property ShowURL: Byte read FDummy;
    //property URLColor: Byte read FDummy;
    {$ENDIF}
    property DefaultExt: string read FDefaultExt write FDefaultExt;
    property FileName: TFileName read GetFileName write SetFileName Stored False;
    property Filter: string read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex default 1;
    property InitialDir: string read FInitialDir write FInitialDir;
    property DialogOptions: TOpenOptions read FDialogOptions write FDialogOptions default [ofHideReadOnly, ofEnableSizing];
    property DialogTitle: string read FDialogTitle write FDialogTitle;
    property DialogKind: TFileDialogKind read FDialogKind write FDialogKind;
    property OnDialogExit: TDialogExitEvent read FOnDialogExit write FOnDialogExit;
  end;

implementation

uses ExtDlgs;
{$R *.RES}

constructor TAdvFileNameEdit.Create(AOwner: TComponent);
Begin
  Inherited;
  Glyph.LoadFromResourceName (HInstance, 'AdvFileNameEdit');
  Button.OnClick := BtnClick;
  ButtonWidth := 18;
End;

procedure TAdvFileNameEdit.BtnClick (Sender: TObject);
var
  Dialog: TOpenDialog;

begin
  Dialog := nil;
  case FDialogKind Of
    fdOpen:         Dialog := TOpenDialog.Create (nil);
    fdOpenPicture:  Dialog := TOpenPictureDialog.Create (nil);
    fdSave:         Dialog := TSaveDialog.Create (nil);
    fdSavePicture:  Dialog := TSavePictureDialog.Create (nil);
  end;

  with Dialog do
  begin
    {$IFDEF DELPHI6_LVL}
    FileName := ExcludeTrailingPathDelimiter(Self.FileName);
    {$ELSE}
    FileName := Self.FileName;
    {$ENDIF}
    DefaultExt := FDefaultExt;
    Filter := FFilter;
    FilterIndex := FFilterIndex;
    InitialDir := FInitialDir;
    Options := FDialogOptions;
    Title := FDialogTitle;
  end;

  if Assigned(OnClickBtn) then
    OnClickBtn(Self);

  try
    if Dialog.Execute then
    begin
      Text := Dialog.FileName;
      FFilterIndex := Dialog.FilterIndex;
      DialogExit(true);
      Modified := True;
    end
    else
      DialogExit(false);
  finally
    Dialog.Free;
  end;
end;

procedure TAdvFileNameEdit.ValidateEvent(Value: String; Var IsValid: Boolean);
begin
  IsValid := FileExists (Value);
  inherited;  
end;

function TAdvFileNameEdit.GetFileName: TFileName;
Begin
  Result := Text;
End;

procedure TAdvFileNameEdit.SetFileName (const Value: TFileName);
Begin
  Text := Value;
End;

function TAdvFileNameEdit.TestURL: Boolean;
begin
  Result := ShowUrl and FileExists(text);
end;

procedure TAdvFileNameEdit.DialogExit(ExitOk: Boolean);
begin
  if Assigned(OnDialogExit) then
    OnDialogExit(Self,ExitOk);
end;

procedure TAdvFileNameEdit.ClickButton;
begin
  BtnClick(Self);
end;

procedure TAdvFileNameEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TAdvFileNameEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_F4) then
    BtnClick(Self);
  SetFocus;
end;

End.
