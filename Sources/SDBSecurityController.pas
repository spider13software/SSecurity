// File: SDBSecurityController.pas
// Version: 1.3
// Author: Spider13

unit SDBSecurityController;

interface

uses SysUtils, Classes, SSecurityCommon, SSecurityController, DB;

type
  TBeforeLoginEvent = procedure (_Sender: TObject; _UserName: String; _Password: String) of object;
  TAfterLoginEvent = procedure (_Sender: TObject) of object;
  TLogoutEvent = procedure (_Sender: TObject) of object;
  TChangePasswordEvent = procedure (_Sender: TObject; _OldPassword: String; _NewPassword: String) of object;
  TEncryptPasswordEvent = procedure (_Sender: TObject; _InputPassword: String; var _OutputPassword: String) of object;

type
  TSUsersBindary = class;
  TSGroupAccessBindary = class;
  TSSecurityAccessBindary = class;
  TSDBSecurityController = class;

  TSUsersBindary = class(TPersistent)
  private
    Owner: TComponent;
    FDataSource: TDataSource;
    FUserIdField: String;
    FUserNameField: String;
    FPasswordField: String;
    FUsePassword: Boolean;
    FUserNameCaseSens: Boolean;
  protected
    procedure SetDataSource(_Value: TDataSource);
  public
    constructor Create(_Owner: TComponent);
    procedure Assign(_Source: TPersistent); override;
    function GetOwner: TPersistent; override;
    destructor Destroy;
  published
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property UserIdField: String read FUserIdField write FUserIdField;
    property UserNameField: String read FUserNameField write FUserNameField;
    property PasswordField: String read FPasswordField write FPasswordField;
    property UsePassword: Boolean read FUsePassword write FUsePassword;
    property UserNameCaseSens: Boolean read FUserNameCaseSens write FUserNameCaseSens;
  end;

  TSGroupAccessBindary = class(TPersistent)
  private
    Owner: TComponent;
    FDataSource: TDataSource;
    FGroupIdField: String;
    FUserIdField: String;
  protected
    procedure SetDataSource(_Value: TDataSource);
  public
    constructor Create(_Owner: TComponent);
    procedure Assign(_Source: TPersistent); override;
    function GetOwner: TPersistent; override;
    destructor Destroy; override;
  published
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property GroupIdField: String read FGroupIdField write FGroupIdField;
    property UserIdField: String read FUserIdField write FUserIdField;
  end;

  TSSecurityAccessBindary = class(TPersistent)
  private
    Owner: TComponent;
    FDataSource: TDataSource;
    FAccessField: String;
    FIndexField: String;
    FGroupIdField: String;
  protected
    procedure SetDataSource(_Value: TDataSource);
  public
    constructor Create(_Owner: TComponent);
    procedure Assign(_Source: TPersistent); override;
    function GetOwner: TPersistent; override;
    destructor Destroy; override;
  published
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property AccessField: String read FAccessField write FAccessField;
    property IndexField: String read FIndexField write FIndexField;
    property GroupIdField: String read FGroupIdField write FGroupIdField;
  end;

  TSDBSecurityController = class(TSSecurityController)
  private
    FUsersBindary: TSUsersBindary;
    FGroupAccessBindary: TSGroupAccessBindary;
    FAccessBindary: TSSecurityAccessBindary;
    FOnBeforeLogin: TBeforeLoginEvent;
    FOnAfterLogin: TAfterLoginEvent;
    FOnLogout: TLogoutEvent;
    FOnChangePassword: TChangePasswordEvent;
    FOnEncryptPassword: TEncryptPasswordEvent;
  protected
    procedure SetUsersBindary(_Value: TSUsersBindary);
    procedure SetGroupAccessBindary(_Value: TSGroupAccessBindary);
    procedure SetAccessBindary(_Value: TSSecurityAccessBindary);
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(_Component: TComponent; _Operation: TOperation); override;
    procedure Login(_UserName: String; _Password: String; _Access: TSSecurityAccess); override;
    procedure Logout; override;
    procedure ChangePassword(_UserName: String; _OldPassword: String; _NewPassword: String); override;
  published
    property UsersBindary: TSUsersBindary read FUsersBindary write SetUsersBindary;
    property GroupAccessBindary: TSGroupAccessBindary read FGroupAccessBindary write SetGroupAccessBindary;
    property AccessBindary: TSSecurityAccessBindary read FAccessBindary write SetAccessBindary;
    property OnBeforeLogin: TBeforeLoginEvent read FOnBeforeLogin write FOnBeforeLogin;
    property OnAfterLogin: TAfterLoginEvent read FOnAfterLogin write FOnAfterLogin;
    property OnLogout: TLogoutEvent read FOnLogout write FOnLogout;
    property OnChangePassword: TChangePasswordEvent read FOnChangePassword write FOnChangePassword;
    property OnEncryptPassword: TEncryptPasswordEvent read FOnEncryptPassword write FOnEncryptPassword;
  end;

implementation

uses SSecurityErrors;

// TSUserBindary //

procedure TSUsersBindary.Assign(_Source: TPersistent);
begin
  if _Source is TSUsersBindary then
  begin
    FUserIdField:= TSUsersBindary(_Source).UserIdField;
    FUserNameField:= TSUsersBindary(_Source).UserNameField;
    FPasswordField:= TSUsersBindary(_Source).PasswordField;
    FUsePassword:= TSUsersBindary(_Source).UsePassword;
    FUserNameCaseSens:= TSUsersBindary(_Source).UserNameCaseSens;
    SetDataSource(TSUsersBindary(_Source).DataSource);
  end
  else
    inherited Assign(_Source);
end;

constructor TSUsersBindary.Create(_Owner: TComponent);
begin
  inherited Create;
  Owner:= _Owner;
  FDataSource:= nil;
  FUserIdField:= 'ID';
  FUserNameField:= 'USERNAME';
  FPasswordField:= 'PASSWORD';
  FUsePassword:= False;
  FUserNameCaseSens:= False;
end;

function TSUsersBindary.GetOwner: TPersistent;
begin
  Result:= Owner;
end;

procedure TSUsersBindary.SetDataSource(_Value: TDataSource);
begin
  if _Value <> FDataSource then
  begin
    if Assigned(FDataSource) then
      Owner.RemoveFreeNotification(FDataSource);
    FDataSource:= _Value;
    if Assigned(FDataSource) then
      Owner.FreeNotification(FDataSource);
  end;
end;

destructor TSUsersBindary.Destroy;
begin
  inherited Destroy;
end;

// TSGroupAccessBindary //

procedure TSGroupAccessBindary.Assign(_Source: TPersistent);
begin
  if _Source is TSGroupAccessBindary then
  begin
    FGroupIdField:= TSGroupAccessBindary(_Source).GroupIdField;
    FUserIdField:= TSGroupAccessBindary(_Source).UserIdField;
    SetDataSource(TSGroupAccessBindary(_Source).DataSource);
  end
  else
    inherited Assign(_Source);
end;

constructor TSGroupAccessBindary.Create(_Owner: TComponent);
begin
  inherited Create;
  Owner:= _Owner;
  FDataSource:= nil;
  FGroupIdField:= 'GROUPID';
  FUserIdField:= 'USERID';
end;

destructor TSGroupAccessBindary.Destroy;
begin
  inherited Destroy;
end;

function TSGroupAccessBindary.GetOwner: TPersistent;
begin
  Result:= Owner;
end;

procedure TSGroupAccessBindary.SetDataSource(_Value: TDataSource);
begin
  if _Value <> FDataSource then
  begin
    if Assigned(FDataSource) then
      Owner.RemoveFreeNotification(FDataSource);
    FDataSource:= _Value;
    if Assigned(FDataSource) then
      Owner.FreeNotification(FDataSource);
  end;
end;

// TSSecurityAccessBindary //

procedure TSSecurityAccessBindary.Assign(_Source: TPersistent);
begin
  if _Source is TSSecurityAccessBindary then
  begin
    FGroupIdField:= TSSecurityAccessBindary(_Source).GroupIdField;
    FAccessField:= TSSecurityAccessBindary(_Source).AccessField;
    FIndexField:= TSSecurityAccessBindary(_Source).IndexField;
    SetDataSource(TSSecurityAccessBindary(_Source).DataSource);
  end
  else
    inherited Assign(_Source);
end;

constructor TSSecurityAccessBindary.Create(_Owner: TComponent);
begin
  inherited Create;
  Owner:= _Owner;
  FDataSource:= nil;
  FGroupIdField:= 'GROUPID';
  FAccessField:= 'ACCESS';
  FIndexField:= 'INDEX';
end;

destructor TSSecurityAccessBindary.Destroy;
begin
  inherited Destroy;
end;

function TSSecurityAccessBindary.GetOwner: TPersistent;
begin
  Result:= Owner;
end;

procedure TSSecurityAccessBindary.SetDataSource(_Value: TDataSource);
begin
  if _Value <> FDataSource then
  begin
    if Assigned(FDataSource) then
      Owner.RemoveFreeNotification(FDataSource);
    FDataSource:= _Value;
    if Assigned(FDataSource) then
      Owner.FreeNotification(FDataSource);
  end;
end;

// TSDBSecurityController //

procedure TSDBSecurityController.ChangePassword(_UserName: String; _OldPassword: String; _NewPassword: String);
var
  UserDataSet: TDataSet;
  LocateOptions: TLocateOptions;
  Password: String;
begin
  if not Assigned(FUsersBindary.DataSource) then
    raise Exception.Create(Format(SEInvalidProperty, ['UserBindary.DataSource']));
  if not (Assigned(FUsersBindary.DataSource.DataSet) and FUsersBindary.DataSource.DataSet.Active) then
    raise Exception.Create(Format(SEDataSetMustBeOpened, ['UserBindary.DataSource.DataSet']));
  if FUsersBindary.UsePassword then
  begin
    UserDataSet:= FUsersBindary.DataSource.DataSet;
    if FUsersBindary.UserNameCaseSens then
      LocateOptions:= [loCaseInsensitive]
    else
      LocateOptions:= [];
    if UserDataSet.Locate(FUsersBindary.UserNameField, _UserName, LocateOptions) then
    begin
      if Assigned(FOnEncryptPassword) then
        FOnEncryptPassword(Self, _OldPassword, Password)
      else
        Password:= _OldPassword;
      if UserDataSet[FUsersBindary.PasswordField] <> Password then
        raise Exception.Create(SEWrongPassword);
      if Assigned(FOnEncryptPassword) then
        FOnEncryptPassword(Self, _NewPassword, Password);
      UserDataSet.Edit;
      UserDataSet[FUsersBindary.PasswordField]:= Password;
      UserDataSet.Post;
    end
    else
      raise Exception.Create(Format(SEUserNotFound, [_UserName]));
  end;
  if Assigned(FOnChangePassword) then
    FOnChangePassword(Self, _OldPassword, _NewPassword);
end;

constructor TSDBSecurityController.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  FUsersBindary:= TSUsersBindary.Create(Self);
  FGroupAccessBindary:= TSGroupAccessBindary.Create(Self);
  FAccessBindary:= TSSecurityAccessBindary.Create(Self);
  FOnBeforeLogin:= nil;
  FOnAfterLogin:= nil;
  FOnLogout:= nil;
  FOnChangePassword:= nil;
  FOnEncryptPassword:= nil;
end;

destructor TSDBSecurityController.Destroy;
begin
  FUsersBindary.Free;
  FAccessBindary.Free;
  FGroupAccessBindary.Free;
  inherited Destroy;
end;

procedure TSDBSecurityController.Login(_UserName: String; _Password: String; _Access: TSSecurityAccess);
var
  UserDataSet: TDataSet;
  GroupAccessDataSet: TDataSet;
  AccessDataSet: TDataSet;
  LocateOptions: TLocateOptions;
  Password: String;
  UserId: Variant;
  GroupId: Variant;
begin
  if Assigned(FOnBeforeLogin) then
    FOnBeforeLogin(Self, _UserName, _Password);
  if not Assigned(FUsersBindary.DataSource) then
    raise Exception.Create(Format(SEInvalidProperty, ['UserBindary.DataSource']));
  if not (Assigned(FUsersBindary.DataSource.DataSet) and FUsersBindary.DataSource.DataSet.Active) then
    raise Exception.Create(Format(SEDataSetMustBeOpened, ['UserBindary.DataSource.DataSet']));
  if not Assigned(FGroupAccessBindary.DataSource) then
    raise Exception.Create(Format(SEInvalidProperty, ['GroupAccessBindary.DataSource']));
  if not (Assigned(FGroupAccessBindary.DataSource.DataSet) and FGroupAccessBindary.DataSource.DataSet.Active) then
    raise Exception.Create(Format(SEDataSetMustBeOpened, ['GroupAccessBindary.DataSource.DataSet']));
  if not Assigned(FAccessBindary.DataSource) then
    raise Exception.Create(Format(SEInvalidProperty, ['AccessBindary.DataSource']));
  if not (Assigned(FAccessBindary.DataSource.DataSet) and FAccessBindary.DataSource.DataSet.Active) then
    raise Exception.Create(Format(SEDataSetMustBeOpened, ['AccessBindary.DataSource.DataSet']));
  UserDataSet:= FUsersBindary.DataSource.DataSet;
  GroupAccessDataSet:= FGroupAccessBindary.DataSource.DataSet;
  AccessDataSet:= FAccessBindary.DataSource.DataSet;
  if FUsersBindary.UserNameCaseSens then
    LocateOptions:= [loCaseInsensitive]
  else
    LocateOptions:= [];
  if UserDataSet.Locate(FUsersBindary.UserNameField, _UserName, LocateOptions) then
  begin
    UserId:= UserDataSet[FUsersBindary.UserIdField];
    if FUsersBindary.UsePassword then
    begin
      if Assigned(FOnEncryptPassword) then
        FOnEncryptPassword(Self, _Password, Password)
      else
        Password:= _Password;
      if UserDataSet[FUsersBindary.PasswordField] <> Password then
        raise Exception.Create(SEWrongPassword);
    end;
    if GroupAccessDataSet.Locate(FGroupAccessBindary.UserIdField, UserId, []) then
    begin
      GroupAccessDataSet.First;
      while not GroupAccessDataSet.Eof do
      begin
        if GroupAccessDataSet[FGroupAccessBindary.UserIdField] = UserId then
        begin
          GroupId:= GroupAccessDataSet[FGroupAccessBindary.GroupIdField];
          if AccessDataSet.Locate(FAccessBindary.GroupIdField, GroupId, []) then
          begin
            AccessDataSet.First;
            while not AccessDataSet.Eof do
            begin
              if AccessDataSet[FAccessBindary.GroupIdField] = GroupId then
              begin
                if AccessDataSet[FAccessBindary.AccessField] <> 0 then
                  _Access.Access[AccessDataSet[FAccessBindary.IndexField]]:= True
                else
                  _Access.Access[AccessDataSet[FAccessBindary.IndexField]]:= False;
              end;
              AccessDataSet.Next;
            end;
          end;
        end;
        GroupAccessDataSet.Next;
      end;
    end;
  end
  else
    raise Exception.Create(Format(SEUserNotFound, [_UserName]));
  if Assigned(FOnAfterLogin) then
    FOnAfterLogin(Self);
end;

procedure TSDBSecurityController.Logout;
begin
  if Assigned(FOnLogout) then
    FOnLogout(Self);
end;

procedure TSDBSecurityController.Notification(_Component: TComponent; _Operation: TOperation);
begin
  inherited Notification(_Component, _Operation);
  if (_Operation = opRemove) and (_Component = FUsersBindary.FDataSource) then
    FUsersBindary.DataSource:= nil;
  if (_Operation = opRemove) and (_Component = FAccessBindary.FDataSource) then
    FAccessBindary.DataSource:= nil;
end;

procedure TSDBSecurityController.SetAccessBindary(_Value: TSSecurityAccessBindary);
begin
  FAccessBindary.Assign(_Value);
end;

procedure TSDBSecurityController.SetGroupAccessBindary(_Value: TSGroupAccessBindary);
begin
  FGroupAccessBindary.Assign(_Value);
end;

procedure TSDBSecurityController.SetUsersBindary(_Value: TSUsersBindary);
begin
  FUsersBindary.Assign(_Value);
end;

end.
