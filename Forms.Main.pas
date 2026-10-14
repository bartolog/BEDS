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
      MostraPagina(TfraDashboard)
end;

procedure TfMain.MostraPagina(AFrameClass: TFrameClass);
begin
  if Assigned(FPaginaAttiva) then
    FreeAndNil(FPaginaAttiva);

  FPaginaAttiva := AFrameClass.Create(Self);
  FPaginaAttiva.Parent := pnlContent;
  FPaginaAttiva.Align := alClient;
end;



procedure TfMain.navMacroPartiClick(Sender: TObject);
begin


     MostraPagina(TfraMacroParti);
end;

procedure TfMain.navLettiClick(Sender: TObject);
begin
  MostraPagina(TfraLetti);
end;

procedure TfMain.navMagazzinoClick(Sender: TObject);
begin
  MostraPagina(TfraMagazzino);
end;

end.
