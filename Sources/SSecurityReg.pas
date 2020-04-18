// File: SSecurityManager.pas
// Version: 1.3
// Author: Spider13

unit SSecurityReg;

interface

uses Classes, SSecurityManager, SMenuSecurity, SFormSecurity, SLoginForm,
     SChangePasswordForm, SDBSecurityController, DesignEditors, DesignIntf,
     SSecurityEditors;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SSecurity', [TSSecurityManager]);
  RegisterComponents('SSecurity', [TSLoginForm]);
  RegisterComponents('SSecurity', [TSFormSecurity]);
  RegisterComponents('SSecurity', [TSMenuSecurity]);
  RegisterComponents('SSecurity', [TSChangePasswordForm]);
  RegisterComponents('SSecurity', [TSDBSecurityController]);
  RegisterComponentEditor(TSMenuSecurity, TSMenuSecurityEditor);
  RegisterComponentEditor(TSFormSecurity, TSFormSecurityEditor);
end;

end.
