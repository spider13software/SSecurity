unit Requests;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Main, StdCtrls, SFormSecurity;

type
  TfRequests = class(TForm)
    FormSecurity: TSFormSecurity;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormSecurityLogin(_Sender: TObject);
    procedure FormSecurityLogout(_Sender: TObject);
  private
  public
  end;

implementation

{$R *.dfm}

procedure TfRequests.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfRequests.FormSecurityLogin(_Sender: TObject);
begin
  Caption:= 'Активно';
end;

procedure TfRequests.FormSecurityLogout(_Sender: TObject);
begin
  Caption:= 'Неактивно';
end;

end.
