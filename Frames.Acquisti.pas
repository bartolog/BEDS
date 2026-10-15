unit Frames.Acquisti;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.DateUtils, System.Variants, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Graphics,
  cxGrid, cxGridLevel, cxGridCustomView, cxGridTableView, cxStyles,
  Data.model;

type
  TfraAcquisti = class(TFrame)
  private
    FOrdini: TList<TOrdineFornitore>;
    FFornitori: TList<TFornitore>;
    FPannelloOrdini, FPannelloFornitori: TPanel;
    FGridFornitori: TcxGrid;
    FViewFornitori: TcxGridTableView;
    FRicercaFornitori: TEdit;
    FGrid: TcxGrid;
    FView: TcxGridTableView;
    procedure MostraOrdini(Sender: TObject);
    procedure MostraFornitori(Sender: TObject);
    procedure CaricaFornitori(Sender: TObject);
    procedure AggiornaFornitori;
    procedure CercaFornitori(Sender: TObject);
    procedure NuovoFornitore(Sender: TObject);
    procedure ModificaFornitore(Sender: TObject);
    procedure EliminaFornitore(Sender: TObject);
    function FornitoreSelezionato: TFornitore;
    function EditorFornitore(AFornitore: TFornitore): Boolean;
    procedure Carica(Sender: TObject);
    procedure NuovoOrdine(Sender: TObject);
    procedure AggiornaGriglia;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses Forms.DataModule;

constructor TfraAcquisti.Create(AOwner: TComponent);
var
  Barra, BarraFornitori, Schede: TPanel;
  B: TButton;
  L: TcxGridLevel;
  C: TcxGridColumn;
begin
  inherited;
  Align := alClient;
  FOrdini := TList<TOrdineFornitore>.Create;
  FFornitori := TList<TFornitore>.Create;
  Schede := TPanel.Create(Self);
  Schede.Parent := Self;
  Schede.Align := alTop;
  Schede.Height := 46;
  Schede.BevelOuter := bvNone;
  B := TButton.Create(Self);
  B.Parent := Schede; B.SetBounds(12, 7, 150, 32);
  B.Caption := 'Ordini fornitori'; B.OnClick := MostraOrdini;
  B := TButton.Create(Self);
  B.Parent := Schede; B.SetBounds(172, 7, 175, 32);
  B.Caption := 'Anagrafica fornitori'; B.OnClick := MostraFornitori;
  FPannelloOrdini := TPanel.Create(Self);
  FPannelloOrdini.Parent := Self;
  FPannelloOrdini.Align := alClient;
  FPannelloOrdini.BevelOuter := bvNone;
  FPannelloFornitori := TPanel.Create(Self);
  FPannelloFornitori.Parent := Self;
  FPannelloFornitori.Align := alClient;
  FPannelloFornitori.BevelOuter := bvNone;
  Barra := TPanel.Create(Self);
  Barra.Parent := FPannelloOrdini;
  Barra.Align := alTop;
  Barra.Height := 58;
  Barra.BevelOuter := bvNone;
  Barra.Color := clWhite;
  B := TButton.Create(Self);
  B.Parent := Barra;
  B.SetBounds(12, 12, 145, 34);
  B.Caption := 'Nuovo ordine';
  B.OnClick := NuovoOrdine;
  B := TButton.Create(Self);
  B.Parent := Barra;
  B.SetBounds(169, 12, 120, 34);
  B.Caption := 'Aggiorna';
  B.OnClick := Carica;
  FGrid := TcxGrid.Create(Self);
  FGrid.Parent := FPannelloOrdini;
  FGrid.Align := alClient;
  FView := FGrid.CreateView(TcxGridTableView) as TcxGridTableView;
  L := FGrid.Levels.Add;
  L.GridView := FView;
  FView.OptionsView.GroupByBox := False;
  FView.OptionsView.ColumnAutoWidth := True;
  FView.OptionsData.Editing := False;
  FView.OptionsData.Deleting := False;
  FView.OptionsData.Inserting := False;
  C := FView.CreateColumn; C.Caption := 'Numero'; C.Width := 90;
  C := FView.CreateColumn; C.Caption := 'Anno'; C.Width := 70;
  C := FView.CreateColumn; C.Caption := 'Data ordine'; C.Width := 120;
  C := FView.CreateColumn; C.Caption := 'Fornitore'; C.Width := 290;
  C := FView.CreateColumn; C.Caption := 'Consegna prevista'; C.Width := 145;
  C := FView.CreateColumn; C.Caption := 'Stato'; C.Width := 160;
  BarraFornitori := TPanel.Create(Self);
  BarraFornitori.Parent := FPannelloFornitori;
  BarraFornitori.Align := alTop;
  BarraFornitori.Height := 58;
  BarraFornitori.BevelOuter := bvNone;
  BarraFornitori.Color := clWhite;
  B := TButton.Create(Self);
  B.Parent := BarraFornitori; B.SetBounds(12, 12, 105, 34);
  B.Caption := 'Nuovo'; B.OnClick := NuovoFornitore;
  B := TButton.Create(Self);
  B.Parent := BarraFornitori; B.SetBounds(127, 12, 105, 34);
  B.Caption := 'Modifica'; B.OnClick := ModificaFornitore;
  B := TButton.Create(Self);
  B.Parent := BarraFornitori; B.SetBounds(242, 12, 105, 34);
  B.Caption := 'Elimina'; B.OnClick := EliminaFornitore;
  B := TButton.Create(Self);
  B.Parent := BarraFornitori; B.SetBounds(357, 12, 105, 34);
  B.Caption := 'Aggiorna'; B.OnClick := CaricaFornitori;
  FRicercaFornitori := TEdit.Create(Self);
  FRicercaFornitori.Parent := BarraFornitori;
  FRicercaFornitori.SetBounds(480, 15, 230, 28);
  FRicercaFornitori.TextHint := 'Cerca codice o ragione sociale';
  FRicercaFornitori.OnChange := CercaFornitori;
  FGridFornitori := TcxGrid.Create(Self);
  FGridFornitori.Parent := FPannelloFornitori;
  FGridFornitori.Align := alClient;
  FViewFornitori := FGridFornitori.CreateView(TcxGridTableView) as TcxGridTableView;
  L := FGridFornitori.Levels.Add; L.GridView := FViewFornitori;
  FViewFornitori.OptionsView.GroupByBox := False;
  FViewFornitori.OptionsView.ColumnAutoWidth := True;
  FViewFornitori.OptionsData.Editing := False;
  FViewFornitori.OptionsData.Deleting := False;
  FViewFornitori.OptionsData.Inserting := False;
  with FViewFornitori.CreateColumn do begin Caption := 'ID'; Visible := False; end;
  with FViewFornitori.CreateColumn do begin Caption := 'Codice'; Width := 100; end;
  with FViewFornitori.CreateColumn do begin Caption := 'Ragione sociale'; Width := 280; end;
  with FViewFornitori.CreateColumn do begin Caption := 'Partita IVA'; Width := 120; end;
  with FViewFornitori.CreateColumn do begin Caption := 'Citta'; Width := 140; end;
  with FViewFornitori.CreateColumn do begin Caption := 'Telefono'; Width := 130; end;
  with FViewFornitori.CreateColumn do begin Caption := 'Email'; Width := 220; end;
  Carica(nil);
  CaricaFornitori(nil);
  MostraOrdini(nil);
end;

destructor TfraAcquisti.Destroy;
begin
  FFornitori.Free;
  FOrdini.Free;
  inherited;
end;

procedure TfraAcquisti.Carica(Sender: TObject);
var
  Lista: TList<TOrdineFornitore>;
  O: TOrdineFornitore;
begin
  FOrdini.Clear;
  Lista := DM.ObjMgr.Find<TOrdineFornitore>.List;
  try
    for O in Lista do
      FOrdini.Add(O);
  finally
    Lista.Free;
  end;
  AggiornaGriglia;
end;

procedure TfraAcquisti.AggiornaGriglia;
var
  I: Integer;
  O: TOrdineFornitore;
begin
  FView.DataController.BeginUpdate;
  try
    FView.DataController.RecordCount := FOrdini.Count;
    for I := 0 to FOrdini.Count - 1 do
    begin
      O := FOrdini[I];
      FView.DataController.Values[I, 0] := O.Numero;
      FView.DataController.Values[I, 1] := O.Anno;
      FView.DataController.Values[I, 2] := FormatDateTime('dd/mm/yyyy', O.DataOrdine);
      if Assigned(O.IdFornitore) then
        FView.DataController.Values[I, 3] := O.IdFornitore.RagioneSociale
      else
        FView.DataController.Values[I, 3] := '';
      if O.DataConsegnaPrevista.HasValue then
        FView.DataController.Values[I, 4] :=
          FormatDateTime('dd/mm/yyyy', TDateTime(O.DataConsegnaPrevista))
      else
        FView.DataController.Values[I, 4] := '';
      FView.DataController.Values[I, 5] := O.Stato;
    end;
  finally
    FView.DataController.EndUpdate;
  end;
end;

procedure TfraAcquisti.NuovoOrdine(Sender: TObject);
var
  Fornitori: TList<TFornitore>;
  F: TForm;
  Combo: TComboBox;
  Conferma: TButton;
  Annulla: TButton;
  Etichetta: TLabel;
  Fornitore: TFornitore;
  O, Esistente: TOrdineFornitore;
  Anno, Numero, I: Integer;
begin
  Fornitori := DM.ObjMgr.Find<TFornitore>.List;
  try
    if Fornitori.Count = 0 then
    begin
      MessageDlg('Nessun fornitore presente in anagrafica.', mtInformation, [mbOK], 0);
      Exit;
    end;
    F := TForm.CreateNew(Self);
    try
      F.Caption := 'Nuovo ordine fornitore';
      F.Position := poMainFormCenter;
      F.BorderStyle := bsDialog;
      F.ClientWidth := 430;
      F.ClientHeight := 155;
      Etichetta := TLabel.Create(F);
      Etichetta.Parent := F;
      Etichetta.SetBounds(16, 18, 370, 20);
      Etichetta.Caption := 'Seleziona il fornitore';
      Combo := TComboBox.Create(F);
      Combo.Parent := F;
      Combo.SetBounds(16, 44, 395, 26);
      Combo.Style := csDropDownList;
      for Fornitore in Fornitori do
        Combo.Items.Add(Fornitore.Codice + ' - ' + Fornitore.RagioneSociale);
      Combo.ItemIndex := 0;
      Conferma := TButton.Create(F);
      Conferma.Parent := F;
      Conferma.SetBounds(220, 102, 90, 30);
      Conferma.Caption := 'Crea';
      Conferma.ModalResult := mrOk;
      Annulla := TButton.Create(F);
      Annulla.Parent := F;
      Annulla.SetBounds(321, 102, 90, 30);
      Annulla.Caption := 'Annulla';
      Annulla.ModalResult := mrCancel;
      if F.ShowModal <> mrOk then Exit;
      I := Combo.ItemIndex;
      if I < 0 then Exit;
      Fornitore := Fornitori[I];
      Anno := YearOf(Date);
      Numero := 1;
      for Esistente in FOrdini do
        if (Esistente.Anno = Anno) and (Esistente.Numero >= Numero) then
          Numero := Esistente.Numero + 1;
      O := TOrdineFornitore.Create;
      O.Numero := Numero;
      O.Anno := Anno;
      O.DataOrdine := Date;
      O.IdFornitore := Fornitore;
      O.Stato := 'APERTO';
      try
        DM.ObjMgr.Save(O);
        DM.ObjMgr.Flush;
        Carica(nil);
      except
        on E: Exception do
          MessageDlg('Errore creazione ordine: ' + E.Message,
            mtError, [mbOK], 0);
      end;
    finally
      F.Free;
    end;
  finally
    Fornitori.Free;
  end;
end;

procedure TfraAcquisti.MostraOrdini(Sender: TObject);
begin
  FPannelloFornitori.Visible := False;
  FPannelloOrdini.Visible := True;
  FPannelloOrdini.BringToFront;
end;

procedure TfraAcquisti.MostraFornitori(Sender: TObject);
begin
  FPannelloOrdini.Visible := False;
  FPannelloFornitori.Visible := True;
  FPannelloFornitori.BringToFront;
  CaricaFornitori(nil);
end;

procedure TfraAcquisti.CaricaFornitori(Sender: TObject);
var
  L: TList<TFornitore>;
  F: TFornitore;
begin
  FFornitori.Clear;
  L := DM.ObjMgr.Find<TFornitore>.List;
  try
    for F in L do FFornitori.Add(F);
  finally
    L.Free;
  end;
  AggiornaFornitori;
end;

procedure TfraAcquisti.CercaFornitori(Sender: TObject);
begin
  AggiornaFornitori;
end;

procedure TfraAcquisti.AggiornaFornitori;
var
  F: TFornitore;
  I: Integer;
  Q: string;
begin
  Q := UpperCase(Trim(FRicercaFornitori.Text));
  FViewFornitori.DataController.BeginUpdate;
  try
    FViewFornitori.DataController.RecordCount := 0;
    for F in FFornitori do
    begin
      if (Q <> '') and (Pos(Q, UpperCase(F.Codice)) = 0) and
         (Pos(Q, UpperCase(F.RagioneSociale)) = 0) then Continue;
      I := FViewFornitori.DataController.RecordCount;
      FViewFornitori.DataController.RecordCount := I + 1;
      FViewFornitori.DataController.Values[I, 0] := F.ID;
      FViewFornitori.DataController.Values[I, 1] := F.Codice;
      FViewFornitori.DataController.Values[I, 2] := F.RagioneSociale;
      if F.PartitaIVA.HasValue then
        FViewFornitori.DataController.Values[I, 3] := string(F.PartitaIVA)
      else FViewFornitori.DataController.Values[I, 3] := '';
      if F.Citta.HasValue then
        FViewFornitori.DataController.Values[I, 4] := string(F.Citta)
      else FViewFornitori.DataController.Values[I, 4] := '';
      if F.Telefono.HasValue then
        FViewFornitori.DataController.Values[I, 5] := string(F.Telefono)
      else FViewFornitori.DataController.Values[I, 5] := '';
      if F.Email.HasValue then
        FViewFornitori.DataController.Values[I, 6] := string(F.Email)
      else FViewFornitori.DataController.Values[I, 6] := '';
    end;
  finally
    FViewFornitori.DataController.EndUpdate;
  end;
end;

function TfraAcquisti.FornitoreSelezionato: TFornitore;
var
  I: Integer;
  ID: Int64;
  F: TFornitore;
begin
  Result := nil;
  I := FViewFornitori.DataController.FocusedRecordIndex;
  if (I < 0) or (I >= FViewFornitori.DataController.RecordCount) then Exit;
  ID := StrToInt64Def(VarToStr(FViewFornitori.DataController.Values[I, 0]), -1);
  for F in FFornitori do
    if F.ID = ID then Exit(F);
end;

function TfraAcquisti.EditorFornitore(AFornitore: TFornitore): Boolean;
const
  Nomi: array[0..6] of string = ('Codice', 'Ragione sociale', 'Partita IVA',
    'Indirizzo', 'Citta', 'Telefono', 'Email');
var
  F: TForm;
  E: array[0..6] of TEdit;
  I: Integer;
  L: TLabel;
  B: TButton;
  Esistente: TFornitore;
begin
  Result := False;
  F := TForm.CreateNew(Self);
  try
    F.Caption := 'Anagrafica fornitore';
    F.Position := poMainFormCenter;
    F.BorderStyle := bsDialog;
    F.ClientWidth := 540;
    F.ClientHeight := 385;
    for I := 0 to 6 do
    begin
      L := TLabel.Create(F); L.Parent := F;
      L.SetBounds(16, 18 + I * 43, 135, 20); L.Caption := Nomi[I];
      E[I] := TEdit.Create(F); E[I].Parent := F;
      E[I].SetBounds(160, 14 + I * 43, 355, 26);
    end;
    E[0].MaxLength := 10; E[1].MaxLength := 100;
    E[2].MaxLength := 11; E[3].MaxLength := 150;
    E[4].MaxLength := 60; E[5].MaxLength := 30;
    E[6].MaxLength := 100;
    if AFornitore <> nil then
    begin
      E[0].Text := AFornitore.Codice;
      E[1].Text := AFornitore.RagioneSociale;
      if AFornitore.PartitaIVA.HasValue then E[2].Text := string(AFornitore.PartitaIVA);
      if AFornitore.Indirizzo.HasValue then E[3].Text := string(AFornitore.Indirizzo);
      if AFornitore.Citta.HasValue then E[4].Text := string(AFornitore.Citta);
      if AFornitore.Telefono.HasValue then E[5].Text := string(AFornitore.Telefono);
      if AFornitore.Email.HasValue then E[6].Text := string(AFornitore.Email);
    end;
    B := TButton.Create(F); B.Parent := F;
    B.SetBounds(315, 329, 95, 32); B.Caption := 'Salva'; B.ModalResult := mrOk;
    B := TButton.Create(F); B.Parent := F;
    B.SetBounds(420, 329, 95, 32); B.Caption := 'Annulla'; B.ModalResult := mrCancel;
    while F.ShowModal = mrOk do
    begin
      if (Trim(E[0].Text) = '') or (Trim(E[1].Text) = '') then
      begin
        MessageDlg('Codice e ragione sociale sono obbligatori.', mtWarning, [mbOK], 0);
        Continue;
      end;
      Esistente := nil;
      for Esistente in FFornitori do
        if SameText(Esistente.Codice, Trim(E[0].Text)) and
           ((AFornitore = nil) or (Esistente.ID <> AFornitore.ID)) then
        begin
          MessageDlg('Codice fornitore gia presente.', mtWarning, [mbOK], 0);
          Break;
        end;
      if (Esistente <> nil) and SameText(Esistente.Codice, Trim(E[0].Text)) and
         ((AFornitore = nil) or (Esistente.ID <> AFornitore.ID)) then Continue;
      if AFornitore = nil then
      begin
        AFornitore := TFornitore.Create;
        AFornitore.Attivo := True;
        AFornitore.Codice := Trim(E[0].Text);
        AFornitore.RagioneSociale := Trim(E[1].Text);
        AFornitore.PartitaIVA := Trim(E[2].Text);
        AFornitore.Indirizzo := Trim(E[3].Text);
        AFornitore.Citta := Trim(E[4].Text);
        AFornitore.Telefono := Trim(E[5].Text);
        AFornitore.Email := Trim(E[6].Text);
        DM.ObjMgr.Save(AFornitore);
      end
      else
      begin
        AFornitore.Codice := Trim(E[0].Text);
        AFornitore.RagioneSociale := Trim(E[1].Text);
        AFornitore.PartitaIVA := Trim(E[2].Text);
        AFornitore.Indirizzo := Trim(E[3].Text);
        AFornitore.Citta := Trim(E[4].Text);
        AFornitore.Telefono := Trim(E[5].Text);
        AFornitore.Email := Trim(E[6].Text);
        DM.ObjMgr.Update(AFornitore);
      end;
      try
        DM.ObjMgr.Flush;
        Result := True;
      except
        on Ex: Exception do
          MessageDlg('Errore salvataggio: ' + Ex.Message, mtError, [mbOK], 0);
      end;
      Break;
    end;
  finally
    F.Free;
  end;
end;

procedure TfraAcquisti.NuovoFornitore(Sender: TObject);
begin
  if EditorFornitore(nil) then CaricaFornitori(nil);
end;

procedure TfraAcquisti.ModificaFornitore(Sender: TObject);
var
  F: TFornitore;
begin
  F := FornitoreSelezionato;
  if F = nil then Exit;
  if EditorFornitore(F) then CaricaFornitori(nil);
end;

procedure TfraAcquisti.EliminaFornitore(Sender: TObject);
var
  F: TFornitore;
  O: TOrdineFornitore;
begin
  F := FornitoreSelezionato;
  if F = nil then Exit;
  for O in FOrdini do
    if Assigned(O.IdFornitore) and (O.IdFornitore.ID = F.ID) then
    begin
      MessageDlg('Fornitore utilizzato in un ordine: eliminazione non consentita.',
        mtWarning, [mbOK], 0);
      Exit;
    end;
  if MessageDlg('Eliminare il fornitore ' + F.RagioneSociale + '?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  try
    FFornitori.Remove(F);
    DM.ObjMgr.Remove(F);
    DM.ObjMgr.Flush;
    CaricaFornitori(nil);
  except
    on E: Exception do
      MessageDlg('Impossibile eliminare il fornitore: ' + E.Message,
        mtError, [mbOK], 0);
  end;
end;

end.
