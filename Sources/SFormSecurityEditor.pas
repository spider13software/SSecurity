// File: SFormSecurityEditor.pas
// Version: 1.3
// Author: Spider13

unit SFormSecurityEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, SFormSecurity,
  StdCtrls, Buttons, System.ImageList;

type
  TfSFormSecurityEditor = class(TForm)
    ilComponents: TImageList;
    tvAcceptedControls: TTreeView;
    tvControls: TTreeView;
    bClose: TButton;
    cbInvertView: TCheckBox;
    eAccessView: TEdit;
    bAcceptMenuItem: TSpeedButton;
    bUnacceptMenuItem: TSpeedButton;
    eAccess: TEdit;
    cbInvert: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure tvAcceptedControlsChange(Sender: TObject; Node: TTreeNode);
    procedure bAcceptMenuItemClick(Sender: TObject);
    procedure bUnacceptMenuItemClick(Sender: TObject);
  private
  public
    Root: TComponent;
    FormSecurity: TSFormSecurity;
    constructor Create(_Owner: TComponent; _FormSecurity: TSFormSecurity; _Root: TComponent);
    function ControlAccepted(_Control: TControl; var _Item: TSFormSecurityItem): Boolean;
  end;

implementation

{$R *.dfm}

// TfSFormSecurityEditor //

procedure TfSFormSecurityEditor.bAcceptMenuItemClick(Sender: TObject);
var
  Item: TSFormSecurityItem;
  Node: TTreeNode;
  Control: TControl;
begin
  if Assigned(tvAcceptedControls.Selected) then
  begin
    Item:= TSFormSecurityItem(tvAcceptedControls.Selected.Data);
    Control:= Item.Control;
    Node:= tvControls.Items.AddObject(nil, Format('%s [%s]', [Control.Name, Control.ClassName]), Item.Control);
    FormSecurity.Items.Delete(Item.Index);
    tvAcceptedControls.Selected.Delete;
  end;
end;

procedure TfSFormSecurityEditor.bCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfSFormSecurityEditor.bUnacceptMenuItemClick(Sender: TObject);
var
  Control: TControl;
  Item: TSFormSecurityItem;
  Node: TTreeNode;
begin
  if Assigned(tvControls.Selected) then
  begin
    Control:= TControl(tvControls.Selected.Data);
    Item:= TSFormSecurityItem(FormSecurity.Items.Add);
    Item.Control:= Control;
    Item.Access:= StrToInt(eAccess.Text);
    Item.Invert:= cbInvert.Checked;
    tvControls.Selected.Delete;
    tvAcceptedControls.Items.AddObject(nil, Format('%s [%s]', [Control.Name, Control.ClassName]), Item);
  end;
end;

function TfSFormSecurityEditor.ControlAccepted(_Control: TControl; var _Item: TSFormSecurityItem): Boolean;
var
  Index: Longint;
  Item: TSFormSecurityItem;
begin
  Result:= False;
  for Index := 0 to FormSecurity.Items.Count - 1 do
  begin
    Item:= TSFormSecurityItem(FormSecurity.Items.Items[Index]);
    if Item.Control = _Control then
    begin
      Result:= True;
      _Item:= Item;
      Exit;
    end;
  end;
end;

constructor TfSFormSecurityEditor.Create(_Owner: TComponent; _FormSecurity: TSFormSecurity; _Root: TComponent);
begin
  Root:= _Root;
  FormSecurity:= _FormSecurity;
  inherited Create(_Owner);
end;

procedure TfSFormSecurityEditor.FormCreate(Sender: TObject);
var
  Index: Longint;
  Control: TControl;
  Node: TTreeNode;
  Item: TSFormSecurityItem;
begin
  Caption:= 'Edit Permissions [' + FormSecurity.Name + ']';
  for Index:= 0 to Root.ComponentCount - 1 do
  begin
    if (Root.Components[Index] is TControl) and (Root.Components[Index].Name <> '') and (Root.Components[Index].ClassName <> '') then
    begin
      Control:= Root.Components[Index] as TControl;
      if ControlAccepted(Control, Item) then
      begin
        Node:= tvAcceptedControls.Items.AddObject(nil, Format('%s [%s]', [Control.Name, Control.ClassName]), Item);
        Node.ImageIndex:= 0;
        Node.SelectedIndex:= 0;
      end
      else
      begin
        Node:= tvControls.Items.AddObject(nil, Format('%s [%s]', [Control.Name, Control.ClassName]), Control);
        Node.ImageIndex:= 0;
        Node.SelectedIndex:= 0;
      end;
    end;
  end;
end;

procedure TfSFormSecurityEditor.tvAcceptedControlsChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) then
  begin
    eAccessView.Text:= IntToStr(TSFormSecurityItem(Node.Data).Access);
    cbInvertView.Checked:= TSFormSecurityItem(Node.Data).Invert;
  end
  else
  begin
    eAccessView.Text:= '-';
    cbInvertView.Checked:= False;
  end;
end;

end.
