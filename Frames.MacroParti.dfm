object fraMacroParti: TfraMacroParti
  Left = 0
  Top = 0
  Width = 1100
  Height = 720
  Color = 16250871
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 1100
    Height = 720
    Align = alClient
    TabOrder = 0
    object cardHeader: TcxGroupBox
      Left = 13
      Top = 13
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        1074
        130)
      Height = 130
      Width = 1074
      object lblTitolo: TcxLabel
        Left = 22
        Top = 18
        Caption = 'Macro-parti'
        ParentFont = False
        TabOrder = 0
        Transparent = True
      end
      object lblSottotitolo: TcxLabel
        Left = 22
        Top = 68
        Caption = 'Anagrafica e gestione articoli'
        ParentFont = False
        TabOrder = 1
        Transparent = True
      end
      object btnNuovo: TcxButton
        Left = 644
        Top = 43
        Width = 122
        Height = 43
        Anchors = [akTop, akRight]
        Caption = 'Nuovo'
        TabOrder = 2
        OnClick = btnNuovoClick
        ExplicitLeft = 630
      end
      object btnElimina: TcxButton
        Left = 779
        Top = 43
        Width = 122
        Height = 43
        Anchors = [akTop, akRight]
        Caption = 'Elimina'
        TabOrder = 3
        OnClick = btnEliminaClick
        ExplicitLeft = 765
      end
      object btnAggiorna: TcxButton
        Left = 914
        Top = 43
        Width = 135
        Height = 43
        Anchors = [akTop, akRight]
        Caption = 'Aggiorna'
        TabOrder = 4
        OnClick = btnAggiornaClick
        ExplicitLeft = 900
      end
    end
    object cardRicerca: TcxGroupBox
      Left = 13
      Top = 152
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        1074
        74)
      Height = 74
      Width = 1074
      object edtRicerca: TcxTextEdit
        Left = 20
        Top = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Width = 804
      end
      object btnFiltri: TcxButton
        Left = 904
        Top = 16
        Width = 145
        Height = 40
        Anchors = [akTop, akRight]
        Caption = 'Filtri'
        TabOrder = 1
        OnClick = btnFiltriClick
        ExplicitLeft = 890
      end
    end
    object cardElenco: TcxGroupBox
      Left = 13
      Top = 235
      ParentBackground = False
      TabOrder = 2
      DesignSize = (
        1074
        472)
      Height = 472
      Width = 1074
      object lblElenco: TcxLabel
        Left = 22
        Top = 16
        Caption = 'Elenco macro-parti'
        ParentFont = False
        TabOrder = 0
        Transparent = True
      end
      object lblTotale: TcxLabel
        Left = 899
        Top = 21
        Anchors = [akTop, akRight]
        Caption = 'Totale: 0 articoli'
        ParentFont = False
        TabOrder = 1
        Transparent = True
      end
      object grdMacroParti: TcxGrid
        Left = 20
        Top = 62
        Width = 1034
        Height = 387
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        ExplicitWidth = 1020
        ExplicitHeight = 355
        object lvMacroParti: TcxGridLevel
        end
      end
    end
    object lgRoot: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object liHeader: TdxLayoutItem
      Parent = lgRoot
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = cardHeader
      ControlOptions.OriginalHeight = 130
      ControlOptions.OriginalWidth = 1060
      Index = 0
    end
    object liRicerca: TdxLayoutItem
      Parent = lgRoot
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = cardRicerca
      ControlOptions.OriginalHeight = 74
      ControlOptions.OriginalWidth = 1060
      Index = 1
    end
    object liElenco: TdxLayoutItem
      Parent = lgRoot
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cardElenco
      ControlOptions.OriginalHeight = 440
      ControlOptions.OriginalWidth = 1060
      Index = 2
    end
  end
end
