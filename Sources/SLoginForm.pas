// File: SLoginForm.pas
// Version: 1.3
// Author: Spider13

unit SLoginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, SSecurityManager, SSecurityErrors, Vcl.StdCtrls, Registry;

type
  TEncodePasswordEvent = procedure (_Sender: TObject; var _Password: String) of object;
  TDecodePasswordEvent = procedure (_Sender: TObject; var _Password: String) of object;

type
  TfSLoginForm = class(TForm)
    iLogo: TImage;
    lUserName: TLabel;
    lPassword: TLabel;
    eUserName: TEdit;
    bLogin: TButton;
    ePassword: TEdit;
    bCancel: TButton;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

type
  TSLoginForm = class(TComponent)
  private
    FSecurityManager: TSSecurityManager;
    FCaption: String;
    FUserNameCaption: String;
    FPasswordCaption: String;
    FLoginButtonCaption: String;
    FCancelButtonCaption: String;
    FRetries: Longint;
    FTryNumber: Longint;
    FUseWindowsUserName: Boolean;
  protected
    procedure SetSecurityManager(_Value: TSSecurityManager);
    function GetWindowsUserName: String;
    function GetTriesRemaining: Longint;
  public
    constructor Create(_Owner: TComponent); override;
    procedure Notification(_Component: TComponent; _Operation: TOperation); override;
    destructor Destroy; override;
    function Execute: Boolean;
    procedure Error(_Exception: Exception);
    property TryNumber: Longint read FTryNumber;
    property TriesRemaining: Longint read GetTriesRemaining;
  published
    property SecurityManager: TSSecurityManager read FSecurityManager write SetSecurityManager;
    property Retries: Longint read FRetries write FRetries default 3;
    property Caption: String read FCaption write FCaption;
    property UserNameCaption: String read FUserNameCaption write FUserNameCaption;
    property PasswordCaption: String read FPasswordCaption write FPasswordCaption;
    property LoginButtonCaption: String read FLoginButtonCaption write FLoginButtonCaption;
    property CancelButtonCaption: String read FCancelButtonCaption write FCancelButtonCaption;
    property UseWindowsUserName: Boolean read FUseWindowsUserName write FUseWindowsUserName default True;
  end;

implementation

{$R *.dfm}

// TfSLoginForm //

procedure TfSLoginForm.FormCreate(Sender: TObject);
begin
end;

// TSLoginForm //

constructor TSLoginForm.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  FSecurityManager:= nil;
  FRetries:= 3;
  FTryNumber:= 0;
  FUseWindowsUserName:= True;
  FCaption:= 'Login';
  FUserNameCaption:= 'Username:';
  FPasswordCaption:= 'Password:';
  FLoginButtonCaption:= 'Login';
  FCancelButtonCaption:= 'Cancel';
end;

destructor TSLoginForm.Destroy;
begin
  inherited Destroy;
end;

procedure TSLoginForm.Error(_Exception: Exception);
begin
  MessageDlg(_Exception.Message, mtError, [mbOk], 0);
end;

function TSLoginForm.Execute: Boolean;
var
  fSLoginForm: TfSLoginForm;
  Sucsessful: Boolean;
  Applied: Boolean;
begin
  if not Assigned(FSecurityManager) then
    raise Exception.Create(Format(SEInvalidProperty, ['SecurityManager']));
  fSLoginForm:= TfSLoginForm.Create(Application);
  fSLoginForm.Caption:= FCaption;
  fSLoginForm.lUserName.Caption:= FUserNameCaption;
  fSLoginForm.lPassword.Caption:= FPasswordCaption;
  fSLoginForm.bLogin.Caption:= FLoginButtonCaption;
  fSLoginForm.bCancel.Caption:= FCancelButtonCaption;
  if FUseWindowsUserName then
    fSLoginForm.eUserName.Text:= GetWindowsUserName;
  FTryNumber:= 1;
  Sucsessful:= False;
  repeat
    Applied:= fSLoginForm.ShowModal = mrOk;
    Sucsessful:= False;
    if Applied then
    try
      FSecurityManager.Login(fSLoginForm.eUserName.Text, fSLoginForm.ePassword.Text);
      Sucsessful:= True;
    except
      on Exception: Exception do
      begin
        FTryNumber:= FTryNumber + 1;
        Error(Exception);
      end;
    end;
  until not Applied or (Applied and Sucsessful) or (FTryNumber > FRetries);
  Result:= Applied and Sucsessful;
  fSLoginForm.Free;
end;

function TSLoginForm.GetTriesRemaining: Longint;
begin
  Result:= FRetries - FTryNumber;
end;

function TSLoginForm.GetWindowsUserName: String;
var
  Buffer: array[0..128] of Char;
  Size: DWord;
begin
  Size:= SizeOf(Buffer);
  if GetUserName(@Buffer, Size) then
    Result:= Buffer
  else
    Result:= '';
end;

procedure TSLoginForm.Notification(_Component: TComponent; _Operation: TOperation);
begin
  inherited Notification(_Component, _Operation);
  if (_Operation = opRemove) and (_Component = FSecurityManager) then
    FSecurityManager:= nil;
end;

procedure TSLoginForm.SetSecurityManager(_Value: TSSecurityManager);
begin
  if _Value <> FSecurityManager then
  begin
    if Assigned(FSecurityManager) then
      RemoveFreeNotification(FSecurityManager);
    FSecurityManager:= _Value;
    if Assigned(FSecurityManager) then
      FreeNotification(FSecurityManager);
  end;
end;

end.
