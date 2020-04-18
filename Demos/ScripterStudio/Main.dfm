object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Scripter Studio Demo'
  ClientHeight = 295
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 344
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Login procedure'
  end
  object mScript: TMemo
    Left = 8
    Top = 8
    Width = 281
    Height = 89
    Lines.Strings = (
      'uses SSecurity;'
      ''
      'begin'
      '  LoginForm.Execute();'
      'end;')
    TabOrder = 0
  end
  object bExecuteScript: TButton
    Left = 8
    Top = 103
    Width = 75
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 1
    OnClick = bExecuteScriptClick
  end
  object mLoginedScript: TMemo
    Left = 8
    Top = 134
    Width = 281
    Height = 121
    Lines.Strings = (
      'uses SSecurity;'
      ''
      'begin'
      '  if SecurityManager.Logined then'
      '    ShowMessage('#39'Logined'#39')'
      '  else'
      '    ShowMessage('#39'Not logined'#39');'
      'end;')
    TabOrder = 2
  end
  object bLoginedExecuteScript: TButton
    Left = 8
    Top = 261
    Width = 75
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 3
    OnClick = bLoginedExecuteScriptClick
  end
  object bChangePassword: TButton
    Left = 176
    Top = 262
    Width = 113
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100
    TabOrder = 4
    OnClick = bChangePasswordClick
  end
  object mLoginProcedure: TMemo
    Left = 344
    Top = 27
    Width = 337
    Height = 214
    Lines.Strings = (
      'uses SSecurity;'
      ''
      'function OnLogin(_Sender: TObject; _UserName: String; '
      '_Password: String; _Access: TSAccess);'
      'var'
      '  Index: Longint;'
      'begin'
      '  if (_UserName = '#39'ADMIN'#39') and (_Password = '#39'admin'#39') then'
      '  begin'
      '    for Index:= 1 to 5 do'
      '      _Access.SetAccess(Index,True);'
      '  end'
      '  else'
      '    raise('#39'Invalid UserName/Password'#39');'
      'end;')
    TabOrder = 5
  end
  object Button1: TButton
    Left = 214
    Top = 103
    Width = 75
    Height = 25
    Caption = #1042#1099#1081#1090#1080
    TabOrder = 6
    OnClick = Button1Click
  end
  object SecurityManager: TSSecurityManager
    AccessCount = 5
    OnLogin = SecurityManagerLogin
    UseController = False
    Left = 8
    Top = 8
  end
  object Scripter: TatScripter
    DefaultLanguage = slPascal
    SaveCompiledCode = False
    ShortBooleanEval = True
    LibOptions.SearchPath.Strings = (
      '$(CURDIR)'
      '$(APPDIR)')
    LibOptions.UseScriptFiles = False
    CallExecHookEvent = False
    Left = 8
    Top = 40
  end
  object LoginForm: TSLoginForm
    SecurityManager = SecurityManager
    Caption = 'Login'
    UserNameCaption = 'Username:'
    PasswordCaption = 'Password:'
    LoginButtonCaption = 'Login'
    CancelButtonCaption = 'Cancel'
    Left = 40
    Top = 8
  end
  object SFormSecurity1: TSFormSecurity
    SecurityManager = SecurityManager
    Items = <
      item
        Control = bChangePassword
        Access = 1
        HideMethod = hmEnabled
        Invert = False
      end
      item
        Control = mLoginedScript
        Access = 1
        HideMethod = hmEnabled
        Invert = False
      end
      item
        Control = bLoginedExecuteScript
        Access = 1
        HideMethod = hmEnabled
        Invert = False
      end
      item
        Control = mLoginProcedure
        Access = 0
        HideMethod = hmEnabled
        Invert = True
      end
      item
        Control = Label1
        Access = 0
        HideMethod = hmEnabled
        Invert = True
      end>
    Left = 40
    Top = 40
  end
  object ChangePasswordForm: TSChangePasswordForm
    SecurityManager = SecurityManager
    Caption = 'Change password'
    CurrentPasswordCaption = 'Current password:'
    NewPassword = 'New password:'
    ConfirmPassword = 'Confirm password:'
    ApplyButtonCaption = 'Change'
    CancelButtonCaption = 'Cancel'
    Left = 72
    Top = 8
  end
  object LoginScripter: TatScripter
    DefaultLanguage = slPascal
    SaveCompiledCode = False
    ShortBooleanEval = True
    LibOptions.SearchPath.Strings = (
      '$(CURDIR)'
      '$(APPDIR)')
    LibOptions.UseScriptFiles = False
    CallExecHookEvent = False
    Left = 352
    Top = 16
  end
end
