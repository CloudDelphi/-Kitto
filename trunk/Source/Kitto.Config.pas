unit Kitto.Config;

{$I Kitto.Defines.inc}

interface

uses
  SysUtils, Generics.Collections,
  EF.Tree, EF.Macros, EF.Classes, EF.DB,
  Kitto.Metadata.Models, Kitto.Metadata.Views, Kitto.Auth, Kitto.AccessControl;

type
  TKConfigMacroExpander = class;

  TKConfig = class;

  TKGetConfig = reference to function: TKConfig;

  TKConfig = class(TEFComponent)
  private
  class var
    FAppHomePath: string;
    FJSFormatSettings: TFormatSettings;
    FBaseConfigFileName: string;
    FOnGetInstance: TKGetConfig;
    FInstance: TKConfig;
    FResourcePathsURLs: TDictionary<string, string>;
    FSystemHomePath: string;
  var
    FDBConnections: TDictionary<string, TEFDBConnection>;
    FMacroExpansionEngine: TEFMacroExpansionEngine;
    FModels: TKModels;
    FViews: TKViews;
    FMacroExpander: TKConfigMacroExpander;
    FAuthenticator: TKAuthenticator;
    FAC: TKAccessController;
    FUserFormatSettings: TFormatSettings;

    class function GetInstance: TKConfig; static;
    function GetMultiFieldSeparator: string;
    const MAIN_DB_NAME = 'Main';
    function GetAC: TKAccessController;
    function GetDBConnection(const ADatabaseName: string): TEFDBConnection;
    function GetAuthenticator: TKAuthenticator;
    function GetMainDBConnection: TEFDBConnection;
    function GetDBAdapter(const ADatabaseName: string): TEFDBAdapter;
    function GetMacroExpansionEngine: TEFMacroExpansionEngine;
    function GetAppTitle: string;
    class function GetAppName: string;
    function GetModels: TKModels;
    function GetViews: TKViews;
    class procedure SetupResourcePathsURLs;
    procedure FinalizeDBConnections;
    class function GetAppHomePath: string; static;
    class procedure SetAppHomePath(const AValue: string); static;
    class function GetSystemHomePath: string; static;
    class procedure SetSystemHomePath(const AValue: string); static;
  protected
    function GetConfigFileName: string; override;
    class function FindSystemHomePath: string;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    class constructor Create;
    class destructor Destroy;
  public

    ///	<summary>
    ///	  <para>Returns or changes the Application Home path.</para>
    ///	  <para>The Application Home path defaults to the exe file directory
    ///	  unless specified through the '-home' command line argument.</para>
    ///	  <para>Setting this property, if necessary, should be done at
    ///	  application startup, preferably in a unit's initialization
    ///	  section.</para>
    ///	</summary>
    ///	<remarks>Changing this property affects all TKConfg instances created
    ///	from that point on, not existing instances.</remarks>
    class property AppHomePath: string read GetAppHomePath write SetAppHomePath;

    ///	<summary>
    ///	  <para>Returns or changes the System Home path, which is used to find
    ///	  any resources that are not found in the Application Home path.
    ///	  Generally, the System Home path contains all predefined metadata and
    ///	  resources of the framework.</para>
    ///	  <para>The System Home path defaults to a "Home" directory inside a
    ///	  nearby directory named "Kitto". The following paths, relative to the
    ///	  executable directory, are searched in order:</para>
    ///	  <list type="number">
    ///	    <item>..\Externals\Kitto\Home</item>
    ///	    <item>..\..\Externals\Kitto\Home</item>
    ///	    <item>..\..\..\Home</item>
    ///	  </list>
    ///	  <para>The first existing path is used. If none of these exist, the
    ///	  value of AppHomePath is assumed.</para>
    ///	  <para>If no default is suitable for your application, you can set
    ///	  this property at application startup, preferably in a unit's
    ///	  initialization section. If you also need to set AppHomePath, do it
    ///	  <b>before</b> setting this property.</para>
    ///	</summary>
    ///	<remarks>Changing this property affects all TKConfg instances created
    ///	from that point on, not existing instances.</remarks>
    class property SystemHomePath: string read GetSystemHomePath write SetSystemHomePath;

    ///	<summary>
    ///	  Returns the full path of the Metadata directory inside the home path.
    ///	</summary>
    class function GetMetadataPath: string;

    ///	<summary>
    ///	  Format settings for Javascript/JSON data encoded in text format. use
    ///	  it, don't change it.
    ///	</summary>
    class property JSFormatSettings: TFormatSettings read FJSFormatSettings;

    ///	<summary>
    ///	  Name of the config file. Defaults to Config.yaml. Changing this
    ///	  property only affects instances created afterwards.
    ///	</summary>
    class property BaseConfigFileName: string read FBaseConfigFileName write FBaseConfigFileName;

    ///	<summary>
    ///	  Sets a�global function that returns the global config object. In web
    ///	  applications there will be a config object per session.
    ///	</summary>
    class property OnGetInstance: TKGetConfig read FOnGetInstance write FOnGetInstance;

    ///	<summary>
    ///	  Returns a singleton instance.
    ///	</summary>
    class property Instance: TKConfig read GetInstance;

    ///	<summary>
    ///	  Returns the URL for the specified resource, based on the first
    ///	  existing file in the ordered list of resource folders. If no existing
    ///	  file is found, an exception is raised.
    ///	</summary>
    ///	<param name="AResourceFileName">
    ///	  Resource file name relative to the resource folder. Examples:
    ///	  some_image.png, js\some_library.js.
    ///	</param>
    class function GetResourceURL(const AResourceFileName: string): string;

    ///	<summary>Returns the URL for the specified resource, based on the first
    ///	existing file in the ordered list of resource folders. If no existing
    ///	file is found, returns ''.</summary>
    ///	<param name="AResourceFileName">Resource file name relative to the
    ///	resource folder. Examples: some_image.png, js\some_library.js.</param>
    class function FindResourceURL(const AResourceFileName: string): string;

    ///	<summary>Returns the full pathname for the specified resource, based on
    ///	the first existing file in the ordered list of resource folders. If no
    ///	existing file is found, returns ''.</summary>
    ///	<param name="AResourceFileName">Resource file name relative to the
    ///	resource folder. Examples: some_image.png, js\some_library.js.</param>
    class function FindResourcePathName(const AResourceFileName: string): string;

    ///	<summary>
    ///	  Returns the full pathname for the specified resource, based on the first
    ///	  existing file in the ordered list of resource folders. If no existing
    ///	  file is found, an exception is raised.
    ///	</summary>
    ///	<param name="AResourceFileName">
    ///	  Resource file name relative to the resource folder. Examples:
    ///	  some_image.png, js\some_library.js.
    ///	</param>
    class function GetResourcePathName(const AResourceFileName: string): string;

    class function GetImageURL(const AResourceName: string; const ASuffix: string = ''): string;

    ///	<summary>A reference to the model catalog, opened on first
    ///	access.</summary>
    property Models: TKModels read GetModels;

    ///	<summary>A reference to the model catalog, opened on first
    ///	access.</summary>
    property Views: TKViews read GetViews;

    ///	<summary>Gives access to the database connection, created on
    ///	demand.</summary>
    property MainDBConnection: TEFDBConnection read GetMainDBConnection;

    ///	<summary>Returns True if the connection has been created.</summary>
    function HasMainDBConnection: Boolean;

    ///	<summary>Returns the application title, to be used for captions, about
    ///	boxes, etc.</summary>
    property AppTitle: string read GetAppTitle;

    ///	<summary>
    ///	  Global expansion engine. Kitto-specific macro expanders should be
    ///	  added here at run time. This engine is chained to the default engine,
    ///	  so all default EF macros are supported.
    ///	</summary>
    property MacroExpansionEngine: TEFMacroExpansionEngine read GetMacroExpansionEngine;

    ///	<summary>Access to the current authenticator.</summary>
    property Authenticator: TKAuthenticator read GetAuthenticator;

    ///	<summary>The current Access Controller.</summary>
    property AC: TKAccessController read GetAC;

    ///	<summary>Calls AC.GetAccessGrantValue passing the current user and
    ///	returns the result.</summary>
    function GetAccessGrantValue(const AResourceURI, AMode: string;
      const ADefaultValue: Variant): Variant;

    ///	<summary>Shortcut for GetAccessGrantValue for Boolean
    ///	values. Returns True if a value is granted and it equals
    ///	ACV_TRUE.</summary>
    function IsAccessGranted(const AResourceURI, AMode: string): Boolean;

    ///	<summary>Calls IsAccessGranted and raises an "access denied" exception
    ///	if the return value is not True.</summary>
    procedure CheckAccessGranted(const AResourceURI, AMode: string);

    property UserFormatSettings: TFormatSettings read FUserFormatSettings;

    property MultiFieldSeparator: string read GetMultiFieldSeparator;
  end;

  ///	<summary>
  ///	  <para>
  ///	    A macro expander that can expand globally available macros.
  ///	  </para>
  ///	  <para>
  ///	    %HOME_PATH% = TKConfig.Instance.GetAppHomePath.
  ///	  </para>
  ///	  <para>
  ///	    It also expands any macros in the Config namespace to the
  ///	    corresponding environment config string. Example:
  ///	  </para>
  ///	  <para>
  ///	    %Config:AppTitle% = The string value of the AppTitle node in
  ///	    Config.yaml.
  ///	  </para>
  ///	</summary>
  TKConfigMacroExpander = class(TEFTreeMacroExpander)
  protected
    function InternalExpand(const AString: string): string; override;
  end;

implementation

uses
  StrUtils, Variants,
  EF.SysUtils, EF.YAML, EF.Localization,
  Kitto.Types;

procedure TKConfig.AfterConstruction;
var
  LLanguageId: string;
begin
  inherited;
  { TODO : read default user format settings from config and allow to change them on a per-user basis. }
  FUserFormatSettings := GetFormatSettings;
  FUserFormatSettings.ShortTimeFormat := Config.GetString('UserFormats/Time', FUserFormatSettings.ShortTimeFormat);
  FUserFormatSettings.ShortDateFormat := Config.GetString('UserFormats/Date', FUserFormatSettings.ShortDateFormat);

  FDBConnections := TDictionary<string, TEFDBConnection>.Create;
  LLanguageId := Config.GetString('LanguageId');
  if LLanguageId <> '' then
    TEFLocalizationToolRegistry.CurrentTool.ForceLanguage(LLanguageId);
  FMacroExpander := TKConfigMacroExpander.Create(Config, 'Config');
  MacroExpansionEngine.AddExpander(FMacroExpander);
end;

destructor TKConfig.Destroy;
begin
  inherited;
  FMacroExpansionEngine.RemoveExpander(FMacroExpander);
  FreeAndNil(FMacroExpander);
  FreeAndNil(FViews);
  FreeAndNil(FModels);
  if Assigned(FAuthenticator) then
    FMacroExpansionEngine.RemoveExpander(FAuthenticator.MacroExpander);
  FreeAndNil(FAuthenticator);
  FreeAndNil(FAC);
  FinalizeDBConnections;
  FreeAndNil(FDBConnections);
  FreeAndNil(FMacroExpansionEngine);
end;

class procedure TKConfig.SetupResourcePathsURLs;
var
  LPath: string;
begin
  FResourcePathsURLs.Clear;
  LPath := GetAppHomePath + 'Resources';
  if DirectoryExists(LPath) then
    FResourcePathsURLs.Add(IncludeTrailingPathDelimiter(LPath), '/' + GetAppName + '/');
  LPath := FindSystemHomePath + 'Resources';
  if DirectoryExists(LPath) and not FResourcePathsURLs.ContainsKey(IncludeTrailingPathDelimiter(LPath)) then
    FResourcePathsURLs.Add(IncludeTrailingPathDelimiter(LPath), '/' + GetAppName + '-Kitto/');
end;

procedure TKConfig.FinalizeDBConnections;
var
  I: Integer;
  LDBConnection: TEFDBConnection;
begin
  for I := 0 to FDBConnections.Count - 1 do
  begin
    LDBConnection := FDBConnections.Values.ToArray[I];
    FreeAndNil(LDBConnection);
  end;
end;

function TKConfig.IsAccessGranted(const AResourceURI,
  AMode: string): Boolean;
begin
  Result := GetAccessGrantValue(AResourceURI, AMode, Null) = ACV_TRUE;
end;

function TKConfig.GetMainDBConnection: TEFDBConnection;
begin
  Result := GetDBConnection(MAIN_DB_NAME);
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

function TKConfig.GetDBAdapter(const ADatabaseName: string): TEFDBAdapter;
begin
  Result := TEFDBAdapterRegistry.Instance[Config.GetExpandedString('Databases/' + ADatabaseName)];
end;

function TKConfig.GetMacroExpansionEngine: TEFMacroExpansionEngine;
begin
  if not Assigned(FMacroExpansionEngine) then
    FMacroExpansionEngine := TEFMacroExpansionEngine.Create(TEFMacroExpansionEngine.Instance);
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
    FModels.Path := GetMetadataPath + 'Models';
    FModels.Open;
  end;
  Result := FModels;
end;

function TKConfig.GetMultiFieldSeparator: string;
begin
  Result := Config.GetString('MultiFieldSeparator', '~~~');
end;

class function TKConfig.FindResourcePathName(const AResourceFileName: string): string;
var
  I: Integer;
begin
  I := 0;
  repeat
    Result := FResourcePathsURLs.Keys.ToArray[I] + AResourceFileName;
    Inc(I);
  until (I >= FResourcePathsURLs.Count) or FileExists(Result);

  if not FileExists(Result) then
    Result := '';
end;

class function TKConfig.GetResourcePathName(const AResourceFileName: string): string;
begin
  Result := FindResourcePathName(AResourceFileName);
  if Result = '' then
    raise EKError.CreateFmt('Resource %s not found.', [AResourceFileName]);
end;

class function TKConfig.FindResourceURL(const AResourceFileName: string): string;
var
  I: Integer;
  LResultURL: string;
begin
  I := 0;
  LResultURL := '';
  repeat
    Result := FResourcePathsURLs.Keys.ToArray[I] + AResourceFileName;
    LResultURL := FResourcePathsURLs.Values.ToArray[I] + ReplaceStr(AResourceFileName, '\', '/');
    Inc(I);
  until (I >= FResourcePathsURLs.Count) or FileExists(Result);

  if FileExists(Result) then
    Result := LResultURL
  else
    Result := ''
end;

class function TKConfig.GetResourceURL(const AResourceFileName: string): string;
begin
  Result := FindResourceURL(AResourceFileName);
  if Result = '' then
    raise EKError.CreateFmt('Resource %s not found.', [AResourceFileName]);
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
    FViews := TKViews.Create;
    FViews.Path := GetMetadataPath + 'Views';
    FViews.Open;
  end;
  Result := FViews;
end;

function TKConfig.HasMainDBConnection: Boolean;
begin
  Result := FDBConnections.ContainsKey(MAIN_DB_NAME);
end;

procedure TKConfig.CheckAccessGranted(const AResourceURI, AMode: string);
begin
  if not IsAccessGranted(AResourceURI, AMode) then
    raise EKAccessDeniedError.CreateWithAdditionalInfo(_('Access denied. The user is not allowed to perform this operation.'),
      Format(_('Resource URI: %s; access mode: %s.'), [AResourceURI, AMode]));
end;

class constructor TKConfig.Create;
begin
  FBaseConfigFileName := 'Config.yaml';

  FResourcePathsURLs := TDictionary<string, string>.Create;
  SetupResourcePathsURLs;

  FJSFormatSettings := TFormatSettings.Create;
  FJSFormatSettings := TFormatSettings.Create;
  FJSFormatSettings.DecimalSeparator := '.';
  FJSFormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  FJSFormatSettings.ShortTimeFormat := 'hh:mm:ss';
  FJSFormatSettings.DateSeparator := '/';
  FJSFormatSettings.TimeSeparator := ':';
  TEFYAMLReader.FormatSettings := FJSFormatSettings;
end;

class destructor TKConfig.Destroy;
begin
  FreeAndNil(FResourcePathsURLs);
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
    LType := Config.GetExpandedString('Auth', 'Null');
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
    LType := Config.GetExpandedString('AccessControl', 'Null');
    FAC := TKAccessControllerFactory.Instance.CreateObject(LType);
    LConfig := Config.FindNode('AccessControl');
    if Assigned(LConfig) then
      for I := 0 to LConfig.ChildCount - 1 do
        FAC.Config.AddChild(TEFNode.Clone(LConfig.Children[I]));
  end;
  Result := FAC;
end;

function TKConfig.GetConfigFileName: string;
begin
  Result := GetMetadataPath + FBaseConfigFileName;
end;

function TKConfig.GetAccessGrantValue(const AResourceURI,
  AMode: string; const ADefaultValue: Variant): Variant;
begin
  Result := AC.GetAccessGrantValue(Authenticator.UserName,
    AResourceURI, AMode, ADefaultValue);
end;

class function TKConfig.GetImageURL(const AResourceName, ASuffix: string): string;

  // Adds a .png extension to the resource name.
  // ASuffix, if specified, is added before the file extension.
  // If the image name ends with _ and a two-digit number among 16, 24, 32, and 48,
  // then the suffix is added before the _.
  function AdaptImageName(const AResourceName: string; const ASuffix: string = ''): string;

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

begin
  Result := GetResourceURL(AdaptImageName(AResourceName, ASuffix));
end;

class function TKConfig.GetInstance: TKConfig;
begin
  Result := nil;
  if Assigned(FOnGetInstance) then
    Result := FOnGetInstance();
  if not Assigned(Result) then
  begin
    if not Assigned(FInstance) then
      FInstance := TKConfig.Create;
    Result := FInstance;
  end;
end;

class procedure TKConfig.SetAppHomePath(const AValue: string);
begin
  if FAppHomePath <> AValue then
  begin
    FAppHomePath := AValue;
    SetupResourcePathsURLs;
  end;
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
        Result := GetAppHomePath;
    end;
  end;
end;

{ TKConfigMacroExpander }

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
  Result := ExpandMacros(Result, '%HOME_PATH%', TKConfig.GetAppHomePath);

  LPosHead := Pos(IMAGE_MACRO_HEAD, Result);
  if LPosHead > 0 then
  begin
    LPosTail := PosEx(MACRO_TAIL, Result, LPosHead + 1);
    if LPosTail > 0 then
    begin
      LName := Copy(Result, LPosHead + Length(IMAGE_MACRO_HEAD),
        LPosTail - (LPosHead + Length(IMAGE_MACRO_HEAD)));
      Result := Copy(Result, 1, LPosHead - 1) + TKConfig.GetImageURL(LName)
        + InternalExpand(Copy(Result, LPosTail + Length(MACRO_TAIL), MaxInt));
    end;
  end;
end;

end.
