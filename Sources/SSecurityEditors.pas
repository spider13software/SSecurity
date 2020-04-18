// File: SSecurityEditors.pas
// Version: 1.3
// Author: Spider13

unit SSecurityEditors;

interface

uses Classes, DesignIntf, DesignEditors, Forms, SMenuSecurity, SMenuSecurityEditor,
     SFormSecurity, SFormSecurityEditor, Menus;

type
  TSSecirutyManagerEditor = class(TDefaultEditor)
  end;

type
  TSMenuSecurityEditor = class(TDefaultEditor)
  public
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

type
  TSFormSecurityEditor = class(TDefaultEditor)
  public
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

implementation

// TSMenuSecurityEditor //

procedure TSMenuSecurityEditor.ExecuteVerb(Index: Integer);
var
  MenuSecurityEditor: TfSMenuSecurityEditor;
  MenuSecurity: TSMenuSecurity;
  Root: TComponent;
begin
  case Index of
    0: if Component is TSMenuSecurity then
       begin
         MenuSecurity:= Component as TSMenuSecurity;
         Root:= Designer.Root;
         MenuSecurityEditor:= TfSMenuSecurityEditor.Create(Application, MenuSecurity, Root);
         MenuSecurityEditor.ShowModal;
         MenuSecurityEditor.Free;
       end;
  end;
end;

function TSMenuSecurityEditor.GetVerb(Index: Integer): String;
begin
  case Index of
    0: Result:= 'Edit Permissions';
  end;
end;

function TSMenuSecurityEditor.GetVerbCount: Integer;
begin
  Result:= 1;
end;

// TSFormSecurityEditor //

procedure TSFormSecurityEditor.ExecuteVerb(Index: Integer);
var
  FormSecurityEditor: TfSFormSecurityEditor;
  FormSecurity: TSFormSecurity;
  Root: TComponent;
begin
  case Index of
    0: if Component is TSFormSecurity then
       begin
         FormSecurity:= Component as TSFormSecurity;
         Root:= Designer.Root;
         FormSecurityEditor:= TfSFormSecurityEditor.Create(Application, FormSecurity, Root);
         FormSecurityEditor.ShowModal;
         FormSecurityEditor.Free;
       end;
  end;
end;

function TSFormSecurityEditor.GetVerb(Index: Integer): String;
begin
  case Index of
    0: Result:= 'Edit Permissions';
  end;
end;

function TSFormSecurityEditor.GetVerbCount: Integer;
begin
  Result:= 1;
end;

end.
