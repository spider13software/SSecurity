unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SSecurityManager, StdCtrls, atScript, atScripter, SLoginForm,
  SSecurityCommon, SFormSecurity, SChangePasswordForm, ap_SSecurity;

type
  TForm1 = class(TForm)
    SecurityManager: TSSecurityManager;
    Scripter: TatScripter;
    mScript: TMemo;
    bExecuteScript: TButton;
    LoginForm: TSLoginForm;
    mLoginedScript: TMemo;
    bLoginedExecuteScript: TButton;
    SFormSecurity1: TSFormSecurity;
    ChangePasswordForm: TSChangePasswordForm;
    bChangePassword: TButton;
    mLoginProcedure: TMemo;
    Label1: TLabel;
    LoginScripter: TatScripter;
    Button1: TButton;
    procedure bExecuteScriptClick(Sender: TObject);
    procedure SecurityManagerLogin(_Sender: TObject; _UserName: String; _Password: string; _Access: TSAccess);
    procedure bLoginedExecuteScriptClick(Sender: TObject);
    procedure bChangePasswordClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.bChangePasswordClick(Sender: TObject);
begin
  Scripter.SourceCode.Text:= 'uses SSecurity; begin ChangePasswordForm.Execute(); end;';
  Scripter.Execute;
end;

procedure TForm1.bExecuteScriptClick(Sender: TObject);
begin
  Scripter.SourceCode.Assign(mScript.Lines);
  Scripter.Execute;
end;

procedure TForm1.bLoginedExecuteScriptClick(Sender: TObject);
begin
  Scripter.SourceCode.Assign(mLoginedScript.Lines);
  Scripter.Execute;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Scripter.SourceCode.Text:= 'uses SSecurity; begin SecurityManager.Logout(); end;';
  Scripter.Execute;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Scripter.AddComponent(SecurityManager);
  Scripter.AddComponent(LoginForm);
  Scripter.AddComponent(ChangePasswordForm);
end;

procedure TForm1.SecurityManagerLogin(_Sender: TObject; _UserName: String; _Password: string; _Access: TSAccess);
begin
  LoginScripter.SourceCode.Assign(mLoginProcedure.Lines);
  LoginScripter.ExecuteSubroutine('OnLogin', [_Sender, _UserName, _Password, _Access]);
end;

end.
