unit ExtSlider;

// Generated by ExtToPascal v.0.9.8, at 3/5/2010 11:59:34
// from "C:\Trabalho\ext\docs\output" detected as ExtJS v.3

interface

uses
  StrUtils, ExtPascal, ExtPascalUtils, Ext;

type
  TExtSliderThumb = class;
  TExtSliderMultiSlider = class;
  TExtSliderSingleSlider = class;
  TExtSliderTip = class;

  TExtSliderThumb = class(TExtFunction)
  private
    FConstrain : Boolean;
    FSlider : TExtSliderMultiSlider;
    FSlider_ : TExtSliderMultiSlider;
    procedure SetFConstrain(Value : Boolean);
    procedure SetFSlider(Value : TExtSliderMultiSlider);
    procedure SetFSlider_(Value : TExtSliderMultiSlider);
  protected
    procedure InitDefaults; override;
  public
    function JSClassName : string; override;
    function Disable : TExtFunction;
    function Enable : TExtFunction;
    function InitEvents : TExtFunction;
    function Render : TExtFunction;
    property Constrain : Boolean read FConstrain write SetFConstrain;
    property Slider : TExtSliderMultiSlider read FSlider write SetFSlider;
    property Slider_ : TExtSliderMultiSlider read FSlider_ write SetFSlider_;
  end;

  // Procedural types for events TExtSliderMultiSlider
  TExtSliderMultiSliderOnBeforechange = procedure(Slider : TExtSlider; NewValue : Integer; OldValue : Integer) of object;
  TExtSliderMultiSliderOnChange = procedure(Slider : TExtSlider; NewValue : Integer; Thumb : TExtSliderThumb) of object;
  TExtSliderMultiSliderOnChangecomplete = procedure(Slider : TExtSlider; NewValue : Integer; Thumb : TExtSliderThumb) of object;
  TExtSliderMultiSliderOnDrag = procedure(Slider : TExtSlider; E : TExtEventObjectSingleton) of object;
  TExtSliderMultiSliderOnDragend = procedure(Slider : TExtSlider; E : TExtEventObjectSingleton) of object;
  TExtSliderMultiSliderOnDragstart = procedure(Slider : TExtSlider; E : TExtEventObjectSingleton) of object;

  TExtSliderMultiSlider = class(TExtBoxComponent)
  private
    FAnimate : Boolean;
    FClickToChange : Boolean;
    FConstrainThumbs : Boolean;
    FDecimalPrecision : Integer;
    FDecimalPrecisionBoolean : Boolean;
    FIncrement : Integer;
    FKeyIncrement : Integer;
    FMaxValue : Integer;
    FMinValue : Integer;
    FValue : Integer;
    FVertical : Boolean;
    FDragging : Boolean;
    FThumbs : TExtObjectList;
    FValues : TExtObjectList;
    FOnBeforechange : TExtSliderMultiSliderOnBeforechange;
    FOnChange : TExtSliderMultiSliderOnChange;
    FOnChangecomplete : TExtSliderMultiSliderOnChangecomplete;
    FOnDrag : TExtSliderMultiSliderOnDrag;
    FOnDragend : TExtSliderMultiSliderOnDragend;
    FOnDragstart : TExtSliderMultiSliderOnDragstart;
    procedure SetFAnimate(Value : Boolean);
    procedure SetFClickToChange(Value : Boolean);
    procedure SetFConstrainThumbs(Value : Boolean);
    procedure SetFDecimalPrecision(Value : Integer);
    procedure SetFDecimalPrecisionBoolean(Value : Boolean);
    procedure SetFIncrement(Value : Integer);
    procedure SetFKeyIncrement(Value : Integer);
    procedure SetFMaxValue(Value : Integer);
    procedure SetFMinValue(Value : Integer);
    procedure SetFValue(Value : Integer);
    procedure SetFVertical(Value : Boolean);
    procedure SetFDragging(Value : Boolean);
    procedure SetFThumbs(Value : TExtObjectList);
    procedure SetFValues(Value : TExtObjectList);
    procedure SetFOnBeforechange(Value : TExtSliderMultiSliderOnBeforechange);
    procedure SetFOnChange(Value : TExtSliderMultiSliderOnChange);
    procedure SetFOnChangecomplete(Value : TExtSliderMultiSliderOnChangecomplete);
    procedure SetFOnDrag(Value : TExtSliderMultiSliderOnDrag);
    procedure SetFOnDragend(Value : TExtSliderMultiSliderOnDragend);
    procedure SetFOnDragstart(Value : TExtSliderMultiSliderOnDragstart);
  protected
    procedure InitDefaults; override;
    procedure HandleEvent(const AEvtName: string); override;
  public
    function JSClassName : string; override;
    function AddThumb(Value : Integer) : TExtFunction;
    function GetValue(Index : Integer) : TExtFunction;
    function GetValues : TExtFunction;
    function SetMaxValue(Val : Integer) : TExtFunction;
    function SetMinValue(Val : Integer) : TExtFunction;
    function SetValue(Index : Integer; Value : Integer; Animate : Boolean) : TExtFunction;
    function SyncThumb : TExtFunction;
    property Animate : Boolean read FAnimate write SetFAnimate;
    property ClickToChange : Boolean read FClickToChange write SetFClickToChange;
    property ConstrainThumbs : Boolean read FConstrainThumbs write SetFConstrainThumbs;
    property DecimalPrecision : Integer read FDecimalPrecision write SetFDecimalPrecision;
    property DecimalPrecisionBoolean : Boolean read FDecimalPrecisionBoolean write SetFDecimalPrecisionBoolean;
    property Increment : Integer read FIncrement write SetFIncrement;
    property KeyIncrement : Integer read FKeyIncrement write SetFKeyIncrement;
    property MaxValue : Integer read FMaxValue write SetFMaxValue;
    property MinValue : Integer read FMinValue write SetFMinValue;
    property Value : Integer read FValue write SetFValue;
    property Vertical : Boolean read FVertical write SetFVertical;
    property Dragging : Boolean read FDragging write SetFDragging;
    property Thumbs : TExtObjectList read FThumbs write SetFThumbs;
    property Values : TExtObjectList read FValues write SetFValues;
    property OnBeforechange : TExtSliderMultiSliderOnBeforechange read FOnBeforechange write SetFOnBeforechange;
    property OnChange : TExtSliderMultiSliderOnChange read FOnChange write SetFOnChange;
    property OnChangecomplete : TExtSliderMultiSliderOnChangecomplete read FOnChangecomplete write SetFOnChangecomplete;
    property OnDrag : TExtSliderMultiSliderOnDrag read FOnDrag write SetFOnDrag;
    property OnDragend : TExtSliderMultiSliderOnDragend read FOnDragend write SetFOnDragend;
    property OnDragstart : TExtSliderMultiSliderOnDragstart read FOnDragstart write SetFOnDragstart;
  end;

  TExtSliderSingleSlider = class(TExtSliderMultiSlider)
  protected
    procedure InitDefaults; override;
  public
    function JSClassName : string; override;
    function GetValue : TExtFunction;
    function SetValue(Value : Integer; Animate : Boolean) : TExtFunction;
    function SyncThumb : TExtFunction;
  end;

  TExtSliderTip = class(TExtTip)
  protected
    procedure InitDefaults; override;
  public
    function JSClassName : string; override;
    function GetText(Thumb : TExtSliderThumb) : TExtFunction;
  end;

implementation

procedure TExtSliderThumb.SetFConstrain(Value : Boolean); begin
  FConstrain := Value;
  JSCode('constrain:' + VarToJSON([Value]));
end;

procedure TExtSliderThumb.SetFSlider(Value : TExtSliderMultiSlider); begin
  FSlider := Value;
    JSCode('slider:' + VarToJSON([Value, false]));
end;

procedure TExtSliderThumb.SetFSlider_(Value : TExtSliderMultiSlider); begin
  FSlider_ := Value;
    JSCode(JSName + '.slider=' + VarToJSON([Value, false]) + ';');
end;

function TExtSliderThumb.JSClassName : string; begin
  Result := 'Ext.slider.Thumb';
end;

procedure TExtSliderThumb.InitDefaults; begin
  inherited;
  FSlider := TExtSliderMultiSlider.CreateInternal(Self, 'slider');
  FSlider_ := TExtSliderMultiSlider.CreateInternal(Self, 'slider');
end;

function TExtSliderThumb.Disable : TExtFunction; begin
  JSCode(JSName + '.disable();', 'TExtSliderThumb');
  Result := Self;
end;

function TExtSliderThumb.Enable : TExtFunction; begin
  JSCode(JSName + '.enable();', 'TExtSliderThumb');
  Result := Self;
end;

function TExtSliderThumb.InitEvents : TExtFunction; begin
  JSCode(JSName + '.initEvents();', 'TExtSliderThumb');
  Result := Self;
end;

function TExtSliderThumb.Render : TExtFunction; begin
  JSCode(JSName + '.render();', 'TExtSliderThumb');
  Result := Self;
end;

procedure TExtSliderMultiSlider.SetFAnimate(Value : Boolean); begin
  FAnimate := Value;
  JSCode('animate:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFClickToChange(Value : Boolean); begin
  FClickToChange := Value;
  JSCode('clickToChange:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFConstrainThumbs(Value : Boolean); begin
  FConstrainThumbs := Value;
  JSCode('constrainThumbs:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFDecimalPrecision(Value : Integer); begin
  FDecimalPrecision := Value;
  JSCode('decimalPrecision:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFDecimalPrecisionBoolean(Value : Boolean); begin
  FDecimalPrecisionBoolean := Value;
  JSCode('decimalPrecision:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFIncrement(Value : Integer); begin
  FIncrement := Value;
  JSCode('increment:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFKeyIncrement(Value : Integer); begin
  FKeyIncrement := Value;
  JSCode('keyIncrement:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFMaxValue(Value : Integer); begin
  FMaxValue := Value;
  if not ConfigAvailable(JSName) then
    SetMaxValue(Value)
  else
    JSCode('maxValue:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFMinValue(Value : Integer); begin
  FMinValue := Value;
  if not ConfigAvailable(JSName) then
    SetMinValue(Value)
  else
    JSCode('minValue:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFValue(Value : Integer); begin
  FValue := Value;
  if not ConfigAvailable(JSName) then
    SetValue(Value, 0, false)
  else
    JSCode('value:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFVertical(Value : Boolean); begin
  FVertical := Value;
  JSCode('vertical:' + VarToJSON([Value]));
end;

procedure TExtSliderMultiSlider.SetFDragging(Value : Boolean); begin
  FDragging := Value;
  JSCode(JSName + '.dragging=' + VarToJSON([Value]) + ';');
end;

procedure TExtSliderMultiSlider.SetFThumbs(Value : TExtObjectList); begin
  FThumbs := Value;
    JSCode(JSName + '.thumbs=' + VarToJSON([Value, false]) + ';');
end;

procedure TExtSliderMultiSlider.SetFValues(Value : TExtObjectList); begin
  FValues := Value;
    JSCode(JSName + '.values=' + VarToJSON([Value, false]) + ';');
end;

procedure TExtSliderMultiSlider.SetFOnBeforechange(Value : TExtSliderMultiSliderOnBeforechange); begin
  if Assigned(FOnBeforechange) then
    JSCode(JSName+'.events ["beforechange"].listeners=[];');
  if Assigned(Value) then
    On('beforechange', Ajax('beforechange', ['Slider', '%0.nm','NewValue', '%1','OldValue', '%2'], true));
  FOnBeforechange := Value;
end;

procedure TExtSliderMultiSlider.SetFOnChange(Value : TExtSliderMultiSliderOnChange); begin
  if Assigned(FOnChange) then
    JSCode(JSName+'.events ["change"].listeners=[];');
  if Assigned(Value) then
    On('change', Ajax('change', ['Slider', '%0.nm','NewValue', '%1','Thumb', '%2.nm'], true));
  FOnChange := Value;
end;

procedure TExtSliderMultiSlider.SetFOnChangecomplete(Value : TExtSliderMultiSliderOnChangecomplete); begin
  if Assigned(FOnChangecomplete) then
    JSCode(JSName+'.events ["changecomplete"].listeners=[];');
  if Assigned(Value) then
    On('changecomplete', Ajax('changecomplete', ['Slider', '%0.nm','NewValue', '%1','Thumb', '%2.nm'], true));
  FOnChangecomplete := Value;
end;

procedure TExtSliderMultiSlider.SetFOnDrag(Value : TExtSliderMultiSliderOnDrag); begin
  if Assigned(FOnDrag) then
    JSCode(JSName+'.events ["drag"].listeners=[];');
  if Assigned(Value) then
    On('drag', Ajax('drag', ['Slider', '%0.nm','E', '%1.nm'], true));
  FOnDrag := Value;
end;

procedure TExtSliderMultiSlider.SetFOnDragend(Value : TExtSliderMultiSliderOnDragend); begin
  if Assigned(FOnDragend) then
    JSCode(JSName+'.events ["dragend"].listeners=[];');
  if Assigned(Value) then
    On('dragend', Ajax('dragend', ['Slider', '%0.nm','E', '%1.nm'], true));
  FOnDragend := Value;
end;

procedure TExtSliderMultiSlider.SetFOnDragstart(Value : TExtSliderMultiSliderOnDragstart); begin
  if Assigned(FOnDragstart) then
    JSCode(JSName+'.events ["dragstart"].listeners=[];');
  if Assigned(Value) then
    On('dragstart', Ajax('dragstart', ['Slider', '%0.nm','E', '%1.nm'], true));
  FOnDragstart := Value;
end;

function TExtSliderMultiSlider.JSClassName : string; begin
  Result := 'Ext.slider.MultiSlider';
end;

procedure TExtSliderMultiSlider.InitDefaults; begin
  inherited;
  FThumbs := TExtObjectList.CreateAsAttribute(Self, 'thumbs');
  FValues := TExtObjectList.CreateAsAttribute(Self, 'values');
end;

function TExtSliderMultiSlider.AddThumb(Value : Integer) : TExtFunction; begin
  JSCode(JSName + '.addThumb(' + VarToJSON([Value]) + ');', 'TExtSliderMultiSlider');
  Result := Self;
end;

function TExtSliderMultiSlider.GetValue(Index : Integer) : TExtFunction; begin
  JSCode(JSName + '.getValue(' + VarToJSON([Index]) + ');', 'TExtSliderMultiSlider');
  Result := Self;
end;

function TExtSliderMultiSlider.GetValues : TExtFunction; begin
  JSCode(JSName + '.getValues();', 'TExtSliderMultiSlider');
  Result := Self;
end;

function TExtSliderMultiSlider.SetMaxValue(Val : Integer) : TExtFunction; begin
  JSCode(JSName + '.setMaxValue(' + VarToJSON([Val]) + ');', 'TExtSliderMultiSlider');
  Result := Self;
end;

function TExtSliderMultiSlider.SetMinValue(Val : Integer) : TExtFunction; begin
  JSCode(JSName + '.setMinValue(' + VarToJSON([Val]) + ');', 'TExtSliderMultiSlider');
  Result := Self;
end;

function TExtSliderMultiSlider.SetValue(Index : Integer; Value : Integer; Animate : Boolean) : TExtFunction; begin
  JSCode(JSName + '.setValue(' + VarToJSON([Index, Value, Animate]) + ');', 'TExtSliderMultiSlider');
  Result := Self;
end;

function TExtSliderMultiSlider.SyncThumb : TExtFunction; begin
  JSCode(JSName + '.syncThumb();', 'TExtSliderMultiSlider');
  Result := Self;
end;

procedure TExtSliderMultiSlider.HandleEvent(const AEvtName : string); begin
  inherited;
  if (AEvtName = 'beforechange') and Assigned(FOnBeforechange) then
    FOnBeforechange(TExtSlider(ParamAsObject('Slider')), ParamAsInteger('NewValue'), ParamAsInteger('OldValue'))
  else if (AEvtName = 'change') and Assigned(FOnChange) then
    FOnChange(TExtSlider(ParamAsObject('Slider')), ParamAsInteger('NewValue'), TExtSliderThumb(ParamAsObject('Thumb')))
  else if (AEvtName = 'changecomplete') and Assigned(FOnChangecomplete) then
    FOnChangecomplete(TExtSlider(ParamAsObject('Slider')), ParamAsInteger('NewValue'), TExtSliderThumb(ParamAsObject('Thumb')))
  else if (AEvtName = 'drag') and Assigned(FOnDrag) then
    FOnDrag(TExtSlider(ParamAsObject('Slider')), ExtEventObject)
  else if (AEvtName = 'dragend') and Assigned(FOnDragend) then
    FOnDragend(TExtSlider(ParamAsObject('Slider')), ExtEventObject)
  else if (AEvtName = 'dragstart') and Assigned(FOnDragstart) then
    FOnDragstart(TExtSlider(ParamAsObject('Slider')), ExtEventObject);
end;

function TExtSliderSingleSlider.JSClassName : string; begin
  Result := 'Ext.slider.SingleSlider';
end;

procedure TExtSliderSingleSlider.InitDefaults; begin
  inherited;
end;

function TExtSliderSingleSlider.GetValue : TExtFunction; begin
  JSCode(JSName + '.getValue();', 'TExtSliderSingleSlider');
  Result := Self;
end;

function TExtSliderSingleSlider.SetValue(Value : Integer; Animate : Boolean) : TExtFunction; begin
  JSCode(JSName + '.setValue(' + VarToJSON([Value, Animate]) + ');', 'TExtSliderSingleSlider');
  Result := Self;
end;

function TExtSliderSingleSlider.SyncThumb : TExtFunction; begin
  JSCode(JSName + '.syncThumb();', 'TExtSliderSingleSlider');
  Result := Self;
end;

function TExtSliderTip.JSClassName : string; begin
  Result := 'Ext.slider.Tip';
end;

procedure TExtSliderTip.InitDefaults; begin
  inherited;
end;

function TExtSliderTip.GetText(Thumb : TExtSliderThumb) : TExtFunction; begin
  JSCode(JSName + '.getText(' + VarToJSON([Thumb, false]) + ');', 'TExtSliderTip');
  Result := Self;
end;

end.