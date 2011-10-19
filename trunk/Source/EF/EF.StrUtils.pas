unit EF.StrUtils;

interface

uses
  Types, Classes, DB,
  EF.Types;

{
  Returns the index of the last occurrence of ASubString in AString.
  Returns 0 if ASubString is not contained in AString.
}
function RightPos(const ASubString, AString: string): Integer;

{
  Strips APrefix from the beginning of AString and ASuffix from the end of it,
  if found. Returns the stripped string. If a prefix or suffix isn't found, then
  that part of the input string is returned unchanged. The match is case
  insensitive. Passing '' in APrefix or ASuffix suppresses stripping of that
  part.
}
function StripPrefixAndSuffix(const AString, APrefix, ASuffix: string): string;

{
  Strips APrefix from the beginning of AString, if found.
  Returns the stripped string. If a prefix isn't found, then the input string
  is returned unchanged. The match is case insensitive.
}
function StripPrefix(const AString, APrefix: string): string;

{
  Strips ASuffix from the end of AString, if found.
  Returns the stripped string. If a suffix isn't found, then the input string
  is returned unchanged. The match is case insensitive.
}
function StripSuffix(const AString, ASuffix: string): string;

{
  Generates a random string of ALength characters in the 'A'..'Z' and '0'..'9'
  printable sets.
}
function GetRandomString(const ALength: Integer): string;

{
  Returns True if APattern matches AString. APattern may contain
  the following jolly characters:
  ? matches any one character.
  * matches any sequence of zero or more characters.
  Everything else is compared literally in a case sensitive manner.
}
function StrMatches(const AString, APattern: string): Boolean;

{
  Interprets a ~ character at the beginning of a pattern as
  a negation symbol. Otherwise it's identical to StrMatches.
}
function StrMatchesEx(const AString, APattern: string): Boolean;

{
  Returns the number of occurences of ASubstring in AString.
}
function CountSubstrings(const AString, ASubstring: string): Integer;

{
  Returns True if AString equals at least one of AStrings, False otherwise.
  Wraps IndexStr, not present in all supported Delphi versions.
}
function MatchStr(const AString: string; const AStrings: array of string): Boolean;

{
  Creates a new GUID and returns it as a string in a compact format (32 chars).
}
function CreateCompactGuidStr: string;

{
  Creates a new GUID and returns it as a string.
}
function CreateGuidStr: string;

{
  Strips and returns (in ASubstring) the initial part of AString until
  ASeparator, or until the end of the string if ASeparator is not found.
  If ARemoveSeparator is True, then the separator is stripped from AString
  as well (but not included in the returned string anyway).
  The function returns True ultil it has reached the end of AString. When the
  function returns False, AString is always '', while ASubstring may or
  may not be ''.
}
function FetchStr(var AString, ASubstring: string; const ASeparator: string = ';';
  const ARemoveSeparator: Boolean = True): Boolean;

{
  Works like Pos, except that it returns 0 if ASubString is not part of AString
  as a whole word.

  Note: this function is case insensitive.
}
function WordPos(const AWord, AString: string): Integer; overload;

{
  Calls the other version of WordPos for each items in AWords.
  Returns a value <> 0 the first time that WordPos returns a value <> 0,
  otherwise returns 0.

  Note: this function is case insensitive.
}
function WordPos(const AWords: array of string;
  const AString: string): Integer; overload;

{
  If AString is shorter than AFinalLength characters, adds instances of
  PadCharacter to the right of the string until it is long exactly
  AFinalLength characters.
  If AString is long exactly AFinalLength characters, it is returned unchanged.
  If AString is longer than AFinalLength characters, an exception is raised. 
}
function PadRight(const AString: string;
  const AFinalLength: Integer; const APadCharacter: Char = ' '): string;

{
  If AString is shorter than AFinalLength characters, adds instances of
  PadCharacter to the left of the string until it is long exactly
  AFinalLength characters.
  If AString is long exactly AFinalLength characters, it is returned unchanged.
  If AString is longer than AFinalLength characters, an exception is raised. 
}
function PadLeft(const AString: string;
  const AFinalLength: Integer; const APadCharacter: Char = '0'): string;

{
  Reads a text file, line by line, and returns the content.
}
function TextFileToString(const AFileName: string): string;

{
  Writes AString to a text file.
}
procedure StringToTextFile(const AString, AFileName: string);

{
  Appends AString to an existing text file. If the file doesn't exist,
  works like StringToTextFile.
}
procedure AppendStringToTextFile(const AString, AFileName: string);

{
  Converts 'THIS_IS_A_STRING' to 'ThisIsAString'.
}
function UpperUnderscoreToCamel(const AString: string): string;

{
  Converts 'ThisIsAString' to 'THIS_IS_A_STRING'.
}
function CamelToUpperUnderscore(const AString: string): string;

{
  Converts 'ThisIsAString' to 'This Is A String'.
}
function CamelToSpaced(const AString: string): string;

{
  Tries to make the plural form of a specified singular name acoording
  to the rules of the english language.
}
function MakePlural(const ASingularName: string): string;

{
  Returns the index of AValue in AStrings, which contains name=value pairs.
}
function GetIndexOfValue(const AStrings: TStrings; const AValue: string): Integer;

{
  Inserts ASubstring into AString at the specified position and returns the
  resulting string.
}
function InsertStr(const ASubstring, AString: string; const AIndex: Integer): string;

{
  Returns the count of uninterrupted leading AChars in AString.
  Returns 0 if AString does not begin with AChar.
}
function CountLeading(const AString: string; const AChar: Char): Integer;

{
  Converts all tab characters (#9) in AString with sequences of ASpacesPerTab
  spaces, and returns the resulting string.
}
function TabsToSpaces(const AString: string; const ASpacesPerTab: Integer = 2): string;

type
  {
    Splits a list of values separated by some customizable separator and
    supplied as a string into a list of "tokens".
  }
  TEFStringTokenizer = class
  private
    FTokens: TStrings;
    function GetToken(const AIndex: Integer): string;
    function GetTokenCount: Integer;
    procedure ExtractTokens(const ATokens: string; const ATokenSeparator: Char);
  public
    constructor Create(const ATokens: string; const ATokenSeparator: Char);
    destructor Destroy; override;
    property Tokens[const AIndex: Integer]: string read GetToken; default;
    property TokenCount: Integer read GetTokenCount;
    function IndexOfToken(const AToken: string): Integer;
    {
      Adds all tokens to AStrings. Returns the count of added strings.
    }
    function AddTokensToStrings(const AStrings: TStrings): Integer;
  end;

  {
    A string list with a stack-like interface. It is not a strict stack, as it
    retains the TStrings interface as well. The stack-like interface is added
    for convenience only.
  }
  TEFStringStack = class(TStringList)
  public
    function Pop: string;
    procedure Push(const AString: string);
    function Peek: string;
  end;

{
  Returns True if AString equals one of the strings in the specified
  comma-separated list, and False otherwise.
}
function StringInCommaList(const AString, ACommaList: string): Boolean;

{
  Returns the number of items in ACommaList.
}
function CommaListItemCount(const ACommaList: string): Integer;

{
  Returns ATerm1 + AConcatString + ATerm2. If either Term1 or Term2 is empty,
  returns the other non-empty term without adding AConcatString.
  If both ATerm1 and ATerm2 are empty, returns an empty string.
}
function SmartConcat(const ATerm1, AConcatString, ATerm2: string): string;

{
  Returns the first value in AValues that's different from AValue. If all
  values in AValues are equal to AValue, then the function returns AValue.
}
function FirstDifferent(const AValues: array of string; const AValue: string): string;

///	<summary>Returns the MD5 hash of AString, encoded as a sequence of
///	lower-case hex values. The resulting string holds 32 hex digits,
///	corresponding to 16 bytes.</summary>
function GetStringHash(const AString: string): string;

{
  Converts an ISO day of week (week starts on monday) to a day of week
  (week starts on sunday).
}
function IsoDayOfWeekToDayOfWeek(const ADay: Integer): Integer;

function Split(const AString: string; const ASeparators: string = ' '): TStringDynArray;
function Join(const AStrings: TStringDynArray; const ASeparator: string = ''): string;

function SplitPairs(const AString: string; const ASeparators: string = ' '): TEFPairs;
function JoinPairs(const APairs: TEFPairs; const ASeparator: string = ''): string;

implementation

uses
  SysUtils, StrUtils,
  IdHashMessageDigest, IdHash;

function RightPos(const ASubString, AString: string): Integer;
var
  LCharIndex: Integer;
  LSubStringLength: Integer;
begin
  Result := 0;
  LSubStringLength := Length(ASubString);
  for LCharIndex := Length(AString) - Length(ASubString) + 1 downto 1 do
  begin
    if Copy(AString, LCharIndex, LSubStringLength) = ASubString then
    begin
      Result := LCharIndex;
      Break;
    end;
  end;
end;

function StripPrefixAndSuffix(const AString, APrefix, ASuffix: string): string;
begin
  Result := AString;
  if (APrefix <> '') and AnsiStartsText(APrefix, Result) then
    Delete(Result, 1, Length(APrefix));
  if (ASuffix <> '') and AnsiEndsText(ASuffix, Result) then
    Delete(Result, Length(Result) - Length(ASuffix) + 1, Length(ASuffix));
end;

function StripPrefix(const AString, APrefix: string): string;
begin
  Result := StripPrefixAndSuffix(AString, APrefix, '');
end;

function StripSuffix(const AString, ASuffix: string): string;
begin
  Result := StripPrefixAndSuffix(AString, '', ASuffix);
end;

function GetRandomString(const ALength: Integer): string;
begin
  // If this function is moved out of this unit, then a call to Randomize should
  // be made somewhere in the application. See this unit's initialization section.
  Result := '';
  while Length(Result) < ALength do
    // Randomly decide whether the next character will be a letter or a number.
    if Random(2) = 1 then
      // A random character between '0' and '9'.
      Result := Result + Chr(Random(Ord('9') - Ord('0') + 1) + Ord('0'))
    else
      // A random character between 'A' e 'Z'.
      Result := Result + Chr(Random(Ord('Z') - Ord('A') + 1) + Ord('A'));
end;

function StrMatches(const AString, APattern: string): Boolean;
var
  // Stores the characters of AString except the first one.
  LRestOfString: string;
  // Stores the characters of APattern except the first one.
  LRestOfPattern: string;
begin
  LRestOfString := AString;
  Delete(LRestOfString, 1, 1);
  LRestOfPattern := APattern;
  Delete(LRestOfPattern, 1, 1);
  // Quick exit condition: a single * matches anything.
  // Note that it ain't so for multiple *s.
  if APattern = '*' then
    Result := True
  // An empty pattern matches an empty string.
  else if (AString = '') and (APattern = '') then
    Result := True
  // A non-empty pattern never matches an empty string, unless
  // it is a * (see one of the above cases).
  else if AString = '' then
    Result := False
  // An empty pattern doesn't match a non-empty string.
  else if APattern = '' then
    Result := False
  else
  begin
    // Non-empty pattern and non-empty string: compare pattern and
    // string character by character, taking care of jolly characters
    // in the pattern.
    case APattern[1] of
      '*':
      // Matches anything: match the rest of the pattern or the rest
      // of the string.
      begin
        if StrMatches(AString, LRestOfPattern) then
          Result := True
        else
          Result := StrMatches(LRestOfString, APattern);
      end;
      '?':
        // Matches any one character: advance both string and pattern.
        Result := StrMatches(LRestOfString, LRestOfPattern);
    else
      // No jolly: compare the characters and if they are equal then
      // match the rest, otherwise we don't have a match.
      if (AString[1] = APattern[1]) then
        Result := StrMatches(LRestOfString, LRestOfPattern)
      else
        Result := False;
    end;
  end;
end;

function StrMatchesEx(const AString, APattern: string): Boolean;
begin
  if (APattern <> '') and (APattern[1] = '~') then
    Result := not StrMatches(AString, Copy(APattern, 2, MaxInt))
  else
    Result := StrMatches(AString, APattern);
end;

function CountSubstrings(const AString, ASubstring: string): Integer;
var
  LSubstringPos: Integer;
begin
  Result := 0;
  LSubstringPos := PosEx(ASubstring, AString);
  while LSubstringPos > 0 do
  begin
    if LSubstringPos > 0 then
      Inc(Result);
    LSubstringPos := PosEx(ASubstring, AString, LSubstringPos + Length(ASubString));
  end;
end;

function MatchStr(const AString: string; const AStrings: array of string): Boolean;
begin
  Result := AnsiIndexStr(AString, AStrings) <> -1;
end;

function CreateCompactGuidStr: string;
var
  I: Integer;
  LBuffer: array[0..15] of Byte;
begin
  CreateGUID(TGUID(LBuffer));
  Result := '';
  for I := 0 to 15 do
    Result := Result + IntToHex(LBuffer[I], 2);
end;

function CreateGuidStr: string;
var
  LTempGUID: TGUID;
begin
  CreateGUID(LTempGUID);
  Result := GUIDToString(LTempGUID);
end;

function FetchStr(var AString, ASubstring: string; const ASeparator: string = ';';
  const ARemoveSeparator: Boolean = True): Boolean;
var
  LSeparatorPosition: Integer;
begin
  if AString = '' then
  begin
    ASubString := '';
    Result := False;
  end
  else
  begin
    LSeparatorPosition := Pos(ASeparator, AString);
    if LSeparatorPosition = 0 then
    begin
      // Reached the end of the string.
      ASubstring := AString;
      AString := '';
      Result := False;
    end
    else
    begin
      ASubstring := Copy(AString, 1, LSeparatorPosition - 1);
      if ARemoveSeparator then
        Delete(AString, 1, LSeparatorPosition - 1 + Length(ASeparator))
      else
        Delete(AString, 1, LSeparatorPosition - 1);
      Result := True;
    end;
  end;
end;

function WordPos(const AWord, AString: string): Integer;
const
  SEPARATORS = ' '#8#13#10;
var
  LLeadingChar, LTrailingChar: Char;
  LKeyword: string;
  LIsFound: Boolean;
  LStartPosition: Integer;
begin
  LIsFound := False;
  Result := Pos(AnsiUpperCase(AWord), AnsiUpperCase(AString));
  if Result <> 0 then
  begin
    LKeyword := Copy(AString,Result,Length(AString));

    if not LIsFound then
    begin
      // Check whether the word is at the beginning or end of the string or not.
      if (Result = 1) or (Length(LKeyword) = Length(AWord)) then
        LIsFound := True;
    end;

    if not LIsFound then
    begin
      // Check that the word is a single word.
      LLeadingChar := Copy(AString, Result - 1, 1)[1];
      LTrailingChar := LKeyword[Length(AWord) + 1];
      if (Pos(LLeadingChar, SEPARATORS) <> 0)
          and (Pos(LTrailingChar, SEPARATORS) <> 0) then
        LIsFound := True;
    end;

    if not LIsFound then
    begin
      // Recursion.
      LStartPosition := Result + Length(AWord);
      Result := LStartPosition - 1
        + WordPos(AWord, Copy(AString, LStartPosition, MaxInt));
      if Result <> LStartPosition - 1 then
        LIsFound := True;
    end;

    if not LIsFound and (Result <> 0) then
      Result := 0;
  end;
end;

function WordPos(const AWords: array of string; const AString: string): Integer;
var
  LWordIndex: Integer;
begin
  Result := 0;
  for LWordIndex := Low(AWords) to High(AWords) do
  begin
    Result := WordPos(AWords[LWordIndex], AString);
    if Result <> 0 then
      Break;
  end;
end;

function InternalPad(const AIsLeft: Boolean;
  const AString: string; const AFinalLength: Integer;
  const APadCharacter: Char): string;
var
  LInitialLength: Integer;
begin
  LInitialLength := Length(AString);
  if LInitialLength > AFinalLength then
    raise Exception.CreateFmt('String %s is longer than %d characters. Cannot pad.',
      [AString, AFinalLength]);
  if LInitialLength = AFinalLength then
    Result := AString
  else if AIsLeft then
    Result := DupeString(APadCharacter, AFinalLength - LInitialLength) + AString
  else
    Result := AString + DupeString(APadCharacter, AFinalLength - LInitialLength);
end;

function PadLeft(const AString: string;
  const AFinalLength: Integer; const APadCharacter: Char = '0'): string;
begin
  Result := InternalPad(True, AString, AFinalLength, APadCharacter);
end;

function PadRight(const AString: string;
  const AFinalLength: Integer; const APadCharacter: Char = ' '): string;
begin
  Result := InternalPad(False, AString, AFinalLength, APadCharacter);
end;

function TextFileToString(const AFileName: string): string;
var
  LFile: TextFile;
  LBuffer: string;
begin
  Result := '';
  if FileExists(AFileName) then
  begin
    AssignFile(LFile, AFileName);
    try
      Reset(LFile);
      while not Eof(LFile) do
      begin
        Readln(LFile, LBuffer);
        Result := Result + LBuffer + sLineBreak;
      end;
    finally
      CloseFile(LFile);
    end;
  end;
end;

procedure StringToTextFile(const AString, AFileName: string);
var
  LFile: TextFile;
  LFilePath: string;
begin
  LFilePath := ExtractFilePath(AFileName);
  if LFilePath <> '' then
    ForceDirectories(LFilePath);
  AssignFile(LFile, AFileName);
  try
    Rewrite(LFile);
    Write(LFile, AString);
  finally
    CloseFile(LFile);
  end;
end;

procedure AppendStringToTextFile(const AString, AFileName: string);
var
  LFile: TextFile;
begin
  if not FileExists(AFileName) then
    StringToTextFile(AString, AFileName)
  else
  begin
    AssignFile(LFile, AFileName);
    try
      Append(LFile);
      Write(LFile, AString);
    finally
      CloseFile(LFile);
    end;
  end;
end;

function CamelToUpperUnderscore(const AString: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
  begin
    if AString[I] = UpperCase(AString[I]) then
      if I > 1 then
        Result := Result + '_';
    Result := Result + UpperCase(AString[I]);
  end;
end;

function CamelToSpaced(const AString: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
  begin
    if AString[I] = UpperCase(AString[I]) then
      if I > 1 then
        Result := Result + ' ';
    Result := Result + AString[I];
  end;
end;

function UpperUnderscoreToCamel(const AString: string): string;
var
  I: Integer;
  LNextIsUpper: Boolean;
begin
  Result := '';
  LNextIsUpper := True;
  for I := 1 to Length(AString) do
  begin
    if AString[I] = '_' then
    begin
      LNextIsUpper := True;
      Continue;
    end;
    if LNextIsUpper then
    begin
      Result := Result + UpperCase(AString[I]);
      LNextIsUpper := False;
    end
    else
      Result := Result + LowerCase(AString[I]);
  end;
end;

function MakePlural(const ASingularName: string): string;
begin
  if ASingularName = '' then
    Result := ''
  else
  begin
    if not SameText(ASingularName[Length(ASingularName)], 's') then
    begin
      if SameText(ASingularName[Length(ASingularName)], 'y') then
        Result := Copy(ASingularName, 1, Length(ASingularName) - 1) + 'ies'
      else
        Result := ASingularName + 's';
    end
    else
      Result := ASingularName;
  end;
  if ASingularName = UpperCase(ASingularName) then
    Result := UpperCase(Result);
end;

function GetIndexOfValue(const AStrings: TStrings; const AValue: string): Integer;
begin
  for Result := 0 to AStrings.Count - 1 do
    if AStrings.Values[AStrings.Names[Result]] = AValue then
      Exit;
  Result := -1;
end;

function InsertStr(const ASubstring, AString: string; const AIndex: Integer): string;
begin
  Result := AString;
  Insert(ASubstring, Result, AIndex);
end;

function CountLeading(const AString: string; const AChar: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  if AString <> '' then
    for I := 1 to Length(AString) do
    begin
      if AString[I] = AChar then
        Inc(Result)
      else
        Break;
    end;
end;

function TabsToSpaces(const AString: string; const ASpacesPerTab: Integer): string;
begin
  Result := ReplaceStr(AString, #9, StringOfChar(' ', ASpacesPerTab));
end;

function GetStringHash(const AString: string): string;
var
  LHash: TIdHashMessageDigest5;
begin
  if AString = '' then
    Result := ''
  else
  begin
    LHash := TIdHashMessageDigest5.Create;
    try
      Result := LowerCase(LHash.HashStringAsHex(AString));
    finally
      FreeAndNil(LHash);
    end;
  end;
end;

{ TEFStringTokenizer }

constructor TEFStringTokenizer.Create(const ATokens: string; const ATokenSeparator: Char);
begin
  inherited Create;
  FTokens := TStringList.Create;
  ExtractTokens(ATokens, ATokenSeparator);
end;

destructor TEFStringTokenizer.Destroy;
begin
  FTokens.Free;
  inherited;
end;

procedure TEFStringTokenizer.ExtractTokens(const ATokens: string;
  const ATokenSeparator: Char);
begin
  FTokens.Text := StringReplace(ATokens, ATokenSeparator, sLineBreak, [rfReplaceAll]);
end;

function TEFStringTokenizer.IndexOfToken(const AToken: string): Integer;
begin
  Result := FTokens.IndexOf(AToken);
end;

function TEFStringTokenizer.GetToken(const AIndex: Integer): string;
begin
  Result := FTokens[AIndex];
end;

function TEFStringTokenizer.GetTokenCount: Integer;
begin
  Result := FTokens.Count;
end;

function TEFStringTokenizer.AddTokensToStrings(const AStrings: TStrings): Integer;
begin
  AStrings.AddStrings(FTokens);
  Result := FTokens.Count;
end;

{ TEFStringStack }

function TEFStringStack.Peek: string;
begin
  if Count > 0 then
    Result := Strings[Count - 1]
  else
    Result := '';
end;

function TEFStringStack.Pop: string;
begin
  if Count > 0 then
  begin
    Result := Strings[Count - 1];
    Delete(Count - 1);
  end
  else
    Result := '';
end;

procedure TEFStringStack.Push(const AString: string);
begin
  Add(AString);
end;

function StringInCommaList(const AString, ACommaList: string): Boolean;
var
  LCommaList: TStrings;
begin
  LCommaList := TStringList.Create;
  try
    LCommaList.CommaText := ACommaList;
    Result := LCommaList.IndexOf(AString) >= 0;
  finally
    LCommaList.Free;
  end;
end;

function CommaListItemCount(const ACommaList: string): Integer;
var
  LCommaList: TStrings;
begin
  LCommaList := TStringList.Create;
  try
    LCommaList.CommaText := ACommaList;
    Result := LCommaList.Count;
  finally
    LCommaList.Free;
  end;
end;

function SmartConcat(const ATerm1, AConcatString, ATerm2: string): string;
begin
  if ATerm1 = '' then
    Result := ATerm2
  else if ATerm2 = '' then
    Result := ATerm1
  else
    Result := ATerm1 + AConcatString + ATerm2;
end;

function FirstDifferent(const AValues: array of string; const AValue: string): string;
var
  LValueIndex: Integer;
begin
  Result := AValue;
  for LValueIndex := Low(AValues) to High(AValues) do
  begin
    if AValues[LValueIndex] <> AValue then
    begin
      Result := AValues[LValueIndex];
      Break;
    end;
  end;
end;

function IsoDayOfWeekToDayOfWeek(const ADay: Integer): Integer;
begin
  Assert((ADay >= 1) and (ADay <= 7));
  Result := Succ(ADay);
  if Result > 7 then
    Result := 1;
end;

function Split(const AString: string; const ASeparators: string): TStringDynArray;
begin
  Result := SplitString(AString, ASeparators);
end;

function Join(const AStrings: TStringDynArray; const ASeparator: string): string;
var
  LString: string;
begin
  Result := '';
  for LString in AStrings do
  begin
    if Result = '' then
      Result := LString
    else
      Result := Result + ASeparator + LString;
  end;
end;

function SplitPairs(const AString: string; const ASeparators: string = ' '): TEFPairs;
var
  LStrings: TStringDynArray;
  I: Integer;
  LItem: TStringDynArray;
begin
  LStrings := Split(AString, ASeparators);
  SetLength(Result, Length(LStrings));
  for I := Low(LStrings) to High(LStrings) do
  begin
    LItem := Split(LStrings[I], '=');
    if Length(LItem) = 2 then
      Result[I] := TEFPair.Create(LItem[0], LItem[1])
    else
      Result[I] := TEFPair.Create(LStrings[I], '');
  end;
end;

function JoinPairs(const APairs: TEFPairs; const ASeparator: string = ''): string;
var
  LStrings: TStringDynArray;
  I: Integer;
begin
  SetLength(LStrings, Length(APairs));
  for I := Low(APairs) to High(APairs) do
    LStrings[I] := APairs[I].Key + '=' + APairs[I].Value;
  Result := Join(LStrings, ASeparator);
end;

initialization
  Randomize;

end.
