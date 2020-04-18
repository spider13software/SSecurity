// File: SChangePasswordForm.pas
// Version: 1.3
// Author: Spider13

unit SChangePasswordForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, SSecurityErrors, Vcl.StdCtrls, SSecurityManager;

type
  TfSChangePasswordForm = class(TForm)
    iLogo: TImage;
    lCurrentPassword: TLabel;
    lNewPassword: TLabel;
    lConfirmPassword: TLabel;
    eCurrentPassword: TEdit;
    bApply: TButton;
    eNewPassword: TEdit;
    bCancel: TButton;
    eConfirmPassword: TEdit;
    procedure ePasswordChange(Sender: TObject);
  private
  public
  end;

type
  TSChangePasswordForm = class(TComponent)
  private
    FSecurityManager: TSSecurityManager;
    FCaption: String;
    FCurrentPasswordCaption: String;
    FNewPasswordCaption: String;
    FConfirmPasswordCaption: String;
    FApplyButtonCaption: String;
    FCancelButtonCaption: String;
  protected
  public
    constructor Create(_Owner: TComponent); override;
    procedure SetSecurityManager(_Value: TSSecurityManager);
    procedure Notification(_Component: TComponent; _Operation: TOperation); override;
    procedure Execute;
    procedure Error(_Exception: Exception);
  published
    property SecurityManager: TSSecurityManager read FSecurityManager write SetSecurityManager;
    property Caption: String read FCaption write FCaption;
    property CurrentPasswordCaption: String read FCurrentPasswordCaption write FCurrentPasswordCaption;
    property NewPassword: String read FNewPasswordCaption write FNewPasswordCaption;
    property ConfirmPassword: String read FConfirmPasswordCaption write FConfirmPasswordCaption;
    property ApplyButtonCaption: String read FApplyButtonCaption write FApplyButtonCaption;
    property CancelButtonCaption: String read FCancelButtonCaption write FCancelButtonCaption;
  end;

implementation

{$R *.dfm}

// TfSChangePasswordForm //

procedure TfSChangePasswordForm.ePasswordChange(Sender: TObject);
begin
  bApply.Enabled:= (Length(eCurrentPassword.Text) > 0) and (Length(eNewPassword.Text) > 0) and (eNewPassword.Text = eConfirmPassword.Text);
end;

// TSChangePasswordForm //

constructor TSChangePasswordForm.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  FSecurityManager:= nil;
  FCaption:= 'Change password';
  FCurrentPasswordCaption:= 'Current password:';
  FNewPasswordCaption:= 'New password:';
  FConfirmPasswordCaption:= 'Confirm password:';
  FApplyButtonCaption:= 'Change';
  FCancelButtonCaption:= 'Cancel';
end;

procedure TSChangePasswordForm.Error(_Exception: Exception);
begin
  MessageDlg(_Exception.Message, mtError, [mbOk], 0);
end;

procedure TSChangePasswordForm.Execute;
var
  fSChangePasswordForm: TfSChangePasswordForm;
  Complate: Boolean;
begin
  if not Assigned(FSecurityManager) then
    raise Exception.Create(Format(SEInvalidProperty, ['SecurityManager']));
  fSChangePasswordForm:= TfSChangePasswordForm.Create(Application);
  fSChangePasswordForm.Caption:= FCaption;
  fSChangePasswordForm.lCurrentPassword.Caption:= FCurrentPasswordCaption;
  fSChangePasswordForm.lNewPassword.Caption:= FNewPasswordCaption;
  fSChangePasswordForm.lConfirmPassword.Caption:= FConfirmPasswordCaption;
  fSChangePasswordForm.bApply.Caption:= FApplyButtonCaption;
  fSChangePasswordForm.bCancel.Caption:= FCancelButtonCaption;
  try
    if fSChangePasswordForm.ShowModal = mrOk then
      FSecurityManager.ChangePassword(fSChangePasswordForm.eCurrentPassword.Text, fSChangePasswordForm.eNewPassword.Text);
  except
    on Exception: Exception do
    begin
      Error(Exception);
    end;
  end;
  fSChangePasswordForm.Free;
end;

procedure TSChangePasswordForm.Notification(_Component: TComponent; _Operation: TOperation);
begin
  inherited Notification(_Component, _Operation);
  if (_Operation = opRemove) and (_Component = FSecurityManager) then
    FSecurityManager:= nil;
end;

procedure TSChangePasswordForm.SetSecurityManager(_Value: TSSecurityManager);
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
