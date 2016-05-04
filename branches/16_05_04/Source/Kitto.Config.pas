{-------------------------------------------------------------------------------
   Copyright 2012 Ethea S.r.l.

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

unit Kitto.Config;

{$I Kitto.Defines.inc}

interface

uses
  SysUtils, Types, Generics.Collections,
  EF.Tree, EF.Macros, EF.Classes, EF.DB, EF.ObserverIntf,
  Kitto.Metadata.Models, Kitto.Metadata.Views, Kitto.Auth, Kitto.AccessControl;

type
  TKConfigMacroExpander = class;

  TKConfig = class;

  TKConfigClass = class of TKConfig;

  TKGetConfig = reference to function: TKConfig;

  TKConfigGetAppNameEvent = procedure (out AAppName: string) of object;

  TKConfig = class(TEFComponent)
  strict private
  type
    TPathURL = record
      Path: string;        
      URL: string;
      constructor Create(const APath, AURL: string);
    end;
  class var
    FAppHomePath: string;
    FJSFormatSettings: TFormatSettings;
    FBaseConfigFileName: string;
    FOnGetInstance: TKGetConfig;
    FInstance: TKConfig;
    FResourcePathsURLs: TList<TPathURL>;
    FSystemHomePath: string;
    FConfigClass: TKConfigClass;
    FOnGetAppName: TKConfigGetAppNameEvent;
  var
    FDBConnections: TDictionary<string, TEFDBConnection>;
    FMacroExpansionEngine: TEFMacroExpansionEngine;
    FModels: TKModels;
    FViews: TKViews;
    FAuthenticator: TKAuthenticator;
    FAC: TKAccessController;
    FUserFormatSettings: TFormatSettings;

    class function GetInstance: TKConfig; static;
    class function GetAppName: string; static;
    class procedure SetupResourcePathsURLs;
    class function GetAppHomePath: string; static;
    class procedure SetAppHomePath(const AValue: string); static;
    class function GetSystemHomePath: string; static;
    class procedure SetSystemHomePath(const AValue: string); static;

    function GetDBConnectionNames: TStringDynArray;
    function GetMultiFieldSeparator: string;
    function GetAC: TKAccessController;
    function GetDBConnection(const ADatabaseName: string): TEFDBConnection;
    function GetAuthenticator: TKAuthenticator;
    function GetDBAdapter(const ADatabaseName: string): TEFDBAdapter;
    function GetMacroExpansionEngine: TEFMacroExpansionEngine;
    function GetAppTitle: string;
    function GetAppIcon: string;
    function GetModels: TKModels;
    function GetViews: TKViews;
    procedure FinalizeDBConnections;
    function GetDefaultDatabaseName: string;
    function GetDatabaseName: string;
    function GetLanguagePerSession: Boolean;
    function GetFOPEnginePath: string;
    class function AdaptImageName(const AResourceName: string; const ASuffix: string = ''): string;
    function GetDefaultDBConnection: TEFDBConnection;
  strict protected
    function GetConfigFileName: string; override;
    class function FindSystemHomePath: string;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    class constructor Create;
    class destructor Destroy;
    procedure UpdateObserver(const ASubject: IEFSubject;
      const AContext: string = ''); override;
  public
    class procedure SetConfigClass(const AValue: TKConfigClass);

    class property AppName: string read GetAppName;
    class property OnGetAppName: TKConfigGetAppNameEvent read FOnGetAppName write FOnGetAppName;

    /// <summary>
    ///   <para>Returns or changes the Application Home path.</para>
    ///   <para>The Application Home path defaults to the exe file directory
    ///   unless specified through the '-home' command line argument.</para>
    ///   <para>Setting this property, if necessary, should be done at
    ///   application startup, preferably in a unit's initialization
    ///   section.</para>
    /// </summary>
    /// <remarks>Changing this property affects all TKConfg instances created
    /// from that point on, not existing instances.</remarks>
    class property AppHomePath: string read GetAppHomePath write SetAppHomePath;

    /// <summary>
    ///   <para>Returns or changes the System Home path, which is used to find
    ///   any resources that are not found in the Application Home path.
    ///   Generally, the System Home path contains all predefined metadata and
    ///   resources of the framework.</para>
    ///   <para>The System Home path defaults to a "Home" directory inside a
    ///   nearby directory named "Kitto". The following paths, relative to the
    ///   executable directory, are searched in order:</para>
    ///   <list type="number">
    ///     <item>..\Externals\Kitto\Home</item>
    ///     <item>..\..\Externals\Kitto\Home</item>
    ///     <item>..\..\..\Home</item>
    ///     <item>%KITTO%\Home</item>
    ///   </list>
    ///   <para>The first existing path is used. If none of these exist, the
    ///   value of AppHomePath is assumed.</para>
    ///   <para>If no default is suitable for your application, you can set
    ///   this property at application startup, preferably in a unit's
    ///   initialization section. If you also need to set AppHomePath, do it
    ///   <b>before</b> setting this property.</para>
    /// </summary>
    /// <remarks>Changing this property affects all TKConfg instances created
    /// from that point on, not existing instances.</remarks>
    class property SystemHomePath: string read GetSystemHomePath write SetSystemHomePath;

    /// <summary>
    ///   Returns the full path of the Metadata directory inside the home path.
    /// </summary>
    class function GetMetadataPath: string;

    /// <summary>
    ///   Format settings for Javascript/JSON data encoded in text format. use
    ///   it, don't change it.
    /// </summary>
    class property JSFormatSettings: TFormatSettings read FJSFormatSettings;

    /// <summary>
    ///   Name of the config file. Defaults to Config.yaml. Changing this
    ///   property only affects instances created afterwards.
    /// </summary>
    class property BaseConfigFileName: string read FBaseConfigFileName write FBaseConfigFileName;

    /// <summary>
    ///   Sets a�global function that returns the global config object. In web
    ///   applications there will be a config object per session.
    /// </summary>
    class property OnGetInstance: TKGetConfig read FOnGetInstance write FOnGetInstance;

    /// <summary>
    ///   Returns a singleton instance.
    /// </summary>
    class property Instance: TKConfig read GetInstance;

    /// <summary>
    ///   Returns the URL for the specified resource, based on the first
    ///   existing file in the ordered list of resource folders. If no existing
    ///   file is found, an exception is raised.
    /// </summary>
    /// <param name="AResourceFileName">
    ///   Resource file name relative to the resource folder. Examples:
    ///   some_image.png, js\some_library.js.
    /// </param>
    function GetResourceURL(const AResourceFileName: string): string;

    /// <summary>Returns the URL for the specified resource, based on the first
    /// existing file in the ordered list of resource folders. If no existing
    /// file is found, returns ''.</summary>
    /// <param name="AResourceFileName">Resource file name relative to the
    /// resource folder. Examples: some_image.png, js\some_library.js.</param>
    function FindResourceURL(const AResourceFileName: string): string;

    /// <summary>
    ///   Returns the full pathname for the specified resource, based on
    ///   the first existing file in the ordered list of resource folders. If no
    ///   existing file is found, returns ''.
    /// </summary>
    /// <param name="AResourceFileName">
    ///   Resource file name relative to the resource folder.
    ///   Examples: some_image.png, js\some_library.js.
    /// </param>
    function FindResourcePathName(const AResourceFileName: string): string;

    /// <summary>
    ///   Returns the full pathname for the specified resource, based on the first
    ///   existing file in the ordered list of resource folders. If no existing
    ///   file is found, an exception is raised.
    /// </summary>
    /// <param name="AResourceFileName">
    ///   Resource file name relative to the resource folder. Examples:
    ///   some_image.png, js\some_library.js.
    /// </param>
    function GetResourcePathName(const AResourceFileName: string): string;

    function FindImagePath(const AResourceName: string; const ASuffix: string = ''): string;

    function FindImageURL(const AResourceName: string; const ASuffix: string = ''): string;
    function GetImageURL(const AResourceName: string; const ASuffix: string = ''): string;

    /// <summary>A reference to the model catalog, opened on first
    /// access.</summary>
    property Models: TKModels read GetModels;

    /// <summary>A reference to the model catalog, opened on first
    /// access.</summary>
    property Views: TKViews read GetViews;

    /// <summary>Makes sure catalogs are recreated upon next access.</summary>
    procedure InvalidateCatalogs;

    /// <summary>Returns the Home URL of the Kitto application (lowercase of AppName)</summary>
    function GetHomeURL: string;

    /// <summary>Gives access to a database connection by name, created on
    /// demand.</summary>
    property DBConnections[const AName: string]: TEFDBConnection read GetDBConnection;

    /// <summary>Returns the names of all defined database
    /// connections.</summary>
    property DBConnectionNames: TStringDynArray read GetDBConnectionNames;

    /// <summary>Default DatabaseName to use when not specified elsewhere. Can
    /// be set through the DatabaseRouter/DatabaseName node or through the
    /// DefaultDatabaseName node.</summary>
    property DatabaseName: string read GetDatabaseName;

    /// <summary>
    ///  Returns a reference to the default database connection, if any.
    /// </summary>
    property DefaultDBConnection: TEFDBConnection read GetDefaultDBConnection;

    /// <summary>Returns the application title, to be used for captions, about
    /// boxes, etc.</summary>
    property AppTitle: string read GetAppTitle;

    /// <summary>Returns the application Icon, to be used mobile apps
    /// and Browser</summary>
    property AppIcon: string read GetAppIcon;

    /// <summary>
    ///   Global expansion engine. Kitto-specific macro expanders should be
    ///   added here at run time. This engine is chained to the default engine,
    ///   so all default EF macros are supported.
    /// </summary>
    property MacroExpansionEngine: TEFMacroExpansionEngine read GetMacroExpansionEngine;

    /// <summary>Access to the current authenticator.</summary>
    property Authenticator: TKAuthenticator read GetAuthenticator;

    /// <summary>The current Access Controller.</summary>
    property AC: TKAccessController read GetAC;

    /// <summary>Calls AC.GetAccessGrantValue passing the current user and
    /// returns the result.</summary>
    function GetAccessGrantValue(const AACURI, AMode: string;
      const ADefaultValue: Variant): Variant; virtual;

    /// <summary>Shortcut for GetAccessGrantValue for Boolean
    /// values. Returns True if a value is granted and it equals
    /// ACV_TRUE.</summary>
    function IsAccessGranted(const AACURI, AMode: string): Boolean;

    /// <summary>Calls IsAccessGranted and raises an "access denied" exception
    /// if the return value is not True.</summary>
    procedure CheckAccessGranted(const AResourceURI, AMode: string);

    property UserFormatSettings: TFormatSettings read FUserFormatSettings;

    property MultiFieldSeparator: string read GetMultiFieldSeparator;

    property LanguagePerSession: Boolean read GetLanguagePerSession;

    /// <summary>
    ///   <para>Returns or changes the home path for FOP engine.</para>
    /// </summary>
    property FOPEnginePath: string read GetFOPEnginePath;
  end;

  /// <summary>
  ///   <para>
  ///     A macro expander that can expand globally available macros.
  ///   </para>
  ///   <para>
  ///     %HOME_PATH% = TKConfig.Instance.GetAppHomePath.
  ///   </para>
  ///   <para>
  ///     It also expands any macros in the Config namespace to the
  ///     corresponding environment config string. Example:
  ///   </para>
  ///   <para>
  ///     %Config:AppTitle% = The string value of the AppTitle node in
  ///     Config.yaml.
  ///   </para>
  /// </summary>
  TKConfigMacroExpander = class(TEFTreeMacroExpander)
  strict private
    FConfig: TKConfig;
  strict protected
    property Config: TKConfig read FConfig;
    function InternalExpand(const AString: string): string; override;
  public
    constructor Create(const AConfig: TKConfig); reintroduce;
  end;

implementation

uses
  StrUtils, Variants,
  EF.SysUtils, EF.YAML, EF.Localization,
  Kitto.Types, Kitto.DatabaseRouter;

procedure TKConfig.AfterConstruction;
begin
  inherited;
  { TODO : read default user format settings from config and allow to change them on a per-user basis. }
  FUserFormatSettings := GetFormatSettings;

  FUserFormatSettings.ShortTimeFormat := Config.GetString('UserFormats/Time', FUserFormatSettings.ShortTimeFormat);
  if Pos('.', FUserFormatSettings.ShortTimeFormat) > 0 then
    FUserFormatSettings.TimeSeparator := '.'
  else
    FUserFormatSettings.TimeSeparator := ':';

  FUserFormatSettings.ShortDateFormat := Config.GetString('UserFormats/Date', FUserFormatSettings.ShortDateFormat);
  if Pos('.', FUserFormatSettings.ShortDateFormat) > 0 then
    FUserFormatSettings.DateSeparator := '.'
  else if Pos('-', FUserFormatSettings.ShortDateFormat) > 0 then
    FUserFormatSettings.DateSeparator := '-'
  else
    FUserFormatSettings.DateSeparator := '/';

  FDBConnections := TDictionary<string, TEFDBConnection>.Create;
end;

destructor TKConfig.Destroy;
begin
  inherited;
  FreeAndNil(FViews);
  FreeAndNil(FModels);
  if Assigned(FAuthenticator) then
    FMacroExpansionEngine.RemoveExpander(FAuthenticator.MacroExpander);
  FreeAndNil(FAuthenticator);
  FreeAndNil(FAC);
  FinalizeDBConnections;
  FreeAndNil(FMacroExpansionEngine);
end;

class procedure TKConfig.SetupResourcePathsURLs;
var
  LPath: string;

  function PathInList(const APath: string): Boolean;
  var
    LPathURL: TPathURL;
  begin
    Result := False;
    for LPathURL in FResourcePathsURLs do
      if SameText(LPathURL.Path, APath) then
        Exit(True);      
  end;
  
begin
  FResourcePathsURLs.Clear;
  LPath := GetAppHomePath + 'Resources';
  if DirectoryExists(LPath) then
    FResourcePathsURLs.Add(TPathURL.Create(IncludeTrailingPathDelimiter(LPath), '/' + GetAppName + '/'));
  LPath := FindSystemHomePath + 'Resources';
  if DirectoryExists(LPath) and not PathInList(IncludeTrailingPathDelimiter(LPath)) then
    FResourcePathsURLs.Add(TPathURL.Create(IncludeTrailingPathDelimiter(LPath), '/' + GetAppName + '-Kitto/'));
end;

procedure TKConfig.UpdateObserver(const ASubject: IEFSubject;
  const AContext: string);
begin
  inherited;
  NotifyObservers(AContext);
end;

procedure TKConfig.FinalizeDBConnections;
var
  LDBConnection: TEFDBConnection;
begin
  for LDBConnection in FDBConnections.Values do
    LDBConnection.Free;
  FreeAndNil(FDBConnections);
end;

procedure TKConfig.InvalidateCatalogs;
begin
  FreeAndNil(FViews);
  FreeAndNil(FModels);
end;

function TKConfig.IsAccessGranted(const AACURI, AMode: string): Boolean;
begin
  Result := GetAccessGrantValue(AACURI, AMode, Null) = ACV_TRUE;
end;

function TKConfig.GetDBConnection(const ADatabaseName: string): TEFDBConnection;
var
  LConfig: TEFNode;
begin
  if not FDBConnections.ContainsKey(ADatabaseName) then
  begin
    Result := GetDBAdapter(ADatabaseName).CreateDBConnection;
    Result.Config.AddChild(TEFNode.Clone(Config.GetNode('Databases/' + ADatabaseName + '/Connection')));
    LConfig := Config.FindNode('Databases/' + ADatabaseName + '/Config');
    if Assigned(LConfig) then
      Result.Config.AddChild(TEFNode.Clone(LConfig));
    FDBConnections.Add(ADatabaseName, Result);
  end
  else
    Result := FDBConnections[ADatabaseName];
end;

function TKConfig.GetDBConnectionNames: TStringDynArray;
var
  LNode: TEFNode;
begin
  LNode := Config.FindNode('Databases');
  if Assigned(LNode) then
    Result := LNode.GetChildNames
  else
    Result := nil;
end;

function TKConfig.GetDatabaseName: string;
var
  LDatabaseRouterNode: TEFNode;
begin
  LDatabaseRouterNode := Config.FindNode('DatabaseRouter');
  if Assigned(LDatabaseRouterNode) then
    Result := TKDatabaseRouterFactory.Instance.GetDatabaseName(
      LDatabaseRouterNode.AsString, Self, LDatabaseRouterNode)
  else
    Result := GetDefaultDatabaseName;
end;

function TKConfig.GetDefaultDatabaseName: string;
begin
  Result := Config.GetExpandedString('DefaultDatabaseName', 'Main');
end;

function TKConfig.GetDefaultDBConnection: TEFDBConnection;
begin
  Result := DBConnections[DatabaseName];
end;

function TKConfig.GetFOPEnginePath: string;
begin
  Result := Config.GetExpandedString('FOPEnginePath');
end;

function TKConfig.GetHomeURL: string;
begin
  Result := LowerCase(Format('http://localhost/kitto/%s', [Self.AppName]));
end;

function TKConfig.GetDBAdapter(const ADatabaseName: string): TEFDBAdapter;
var
  LDbAdapterKey: string;
begin
  Try
    LDbAdapterKey := Config.GetExpandedString('Databases/' + ADatabaseName);
    Result := TEFDBAdapterRegistry.Instance[LDbAdapterKey];
  except
    raise EKError.CreateFmt(_('DB connection type "%s" for database "%s" not available'),
      [LDbAdapterKey, ADatabaseName]);
  end;
end;

function TKConfig.GetMacroExpansionEngine: TEFMacroExpansionEngine;
begin
  if not Assigned(FMacroExpansionEngine) then
  begin
    FMacroExpansionEngine := TEFMacroExpansionEngine.Create;
    FMacroExpansionEngine.OnGetFormatSettings :=
      function: TFormatSettings
      begin
        Result := UserFormatSettings;
      end;
    AddStandardMacroExpanders(FMacroExpansionEngine);
    FMacroExpansionEngine.AddExpander(TKConfigMacroExpander.Create(Self));
  end;
  Result := FMacroExpansionEngine;
end;

class function TKConfig.GetMetadataPath: string;
begin
  Result := GetAppHomePath + IncludeTrailingPathDelimiter('Metadata');
end;

function TKConfig.GetModels: TKModels;
begin
  if not Assigned(FModels) then
  begin
    FModels := TKModels.Create;
    FModels.AttachObserver(Self);
    FModels.Path := GetMetadataPath + 'Models';
    FModels.Open;
  end;
  Result := FModels;
end;

function TKConfig.GetMultiFieldSeparator: string;
begin
  Result := Config.GetString('MultiFieldSeparator', '~');
end;

function TKConfig.FindResourcePathName(const AResourceFileName: string): string;
var
  LPathURL: TPathURL;
  LPath: string;
begin
  Result := '';
  for LPathURL in FResourcePathsURLs do
  begin
    LPath := LPathURL.Path + AResourceFileName;
    if FileExists(LPath) then
    begin
      Result := LPath;
      Break;
    end;
  end;
end;

function TKConfig.GetResourcePathName(const AResourceFileName: string): string;
begin
  Result := FindResourcePathName(AResourceFileName);
  if Result = '' then
    raise EKError.CreateFmt(_('Resource %s not found.'), [AResourceFileName]);
end;

function TKConfig.FindResourceURL(const AResourceFileName: string): string;

  function TryFind(const AName: string): string;
  var
    LURL: TPathURL;
    LPath: string;
  begin
    Result := '';
    for LURL in FResourcePathsURLs do
    begin
      LPath := LURL.Path + AName;
      if FileExists(LPath) then
      begin
        Result := LURL.URL + ReplaceStr(AName, '\', '/');
        Break;
      end;
    end;
  end;

var
  LLocalizedName: string;
begin
  if SameText(Config.GetString('LanguageId'), 'en') or SameText(Config.GetString('LanguageId'), '') then
    Result := TryFind(AResourceFileName)
  else begin
    LLocalizedName := ChangeFileExt(AResourceFileName, '_' + Config.GetString('LanguageId') + ExtractFileExt(AResourceFileName));
    Result := TryFind(LLocalizedName);
    if Result = '' then
      Result := TryFind(AResourceFileName);
  end;
end;

function TKConfig.GetResourceURL(const AResourceFileName: string): string;
begin
  Result := FindResourceURL(AResourceFileName);
  if Result = '' then
    raise EKError.CreateFmt(_('Resource %s not found.'), [AResourceFileName]);
end;

class function TKConfig.GetSystemHomePath: string;
begin
  if FSystemHomePath <> '' then
    Result := FSystemHomePath
  else
    Result := FindSystemHomePath;
  Result := IncludeTrailingPathDelimiter(Result);
end;

function TKConfig.GetViews: TKViews;
begin
  if not Assigned(FViews) then
  begin
    FViews := TKViews.Create(Models);
    FViews.AttachObserver(Self);
    FViews.Layouts.AttachObserver(Self);
    FViews.Path := GetMetadataPath + 'Views';
    FViews.Open;
  end;
  Result := FViews;
end;

procedure TKConfig.CheckAccessGranted(const AResourceURI, AMode: string);
var
  LErrorMsg: string;
begin
  if not IsAccessGranted(AResourceURI, AMode) then
  begin
    LErrorMsg := _('Access denied. The user is not allowed to perform this operation.');
    {$IFDEF DEBUG}
    LErrorMsg := LErrorMsg + sLineBreak +
      Format(_('Resource URI: %s; access mode: %s.'), [AResourceURI, AMode]);
    {$ENDIF}
    raise EKAccessDeniedError.Create(LErrorMsg);
  end;
end;

class constructor TKConfig.Create;
begin
  FConfigClass := TKConfig;
  FBaseConfigFileName := 'Config.yaml';

  FResourcePathsURLs := TList<TPathURL>.Create;
  SetupResourcePathsURLs;

  FJSFormatSettings := GetFormatSettings;
  FJSFormatSettings.DecimalSeparator := '.';
  FJSFormatSettings.ThousandSeparator := ',';
  FJSFormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  FJSFormatSettings.ShortTimeFormat := 'hh:nn:ss';
  FJSFormatSettings.DateSeparator := '/';
  FJSFormatSettings.TimeSeparator := ':';
  TEFYAMLReader.FormatSettings := FJSFormatSettings;
end;

class destructor TKConfig.Destroy;
begin
  FreeAndNil(FResourcePathsURLs);
  FreeAndNil(FInstance);
end;

function TKConfig.GetAppTitle: string;
begin
  Result := Config.GetString('AppTitle', 'Kitto');
end;

function TKConfig.GetAuthenticator: TKAuthenticator;
var
  LType: string;
  LConfig: TEFNode;
  I: Integer;
begin
  if not Assigned(FAuthenticator) then
  begin
    LType := Config.GetExpandedString('Auth', NODE_NULL_VALUE);
    FAuthenticator := TKAuthenticatorFactory.Instance.CreateObject(LType);
    MacroExpansionEngine.AddExpander(FAuthenticator.MacroExpander);
    LConfig := Config.FindNode('Auth');
    if Assigned(LConfig) then
      for I := 0 to LConfig.ChildCount - 1 do
        FAuthenticator.Config.AddChild(TEFNode.Clone(LConfig.Children[I]));
  end;
  Result := FAuthenticator;
end;

function TKConfig.GetAC: TKAccessController;
var
  LType: string;
  LConfig: TEFNode;
  I: Integer;
begin
  if not Assigned(FAC) then
  begin
    LType := Config.GetExpandedString('AccessControl', NODE_NULL_VALUE);
    FAC := TKAccessControllerFactory.Instance.CreateObject(LType);
    LConfig := Config.FindNode('AccessControl');
    if Assigned(LConfig) then
    begin
      for I := 0 to LConfig.ChildCount - 1 do
        FAC.Config.AddChild(TEFNode.Clone(LConfig.Children[I]));
      FAC.Init;
    end;
  end;
  Result := FAC;
end;

function TKConfig.GetConfigFileName: string;
begin
  Result := GetMetadataPath + FBaseConfigFileName;
end;

function TKConfig.GetAccessGrantValue(const AACURI, AMode: string; const ADefaultValue: Variant): Variant;
begin
  Result := AC.GetAccessGrantValue(Authenticator.UserName, AACURI, AMode, ADefaultValue);
end;

// Adds a .png extension to the resource name.
// ASuffix, if specified, is added before the file extension.
// If the image name ends with _ and a two-digit number among 16, 24, 32, and 48,
// then the suffix is added before the _.
class function TKConfig.AdaptImageName(const AResourceName: string; const ASuffix: string = ''): string;

  function HasSize(const AName: string): Boolean;
  begin
    Result := EndsStr('_16', AName) or EndsStr('_24', AName)
      or EndsStr('_32', AName) or EndsStr('_48', AName);
  end;

begin
  Result := AResourceName;
  if HasSize(Result) then
    Insert(ASuffix, Result, Length(Result) - 2)
  else
    Result := Result + ASuffix;
  Result := Result + '.png';
end;

function TKConfig.GetAppIcon: string;
begin
  Result := Config.GetString('AppIcon', 'kitto_128');
end;

function TKConfig.GetImageURL(const AResourceName: string; const ASuffix: string = ''): string;
begin
  Result := GetResourceURL(AdaptImageName(AResourceName, ASuffix));
end;

function TKConfig.FindImagePath(const AResourceName: string; const ASuffix: string = ''): string;
begin
  Result := FindResourcePathName(AdaptImageName(AResourceName, ASuffix));
end;

function TKConfig.FindImageURL(const AResourceName, ASuffix: string): string;
begin
  Result := FindResourceURL(AdaptImageName(AResourceName, ASuffix));
end;

class function TKConfig.GetInstance: TKConfig;
begin
  Result := nil;
  if Assigned(FOnGetInstance) then
    Result := FOnGetInstance();
  if not Assigned(Result) then
  begin
    if not Assigned(FInstance) then
      FInstance := FConfigClass.Create;
    Result := FInstance;
  end;
end;

function TKConfig.GetLanguagePerSession: Boolean;
begin
  Result := Config.GetBoolean('LanguagePerSession', False);
end;

class procedure TKConfig.SetAppHomePath(const AValue: string);
begin
  if FAppHomePath <> AValue then
  begin
    FAppHomePath := AValue;
    SetupResourcePathsURLs;
  end;
end;

class procedure TKConfig.SetConfigClass(const AValue: TKConfigClass);
begin
  FConfigClass := AValue;
end;

class procedure TKConfig.SetSystemHomePath(const AValue: string);
begin
  if AValue <> SystemHomePath then
  begin
    FSystemHomePath := AValue;
    SetupResourcePathsURLs;
  end;
end;

class function TKConfig.GetAppName: string;
begin
  if Assigned(FOnGetAppName) then
    FOnGetAppName(Result)
  else
    Result := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
end;

class function TKConfig.GetAppHomePath: string;
begin
  if FAppHomePath = '' then
  begin
    FAppHomePath := GetCmdLineParamValue('home', ExtractFilePath(ParamStr(0)));
    if not IsAbsolutePath(FAppHomePath) then
      FAppHomePath := ExtractFilePath(ParamStr(0)) + FAppHomePath;
  end;
  Result := IncludeTrailingPathDelimiter(FAppHomePath);
end;

class function TKConfig.FindSystemHomePath: string;
var
  LExePath: string;
begin
  LExePath := ExtractFilePath(ParamStr(0));
  Result := LExePath + '..\Externals\Kitto\Home\';
  if not DirectoryExists(Result) then
  begin
    Result := LExePath + '..\..\Externals\Kitto\Home\';
    if not DirectoryExists(Result) then
    begin
      Result := LExePath + '..\..\..\Home\';
      if not DirectoryExists(Result) then
      begin
        Result := LExePath + '..\..\..\..\Kitto\Home\';
        if not DirectoryExists(Result) then
        begin
          Result := ExpandEnvironmentVariables('%KITTO%\Home\');
          if not DirectoryExists(Result) then
            Result := GetAppHomePath;
        end;
      end;
    end;
  end;
end;

{ TKConfigMacroExpander }

constructor TKConfigMacroExpander.Create(const AConfig: TKConfig);
begin
  Assert(Assigned(AConfig));

  FConfig := AConfig;
  inherited Create(AConfig.Config, 'Config');
end;

function TKConfigMacroExpander.InternalExpand(const AString: string): string;
const
  IMAGE_MACRO_HEAD = '%IMAGE(';
  MACRO_TAIL = ')%';
var
  LPosHead: Integer;
  LPosTail: Integer;
  LName: string;
begin
  Result := inherited InternalExpand(AString);
  Result := ExpandMacros(Result, '%HOME_PATH%', TKConfig.AppHomePath);

  LPosHead := Pos(IMAGE_MACRO_HEAD, Result);
  if LPosHead > 0 then
  begin
    LPosTail := PosEx(MACRO_TAIL, Result, LPosHead + 1);
    if LPosTail > 0 then
    begin
      LName := Copy(Result, LPosHead + Length(IMAGE_MACRO_HEAD),
        LPosTail - (LPosHead + Length(IMAGE_MACRO_HEAD)));
      Result := Copy(Result, 1, LPosHead - 1) + Config.GetImageURL(LName)
        + InternalExpand(Copy(Result, LPosTail + Length(MACRO_TAIL), MaxInt));
    end;
  end;
end;

{ TKConfig.TResourcePathURL }

constructor TKConfig.TPathURL.Create(const APath, AURL: string);
begin
  Path := APath;
  URL := AURL;
end;

end.
