// Файл: SMenuSecurity.pas
// Версия: 1.3
// Автор: Spider13

unit SMenuSecurity;

interface

uses Classes, Vcl.Menus, SSecurityManager, SSecurityCommon;

type
  TSMenuSecurityLink = class;
  TSMenuSecurity = class;
  TSMenuSecurityItem = class;
  TSMenuSecurityItems = class;

  TSMenuSecurityLink = class(TSSecurityLink)
  private
    MenuSecurity: TSMenuSecurity;
  public
    constructor Create(_MenuSecurity: TSMenuSecurity);
    procedure LoginEvent; override;
    procedure LogoutEvent; override;
    destructor Destroy; override;
  end;

  TSMenuSecurityItem = class(TCollectionItem)
  private
    FHideMethod: THideMethod;
    FMenuItem: TMenuItem;
    FAccess: Longint;
    FInvert: Boolean;
  public
    constructor Create(_Collection: TCollection);
    procedure Assign(_Source: TPersistent); override;
    destructor Destroy;
  published
    property MenuItem: TMenuItem read FMenuItem write FMenuItem;
    property Access: Longint read FAccess write FAccess;
    property HideMethod: THideMethod read FHideMethod write FHideMethod;
    property Invert: Boolean read FInvert write FInvert;
  end;

  TSMenuSecurityItems = class(TOwnedCollection)
  protected
    function GetItem(_Index: Longint): TSMenuSecurityItem;
  public
    function Add: TSMenuSecurityItem;
    property Items[_Index: Longint]: TSMenuSecurityItem read GetItem; default;
  end;

  TSMenuSecurity = class(TComponent)
  private
    Link: TSMenuSecurityLink;
    FItems: TSMenuSecurityItems;
    FOnLogin: TLoginEvent;
    FOnLogout: TLogoutEvent;
  protected
    function GetSecurityManager: TSSecurityManager;
    procedure SetSecurityManager(_Value: TSSecurityManager);
    procedure SetItems(_Value: TSMenuSecurityItems);
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
    property Items: TSMenuSecurityItems read FItems write SetItems;
    property OnLogin: TLoginEvent read FOnLogin write FOnLogin;
    property OnLogout: TLogoutEvent read FOnLogout write FOnLogout;
  end;

implementation

// TSMenuSecurityLink //

constructor TSMenuSecurityLink.Create(_MenuSecurity: TSMenuSecurity);
begin
  inherited Create;
  MenuSecurity:= _MenuSecurity;
end;

destructor TSMenuSecurityLink.Destroy;
begin
  inherited;
end;

procedure TSMenuSecurityLink.LoginEvent;
begin
  MenuSecurity.LoginEvent;
end;

procedure TSMenuSecurityLink.LogoutEvent;
begin
  MenuSecurity.LogoutEvent;
end;

// TSMenuSecurityItem //

procedure TSMenuSecurityItem.Assign(_Source: TPersistent);
begin
  if _Source is TSMenuSecurityItem then
  begin
    FMenuItem:= TSMenuSecurityItem(_Source).MenuItem;
    FAccess:= TSMenuSecurityItem(_Source).Access;
    FInvert:= TSMenuSecurityItem(_Source).Invert;
    FHideMethod:= TSMenuSecurityItem(_Source).HideMethod;
  end
  else
    inherited Assign(_Source);
end;

constructor TSMenuSecurityItem.Create(_Collection: TCollection);
begin
  inherited Create(_Collection);
  FMenuItem:= nil;
  FAccess:= 0;
  FInvert:= False;
  FHideMethod:= hmEnabled;
end;

destructor TSMenuSecurityItem.Destroy;
begin
  inherited Destroy;
end;

// TSMenuSecurityItems //

function TSMenuSecurityItems.Add: TSMenuSecurityItem;
begin
  Result:= TSMenuSecurityItem(inherited Add);
end;

function TSMenuSecurityItems.GetItem(_Index: Integer): TSMenuSecurityItem;
begin
  Result:= TSMenuSecurityItem(inherited Items[_Index]);
end;

// TSMenuSecurity //

constructor TSMenuSecurity.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  Link:= TSMenuSecurityLink.Create(Self);
  FItems:= TSMenuSecurityItems.Create(Self, TSMenuSecurityItem);
  FOnLogin:= nil;
  FOnLogout:= nil;
end;

destructor TSMenuSecurity.Destroy;
begin
  FItems.Free;
  Link.Free;
  inherited Destroy;
end;

function TSMenuSecurity.GetSecurityManager: TSSecurityManager;
begin
  Result:= Link.SecurityManager;
end;

procedure TSMenuSecurity.Loaded;
begin
  inherited Loaded;
  Link.UpdateState;
end;

procedure TSMenuSecurity.LoginEvent;
begin
  UpdateControls;
  if Assigned(FOnLogin) then
    FOnLogin(Self);
end;

procedure TSMenuSecurity.LogoutEvent;
begin
  UpdateControls;
  if Assigned(FOnLogout) then
    FOnLogout(Self);
end;

procedure TSMenuSecurity.Notification(_Component: TComponent; _Operation: TOperation);
begin
  inherited Notification(_Component, _Operation);
  if (_Operation = opRemove) and (_Component = Link.SecurityManager) then
    Link.SecurityManager:= nil;
end;

procedure TSMenuSecurity.SetItems(_Value: TSMenuSecurityItems);
begin
  if _Value <> FItems then
    FItems.Assign(_Value);
end;

procedure TSMenuSecurity.SetSecurityManager(_Value: TSSecurityManager);
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

procedure TSMenuSecurity.UpdateControls;
var
  Index: Longint;
  Item: TSMenuSecurityItem;
  Value: Boolean;
begin
  if not (csDesigning in ComponentState) then
  begin
    for Index:= 0 to FItems.Count - 1 do
    begin
      Item:= TSMenuSecurityItem(FItems.Items[Index]);
      Value:= Link.Logined and Link.SecurityManager.Access[Item.Access];
      if Item.Invert then
        Value:= not Value;
      case Item.HideMethod of
        hmEnabled: Item.MenuItem.Enabled:= Value;
        hmVisible: Item.MenuItem.Visible:= Value;
      end;
    end;
  end;
end;

end.
