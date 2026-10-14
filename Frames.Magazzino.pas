unit Frames.Magazzino;

interface

uses
  System.Classes, System.SysUtils, System.Variants, System.Math, System.Generics.Collections, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Dialogs, Vcl.Graphics,
  Data.model, cxGrid, cxGridLevel, cxGridCustomView, cxGridTableView,
  cxButtons, cxControls, cxStyles, cxLookAndFeels;

type
  TfraMagazzino = class(TFrame)
  private
    FGrid: TcxGrid;
    FView: TcxGridTableView;
    FRicerca: TEdit;
    FMacroParti: TList<TMacroParte>;
    FMovimenti: TList<TMovimentoMagazzino>;
    FScorte: TList<TScorta>;
    FHeaderStyle, FSelectionStyle: TcxStyle;
    procedure Carica(Sender: TObject);
    procedure Filtra(Sender: TObject);
    procedure NuovoMovimento(Sender: TObject);
    procedure ModificaScorta(Sender: TObject);
    function Selezionata: TMacroParte;
    function Giacenza(AMacroParte: TMacroParte): Integer;
    function ScortaMinima(AMacroParte: TMacroParte): Integer;
    procedure AggiornaGriglia;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Forms.DataModule;

{$R *.dfm}

constructor TfraMagazzino.Create(AOwner: TComponent);
var
  Barra: TPanel;
  B: TcxButton;
  L: TcxGridLevel;
  procedure Pulsante(const Titolo: string; X: Integer; Handler: TNotifyEvent;
    Colore: TColor);
  begin
    B := TcxButton.Create(Self);
    B.Parent := Barra;
    B.SetBounds(X, 12, 145, 34);
    B.Caption := Titolo;
    B.OnClick := Handler;
    B.LookAndFeel.NativeStyle := False;
    B.LookAndFeel.SkinName := '';
    B.LookAndFeel.Kind := lfFlat;
    B.Colors.Default := Colore;
    B.Colors.Normal := Colore;
    B.ParentFont := False;
    B.Font.Name := 'Segoe UI';
    B.Font.Color := clWhite;
    B.Font.Style := [fsBold];
  end;
begin
  inherited;
  FMacroParti := TList<TMacroParte>.Create;
  FMovimenti := TList<TMovimentoMagazzino>.Create;
  FScorte := TList<TScorta>.Create;
  Align := alClient;
  Color := $00F7F7F7;
  Font.Name := 'Segoe UI';
  Font.Size := 10;

  Barra := TPanel.Create(Self);
  Barra.Parent := Self;
  Barra.Align := alTop;
  Barra.Height := 62;
  Barra.BevelOuter := bvNone;
  Barra.Color := clWhite;
  Pulsante('Carico / Scarico', 12, NuovoMovimento, $00B36517);
  Pulsante('Scorta minima', 165, ModificaScorta, $009A671E);
  Pulsante('Aggiorna', 318, Carica, $009A671E);

  FRicerca := TEdit.Create(Self);
  FRicerca.Parent := Barra;
  FRicerca.SetBounds(480, 16, 310, 27);
  FRicerca.TextHint := 'Cerca macro-parte';
  FRicerca.OnChange := Filtra;

  FGrid := TcxGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FView := FGrid.CreateView(TcxGridTableView) as TcxGridTableView;
  L := FGrid.Levels.Add;
  L.GridView := FView;
  FHeaderStyle := TcxStyle.Create(Self);
  FHeaderStyle.Color := $00F9F5F2;
  FHeaderStyle.TextColor := $003E2817;
  FHeaderStyle.Font.Name := 'Segoe UI';
  FHeaderStyle.Font.Style := [fsBold];
  FView.Styles.Header := FHeaderStyle;
  FSelectionStyle := TcxStyle.Create(Self);
  FSelectionStyle.Color := $00F8EBDD;
  FSelectionStyle.TextColor := $003E2817;
  FView.Styles.Selection := FSelectionStyle;
  FView.OptionsView.GroupByBox := False;
  FView.OptionsView.ColumnAutoWidth := True;
  FView.OptionsData.Editing := False;
  FView.OptionsData.Deleting := False;
  FView.OptionsData.Inserting := False;
  with FView.CreateColumn do begin Caption := 'Codice'; Width := 150; end;
  with FView.CreateColumn do begin Caption := 'Macro-parte'; Width := 400; end;
  with FView.CreateColumn do begin Caption := 'Giacenza'; Width := 120; end;
  with FView.CreateColumn do begin Caption := 'Scorta minima'; Width := 130; end;
  with FView.CreateColumn do begin Caption := 'Da riordinare'; Width := 140; end;
  Carica(nil);
end;

destructor TfraMagazzino.Destroy;
begin
  FScorte.Free;
  FMovimenti.Free;
  FMacroParti.Free;
  inherited;
end;

procedure TfraMagazzino.Carica(Sender: TObject);
var
  A: TList<TMacroParte>;
  M: TList<TMovimentoMagazzino>;
  S: TList<TScorta>;
  P: TMacroParte;
  Mov: TMovimentoMagazzino;
  Sc: TScorta;
begin
  FMacroParti.Clear;
  FMovimenti.Clear;
  FScorte.Clear;
  A := DM.ObjMgr.Find<TMacroParte>.List;
  try
    for P in A do FMacroParti.Add(P);
  finally
    A.Free;
  end;
  M := DM.ObjMgr.Find<TMovimentoMagazzino>.List;
  try
    for Mov in M do FMovimenti.Add(Mov);
  finally
    M.Free;
  end;
  S := DM.ObjMgr.Find<TScorta>.List;
  try
    for Sc in S do FScorte.Add(Sc);
  finally
    S.Free;
  end;
  AggiornaGriglia;
end;

function TfraMagazzino.Giacenza(AMacroParte: TMacroParte): Integer;
var
  M: TMovimentoMagazzino;
begin
  Result := 0;
  for M in FMovimenti do
    if Assigned(M.IdMacroParte) and (M.IdMacroParte.Id = AMacroParte.Id) then
    begin
      if SameText(M.TipoMovimento, 'C') then
        Inc(Result, M.Quantita)
      else if SameText(M.TipoMovimento, 'S') then
        Dec(Result, M.Quantita);
    end;
end;

function TfraMagazzino.ScortaMinima(AMacroParte: TMacroParte): Integer;
var
  S: TScorta;
begin
  Result := 0;
  for S in FScorte do
    if Assigned(S.IdMacroParte) and (S.IdMacroParte.Id = AMacroParte.Id) then
      Exit(S.ScortaMinima);
end;

procedure TfraMagazzino.AggiornaGriglia;
var
  P: TMacroParte;
  I, G, Min: Integer;
  Filtro: string;
begin
  Filtro := UpperCase(Trim(FRicerca.Text));
  FView.DataController.BeginUpdate;
  try
    FView.DataController.RecordCount := 0;
    for P in FMacroParti do
    begin
      if (Filtro <> '') and
         (Pos(Filtro, UpperCase(string(P.Codice))) = 0) and
         (Pos(Filtro, UpperCase(string(P.Descrizione))) = 0) then Continue;
      I := FView.DataController.RecordCount;
      FView.DataController.RecordCount := I + 1;
      G := Giacenza(P);
      Min := ScortaMinima(P);
      FView.DataController.Values[I, 0] := string(P.Codice);
      FView.DataController.Values[I, 1] := string(P.Descrizione);
      FView.DataController.Values[I, 2] := G;
      FView.DataController.Values[I, 3] := Min;
      FView.DataController.Values[I, 4] := Max(0, Min - G);
    end;
  finally
    FView.DataController.EndUpdate;
  end;
end;

procedure TfraMagazzino.Filtra(Sender: TObject);
begin
  AggiornaGriglia;
end;

function TfraMagazzino.Selezionata: TMacroParte;
var
  I: Integer;
  Codice: string;
  P: TMacroParte;
begin
  Result := nil;
  I := FView.DataController.FocusedRecordIndex;
  if (I < 0) or (I >= FView.DataController.RecordCount) then Exit;
  Codice := VarToStr(FView.DataController.Values[I, 0]);
  for P in FMacroParti do
    if string(P.Codice) = Codice then Exit(P);
end;

procedure TfraMagazzino.NuovoMovimento(Sender: TObject);
var
  P: TMacroParte;
  M: TMovimentoMagazzino;
  Tipo, Quantita, Causale: string;
  Q: Integer;
begin
  P := Selezionata;
  if P = nil then
  begin
    MessageDlg('Selezionare una macro-parte.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Tipo := 'C';
  if not InputQuery('Movimento di magazzino',
    'Tipo movimento (C = carico, S = scarico):', Tipo) then Exit;
  Tipo := UpperCase(Trim(Tipo));
  if (Tipo <> 'C') and (Tipo <> 'S') then
  begin
    MessageDlg('Tipo non valido: usare C o S.', mtWarning, [mbOK], 0);
    Exit;
  end;
  Quantita := '1';
  if not InputQuery('Movimento di magazzino', 'Quantita:', Quantita) then Exit;
  if not TryStrToInt(Trim(Quantita), Q) or (Q <= 0) then
  begin
    MessageDlg('Inserire una quantita intera positiva.', mtWarning, [mbOK], 0);
    Exit;
  end;
  if (Tipo = 'S') and (Q > Giacenza(P)) then
  begin
    MessageDlg('Giacenza insufficiente.', mtWarning, [mbOK], 0);
    Exit;
  end;
  Causale := 'RETTIFICA';
  if not InputQuery('Movimento di magazzino', 'Causale:', Causale) then Exit;
  Causale := Trim(Causale);
  if (Causale = '') or (Length(Causale) > 30) then
  begin
    MessageDlg('Causale obbligatoria (max 30 caratteri).', mtWarning, [mbOK], 0);
    Exit;
  end;
  M := TMovimentoMagazzino.Create;
  M.IdMacroParte := P;
  M.DataMovimento := Now;
  M.TipoMovimento := Tipo;
  M.Quantita := Q;
  M.Causale := Causale;
  try
    DM.ObjMgr.Save(M);
    DM.ObjMgr.Flush;
    Carica(nil);
  except
    on E: Exception do
      MessageDlg('Errore registrazione: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfraMagazzino.ModificaScorta(Sender: TObject);
var
  P: TMacroParte;
  S: TScorta;
  X: TScorta;
  Valore: string;
  Q: Integer;
begin
  P := Selezionata;
  if P = nil then
  begin
    MessageDlg('Selezionare una macro-parte.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Valore := IntToStr(ScortaMinima(P));
  if not InputQuery('Scorta minima', 'Quantita minima:', Valore) then Exit;
  if not TryStrToInt(Trim(Valore), Q) or (Q < 0) then
  begin
    MessageDlg('Inserire un numero intero non negativo.', mtWarning, [mbOK], 0);
    Exit;
  end;
  S := nil;
  for X in FScorte do
    if Assigned(X.IdMacroParte) and (X.IdMacroParte.Id = P.Id) then
    begin
      S := X;
      Break;
    end;
  if S = nil then
  begin
    S := TScorta.Create;
    S.IdMacroParte := P;
    S.ScortaMinima := Q;
    DM.ObjMgr.Save(S);
  end
  else
  begin
    S.ScortaMinima := Q;
    DM.ObjMgr.Update(S);
  end;
  try
    DM.ObjMgr.Flush;
    Carica(nil);
  except
    on E: Exception do
      MessageDlg('Errore scorta: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

end.
