// File: SSecurityManager.pas
// Version: 1.3
// Author: Spider13

unit SSecurityManager;

interface

uses SysUtils, Classes, SSecurityCommon, SSecurityController, SSecurityErrors;

type
  TLoginEvent = procedure (_Sender: TObject; _UserName: String; _Password: String; _Access: TSSecurityAccess) of object;
  TLogoutEvent = procedure (_Sender: TObject) of object;
  TChangePasswordEvent = procedure (_Sender: TObject; _OldPassword: String; _NewPassword: String) of object;

type
  TSSecurityLink = class;
  TSSecurityManager = class;

  TSSecurityLink = class(TObject)
  private
    FSecurityManager: TSSecurityManager;
  protected
    procedure SetSecurityManager(_Value: TSSecurityManager);
    function GetLogined: Boolean;
  public
    constructor Create;
    procedure UpdateState;
    procedure LoginEvent; virtual; abstract;
    procedure LogoutEvent; virtual; abstract;
    destructor Destroy; override;
    property SecurityManager: TSSecurityManager read FSecurityManager write SetSecurityManager;
    property Logined: Boolean read GetLogined;
  end;

  TSSecurityManager = class(TComponent)
  private
    Links: TList;
    FLogined: Boolean;
    FAccess: TSSecurityAccess;
    FAccessCount: Longint;
    FUserName: String;
    FOnLogin: TLoginEvent;
    FOnLogout: TLogoutEvent;
    FOnChangePassword: TChangePasswordEvent;
    FSecurityController: TSSecurityController;
    FUseController: Boolean;
  protected
    function GetAccess(_Index: Longint): Boolean;
    procedure SetAccessCount(_Value: Longint);
    procedure SetUseController(_Value: Boolean);
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterLink(_Link: TSSecurityLink);
    procedure UnregisterLink(_Link: TSSecurityLink);
    procedure Login(_UserName: String; _Password: String);
    procedure LoginEvents;
    procedure Logout;
    procedure LogoutEvents;
    procedure ChangePassword(_OldPassword: String; _NewPassword: String);
    property Access[_Index: Longint]: Boolean read GetAccess;
    property Logined: Boolean read FLogined;
    property UserName: String read FUserName;
  published
    property AccessCount: Longint read FAccessCount write FAccessCount default 0;
    property OnLogin: TLoginEvent read FOnLogin write FOnLogin default nil;
    property OnLogout: TLogoutEvent read FOnLogout write FOnLogout default nil;
    property OnChangePassword: TChangePasswordEvent read FOnChangePassword write FOnChangePassword default nil;
    property SecurityController: TSSecurityController read FSecurityController write FSecurityController;
    property UseController: Boolean read FUseController write SetUseController;
  end;

implementation

// TSSecurityLink //

constructor TSSecurityLink.Create;
begin
  inherited Create();
  FSecurityManager:= nil;
end;

destructor TSSecurityLink.Destroy;
begin
  if Assigned(FSecurityManager) then
    FSecurityManager.UnregisterLink(Self);
  inherited Destroy;
end;

function TSSecurityLink.GetLogined: Boolean;
begin
  Result:= Assigned(FSecurityManager) and FSecurityManager.Logined;
end;

procedure TSSecurityLink.SetSecurityManager(_Value: TSSecurityManager);
begin
  if _Value <> FSecurityManager then
  begin
    if Assigned(FSecurityManager) then
      FSecurityManager.UnregisterLink(Self);
    FSecurityManager:= _Value;
    if Assigned(FSecurityManager) then
      FSecurityManager.RegisterLink(Self);
  end;
end;

procedure TSSecurityLink.UpdateState;
begin
  if Assigned(FSecurityManager) and FSecurityManager.Logined then
    LoginEvent
  else
    LogoutEvent;
end;

// TSSecurityManager //

constructor TSSecurityManager.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  Links:= TList.Create;
  FAccessCount:= 0;
  FAccess:= TSSecurityAccess.Create;
  FOnLogin:= nil;
  FOnLogout:= nil;
  FOnChangePassword:= nil;
  FLogined:= False;
  FUserName:= '';
  FSecurityController:= nil;
  FUseController:= False;
end;

procedure TSSecurityManager.ChangePassword(_OldPassword: String; _NewPassword: String);
begin
  if FUseController and Assigned(FSecurityController) then
  begin
    FSecurityController.ChangePassword(UserName, _OldPassword, _NewPassword);
  end
  else
  begin
    if Assigned(FOnChangePassword) then
      FOnChangePassword(Self, _OldPassword, _NewPassword);
  end;
end;

destructor TSSecurityManager.Destroy;
begin
  while Links.Count > 0 do
    TSSecurityLink(Links.Items[0]).SecurityManager:= nil;
  FAccess.Free;
  Links.Free;
  inherited;
end;

function TSSecurityManager.GetAccess(_Index: Integer): Boolean;
begin
  Result:= FAccess.Access[_Index];
end;

procedure TSSecurityManager.Login(_UserName: String; _Password: String);
begin
  if FLogined then
    raise Exception.Create(SEAlreadyLogined);
  try
    if FUseController and Assigned(FSecurityController) then
    begin
      FAccess.Size:= FSecurityController.AccessCount + 1;
      FSecurityController.Login(_UserName, _Password, FAccess);
    end
    else
    begin
      FAccess.Size:= FAccessCount + 1;
      if Assigned(FOnLogin) then
        FOnLogin(Self, _UserName, _Password, FAccess);
    end;
    FAccess.Access[0]:= True;
    FAccess.Lock;
    FLogined:= True;
    FUserName:= _UserName;
    LoginEvents;
  except
    FAccess.Size:= 0;
    FLogined:= False;
    raise;
  end;
end;

procedure TSSecurityManager.LoginEvents;
var
  Index: Longint;
begin
  for Index:= 0 to Links.Count - 1 do
    TSSecurityLink(Links[Index]).LoginEvent;
end;

procedure TSSecurityManager.Logout;
begin
  if not FLogined then
    raise Exception.Create(SENotLogined);
  if FUseController and Assigned(FSecurityController) then
  begin
    FSecurityController.Logout;
  end
  else
  begin
    if Assigned(FOnLogout) then
      FOnLogout(Self);
  end;
  FAccess.Unlock;
  FLogined:= False;
  LogoutEvents;
  FAccess.Size:= 0;
end;

procedure TSSecurityManager.LogoutEvents;
var
  Index: Longint;
begin
  for Index:= 0 to Links.Count - 1 do
    TSSecurityLink(Links[Index]).LogoutEvent;
end;

procedure TSSecurityManager.RegisterLink(_Link: TSSecurityLink);
begin
  Links.Add(_Link);
end;

procedure TSSecurityManager.SetAccessCount(_Value: Integer);
begin
  if _Value <> FAccessCount then
  begin
    FAccessCount:= _Value;
    FAccess.Size:= FAccessCount;
  end;
end;

procedure TSSecurityManager.SetUseController(_Value: Boolean);
begin
  if _Value <> FUseController then
  begin
    if FLogined then
      raise Exception.Create(SECannotSetUseController);
    FUseController:= _Value;
  end;
end;

procedure TSSecurityManager.UnregisterLink(_Link: TSSecurityLink);
var
  Index: Longint;
begin
  Index:= Links.IndexOf(_Link);
  if Index <> -1 then
    Links.Delete(Index);
end;

end.
