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
unit KIDE.LoginWindowLocalStorageDesignerFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, KIDE.EditNodeBaseFrameUnit,
  Vcl.ExtCtrls, Vcl.Tabs,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls, Vcl.Buttons,
  KIDE.BaseFrameUnit, KIDE.CodeEditorFrameUnit,
  EF.Tree, Vcl.Samples.Spin, KIDE.ControllerDesignerFrameUnit;

type
  TLoginWindowLocalStorageDesignerFrame = class(TEditNodeBaseFrame)
    ModeLabel: TLabel;
    _Mode: TComboBox;
    _AskUser_Default: TCheckBox;
    _AskUser: TCheckBox;
  private
  protected
    class function SuitsNode(const ANode: TEFNode): Boolean; override;
    procedure UpdateDesignPanel(const AForce: Boolean = False); override;
    procedure CleanupDefaultsToEditNode; override;
    procedure UpdateEditComponents; override;
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
  KIDE.Utils;

{ TWindowControllerDesignerFrame }

procedure TLoginWindowLocalStorageDesignerFrame.CleanupDefaultsToEditNode;
var
  Resizable: Boolean;
begin
  inherited;
  CleanupTextNode('Mode');
  CleanupBooleanNode('AskUser/Default', True);
  CleanupOrphanNode('AskUser');
  CleanupBooleanNode('AskUser');
end;

procedure TLoginWindowLocalStorageDesignerFrame.Init(const ANode: TEFTree);
begin
  inherited;
end;

class function TLoginWindowLocalStorageDesignerFrame.SuitsNode(
  const ANode: TEFNode): Boolean;
var
  LControllerClass: TClass;
begin
  Result := False;
  if SameText(ANode.Name, 'LocalStorage') and (ANode.Parent is TEFNode) then
  begin
    LControllerClass := GetControllerClass(TEFNode(ANode.Parent));
    Result := Assigned(LControllerClass) and
    LControllerClass.InheritsFrom(TKExtLoginWindow);
  end;
end;

procedure TLoginWindowLocalStorageDesignerFrame.UpdateDesignPanel(
  const AForce: Boolean);
begin
  inherited;
  Assert(Assigned(EditNode));
  _AskUser_Default.Checked := EditNode.GetBoolean('AskUser/Default', True);
end;

procedure TLoginWindowLocalStorageDesignerFrame.UpdateEditComponents;
begin
  inherited;
  _AskUser_Default.Visible := _AskUser.Checked;
end;

initialization
  TEditNodeFrameRegistry.Instance.RegisterClass(TLoginWindowLocalStorageDesignerFrame.GetClassId, TLoginWindowLocalStorageDesignerFrame);

finalization
  TEditNodeFrameRegistry.Instance.UnregisterClass(TLoginWindowLocalStorageDesignerFrame.GetClassId);

end.
