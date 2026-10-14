unit Frames.MacroParti;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Graphics, Vcl.Dialogs,
  dxLayoutControl, dxLayoutContainer,
  cxClasses, cxControls, cxLabel, cxButtons, cxTextEdit, cxGroupBox,
  cxGrid, cxGridLevel, cxGridCustomView, cxGridTableView,
  cxGridDBTableView, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.Menus, cxStyles, dxLayoutcxEditAdapters,
  Vcl.StdCtrls, Data.DB, Data.model, System.IOUtils;

type
  TfraMacroParti = class(TFrame)
    lcMain: TdxLayoutControl;
    cardHeader: TcxGroupBox;
    lblTitolo: TcxLabel;
    lblSottotitolo: TcxLabel;
    btnNuovo: TcxButton;
    btnElimina: TcxButton;
    btnAggiorna: TcxButton;
    cardRicerca: TcxGroupBox;
    edtRicerca: TcxTextEdit;
    btnFiltri: TcxButton;
    cardElenco: TcxGroupBox;
    lblElenco: TcxLabel;
    lblTotale: TcxLabel;
    grdMacroParti: TcxGrid;
    lvMacroParti: TcxGridLevel;
    lgRoot: TdxLayoutGroup;
    liHeader: TdxLayoutItem;
    liRicerca: TdxLayoutItem;
    liElenco: TdxLayoutItem;
    procedure btnNuovoClick(Sender: TObject);
    procedure btnEliminaClick(Sender: TObject);
    procedure btnAggiornaClick(Sender: TObject);
    procedure btnFiltriClick(Sender: TObject);
  private
    FBtnComposizione: TcxButton;
    FTableView: TcxGridDBTableView;
    FHeaderStyle: TcxStyle;
    FSelectionStyle: TcxStyle;
    FFiltroAttivo: Boolean;
    FTestoFiltro: string;
    procedure ApriComposizione(Sender: TObject);
    procedure ApplicaFiltro;
    procedure MacroPartiFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure RicercaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AggiornaTotale;
    procedure CaricaIcone;
    procedure CaricaIcona(Pulsante: TcxButton; const NomeFile: string);
    procedure ConfiguraAspetto;
    procedure ConfiguraGriglia;
    procedure ModificaMacroParte(Sender: TObject);
    procedure CaricaMacroParti;
    procedure MostraDialogoMacroParte(AMacroParte: TMacroParte);
    function TrovaScorta(
  AMacroParte: TMacroParte): TScorta;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Forms.DataModule, Forms.ComposizioneMacroParte, Generics.Collections;

{$R *.dfm}

constructor TfraMacroParti.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFiltroAttivo := False;
  FTestoFiltro := '';
  ConfiguraAspetto;
  ConfiguraGriglia;
  FTableView.OnDblClick := ModificaMacroParte;
  // Il dataset appartiene al DataModule e puo' essere ancora attivo
  // quando si torna a questa pagina: non reimpostare Manager qui.
  DM.dsMacroParti.OnFilterRecord := MacroPartiFilterRecord;
  edtRicerca.OnKeyDown := RicercaKeyDown;
  btnFiltri.Caption := 'Filtra';
  btnElimina.Caption := 'Elimina';
  FBtnComposizione := TcxButton.Create(Self);
  FBtnComposizione.Parent := cardHeader;
  FBtnComposizione.SetBounds(495, 43, 135, 43);
  FBtnComposizione.Anchors := [akTop, akRight];
  FBtnComposizione.Caption := 'Composizione';
  FBtnComposizione.LookAndFeel.NativeStyle := False;
  FBtnComposizione.LookAndFeel.SkinName := '';
  FBtnComposizione.LookAndFeel.Kind := lfFlat;
  FBtnComposizione.Colors.Default := $009A671E;
  FBtnComposizione.Colors.Normal := $009A671E;
  FBtnComposizione.Font.Color := clWhite;
  FBtnComposizione.Font.Style := [fsBold];
  FBtnComposizione.ParentFont := False;
  FBtnComposizione.OnClick := ApriComposizione;
  CaricaIcone;
  CaricaMacroParti;
end;

procedure TfraMacroParti.ConfiguraAspetto;
begin
  Color := $00F7F7F7;
  cardHeader.Style.Color := clWhite;
  cardRicerca.Style.Color := clWhite;
  cardElenco.Style.Color := clWhite;

  btnNuovo.LookAndFeel.NativeStyle := False;
  btnNuovo.LookAndFeel.SkinName := '';
  btnNuovo.LookAndFeel.Kind := lfFlat;
  btnNuovo.Colors.Default := $00B36517;
  btnNuovo.Colors.Normal := $00B36517;
  btnNuovo.Font.Color := clWhite;
  btnNuovo.Font.Style := [fsBold];
  btnNuovo.ParentFont := False;

  btnElimina.LookAndFeel.NativeStyle := False;
  btnElimina.LookAndFeel.SkinName := '';
  btnElimina.LookAndFeel.Kind := lfFlat;
  btnElimina.Colors.Default := $004545C6;
  btnElimina.Colors.Normal := $004545C6;
  btnElimina.Font.Color := clWhite;
  btnElimina.Font.Style := [fsBold];
  btnElimina.ParentFont := False;

  btnAggiorna.LookAndFeel.NativeStyle := False;
  btnAggiorna.LookAndFeel.SkinName := '';
  btnAggiorna.LookAndFeel.Kind := lfFlat;
  btnFiltri.LookAndFeel.NativeStyle := False;
  btnFiltri.LookAndFeel.SkinName := '';
  btnFiltri.LookAndFeel.Kind := lfFlat;

  edtRicerca.Properties.Nullstring := 'Cerca codice o descrizione...';
  Font.Name := 'Segoe UI';
  Font.Size := 10;
  lblTitolo.Style.Font.Name := 'Segoe UI';
  lblTitolo.Style.Font.Size := 21;
  lblTitolo.Style.Font.Style := [fsBold];
  lblTitolo.Style.Font.Color := $00332211;
  lblSottotitolo.Style.Font.Name := 'Segoe UI';
  lblSottotitolo.Style.Font.Size := 11;
  lblSottotitolo.Style.Font.Color := $00756859;
  lblElenco.Style.Font.Name := 'Segoe UI';
  lblElenco.Style.Font.Size := 14;
  lblElenco.Style.Font.Style := [fsBold];
  lblElenco.Style.Font.Color := $00332211;
  lblTotale.Style.Font.Name := 'Segoe UI';
  lblTotale.Style.Font.Size := 10;
  lblTotale.Style.Font.Color := $00756859;
end;

procedure TfraMacroParti.ConfiguraGriglia;
begin
  FTableView := grdMacroParti.CreateView(TcxGridDBTableView) as TcxGridDBTableView;
  lvMacroParti.GridView := FTableView;
  FTableView.DataController.DataSource := DM.srcMacroParti;

  with FTableView.CreateColumn do
  begin
    Caption := 'Codice';
    DataBinding.FieldName := 'Codice';
    Width := 160;
  end;
  with FTableView.CreateColumn do
  begin
    Caption := 'Descrizione';
    DataBinding.FieldName := 'Descrizione';
    Width := 500;
  end;

  FHeaderStyle := TcxStyle.Create(Self);
  FHeaderStyle.Color := $00F9F5F2;
  FHeaderStyle.TextColor := $003E2817;
  FHeaderStyle.Font.Name := 'Segoe UI';
  FHeaderStyle.Font.Style := [fsBold];
  FTableView.Styles.Header := FHeaderStyle;

  FSelectionStyle := TcxStyle.Create(Self);
  FSelectionStyle.Color := $00F8EBDD;
  FSelectionStyle.TextColor := $003E2817;
  FTableView.Styles.Selection := FSelectionStyle;

  FTableView.OptionsView.GroupByBox := False;
  FTableView.OptionsView.ColumnAutoWidth := True;
  FTableView.OptionsView.Header := True;
  FTableView.OptionsView.Indicator := False;
  FTableView.OptionsView.GridLines := glVertical;
  FTableView.OptionsData.Editing := False;
end;

procedure TfraMacroParti.AggiornaTotale;
begin
  if not DM.dsMacroParti.Active then Exit;
  DM.dsMacroParti.DisableControls;
  try
    DM.dsMacroParti.Last; // completa il fetch prima del conteggio
    if FFiltroAttivo and (FTestoFiltro <> '') then
      lblTotale.Caption := Format('Trovati: %d articoli', [DM.dsMacroParti.RecordCount])
    else
      lblTotale.Caption := Format('Totale: %d articoli', [DM.dsMacroParti.RecordCount]);
    DM.dsMacroParti.First;
  finally
    DM.dsMacroParti.EnableControls;
  end;
end;

procedure TfraMacroParti.MacroPartiFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  Codice, Descrizione: string;
begin
  if not FFiltroAttivo or (FTestoFiltro = '') then
  begin
    Accept := True;
    Exit;
  end;
  Codice := UpperCase(DataSet.FieldByName('Codice').AsString);
  Descrizione := UpperCase(DataSet.FieldByName('Descrizione').AsString);
  Accept := (Pos(FTestoFiltro, Codice) > 0) or
            (Pos(FTestoFiltro, Descrizione) > 0);
end;

procedure TfraMacroParti.ApplicaFiltro;
begin
  FTestoFiltro := UpperCase(Trim(edtRicerca.Text));
  FFiltroAttivo := FTestoFiltro <> '';
  DM.dsMacroParti.Filtered := False;
  if FFiltroAttivo then
    DM.dsMacroParti.Filtered := True;
  if FFiltroAttivo then
    btnFiltri.Caption := 'Rimuovi filtro'
  else
    btnFiltri.Caption := 'Filtra';
  AggiornaTotale;
end;

procedure TfraMacroParti.RicercaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    Key := 0;
    ApplicaFiltro;
  end;
end;

function TfraMacroParti.TrovaScorta(
  AMacroParte: TMacroParte): TScorta;
var
  Scorta: TScorta;
  Scorte: TList<TScorta>;
begin
  Result := nil;

  Scorte := DM.ObjMgr.Find<TScorta>.List;
  try
    for Scorta in Scorte do
      if Scorta.IdMacroParte.Id = AMacroParte.Id then
      begin
        Result := Scorta;
        Break;
      end;
  finally
    Scorte.Free;
  end;
end;

procedure TfraMacroParti.CaricaIcona(Pulsante: TcxButton;
  const NomeFile: string);
var
  Percorso: string;
begin
  // Le SVG vengono lette direttamente da OptionsImage.Glyph di DevExpress.
  Percorso := TPath.Combine(ExtractFilePath(ParamStr(0)),
    TPath.Combine('Icons', NomeFile));
  if not FileExists(Percorso) then Exit;
  try
    Pulsante.OptionsImage.Glyph.LoadFromFile(Percorso);
  except
    // L'assenza di supporto SVG non deve impedire l'apertura del frame.
    Pulsante.OptionsImage.Glyph.Assign(nil);
  end;
end;

procedure TfraMacroParti.CaricaIcone;
begin
  CaricaIcona(btnNuovo, 'nuovo.svg');
  CaricaIcona(btnElimina, 'elimina.svg');
  CaricaIcona(btnFiltri, 'filtro.svg');
  CaricaIcona(btnAggiorna, 'aggiorna.svg');
  CaricaIcona(FBtnComposizione, 'composizione.svg');
end;

procedure TfraMacroParti.CaricaMacroParti;
begin
  DM.dsMacroParti.Close;
  DM.dsMacroParti.Filtered := False;
  DM.dsMacroParti.SetSourceCriteria(DM.ObjMgr.Find<TMacroParte>);
  DM.dsMacroParti.Open;
  DM.dsMacroParti.Last;
  if FFiltroAttivo then
    DM.dsMacroParti.Filtered := True;
  AggiornaTotale;
end;

procedure TfraMacroParti.MostraDialogoMacroParte(AMacroParte: TMacroParte);
var
  Dlg: TForm;
  LCodice, LDescrizione, LScorta: TcxLabel;
  ECodice, EDescrizione, EScorta: TcxTextEdit;
  BSalva, BAnnulla: TcxButton;
  Codice, Descrizione: string;
  Nuova: Boolean;
  Obj: TMacroParte;
  Scorta: TScorta;
  Minimo, MinimoOriginale: Integer;
  ModificataAnagrafica: Boolean;
begin
  Nuova := AMacroParte = nil;
  Scorta := nil; // Fondamentale: per Nuovo non esiste ancora alcuna scorta.
  MinimoOriginale := 0;
  // Recupera la scorta direttamente dal manager, non dalla lista lazy.
  if not Nuova then
  begin
    Scorta := TrovaScorta(AMacroParte);
    if Assigned(Scorta) then
      MinimoOriginale := Scorta.ScortaMinima;
  end;

  Dlg := TForm.CreateNew(Self);
  try
    Dlg.BorderStyle := bsDialog;
    Dlg.Position := poMainFormCenter;
    Dlg.ClientWidth := 540;
    Dlg.ClientHeight := 300;
    Dlg.Font.Name := 'Segoe UI';
    Dlg.Font.Size := 10;
    Dlg.Color := clWhite;
    if Nuova then
      Dlg.Caption := 'Nuova macro-parte'
    else
      Dlg.Caption := 'Modifica macro-parte';

    LCodice := TcxLabel.Create(Dlg);
    LCodice.Parent := Dlg;
    LCodice.SetBounds(24, 20, 160, 25);
    LCodice.Caption := 'Codice';

    ECodice := TcxTextEdit.Create(Dlg);
    ECodice.Parent := Dlg;
    ECodice.SetBounds(24, 46, 210, 30);
    ECodice.Properties.MaxLength := 10;

    LDescrizione := TcxLabel.Create(Dlg);
    LDescrizione.Parent := Dlg;
    LDescrizione.SetBounds(24, 91, 200, 25);
    LDescrizione.Caption := 'Descrizione';

    EDescrizione := TcxTextEdit.Create(Dlg);
    EDescrizione.Parent := Dlg;
    EDescrizione.SetBounds(24, 118, 490, 30);
    EDescrizione.Properties.MaxLength := 80;

    LScorta := TcxLabel.Create(Dlg);
    LScorta.Parent := Dlg;
    LScorta.SetBounds(24, 163, 300, 25);
    LScorta.Caption := 'Scorta minima (0 = Just in Time)';

    EScorta := TcxTextEdit.Create(Dlg);
    EScorta.Parent := Dlg;
    EScorta.SetBounds(24, 190, 145, 30);
    EScorta.Properties.MaxLength := 9;
    EScorta.Text := IntToStr(MinimoOriginale);

    BSalva := TcxButton.Create(Dlg);
    BSalva.Parent := Dlg;
    BSalva.SetBounds(254, 241, 125, 37);
    BSalva.Caption := 'Salva';
    BSalva.ModalResult := mrOk;
    BSalva.Default := True;
    BSalva.LookAndFeel.NativeStyle := False;
    BSalva.LookAndFeel.SkinName := '';
    BSalva.LookAndFeel.Kind := lfFlat;
    BSalva.Colors.Default := $00539622;
    BSalva.Colors.Normal := $00539622;
    BSalva.ParentFont := False;
    BSalva.Font.Color := clWhite;
    BSalva.Font.Style := [fsBold];

    BAnnulla := TcxButton.Create(Dlg);
    BAnnulla.Parent := Dlg;
    BAnnulla.SetBounds(389, 241, 125, 37);
    BAnnulla.Caption := 'Annulla';
    BAnnulla.ModalResult := mrCancel;
    BAnnulla.Cancel := True;

    if not Nuova then
    begin
      ECodice.Text := AMacroParte.Codice;
      EDescrizione.Text := AMacroParte.Descrizione;
    end;
    Dlg.ActiveControl := ECodice;

    while Dlg.ShowModal = mrOk do
    begin
      Codice := Trim(ECodice.Text);
      Descrizione := Trim(EDescrizione.Text);
      if (Codice = '') or (Descrizione = '') then
      begin
        MessageDlg('Codice e Descrizione sono obbligatori.', mtWarning, [mbOK], 0);
        Continue;
      end;
      if not TryStrToInt(Trim(EScorta.Text), Minimo) or (Minimo < 0) then
      begin
        MessageDlg('La scorta minima deve essere un intero maggiore o uguale a zero.',
          mtWarning, [mbOK], 0);
        Continue;
      end;

      ModificataAnagrafica := Nuova or
        (Codice <> AMacroParte.Codice) or
        (Descrizione <> AMacroParte.Descrizione);
      if not ModificataAnagrafica and (Minimo = MinimoOriginale) then
        Exit;

      Obj := AMacroParte;
      if Nuova then
      begin
        Obj := TMacroParte.Create;
        Obj.Codice := Codice;
        Obj.Descrizione := Descrizione;
        try
          DM.ObjMgr.Save(Obj);
        except
          Obj.Free;
          raise;
        end;
      end
      else if ModificataAnagrafica then
      begin
        Obj.Codice := Codice;
        Obj.Descrizione := Descrizione;
        DM.ObjMgr.Update(Obj);
      end;

      // Minimo e' gia' stato validato prima di salvare l'anagrafica.
      // Riutilizza la scorta trovata in apertura della finestra.
      if Scorta = nil then
      begin
        // Una macro-parte JIT non richiede una riga Scorte.
        if Minimo > 0 then
        begin
          Scorta := TScorta.Create;
          Scorta.IdMacroParte := Obj;
          Scorta.ScortaMinima := Minimo;
          try
            DM.ObjMgr.Save(Scorta);
          except
            Scorta.Free;
            raise;
          end;
        end;
      end
      else
      begin
        if Scorta.ScortaMinima <> Minimo then
        begin
          Scorta.ScortaMinima := Minimo;
          DM.ObjMgr.Update(Scorta);
        end;
      end;
       DM.ObjMgr.Flush;
      CaricaMacroParti;
      if not FFiltroAttivo then
        DM.dsMacroParti.Locate('Codice', Codice, []);
      Exit;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfraMacroParti.ApriComposizione(Sender: TObject);
var
  Dlg: TfrmComposizioneMacroParte;
begin
  if DM.dsMacroParti.IsEmpty then
  begin
    MessageDlg('Seleziona una macro-parte.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Dlg := TfrmComposizioneMacroParte.CreatePerMacroParte(
    Self, DM.dsMacroParti.Current<TMacroParte>);
  try
    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

procedure TfraMacroParti.btnNuovoClick(Sender: TObject);
begin
  try
    MostraDialogoMacroParte(nil);
  except
    on E: Exception do
      MessageDlg('Errore durante il salvataggio: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfraMacroParti.ModificaMacroParte(Sender: TObject);
begin
  if not DM.dsMacroParti.IsEmpty then
    try
      MostraDialogoMacroParte(DM.dsMacroParti.Current<TMacroParte>);
    except
      on E: Exception do
        MessageDlg('Errore durante il salvataggio: ' + E.Message, mtError, [mbOK], 0);
    end;
end;

procedure TfraMacroParti.btnEliminaClick(Sender: TObject);
var
  Obj: TMacroParte;
  IdMacroParte: Int64;
  Codice: string;
  Letti: TList<TMacroParteLetto>;
  Ordini: TList<TRigaOrdineFornitore>;
  Movimenti: TList<TMovimentoMagazzino>;
  ParteLetto: TMacroParteLetto;
  RigaOrdine: TRigaOrdineFornitore;
  Movimento: TMovimentoMagazzino;
  Utilizzata: Boolean;
begin
  if DM.dsMacroParti.IsEmpty then
    Exit;

  Obj := DM.dsMacroParti.Current<TMacroParte>;
  if Obj = nil then
    Exit;

  IdMacroParte := Obj.Id;
  Codice := Obj.Codice;

  try
    Utilizzata := False;

    // Blocca la cancellazione se la macro-parte appartiene a un letto.
    Letti := DM.ObjMgr.Find<TMacroParteLetto>.List;
    try
      for ParteLetto in Letti do
        if (ParteLetto.IdMacroParte <> nil) and
           (ParteLetto.IdMacroParte.Id = IdMacroParte) then
        begin
          Utilizzata := True;
          Break;
        end;
    finally
      Letti.Free;
    end;

    // Blocca la cancellazione se compare in righe d'ordine.
    if not Utilizzata then
    begin
      Ordini := DM.ObjMgr.Find<TRigaOrdineFornitore>.List;
      try
        for RigaOrdine in Ordini do
          if (RigaOrdine.IdMacroParte <> nil) and
             (RigaOrdine.IdMacroParte.Id = IdMacroParte) then
          begin
            Utilizzata := True;
            Break;
          end;
      finally
        Ordini.Free;
      end;
    end;

    // Blocca la cancellazione in presenza di movimenti di magazzino.
    if not Utilizzata then
    begin
      Movimenti := DM.ObjMgr.Find<TMovimentoMagazzino>.List;
      try
        for Movimento in Movimenti do
          if (Movimento.IdMacroParte <> nil) and
             (Movimento.IdMacroParte.Id = IdMacroParte) then
          begin
            Utilizzata := True;
            Break;
          end;
      finally
        Movimenti.Free;
      end;
    end;

    if Utilizzata then
    begin
      MessageDlg('Impossibile eliminare la macro-parte ' + Codice +
        ': e'' utilizzata in letti, ordini o movimenti.',
        mtWarning, [mbOK], 0);
      Exit;
    end;

    if MessageDlg('Eliminare definitivamente la macro-parte ' + Codice +
      ', la relativa distinta componenti e la scorta minima?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

    // Le associazioni ComponentiMacroParteList e ScorteList
    // hanno TCascadeType.Remove nel mapping Aurelius.
    // Non rimuovere manualmente le entita' figlie.
    DM.ObjMgr.Remove(Obj);
    DM.ObjMgr.Flush;
    CaricaMacroParti;
  except
    on E: Exception do
      MessageDlg('Impossibile eliminare la macro-parte: ' + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TfraMacroParti.btnAggiornaClick(Sender: TObject);
begin
  CaricaMacroParti;
end;

procedure TfraMacroParti.btnFiltriClick(Sender: TObject);
begin
  if FFiltroAttivo then
  begin
    edtRicerca.Text := '';
    ApplicaFiltro;
  end
  else
    ApplicaFiltro;
end;

end.
