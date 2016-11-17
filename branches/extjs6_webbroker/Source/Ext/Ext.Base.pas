unit Ext.Base;

interface

uses
  Classes
  , StrUtils
  , Kitto.JS
  , Kitto.JS.Types
  ;

type
  TExtObject = TJSObject;
  TExtObjectClass = TJSObjectClass;
  TExtExpression = TJSExpression;
  TExtProgressWaitConfig = class;
  TExtEventObjectSingleton = class;
  TExtSplitBarBasicLayoutAdapter = class;
  TExtTemplate = class;
  TExtQuickTipsSingleton = class;
  TExtElement = class;
  TExtAction = class;
  TExtDirectTransaction = class;
  TExtSplitBar = class;
  TExtComponent = class;
  TExtLayer = class;
  TExtXTemplate = class;
  TExtEditor = class;
  TExtColorPalette = class;
  TExtDatePicker = class;
  TExtBoxComponent = class;
  TExtToolbarItem = class;
  TExtProgressBar = class;
  TExtSpacer = class;
  TExtContainer = class;
  TExtButton = class;
  TExtDataView = class;
  TExtViewport = class;
  TExtPanel = class;
  TExtSplitButton = class;
  TExtToolbarSpacer = class;
  TExtToolbarTextItem = class;
  TExtToolbar = class;
  TExtToolbarSeparator = class;
  TExtTip = class;
  TExtToolbarFill = class;
  TExtButtonGroup = class;
  TExtCycleButton = class;
  TExtWindow = class;
  TExtTabPanel = class;
  TExtPagingToolbar = class;
  TExtToolTip = class;
  TExtQuickTip = class;
  TExtMessageBoxSingleton = class;

  TExtFormField = TExtBoxComponent;
  TExtMenuCheckItem = TExtComponent;
  TExtMenuMenu = TExtContainer;
  TExtDataRecord = TExtObject;

  TExtUtilObservable = class(TExtObject)
  public
    class function JSClassName: string; override;
    function AddListener(const AEventName: string; const AHandler: TExtExpression;
      const AScope: TExtObject = nil; const AOptions: TExtObject = nil): TExtExpression;
    function FireEvent(const AEventName: string; const AArgs: TJSObjectArray): TExtExpression;
    function &On(const AEventName: string; const AHandler: TExtExpression;
      const AScope: TExtObject = nil; const AOptions: TExtObject = nil): TExtExpression;
    function RemoveAllListeners(const AEventName: string): TExtExpression;
  end;

  TExtDataStore = TExtUtilObservable;

  TExtProgressWaitConfig = class(TExtObject)
  private
    FDuration: Integer;
    FInterval: Integer; // 1000
    FIncrement: Integer; // 10
    procedure SetDuration(const AValue: Integer);
    procedure SetInterval(const AValue: Integer);
    procedure SetIncrement(const AValue: Integer);
  public
    class function JSClassName: string; override;
    property Duration: Integer read FDuration write SetDuration;
    property Interval: Integer read FInterval write SetInterval;
    property Increment: Integer read FIncrement write SetIncrement;
  end;

  TExtEventObjectSingleton = class(TExtObject)
  end;

  TExtSplitBarBasicLayoutAdapter = class(TExtObject)
  public
    class function JSClassName: string; override;
  end;

  TExtTemplate = class(TExtObject)
  public
    class function JSClassName: string; override;
  end;

  TExtQuickTipsSingleton = class(TExtObject)
  public
    class function JSClassName: string; override;
    function Disable: TExtExpression;
    function Enable: TExtExpression;
    function Init(const AAutoRender: Boolean): TExtExpression;
  end;

  TExtElement = class(TExtObject)
  public
    class function JSClassName: string; override;
    function AddClass(const AClassName: string): TExtExpression;
  end;

  TExtAction = class(TExtObject)
  private
    FHandler: TExtExpression;
    FHidden: Boolean;

    FScope: TExtObject;
    FText: string;
    procedure _SetText(const AValue: string);
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
    function SetHandler(const AFn: TExtExpression; const AScope: TExtObject): TExtExpression;
    function SetHidden(const AHidden: Boolean): TExtExpression;
    function SetText(const AText: string): TExtExpression;
    property Text: string read FText write _SetText;
  end;

  TExtDirectTransaction = class(TExtObject)
  public
    class function JSClassName: string; override;
  end;

  TExtSplitBar = class(TExtUtilObservable)
  public
    class function JSClassName: string; override;
  end;

  // Procedural types for events TExtComponent
  TExtComponentOnAfterrender = procedure(This: TExtComponent) of object;

  // Enumerated types for properties
  TExtComponentXtype = (xtBox, xtButton, xtButtonGroup, xtColorPalette, xtComponent,
    xtContainer, xtCycle, xtDataView, xtDatePicker, xtEditor, xtEditorGrid, xtFlash,
    xtGrid, xtListView, xtPaging, xtPanel, xtProgress, xtPropertyGrid, xtSlider, xtSpacer,
    xtSplitButton, xtStatusBar, xtTabPanel, xtTreePanel, xtViewPort, xtWindow, xtToolbar,
    xtTBButton, xtTBFill, xtTBItem, xtTBSeparator, xtTBSpacer, xtTBSplit, xtTBText,
    xtMenu, xtColorMenu, xtDateMenu, xtMenuBaseItem, xtMenuCheckItem, xtMenuItem,
    xtMenuSeparator, xtMenuTextItem, xtForm, xtCheckBox, xtCheckBoxGroup, xtCombo,
    xtDateField, xtDisplayField, xtField, xtFieldSet, xtHidden, xtHTMLEditor, xtLabel,
    xtNumberField, xtRadio, xtRadioGroup, xtTextArea, xtTextField, xtTimeField, xtTrigger,
    xtChart, xtBarChart, xtCartesianChart, xtColumnChart, xtLineChart, xtPieChart);

  TExtComponent = class(TExtUtilObservable)
  private
    FMinSize: Integer;
    FItemId: string;
    FLabelStyle: string;
    FCollapseMode: string;
    FPlugins: TJSObjectArray;
    FLoader: TExtObject;
    FCls: string;
    FOverCls: string;
    FHtml: string;
    FMaxWidth: Integer;
    FLabelSeparator: string;
    FPadding: string;
    FHidden: Boolean;
    FId: string;
    FMinWidth: Integer;
    FSplit: Boolean;
    FFieldLabel: string;
    FOnAfterrender: TExtComponentOnAfterrender;
    FMaxSize: Integer;
    FItemCls: string;
    FDisabled: Boolean;
    FStyle: string;
    FTpl: string;
    procedure _SetDisabled(const AValue: Boolean);
    procedure SetFieldLabel(const AValue: string);
    procedure SetHidden(const AValue: Boolean);
    procedure SetHtml(const AValue: string);
    procedure SetId(const AValue: string);
    procedure SetItemCls(const AValue: string);
    procedure SetItemId(const AValue: string);
    procedure SetLabelSeparator(const AValue: string);
    procedure SetLabelStyle(const AValue: string);
    procedure SetOverCls(const AValue: string);
    procedure SetStyle(const AValue: string);
    procedure SetTpl(const AValue: string);
    procedure SetSplit(const AValue: Boolean);
    procedure SetCollapseMode(const AValue: string);
    procedure SetMinWidth(const AValue: Integer);
    procedure SetMaxWidth(const AValue: Integer);
    procedure SetMinSize(const AValue: Integer);
    procedure SetMaxSize(const AValue: Integer);
    procedure SetPadding(const AValue: string);
    procedure SetCls(const AValue: string);
    procedure SetOnAfterrender(const AValue: TExtComponentOnAfterrender);
  protected
    procedure InitDefaults; override;
  public
    procedure HandleEvent(const AEvtName: string); override;
    class function JSClassName: string; override;
    function AddCls(const AClsName: string): TExtExpression;
    function Focus(const ASelectText: Boolean = False; const ADelay: Boolean = False): TExtExpression; overload;
    function Focus(const ASelectText: Boolean; const ADelay: Integer): TExtExpression; overload;
    function Hide: TExtExpression;
    function SetDisabled(const AValue: Boolean): TExtExpression;
    function SetVisible(const AValue: Boolean): TExtExpression;
    function Show: TExtExpression;
    property Cls: string read FCls write SetCls;
    property Disabled: Boolean read FDisabled write _SetDisabled;
    property FieldLabel: string read FFieldLabel write SetFieldLabel;
    property Hidden: Boolean read FHidden write SetHidden;
    property Html: string read FHtml write SetHtml;
    property Id: string read FId write SetId;
    property ItemCls: string read FItemCls write SetItemCls;
    property ItemId: string read FItemId write SetItemId;
    property LabelSeparator: string read FLabelSeparator write SetLabelSeparator;
    property LabelStyle: string read FLabelStyle write SetLabelStyle;
    property Loader: TExtObject read FLoader;
    property OverCls: string read FOverCls write SetOverCls;
    property Padding: string read FPadding write SetPadding;
    property Plugins: TJSObjectArray read FPlugins;
    property Style: string read FStyle write SetStyle;
    property Tpl: string read FTpl write SetTpl;
    property Split: Boolean read FSplit write SetSplit;
    property CollapseMode: string read FCollapseMode write SetCollapseMode;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property MinSize: Integer read FMinSize write SetMinSize;
    property MaxSize: Integer read FMaxSize write SetMaxSize;
    property OnAfterrender: TExtComponentOnAfterrender read FOnAfterrender write SetOnAfterrender;
  end;

  TExtLayer = class(TExtElement)
  private
    FZindex: Integer; // 11000
    procedure _SetZindex(const AValue: Integer);
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
    function SetZIndex(const AZindex: Integer): TExtExpression;
    property Zindex: Integer read FZindex write _SetZindex;
  end;

  TExtXTemplate = class(TExtTemplate)
  public
    class function JSClassName: string; override;
  end;

  TExtEditor = class(TExtComponent)
  private
    FValue: string;
    procedure _SetValue(const AValue: string);
  public
    class function JSClassName: string; override;
    function SetValue(const AValue: string): TExtExpression;
    property Value: string read FValue write _SetValue;
  end;

  TExtColorPalette = class(TExtComponent)
  public
    class function JSClassName: string; override;
  end;

  TExtDatePicker = class(TExtComponent)
  private
    FMaxDate: TDateTime;
    FMinDate: TDateTime;
    procedure _SetMaxDate(const AValue: TDateTime);
    procedure _SetMinDate(const AValue: TDateTime);
  public
    class function JSClassName: string; override;
    function SetMaxDate(const AValue: TDateTime): TExtExpression;
    function SetMinDate(const AValue: TDateTime): TExtExpression;
    property MaxDate: TDateTime read FMaxDate write _SetMaxDate;
    property MinDate: TDateTime read FMinDate write _SetMinDate;
  end;

  // Enumerated types for properties
  TExtBoxComponentRegion = (rgCenter, rgNorth, rgEast, rgSouth, rgWest);

  TExtBoxComponent = class(TExtComponent)
  private
    FAutoHeight: Boolean;
    FWidthString: string;
    FWidth: Integer;
    FAutoScroll: Boolean;
    FHeightFunc: TExtExpression;
    FFlex: Integer;
    FMargins: string;
    FAnchor: string;
    FAutoWidth: Boolean;
    FHeightString: string;
    FRegion: TExtBoxComponentRegion;
    FHeight: Integer;
    FWidthExpression: TExtExpression;
    FOwnerCt: TExtContainer;
    procedure SetAnchor(const AValue: string);
    procedure SetAutoHeight(const AValue: Boolean);
    procedure _SetAutoScroll(const AValue: Boolean);
    procedure SetAutoWidth(const AValue: Boolean);
    procedure SetFlex(const AValue: Integer);
    procedure SetHeight(const AValue: Integer);
    procedure SetMargins(AValue: string);
    procedure SetRegion(const AValue: TExtBoxComponentRegion);
    procedure SetWidth(const AValue: Integer);
    procedure SetHeightString(const AValue: string);
    procedure SetWidthString(const AValue: string);
    procedure SetWidthExpression(const AValue: TExtExpression);
    procedure SetHeightFunc(const AValue: TExtExpression);
    procedure SetOwnerCt(const AValue: TExtContainer);
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
    property Anchor: string read FAnchor write SetAnchor;
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight;
    property AutoScroll: Boolean read FAutoScroll write _SetAutoScroll;
    property AutoWidth: Boolean read FAutoWidth write SetAutoWidth;
    property Flex: Integer read FFlex write SetFlex;
    property Height: Integer read FHeight write SetHeight;
    property HeightString: string read FHeightString write SetHeightString;
    property HeightFunc: TExtExpression read FHeightFunc write SetHeightFunc;
    property Margins: string read FMargins write SetMargins;
    property OwnerCt: TExtContainer read FOwnerCt write SetOwnerCt;
    property Region: TExtBoxComponentRegion read FRegion write SetRegion;
    property Width: Integer read FWidth write SetWidth;
    property WidthString: string read FWidthString write SetWidthString;
    property WidthExpression: TExtExpression read FWidthExpression write SetWidthExpression;
  end;

  TExtToolbarItem = class(TExtBoxComponent)
  public
    class function JSClassName: string; override;
  end;

  TExtProgressBar = class(TExtBoxComponent)
  public
    class function JSClassName: string; override;
  end;

  TExtSpacer = class(TExtBoxComponent)
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
  end;

  // Enumerated types for properties
  TExtContainerLayout = (lyAuto, lyAbsolute, lyAccordion, lyAnchor, lyBody,
    lyBorder, lyBoundlist, lyBox, lyCard, lyCenter, lyCheckboxgroup,
    lyColumn, lyColumncomponent, lyContainer, lyDashboard, lyDock, lyEditor,
    lyFieldContainer, lyFieldset, lyFit, lyForm, lyGridcolumn, lyHbox,
    lyResponsivecolumn, lySegmentedbutton, lyTable, lyTableview, lyVbox);
  TExtContainerLabelAlign = (laLeft, laRight, laTop);

  TExtContainer = class(TExtBoxComponent)
  private
    FActiveItem: string;
    FActiveItemNumber: Integer;
    FAutoDestroy: Boolean; // true
    FDefaults: TExtObject;
    FItems: TJSObjectArray;
    FLayout: TExtContainerLayout;
    FLayoutObject: TExtObject;
    FLayoutConfig: TExtObject;
    FLayoutString: string;
    FColumnWidth: Double;
    FLabelWidth: Integer;
    FLabelAlign: TExtContainerLabelAlign;
    FHideLabels: Boolean;
    procedure SetActiveItem(const AValue: string);
    procedure SetActiveItemNumber(const AValue: Integer);
    procedure SetLayout(const AValue: TExtContainerLayout);
    procedure SetColumnWidth(const AValue: Double);
    procedure SetLabelWidth(const AValue: Integer);
    procedure SetLabelAlign(const AValue: TExtContainerLabelAlign);
    procedure SetLayoutString(const AValue: string);
    procedure SetHideLabels(const AValue: Boolean);
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
    function UpdateLayout(const AShallow: Boolean; const AForce: Boolean): TExtExpression; overload;
    function UpdateLayout: TExtExpression; overload;
    function Remove(const AComponent: TExtComponent; const AAutoDestroy: Boolean = False): TExtExpression;
    property ActiveItem: string read FActiveItem write SetActiveItem;
    property ActiveItemNumber: Integer read FActiveItemNumber write SetActiveItemNumber;
    property Defaults: TExtObject read FDefaults;
    property HideLabels: Boolean read FHideLabels write SetHideLabels;
    property Items: TJSObjectArray read FItems;
    property LabelAlign: TExtContainerLabelAlign read FLabelAlign write SetLabelAlign;
    property LabelWidth: Integer read FLabelWidth write SetLabelWidth;
    property Layout: TExtContainerLayout read FLayout write SetLayout;
    property LayoutConfig: TExtObject read FLayoutConfig;
    property LayoutString: string read FLayoutString write SetLayoutString;
    property ColumnWidth: Double read FColumnWidth write SetColumnWidth;
  end;

  TExtButton = class(TExtBoxComponent)
  private
    FAllowDepress: Boolean;
    FDisabled: Boolean;
    FEnableToggle: Boolean;
    FFormBind: Boolean;
    FHandleMouseEvents: Boolean; // true
    FHandler: TExtExpression;
    FHidden: Boolean;
    FIcon: string;
    FIconCls: string;
    FMenu: TExtUtilObservable;
    FMinWidth: Integer;
    FPressed: Boolean;
    FScale: string;
    FScope: TExtObject;
    FTemplate: TExtTemplate;
    FText: string;
    FToggleGroup: string;
    FTooltip: string;
    FTooltipObject: TExtObject;
    FBtnEl: TExtElement;
    procedure SetAllowDepress(const AValue: Boolean);
    procedure SetDisabled(const AValue: Boolean);
    procedure SetEnableToggle(const AValue: Boolean);
    procedure SetFormBind(const AValue: Boolean);
    procedure _SetHandler(const AValue: TExtExpression);
    procedure SetHidden(const AValue: Boolean);
    procedure _SetIcon(const AValue: string);
    procedure SetIconCls(const AValue: string);
    procedure SetMenu(AValue: TExtUtilObservable);
    procedure SetPressed(const AValue: Boolean);
    procedure SetScale(const AValue: string);
    procedure _SetText(const AValue: string);
    procedure SetToggleGroup(const AValue: string);
    procedure _SetTooltip(const AValue: string);
    procedure SetMinWidth(const AValue: Integer);
  protected
    procedure InitDefaults; override;
    function GetObjectNamePrefix: string; override;
  public
    class function JSClassName: string; override;
    function GetPressed(const AGroup: string): TExtExpression;
    function Pressed_: TExtExpression;
    function GetTemplateArgs: TExtExpression;
    function GetText: TExtExpression;
    function HasVisibleMenu: TExtExpression;
    function HideMenu: TExtExpression;
    function PerformClick: TExtExpression;
    function SetHandler(const AHandler: TExtExpression; const AScope: TExtObject = nil): TExtExpression;
    function SetText(const AText: string): TExtExpression;
    function SetTooltip(const ATooltip: string): TExtExpression; overload;
    function SetTooltip(const ATooltip: TExtObject): TExtExpression; overload;
    property AllowDepress: Boolean read FAllowDepress write SetAllowDepress;
    property Disabled: Boolean read FDisabled write SetDisabled;
    property EnableToggle: Boolean read FEnableToggle write SetEnableToggle;
    property FormBind: Boolean read FFormBind write SetFormBind;
    property Handler: TExtExpression read FHandler write _SetHandler;
    property Hidden: Boolean read FHidden write SetHidden;
    property Icon: string read FIcon write _SetIcon;
    property IconCls: string read FIconCls write SetIconCls;
    property Menu: TExtUtilObservable read FMenu write SetMenu;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property Pressed: Boolean read FPressed write SetPressed;
    property Scale: string read FScale write SetScale;
    property Text: string read FText write _SetText;
    property ToggleGroup: string read FToggleGroup write SetToggleGroup;
    property Tooltip: string read FTooltip write _SetTooltip;
  end;

  TExtDataView = class(TExtBoxComponent)
  private
    FEmptyText: string;
    FItemSelector: string;
    FMultiSelect: Boolean;
    FOverClass: string;
    FSelectedClass: string; // 'x-view-selected'
    FSimpleSelect: Boolean;
    FSingleSelect: Boolean;
    FStore: TExtDataStore;
    FTpl: string;
    FTplArray: TJSObjectArray;
    FStoreArray: TJSObjectArray;
    procedure SetEmptyText(AValue: string);
    procedure SetItemSelector(const AValue: string);
    procedure SetMultiSelect(const AValue: Boolean);
    procedure SetOverClass(const AValue: string);
    procedure SetSimpleSelect(const AValue: Boolean);
    procedure SetSingleSelect(const AValue: Boolean);
    procedure _SetStore(const AValue: TExtDataStore);
    procedure SetTpl(AValue: string);
    procedure SetStoreArray(const AValue: TJSObjectArray);
    procedure SetSelectedClass(const AValue: string);
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
    function SetStore(const AStore: TExtDataStore): TExtExpression;
    property EmptyText: string read FEmptyText write SetEmptyText;
    property ItemSelector: string read FItemSelector write SetItemSelector;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property OverClass: string read FOverClass write SetOverClass;
    property SelectedClass: string read FSelectedClass write SetSelectedClass;
    property SimpleSelect: Boolean read FSimpleSelect write SetSimpleSelect;
    property SingleSelect: Boolean read FSingleSelect write SetSingleSelect;
    property Store: TExtDataStore read FStore write _SetStore;
    property StoreArray: TJSObjectArray read FStoreArray write SetStoreArray;
    property Tpl: string read FTpl write SetTpl;
  end;

  TExtViewport = class(TExtContainer)
  protected
    function GetObjectNamePrefix: string; override;
  public
    class function JSClassName: string; override;
  end;

  TExtPanel = class(TExtContainer)
  private
    FFrame: Boolean;
    FBodyStyle: string;
    FTbar: TExtObject;
    FAutoLoadString: string;
    FAutoLoad: TExtObject;
    FPaddingString: string;
    FHeader: Boolean;
    FCollapsed: Boolean;
    FCollapsible: Boolean;
    FClosable: Boolean;
    FTitle: string;
    FBbar: TExtObject;
    FFbar: TJSObjectArray;
    FBorder: Boolean;
    FAnimCollapse: Boolean;
    FFooter: Boolean;
    FIconCls: string;
    FAutoLoadBoolean: Boolean;
    FButtons: TJSObjectArray;
    FMinButtonWidth: Integer;
    procedure SetAnimCollapse(const AValue: Boolean);
    procedure SetAutoLoad(const AValue: TExtObject);
    procedure SetAutoLoadString(const AValue: string);
    procedure SetAutoLoadBoolean(const AValue: Boolean);
    procedure SetBbar(const AValue: TExtObject);
    procedure SetBodyStyle(const AValue: string);
    procedure SetBorder(const AValue: Boolean);
    procedure SetClosable(const AValue: Boolean);
    procedure SetCollapsible(const AValue: Boolean);
    procedure SetFooter(const AValue: Boolean);
    procedure SetFrame(const AValue: Boolean);
    procedure SetHeader(const AValue: Boolean);
    procedure SetIconCls(const AValue: string);
    procedure SetPaddingString(const AValue: string);
    procedure _SetTitle(AValue: string);
    procedure SetCollapsed(const AValue: Boolean);
    procedure SetTbar(const AValue: TExtObject);
    procedure SetMinButtonWidth(const AValue: Integer);
  protected
    procedure InitDefaults; override;
    function GetObjectNamePrefix: string; override;
  public
    class function JSClassName: string; override;
    function Collapse(const AAnimate: Boolean): TExtExpression;
    function Expand(const AAnimate: Boolean): TExtExpression;
    function SetTitle(const ATitle: string; const AIconCls: string = ''): TExtExpression;
    property AnimCollapse: Boolean read FAnimCollapse write SetAnimCollapse;
    property AutoLoad: TExtObject read FAutoLoad write SetAutoLoad;
    property AutoLoadString: string read FAutoLoadString write SetAutoLoadString;
    property AutoLoadBoolean: Boolean read FAutoLoadBoolean write SetAutoLoadBoolean;
    property Bbar: TExtObject read FBbar write SetBbar;
    property BodyStyle: string read FBodyStyle write SetBodyStyle;
    property Border: Boolean read FBorder write SetBorder;
    property Buttons: TJSObjectArray read FButtons;
    property Closable: Boolean read FClosable write SetClosable;
    property Collapsible: Boolean read FCollapsible write SetCollapsible;
    property Collapsed: Boolean read FCollapsed write SetCollapsed;
    property Fbar: TJSObjectArray read FFbar;
    property Footer: Boolean read FFooter write SetFooter;
    property Frame: Boolean read FFrame write SetFrame;
    property Header: Boolean read FHeader write SetHeader;
    property IconCls: string read FIconCls write SetIconCls;
    property MinButtonWidth: Integer read FMinButtonWidth write SetMinButtonWidth;
    property PaddingString: string read FPaddingString write SetPaddingString;
    property Tbar: TExtObject read FTbar write SetTbar;
    property Title: string read FTitle write _SetTitle;
  end;

  TExtSplitButton = class(TExtButton)
  private
    FArrowHandler: TExtExpression;
    procedure _SetArrowHandler(const AValue: TExtExpression);
  public
    class function JSClassName: string; override;
    function SetArrowHandler(const AHandler: TExtExpression; const AScope: TExtObject = nil): TExtExpression;
    property ArrowHandler: TExtExpression read FArrowHandler write _SetArrowHandler;
  end;

  TExtToolbarSpacer = class(TExtToolbarItem)
  protected
    function GetObjectNamePrefix: string; override;
  public
    class function JSClassName: string; override;
  end;

  TExtToolbarTextItem = class(TExtToolbarItem)
  private
    FText: string;
    procedure _SetText(const AValue: string);
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
    function SetText(const AText: string): TExtExpression;
    property Text: string read FText write _SetText;
  end;

  TExtToolbar = class(TExtContainer)
  protected
    function GetObjectNamePrefix: string; override;
  public
    class function JSClassName: string; override;
  end;

  TExtToolbarSeparator = class(TExtToolbarItem)
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
  end;

  TExtTip = class(TExtPanel)
  public
    class function JSClassName: string; override;
  end;

  TExtToolbarFill = class(TExtToolbarSpacer)
  protected
    procedure InitDefaults; override;
  public
    class function JSClassName: string; override;
  end;

  TExtButtonGroup = class(TExtPanel)
  public
    class function JSClassName: string; override;
  end;

  TExtCycleButton = class(TExtSplitButton)
  public
    class function JSClassName: string; override;
  end;

  TExtWindow = class(TExtPanel)
  private
    FAnimateTarget: string;
    FAnimateTargetElement: TExtElement;
    FBaseCls: string; // 'x-window'
    FButtons: TJSObjectArray;
    FClosable: Boolean; // true
    FConstrain: Boolean;
    FDraggable: Boolean; // true
    FExpandOnShow: Boolean; // true
    FInitHidden: Boolean; // true
    FMaximizable: Boolean;
    FMaximized: Boolean;
    FMinHeight: Integer; // 100
    FMinWidth: Integer; // 200
    FModal: Boolean;
    FPlain: Boolean;
    FResizable: Boolean; // true
    FResizeHandles: string; // 'all'
    procedure _SetAnimateTarget(const AValue: string);
    procedure SetClosable(const AValue: Boolean);
    procedure SetConstrain(const AValue: Boolean);
    procedure SetDraggable(const AValue: Boolean);
    procedure SetMaximizable(const AValue: Boolean);
    procedure SetMaximized(const AValue: Boolean);
    procedure SetModal(const AValue: Boolean);
    procedure SetPlain(const AValue: Boolean);
    procedure SetResizable(const AValue: Boolean);
    procedure SetResizeHandles(const AValue: string);
  protected
    procedure InitDefaults; override;
    function GetObjectNamePrefix: string; override;
  public
    class function JSClassName: string; override;
    function Close: TExtExpression;
    procedure SetAnimateTarget(const AElement: string);
    function Show(const AAnimateTarget: string = ''; const ACallback: TExtExpression = nil;
      const AScope: TExtObject = nil): TExtExpression; overload;
    function Show(const AAnimateTarget: TExtElement; const ACallback: TExtExpression = nil;
      const AScope: TExtObject = nil): TExtExpression; overload;
    property AnimateTarget: string read FAnimateTarget write _SetAnimateTarget;
    property Buttons: TJSObjectArray read FButtons;
    property Closable: Boolean read FClosable write SetClosable;
    property Constrain: Boolean read FConstrain write SetConstrain;
    property Draggable: Boolean read FDraggable write SetDraggable;
    property Maximizable: Boolean read FMaximizable write SetMaximizable;
    property Maximized: Boolean read FMaximized write SetMaximized;
    property Modal: Boolean read FModal write SetModal;
    property Plain: Boolean read FPlain write SetPlain;
    property Resizable: Boolean read FResizable write SetResizable;
    property ResizeHandles: string read FResizeHandles write SetResizeHandles;
  end;

  // Procedural types for events TExtTabPanel
  TExtTabPanelOnTabchange = procedure(This: TExtTabPanel; Tab: TExtPanel) of object;

  TExtTabPanel = class(TExtPanel)
  private
    FOnTabChange: TExtTabPanelOnTabchange;
    FLayoutOnTabChange: Boolean;
    FEnableTabScroll: Boolean;
    FActiveTab: string;
    FDeferredRender: Boolean;
    FActiveTabNumber: Integer;
    procedure _SetActiveTab(const AValue: string);
    procedure SetActiveTabNumber(const AValue: Integer);
    procedure SetDeferredRender(const AValue: Boolean);
    procedure SetEnableTabScroll(const AValue: Boolean);
    procedure SetLayoutOnTabChange(const AValue: Boolean);
    procedure SetOnTabChange(const AValue: TExtTabPanelOnTabchange);
  protected
    function GetObjectNamePrefix: string; override;
  public
    procedure HandleEvent(const AEvtName: string); override;
    class function JSClassName: string; override;
    function GetActiveTab: TExtExpression;
    function SetActiveTab(const AItem: string): TExtExpression; overload;
    function SetActiveTab(const AItem: Integer): TExtExpression; overload;
    property ActiveTab: string read FActiveTab write _SetActiveTab;
    property ActiveTabNumber: Integer read FActiveTabNumber write SetActiveTabNumber;
    property DeferredRender: Boolean read FDeferredRender write SetDeferredRender;
    property EnableTabScroll: Boolean read FEnableTabScroll write SetEnableTabScroll;
    property LayoutOnTabChange: Boolean read FLayoutOnTabChange
      write SetLayoutOnTabChange;
    property OnTabchange: TExtTabPanelOnTabchange read FOnTabChange write SetOnTabChange;
  end;

  TExtPagingToolbar = class(TExtToolbar)
  private
    FPageSize: Integer;
    FDisplayInfo: Boolean;
    FStore: TExtDataStore;
    procedure SetDisplayInfo(const AValue: Boolean);
    procedure SetPageSize(const AValue: Integer);
    procedure SetStore(const AValue: TExtDataStore);
  public
    class function JSClassName: string; override;
    function MoveFirst: TExtExpression;
    function MoveLast: TExtExpression;
    function MoveNext: TExtExpression;
    function MovePrevious: TExtExpression;
    property DisplayInfo: Boolean read FDisplayInfo write SetDisplayInfo;
    property PageSize: Integer read FPageSize write SetPageSize;
    property Store: TExtDataStore read FStore write SetStore;
  end;

  TExtToolTip = class(TExtTip)
  public
    class function JSClassName: string; override;
  end;

  TExtQuickTip = class(TExtToolTip)
  public
    class function JSClassName: string; override;
  end;

  TExtPluginAbstract = class(TExtObject)
  end;

  TExtMessageBoxSingleton = class(TExtObject)
  public
    class function JSClassName: string; override;
    function Alert(const ATitle: string; const AMsg: string;
      const AFn: TExtExpression = nil; const AScope: TExtObject = nil): TExtExpression;
  end;

function ExtQuickTips: TExtQuickTipsSingleton;
function ExtMessageBox: TExtMessageBoxSingleton;
function LabelAlignAsOption(const AValue: TExtContainerLabelAlign): string;

implementation

uses
  SysUtils
  , KItto.JS.Formatting
  , Kitto.Web.Response
  ;

function ExtQuickTips: TExtQuickTipsSingleton;
begin
  if Session <> nil then
    Result := Session.GetSingleton<TExtQuickTipsSingleton>(TExtQuickTipsSingleton.JSClassName)
  else
    Result := nil;
end;

function ExtMessageBox: TExtMessageBoxSingleton;
begin
  if Session <> nil then
    Result := Session.GetSingleton<TExtMessageBoxSingleton>(TExtMessageBoxSingleton.JSClassName)
  else
    Result := nil;
end;

function LabelAlignAsOption(const AValue: TExtContainerLabelAlign): string;
begin
  case AValue of
    laLeft : Result := 'left';
    laTop : Result := 'top';
    laRight : Result := 'right';
  end;
end;

class function TExtUtilObservable.JSClassName: string;
begin
  Result := 'Ext.util.Observable';
end;

function TExtUtilObservable.AddListener(const AEventName: string; const AHandler: TExtExpression;
  const AScope: TExtObject = nil; const AOptions: TExtObject = nil): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'addListener')
    .AddParam(AEventName)
    .AddParam(AHandler)
    .AddParam(AScope)
    .AddParam(AOptions)
    .AsExpression;
end;

function TExtUtilObservable.FireEvent(const AEventName: string; const AArgs: TJSObjectArray): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'fireEvent')
    .AddParam(AEventName)
    .AddParam(AArgs)
    .AsExpression;
end;

function TExtUtilObservable.&On(const AEventName: string; const AHandler: TExtExpression;
  const AScope: TExtObject; const AOptions: TExtObject): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'on')
    .AddParam(AEventName)
    .AddParam(AHandler)
    .AddParam(AScope)
    .AddParam(AOptions)
    .AsExpression;
end;

function TExtUtilObservable.RemoveAllListeners(const AEventName: string): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.ExecuteJSCode(Self, Format('if (%s.events.%s) delete (%s.events.%s)',
    [JSName, AEventName, JSName, AEventName])).AsExpression;
end;

procedure TExtProgressWaitConfig.SetDuration(const AValue: Integer);
begin
  FDuration := SetConfigItem('duration', AValue);
end;

procedure TExtProgressWaitConfig.SetInterval(const AValue: Integer);
begin
  FInterval := SetConfigItem('interval', AValue);
end;

procedure TExtProgressWaitConfig.SetIncrement(const AValue: Integer);
begin
  FIncrement := SetConfigItem('increment', AValue);
end;

class function TExtProgressWaitConfig.JSClassName: string;
begin
  Result := 'Object';
end;

class function TExtSplitBarBasicLayoutAdapter.JSClassName: string;
begin
  Result := 'Ext.SplitBar.BasicLayoutAdapter';
end;


class function TExtTemplate.JSClassName: string;
begin
  Result := 'Ext.Template';
end;

class function TExtQuickTipsSingleton.JSClassName: string;
begin
  Result := 'Ext.QuickTips';
end;

function TExtQuickTipsSingleton.Disable: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'disable').AsExpression;
end;

function TExtQuickTipsSingleton.Enable: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'enable').AsExpression;
end;

function TExtQuickTipsSingleton.Init(const AAutoRender: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'init').AddParam(AAutoRender).AsExpression;
end;

class function TExtElement.JSClassName: string;
begin
  Result := 'Ext.Element';
end;

function TExtElement.AddClass(const AClassName: string): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'addClass').AddParam(AClassName).AsExpression;
end;

procedure TExtAction._SetText(const AValue: string);
begin
  FText := SetConfigItem('text', 'setText', AValue);
end;

class function TExtAction.JSClassName: string;
begin
  Result := 'Ext.Action';
end;

procedure TExtAction.InitDefaults;
begin
  inherited;
  FScope := TExtObject.CreateInternal(Self, 'scope');
end;

function TExtAction.SetHandler(const AFn: TExtExpression; const AScope: TExtObject): TExtExpression;
begin
  FHandler := AFn;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setHandler')
    .AddParam(AFn)
    .AddParam(AScope)
    .AsExpression;
end;

function TExtAction.SetHidden(const AHidden: Boolean): TExtExpression;
begin
  FHidden := AHidden;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setHidden').AddParam(AHidden).AsExpression;
end;

function TExtAction.SetText(const AText: string): TExtExpression;
begin
  FText := AText;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setText').AddParam(AText).AsExpression;
end;

class function TExtDirectTransaction.JSClassName: string;
begin
  Result := 'Ext.Direct.Transaction';
end;

class function TExtSplitBar.JSClassName: string;
begin
  Result := 'Ext.SplitBar';
end;

procedure TExtComponent._SetDisabled(const AValue: Boolean);
begin
  FDisabled := SetConfigItem('disabled', 'setDisabled', AValue);
end;

procedure TExtComponent.SetFieldLabel(const AValue: string);
begin
  FFieldLabel := SetConfigItem('fieldLabel', AValue);
end;

procedure TExtComponent.SetHidden(const AValue: Boolean);
begin
  FHidden := SetConfigItem('hidden', 'setHidden', AValue);
end;

procedure TExtComponent.SetHtml(const AValue: string);
begin
  FHtml := SetConfigItem('html', 'update', AValue);
end;

procedure TExtComponent.SetId(const AValue: string);
begin
  FId := SetConfigItem('id', AValue);
end;

procedure TExtComponent.SetItemCls(const AValue: string);
begin
  FItemCls := SetConfigItem('itemCls', AValue);
end;

procedure TExtComponent.SetItemId(const AValue: string);
begin
  FItemId := SetConfigItem('itemId', AValue);
end;

procedure TExtComponent.SetLabelSeparator(const AValue: string);
begin
  FLabelSeparator := SetConfigItem('labelSeparator', AValue);
end;

procedure TExtComponent.SetLabelStyle(const AValue: string);
begin
  FLabelStyle := SetConfigItem('labelStyle', AValue);
end;

procedure TExtComponent.SetOverCls(const AValue: string);
begin
  FOverCls := SetConfigItem('overCls', AValue);
end;

procedure TExtComponent.SetPadding(const AValue: string);
begin
  FPadding := SetConfigItem('padding', AValue);
end;

procedure TExtComponent.SetStyle(const AValue: string);
begin
  FStyle := SetConfigItem('style', AValue);
end;

procedure TExtComponent.SetTpl(const AValue: string);
begin
  FTpl := SetConfigItem('tpl', AValue);
end;

procedure TExtComponent.SetSplit(const AValue: Boolean);
begin
  FSplit := AValue;
  SetConfigItem('split', AValue);
end;

procedure TExtComponent.SetCls(const AValue: string);
begin
  FCls := SetConfigItem('cls', AValue);
end;

procedure TExtComponent.SetCollapseMode(const AValue: string);
begin
  FCollapseMode := AValue;
  SetConfigItem('collapseMode', AValue);
end;

procedure TExtComponent.SetMinWidth(const AValue: Integer);
begin
  FMinWidth := AValue;
  SetConfigItem('minWidth', AValue);
end;

procedure TExtComponent.SetMaxWidth(const AValue: Integer);
begin
  FMaxWidth := AValue;
  SetConfigItem('maxWidth', AValue);
end;

procedure TExtComponent.SetMinSize(const AValue: Integer);
begin
  FMinSize := AValue;
  SetConfigItem('minSize', AValue);
end;

procedure TExtComponent.SetMaxSize(const AValue: Integer);
begin
  FMaxSize := AValue;
  SetConfigItem('maxSize', AValue);
end;

class function TExtComponent.JSClassName: string;
begin
  Result := 'Ext.Component';
end;

procedure TExtComponent.InitDefaults;
begin
  inherited;
  FLabelSeparator := ':';
  FPlugins := CreateConfigArray('plugins');
  FLoader := TExtObject.CreateInternal(Self, 'loader');
end;

function TExtComponent.AddCls(const AClsName: string): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'addCls').AddParam(AClsName).AsExpression;
end;

function TExtComponent.Focus(const ASelectText: Boolean; const ADelay: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'focus')
    .AddParam(ASelectText)
    .AddParam(ADelay)
    .AsExpression;
end;

function TExtComponent.Focus(const ASelectText: Boolean; const ADelay: Integer): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'focus')
    .AddParam(ASelectText)
    .AddParam(ADelay)
    .AsExpression;
end;

function TExtComponent.Hide: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'hide').AsExpression;
end;

function TExtComponent.SetDisabled(const AValue: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setDisabled')
    .AddParam(AValue)
    .AsExpression;
end;

function TExtComponent.SetVisible(const AValue: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setVisible')
    .AddParam(AValue)
    .AsExpression;
end;

function TExtComponent.Show: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'show').AsExpression;
end;

procedure TExtComponent.SetOnAfterrender(const AValue: TExtComponentOnAfterrender);
begin
  RemoveAllListeners('afterrender');
  if Assigned(AValue) then
    &On('afterrender', TKWebResponse.Current.Items.AjaxCallMethod(Self, 'afterrender')
      .Event
      .AddRawParam('This', 'sender.nm')
      .FunctionArgs('sender')
      .AsFunction);
  FOnAfterrender := AValue;
end;

procedure TExtComponent.HandleEvent(const AEvtName: string);
begin
  inherited;
  if (AEvtName = 'afterrender') and Assigned(FOnAfterrender) then
    FOnAfterrender(TExtComponent(ParamAsObject('This')));
end;

procedure TExtLayer._SetZindex(const AValue: Integer);
begin
  FZindex := SetConfigItem('zindex', 'setZindex', AValue);
end;

class function TExtLayer.JSClassName: string;
begin
  Result := 'Ext.Layer';
end;

procedure TExtLayer.InitDefaults;
begin
  inherited;
  FZindex := 11000;
end;

function TExtLayer.SetZIndex(const AZindex: Integer): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setZindex')
    .AddParam(AZindex)
    .AsExpression;
end;

class function TExtXTemplate.JSClassName: string;
begin
  Result := 'Ext.XTemplate';
end;

procedure TExtEditor._SetValue(const AValue: string);
begin
  FValue := AValue;
  SetConfigItem('value', 'setValue', AValue);
end;

class function TExtEditor.JSClassName: string;
begin
  Result := 'Ext.Editor';
end;

function TExtEditor.SetValue(const AValue: string): TExtExpression;
begin
  FValue := AValue;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setValue')
    .AddParam(AValue)
    .AsExpression;
end;

class function TExtColorPalette.JSClassName: string;
begin
  Result := 'Ext.ColorPalette';
end;

procedure TExtDatePicker._SetMaxDate(const AValue: TDateTime);
begin
  FMaxDate := AValue;
  SetConfigItem('maxDate', 'setMaxDate', AValue);
end;

procedure TExtDatePicker._SetMinDate(const AValue: TDateTime);
begin
  FMinDate := AValue;
  SetConfigItem('minDate', 'setMinDate', AValue);
end;

class function TExtDatePicker.JSClassName: string;
begin
  Result := 'Ext.DatePicker';
end;

function TExtDatePicker.SetMaxDate(const AValue: TDateTime): TExtExpression;
begin
  FMaxDate := AValue;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setMaxDate')
    .AddParam(AValue)
    .AsExpression;
end;

function TExtDatePicker.SetMinDate(const AValue: TDateTime): TExtExpression;
begin
  FMinDate := AValue;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setMinDate')
    .AddParam(AValue)
    .AsExpression;
end;

procedure TExtBoxComponent.SetAnchor(const AValue: string);
begin
  FAnchor := SetConfigItem('anchor', AValue);
end;

procedure TExtBoxComponent.SetAutoHeight(const AValue: Boolean);
begin
  FAutoHeight := SetConfigItem('autoHeight', AValue);
end;

procedure TExtBoxComponent._SetAutoScroll(const AValue: Boolean);
begin
  FAutoScroll := SetConfigItem('autoScroll', 'setAutoScroll', AValue);
end;

procedure TExtBoxComponent.SetAutoWidth(const AValue: Boolean);
begin
  FAutoWidth := SetConfigItem('autoWidth', AValue);
end;

procedure TExtBoxComponent.SetFlex(const AValue: Integer);
begin
  FFlex := SetConfigItem('flex', AValue);
end;

procedure TExtBoxComponent.SetHeight(const AValue: Integer);
begin
  FHeight := SetConfigItem('height', 'setHeight', AValue);
end;

procedure TExtBoxComponent.SetHeightFunc(const AValue: TExtExpression);
begin
  FHeightFunc := SetConfigItem('height', AValue);
end;

procedure TExtBoxComponent.SetHeightString(const AValue: string);
begin
  FHeightString := SetConfigItem('height', 'setHeight', AValue);
end;

procedure TExtBoxComponent.SetMargins(AValue: string);
begin
  FMargins := SetConfigItem('margins', AValue);
end;

procedure TExtBoxComponent.SetOwnerCt(const AValue: TExtContainer);
begin
  FOwnerCt := TExtContainer(SetConfigItem('ownerCt', AValue));
end;

procedure TExtBoxComponent.SetRegion(const AValue: TExtBoxComponentRegion);
begin
  FRegion := AValue;
  SetConfigItem('region', TJS.EnumToJSString(TypeInfo(TExtBoxComponentRegion), Ord(AValue)));
end;

procedure TExtBoxComponent.SetWidth(const AValue: Integer);
begin
  FWidth := SetConfigItem('width', 'setWidth', AValue);
end;

procedure TExtBoxComponent.SetWidthExpression(const AValue: TExtExpression);
begin
  FWidthExpression := SetConfigItem('width', AValue);
end;

procedure TExtBoxComponent.SetWidthString(const AValue: string);
begin
  FWidthString := SetConfigItem('width', 'setWidth', AValue);
end;

class function TExtBoxComponent.JSClassName: string;
begin
  Result := 'Ext.Component';
end;

procedure TExtBoxComponent.InitDefaults;
begin
  inherited;
end;

class function TExtToolbarItem.JSClassName: string;
begin
  Result := 'Ext.Toolbar.Item';
end;

class function TExtProgressBar.JSClassName: string;
begin
  Result := 'Ext.ProgressBar';
end;

class function TExtSpacer.JSClassName: string;
begin
  Result := 'Ext.Spacer';
end;

procedure TExtSpacer.InitDefaults;
begin
  inherited;
end;

procedure TExtContainer.SetActiveItem(const AValue: string);
begin
  FActiveItem := SetConfigItem('activeItem', AValue);
end;

procedure TExtContainer.SetActiveItemNumber(const AValue: Integer);
begin
  FActiveItemNumber := SetConfigItem('activeItemNumber', AValue);
end;

procedure TExtContainer.SetLabelAlign(const AValue: TExtContainerLabelAlign);
begin
  FLabelAlign := AValue;
  Defaults.SetConfigItem('labelAlign', LabelAlignAsOption(AValue));
end;

procedure TExtContainer.SetLabelWidth(const AValue: Integer);
begin
  FLabelWidth := AValue;
  Defaults.SetConfigItem('labelWidth', AValue);
end;

procedure TExtContainer.SetLayout(const AValue: TExtContainerLayout);
begin
  FLayout := AValue;
  SetConfigItem('layout', TJS.EnumToJSString(TypeInfo(TExtContainerLayout), Ord(AValue)));
end;

procedure TExtContainer.SetLayoutString(const AValue: string);
begin
  FLayoutString := SetConfigItem('layout', AValue);
end;

procedure TExtContainer.SetColumnWidth(const AValue: Double);
begin
  FColumnWidth := SetConfigItem('columnWidth', AValue);
end;

procedure TExtContainer.SetHideLabels(const AValue: Boolean);
begin
  FHideLabels := SetConfigItem('hideLabels', AValue);
end;

class function TExtContainer.JSClassName: string;
begin
  Result := 'Ext.Container';
end;

procedure TExtContainer.InitDefaults;
begin
  inherited;
  FAutoDestroy := True;
  FDefaults := TExtObject.CreateInternal(Self, 'defaults');
  FItems := CreateConfigArray('items');
  FLayoutObject := TExtObject.CreateInternal(Self, 'layout');
  FLayoutConfig := TExtObject.CreateInternal(Self, 'layoutConfig');
end;

function TExtContainer.UpdateLayout: TExtExpression;
begin
  Result := UpdateLayout(False, False);
end;

function TExtContainer.UpdateLayout(const AShallow: Boolean; const AForce: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'updateLayout')
    .AddParam(AShallow)
    .AddParam(AForce)
    .AsExpression;
end;

function TExtContainer.Remove(const AComponent: TExtComponent; const AAutoDestroy: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'remove')
    .AddParam(AComponent)
    .AddParam(AAutoDestroy)
    .AsExpression;
end;

procedure TExtButton.SetAllowDepress(const AValue: Boolean);
begin
  FAllowDepress := SetConfigItem('allowDepress', AValue);
end;

procedure TExtButton.SetDisabled(const AValue: Boolean);
begin
  FDisabled := SetConfigItem('disabled', AValue);
end;

procedure TExtButton.SetEnableToggle(const AValue: Boolean);
begin
  FEnableToggle := SetConfigItem('enableToggle', AValue);
end;

procedure TExtButton.SetFormBind(const AValue: Boolean);
begin
  FFormBind := SetConfigItem('formBind', AValue);
end;

procedure TExtButton._SetHandler(const AValue: TExtExpression);
begin
  FHandler := SetConfigItem('handler', 'setHandler', AValue);
end;

procedure TExtButton.SetHidden(const AValue: Boolean);
begin
  FHidden := SetConfigItemOrProperty('hidden', AValue);
end;

procedure TExtButton._SetIcon(const AValue: string);
begin
  FIcon := SetConfigItem('icon', 'setIcon', AValue);
end;

procedure TExtButton.SetIconCls(const AValue: string);
begin
  FIconCls := SetConfigItem('iconCls', AValue);
end;

procedure TExtButton.SetMenu(AValue: TExtUtilObservable);
begin
  FMenu.Free;
  FMenu := TExtUtilObservable(SetConfigItem('menu', AValue));
end;

procedure TExtButton.SetMinWidth(const AValue: Integer);
begin
  FMinWidth := SetConfigItem('minWidth', AValue);
end;

procedure TExtButton.SetPressed(const AValue: Boolean);
begin
  FPressed := SetConfigItemOrProperty('pressed', AValue);
end;

procedure TExtButton.SetScale(const AValue: string);
begin
  FScale := SetConfigItem('scale', AValue);
end;

procedure TExtButton._SetText(const AValue: string);
begin
  FText := SetConfigItem('text', 'setText', AValue);
end;

procedure TExtButton.SetToggleGroup(const AValue: string);
begin
  FToggleGroup := SetConfigItem('toggleGroup', AValue);
end;

procedure TExtButton._SetTooltip(const AValue: string);
begin
  FTooltip := SetConfigItem('tooltip', 'setTooltip', AValue);
end;

class function TExtButton.JSClassName: string;
begin
  Result := 'Ext.Button';
end;

procedure TExtButton.InitDefaults;
begin
  inherited;
  FHandleMouseEvents := true;
  FMenu := TExtUtilObservable.CreateInternal(Self, 'menu');
  FScope := TExtObject.CreateInternal(Self, 'scope');
  FTemplate := TExtTemplate.CreateInternal(Self, 'template');
  FTooltipObject := TExtObject.CreateInternal(Self, 'tooltip');
  FBtnEl := TExtElement.CreateInternal(Self, 'btnEl');
end;

function TExtButton.GetObjectNamePrefix: string;
begin
  Result := 'btn';
end;

function TExtButton.GetPressed(const AGroup: string): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'getPressed')
    .AddParam(AGroup)
    .AsExpression;
end;

function TExtButton.PerformClick: TExtExpression;
begin
  Result := FireEvent('click', nil);
end;

function TExtButton.Pressed_: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.GetProperty(Self, 'pressed').AsExpression;
end;

function TExtButton.GetTemplateArgs: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'getTemplateArgs')
    .AsExpression;
end;

function TExtButton.GetText: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'getText')
    .AsExpression;
end;

function TExtButton.HasVisibleMenu: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'hasVisibleMenu')
    .AsExpression;
end;

function TExtButton.HideMenu: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'hideMenu')
    .AsExpression;
end;

function TExtButton.SetHandler(const AHandler: TExtExpression; const AScope: TExtObject): TExtExpression;
begin
  FHandler := AHandler;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setHandler')
    .AddParam(AHandler)
    .AddParam(AScope)
    .AsExpression;
end;

function TExtButton.SetText(const AText: string): TExtExpression;
begin
  FText := AText;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setText')
    .AddParam(AText)
    .AsExpression;
end;

function TExtButton.SetTooltip(const ATooltip: string): TExtExpression;
begin
  FTooltip := ATooltip;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setTooltip')
    .AddParam(ATooltip)
    .AsExpression;
end;

function TExtButton.SetTooltip(const ATooltip: TExtObject): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setTooltip')
    .AddParam(ATooltip)
    .AsExpression;
end;

procedure TExtDataView.SetEmptyText(AValue: string);
begin
  FEmptyText := SetConfigItem('emptyText', AValue);
end;

procedure TExtDataView.SetItemSelector(const AValue: string);
begin
  FItemSelector := SetConfigItem('itemSelector', AValue);
end;

procedure TExtDataView.SetMultiSelect(const AValue: Boolean);
begin
  FMultiSelect := SetConfigItem('multiSelect', AValue);
end;

procedure TExtDataView.SetOverClass(const AValue: string);
begin
  FOverClass := SetConfigItem('overClass', AValue);
end;

procedure TExtDataView.SetSelectedClass(const AValue: string);
begin
  FSelectedClass := SetConfigItem('selectedClass', AValue);
end;

procedure TExtDataView.SetSimpleSelect(const AValue: Boolean);
begin
  FSimpleSelect := SetConfigItem('simpleSelect', AValue);
end;

procedure TExtDataView.SetSingleSelect(const AValue: Boolean);
begin
  FSingleSelect := SetConfigItem('singleSelect', AValue);
end;

procedure TExtDataView._SetStore(const AValue: TExtDataStore);
begin
  FStore.Free;
  FStore := TExtDataStore(SetConfigItem('store', 'setStore', AValue));
end;

procedure TExtDataView.SetTpl(AValue: string);
begin
  FTpl := SetConfigItem('tpl', AValue);
end;

class function TExtDataView.JSClassName: string;
begin
  Result := 'Ext.DataView';
end;

procedure TExtDataView.InitDefaults;
begin
  inherited;
  FSelectedClass := 'x-view-selected';
  FStore := TExtDataStore.CreateInternal(Self, 'store');
  FTplArray := CreateConfigArray('tpl');
end;

function TExtDataView.SetStore(const AStore: TExtDataStore): TExtExpression;
begin
  FStore := AStore;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setStore')
    .AddParam(AStore)
    .AsExpression;
end;

procedure TExtDataView.SetStoreArray(const AValue: TJSObjectArray);
begin
  FStoreArray.Free;
  FStoreArray := TJSObjectArray(SetConfigItem('store', AValue));
end;

class function TExtViewport.JSClassName: string;
begin
  Result := 'Ext.Viewport';
end;

function TExtViewport.GetObjectNamePrefix: string;
begin
  Result := 'vp';
end;

procedure TExtPanel.SetAnimCollapse(const AValue: Boolean);
begin
  FAnimCollapse := SetConfigItem('animCollapse', AValue);
end;

procedure TExtPanel.SetAutoLoad(const AValue: TExtObject);
begin
  FAutoLoad := SetConfigItem('autoLoad', AValue);
end;

procedure TExtPanel.SetAutoLoadString(const AValue: string);
begin
  FAutoLoadString := SetConfigItem('autoLoad', AValue);
end;

procedure TExtPanel.SetAutoLoadBoolean(const AValue: Boolean);
begin
  FAutoLoadBoolean := SetConfigItem('autoLoad', AValue);
end;

procedure TExtPanel.SetBbar(const AValue: TExtObject);
begin
  FBbar.Free;
  FBbar := SetConfigItem('bbar', AValue);
end;

procedure TExtPanel.SetBodyStyle(const AValue: string);
begin
  FBodyStyle := SetConfigItem('bodyStyle', AValue);
end;

procedure TExtPanel.SetBorder(const AValue: Boolean);
begin
  FBorder := AValue;
  SetConfigItem('border', AValue);
end;

procedure TExtPanel.SetClosable(const AValue: Boolean);
begin
  FClosable := SetConfigItem('closable', AValue);
end;

procedure TExtPanel.SetCollapsible(const AValue: Boolean);
begin
  FCollapsible := SetConfigItem('collapsible', AValue);
end;

procedure TExtPanel.SetFooter(const AValue: Boolean);
begin
  FFooter := SetConfigItem('footer', AValue);
end;

procedure TExtPanel.SetFrame(const AValue: Boolean);
begin
  FFrame := SetConfigItem('frame', AValue);
end;

procedure TExtPanel.SetHeader(const AValue: Boolean);
begin
  FHeader := AValue;
  SetConfigItem('header', AValue);
end;

procedure TExtPanel.SetIconCls(const AValue: string);
begin
  FIconCls := SetConfigItem('iconCls', AValue);
end;

procedure TExtPanel.SetMinButtonWidth(const AValue: Integer);
begin
  FMinButtonWidth := SetConfigItem('minButtonWidth', AValue);
end;

procedure TExtPanel.SetPaddingString(const AValue: string);
begin
  FPaddingString := SetConfigItem('padding', AValue);
end;

procedure TExtPanel._SetTitle(AValue: string);
begin
  FTitle := SetConfigItem('title', 'setTitle', AValue);
end;

procedure TExtPanel.SetCollapsed(const AValue: Boolean);
begin
  FCollapsed := SetConfigItemorProperty('collapsed', AValue);
end;

class function TExtPanel.JSClassName: string;
begin
  Result := 'Ext.Panel';
end;

procedure TExtPanel.InitDefaults;
begin
  inherited;
  FAnimCollapse := true;
  FAutoLoad := TExtObject.CreateInternal(Self, 'autoLoad');
  FBbar := CreateConfigArray('bbar');
  FBorder := true;
  FButtons := CreateConfigArray('buttons');
  FFbar := CreateConfigArray('fbar');
  FMinButtonWidth := 75;
  FHeader := true;
end;

function TExtPanel.Collapse(const AAnimate: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'collapse')
    .AddParam(AAnimate)
    .AsExpression;
end;

function TExtPanel.Expand(const AAnimate: Boolean): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'exand')
    .AddParam(AAnimate)
    .AsExpression;
end;

function TExtPanel.GetObjectNamePrefix: string;
begin
  Result := 'pnl';
end;

procedure TExtPanel.SetTbar(const AValue: TExtObject);
begin
  FTbar.Free;
  FTbar := SetConfigItem('tbar', AValue);
end;

function TExtPanel.SetTitle(const ATitle: string; const AIconCls: string): TExtExpression;
begin
  FTitle := ATitle;
  FIconCls := AIconCls;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setTitle')
    .AddParam(ATitle)
    .AddParam(AIconCls)
    .AsExpression;
end;

procedure TExtSplitButton._SetArrowHandler(const AValue: TExtExpression);
begin
  FArrowHandler := SetConfigItem('arrowHandler', 'setArrowHandler', AValue);
end;

class function TExtSplitButton.JSClassName: string;
begin
  Result := 'Ext.SplitButton';
end;

function TExtSplitButton.SetArrowHandler(const AHandler: TExtExpression; const AScope: TExtObject): TExtExpression;
begin
  FArrowHandler := AHandler;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setArrowHandler')
    .AddParam(AHandler)
    .AddParam(AScope)
    .AsExpression;
end;

class function TExtToolbarSpacer.JSClassName: string;
begin
  Result := 'Ext.Toolbar.Spacer';
end;

function TExtToolbarSpacer.GetObjectNamePrefix: string;
begin
  Result := 'spacer';
end;

procedure TExtToolbarTextItem._SetText(const AValue: string);
begin
  FText := SetConfigItem('text', 'setText', AValue);
end;

class function TExtToolbarTextItem.JSClassName: string;
begin
  Result := 'Ext.Toolbar.TextItem';
end;

procedure TExtToolbarTextItem.InitDefaults;
begin
  inherited;
end;

function TExtToolbarTextItem.SetText(const AText: string): TExtExpression;
begin
  FText := AText;
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setText').AddParam(AText).AsExpression;
end;

class function TExtToolbar.JSClassName: string;
begin
  Result := 'Ext.Toolbar';
end;

function TExtToolbar.GetObjectNamePrefix: string;
begin
  Result := 'tb';
end;

class function TExtToolbarSeparator.JSClassName: string;
begin
  Result := 'Ext.Toolbar.Separator';
end;

procedure TExtToolbarSeparator.InitDefaults;
begin
  inherited;
end;

class function TExtTip.JSClassName: string;
begin
  Result := 'Ext.Tip';
end;

class function TExtToolbarFill.JSClassName: string;
begin
  Result := 'Ext.Toolbar.Fill';
end;

procedure TExtToolbarFill.InitDefaults;
begin
  inherited;
end;

class function TExtButtonGroup.JSClassName: string;
begin
  Result := 'Ext.ButtonGroup';
end;

class function TExtCycleButton.JSClassName: string;
begin
  Result := 'Ext.CycleButton';
end;

procedure TExtWindow._SetAnimateTarget(const AValue: string);
begin
  FAnimateTarget := SetConfigItem('animateTarget', 'setAnimateTarget', AValue);
end;

procedure TExtWindow.SetClosable(const AValue: Boolean);
begin
  FClosable := SetConfigItem('closable', AValue);
end;

procedure TExtWindow.SetConstrain(const AValue: Boolean);
begin
  FConstrain := SetConfigItem('constrain', AValue);
end;

procedure TExtWindow.SetDraggable(const AValue: Boolean);
begin
  FDraggable := SetConfigItem('draggable', AValue);
end;

procedure TExtWindow.SetMaximizable(const AValue: Boolean);
begin
  FMaximizable := SetConfigItem('maximizable', AValue);
end;

procedure TExtWindow.SetMaximized(const AValue: Boolean);
begin
  FMaximized := SetConfigItem('maximized', AValue);
end;

procedure TExtWindow.SetModal(const AValue: Boolean);
begin
  FModal := SetConfigItem('modal', AValue);
end;

procedure TExtWindow.SetPlain(const AValue: Boolean);
begin
  FPlain := SetConfigItem('plain', AValue);
end;

procedure TExtWindow.SetResizable(const AValue: Boolean);
begin
  FResizable := SetConfigItem('resizable', AValue);
end;

procedure TExtWindow.SetResizeHandles(const AValue: string);
begin
  FResizeHandles := SetConfigItem('resizeHandles', AValue);
end;

class function TExtWindow.JSClassName: string;
begin
  Result := 'Ext.Window';
end;

procedure TExtWindow.InitDefaults;
begin
  inherited;
  FAnimateTargetElement := TExtElement.CreateInternal(Self, 'animateTarget');
  FBaseCls := 'x-window';
  FButtons := CreateConfigArray('buttons');
  FClosable := true;
  FDraggable := true;
  FExpandOnShow := true;
  FInitHidden := true;
  FMinHeight := 100;
  FMinWidth := 200;
  FResizable := true;
  FResizeHandles := 'all';
  FBbar := CreateConfigArray('bbar');
end;

function TExtWindow.Close: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'close').AsExpression;
end;

procedure TExtWindow.SetAnimateTarget(const AElement: string);
begin
  FAnimateTarget := SetConfigItem('animateTarget', 'setAnimateTarget', AElement);
end;

function TExtWindow.Show(const AAnimateTarget: string; const ACallback: TExtExpression;
  const AScope: TExtObject): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'show')
    .AddParam(AAnimateTarget)
    .AddParam(ACallback)
    .AddParam(AScope)
    .AsExpression;
end;

function TExtWindow.Show(const AAnimateTarget: TExtElement; const ACallback: TExtExpression;
  const AScope: TExtObject): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'show')
    .AddParam(AAnimateTarget)
    .AddParam(ACallback)
    .AddParam(AScope)
    .AsExpression;
end;

function TExtWindow.GetObjectNamePrefix: string;
begin
  Result := 'win';
end;

procedure TExtTabPanel._SetActiveTab(const AValue: string);
begin
  FActiveTab := SetConfigItem('activeTab', 'setActiveTab', AValue);
end;

procedure TExtTabPanel.SetActiveTabNumber(const AValue: Integer);
begin
  FActiveTabNumber := SetConfigItem('activeTab', AValue);
end;

procedure TExtTabPanel.SetDeferredRender(const AValue: Boolean);
begin
  FDeferredRender := SetConfigItem('deferredRender', AValue);
end;

procedure TExtTabPanel.SetEnableTabScroll(const AValue: Boolean);
begin
  FEnableTabScroll := SetConfigItem('enableTabScroll', AValue);
end;

procedure TExtTabPanel.SetLayoutOnTabChange(const AValue: Boolean);
begin
  FLayoutOnTabChange := SetConfigItem('layoutOnTabChange', AValue);
end;

procedure TExtTabPanel.SetOnTabChange(const AValue: TExtTabPanelOnTabchange);
begin
  RemoveAllListeners('tabchange');
  if Assigned(AValue) then
    //On('tabchange', Ajax('tabchange', ['This', '%0.nm', 'Tab', '(%1 ? %1.nm : null)'], True));
    &On('tabchange', TKWebResponse.Current.Items.AjaxCallMethod(Self, 'tabchange')
      .Event
      .AddRawParam('This', 'sender.nm')
      .AddRawParam('Tab', '(tab ? tab.nm : null)')
      .FunctionArgs('sender, tab')
      .AsFunction);
  FOnTabChange := AValue;
end;

class function TExtTabPanel.JSClassName: string;
begin
  Result := 'Ext.TabPanel';
end;

function TExtTabPanel.GetActiveTab: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'getActiveTab').AsExpression;
end;

function TExtTabPanel.GetObjectNamePrefix: string;
begin
  Result := 'tabpnl';
end;

function TExtTabPanel.SetActiveTab(const AItem: string): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setActiveTab')
    .AddParam(AItem)
    .AsExpression;
end;

function TExtTabPanel.SetActiveTab(const AItem: Integer): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'setActiveTab')
    .AddParam(AItem)
    .AsExpression;
end;

procedure TExtTabPanel.HandleEvent(const AEvtName: string);
begin
  inherited;
  if (AEvtName = 'tabchange') and Assigned(FOnTabChange) then
    FOnTabChange(TExtTabPanel(ParamAsObject('This')), TExtPanel(ParamAsObject('Tab')));
end;

procedure TExtPagingToolbar.SetDisplayInfo(const AValue: Boolean);
begin
  FDisplayInfo := SetConfigItem('displayInfo', AValue);
end;

procedure TExtPagingToolbar.SetPageSize(const AValue: Integer);
begin
  FPageSize := SetConfigItem('pageSize', AValue);
end;

procedure TExtPagingToolbar.SetStore(const AValue: TExtDataStore);
begin
  FStore.Free;
  FStore := TExtDataStore(SetConfigItem('store', AValue));
end;

class function TExtPagingToolbar.JSClassName: string;
begin
  Result := 'Ext.PagingToolbar';
end;

function TExtPagingToolbar.MoveFirst: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'moveFirst').AsExpression;
end;

function TExtPagingToolbar.MoveLast: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'moveLast').AsExpression;
end;

function TExtPagingToolbar.MoveNext: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'moveNext').AsExpression;
end;

function TExtPagingToolbar.MovePrevious: TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'movePrevious').AsExpression;
end;

class function TExtToolTip.JSClassName: string;
begin
  Result := 'Ext.ToolTip';
end;

class function TExtQuickTip.JSClassName: string;
begin
  Result := 'Ext.QuickTip';
end;

class function TExtMessageBoxSingleton.JSClassName: string;
begin
  Result := 'Ext.MessageBox';
end;

function TExtMessageBoxSingleton.Alert(const ATitle: string; const AMsg: string;
  const AFn: TExtExpression = nil; const AScope: TExtObject = nil): TExtExpression;
begin
  Result := TKWebResponse.Current.Items.CallMethod(Self, 'alert').AddParam(ATitle).AddParam(AMsg)
    .AddParam(AFn).AddParam(AScope).AsExpression;
end;

end.

