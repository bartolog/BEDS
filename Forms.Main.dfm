object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'BEDS - Management System'
  ClientHeight = 441
  ClientWidth = 624
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 15
  object navMain: TdxNavBar
    Left = 0
    Top = 0
    Width = 230
    Height = 441
    Align = alLeft
    ActiveGroupIndex = 0
    TabOrder = 0
    View = 21
    ViewStyle.SkinNameAssigned = True
    OptionsStyle.DefaultStyles.Item.BackColor = clWhite
    OptionsStyle.DefaultStyles.Item.BackColor2 = clWhite
    OptionsStyle.DefaultStyles.Item.Font.Charset = DEFAULT_CHARSET
    OptionsStyle.DefaultStyles.Item.Font.Color = clWhite
    OptionsStyle.DefaultStyles.Item.Font.Height = -15
    OptionsStyle.DefaultStyles.Item.Font.Name = 'Segoe UI'
    OptionsStyle.DefaultStyles.Item.Font.Style = []
    OptionsStyle.DefaultStyles.Item.AssignedValues = [savFont]
    OptionsStyle.DefaultStyles.ItemHotTracked.BackColor = 11104281
    OptionsStyle.DefaultStyles.ItemHotTracked.BackColor2 = 11104281
    OptionsStyle.DefaultStyles.ItemHotTracked.Font.Charset = DEFAULT_CHARSET
    OptionsStyle.DefaultStyles.ItemHotTracked.Font.Color = clWhite
    OptionsStyle.DefaultStyles.ItemHotTracked.Font.Height = -15
    OptionsStyle.DefaultStyles.ItemHotTracked.Font.Name = 'Segoe UI'
    OptionsStyle.DefaultStyles.ItemHotTracked.Font.Style = []
    OptionsStyle.DefaultStyles.ItemHotTracked.AssignedValues = [savBackColor, savBackColor2]
    object Navigazione: TdxNavBarGroup
      Caption = 'Navigazione'
      SelectedLinkIndex = -1
      TopVisibleLinkIndex = 0
      Links = <
        item
          Item = navDashboard
        end
        item
          Item = navLetti
        end
        item
          Item = navMacroParti
        end
        item
          Item = navMagazzino
        end
        item
          Item = navAcquisti
        end
        item
          Item = navProduzione
        end>
    end
    object navDashboard: TdxNavBarItem
      Caption = 'Dashboard'
    end
    object navLetti: TdxNavBarItem
      Caption = 'Catalogo letti'
      OnClick = navLettiClick
    end
    object navMacroParti: TdxNavBarItem
      Caption = 'Macro-parti'
      OnClick = navMacroPartiClick
    end
    object navMagazzino: TdxNavBarItem
      Caption = 'Magazzino'
    end
    object navAcquisti: TdxNavBarItem
      Caption = 'Acquisti'
    end
    object navProduzione: TdxNavBarItem
      Caption = 'Produzione'
    end
  end
  object pnlContent: TPanel
    Left = 230
    Top = 0
    Width = 394
    Height = 441
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object dxSkinController1: TdxSkinController
    SkinName = 'WXICompact'
    Left = 368
    Top = 144
  end
end
