// File: SSecurityController.pas
// Version: 1.3
// Author: Spider13

unit SSecurityController;

interface

uses SysUtils, Classes, SSecurityCommon;

type
  TSSecurityController = class(TComponent)
  private
    FAccessCount: Longint;
  protected
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    procedure Login(_UserName: String; _Password: String; _Access: TSSecurityAccess); virtual; abstract;
    procedure Logout; virtual; abstract;
    procedure ChangePassword(_UserName: String; _OldPassword: String; _NewPassword: String); virtual; abstract;
  published
    property AccessCount: Longint read FAccessCount write FAccessCount;
  end;

implementation

// TSSecurityController //

constructor TSSecurityController.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
  FAccessCount:= 0;
end;

destructor TSSecurityController.Destroy;
begin
  inherited Destroy;
end;

end.

