{-------------------------------------------------------------------------------
   Copyright 2012-2018 Ethea S.r.l.

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

unit Kitto.Ext.Window;

{$I Kitto.Defines.inc}

interface

uses
  Kitto.Ext.Base, Kitto.Ext.Controller;

type
  TKExtWindowController = class(TKExtWindowControllerBase)
  protected
    procedure DoDisplay; override;
    procedure InitDefaults; override;
  end;

implementation

uses
  Ext.Base
  , EF.Localization
  , Kitto.Metadata.Views
  ;

{ TKExtWindowController }

procedure TKExtWindowController.DoDisplay;
begin
  Title := _(View.GetExpandedString('DisplayLabel'));
  Width := Config.GetInteger('Width', DEFAULT_WINDOW_WIDTH);
  Height := Config.GetInteger('Height', DEFAULT_WINDOW_HEIGHT);
  ResizeHandles := Config.GetString('ResizeHandles');
  Resizable := ResizeHandles <> '';
  Maximizable := Config.GetBoolean('Maximizable', Resizable);
  inherited;
end;

procedure TKExtWindowController.InitDefaults;
begin
  inherited;
  Constrain := True;
  Closable := False;
end;

initialization
  TKExtControllerRegistry.Instance.RegisterClass('Window', TKExtWindowController);

finalization
  TKExtControllerRegistry.Instance.UnregisterClass('Window');

end.
