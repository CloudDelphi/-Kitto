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
  Ext,
  EF.Localization,
  Kitto.Ext.Session, Kitto.Metadata.Views;

{ TKExtWindowController }

procedure TKExtWindowController.DoDisplay;
begin
  Title := _(View.GetExpandedString('DisplayLabel'));
  Width := View.GetInteger('Controller/Width', 800);
  Height := View.GetInteger('Controller/Height', 600);
  ResizeHandles := View.GetString('Controller/ResizeHandles');
  Resizable := ResizeHandles <> '';
  Maximizable := View.GetBoolean('Controller/Maximizable', Resizable);
  Draggable := View.GetBoolean('Controller/Movable', True);
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
