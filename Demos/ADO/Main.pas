unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SFormSecurity, SSecurityManager, SLoginForm, SMenuSecurity,
  Menus, SChangePasswordForm, SSecurityCommon, SSecurityController, Registry,
  SDBSecurityController, DB, ADODB, Grids, DBGrids;

type
  TfMain = class(TForm)
    SecurityManager: TSSecurityManager;
    LoginForm: TSLoginForm;
    MainMenu: TMainMenu;
    miRegistration: TMenuItem;
    MenuSecurity: TSMenuSecurity;
    ChangePasswordForm: TSChangePasswordForm;
    miRegister: TMenuItem;
    miUnregister: TMenuItem;
    miChangePassword: TMenuItem;
    SDBSecurityController1: TSDBSecurityController;
    Connection: TADOConnection;
    tUsers: TADOTable;
    dsUsers: TDataSource;
    tAccess: TADOTable;
    dsAccess: TDataSource;
    miPermissions: TMenuItem;
    miPermissions1: TMenuItem;
    miPermissions2: TMenuItem;
    miPermissions3: TMenuItem;
    miPermissions4: TMenuItem;
    miPermissions5: TMenuItem;
    tAccessACCESSID: TAutoIncField;
    tAccessINDEX: TIntegerField;
    tAccessACCESS: TIntegerField;
    tGroupAccess: TADOTable;
    tGroupAccessID: TAutoIncField;
    tGroupAccessUSERID: TIntegerField;
    tGroupAccessGROUPID: TIntegerField;
    dsGroupAccess: TDataSource;
    tAccessGROUPID: TIntegerField;
    tUsersUSERID: TAutoIncField;
    tUsersUSERNAME: TWideStringField;
    tUsersPASSWORD: TWideStringField;
    tUsersFIRSTNAME: TWideStringField;
    tUsersLASTNAME: TWideStringField;
    procedure miRegisterClick(Sender: TObject);
    procedure miChangePasswordClick(Sender: TObject);
    procedure miNewRequestClick(Sender: TObject);
    procedure miRequestsFormClick(Sender: TObject);
    procedure MenuSecurityLogout(_Sender: TObject);
    procedure SDBSecurityController1BeforeLogin(_Sender: TObject; _UserName, _Password: String);
    procedure miUnregisterClick(Sender: TObject);
    procedure SDBSecurityController1Logout(_Sender: TObject);
    procedure miPermissions1Click(Sender: TObject);
    procedure miPermissions2Click(Sender: TObject);
    procedure miPermissions3Click(Sender: TObject);
    procedure miPermissions4Click(Sender: TObject);
    procedure miPermissions5Click(Sender: TObject);
    procedure SDBSecurityController1EncryptPassword(_Sender: TObject;
      _InputPassword: string; var _OutputPassword: string);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses Requests;

{$R *.dfm}

function Revert(_Text: String): String;
var
  Index: Longint;
  Size: Longint;
begin
  Size:= Length(_Text);
  SetLength(Result, Size);
  for Index:= 1 to Size do
    Result[Size - Index + 1]:= _Text[Index];
end;

procedure TfMain.MenuSecurityLogout(_Sender: TObject);
var
  Index: Longint;
begin
  for Index:= 0 to MDIChildCount - 1 do
    MDIChildren[Index].Close;
end;

procedure TfMain.miChangePasswordClick(Sender: TObject);
begin
  ChangePasswordForm.Execute;
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

procedure TfMain.SDBSecurityController1BeforeLogin(_Sender: TObject;
  _UserName, _Password: String);
begin
  if Connection.Connected then
    Connection.Connected:= False;
  Connection.ConnectionString:= 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\Data\Data.mdb;Persist Security Info=False';
  Connection.Connected:= True;
  tUsers.Active:= True;
  tGroupAccess.Active:= True;
  tAccess.Active:= True;
end;

procedure TfMain.SDBSecurityController1EncryptPassword(_Sender: TObject;
  _InputPassword: string; var _OutputPassword: string);
begin
  _OutputPassword:= Revert(_InputPassword);

end;

procedure TfMain.miUnregisterClick(Sender: TObject);
begin
  SecurityManager.Logout;
end;

procedure TfMain.SDBSecurityController1Logout(_Sender: TObject);
begin
  Connection.Connected:= False;
end;

procedure TfMain.miPermissions1Click(Sender: TObject);
begin
  ShowMessage('Permission 1');
end;

procedure TfMain.miPermissions2Click(Sender: TObject);
begin
  ShowMessage('Permission 2');
end;

procedure TfMain.miPermissions3Click(Sender: TObject);
begin
  ShowMessage('Permission 3');
end;

procedure TfMain.miPermissions4Click(Sender: TObject);
begin
  ShowMessage('Permission 4');
end;

procedure TfMain.miPermissions5Click(Sender: TObject);
begin
  ShowMessage('Permission 5');
end;

end.
