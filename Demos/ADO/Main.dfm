object fMain: TfMain
  Left = 239
  Top = 146
  Caption = 'SSecurity Demo'
  ClientHeight = 370
  ClientWidth = 659
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
    SecurityController = SDBSecurityController1
    UseController = True
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
    Top = 72
  end
  object MainMenu: TMainMenu
    Left = 88
    Top = 8
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
      object miChangePassword: TMenuItem
        Caption = 'Change password'
        OnClick = miChangePasswordClick
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
    object miPermissions: TMenuItem
      Caption = 'Permissions'
      object miPermissions1: TMenuItem
        Caption = 'Permission 1'
        OnClick = miPermissions1Click
      end
      object miPermissions2: TMenuItem
        Caption = 'Permission 2'
        OnClick = miPermissions2Click
      end
      object miPermissions3: TMenuItem
        Caption = 'Permission 3'
        OnClick = miPermissions3Click
      end
      object miPermissions4: TMenuItem
        Caption = 'Permission 4'
        OnClick = miPermissions4Click
      end
      object miPermissions5: TMenuItem
        Caption = 'Permission 5'
        OnClick = miPermissions5Click
      end
    end
  end
  object MenuSecurity: TSMenuSecurity
    SecurityManager = SecurityManager
    Items = <
      item
        MenuItem = miChangePassword
        Access = 0
        HideMethod = hmEnabled
        Invert = False
      end
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
      end
      item
        MenuItem = miPermissions
        Access = 0
        HideMethod = hmEnabled
        Invert = False
      end
      item
        MenuItem = miPermissions1
        Access = 1
        HideMethod = hmEnabled
        Invert = False
      end
      item
        MenuItem = miPermissions2
        Access = 2
        HideMethod = hmEnabled
        Invert = False
      end
      item
        MenuItem = miPermissions3
        Access = 3
        HideMethod = hmEnabled
        Invert = False
      end
      item
        MenuItem = miPermissions4
        Access = 4
        HideMethod = hmEnabled
        Invert = False
      end
      item
        MenuItem = miPermissions5
        Access = 5
        HideMethod = hmEnabled
        Invert = False
      end>
    OnLogout = MenuSecurityLogout
    Left = 120
    Top = 8
  end
  object ChangePasswordForm: TSChangePasswordForm
    SecurityManager = SecurityManager
    Caption = #1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103
    CurrentPasswordCaption = #1058#1077#1082#1091#1097#1080#1081' '#1087#1072#1088#1086#1083#1100':'
    NewPassword = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100':'
    ConfirmPassword = #1055#1086#1074#1090#1086#1088' '#1087#1072#1088#1086#1083#1103':'
    ApplyButtonCaption = #1055#1088#1080#1085#1103#1090#1100
    CancelButtonCaption = #1054#1090#1084#1077#1085#1072
    Left = 8
    Top = 40
  end
  object SDBSecurityController1: TSDBSecurityController
    AccessCount = 5
    UsersBindary.DataSource = dsUsers
    UsersBindary.UserIdField = 'USERID'
    UsersBindary.UserNameField = 'USERNAME'
    UsersBindary.PasswordField = 'PASSWORD'
    UsersBindary.UsePassword = True
    UsersBindary.UserNameCaseSens = False
    GroupAccessBindary.DataSource = dsGroupAccess
    GroupAccessBindary.GroupIdField = 'GROUPID'
    GroupAccessBindary.UserIdField = 'USERID'
    AccessBindary.DataSource = dsAccess
    AccessBindary.AccessField = 'ACCESS'
    AccessBindary.IndexField = 'INDEX'
    AccessBindary.GroupIdField = 'GROUPID'
    OnBeforeLogin = SDBSecurityController1BeforeLogin
    OnLogout = SDBSecurityController1Logout
    OnEncryptPassword = SDBSecurityController1EncryptPassword
    Left = 40
    Top = 8
  end
  object Connection: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\!projects\SSecur' +
      'ity\Demos\ADO\Data\Data.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 104
  end
  object tUsers: TADOTable
    Active = True
    Connection = Connection
    CursorType = ctStatic
    TableName = 'USERS'
    Left = 8
    Top = 136
    object tUsersUSERID: TAutoIncField
      FieldName = 'USERID'
      ReadOnly = True
    end
    object tUsersUSERNAME: TWideStringField
      FieldName = 'USERNAME'
      Size = 50
    end
    object tUsersPASSWORD: TWideStringField
      FieldName = 'PASSWORD'
      Size = 50
    end
    object tUsersFIRSTNAME: TWideStringField
      FieldName = 'FIRSTNAME'
      Size = 50
    end
    object tUsersLASTNAME: TWideStringField
      FieldName = 'LASTNAME'
      Size = 50
    end
  end
  object dsUsers: TDataSource
    AutoEdit = False
    DataSet = tUsers
    Left = 40
    Top = 136
  end
  object tAccess: TADOTable
    Active = True
    Connection = Connection
    CursorType = ctStatic
    TableName = 'ACCESS'
    Left = 8
    Top = 200
    object tAccessACCESSID: TAutoIncField
      FieldName = 'ACCESSID'
      ReadOnly = True
    end
    object tAccessINDEX: TIntegerField
      FieldName = 'INDEX'
    end
    object tAccessACCESS: TIntegerField
      FieldName = 'ACCESS'
    end
    object tAccessGROUPID: TIntegerField
      FieldName = 'GROUPID'
    end
  end
  object dsAccess: TDataSource
    AutoEdit = False
    DataSet = tAccess
    Left = 40
    Top = 200
  end
  object tGroupAccess: TADOTable
    Active = True
    Connection = Connection
    CursorType = ctStatic
    TableName = 'GROUPACCESS'
    Left = 8
    Top = 168
    object tGroupAccessID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object tGroupAccessUSERID: TIntegerField
      FieldName = 'USERID'
    end
    object tGroupAccessGROUPID: TIntegerField
      FieldName = 'GROUPID'
    end
  end
  object dsGroupAccess: TDataSource
    AutoEdit = False
    DataSet = tGroupAccess
    Left = 40
    Top = 168
  end
end
