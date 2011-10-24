unit Kitto.SQL;

{$I Kitto.Defines.inc}

interface

uses
  Classes, Generics.Collections,
  EF.Classes,  EF.Tree, EF.DB,
  Kitto.Metadata.Models, Kitto.Metadata.DataView;

type
  ///	<summary>
  ///	  Builds SQL select statements on request.
  ///	</summary>
  TKSQLBuilder = class(TEFComponent)
  private
    FUsedReferenceFields: TList<TKModelField>;
    FSelectTerms: string;
    FViewTable: TKViewTable;
    procedure Clear;
    procedure AddSelectTerm(const ATerm: string);
    procedure AddReferenceFieldTerms(const AViewField: TKViewField);
    function GetFromClause: string;
    function BuildJoin(const AReferenceField: TKModelField): string;

    procedure InternalBuildSelectQuery(const AViewTable: TKViewTable;
      const AFilter: string; const ADBQuery: TEFDBQuery; const AMasterValues: TEFNode = nil;
      const AFrom: Integer = 0; const AFor: Integer = 0);
    procedure InternalBuildCountQuery(const AViewTable: TKViewTable;
      const AFilter: string; const ADBQuery: TEFDBQuery;
      const AMasterValues: TEFNode);
    function GetSelectWhereClause(const AFilter: string;
      const ADBQuery: TEFDBQuery): string;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;

    ///	<summary>
    ///	  <para>Builds in the specified query a select statement that selects
    ///	  all fields from the specified view table with an optional filter
    ///	  clause. Handles joins and table aliases based on model
    ///	  information.</para>
    ///	  <para>If the view table is a detail table, a where clause with
    ///	  parameters for the master fields is added as well, and param values
    ///	  are set based on AMasterValues.</para>
    ///	</summary>
    class procedure BuildSelectQuery(const AViewTable: TKViewTable; const AFilter: string;
      const ADBQuery: TEFDBQuery; const AMasterValues: TEFNode = nil;
      const AFrom: Integer = 0; const AFor: Integer = 0);

    class procedure BuildCountQuery(const AViewTable: TKViewTable;
      const AFilter: string; const ADBQuery: TEFDBQuery;
      const AMasterValues: TEFNode);

    ///	<summary>Builds and returns a SQL statement that selects the specified
    ///	field plus all key fields from the specified field's table. AViewField
    ///	must have an assigned Reference, otherwise an exception is
    ///	raised.</summary>
    class function GetLookupSelectStatement(const AViewField: TKViewField): string;

    ///	<summary>Builds in the specified command an insert statement against
    ///	the specified model's table with a parameter for each value in AValues.
    ///	Also sets the parameter values, so that the command is ready for
    ///	execution.</summary>
    class procedure BuildInsertCommand(const AViewTable: TKViewTable;
      const ADBCommand: TEFDBCommand; const AValues: TEFNode);

    ///	<summary>Builds in the specified command an update statement against
    ///	the specified model's table with a parameter for each value in AValues
    /// plus a where clause with a parameter for each key field.
    ///	Also sets the parameter values, so that the command is ready for
    ///	execution. AValues must contain at least the key fields.</summary>
    class procedure BuildUpdateCommand(const AViewTable: TKViewTable;
      const ADBCommand: TEFDBCommand; const AValues: TEFNode);

    ///	<summary>Builds in the specified command a delete statement against
    ///	the specified model's table with a where clause with a parameter for
    /// each key field.
    ///	Also sets the parameter values, so that the command is ready for
    ///	execution. AValues must contain at least the key fields.</summary>
    class procedure BuildDeleteCommand(const AViewTable: TKViewTable;
      const ADBCommand: TEFDBCommand; const AValues: TEFNode);
  end;

implementation

uses
  SysUtils, StrUtils, DB, Types,
  EF.Intf, EF.Localization, EF.Types, EF.StrUtils, EF.DB.Utils, EF.SQL,
  Kitto.Types, Kitto.Environment;

{ TKSQLQueryBuilder }

class procedure TKSQLBuilder.BuildSelectQuery(const AViewTable: TKViewTable;
  const AFilter: string; const ADBQuery: TEFDBQuery; const AMasterValues: TEFNode;
  const AFrom: Integer; const AFor: Integer);
begin
  Assert(Assigned(AViewTable));

  with TKSQLBuilder.Create do
  begin
    try
      InternalBuildSelectQuery(AViewTable, AFilter, ADBQuery, AMasterValues, AFrom, AFor);
    finally
      Free;
    end;
  end;
end;

class procedure TKSQLBuilder.BuildCountQuery(const AViewTable: TKViewTable;
  const AFilter: string; const ADBQuery: TEFDBQuery; const AMasterValues: TEFNode);
begin
  Assert(Assigned(AViewTable));

  with TKSQLBuilder.Create do
  begin
    try
      InternalBuildCountQuery(AViewTable, AFilter, ADBQuery, AMasterValues);
    finally
      Free;
    end;
  end;
end;

class procedure TKSQLBuilder.BuildInsertCommand(const AViewTable: TKViewTable;
  const ADBCommand: TEFDBCommand; const AValues: TEFNode);
var
  LCommandText: string;
  I: Integer;
  LViewField: TKViewField;
  LFieldNames: string;
  LValueNames: string;
  LSubFieldIndex: Integer;

  procedure AddFieldName(const AFieldName: string);
  begin
    if LFieldNames = '' then
    begin
      LFieldNames := AFieldName;
      LValueNames := ':' + AFieldName;
    end
    else
    begin
      LFieldNames := LFieldNames + ', ' + AFieldName;
      LValueNames := LValueNames + ', :' + AFieldName;
    end;
    ADBCommand.Params.CreateParam(ftUnknown, AFieldName, ptInput);
  end;

begin
  Assert(Assigned(AViewTable));
  Assert(Assigned(ADBCommand));
  Assert(Assigned(AValues));

  if ADBCommand.Prepared then
    ADBCommand.Prepared := False;
  ADBCommand.Params.BeginUpdate;
  try
    ADBCommand.Params.Clear;
    LCommandText := 'insert into ' + AViewTable.ModelName + ' (';
    LFieldNames := '';
    LValueNames := '';
    for I := 0 to AValues.ChildCount - 1 do
    begin
      LViewField := AViewTable.FindField(AValues[I].Name);
      if Assigned(LViewField) and LViewField.CanInsert then
      begin
        if LViewField.IsReference then
        begin
          for LSubFieldIndex := 0 to LViewField.ModelField.FieldCount - 1 do
            AddFieldName(LViewField.ModelField.Fields[LSubFieldIndex].FieldName);
        end
        else
          AddFieldName(AValues[I].Name);
      end;
    end;
    LCommandText := LCommandText + LFieldNames + ') values (' + LValueNames + ')';
    ADBCommand.CommandText := LCommandText;
  finally
    ADBCommand.Params.EndUpdate;
  end;
  for I := 0 to ADBCommand.Params.Count - 1 do
    AValues.GetNode(ADBCommand.Params[I].Name).AssignValueToParam(ADBCommand.Params[I]);
end;

class procedure TKSQLBuilder.BuildUpdateCommand(const AViewTable: TKViewTable;
  const ADBCommand: TEFDBCommand; const AValues: TEFNode);
var
  LCommandText: string;
  I: Integer;
  LKeyFields: TStringDynArray;
  LViewField: TKViewField;
  LFieldNames: string;
  LParamName: string;
  LSubFieldIndex: Integer;

  procedure AddFieldName(const AFieldName: string);
  begin
    if LFieldNames = '' then
      LFieldNames := AFieldName + ' = :' + AFieldName
    else
      LFieldNames := LFieldNames + ', ' + AFieldName + ' = :' + AFieldName;
    ADBCommand.Params.CreateParam(ftUnknown, AFieldName, ptInput);
  end;

begin
  Assert(Assigned(AViewTable));
  Assert(Assigned(ADBCommand));
  Assert(Assigned(AValues));

  if ADBCommand.Prepared then
    ADBCommand.Prepared := False;
  ADBCommand.Params.BeginUpdate;
  try
    ADBCommand.Params.Clear;
    LCommandText := 'update ' + AViewTable.ModelName + ' set ';
    LFieldNames := '';
    for I := 0 to AValues.ChildCount - 1 do
    begin
      LViewField := AViewTable.FindField(AValues[I].Name);
      if Assigned(LViewField) and LViewField.CanUpdate then
      begin
        if LViewField.IsReference then
        begin
          for LSubFieldIndex := 0 to LViewField.ModelField.FieldCount - 1 do
            AddFieldName(LViewField.ModelField.Fields[LSubFieldIndex].FieldName);
        end
        else
          AddFieldName(AValues[I].Name);
      end;
    end;
    LCommandText := LCommandText + LFieldNames + ' where ';
    LKeyFields := AViewTable.Model.GetKeyFieldNames;
    for I := 0 to Length(LKeyFields) - 1 do
    begin
      LParamName := AViewTable.FieldByName(LKeyFields[I]).AliasedName;
      if I > 0 then
        LCommandText := LCommandText + ' and ';
      LCommandText := LCommandText + LKeyFields[I] + ' = :' + LParamName;
      ADBCommand.Params.CreateParam(ftUnknown, LParamName, ptInput);
    end;
    ADBCommand.CommandText := LCommandText;
  finally
    ADBCommand.Params.EndUpdate;
  end;
  for I := 0 to ADBCommand.Params.Count - 1 do
    AValues.GetNode(ADBCommand.Params[I].Name).AssignValueToParam(ADBCommand.Params[I]);
end;

class procedure TKSQLBuilder.BuildDeleteCommand(const AViewTable: TKViewTable;
  const ADBCommand: TEFDBCommand; const AValues: TEFNode);
var
  LCommandText: string;
  I: Integer;
  LKeyFields: TStringDynArray;
  LParamName: string;
begin
  Assert(Assigned(AViewTable));
  Assert(Assigned(ADBCommand));
  Assert(Assigned(AValues));

  if ADBCommand.Prepared then
    ADBCommand.Prepared := False;
  ADBCommand.Params.BeginUpdate;
  try
    ADBCommand.Params.Clear;
    LCommandText := 'delete from ' + AViewTable.ModelName + ' where ';
    LKeyFields := AViewTable.Model.GetKeyFieldNames;
    for I := 0 to Length(LKeyFields) - 1 do
    begin
      LParamName := AViewTable.FieldByName(LKeyFields[I]).AliasedName;
      if I > 0 then
        LCommandText := LCommandText + ' and ';
      LCommandText := LCommandText + LKeyFields[I] + ' = :' + LParamName;
      ADBCommand.Params.CreateParam(ftUnknown, LParamName, ptInput);
    end;
    ADBCommand.CommandText := LCommandText;
  finally
    ADBCommand.Params.EndUpdate;
  end;
  for I := 0 to ADBCommand.Params.Count - 1 do
    AValues.GetNode(ADBCommand.Params[I].Name).AssignValueToParam(ADBCommand.Params[I]);
end;

procedure TKSQLBuilder.AfterConstruction;
begin
  inherited;
  FUsedReferenceFields := TList<TKModelField>.Create;
end;

destructor TKSQLBuilder.Destroy;
begin
  inherited;
  FreeAndNil(FUsedReferenceFields);
end;

procedure TKSQLBuilder.Clear;
begin
  FViewTable := nil;
  FSelectTerms := '';
  FUsedReferenceFields.Clear;
end;

procedure TKSQLBuilder.AddSelectTerm(const ATerm: string);
begin
  if FSelectTerms = '' then
    FSelectTerms := ATerm
  else
    FSelectTerms := FSelectTerms + ', ' + ATerm;
end;

function TKSQLBuilder.GetFromClause: string;
var
  I: Integer;
begin
  Assert(Assigned(FViewTable));

  Result := FViewTable.ModelName;
  for I := 0 to FUsedReferenceFields.Count - 1 do
    Result := Result + sLineBreak + BuildJoin(FUsedReferenceFields[I]);
end;

class function TKSQLBuilder.GetLookupSelectStatement(
  const AViewField: TKViewField): string;
var
  LLookupModel: TKModel;
begin
  Assert(Assigned(AViewField));
  Assert(AViewField.IsReference);

  LLookupModel := AViewField.ModelField.ReferencedModel;
  Result := 'select '
    + Join(LLookupModel.GetKeyFieldNames, ', ');
    if not LLookupModel.CaptionField.IsKey then
      Result := Result + ', ' + LLookupModel.CaptionField.FieldName;
    Result := Result + ' from ' + LLookupModel.ModelName
    + ' order by ' + LLookupModel.CaptionField.FieldName;
  if LLookupModel.DefaultFilter <> '' then
    Result := AddToSQLWhereClause(Result, LLookupModel.DefaultFilter);
end;

function TKSQLBuilder.BuildJoin(const AReferenceField: TKModelField): string;

  function GetJoinKeyword: string;
  begin
    if AReferenceField.IsRequired then
      Result := 'join'
    else
      Result := 'left join';
  end;

var
  I: Integer;
  LLocalFieldNames: TStringDynArray;
  LForeignFieldNames: TStringDynArray;
begin
  Assert(Assigned(AReferenceField));

  Result := GetJoinKeyword + ' ' + AReferenceField.ReferencedModelName + ' on (';
  LLocalFieldNames := AReferenceField.ReferenceFieldNames;
  Assert(Length(LLocalFieldNames) > 0);
  LForeignFieldNames := AReferenceField.ReferencedModel.GetKeyFieldNames;
  Assert(Length(LForeignFieldNames) = Length(LLocalFieldNames));

  for I := Low(LLocalFieldNames) to High(LLocalFieldNames) do
  begin
    Result := Result + FViewTable.ModelName + '.' + LLocalFieldNames[I] + ' = '
      + AReferenceField.ReferencedModelName + '.' + LForeignFieldNames[I];
    if I < High(LLocalFieldNames) then
      Result := Result + ' and ';
  end;
  Result := Result + ')';
end;

procedure TKSQLBuilder.AddReferenceFieldTerms(const AViewField: TKViewField);
var
  LFieldNames: TStringDynArray;
  I: Integer;
begin
  Assert(Assigned(FViewTable));
  Assert(Assigned(AViewField));
  Assert(AViewField.IsReference);

  if not FUsedReferenceFields.Contains(AViewField.ModelField)   then
    FUsedReferenceFields.Add(AViewField.ModelField);

  LFieldNames := AViewField.ModelField.ReferenceFieldNames;
  for I := Low(LFieldNames) to High(LFieldNames) do
    AddSelectTerm(FViewTable.ModelName + '.' + LFieldNames[I]);
  // Add the caption field of the referenced model as well.
  // The reference field name is used as table alias.
  AddSelectTerm(AViewField.ModelField.ReferencedModel.CaptionField.QualifiedFieldName
    + ' ' + AViewField.ModelField.FieldName);
end;

function TKSQLBuilder.GetSelectWhereClause(const AFilter: string;
  const ADBQuery: TEFDBQuery): string;
var
  I: Integer;
  LMasterFieldNames: TStringDynArray;
  LDetailFieldNames: TStringDynArray;
  LClause: string;
begin
  Result := '';
  if FViewTable.DefaultFilter <> '' then
    Result := Result + ' where (' + FViewTable.DefaultFilter + ')';
  if AFilter <> '' then
    Result := AddToSQLWhereClause(Result, AFilter);

  if FViewTable.IsDetail then
  begin
    // Get master and detail field names...
    LMasterFieldNames := FViewTable.MasterTable.Model.GetKeyFieldNames;
    Assert(Length(LMasterFieldNames) > 0);
    LDetailFieldNames := FViewTable.ModelDetailReference.ReferenceField.GetFieldNames;
    Assert(Length(LDetailFieldNames) = Length(LMasterFieldNames));
    LClause := '';
    for I := 0 to High(LDetailFieldNames) do
    begin
      // ...and alias master field names. Don'alias detail field names used in the where clause.
      LMasterFieldNames[I] := FViewTable.MasterTable.ApplyFieldAliasedName(LMasterFieldNames[I]);
      LClause := LClause + FViewTable.ModelName + '.' + LDetailFieldNames[I] + ' = :' + LMasterFieldNames[I];
      ADBQuery.Params.CreateParam(ftUnknown, LMasterFieldNames[I], ptInput);
      if I < High(LDetailFieldNames) then
        LClause := LClause + ' and ';
    end;
    Result := AddToSQLWhereClause(Result, '(' + LClause + ')');
  end;
end;

procedure TKSQLBuilder.InternalBuildSelectQuery(const AViewTable: TKViewTable;
  const AFilter: string; const ADBQuery: TEFDBQuery; const AMasterValues: TEFNode;
  const AFrom: Integer; const AFor: Integer);
var
  I: Integer;
  LCommandText: string;
begin
  Clear;
  FViewTable := AViewTable;
  for I := 0 to AViewTable.FieldCount - 1 do
  begin
    if AViewTable.Fields[I].IsReference then
      AddReferenceFieldTerms(AViewTable.Fields[I])
    else
      AddSelectTerm(AViewTable.Fields[I].QualifiedAliasedNameOrExpression);
  end;

  if ADBQuery.Prepared then
    ADBQuery.Prepared := False;
  ADBQuery.Params.BeginUpdate;
  try
    ADBQuery.Params.Clear;
    LCommandText :=
      'select ' +  FSelectTerms +
      ' from ' + GetFromClause + GetSelectWhereClause(AFilter, ADBQuery);
    if FViewTable.DefaultSorting <> '' then
      LCommandText := LCommandText + ' order by ' + FViewTable.DefaultSorting;
    LCommandText := ADBQuery.Connection.AddLimitClause(LCommandText, AFrom, AFor);
    ADBQuery.CommandText := Environment.MacroExpansionEngine.Expand(LCommandText);
  finally
    ADBQuery.Params.EndUpdate;
  end;
  for I := 0 to ADBQuery.Params.Count - 1 do
    AMasterValues.GetNode(ADBQuery.Params[I].Name).AssignValueToParam(ADBQuery.Params[I]);
end;

procedure TKSQLBuilder.InternalBuildCountQuery(const AViewTable: TKViewTable;
  const AFilter: string; const ADBQuery: TEFDBQuery;
  const AMasterValues: TEFNode);
var
  I: Integer;
  LCommandText: string;
begin
  Clear;
  FViewTable := AViewTable;
{ TODO :
Process all fields to build the from clause. A future refactoring might
build only those that affect the count (outer joins). }
  for I := 0 to AViewTable.FieldCount - 1 do
  begin
    if AViewTable.Fields[I].IsReference then
      AddReferenceFieldTerms(AViewTable.Fields[I])
    else
      AddSelectTerm(AViewTable.Fields[I].QualifiedAliasedNameOrExpression);
  end;

  if ADBQuery.Prepared then
    ADBQuery.Prepared := False;
  ADBQuery.Params.BeginUpdate;
  try
    ADBQuery.Params.Clear;
    LCommandText := 'select count(*) from ' + GetFromClause + GetSelectWhereClause(AFilter, ADBQuery);
    ADBQuery.CommandText := Environment.MacroExpansionEngine.Expand(LCommandText);
  finally
    ADBQuery.Params.EndUpdate;
  end;
  for I := 0 to ADBQuery.Params.Count - 1 do
    AMasterValues.GetNode(ADBQuery.Params[I].Name).AssignValueToParam(ADBQuery.Params[I]);
end;

end.

