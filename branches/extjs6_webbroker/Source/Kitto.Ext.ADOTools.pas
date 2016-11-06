{-------------------------------------------------------------------------------
   Copyright 2014 Ethea S.r.l.

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

unit Kitto.Ext.ADOTools;

interface

uses
  SysUtils, Classes, ADODB, DB, Generics.Collections,
  EF.Tree, Kitto.Excel,
  Kitto.Ext.Controller, Kitto.Ext.DataTool, Kitto.Ext.Base, Kitto.Ext.Tools,
  Kitto.Metadata.DataView, Kitto.Ext.StandardControllers;

type
  TExportExcelToolController = class(TKExtDownloadFileController)
  strict private
    FExportExcelEngine: TKExcelExportEngine;
    function GetExcelRangeName: string;
    function GetTemplateFileName: string;
    function GetUseDisplayLabels: boolean;
  strict protected
    function GetDefaultFileName: string; override;
    function GetDefaultFileExtension: string; override;
    procedure PrepareFile(const AFileName: string); override;
    procedure AcceptRecord(ARecord: TKViewTableRecord; var AAccept: boolean); virtual;
    procedure AcceptField(AViewField: TKViewField; var AAccept: boolean); virtual;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    class function GetDefaultImageName: string; override;
    property ExportEngine: TKExcelExportEngine read FExportExcelEngine;
  published
    property ExcelRangeName: string read GetExcelRangeName;
    property TemplateFileName: string read GetTemplateFileName;
    property UseDisplayLabels: boolean read GetUseDisplayLabels;
  end;

  TUploadExcelToolController = class(TKExtUploadFileController)
  strict private
    FImportExcelEngine: TKExcelImportEngine;
    FFieldMappings: TStringList;
    function GetExcelRangeName: string;
    function GetFieldMappings: TStringList;
  private
  protected
    function GetAcceptedWildcards: string; override;
    procedure ProcessUploadedFile(const AFileName: string); override;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    class function GetDefaultImageName: string; override;
    property ImportEngine: TKExcelImportEngine read FImportExcelEngine;
  published
    property ExcelRangeName: string read GetExcelRangeName;
    property FieldMappings: TStringList read GetFieldMappings;
  end;

  TImportExcelToolController = class(TKExtUploadFileController)
  strict private
    FImportExcelEngine: TKExcelImportEngine;
    FFieldMappings: TStringList;
    function GetExcelRangeName: string;
    function GetFieldMappings: TStringList;
  private
  protected
    function GetAcceptedWildcards: string; override;
    procedure ProcessUploadedFile(const AFileName: string); override;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    class function GetDefaultImageName: string; override;
    property ImportEngine: TKExcelImportEngine read FImportExcelEngine;
  published
    property ExcelRangeName: string read GetExcelRangeName;
    property FieldMappings: TStringList read GetFieldMappings;
  end;

function DefaultExcelWildcards: string;

implementation

uses
  Math
  , Ext.Base
  , EF.DB
  , EF.SysUtils
  , EF.StrUtils
  , Kitto.Metadata.Models
  , Kitto.Config
  ;

function DefaultExcelWildcards: string;
begin
  Result := Format('*%s *%s', [EXCEL_NEW_FILE_EXT, EXCEL_FILE_EXT]);
end;

{ TExportExcelToolController }

procedure TExportExcelToolController.AfterConstruction;
begin
  inherited;
  FExportExcelEngine := TKExcelExportEngine.Create(self);
end;

destructor TExportExcelToolController.Destroy;
begin
  FreeAndNil(FExportExcelEngine);
  inherited;
end;

function TExportExcelToolController.GetDefaultFileExtension: string;
begin
  Result := EXCEL_NEW_FILE_EXT;
end;

class function TExportExcelToolController.GetDefaultImageName: string;
begin
  Result := 'excel_document';
end;

function TExportExcelToolController.GetExcelRangeName: string;
begin
  Result := Config.GetString('ExcelRangeName', EXCEL_DEFAULT_RANGE);
end;

function TExportExcelToolController.GetTemplateFileName: string;
begin
  Result := Config.GetExpandedString('TemplateFileName');
end;

function TExportExcelToolController.GetUseDisplayLabels: Boolean;
begin
  Result := Config.GetBoolean('UseDisplayLabels');
end;

procedure TExportExcelToolController.AcceptRecord(ARecord: TKViewTableRecord; var AAccept: boolean);
begin
  if AAccept and Assigned(ServerRecord) then
    AAccept := ARecord = ServerRecord;
end;

procedure TExportExcelToolController.AcceptField(AViewField: TKViewField; var AAccept: boolean);
begin
  AAccept := AViewField.IsVisible;
end;

procedure TExportExcelToolController.PrepareFile(const AFileName: string);
var
  LStore: TKViewTableStore;
begin
  inherited;
  LStore := ServerStore;
  //if not using a template file we must built the structure of a new excel file using ADOX
  if (TemplateFileName = '') then
    FExportExcelEngine.CreateFileByTable(AFileName, LStore, ExcelRangeName,
      AcceptField, UseDisplayLabels)
  else
  begin
    Assert(FileExists(TemplateFileName),
      Format('Excel template file "%s" not found!',[TemplateFileName]));
    //Save the template file as the output file
    CopyFile(TemplateFileName, AFileName);
  end;

  //Now the output file is ready: filling data
  FExportExcelEngine.FillAdoTable(AFileName, ExcelRangeName, LStore,
    AcceptRecord, AcceptField, UseDisplayLabels);
end;

function TExportExcelToolController.GetDefaultFileName: string;
var
  LFileExtension: string;
begin
  LFileExtension := ExtractFileExt(ClientFileName);
  if LFileExtension = '' then
    LFileExtension := GetDefaultFileExtension;
  Result := EF.SysUtils.GetTempFileName(LFileExtension);
  AddTempFilename(Result);
end;

{ TUploadExcelToolController }

procedure TUploadExcelToolController.AfterConstruction;
begin
  inherited;
  FImportExcelEngine := TKExcelImportEngine.Create(self);
end;

destructor TUploadExcelToolController.Destroy;
begin
  FreeAndNil(FImportExcelEngine);
  FreeAndNil(FFieldMappings);
  inherited;
end;

class function TUploadExcelToolController.GetDefaultImageName: string;
begin
  Result := 'excel_document';
end;

function TUploadExcelToolController.GetAcceptedWildcards: string;
begin
  Result := inherited GetAcceptedWildcards;
  if Result = '' then
    Result := DefaultExcelWildcards;
end;

function TUploadExcelToolController.GetExcelRangeName: string;
begin
  Result := Config.GetString('ExcelRangeName', EXCEL_DEFAULT_RANGE);
end;

function TUploadExcelToolController.GetFieldMappings: TStringList;
begin
  if not Assigned(FFieldMappings) then
  begin
    FFieldMappings := TStringList.Create;
    Config.GetChildrenAsStrings('FieldMappings', FFieldMappings);
  end;
  Result := FFieldMappings;
end;

procedure TUploadExcelToolController.ProcessUploadedFile(const AFileName: string);
begin
  inherited;
  FImportExcelEngine.ImportFileIntoViewTable(
    AFileName, ViewTable, FieldMappings, ExcelRangeName);
end;

{ TImportExcelToolController }

procedure TImportExcelToolController.AfterConstruction;
begin
  inherited;
  FImportExcelEngine := TKExcelImportEngine.Create(self);
end;

destructor TImportExcelToolController.Destroy;
begin
  FreeAndNil(FImportExcelEngine);
  FreeAndNil(FFieldMappings);
  inherited;
end;

class function TImportExcelToolController.GetDefaultImageName: string;
begin
  Result := 'excel_document';
end;

function TImportExcelToolController.GetAcceptedWildcards: string;
begin
  Result := inherited GetAcceptedWildcards;
  if Result = '' then
    Result := DefaultExcelWildcards;
end;

function TImportExcelToolController.GetExcelRangeName: string;
begin
  Result := Config.GetString('ExcelRangeName', EXCEL_DEFAULT_RANGE);
end;

function TImportExcelToolController.GetFieldMappings: TStringList;
begin
  if not Assigned(FFieldMappings) then
  begin
    FFieldMappings := TStringList.Create;
    Config.GetChildrenAsStrings('FieldMappings', FFieldMappings);
  end;
  Result := FFieldMappings;
end;

procedure TImportExcelToolController.ProcessUploadedFile(const AFileName: string);
begin
  inherited;
  FImportExcelEngine.ImportFileIntoViewTable(
    AFileName, ViewTable, FieldMappings, ExcelRangeName);
end;

initialization
  TKExtControllerRegistry.Instance.RegisterClass('ExportExcelTool', TExportExcelToolController);
  TKExtControllerRegistry.Instance.RegisterClass('ImportExcelTool', TImportExcelToolController);
  TKExtControllerRegistry.Instance.RegisterClass('UploadExcelTool', TUploadExcelToolController);

finalization
  TKExtControllerRegistry.Instance.UnregisterClass('ExportExcelTool');
  TKExtControllerRegistry.Instance.UnregisterClass('ImportExcelTool');
  TKExtControllerRegistry.Instance.UnregisterClass('UploadExcelTool');

end.
