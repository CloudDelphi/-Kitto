unit Kitto.Metadata;

interface

uses
  Classes, Generics.Collections,
  EF.Types, EF.Tree, EF.YAML;

type
  TKMetadata = class(TEFTree)
  private
    FPersistentName: string;
    function GetIsPersistent: Boolean;
    class function BeautifiedClassName: string; static;
  public
    procedure Assign(const ASource: TEFTree); override;

    property PersistentName: string read FPersistentName write FPersistentName;

    property IsPersistent: Boolean read GetIsPersistent;

    ///	<summary>Returns a string URI that uniquely identifies the object, to
    ///	be used for access control.</summary>
    function GetResourceURI: string; virtual;

    ///	<summary>Returns true if access is granted to the resource representing
    ///	the metadata object in the specified mode. This is a shortcut to
    ///	calling TKConfig.Instance.IsAccessGranted (possibly multiple times for
    ///	cascading, and "or"ing the results).</summary>
    function IsAccessGranted(const AMode: string): Boolean; virtual;
  end;

  TKMetadataClass = class of TKMetadata;

  TKMetadataItem = class(TEFNode)
  public
    ///	<summary>Returns a string URI that uniquely identifies the object, to
    ///	be used for access control.</summary>
    function GetResourceURI: string; virtual;

    ///	<summary>Returns true if access is granted to the resource representing
    ///	the metadata object in the specified mode. This is a shortcut to
    ///	calling TKConfig.Instance.IsAccessGranted (possibly multiple times for
    ///	cascading, and "or"ing the results).</summary>
    function IsAccessGranted(const AMode: string): Boolean; virtual;
  end;

  TKMetadataCatalog = class
  private
    FPath: string;
    FIndex: TStringList;
    FReader: TEFYAMLReader;
    FWriter: TEFYAMLWriter;
    FDisposedObjects: TList<TKMetadata>;
    procedure LoadIndex;
    function GetObjectCount: Integer;
    function GetReader: TEFYAMLReader;
    function LoadObject(const AName: string): TKMetadata;
    procedure SaveObject(const AObject: TKMetadata);
    function GetWriter: TEFYAMLWriter;
    function GetObject(I: Integer): TKMetadata;
    function GetFullFileName(const AName: string): string;
    function ObjectExists(const AName: string): Boolean;
    procedure DuplicateObjectError(const AName: string);
  protected
    procedure ObjectNotFound(const AName: string);
    // Delete file and free object.
    procedure DisposeObject(const AObject: TKMetadata);
    property Reader: TEFYAMLReader read GetReader;
    property Writer: TEFYAMLWriter read GetWriter;
    procedure AfterCreateObject(const AObject: TKMetadata); virtual;
    procedure SetPath(const AValue: string); virtual;
    function GetObjectClassType: TKMetadataClass; virtual; abstract;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  public
    property Path: string read FPath write SetPath;
    procedure Open; virtual;
    procedure Close; virtual;

    property ObjectCount: Integer read GetObjectCount;
    property Objects[I: Integer]: TKMetadata read GetObject;
    function FindObject(const AName: string): TKMetadata;
    function ObjectByName(const AName: string): TKMetadata;

    function ObjectByNode(const ANode: TEFNode): TKMetadata;
    function FindObjectByNode(const ANode: TEFNode): TKMetadata;

    procedure AddObject(const AObject: TKMetadata);

    ///	<summary>
    ///	  Marks the object as disposed and removes it from the index (but
    ///	  doesn't free it). The file is then deleted when SaveAll is called.
    ///	</summary>
    ///	<param name="AObject">
    ///	  Object to be disposed.
    ///	</param>
    procedure MarkObjectAsDisposed(const AObject: TKMetadata);

    ///	<summary>
    ///	  Saves all modified objects in the catalog and disposes all objects
    ///	  marked for disposition.
    ///	</summary>
    procedure SaveAll;
  end;

  TKMetadataRegistry = class(TEFRegistry)
  private
    class var FInstance: TKMetadataRegistry;
    class function GetInstance: TKMetadataRegistry; static;
  protected
    procedure BeforeRegisterClass(const AId: string; const AClass: TClass);
      override;
  public
    class property Instance: TKMetadataRegistry read GetInstance;
    class destructor Destroy;
    function GetClass(const AId: string): TKMetadataClass;
  end;

implementation

uses
  Windows, SysUtils,
  EF.Localization, EF.StrUtils,
  Kitto.Types, Kitto.Config;

{ TKMetadataCatalog<T> }

procedure TKMetadataCatalog.AfterConstruction;
begin
  inherited;
  FIndex := TStringList.Create;
  FIndex.Sorted := True;
  Findex.Duplicates := dupError;
  Findex.CaseSensitive := False;
  FDisposedObjects := TList<TKMetadata>.Create;
end;

procedure TKMetadataCatalog.AfterCreateObject(const AObject: TKMetadata);
begin
end;

procedure TKMetadataCatalog.Close;
var
  I: Integer;
begin
  for I := FDisposedObjects.Count - 1 downto 0 do
  begin
    FDisposedObjects[I].Free;
    FDisposedObjects.Delete(I);
  end;
  FDisposedObjects.Clear;

  for I := FIndex.Count - 1 downto 0 do
  begin
    FIndex.Objects[I].Free;
    FIndex.Delete(I);
  end;
  FIndex.Clear;
end;

procedure TKMetadataCatalog.DisposeObject(const AObject: TKMetadata);
var
  LFileName: string;
begin
  Assert(Assigned(AObject));

  if AObject.PersistentName <> '' then
  begin
    LFileName := GetFullFileName(AObject.PersistentName);
    if FileExists(LFileName) then
      DeleteFile(LFileName);
  end;
  AObject.Free;
end;

procedure TKMetadataCatalog.DuplicateObjectError(const AName: string);
begin
  raise EKError.CreateFmt(_('Duplicate object %s.'), [AName]);
end;

destructor TKMetadataCatalog.Destroy;
begin
  Close;
  FreeAndNil(FIndex);
  FreeAndNil(FDisposedObjects);
  FreeAndNil(FReader);
  FreeAndNil(FWriter);
  inherited;
end;

procedure TKMetadataCatalog.MarkObjectAsDisposed(const AObject: TKMetadata);
var
  LIndex: Integer;
begin
  FDisposedObjects.Add(AObject);
  if FIndex.Find(AObject.PersistentName, LIndex) then
  begin
    Assert(TKMetadata(FIndex.Objects[LIndex]) = AObject);
    FIndex.Delete(LIndex);
  end;
end;

function TKMetadataCatalog.GetFullFileName(const AName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(FPath) + AName + '.yaml';
end;

function TKMetadataCatalog.GetObject(I: Integer): TKMetadata;
begin
  Result := nil;
  if (I >= 0) and (I < FIndex.Count) then
  begin
    Result := FIndex.Objects[I] as TKMetadata;
    if Result = nil then
    begin
      Result := LoadObject(FIndex[I]);
      FIndex.Objects[I] := Result;
    end;
  end;
  if Result = nil then
    ObjectNotFound(IntToStr(I));
end;

function TKMetadataCatalog.GetObjectCount: Integer;
begin
  Result := FIndex.Count;
end;

function TKMetadataCatalog.GetReader: TEFYAMLReader;
begin
  if not Assigned(FReader) then
    FReader := TEFYAMLReader.Create;
  Result := FReader;
end;

function TKMetadataCatalog.GetWriter: TEFYAMLWriter;
begin
  if not Assigned(FWriter) then
    FWriter := TEFYAMLWriter.Create;
  Result := FWriter;
end;

procedure TKMetadataCatalog.LoadIndex;
var
  LResult: Integer;
  LSearchRec: TSearchRec;
begin
  LResult := FindFirst(IncludeTrailingPathDelimiter(FPath) + '*.yaml', faNormal, LSearchRec);
  while LResult = 0 do
  begin
    FIndex.AddObject(ChangeFileExt(LSearchRec.Name, ''), nil);
    LResult := FindNext(LSearchRec);
  end;
  FindClose(LSearchRec);
end;

function TKMetadataCatalog.FindObject(const AName: string): TKMetadata;
var
  LIndex: Integer;
begin
  if FIndex.Find(AName, LIndex) then
  begin
    Result := FIndex.Objects[LIndex] as TKMetadata;
    if Result = nil then
    begin
      Result := LoadObject(AName);
      FIndex.Objects[LIndex] := Result;
    end;
  end
  else
    Result := nil;
end;

function TKMetadataCatalog.ObjectByName(const AName: string): TKMetadata;
begin
  Result := FindObject(AName);
  if Result = nil then
    ObjectNotFound(AName);
end;

function TKMetadataCatalog.ObjectByNode(const ANode: TEFNode): TKMetadata;
begin
  Result := FindObjectByNode(ANode);
  if Result = nil then
    if Assigned(ANode) then
      ObjectNotFound(ANode.Name + ':' + ANode.AsString)
    else
      ObjectNotFound('<nil>');
end;

function TKMetadataCatalog.FindObjectByNode(const ANode: TEFNode): TKMetadata;
begin
  if not Assigned(ANode) then
    Result := nil
  else if ANode.AsString <> '' then
    Result := ObjectByName(ANode.AsString)
  else if ANode.ChildCount > 0 then
  begin
    Result := GetObjectClassType.Create;
    try
      Result.Assign(ANode);
    except
      FreeAndNil(Result);
      raise;
    end;
  end
  else
    Result := nil;
end;

procedure TKMetadataCatalog.ObjectNotFound(const AName: string);
begin
  raise EKError.CreateFmt(_('Object %s not found.'), [AName]);
end;

function TKMetadataCatalog.ObjectExists(const AName: string): Boolean;
begin
  Result := FIndex.IndexOf(AName) >= 0;
end;

function TKMetadataCatalog.LoadObject(const AName: string): TKMetadata;
var
  LFileName: string;
  LDeclaredClassType: TKMetadataClass;
  LObject: TKMetadata;
  LDeclaredClassName: string;
begin
  Result := nil;
  LFileName := GetFullFileName(AName);
  if FileExists(LFileName) then
  begin
    LObject := GetObjectClassType.Create;
    LObject.PersistentName := AName;
    Reader.LoadTreeFromFile(LObject, LFileName);

    // Change object type according to the declaration, if present.
    LDeclaredClassName := LObject.GetString('Type');
    if LDeclaredClassName <> '' then
    begin
      LDeclaredClassType := TKMetadataRegistry.Instance.GetClass(LDeclaredClassName);
      if LDeclaredClassType <> LObject.ClassType then
      begin
        Result := LDeclaredClassType.Clone(LObject);
        FreeAndNil(LObject);
      end
      else
        Result := LObject;
    end
    else
      Result := LObject;
    AfterCreateObject(Result);
  end;
  if Result = nil then
    ObjectNotFound(AName);
end;

procedure TKMetadataCatalog.AddObject(const AObject: TKMetadata);
begin
  Assert(Assigned(AObject));
  Assert(AObject.PersistentName <> '');

  if ObjectExists(AObject.PersistentName) then
    DuplicateObjectError(AObject.PersistentName);
  FIndex.AddObject(AObject.PersistentName, AObject);
end;

procedure TKMetadataCatalog.SetPath(const AValue: string);
begin
  FPath := AValue;
end;

procedure TKMetadataCatalog.Open;
begin
  Close;
  LoadIndex;
end;

procedure TKMetadataCatalog.SaveAll;
var
  I: Integer;
begin
  for I := 0 to FIndex.Count - 1 do
  begin
    if Assigned(FIndex.Objects[I]) then
      SaveObject(FIndex.Objects[I] as TKMetadata);
  end;

  for I := FDisposedObjects.Count - 1 downto 0 do
  begin
    DisposeObject(FDisposedObjects[I]);
    FDisposedObjects.Delete(I);
  end;
end;

procedure TKMetadataCatalog.SaveObject(const AObject: TKMetadata);
begin
  Assert(Assigned(AObject));
  Assert(AObject.PersistentName <> '');

  Writer.SaveTreeToFile(AObject, GetFullFileName(AObject.PersistentName));
end;

{ TKMetadataRegistry }

procedure TKMetadataRegistry.BeforeRegisterClass(const AId: string;
  const AClass: TClass);
begin
  if not AClass.InheritsFrom(TKMetadata) then
    raise EKError.CreateFmt('Cannot regisater class %s (Id %s). Class is not a TKMetadata subclass.', [AClass.ClassName, AId]);
  inherited;
end;

class destructor TKMetadataRegistry.Destroy;
begin
  FreeAndNil(FInstance);
end;

function TKMetadataRegistry.GetClass(const AId: string): TKMetadataClass;
begin
  Result := TKMetadataClass(inherited GetClass(AId));
end;

class function TKMetadataRegistry.GetInstance: TKMetadataRegistry;
begin
  if FInstance = nil then
    FInstance := TKMetadataRegistry.Create;
  Result := TKMetadataRegistry(FInstance);
end;

{ TKMetadata }

procedure TKMetadata.Assign(const ASource: TEFTree);
begin
  inherited;
  if Assigned(ASource) and (ASource is TKMetadata) then
    FPersistentName := TKMetadata(ASource).PersistentName;
end;

function TKMetadata.GetIsPersistent: Boolean;
begin
  Result := PersistentName <> '';
end;

function TKMetadata.GetResourceURI: string;
begin
  Result := 'metadata://' + BeautifiedClassName + '/' + PersistentName;
end;

function TKMetadata.IsAccessGranted(const AMode: string): Boolean;
begin
  Result := TKConfig.Instance.IsAccessGranted(GetResourceURI, AMode);
end;

class function TKMetadata.BeautifiedClassName: string;
begin
  Result := StripPrefix(ClassName, 'TK');
end;

{ TKMetadataItem }

function TKMetadataItem.GetResourceURI: string;
begin
  Result := '';
end;

function TKMetadataItem.IsAccessGranted(const AMode: string): Boolean;
begin
  Result := TKConfig.Instance.IsAccessGranted(GetResourceURI, AMode);
end;

end.

