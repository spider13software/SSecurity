// Файл: SFormSecurity.pas
// Версия: 1.3
// Автор: Spider13

unit SFormSecurity;

interface

uses Classes, Vcl.Controls, SSecurityManager, SSecurityCommon;

type
  TSFormSecurityLink = class;
  TSFormSecurity = class;
  TSFormSecurityItem = class;
  TSFormSecurityItems = class;

  TSFormSecurityLink = class(TSSecurityLink)
  private
    FormSecurity: TSFormSecurity;
  public
    constructor Create(_FormSecurity: TSFormSecurity);
    procedure LoginEvent; override;
    procedure LogoutEvent; override;
    destructor Destroy; override;
  end;

  TSFormSecurityItem = class(TCollectionItem)
  private
    FHideMethod: THideMethod;
    FControl: TControl;
    FAccess: Longint;
    FInvert: Boolean;
  public
    constructor Create(_Collection: TCollection);
    procedure Assign(_Source: TPersistent); override;
    destructor Destroy;
  published
    property Control: TControl read FControl write FControl;
    property Access: Longint read FAccess write FAccess;
    property HideMethod: THideMethod read FHideMethod write FHideMethod;
    property Invert: Boolean read FInvert write FInvert;
  end;

  TSFormSecurityItems = class(TOwnedCollection)
  protected
    function GetItem(_Index: Longint): TSFormSecurityItem;
  public
    function Add: TSFormSecurityItem;
    property Items[_Index: Longint]: TSFormSecurityItem read GetItem; default;
  end;

  TSFormSecurity = class(TComponent)
  private
    Link: TSFormSecurityLink;
    FItems: TSFormSecurityItems;
    FSecurityManager: TSSecurityManager;
    FOnLogin: TLoginEvent;
    FOnLogout: TLogoutEvent;
  protected
    function GetSecurityManager: TSSecurityManager;
    procedure SetSecurityManager(_Value: TSSecurityManager);
    procedure SetItems(_Value: TSFormSecurityItems);
  public
    constructor Create(_Owner: TComponent); override;
    procedure Notification(_Component: TComponent; _Operation: TOperation); override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure UpdateControls;
    procedure LoginEvent;
    procedure LogoutEvent;
  published
    property SecurityManager: TSSecurityManager read GetSecurityManager write SetSecurityManager;
    property Items: TSFormSecurityItems read FItems write SetItems;
    property OnLogin: TLoginEvent read FOnLogin write FOnLogin;
    property OnLogout: TLogoutEvent read FOnLogout write FOnLogout;
  end;

implementation

// TSFormSecurityLink //

constructor TSFormSecurityLink.Create(_FormSecurity: TSFormSecurity);
begin
  inherited Create();
  FormSecurity:= _FormSecurity;
end;

destructor TSFormSecurityLink.Destroy;
begin
  inherited Destroy();
end;

procedure TSFormSecurityLink.LoginEvent;
begin
  FormSecurity.LoginEvent;
end;

procedure TSFormSecurityLink.LogoutEvent;
begin
  FormSecurity.LogoutEvent;
end;

// TSFormSecurityItem //

procedure TSFormSecurityItem.Assign(_Source: TPersistent);
begin
  if _Source is TSFormSecurityItem then
  begin
    FControl:= TSFormSecurityItem(_Source).Control;
    FAccess:= TSFormSecurityItem(_Source).Access;
    FInvert:= TSFormSecurityItem(_Source).Invert;
    FHideMethod:= TSFormSecurityItem(_Source).HideMethod;
  end
  else
    inherited Assign(_Source);
end;

constructor TSFormSecurityItem.Create(_Collection: TCollection);
begin
  inherited Create(_Collection);
  FControl:= nil;
  FAccess:= 0;
  FHideMethod:= hmEnabled;
  FInvert:= False;
end;

destructor TSFormSecurityItem.Destroy;
begin
  inherited Destroy;
end;

// TSFormSecurityItems //

function TSFormSecurityItems.GetItem(_Index: Integer): TSFormSecurityItem;
begin
  Result:= TSFormSecurityItem(inherited Items[_Index]);
end;

function TSFormSecurityItems.Add: TSFormSecurityItem;
begin
  Result:= TSFormSecurityItem(inherited Add);
end;

// TSFormSecurity //

constructor TSFormSecurity.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  Link:= TSFormSecurityLink.Create(Self);
  FItems:= TSFormSecurityItems.Create(Self, TSFormSecurityItem);
  FOnLogin:= nil;
  FOnLogout:= nil;
end;

destructor TSFormSecurity.Destroy;
begin
  FItems.Free;
  Link.Free;
  inherited Destroy;
end;

function TSFormSecurity.GetSecurityManager: TSSecurityManager;
begin
  Result:= Link.SecurityManager;
end;

procedure TSFormSecurity.Loaded;
begin
  inherited Loaded;
  Link.UpdateState;
end;

procedure TSFormSecurity.LoginEvent;
begin
  UpdateControls;
  if Assigned(FOnLogin) then
    FOnLogin(Self);
end;

procedure TSFormSecurity.LogoutEvent;
begin
  UpdateControls;
  if Assigned(FOnLogout) then
    FOnLogout(Self);
end;

procedure TSFormSecurity.Notification(_Component: TComponent; _Operation: TOperation);
begin
  inherited Notification(_Component, _Operation);
  if (_Operation = opRemove) and (_Component = Link.SecurityManager) then
    Link.SecurityManager:= nil;
end;

procedure TSFormSecurity.SetItems(_Value: TSFormSecurityItems);
begin
  if _Value <> FItems then
    FItems.Assign(_Value);
end;

procedure TSFormSecurity.SetSecurityManager(_Value: TSSecurityManager);
begin
  if _Value <> Link.SecurityManager then
  begin
    if Assigned(Link.SecurityManager) then
      RemoveFreeNotification(Link.SecurityManager);
    Link.SecurityManager:= _Value;
    if Assigned(Link.SecurityManager) then
      FreeNotification(Link.SecurityManager);
  end;
end;

procedure TSFormSecurity.UpdateControls;
var
  Index: Longint;
  Item: TSFormSecurityItem;
  Value: Boolean;
begin
  if not (csDesigning in ComponentState) then
  begin
    for Index:= 0 to FItems.Count - 1 do
    begin
      Item:= TSFormSecurityItem(FItems.Items[Index]);
      Value:= Link.Logined and Link.SecurityManager.Access[Item.Access];
      if Item.Invert then
        Value:= not Value;
      case Item.HideMethod of
        hmEnabled: Item.Control.Enabled:= Value;
        hmVisible: Item.Control.Visible:= Value;
      end;
    end;
  end;
end;

end.
