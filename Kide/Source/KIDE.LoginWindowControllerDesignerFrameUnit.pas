{*******************************************************************}
{                                                                   }
{   Kide2 Editor: GUI for Kitto2                                    }
{                                                                   }
{   Copyright (c) 2012-2017 Ethea S.r.l.                            }
{   ALL RIGHTS RESERVED / TUTTI I DIRITTI RISERVATI                 }
{                                                                   }
{*******************************************************************}
{                                                                   }
{   The entire contents of this file is protected by                }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT  }
{   AND PERMISSION FROM ETHEA S.R.L.                                }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{*******************************************************************}
{                                                                   }
{   Il contenuto di questo file � protetto dalle leggi              }
{   internazionali sul Copyright. Sono vietate la riproduzione, il  }
{   reverse-engineering e la distribuzione non autorizzate di tutto }
{   o parte del codice contenuto in questo file. Ogni infrazione    }
{   sar� perseguita civilmente e penalmente a termini di legge.     }
{                                                                   }
{   RESTRIZIONI                                                     }
{                                                                   }
{   SONO VIETATE, SENZA IL CONSENSO SCRITTO DA PARTE DI             }
{   ETHEA S.R.L., LA COPIA, LA VENDITA, LA DISTRIBUZIONE E IL       }
{   TRASFERIMENTO A TERZI, A QUALUNQUE TITOLO, DEL CODICE SORGENTE  }
{   CONTENUTO IN QUESTO FILE E ALTRI FILE AD ESSO COLLEGATI.        }
{                                                                   }
{   SI FACCIA RIFERIMENTO ALLA LICENZA D'USO PER INFORMAZIONI SU    }
{   EVENTUALI RESTRIZIONI ULTERIORI.                                }
{                                                                   }
{*******************************************************************}
unit KIDE.LoginWindowControllerDesignerFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, KIDE.EditNodeBaseFrameUnit,
  Vcl.ExtCtrls, Vcl.Tabs,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls, Vcl.Buttons,
  KIDE.BaseFrameUnit, KIDE.CodeEditorFrameUnit, KIDE.ControllerDesignerFrameUnit,
  EF.Tree, Vcl.Samples.Spin;

type
  TLoginWindowControllerDesignerFrame = class(TControllerDesignerFrame)
    LoginPageControl: TPageControl;
    WindowTabSheet: TTabSheet;
    LocalStorageTabSheet: TTabSheet;
    BorderPanelTabSheet: TTabSheet;
    ExtraWidthLabel: TLabel;
    _ExtraWidth: TSpinEdit;
    ExtraHeightLabel: TLabel;
    _ExtraHeight: TSpinEdit;
    LabelWidthLabel: TLabel;
    _LabelWidth: TSpinEdit;
    procedure LoginPageControlChange(Sender: TObject);
  private
  protected
    class function SuitsNode(const ANode: TEFNode): Boolean; override;
    procedure UpdateDesignPanel(const AForce: Boolean = False); override;
    procedure CleanupDefaultsToEditNode; override;
    procedure DesignPanelToEditNode; override;
  protected
  public
    procedure Init(const ANode: TEFTree); override;
  end;

implementation

{$R *.dfm}

uses
  EF.Macros,
  Kitto.Ext.Controller, Kitto.Ext.Base,
  Kitto.Ext.AccordionPanel,
  Kitto.Ext.ToolBar,
  Kitto.Ext.Login,
  Kitto.Ext.List,
  Kitto.Ext.Form,
  KIDE.BorderPanelControllerDesignerFrameUnit,
  KIDE.LoginWindowLocalStorageDesignerFrameUnit,
  KIDE.Utils;

{ TWindowControllerDesignerFrame }

procedure TLoginWindowControllerDesignerFrame.CleanupDefaultsToEditNode;
var
  Resizable: Boolean;
begin
  inherited;
  CleanupIntegerNode('ExtraWidth');
  CleanupIntegerNode('ExtraHeight');
  CleanupTextNode('LabelWidth');
  CleanupOrphanNode('LocalStorage');
end;

procedure TLoginWindowControllerDesignerFrame.DesignPanelToEditNode;
begin
  inherited;
  LoginPageControl.ActivePageIndex := 0;
end;

procedure TLoginWindowControllerDesignerFrame.Init(const ANode: TEFTree);
begin
  inherited;
  EmbedEditNodeFrame(LocalStorageTabSheet, TLoginWindowLocalStorageDesignerFrame,
    EditNode.FindNode('LocalStorage'));
end;

procedure TLoginWindowControllerDesignerFrame.LoginPageControlChange(
  Sender: TObject);
begin
  inherited;
  if LoginPageControl.ActivePage = LocalStorageTabSheet then
    EmbedEditNodeFrame(LocalStorageTabSheet, TLoginWindowLocalStorageDesignerFrame,
      EditNode.FindNode('LocalStorage', True), True);
end;

class function TLoginWindowControllerDesignerFrame.SuitsNode(
  const ANode: TEFNode): Boolean;
var
  LControllerClass: TClass;
begin
  Assert(Assigned(ANode));
  LControllerClass := GetControllerClass(ANode);
  Result := Assigned(LControllerClass) and
    LControllerClass.InheritsFrom(TKExtLoginWindow);
end;

procedure TLoginWindowControllerDesignerFrame.UpdateDesignPanel(
  const AForce: Boolean);
begin
  inherited;
  Assert(Assigned(EditNode));
  LoginPageControl.ActivePageIndex := 0;
end;

initialization
  TEditNodeFrameRegistry.Instance.RegisterClass(TLoginWindowControllerDesignerFrame.GetClassId, TLoginWindowControllerDesignerFrame);

finalization
  TEditNodeFrameRegistry.Instance.UnregisterClass(TLoginWindowControllerDesignerFrame.GetClassId);

end.
