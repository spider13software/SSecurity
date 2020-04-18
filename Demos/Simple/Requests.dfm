object fRequests: TfRequests
  Left = 626
  Top = 416
  Width = 144
  Height = 106
  Caption = #1047#1072#1103#1074#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 121
    Height = 25
    Caption = 'New request'
    TabOrder = 0
  end
  object Button2: TButton
    Left = 8
    Top = 39
    Width = 121
    Height = 25
    Caption = 'Delete request'
    TabOrder = 1
  end
  object FormSecurity: TSFormSecurity
    SecurityManager = fMain.SecurityManager
    Items = <
      item
        Control = Button1
        Access = 1
        HideMethod = hmEnabled
        Invert = False
      end
      item
        Control = Button2
        Access = 2
        HideMethod = hmEnabled
        Invert = False
      end>
    OnLogin = FormSecurityLogin
    OnLogout = FormSecurityLogout
    Left = 8
    Top = 8
  end
end
