unit Kitto.Ext.Controller;

{$I Kitto.Defines.inc}

interface

uses
  Classes,
  Ext, ExtPascal,
  EF.Intf, EF.ObserverIntf, EF.Tree, EF.Classes,
  Kitto.Types, Kitto.Metadata.Views;

type
  ///	<summary>
  ///	  Base interface for controllers. Controllers manages views to build
  ///   the user interface.
  ///	</summary>
  IKExtController = interface(IEFInterface)
    ['{FCDFC7CC-E202-4C20-961C-11255CABE497}']

    ///	<summary>
    ///	  Renders AView according to the Config.
    ///	</summary>
    procedure Display;

    function GetConfig: TEFNode;
    property Config: TEFNode read GetConfig;

    function GetView: TKView;
    procedure SetView(const AValue: TKView);
    property View: TKView read GetView write SetView;

    function GetContainer: TExtContainer;
    procedure SetContainer(const AValue: TExtContainer);
    property Container: TExtContainer read GetContainer write SetContainer;
  end;

  ///	<summary>
  ///	  Holds a list of registered controller classes.
  ///	</summary>
  ///	<remarks>
  ///	  Classes passed to RegisterClass and UnregisterClass must implement
  ///	  IKController, otherwise an exception is raised.
  ///	</remarks>
 { TODO :
allow to overwrite registrations in order to override predefined controllers;
keep track of all classes registered under the same name to handle
de-registration gracefully. }
  TKExtControllerRegistry = class(TEFRegistry)
  private
    class var FInstance: TKExtControllerRegistry;
    class function GetInstance: TKExtControllerRegistry; static;
  protected
    procedure BeforeRegisterClass(const AId: string; const AClass: TClass);
      override;
  public
    class destructor Destroy;
    class property Instance: TKExtControllerRegistry read GetInstance;
    procedure RegisterClass(const AId: string; const AClass: TExtObjectClass);
  end;

  ///	<summary>
  ///	  Queries the registry to create controllers by class Id. It is
  ///	  friend to TKControllerRegistry.
  ///	</summary>
  TKExtControllerFactory = class
  private
    class var FInstance: TKExtControllerFactory;
    class function GetInstance: TKExtControllerFactory; static;
  public
    class destructor Destroy;
    class property Instance: TKExtControllerFactory read GetInstance;

    function CreateController(const AView: TKView; const AContainer: TExtContainer;
      const AObserver: IEFObserver = nil; const ACustomType: string = ''): IKExtController;
  end;

implementation

uses
  SysUtils;

{ TKExtControllerRegistry }

procedure TKExtControllerRegistry.BeforeRegisterClass(const AId: string;
  const AClass: TClass);
begin
  if not AClass.InheritsFrom(TExtObject) or not Supports(AClass, IKExtController) then
    raise EKError.CreateFmt('Cannot register class %s (Id %s). Class is not a TExtObject descendant or does not support IKController.', [AClass.ClassName, AId]);
  inherited;
end;

class destructor TKExtControllerRegistry.Destroy;
begin
  FreeAndNil(FInstance);
end;

class function TKExtControllerRegistry.GetInstance: TKExtControllerRegistry;
begin
  if FInstance = nil then
    FInstance := TKExtControllerRegistry.Create;
  Result := FInstance;
end;

procedure TKExtControllerRegistry.RegisterClass(const AId: string;
  const AClass: TExtObjectClass);
begin
  inherited RegisterClass(AId, AClass);
end;

{ TKExtControllerFactory }

class destructor TKExtControllerFactory.Destroy;
begin
  FreeAndNil(FInstance);
end;

class function TKExtControllerFactory.GetInstance: TKExtControllerFactory;
begin
  if FInstance = nil then
    FInstance := TKExtControllerFactory.Create;
  Result := TKExtControllerFactory(FInstance);
end;

type
  TBreakExtObject = class(TExtObject);

function TKExtControllerFactory.CreateController(const AView: TKView;
  const AContainer: TExtContainer; const AObserver: IEFObserver;
  const ACustomType: string): IKExtController;
var
  LClass: TExtObjectClass;
  LIntf: IEFSubject;
  LObject: TExtObject;
  LType: string;
begin
  Assert(AView <> nil);

  LType := ACustomType;
  if LType = '' then
    LType := AView.ControllerType;

  if LType = '' then
    raise EKError.Create('Cannot create controller. Unspecified type.');

  LClass := TExtObjectClass(TKExtControllerRegistry.Instance.GetClass(LType));

  if Assigned(AContainer) then
    LObject := LClass.AddTo(AContainer.Items)
  else
  begin
    LObject := LClass.Create;
    { TODO : fix virtual construction in ExtPascal! }
    TBreakExtObject(LObject).InitDefaults;
  end;

  if not Supports(LObject, IKExtController, Result) then
    raise EKError.Create('Object does not support IKController.');

  Result.View := AView;
  Result.Container := AContainer;
  if Assigned(AObserver) and Supports(Result.AsObject, IEFSubject, LIntf) then
    Lintf.AttachObserver(AObserver);
end;

end.

