unit Kitto.Metadata.Views;

{$I Kitto.Defines.inc}

interface

uses
  Types,
  EF.Classes, EF.Types, EF.Tree,
  Kitto.Metadata, Kitto.Metadata.Models, Kitto.Store, Kitto.Rules;

type
  TKViews = class;

  TKView = class(TKMetadata)
  private
    FViews: TKViews;
    function GetControllerType: string;
  protected
    const DEFAULT_IMAGE_NAME = 'default_view';
    function GetDisplayLabel: string; virtual;
    function GetImageName: string; virtual;
  public
    property Catalog: TKViews read FViews;

    property DisplayLabel: string read GetDisplayLabel;
    property ImageName: string read GetImageName;

    property ControllerType: string read GetControllerType;
  end;

  TKLayouts = class;

  TKLayout = class(TKMetadata)
  private
    FLayouts: TKLayouts;
  end;

  ///	<summary>
  ///	  A catalog of views.
  ///	</summary>
  TKViews = class(TKMetadataCatalog)
  private
    FLayouts: TKLayouts;
    function GetLayouts: TKLayouts;
    function BuildView(const ANode: TEFNode;
      const AViewBuilderName: string): TKView;
  protected
    procedure AfterCreateObject(const AObject: TKMetadata); override;
    function GetObjectClassType: TKMetadataClass; override;
    procedure SetPath(const AValue: string); override;
  public
    destructor Destroy; override;
  public
    function ViewByName(const AName: string): TKView;
    function FindView(const AName: string): TKView;

    function ViewByNode(const ANode: TEFNode): TKView;
    function FindViewByNode(const ANode: TEFNode): TKView;

    property Layouts: TKLayouts read GetLayouts;
    procedure Open; override;
    procedure Close; override;
  end;

  ///	<summary>
  ///	  A catalog of layouts. Internally used by the catalog of views.
  ///	</summary>
  TKLayouts = class(TKMetadataCatalog)
  protected
    procedure AfterCreateObject(const AObject: TKMetadata); override;
    function GetObjectClassType: TKMetadataClass; override;
  public
    function LayoutByName(const AName: string): TKLayout;
    function FindLayout(const AName: string): TKLayout;
  end;

  ///	<summary>
  ///	  A view that executes an action.
  ///	</summary>
  TKActionView = class(TKView)

  end;

  ///	<summary>The type of nodes in a tree view.</summary>
  TKTreeViewNode = class(TEFNode)
  private
    function GetTreeViewNodeCount: Integer;
    function GetTreeViewNode(I: Integer): TKTreeViewNode;
  protected
    function GetChildClass(const AName: string): TEFNodeClass; override;
  public
    property TreeViewNodeCount: Integer read GetTreeViewNodeCount;
    property TreeViewNodes[I: Integer]: TKTreeViewNode read GetTreeViewNode;
  end;

  ///	<summary>A node in a tree view that is a folder (i.e. contains other
  ///	nodes and doesn't represent a view).</summary>
  TKTreeViewFolder = class(TKTreeViewNode);

  ///	<summary>
  ///	  A view that is a tree of views. Contains views and folders, which
  ///  in turn contain views.
  ///	</summary>
  TKTreeView = class(TKView)
  private
    function GetTreeViewNode(I: Integer): TKTreeViewNode;
    function GetTreeViewNodeCount: Integer;
  protected
    function GetChildClass(const AName: string): TEFNodeClass; override;
  public
    property TreeViewNodeCount: Integer read GetTreeViewNodeCount;
    property TreeViewNodes[I: Integer]: TKTreeViewNode read GetTreeViewNode;
  end;

  TKViewBuilder = class(TKMetadata)
  public
    function BuildView: TKView; virtual; abstract;
  end;

  TKViewBuilderClass = class of TKViewBuilder;

  TKViewBuilderRegistry = class(TEFRegistry)
  private
    class var FInstance: TKViewBuilderRegistry;
    class function GetInstance: TKViewBuilderRegistry; static;
  protected
    class destructor Destroy;
  public
    class property Instance: TKViewBuilderRegistry read GetInstance;
    function GetClass(const AId: string): TKViewBuilderClass;
  end;

  TKViewBuilderFactory = class(TEFFactory)
  private
    class var FInstance: TKViewBuilderFactory;
    class function GetInstance: TKViewBuilderFactory; static;
  protected
    function DoCreateObject(const AClass: TClass): TObject; override;
  public
    class destructor Destroy;
  public
    class property Instance: TKViewBuilderFactory read GetInstance;

    function CreateObject(const AId: string): TKViewBuilder; reintroduce;
  end;

implementation

uses
  SysUtils, StrUtils, Variants, TypInfo,
  EF.DB, EF.StrUtils,
  Kitto.Types, Kitto.Config, Kitto.SQL;

{ TKViews }

procedure TKViews.AfterCreateObject(const AObject: TKMetadata);
begin
  inherited;
  (AObject as TKView).FViews := Self;
end;

procedure TKViews.Close;
begin
  inherited;
  if Assigned(FLayouts) then
    FLayouts.Close;
end;

destructor TKViews.Destroy;
begin
  FreeAndNil(FLayouts);
  inherited;
end;

function TKViews.FindView(const AName: string): TKView;
begin
  Result := FindObject(AName) as TKView;
end;

function TKViews.FindViewByNode(const ANode: TEFNode): TKView;
var
  LWords: TStringDynArray;
begin
  if Assigned(ANode) then
  begin
    LWords := Split(ANode.AsString);
    if Length(LWords) >= 2 then
    begin
      // Two words: the first one is the verb.
      if SameText(LWords[0], 'Build') then
      begin
        Result := BuildView(ANode, LWords[1]);
        Exit;
      end;
    end;
  end;
  Result := FindObjectByNode(ANode) as TKView;
end;

function TKViews.BuildView(const ANode: TEFNode; const AViewBuilderName: string): TKView;
var
  LViewBuilder: TKViewBuilder;
begin
  Assert(Assigned(ANode));
  Assert(AViewBuilderName <> '');

  LViewBuilder := TKViewBuilderFactory.Instance.CreateObject(AViewBuilderName);
  try
    LViewBuilder.Assign(ANode);
    Result := LViewBuilder.BuildView;
  finally
    FreeAndNil(LViewBuilder);
  end;
end;

function TKViews.GetLayouts: TKLayouts;
begin
  if not Assigned(FLayouts) then
    FLayouts := TKLayouts.Create;
  Result := FLayouts;
end;

function TKViews.GetObjectClassType: TKMetadataClass;
begin
  Result := TKView;
end;

procedure TKViews.Open;
begin
  inherited;
  Layouts.Open;
end;

procedure TKViews.SetPath(const AValue: string);
begin
  inherited;
  Layouts.Path := IncludeTrailingPathDelimiter(AValue) + 'Layouts';
end;

function TKViews.ViewByName(const AName: string): TKView;
begin
  Result := ObjectByName(AName) as TKView;
end;

function TKViews.ViewByNode(const ANode: TEFNode): TKView;
begin
  Result := FindViewByNode(ANode);
  if not Assigned(Result) then
    if Assigned(ANode) then
      ObjectNotFound(ANode.Name + ':' + ANode.AsString)
    else
      ObjectNotFound('<nil>');
end;

{ TKLayouts }

procedure TKLayouts.AfterCreateObject(const AObject: TKMetadata);
begin
  inherited;
  (AObject as TKLayout).FLayouts := Self;
end;

function TKLayouts.FindLayout(const AName: string): TKLayout;
begin
  Result := FindObject(AName) as TKLayout;
end;

function TKLayouts.GetObjectClassType: TKMetadataClass;
begin
  Result := TKLayout;
end;

function TKLayouts.LayoutByName(const AName: string): TKLayout;
begin
  Result := ObjectByName(AName) as TKLayout;
end;

{ TKView }

function TKView.GetControllerType: string;
begin
  Result := GetString('Controller');
end;

function TKView.GetDisplayLabel: string;
begin
  Result := GetString('DisplayLabel');
end;

function TKView.GetImageName: string;
begin
  Result := GetString('ImageName');
  if Result = '' then
    Result := DEFAULT_IMAGE_NAME;
end;

{ TKTreeViewNode }

function TKTreeViewNode.GetChildClass(const AName: string): TEFNodeClass;
begin
  if SameText(AName, 'Folder') then
    Result := TKTreeViewFolder
  else if SameText(AName, 'View') then
    Result := TKTreeViewNode
  else
    Result := inherited GetChildClass(AName);
end;

function TKTreeViewNode.GetTreeViewNode(I: Integer): TKTreeViewNode;
begin
  Result := GetChild<TKTreeViewNode>(I);
end;

function TKTreeViewNode.GetTreeViewNodeCount: Integer;
begin
  Result := GetChildCount<TKTreeViewNode>;
end;

{ TKTreeView }

function TKTreeView.GetChildClass(const AName: string): TEFNodeClass;
begin
  if SameText(AName, 'Folder') then
    Result := TKTreeViewFolder
  else if SameText(AName, 'View') then
    Result := TKTreeViewNode
  else
    Result := inherited GetChildClass(AName);
end;

function TKTreeView.GetTreeViewNode(I: Integer): TKTreeViewNode;
begin
  Result := GetChild<TKTreeViewNode>(I);
end;

function TKTreeView.GetTreeViewNodeCount: Integer;
begin
  Result := GetChildCount<TKTreeViewNode>;
end;

{ TKViewBuilderRegistry }

class destructor TKViewBuilderRegistry.Destroy;
begin
  FreeAndNil(FInstance);
end;

function TKViewBuilderRegistry.GetClass(const AId: string): TKViewBuilderClass;
begin
  Result := TKViewBuilderClass(inherited GetClass(AId));
end;

class function TKViewBuilderRegistry.GetInstance: TKViewBuilderRegistry;
begin
  if FInstance = nil then
    FInstance := TKViewBuilderRegistry.Create;
  Result := FInstance;
end;

{ TKViewBuilderFactory }

function TKViewBuilderFactory.CreateObject(const AId: string): TKViewBuilder;
begin
  Result := inherited CreateObject(AId) as TKViewBuilder;
end;

class destructor TKViewBuilderFactory.Destroy;
begin
  FreeAndNil(FInstance);
end;

function TKViewBuilderFactory.DoCreateObject(const AClass: TClass): TObject;
begin
  // Must use the virtual constructor in TEFTree.
  Result := TKViewBuilderClass(AClass).Create;
end;

class function TKViewBuilderFactory.GetInstance: TKViewBuilderFactory;
begin
  if FInstance = nil then
    FInstance := TKViewBuilderFactory.Create(TKViewBuilderRegistry.Instance);
  Result := FInstance;
end;

initialization
  TKMetadataRegistry.Instance.RegisterClass('Tree', TKTreeView);

finalization
  TKMetadataRegistry.Instance.UnregisterClass('Tree');

end.
