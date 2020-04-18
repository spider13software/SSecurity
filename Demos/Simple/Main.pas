unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SFormSecurity, SSecurityManager, SLoginForm, SMenuSecurity,
  Menus, SChangePasswordForm, SSecurityCommon, SSecurityController, Registry;

type
  TfMain = class(TForm)
    SecurityManager: TSSecurityManager;
    LoginForm: TSLoginForm;
    MainMenu: TMainMenu;
    miRegistration: TMenuItem;
    MenuSecurity: TSMenuSecurity;
    miRegister: TMenuItem;
    miUnregister: TMenuItem;
    miRequests: TMenuItem;
    miRequestsForm: TMenuItem;
    miNewRequest: TMenuItem;
    procedure miRegisterClick(Sender: TObject);
    procedure miUnregisterClick(Sender: TObject);
    procedure miNewRequestClick(Sender: TObject);
    procedure miRequestsFormClick(Sender: TObject);
    procedure MenuSecurityLogout(_Sender: TObject);
    procedure SecurityManagerLogin(_Sender: TObject; _UserName,
      _Password: String; _Access: TSSecurityAccess);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses Requests;

{$R *.dfm}

procedure TfMain.MenuSecurityLogout(_Sender: TObject);
var
  Index: Longint;
begin
  for Index:= 0 to MDIChildCount - 1 do
    MDIChildren[Index].Close;
end;

procedure TfMain.miNewRequestClick(Sender: TObject);
begin
  ShowMessage('New request');
end;

procedure TfMain.miRegisterClick(Sender: TObject);
begin
  LoginForm.Execute;
end;

procedure TfMain.miRequestsFormClick(Sender: TObject);
begin
  TfRequests.Create(Application);
end;

procedure TfMain.miUnregisterClick(Sender: TObject);
begin
  SecurityManager.Logout();
end;

procedure TfMain.SecurityManagerLogin(_Sender: TObject; _UserName,
  _Password: String; _Access: TSSecurityAccess);
begin
  if ((_UserName = 'admin') and (_Password = 'admin')) or ((_UserName = 'user') and (_Password = 'user')) then
  begin
    if _UserName = 'ADMIN' then
    begin
      _Access.Access[1]:= True;
      _Access.Access[2]:= True;
    end
    else
    begin
      _Access.Access[1]:= False;
      _Access.Access[2]:= False;
    end;
  end
  else
    raise Exception.Create('Invalid User/Password');
end;

end.
