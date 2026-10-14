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
    FGrid: TcxGrid;
    FView: TcxGridTableView;
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
  Barra: TPanel;
  B: TButton;
  L: TcxGridLevel;
  C: TcxGridColumn;
begin
  inherited;
  Align := alClient;
  FOrdini := TList<TOrdineFornitore>.Create;
  Barra := TPanel.Create(Self);
  Barra.Parent := Self;
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
  FGrid.Parent := Self;
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
  Carica(nil);
end;

destructor TfraAcquisti.Destroy;
begin
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

end.
