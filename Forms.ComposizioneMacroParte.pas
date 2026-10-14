unit Forms.ComposizioneMacroParte;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  Winapi.Windows,
  Data.model, cxGrid, cxGridLevel, cxGridCustomView, cxGridTableView,
  cxButtons, cxControls;

type
  TfrmComposizioneMacroParte = class(TForm)
  private
    FMacroParte: TMacroParte;
    FAssociazioni: TList<TComponenteMacroParte>;
    FComponenti: TList<TComponente>;
    FFiltrati: TList<TComponente>;
    FGrigliaDisponibili: TcxGrid;
    FViewDisponibili: TcxGridTableView;
    FGrigliaDistinta: TcxGrid;
    FViewDistinta: TcxGridTableView;
    FRicerca: TEdit;
    FQuantita: TEdit;
    FInfo: TLabel;
    FComponentiCaricati: Boolean;
    FDistintaCaricata: Boolean;
    procedure RicercaEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AggiornaGrigliaDistinta;
    procedure CaricaComponenti;
    procedure FiltraComponenti(Sender: TObject);
    procedure RicaricaDistinta;
    procedure Aggiungi(Sender: TObject);
    procedure Modifica(Sender: TObject);
    procedure Elimina(Sender: TObject);
    procedure Chiudi(Sender: TObject);
    procedure DoppioClickDisponibili(Sender: TObject);
    function ComponenteSelezionato: TComponente;
    function RigaSelezionata: TComponenteMacroParte;
    function QuantitaValida(out Q: Integer): Boolean;
  public
    constructor CreatePerMacroParte(AOwner: TComponent; AMacroParte: TMacroParte);
    destructor Destroy; override;
  end;

implementation

uses
  Forms.DataModule, Vcl.Graphics;

constructor TfrmComposizioneMacroParte.CreatePerMacroParte(
  AOwner: TComponent; AMacroParte: TMacroParte);
var
  PannelloSuperiore, PannelloRicerca, PannelloDistinta, Barra: TPanel;
  Etichetta: TLabel;
  Bottone: TcxButton;
  Livello: TcxGridLevel;
  procedure CreaBottone(const Titolo: string; X: Integer;
    Handler: TNotifyEvent);
  begin
    Bottone := TcxButton.Create(Self);
    Bottone.Parent := Barra;
    Bottone.SetBounds(X, 8, 130, 34);
    Bottone.Caption := Titolo;
    Bottone.OnClick := Handler;
  end;
begin
  inherited CreateNew(AOwner);
  FMacroParte := AMacroParte;
  FComponentiCaricati := False;
  FDistintaCaricata := False;
  KeyPreview := True;
  OnKeyDown := FormKeyDown;
  FAssociazioni := TList<TComponenteMacroParte>.Create;
  FComponenti := TList<TComponente>.Create;
  FFiltrati := TList<TComponente>.Create;
  Caption := 'Composizione macro-parte';
  Width := 1100;
  Height := 760;
  Position := poMainFormCenter;
  Font.Name := 'Segoe UI';
  Font.Size := 10;
  Color := clWhite;

  PannelloSuperiore := TPanel.Create(Self);
  PannelloSuperiore.Parent := Self;
  PannelloSuperiore.Align := alTop;
  PannelloSuperiore.Height := 82;
  PannelloSuperiore.BevelOuter := bvNone;
  PannelloSuperiore.Color := clWhite;

  FInfo := TLabel.Create(Self);
  FInfo.Parent := PannelloSuperiore;
  FInfo.SetBounds(18, 12, 1020, 28);
  FInfo.Font.Size := 14;
  FInfo.Font.Style := [fsBold];
  FInfo.Caption := string(FMacroParte.Codice) + ' - ' +
    string(FMacroParte.Descrizione);

  Etichetta := TLabel.Create(Self);
  Etichetta.Parent := PannelloSuperiore;
  Etichetta.SetBounds(18, 49, 900, 22);
  Etichetta.Caption :=
    'Seleziona un componente dall''elenco, indica la quantita e premi Aggiungi.';

  PannelloRicerca := TPanel.Create(Self);
  PannelloRicerca.Parent := Self;
  PannelloRicerca.Align := alTop;
  PannelloRicerca.Height := 315;
  PannelloRicerca.BevelOuter := bvNone;
  PannelloRicerca.Color := clWhite;

  Etichetta := TLabel.Create(Self);
  Etichetta.Parent := PannelloRicerca;
  Etichetta.SetBounds(18, 5, 700, 20);
  Etichetta.Caption := 'COMPONENTI DISPONIBILI - ricerca per codice o descrizione';

  FRicerca := TEdit.Create(Self);
  FRicerca.Parent := PannelloRicerca;
  FRicerca.SetBounds(18, 29, 780, 28);
  FRicerca.Anchors := [akLeft, akTop, akRight];
  FRicerca.OnChange := FiltraComponenti;
  FRicerca.OnEnter := RicercaEnter;

  Etichetta := TLabel.Create(Self);
  Etichetta.Parent := PannelloRicerca;
  Etichetta.SetBounds(820, 8, 170, 20);
  Etichetta.Caption := 'Quantita';

  FQuantita := TEdit.Create(Self);
  FQuantita.Parent := PannelloRicerca;
  FQuantita.SetBounds(820, 29, 100, 28);
  FQuantita.Text := '1';

  FGrigliaDisponibili := TcxGrid.Create(Self);
  FGrigliaDisponibili.Parent := PannelloRicerca;
  FGrigliaDisponibili.SetBounds(18, 68, 1044, 230);
  FGrigliaDisponibili.Anchors := [akLeft, akTop, akRight, akBottom];
  FViewDisponibili :=
    FGrigliaDisponibili.CreateView(TcxGridTableView) as TcxGridTableView;
  Livello := FGrigliaDisponibili.Levels.Add;
  Livello.GridView := FViewDisponibili;
  FViewDisponibili.OptionsView.GroupByBox := False;
  FViewDisponibili.OptionsView.ColumnAutoWidth := True;
  FViewDisponibili.OptionsData.Editing := False;
  FViewDisponibili.OnDblClick := DoppioClickDisponibili;
  with FViewDisponibili.CreateColumn do
  begin Caption := 'Codice'; Width := 190; end;
  with FViewDisponibili.CreateColumn do
  begin Caption := 'Descrizione'; Width := 760; end;

  PannelloDistinta := TPanel.Create(Self);
  PannelloDistinta.Parent := Self;
  PannelloDistinta.Align := alClient;
  PannelloDistinta.BevelOuter := bvNone;
  PannelloDistinta.Color := clWhite;

  Etichetta := TLabel.Create(Self);
  Etichetta.Parent := PannelloDistinta;
  Etichetta.Align := alTop;
  Etichetta.Height := 28;
  Etichetta.Caption := '   DISTINTA CORRENTE';

  Barra := TPanel.Create(Self);
  Barra.Parent := PannelloDistinta;
  Barra.Align := alBottom;
  Barra.Height := 54;
  Barra.BevelOuter := bvNone;
  Barra.Color := $00F4F4F4;
  CreaBottone('Aggiungi', 18, Aggiungi);
  CreaBottone('Modifica quantita', 155, Modifica);
  CreaBottone('Elimina', 292, Elimina);
  CreaBottone('Chiudi', 830, Chiudi);

  FGrigliaDistinta := TcxGrid.Create(Self);
  FGrigliaDistinta.Parent := PannelloDistinta;
  FGrigliaDistinta.Align := alClient;
  FViewDistinta :=
    FGrigliaDistinta.CreateView(TcxGridTableView) as TcxGridTableView;
  Livello := FGrigliaDistinta.Levels.Add;
  Livello.GridView := FViewDistinta;
  FViewDistinta.OptionsView.GroupByBox := False;
  FViewDistinta.OptionsView.ColumnAutoWidth := True;
  FViewDistinta.OptionsData.Editing := False;
  with FViewDistinta.CreateColumn do
  begin Caption := 'Codice'; Width := 190; end;
  with FViewDistinta.CreateColumn do
  begin Caption := 'Descrizione'; Width := 650; end;
  with FViewDistinta.CreateColumn do
  begin Caption := 'Quantita'; Width := 130; end;

  // Caricamento componenti differito alla prima ricerca.
  // La distinta e caricata al primo utilizzo, evitando lavoro nel costruttore.
  RicaricaDistinta;
end;

destructor TfrmComposizioneMacroParte.Destroy;
begin
  FFiltrati.Free;
  FComponenti.Free;
  FAssociazioni.Free;
  inherited;
end;

procedure TfrmComposizioneMacroParte.CaricaComponenti;
var
  Tutti: TList<TComponente>;
  C: TComponente;
begin
  FComponenti.Clear;
  Tutti := DM.ObjMgr.Find<TComponente>.List;
  try
    for C in Tutti do
      FComponenti.Add(C);
  finally
    Tutti.Free;
  end;
  FComponentiCaricati := True;
  FiltraComponenti(nil);
end;

procedure TfrmComposizioneMacroParte.RicercaEnter(Sender: TObject);
begin
  if not FComponentiCaricati then
    CaricaComponenti;
end;

procedure TfrmComposizioneMacroParte.FormKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_RETURN then Exit;
  if (ActiveControl = FGrigliaDisponibili) then
  begin
    Key := 0;
    Aggiungi(Sender);
  end
  else if ActiveControl = FRicerca then
  begin
    if not FComponentiCaricati then CaricaComponenti;
    if FFiltrati.Count > 0 then
    begin
      FGrigliaDisponibili.SetFocus;
      Key := 0;
    end;
  end;
end;

procedure TfrmComposizioneMacroParte.FiltraComponenti(Sender: TObject);
var
  C: TComponente;
  Testo: string;
  I: Integer;
begin
  if (FFiltrati = nil) or not FComponentiCaricati then Exit;
  FFiltrati.Clear;
  Testo := UpperCase(Trim(FRicerca.Text));
  for C in FComponenti do
    if (Testo = '') or
       (Pos(Testo, UpperCase(string(C.Codice))) > 0) or
       (Pos(Testo, UpperCase(string(C.Descrizione))) > 0) then
      FFiltrati.Add(C);

  FViewDisponibili.DataController.RecordCount := FFiltrati.Count;
  for I := 0 to FFiltrati.Count - 1 do
  begin
    C := FFiltrati[I];
    FViewDisponibili.DataController.Values[I, 0] := string(C.Codice);
    FViewDisponibili.DataController.Values[I, 1] := string(C.Descrizione);
  end;
end;

procedure TfrmComposizioneMacroParte.RicaricaDistinta;
var
  R: TComponenteMacroParte;
begin
  if not FDistintaCaricata then
  begin
    FAssociazioni.Clear;
    for R in FMacroParte.ComponentiMacroParteList do
      FAssociazioni.Add(R);
    FDistintaCaricata := True;
  end;
  AggiornaGrigliaDistinta;
end;

procedure TfrmComposizioneMacroParte.AggiornaGrigliaDistinta;
var
  R: TComponenteMacroParte;
  I: Integer;
begin
  FViewDistinta.DataController.BeginUpdate;
  try
    FViewDistinta.DataController.RecordCount := FAssociazioni.Count;
    for I := 0 to FAssociazioni.Count - 1 do
    begin
      R := FAssociazioni[I];
      if Assigned(R.IdComponente) then
      begin
        FViewDistinta.DataController.Values[I, 0] :=
          string(R.IdComponente.Codice);
        FViewDistinta.DataController.Values[I, 1] :=
          string(R.IdComponente.Descrizione);
      end;
      FViewDistinta.DataController.Values[I, 2] := Integer(R.Quantity);
    end;
  finally
    FViewDistinta.DataController.EndUpdate;
  end;
end;

function TfrmComposizioneMacroParte.ComponenteSelezionato: TComponente;
var
  I: Integer;
begin
  Result := nil;
  I := FViewDisponibili.DataController.FocusedRecordIndex;
  if (I >= 0) and (I < FFiltrati.Count) then
    Result := FFiltrati[I];
end;

function TfrmComposizioneMacroParte.RigaSelezionata: TComponenteMacroParte;
var
  I: Integer;
begin
  Result := nil;
  I := FViewDistinta.DataController.FocusedRecordIndex;
  if (I >= 0) and (I < FAssociazioni.Count) then
    Result := FAssociazioni[I];
end;

function TfrmComposizioneMacroParte.QuantitaValida(out Q: Integer): Boolean;
begin
  Result := TryStrToInt(Trim(FQuantita.Text), Q) and (Q > 0);
  if not Result then
    MessageDlg('Inserire una quantita intera positiva.',
      mtWarning, [mbOK], 0);
end;

procedure TfrmComposizioneMacroParte.Aggiungi(Sender: TObject);
var
  C: TComponente;
  R, Esistente: TComponenteMacroParte;
  Q: Integer;
  TestoQuantita: string;
begin
  C := ComponenteSelezionato;
  if C = nil then
  begin
    MessageDlg('Selezionare un componente nell''elenco superiore.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  for Esistente in FAssociazioni do
    if Assigned(Esistente.IdComponente) and
       (Esistente.IdComponente.Id = C.Id) then
    begin
      MessageDlg('Il componente e'' gia'' presente nella distinta.',
        mtInformation, [mbOK], 0);
      Exit;
    end;

  TestoQuantita := '1';
  if not InputQuery('Quantita componente',
    string(C.Codice) + ' - ' + string(C.Descrizione) +
    sLineBreak + 'Quantita:', TestoQuantita) then Exit;
  if not TryStrToInt(Trim(TestoQuantita), Q) or (Q <= 0) then
  begin
    MessageDlg('Inserire una quantita intera positiva.',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  R := TComponenteMacroParte.Create;
  R.IdMacroParte := FMacroParte;
  R.IdComponente := C;
  R.Quantity := Q;
  try
    DM.ObjMgr.Save(R);
    DM.ObjMgr.Flush;
    FMacroParte.ComponentiMacroParteList.Add(R);
    FAssociazioni.Add(R);
    AggiornaGrigliaDistinta;
    if FRicerca.CanFocus then
    begin
      FRicerca.SetFocus;
      FRicerca.SelectAll;
    end;
  except
    on E: Exception do
      MessageDlg('Errore inserimento: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmComposizioneMacroParte.DoppioClickDisponibili(Sender: TObject);
begin
  Aggiungi(Sender);
end;

procedure TfrmComposizioneMacroParte.Modifica(Sender: TObject);
var
  R: TComponenteMacroParte;
  Q: Integer;
begin
  R := RigaSelezionata;
  if R = nil then Exit;
  if not QuantitaValida(Q) then Exit;
  if Integer(R.Quantity) = Q then Exit;
  try
    R.Quantity := Q;
    DM.ObjMgr.Update(R);
    DM.ObjMgr.Flush;
    AggiornaGrigliaDistinta;
  except
    on E: Exception do
      MessageDlg('Errore modifica: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmComposizioneMacroParte.Elimina(Sender: TObject);
var
  R: TComponenteMacroParte;
  IndiceDistinta, IndiceAssociazione: Integer;
  ListaMacroParte: TList<TComponenteMacroParte>;
begin
  R := RigaSelezionata;
  if R = nil then
  begin
    MessageDlg('Selezionare una riga nella distinta corrente.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  if MessageDlg('Rimuovere il componente dalla distinta?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  // Le collezioni vanno aggiornate PRIMA che Aurelius possa liberare R.
  // Non modificare mai R dopo ObjMgr.Remove/Flush.
  ListaMacroParte := FMacroParte.ComponentiMacroParteList;
  IndiceDistinta := FAssociazioni.IndexOf(R);
  IndiceAssociazione := ListaMacroParte.IndexOf(R);

  if IndiceDistinta >= 0 then
    FAssociazioni.Delete(IndiceDistinta);
  if IndiceAssociazione >= 0 then
    ListaMacroParte.Delete(IndiceAssociazione);

  try
    DM.ObjMgr.Remove(R);
    DM.ObjMgr.Flush;
    AggiornaGrigliaDistinta;
  except
    on E: Exception do
    begin
      // La rimozione potrebbe essere gia' stata applicata dal manager:
      // non reinserire un oggetto potenzialmente distrutto.
      MessageDlg('Errore eliminazione: ' + E.Message + sLineBreak +
        'Chiudere e riaprire la composizione per verificare lo stato.',
        mtError, [mbOK], 0);
      Close;
    end;
  end;
end;

procedure TfrmComposizioneMacroParte.Chiudi(Sender: TObject);
begin
  Close;
end;

end.
