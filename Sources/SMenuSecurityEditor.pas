// File: SMenuSecurityEditor.pas
// Version: 1.3
// Author: Spider13

unit SMenuSecurityEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SMenuSecurity, StdCtrls, ComCtrls, ImgList,
  ExtCtrls, Menus, Buttons, System.ImageList;

type
  TfSMenuSecurityEditor = class(TForm)
    ilComponents: TImageList;
    tvMenuItems: TTreeView;
    tvAcceptedMenuItems: TTreeView;
    bClose: TButton;
    bAcceptMenuItem: TSpeedButton;
    bUnacceptMenuItem: TSpeedButton;
    eAccess: TEdit;
    cbInvert: TCheckBox;
    cbInvertView: TCheckBox;
    eAccessView: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bAcceptMenuItemClick(Sender: TObject);
    procedure bUnacceptMenuItemClick(Sender: TObject);
    procedure tvAcceptedMenuItemsChange(Sender: TObject; Node: TTreeNode);
  private
  public
    MenuSecurity: TSMenuSecurity;
    Root: TComponent;
    constructor Create(_Owner: TComponent; _MenuSecurity: TSMenuSecurity; _Root: TComponent);
    destructor Destroy; override;
    function MenuItemAccepted(_MenuItem: TMenuItem; var _Item: TSMenuSecurityItem): Boolean;
  end;

var
  fSMenuSecurityEditor: TfSMenuSecurityEditor;

implementation

{$R *.dfm}

// TfSMenuSecurityEditor //

procedure TfSMenuSecurityEditor.bAcceptMenuItemClick(Sender: TObject);
var
  Item: TSMenuSecurityItem;
  Node: TTreeNode;
begin
  if Assigned(tvAcceptedMenuItems.Selected) then
  begin
    Item:= TSMenuSecurityItem(tvAcceptedMenuItems.Selected.Data);
    Node:= tvMenuItems.Items.AddObject(nil, Item.MenuItem.Name, Item.MenuItem);
    MenuSecurity.Items.Delete(Item.Index);
    tvAcceptedMenuItems.Selected.Delete;
  end;
end;

procedure TfSMenuSecurityEditor.bCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfSMenuSecurityEditor.bUnacceptMenuItemClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  Item: TSMenuSecurityItem;
  Node: TTreeNode;
begin
  if Assigned(tvMenuItems.Selected) then
  begin
    MenuItem:= TMenuItem(tvMenuItems.Selected.Data);
    Item:= TSMenuSecurityItem(MenuSecurity.Items.Add);
    Item.MenuItem:= MenuItem;
    Item.Access:= StrToInt(eAccess.Text);
    Item.Invert:= cbInvert.Checked;
    tvMenuItems.Selected.Delete;
    tvAcceptedMenuItems.Items.AddObject(nil, MenuItem.Name, Item);
  end;
end;

constructor TfSMenuSecurityEditor.Create(_Owner: TComponent; _MenuSecurity: TSMenuSecurity; _Root: TComponent);
begin
  MenuSecurity:= _MenuSecurity;
  Root:= _Root;
  inherited Create(_Owner);
end;

destructor TfSMenuSecurityEditor.Destroy;
begin
  inherited Destroy;
end;

procedure TfSMenuSecurityEditor.FormCreate(Sender: TObject);
var
  Index: Longint;
  Node: TTreeNode;
  MenuItem: TMenuItem;
  Item: TSMenuSecurityItem;
begin
  Caption:= 'Edit Permissions [' + MenuSecurity.Name + ']';
  for Index:= 0 to Root.ComponentCount - 1 do
  begin
    if (Root.Components[Index] is TMenuItem) and (Root.Components[Index].Name <> '') and (Root.Components[Index].ClassName <> '') then
    begin
      MenuItem:= Root.Components[Index] as TMenuItem;
      if MenuItemAccepted(MenuItem, Item) then
      begin
        Node:= tvAcceptedMenuItems.Items.AddChildObject(nil, MenuItem.Name, Item);
        Node.ImageIndex:= 0;
        Node.SelectedIndex:= 0;
      end
      else
      begin
        Node:= tvMenuItems.Items.AddChildObject(nil, MenuItem.Name, MenuItem);
        Node.ImageIndex:= 0;
        Node.SelectedIndex:= 0;
      end
    end;
  end;
end;

function TfSMenuSecurityEditor.MenuItemAccepted(_MenuItem: TMenuItem; var _Item: TSMenuSecurityItem): Boolean;
var
  Index: Longint;
  Item: TSMenuSecurityItem;
begin
  Result:= False;
  for Index := 0 to MenuSecurity.Items.Count - 1 do
  begin
    Item:= TSMenuSecurityItem(MenuSecurity.Items.Items[Index]);
    if Item.MenuItem = _MenuItem then
    begin
      Result:= True;
      _Item:= Item;
      Exit;
    end;
  end;
end;

procedure TfSMenuSecurityEditor.tvAcceptedMenuItemsChange(Sender: TObject; Node: TTreeNode);
begin
  eAccessView.Text:= IntToStr(TSMenuSecurityItem(Node.Data).Access);
  cbInvertView.Checked:= TSMenuSecurityItem(Node.Data).Invert;
end;

end.
