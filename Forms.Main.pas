unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxCore, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.ExtCtrls, dxNavBar, cxClasses,
  dxSkinsForm, dxNavBarBase, dxNavBarCollns, Frames.Dashboard;

type
  TFrameClass = class of TFrame;

  TfMain = class(TForm)
    dxSkinController1: TdxSkinController;
    navMain: TdxNavBar;
    pnlContent: TPanel;
    Navigazione: TdxNavBarGroup;
    navDashboard: TdxNavBarItem;
    navLetti: TdxNavBarItem;
    navMacroParti: TdxNavBarItem;
    navMagazzino: TdxNavBarItem;
    navAcquisti: TdxNavBarItem;
    navProduzione: TdxNavBarItem;
    procedure FormCreate(Sender: TObject);
    procedure navMacroPartiClick(Sender: TObject);
    procedure navLettiClick(Sender: TObject);
    procedure navMagazzinoClick(Sender: TObject);
  private
    { Private declarations }
    private
  FPaginaAttiva: TFrame;
  procedure MostraPagina(AFrameClass: TFrameClass);
  procedure EvidenziaSezione(Indice: Integer);

  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses Frames.MacroParti, Frames.Letti, Frames.Magazzino;

{ TfMain }

procedure TfMain.FormCreate(Sender: TObject);
begin
  navMain.OptionsBehavior.Common.AllowSelectLinks := True;
  MostraPagina(TfraDashboard);
  EvidenziaSezione(0);
end;

procedure TfMain.MostraPagina(AFrameClass: TFrameClass);
begin
  if Assigned(FPaginaAttiva) then
    FreeAndNil(FPaginaAttiva);

  FPaginaAttiva := AFrameClass.Create(Self);
  FPaginaAttiva.Parent := pnlContent;
  FPaginaAttiva.Align := alClient;
end;



procedure TfMain.EvidenziaSezione(Indice: Integer);
const
  Titoli: array[0..5] of string = (
    'Dashboard', 'Catalogo letti', 'Macro-parti',
    'Magazzino', 'Acquisti', 'Produzione');
var
  I: Integer;
begin
  // La selezione e' gestita dal NavBar; nessun prefisso nel titolo.
  for I := 0 to 5 do
    Navigazione.Links[I].Item.Caption := Titoli[I];
  Navigazione.SelectedLinkIndex := Indice;
end;

procedure TfMain.navMacroPartiClick(Sender: TObject);
begin


  MostraPagina(TfraMacroParti);
  EvidenziaSezione(2);
end;

procedure TfMain.navLettiClick(Sender: TObject);
begin
  MostraPagina(TfraLetti);
  EvidenziaSezione(1);
end;

procedure TfMain.navMagazzinoClick(Sender: TObject);
begin
  MostraPagina(TfraMagazzino);
  EvidenziaSezione(3);
end;

end.
