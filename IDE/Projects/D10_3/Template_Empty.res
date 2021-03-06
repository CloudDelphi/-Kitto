        ??  ??                     P   ??
 E M P T Y _ S U P P O R T _ A C _ D B _ Y A M L         0         AccessControl: DB   K  X   ??
 E M P T Y _ S U P P O R T _ A F T E R C R E A T E _ R T F       0         {\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1040{\fonttbl{\f0\fnil\fcharset0 Calibri;}{\f1\fnil\fcharset2 Symbol;}}
{\*\generator Riched20 10.0.16299}\viewkind4\uc1 
\pard\sa200\sl276\slmult1\f0\fs22\lang16 A new empty Kide project was created and will be open now.\par
\b Where do I go from here?\par
\b0 You can:\par

\pard{\pntext\f1\'B7\tab}{\*\pn\pnlvlblt\pnf1\pnindent0{\pntxtb\'B7}}\fi-360\li720\sa200\sl276\slmult1 Edit Config.yaml to set access parameters for your database(s) and/or add more databases as required.\par
{\pntext\f1\'B7\tab}Run the Model Wizard to create Models based on database tables and views. \par
{\pntext\f1\'B7\tab}Run the Data View Wizard to create data views based on your Models.\par
{\pntext\f1\'B7\tab}Create .pas files and add any server-side code.\par

\pard\sa200\sl276\slmult1\par
}
  ?   T   ??
 E M P T Y _ S U P P O R T _ A U T H _ D B _ Y A M L         0         Auth: DB
  IsClearPassword: False
  IsPassepartoutEnabled: False
  PassepartoutPassword:
  AfterAuthenticateCommandText:
  ReadUserCommandText:
  SetPasswordCommandText:
  Defaults:
    UserName:
    Password:  ;   `   ??
 E M P T Y _ S U P P O R T _ A U T H _ D B S E R V E R _ Y A M L         0         Auth: DBServer
  Defaults:
    UserName:
    Password:
 ?   X   ??
 E M P T Y _ S U P P O R T _ A U T H _ O S D B _ Y A M L         0         Auth: OSDB
  IsClearPassword: False
  IsPassepartoutEnabled: False
  PassepartoutPassword:
  AfterAuthenticateCommandText:
  ReadUserCommandText:
  SetPasswordCommandText:
  Defaults:
    UserName:
    Password:
  w   `   ??
 E M P T Y _ S U P P O R T _ A U T H _ T E X T F I L E _ Y A M L         0         Auth: TextFile
  IsClearPassword: False
  FileName: %HOME_PATH%\Auth.txt
  Defaults:
    UserName:
    Password:
 j  P   ??
 E M P T Y _ S U P P O R T _ D B _ A D O _ Y A M L       0         Connection:
  # This doesn't work because of a bug with date and time fields in ADO/OLEDB.
  # See http://qc.embarcadero.com/wc/qcmain.aspx?d=78910
  #Provider: SQLOLEDB.1
  # Using the Native client fixes the date bug but still not the time bug.
  Provider: SQLNCLI10
  Trusted_Connection: Yes
  Initial Catalog: ChangeMe
  Data Source: %COMPUTERNAME%
  ?   P   ??
 E M P T Y _ S U P P O R T _ D B _ D B X _ Y A M L       0         Connection:
  DriverName: Firebird
  DataBase: localhost:ChangeMe
  User_Name: SYSDBA
  Password: masterkey
  ServerCharSet: UTF8
  WaitOnLocks: True
  IsolationLevel: ReadCommitted
  Trim Char: False
    P   ??
 E M P T Y _ S U P P O R T _ D B _ F D _ Y A M L         0         ﻿Connection:
  # Example for MSSQL
  DriverID: MSSQL
  Server: %COMPUTERNAME%
  ApplicationName: %APPTITLE%
  Database: ChangeMe
  OSAuthent: Yes
  # if OSAuthent: No provide User_Name and Password
  User_Name: ChangeMe
  Password: ChangeMe
  Isolation: ReadCommitted

Connection:
  # Example for Firebird
  DriverID: FB
  # Alias of database defined in Aliases.conf
  Database: ChangeMe
  User_Name: ChangeMe
  Password: ChangeMe
  Server: localhost
  CharacterSet: UTF8
  Protocol: TCPIP
  Isolation: ReadCommitted
  (  L   ??
 E M P T Y _ S U P P O R T _ I N F O _ R T F         0         {\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1040{\fonttbl{\f0\fnil\fcharset0 Calibri;}}
{\*\generator Riched20 10.0.16299}\viewkind4\uc1 
\pard\sa200\sl276\slmult1\b\f0\fs22\lang16 Empty\b0\par
This template creates an empty project, with no sample units, code or configurations.\par
}
 s  \   ??
 E M P T Y _ H O M E _ M E T A D A T A _ C O N F I G _ Y A M L       0         AppTitle: {AppTitle}

Databases:

Auth: Null

AccessControl: Null

ExtJS:
  Theme: classic
  AjaxTimeout: 100000

LanguageId: en
# Either utf-8 or a SBCS corresponding to the system code page
# (such as iso-8859-1 for Western Europe). Defaults to utf-8.
Charset: utf-8

Server:
  Port: 8080
  ThreadPoolSize: 20
  # In minutes.
  SessionTimeOut: 10
 s   l   ??
 E M P T Y _ H O M E _ R E S O U R C E S _ J S _ A P P L I C A T I O N _ C S S       0         /* This file is automatically included in all rendered pages. */
/* Put extra CSS classes used in views here. */
 j   l   ??
 E M P T Y _ H O M E _ R E S O U R C E S _ J S _ A P P L I C A T I O N _ J S         0         // This file is automatically included in all rendered pages.

// Put utility code used in views here.
  ?   P   ??
 E M P T Y _ S O U R C E _ P R O J E C T _ D P R         0         program {ProjectName};

uses
  Kitto.Ext.Start,
  Controllers in '..\..\Source\Controllers.pas',
  Rules in '..\..\Source\Rules.pas',
  UseKitto in '..\..\Source\UseKitto.pas';

{$R *.res}

begin
  TKExtStart.Start;
end.
  2  X   ??
 E M P T Y _ S O U R C E _ C O N T R O L L E R S _ P A S         0         // This unit should contain any custom controllers used
// by the application. The two controllers defined here
// are provided as examples.
unit Controllers;

interface

uses
  Kitto.Ext.Controller, Kitto.Ext.DataTool, Kitto.Ext.Base;

type
  // Navigates to a different URL depending on the client's IP address.
  TURLToolController = class(TKExtDataToolController)
  protected
    procedure ExecuteTool; override;
  end;

  TTestToolController = class(TKExtDataToolController)
  protected
    procedure ExecuteTool; override;
  //published
    procedure Callback;
    procedure DownloadFile;
  end;

implementation

uses
  SysUtils
  , Classes
  , Ext.Base
  , Kitto.JS
  , Kitto.Web.Application
  , Kitto.Web.Request
  ;

{ TTestToolController }

procedure TTestToolController.Callback;
begin
  ExtMessageBox.Alert('Test Tool', 'This is a callback');
end;

procedure TTestToolController.ExecuteTool;
begin
  inherited;
  //ExtMessageBox.Alert('Test Tool', 'This is a custom action', RequestDownload(DownloadFile));
  Download(DownloadFile);
end;

procedure TTestToolController.DownloadFile;
var
  LStream: TFileStream;
begin
  LStream := TFileStream.Create('c:\temp\test2.pdf', fmOpenRead);
  try
    TKWebApplication.Current.DownloadStream(LStream, 'customfile.pdf');
  finally
    FreeAndNil(LStream);
  end;
  //Session.DownloadFile('c:\temp\test2.pdf');
end;

{ TURLToolController }

procedure TURLToolController.ExecuteTool;
var
  LAddr: string;
begin
  inherited;
  LAddr := TKWebRequest.Current.RemoteAddr;
  if LAddr = '127.0.0.1' then
    TKWebApplication.Current.Navigate('http://www.ethea.it')
  else
    TKWebApplication.Current.Navigate('http://www.sencha.com');
end;

initialization
  TKExtControllerRegistry.Instance.RegisterClass('TestTool', TTestToolController);
  TKExtControllerRegistry.Instance.RegisterClass('URLTool', TURLToolController);

finalization
  TKExtControllerRegistry.Instance.UnregisterClass('TestTool');
  TKExtControllerRegistry.Instance.UnregisterClass('URLTool');

end.
  ?  L   ??
 E M P T Y _ S O U R C E _ R U L E S _ P A S         0         // This unit should contain any custom rules used
// by the application. The rule defined here
// is provided as an example.
unit Rules;

interface

uses
  Kitto.Rules, KItto.Store;

type
  TCheckDuplicateInvitations = class(TKRuleImpl)
  public
    procedure BeforeAdd(const ARecord: TKRecord); override;
  end;

implementation

uses
  EF.Localization,
  Kitto.Metadata.DataView;

{ TCheckDuplicateInvitations }

procedure TCheckDuplicateInvitations.BeforeAdd(const ARecord: TKRecord);
begin
  if ARecord.Store.Count('INVITEE_ID', ARecord.FieldByName('INVITEE_ID').Value) > 1 then
    RaiseError(_('Cannot invite the same girl twice.'));
end;

initialization
  TKRuleImplRegistry.Instance.RegisterClass(TCheckDuplicateInvitations.GetClassId, TCheckDuplicateInvitations);

finalization
  TKRuleImplRegistry.Instance.UnregisterClass(TCheckDuplicateInvitations.GetClassId);

end.
   P   ??
 E M P T Y _ S O U R C E _ U S E K I T T O _ P A S       0         unit UseKitto;

interface

uses
  {DB/ADO},
  {DB/FD},
  {DB/DBX},{AC}{Auth}
  Kitto.Auth.DB,
  Kitto.Localization.dxgettext,
  Kitto.Ext.TilePanel,
  Kitto.Metadata.ModelImplementation,
  Kitto.Metadata.ViewBuilders,
  Kitto.Ext.All
  ;

implementation

end.
 