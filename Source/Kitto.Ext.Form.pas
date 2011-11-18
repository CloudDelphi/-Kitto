{-------------------------------------------------------------------------------
   Copyright 2011 Ethea S.r.l.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-------------------------------------------------------------------------------}

unit Kitto.Ext.Form;

{$I Kitto.Defines.inc}

interface

uses
  Generics.Collections,
  Ext, ExtData, ExtForm,
  EF.ObserverIntf,
  Kitto.Metadata.Views, Kitto.Metadata.DataView, Kitto.Store,
  Kitto.Ext.Controller, Kitto.Ext.Base, Kitto.Ext.DataPanel, Kitto.Ext.Editors,
  Kitto.Ext.GridPanel;

type
  ///	<summary>
  ///	  A button that opens a popup detail form.
  ///	</summary>
  TKExtDetailFormButton = class(TExtButton)
  private
    FViewTable: TKViewTable;
    FDetailHostWindow: TKExtModalWindow;
    FServerStore: TKViewTableStore;
    procedure SetViewTable(const AValue: TKViewTable);
  public
    destructor Destroy; override;
    property ViewTable: TKViewTable read FViewTable write SetViewTable;
    property ServerStore: TKViewTableStore read FServerStore write FServerStore;
  published
    procedure ShowDetailWindow;
  end;

  ///	<summary>
  ///	  The Form controller.
  ///	</summary>
  TKExtFormPanelController = class(TKExtDataPanelController)
  private
    FTabPanel: TExtTabPanel;
    FFormPanel: TKExtEditPanel;
    FIsReadOnly: Boolean;
    FSaveButton: TExtButton;
    FCancelButton: TExtButton;
    FDetailToolbar: TExtToolbar;
    FDetailButtons: TObjectList<TKExtDetailFormButton>;
    FDetailPanels: TObjectList<TKExtGridPanel>;
    FOperation: string;
    FFocusField: TExtFormField;
    FStoreRecord: TKViewTableRecord;
    FEditors: TList<IKExtEditor>;
    procedure CreateEditors(const AForceReadOnly: Boolean);
    procedure StartOperation;
    procedure FocusFirstField;
    procedure CreateDetailPanels;
    procedure CreateDetailToolbar;
    procedure LoadDetailData;
    function GetDetailStyle: string;
    procedure OnFieldChange(AField: TExtFormField; ANewValue, AOldValue: string);
    function FindEditor(const AFieldName: string): IKExtEditor;
  protected
    procedure LoadData; override;
    procedure InitComponents; override;
    function AutoLoadData: Boolean; override;
  public
    destructor Destroy; override;
  published
    procedure GetRecord;
    procedure SaveChanges;
    procedure CancelChanges;
  end;

implementation

uses
  SysUtils, StrUtils,
  EF.Localization, EF.Types, EF.Intf, EF.Tree, EF.DB,
  Kitto.AccessControl, Kitto.JSON, Kitto.Rules, Kitto.SQL,
  Kitto.Ext.Session, Kitto.Ext.Utils;

{ TKExtFormPanelController }

destructor TKExtFormPanelController.Destroy;
begin
  FreeAndNil(FEditors);
  FreeAndNil(FDetailButtons);
  FreeAndNil(FDetailPanels);
  inherited;
end;

procedure TKExtFormPanelController.CreateDetailToolbar;
var
  I: Integer;
begin
  Assert(ViewTable <> nil);
  Assert(FDetailToolbar = nil);
  Assert(FDetailButtons = nil);
  Assert(Assigned(FStoreRecord));

  if ViewTable.DetailTableCount > 0 then
  begin
    FStoreRecord.EnsureDetailStores;
    Assert(FStoreRecord.DetailStoreCount = ViewTable.DetailTableCount);
    FDetailToolbar := TExtToolbar.Create;
    FDetailButtons := TObjectList<TKExtDetailFormButton>.Create(False);
    for I := 0 to ViewTable.DetailTableCount - 1 do
    begin
      FDetailButtons.Add(TKExtDetailFormButton.AddTo(FDetailToolbar.Items));
      FDetailButtons[I].ServerStore := FStoreRecord.DetailStores[I];
      FDetailButtons[I].ViewTable := ViewTable.DetailTables[I];
    end;
    Tbar := FDetailToolbar;
  end;
end;

procedure TKExtFormPanelController.CreateDetailPanels;
var
  I: Integer;
begin
  Assert(ViewTable <> nil);
  Assert(FDetailPanels = nil);
  Assert(Assigned(FStoreRecord));

  if ViewTable.DetailTableCount > 0 then
  begin
    Assert(FTabPanel <> nil);
    FStoreRecord.EnsureDetailStores;
    Assert(FStoreRecord.DetailStoreCount = ViewTable.DetailTableCount);
    FDetailToolbar := TExtToolbar.Create;
    FDetailPanels := TObjectList<TKExtGridPanel>.Create(False);
    for I := 0 to ViewTable.DetailTableCount - 1 do
    begin
      FDetailPanels.Add(TKExtGridPanel.AddTo(FTabPanel.Items));
      FDetailPanels[I].ServerStore := FStoreRecord.DetailStores[I];
      FDetailPanels[I].ViewTable := ViewTable.DetailTables[I];
      FDetailPanels[I].Show;
    end;
  end;
end;

procedure TKExtFormPanelController.CreateEditors(const AForceReadOnly: Boolean);
var
  LLayoutProcessor: TKExtLayoutProcessor;
  LLayoutName: string;
begin
  FreeAndNil(FEditors);
  FEditors := TList<IKExtEditor>.Create;
  LLayoutProcessor := TKExtLayoutProcessor.Create;
  try
    LLayoutProcessor.DataRecord := FStoreRecord;
    LLayoutProcessor.FormPanel := FFormPanel;
    LLayoutProcessor.OnFieldChange := OnFieldChange;
    LLayoutProcessor.OnNewEditor :=
      procedure (AEditor: IKExtEditor)
      begin
        FEditors.Add(AEditor);
      end;
    LLayoutProcessor.ForceReadOnly := AForceReadOnly;

    LLayoutName := ViewTable.GetString('Controller/Form/Layout');
    if LLayoutName <> '' then
      LLayoutProcessor.CreateEditors(View.Catalog.Layouts.FindLayout(LLayoutName))
    else
      LLayoutProcessor.CreateEditors(ViewTable.FindLayout('Form'));
    FFocusField := LLayoutProcessor.FocusField;
  finally
    FreeAndNil(LLayoutProcessor);
  end;
  // Scroll back to top - can't do that until afterrender because body.dom is needed.
  FFormPanel.On('afterrender', JSFunction(FFormPanel.JSName + '.body.dom.scrollTop = 0;'));
end;

function TKExtFormPanelController.GetDetailStyle: string;
begin
  Result := ViewTable.GetString('DetailTables/Controller/Style', 'Tabs');
end;

procedure TKExtFormPanelController.LoadData;
var
  LDetailStyle: string;
begin
  CreateEditors(FIsReadOnly);
  LDetailStyle := GetDetailStyle;
  if SameText(LDetailStyle, 'Tabs') then
    CreateDetailPanels
  else if SameText(LDetailStyle, 'Popup') then
    CreateDetailToolbar;
  StartOperation;
end;

procedure TKExtFormPanelController.StartOperation;
var
  LDefaultValues: TEFNode;
begin
  Assert(Assigned(FStoreRecord));

  try
    if FOperation = 'Add' then
    begin
      LDefaultValues := ViewTable.GetDefaultValues;
      try
        FStoreRecord.ReadFromNode(LDefaultValues);
        FStoreRecord.ApplyNewRecordRules;
      finally
        FreeAndNil(LDefaultValues);
      end;
    end;

    // Load data from FServerRecord.
    Session.JSCode(
      FFormPanel.JSName + '.getForm().load({url:"' + MethodURI(GetRecord) + '",' +
        'failure: function(form, action) { Ext.Msg.alert("' + _('Load failed.') + '", action.result.errorMessage);}});');
    LoadDetailData;
    FocusFirstField;
  except
    on E: EKValidationError do
    begin
      ExtMessageBox.Alert(Session.Config.AppTitle, E.Message);
      CancelChanges;
    end;
  end;
end;

procedure TKExtFormPanelController.LoadDetailData;
var
  I: Integer;
begin
  if Assigned(FDetailPanels) then
  begin
    for I := 0 to FDetailPanels.Count - 1 do
      FDetailPanels[I].LoadData;
  end;
end;

procedure TKExtFormPanelController.OnFieldChange(AField: TExtFormField;
  ANewValue, AOldValue: string);
var
  LEditor: IKExtEditor;
  LStore: TKStore;
  I: Integer;
  LDerivedEditor: IKExtEditor;
begin
  Assert(Assigned(AField));

  if Supports(AField, IKExtEditor, LEditor) then
  begin
    Assert(LEditor.GetField.IsReference);

    // Get derived values.
    LStore := LEditor.GetField.CreateDerivedFieldsStore(ANewValue);
    try
      // Copy values to editors.
      for I := 0 to LStore.Header.FieldCount - 1 do
      begin
        LDerivedEditor := FindEditor(LStore.Header.Fields[I].FieldName);
        if Assigned(LDerivedEditor) then
        begin
          if LStore.RecordCount > 0 then
            { TODO : need to format value? }
            LDerivedEditor.AsExtFormField.SetValue(LStore.Records[0].Fields[I].AsString)
          else
            LDerivedEditor.AsExtFormField.SetValue('');
        end;
      end;
    finally
      FreeAndNil(LStore);
    end;
  end;
end;

function TKExtFormPanelController.FindEditor(const AFieldName: string): IKExtEditor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FEditors.Count - 1 do
  begin
    if SameText(FEditors[I].GetField.AliasedName, AFieldName) then
    begin
      Result := FEditors[I];
      Break;
    end;
  end;
end;

procedure TKExtFormPanelController.FocusFirstField;
begin
  if Assigned (FFocusField) then
    FFocusField.Focus(False, 500);
end;

procedure TKExtFormPanelController.GetRecord;
begin
  Assert(Assigned(FStoreRecord));

  Session.Response := '{success:true,data:' + FStoreRecord.GetAsJSON + '}';
end;

procedure TKExtFormPanelController.SaveChanges;
begin
  try
    // Get POST values.
    FStoreRecord.SetChildValuesfromStrings(Session.Queries,
      False, Session.Config.UserFormatSettings,
      function(const AName: string): string
      var
        LViewField: TKViewField;
      begin
        LViewField := ViewTable.FindFieldByAliasedName(AName);
        if Assigned(LViewField) then
          Result := LViewField.AliasedName
        else
          Result := AName;
      end);

    // Save record.
    FStoreRecord.MarkAsModified;
    FStoreRecord.ApplyBeforeRules;
    if not ViewTable.IsDetail then
    begin
      FStoreRecord.Save(True);
      Session.Flash(_('Changes saved succesfully.'));
    end;

  except
    on E: EKValidationError do
    begin
      ExtMessageBox.Alert(Session.Config.AppTitle, E.Message);
      Exit;
    end;
  end;

  NotifyObservers('Confirmed');
  if not CloseHostWindow then
    StartOperation;
end;

procedure TKExtFormPanelController.InitComponents;
var
  LHostWindow: TExtWindow;
begin
  inherited;
  Title := ViewTable.DisplayLabel;

  FOperation := Config.GetString('Sys/Operation');
  if FOperation = '' then
    FOperation := View.GetString('Controller/Operation');

  FStoreRecord := Config.GetObject('Sys/Record') as TKViewTableRecord;
  Assert((FOperation = 'Add') or Assigned(FStoreRecord));
  if FOperation = 'Add' then
  begin
    Assert(not Assigned(FStoreRecord));
    FStoreRecord := ServerStore.AppendRecord(nil);
  end;

  if SameText(FOperation, 'Add') then
    FIsReadOnly := View.GetBoolean('IsReadOnly') or ViewTable.IsReadOnly or View.GetBoolean('Controller/PreventAdding')
      or not ViewTable.IsAccessGranted(ACM_ADD)
  else
    FIsReadOnly := View.GetBoolean('IsReadOnly') or ViewTable.IsReadOnly or View.GetBoolean('Controller/PreventEditing')
      or not ViewTable.IsAccessGranted(ACM_MODIFY);
  if SameText(FOperation, 'Add') and FIsReadOnly then
    raise EEFError.Create(_('Operation Add not supported on read-only data.'));

  ExtQuickTips.Init(True);

  if (ViewTable.DetailTableCount > 0) and SameText(GetDetailStyle, 'Tabs') then
  begin
    FTabPanel := TExtTabPanel.AddTo(Items);
    FTabPanel.Border := False;
    FTabPanel.Region := rgCenter;
    FTabPanel.AutoScroll := False;
    FTabPanel.SetActiveTab(0);
    FFormPanel := TKExtEditPanel.AddTo(FTabPanel.Items);
    FFormPanel.Title := ViewTable.DisplayLabel;
  end
  else
  begin
    FTabPanel := nil;
    FFormPanel := TKExtEditPanel.AddTo(Items);
    FFormPanel.Region := rgCenter;
  end;
  FFormPanel.Border := False;
  FFormPanel.Header := False;
  FFormPanel.Frame := True;
  FFormPanel.AutoScroll := True;
  FFormPanel.AutoWidth := True;
  FFormPanel.LabelWidth := 120;
  FFormPanel.MonitorValid := True;
  //TExtFormBasicForm(FFormPanel.GetForm).Url := MethodURI(SaveChanges);

  if not FIsReadOnly then
  begin
    FSaveButton := TExtButton.AddTo(FFormPanel.Buttons);
    FSaveButton.Scale := View.GetString('Controller/ButtonScale', 'medium');
    FSaveButton.FormBind := True;
    FSaveButton.Text := _('Save');
    FSaveButton.Tooltip := _('Save changes and finish editing');
    FSaveButton.Icon := Session.Config.GetImageURL('accept');
    FSaveButton.Handler := AjaxForms(SaveChanges, [FFormPanel]);
    //FSaveButton.Handler := JSFunction(FFormPanel.JSName + '.getForm().doAction("submit", {success:"AjaxSuccess", failure:"AjaxFailure"});');
  end;
  FCancelButton := TExtButton.AddTo(FFormPanel.Buttons);
  FCancelButton.Scale := View.GetString('Controller/ButtonScale', 'medium');
  FCancelButton.Icon := Session.Config.GetImageURL('cancel');
  if FIsReadOnly then
  begin
    FCancelButton.Text := _('Close');
    FCancelButton.Tooltip := _('Close this panel');
    // No need for an ajax call when we just close the client-side panel.
    LHostWindow := GetHostWindow;
    if Assigned(LHostWindow) then
      FCancelButton.Handler := JSFunction(LHostWindow.JSName + '.close();');
  end
  else
  begin
    FCancelButton.Text := _('Cancel');
    FCancelButton.Tooltip := _('Cancel changes');
    FCancelButton.Handler := Ajax(CancelChanges);
  end;
end;

function TKExtFormPanelController.AutoLoadData: Boolean;
begin
  // A form is not subject to the AutoOpen parameter.
  Result := True;
end;

procedure TKExtFormPanelController.CancelChanges;
begin
  if FOperation = 'Add' then
  begin
    ServerStore.RemoveRecord(FStoreRecord);
    FStoreRecord := nil;
  end;
  NotifyObservers('Canceled');
  if not CloseHostWindow then
    StartOperation;
end;

{ TKExtDetailFormButton }

destructor TKExtDetailFormButton.Destroy;
begin
  //FreeAndNil(FDetailHostWindow);
  inherited;
end;

procedure TKExtDetailFormButton.SetViewTable(const AValue: TKViewTable);
begin
  FViewTable := AValue;
  if Assigned(FViewTable) then
  begin
    Text := FViewTable.PluralDisplayLabel;
    Icon := Session.Config.GetImageURL(FViewTable.ImageName);
    Handler := Ajax(ShowDetailWindow, []);
  end;
end;

procedure TKExtDetailFormButton.ShowDetailWindow;
var
  LController: IKExtController;
begin
  Assert(Assigned(FViewTable));

  if Assigned(FDetailHostWindow) then
    FDetailHostWindow.Free(True);
  FDetailHostWindow := TKExtModalWindow.Create;

  FDetailHostWindow.Title := ViewTable.PluralDisplayLabel;
  FDetailHostWindow.Closable := True;

  LController := TKExtControllerFactory.Instance.CreateController(FViewTable.View, FDetailHostWindow);
  LController.OwnsView := False;
  LController.Config.SetObject('Sys/ServerStore', ServerStore);
  LController.Config.SetObject('Sys/ViewTable', ViewTable);
  LController.Config.SetObject('Sys/HostWindow', FDetailHostWindow);
  LController.Display;
  FDetailHostWindow.Show;
end;

initialization
  TKExtControllerRegistry.Instance.RegisterClass('Form', TKExtFormPanelController);

finalization
  TKExtControllerRegistry.Instance.UnregisterClass('Form');

end.
