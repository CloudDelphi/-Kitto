inherited ListControllerFiltersItemsNodeFrame: TListControllerFiltersItemsNodeFrame
  Width = 451
  ExplicitWidth = 451
  inherited ClientPanel: TPanel
    Width = 451
    ExplicitWidth = 451
    inherited DesignPanel: TPanel
      Width = 451
      ExplicitWidth = 451
      object ItemsPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 451
        Height = 299
        ActivePage = ItemTabSheet
        Align = alClient
        TabOrder = 0
        object ItemTabSheet: TTabSheet
          Caption = 'Item'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
      end
    end
  end
end
