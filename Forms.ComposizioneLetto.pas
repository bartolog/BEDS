unit Forms.ComposizioneLetto;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  Winapi.Windows,
  Data.model, cxGrid, cxGridLevel, cxGridCustomView, cxGridTableView,
  cxButtons, cxControls;

type
  TfrmComposizioneLetto = class(TForm)
  private
    FLetto: TLetto;
    FAssociazioni: TList<TMacroParteLetto>;
    FMacroParti: TList<TMacroParte>;
    FFiltrate: TList<TMacroParte>;
    FGrigliaDisponibili: TcxGrid;
    FViewDisponibili: TcxGridTableView;
    FGrigliaDistinta: TcxGrid;
    FViewDistinta: TcxGridTableView;
    FRicerca: TEdit;
    FQuantita: TEdit;
    FInfo: TLabel;
    FMacroPartiCaricate: Boolean;
    FDistintaCaricata: Boolean;
    procedure RicercaEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AggiornaGrigliaDistinta;
    procedure CaricaMacroParti;
    procedure FiltraMacroParti(Sender: TObject);
    procedure RicaricaDistinta;
    procedure Aggiungi(Sender: TObject);
    procedure Modifica(Sender: TObject);
    procedure Elimina(Sender: TObject);
    procedure Chiudi(Sender: TObject);
    procedure DoppioClickDisponibili(Sender: TObject);
    function MacroParteSelezionata: TMacroParte;
    function RigaSelezionata: TMacroParteLetto;
    function QuantitaValida(out Q: Integer): Boolean;
  public
    constructor CreatePerLetto(AOwner: TComponent; ALetto: TLetto);
    destructor Destroy; override;
  end;

implementation

uses
  Forms.DataModule, Vcl.Graphics;

constructor TfrmComposizioneLetto.CreatePerLetto(
  AOwner: TComponent; ALetto: TLetto);
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
    Bottone.LookAndFeel.NativeStyle := False;
    Bottone.LookAndFeel.SkinName := '';
    Bottone.Colors.Default := $009A671E;
    Bottone.Colors.Normal := $009A671E;
    if Titolo = 'Elimina' then
    begin
      Bottone.Colors.Default := $004545C6;
      Bottone.Colors.Normal := $004545C6;
    end;
    Bottone.ParentFont := False;
    Bottone.Font.Color := clWhite;
    Bottone.Font.Style := [fsBold];
  end;
begin
  inherited CreateNew(AOwner);
  FLetto := ALetto;
  FMacroPartiCaricate := False;
  FDistintaCaricata := False;
  KeyPreview := True;
  OnKeyDown := FormKeyDown;
  FAssociazioni := TList<TMacroParteLetto>.Create;
  FMacroParti := TList<TMacroParte>.Create;
  FFiltrate := TList<TMacroParte>.Create;
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
  FInfo.Caption := string(FLetto.Codice) + ' - ' +
    string(FLetto.Descrizione);

  Etichetta := TLabel.Create(Self);
  Etichetta.Parent := PannelloSuperiore;
  Etichetta.SetBounds(18, 49, 900, 22);
  Etichetta.Caption :=
    'Seleziona un macro-parte dall''elenco, indica la quantita e premi Aggiungi.';

  PannelloRicerca := TPanel.Create(Self);
  PannelloRicerca.Parent := Self;
  PannelloRicerca.Align := alTop;
  PannelloRicerca.Height := 315;
  PannelloRicerca.BevelOuter := bvNone;
  PannelloRicerca.Color := clWhite;

  Etichetta := TLabel.Create(Self);
  Etichetta.Parent := PannelloRicerca;
  Etichetta.SetBounds(18, 5, 700, 20);
  Etichetta.Caption := 'MACRO-PARTI DISPONIBILI - ricerca per codice o descrizione';

  FRicerca := TEdit.Create(Self);
  FRicerca.Parent := PannelloRicerca;
  FRicerca.SetBounds(18, 29, 780, 28);
  FRicerca.Anchors := [akLeft, akTop, akRight];
  FRicerca.OnChange := FiltraMacroParti;
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

  // Caricamento macro-parti differito alla prima ricerca.
  // La distinta e caricata al primo utilizzo, evitando lavoro nel costruttore.
  RicaricaDistinta;
end;

destructor TfrmComposizioneLetto.Destroy;
begin
  FFiltrate.Free;
  FMacroParti.Free;
  FAssociazioni.Free;
  inherited;
end;

procedure TfrmComposizioneLetto.CaricaMacroParti;
var
  Tutti: TList<TMacroParte>;
  C: TMacroParte;
begin
  FMacroParti.Clear;
  Tutti := DM.ObjMgr.Find<TMacroParte>.List;
  try
    for C in Tutti do
      FMacroParti.Add(C);
  finally
    Tutti.Free;
  end;
  FMacroPartiCaricate := True;
  FiltraMacroParti(nil);
end;

procedure TfrmComposizioneLetto.RicercaEnter(Sender: TObject);
begin
  if not FMacroPartiCaricate then
    CaricaMacroParti;
end;

procedure TfrmComposizioneLetto.FormKeyDown(
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
    if not FMacroPartiCaricate then CaricaMacroParti;
    if FFiltrate.Count > 0 then
    begin
      FGrigliaDisponibili.SetFocus;
      Key := 0;
    end;
  end;
end;

procedure TfrmComposizioneLetto.FiltraMacroParti(Sender: TObject);
var
  C: TMacroParte;
  Testo: string;
  I: Integer;
begin
  if (FFiltrate = nil) or not FMacroPartiCaricate then Exit;
  FFiltrate.Clear;
  Testo := UpperCase(Trim(FRicerca.Text));
  for C in FMacroParti do
    if (Testo = '') or
       (Pos(Testo, UpperCase(string(C.Codice))) > 0) or
       (Pos(Testo, UpperCase(string(C.Descrizione))) > 0) then
      FFiltrate.Add(C);

  FViewDisponibili.DataController.RecordCount := FFiltrate.Count;
  for I := 0 to FFiltrate.Count - 1 do
  begin
    C := FFiltrate[I];
    FViewDisponibili.DataController.Values[I, 0] := string(C.Codice);
    FViewDisponibili.DataController.Values[I, 1] := string(C.Descrizione);
  end;
end;

procedure TfrmComposizioneLetto.RicaricaDistinta;
var
  R: TMacroParteLetto;
begin
  if not FDistintaCaricata then
  begin
    FAssociazioni.Clear;
    for R in FLetto.MacroPartiLettoList do
      FAssociazioni.Add(R);
    FDistintaCaricata := True;
  end;
  AggiornaGrigliaDistinta;
end;

procedure TfrmComposizioneLetto.AggiornaGrigliaDistinta;
var
  R: TMacroParteLetto;
  I: Integer;
begin
  FViewDistinta.DataController.BeginUpdate;
  try
    FViewDistinta.DataController.RecordCount := FAssociazioni.Count;
    for I := 0 to FAssociazioni.Count - 1 do
    begin
      R := FAssociazioni[I];
      if Assigned(R.IdMacroParte) then
      begin
        FViewDistinta.DataController.Values[I, 0] :=
          string(R.IdMacroParte.Codice);
        FViewDistinta.DataController.Values[I, 1] :=
          string(R.IdMacroParte.Descrizione);
      end;
      FViewDistinta.DataController.Values[I, 2] := Integer(R.Quantity);
    end;
  finally
    FViewDistinta.DataController.EndUpdate;
  end;
end;

function TfrmComposizioneLetto.MacroParteSelezionata: TMacroParte;
var
  I: Integer;
begin
  Result := nil;
  I := FViewDisponibili.DataController.FocusedRecordIndex;
  if (I >= 0) and (I < FFiltrate.Count) then
    Result := FFiltrate[I];
end;

function TfrmComposizioneLetto.RigaSelezionata: TMacroParteLetto;
var
  I: Integer;
begin
  Result := nil;
  I := FViewDistinta.DataController.FocusedRecordIndex;
  if (I >= 0) and (I < FAssociazioni.Count) then
    Result := FAssociazioni[I];
end;

function TfrmComposizioneLetto.QuantitaValida(out Q: Integer): Boolean;
begin
  Result := TryStrToInt(Trim(FQuantita.Text), Q) and (Q > 0);
  if not Result then
    MessageDlg('Inserire una quantita intera positiva.',
      mtWarning, [mbOK], 0);
end;

procedure TfrmComposizioneLetto.Aggiungi(Sender: TObject);
var
  C: TMacroParte;
  R, Esistente: TMacroParteLetto;
  Q: Integer;
  TestoQuantita: string;
begin
  C := MacroParteSelezionata;
  if C = nil then
  begin
    MessageDlg('Selezionare una macro-parte nell''elenco superiore.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  for Esistente in FAssociazioni do
    if Assigned(Esistente.IdMacroParte) and
       (Esistente.IdMacroParte.Id = C.Id) then
    begin
      MessageDlg('La macro-parte e'' gia'' presente nella distinta.',
        mtInformation, [mbOK], 0);
      Exit;
    end;

  TestoQuantita := '1';
  if not InputQuery('Quantita macro-parte',
    string(C.Codice) + ' - ' + string(C.Descrizione) +
    sLineBreak + 'Quantita:', TestoQuantita) then Exit;
  if not TryStrToInt(Trim(TestoQuantita), Q) or (Q <= 0) then
  begin
    MessageDlg('Inserire una quantita intera positiva.',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  R := TMacroParteLetto.Create;
  R.IdLetto := FLetto;
  R.IdMacroParte := C;
  R.Quantity := Q;
  try
    DM.ObjMgr.Save(R);
    DM.ObjMgr.Flush;
    FLetto.MacroPartiLettoList.Add(R);
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

procedure TfrmComposizioneLetto.DoppioClickDisponibili(Sender: TObject);
begin
  Aggiungi(Sender);
end;

procedure TfrmComposizioneLetto.Modifica(Sender: TObject);
var
  R: TMacroParteLetto;
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

procedure TfrmComposizioneLetto.Elimina(Sender: TObject);
var
  R: TMacroParteLetto;
  IndiceDistinta, IndiceAssociazione: Integer;
  ListaMacroParte: TList<TMacroParteLetto>;
begin
  R := RigaSelezionata;
  if R = nil then
  begin
    MessageDlg('Selezionare una riga nella distinta corrente.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  if MessageDlg('Rimuovere la macro-parte dalla distinta?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  // Le collezioni vanno aggiornate PRIMA che Aurelius possa liberare R.
  // Non modificare mai R dopo ObjMgr.Remove/Flush.
  ListaMacroParte := FLetto.MacroPartiLettoList;
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

procedure TfrmComposizioneLetto.Chiudi(Sender: TObject);
begin
  Close;
end;

end.
