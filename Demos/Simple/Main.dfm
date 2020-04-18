object fMain: TfMain
  Left = 333
  Top = 205
  Caption = 'SSecurity Simple Demo'
  ClientHeight = 366
  ClientWidth = 651
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object SecurityManager: TSSecurityManager
    AccessCount = 2
    OnLogin = SecurityManagerLogin
    UseController = False
    Left = 8
    Top = 8
  end
  object LoginForm: TSLoginForm
    SecurityManager = SecurityManager
    Retries = 2
    Caption = #1042#1093#1086#1076' '#1074' '#1089#1080#1089#1090#1077#1084#1091
    UserNameCaption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    PasswordCaption = #1055#1072#1088#1086#1083#1100':'
    LoginButtonCaption = #1042#1086#1081#1090#1080
    CancelButtonCaption = #1054#1090#1084#1077#1085#1072
    Left = 8
    Top = 40
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 96
    object miRegistration: TMenuItem
      Caption = 'Register'
      object miRegister: TMenuItem
        Caption = 'Login'
        OnClick = miRegisterClick
      end
      object miUnregister: TMenuItem
        Caption = 'Logout'
        OnClick = miUnregisterClick
      end
    end
    object miRequests: TMenuItem
      Caption = 'Requests'
      object miNewRequest: TMenuItem
        Caption = 'New'
        OnClick = miNewRequestClick
      end
      object miRequestsForm: TMenuItem
        Caption = 'Edit'
        OnClick = miRequestsFormClick
      end
    end
  end
  object MenuSecurity: TSMenuSecurity
    SecurityManager = SecurityManager
    Items = <
      item
        MenuItem = miUnregister
        Access = 0
        HideMethod = hmEnabled
        Invert = False
      end
      item
        MenuItem = miRegister
        Access = 0
        HideMethod = hmEnabled
        Invert = True
      end
      item
        MenuItem = miRequests
        Access = 0
        HideMethod = hmVisible
        Invert = False
      end
      item
        MenuItem = miNewRequest
        Access = 1
        HideMethod = hmEnabled
        Invert = False
      end>
    OnLogout = MenuSecurityLogout
    Left = 40
    Top = 96
  end
end
