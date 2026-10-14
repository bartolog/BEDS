unit Frames.Letti;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.UITypes, System.Variants,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Dialogs,
  Data.model, cxGrid, cxGridLevel, cxGridCustomView, cxGridTableView,
  cxButtons, cxControls;

type
  TfraLetti = class(TFrame)
  private
    FLetti: TList<TLetto>;
    FGrid: TcxGrid;
    FView: TcxGridTableView;
    FRicerca: TEdit;
    procedure Carica;
    procedure Filtra(Sender: TObject);
    procedure Nuovo(Sender: TObject);
    procedure Modifica(Sender: TObject);
    procedure Elimina(Sender: TObject);
    procedure Aggiorna(Sender: TObject);
    procedure DoppioClick(Sender: TObject);
    function Selezionato: TLetto;
    function DialogoLetto(ALetto: TLetto): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Forms.DataModule;

constructor TfraLetti.Create(AOwner: TComponent);
var
  Barra: TPanel;
  B: TcxButton;
  Livello: TcxGridLevel;
  procedure Pulsante(const Titolo: string; X: Integer; Evento: TNotifyEvent);
  begin
    B := TcxButton.Create(Self);
    B.Parent := Barra;
    B.SetBounds(X, 12, 130, 34);
    B.Caption := Titolo;
    B.OnClick := Evento;
  end;
begin
  inherited;
  FLetti := TList<TLetto>.Create;
  Align := alClient;
  Barra := TPanel.Create(Self);
  Barra.Parent := Self;
  Barra.Align := alTop;
  Barra.Height := 62;
  Barra.BevelOuter := bvNone;
  Pulsante('Nuovo', 12, Nuovo);
  Pulsante('Modifica', 150, Modifica);
  Pulsante('Elimina', 288, Elimina);
  Pulsante('Aggiorna', 426, Aggiorna);

  FRicerca := TEdit.Create(Self);
  FRicerca.Parent := Barra;
  FRicerca.SetBounds(575, 16, 300, 27);
  FRicerca.Anchors := [akLeft, akTop, akRight];
  FRicerca.TextHint := 'Cerca codice, descrizione o modello';
  FRicerca.OnChange := Filtra;

  FGrid := TcxGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FView := FGrid.CreateView(TcxGridTableView) as TcxGridTableView;
  Livello := FGrid.Levels.Add;
  Livello.GridView := FView;
  FView.OptionsView.GroupByBox := False;
  FView.OptionsView.ColumnAutoWidth := True;
  FView.OptionsData.Editing := False;
  FView.OptionsData.Deleting := False;
  FView.OptionsData.Inserting := False;
  FView.OnDblClick := DoppioClick;
  with FView.CreateColumn do begin Caption := 'Codice'; Width := 150; end;
  with FView.CreateColumn do begin Caption := 'Descrizione'; Width := 450; end;
  with FView.CreateColumn do begin Caption := 'Modello'; Width := 220; end;
  Carica;
end;

destructor TfraLetti.Destroy;
begin
  FLetti.Free;
  inherited;
end;

procedure TfraLetti.Carica;
var
  Risultati: TList<TLetto>;
  L: TLetto;
begin
  FLetti.Clear;
  Risultati := DM.ObjMgr.Find<TLetto>.List;
  try
    for L in Risultati do
      FLetti.Add(L);
  finally
    Risultati.Free;
  end;
  Filtra(nil);
end;

procedure TfraLetti.Filtra(Sender: TObject);
var
  I, Riga: Integer;
  S: string;
  L: TLetto;
begin
  S := UpperCase(Trim(FRicerca.Text));
  FView.DataController.BeginUpdate;
  try
    FView.DataController.RecordCount := 0;
    Riga := 0;
    for I := 0 to FLetti.Count - 1 do
    begin
      L := FLetti[I];
      if (S <> '') and
        (Pos(S, UpperCase(string(L.Codice))) = 0) and
        (Pos(S, UpperCase(string(L.Descrizione))) = 0) and
        (Pos(S, UpperCase(string(L.Modello))) = 0) then
        Continue;
      FView.DataController.RecordCount := Riga + 1;
      FView.DataController.Values[Riga, 0] := string(L.Codice);
      FView.DataController.Values[Riga, 1] := string(L.Descrizione);
      FView.DataController.Values[Riga, 2] := string(L.Modello);
      FView.DataController.Values[Riga, 0] := string(L.Codice);
      Inc(Riga);
    end;
  finally
    FView.DataController.EndUpdate;
  end;
end;

function TfraLetti.Selezionato: TLetto;
var
  I: Integer;
  S: string;
  L: TLetto;
begin
  Result := nil;
  I := FView.DataController.FocusedRecordIndex;
  if (I < 0) or (I >= FView.DataController.RecordCount) then Exit;
  S := VarToStr(FView.DataController.Values[I, 0]);
  for L in FLetti do
    if SameText(string(L.Codice), S) then
      Exit(L);
end;

function TfraLetti.DialogoLetto(ALetto: TLetto): Boolean;
var
  D: TForm;
  ECodice, EDescrizione, EModello: TEdit;
  B: TButton;
  L: TLabel;
  Codice, Descrizione, Modello: string;
  Esistente: TLetto;
begin
  Result := False;
  D := TForm.CreateNew(Self);
  try
    D.Caption := 'Anagrafica letto';
    D.BorderStyle := bsDialog;
    D.Position := poMainFormCenter;
    D.ClientWidth := 520;
    D.ClientHeight := 255;
    D.Font.Name := 'Segoe UI';
    D.Font.Size := 10;
    L := TLabel.Create(D); L.Parent := D;
    L.SetBounds(20, 12, 200, 20); L.Caption := 'Codice';
    ECodice := TEdit.Create(D); ECodice.Parent := D;
    ECodice.SetBounds(20, 34, 220, 26); ECodice.MaxLength := 10;
    L := TLabel.Create(D); L.Parent := D;
    L.SetBounds(20, 70, 200, 20); L.Caption := 'Descrizione';
    EDescrizione := TEdit.Create(D); EDescrizione.Parent := D;
    EDescrizione.SetBounds(20, 92, 475, 26); EDescrizione.MaxLength := 50;
    L := TLabel.Create(D); L.Parent := D;
    L.SetBounds(20, 128, 200, 20); L.Caption := 'Modello';
    EModello := TEdit.Create(D); EModello.Parent := D;
    EModello.SetBounds(20, 150, 300, 26); EModello.MaxLength := 25;
    B := TButton.Create(D); B.Parent := D;
    B.SetBounds(240, 200, 120, 32); B.Caption := 'Salva';
    B.ModalResult := mrOk; B.Default := True;
    B := TButton.Create(D); B.Parent := D;
    B.SetBounds(370, 200, 120, 32); B.Caption := 'Annulla';
    B.ModalResult := mrCancel; B.Cancel := True;
    if ALetto <> nil then
    begin
      ECodice.Text := string(ALetto.Codice);
      EDescrizione.Text := string(ALetto.Descrizione);
      EModello.Text := string(ALetto.Modello);
    end;
    while D.ShowModal = mrOk do
    begin
      Codice := Trim(ECodice.Text);
      Descrizione := Trim(EDescrizione.Text);
      Modello := Trim(EModello.Text);
      if (Codice = '') or (Descrizione = '') then
      begin
        MessageDlg('Codice e descrizione sono obbligatori.',
          mtWarning, [mbOK], 0);
        Continue;
      end;
      for Esistente in FLetti do
        if (Esistente <> ALetto) and SameText(string(Esistente.Codice), Codice) then
        begin
          MessageDlg('Codice gia presente.', mtWarning, [mbOK], 0);
          Codice := '';
          Break;
        end;
      if Codice = '' then Continue;
      if ALetto = nil then
      begin
        Esistente := TLetto.Create;
        Esistente.Codice := Codice;
        Esistente.Descrizione := Descrizione;
        Esistente.Modello := Modello;
        try
          DM.ObjMgr.Save(Esistente);
          DM.ObjMgr.Flush;
        except
          on E: Exception do
          begin
            MessageDlg(E.Message, mtError, [mbOK], 0);
            Continue;
          end;
        end;
      end
      else
      begin
        ALetto.Codice := Codice;
        ALetto.Descrizione := Descrizione;
        ALetto.Modello := Modello;
        try
          DM.ObjMgr.Update(ALetto);
          DM.ObjMgr.Flush;
        except
          on E: Exception do
          begin
            MessageDlg(E.Message, mtError, [mbOK], 0);
            Continue;
          end;
        end;
      end;
      Result := True;
      Break;
    end;
  finally
    D.Free;
  end;
end;

procedure TfraLetti.Nuovo(Sender: TObject);
begin
  if DialogoLetto(nil) then Carica;
end;

procedure TfraLetti.Modifica(Sender: TObject);
var L: TLetto;
begin
  L := Selezionato;
  if (L <> nil) and DialogoLetto(L) then Carica;
end;

procedure TfraLetti.Elimina(Sender: TObject);
var
  L: TLetto;
begin
  L := Selezionato;
  if L = nil then Exit;
  if L.MacroPartiLettoList.Count > 0 then
  begin
    MessageDlg('Il letto contiene macro-parti: eliminazione non consentita.',
      mtWarning, [mbOK], 0);
    Exit;
  end;
  if MessageDlg('Eliminare il letto selezionato?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  try
    DM.ObjMgr.Remove(L);
    DM.ObjMgr.Flush;
    Carica;
  except
    on E: Exception do
      MessageDlg('Errore eliminazione: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfraLetti.Aggiorna(Sender: TObject);
begin
  Carica;
end;

procedure TfraLetti.DoppioClick(Sender: TObject);
begin
  Modifica(Sender);
end;

end.
