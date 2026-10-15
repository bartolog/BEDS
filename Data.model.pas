unit Data.model;

interface

uses
  SysUtils, 
  Generics.Collections, 
  Aurelius.Mapping.Attributes, 
  Aurelius.Types.Blob, 
  Aurelius.Types.DynamicProperties, 
  Aurelius.Types.Nullable, 
  Aurelius.Types.Proxy, 
  Aurelius.Dictionary.Classes, 
  Aurelius.Linq;

type
  TCliente = class;
  TComponente = class;
  TComponenteMacroParte = class;
  TFornitore = class;
  TLetto = class;
  TMacroParte = class;
  TMacroParteLetto = class;
  TMovimentoMagazzino = class;
  TOrdineCliente = class;
  TOrdineFornitore = class;
  TRigaOrdineCliente = class;
  TRigaOrdineFornitore = class;
  TScorta = class;
  TClienteDictionary = class;
  TComponenteDictionary = class;
  TComponenteMacroParteDictionary = class;
  TFornitoreDictionary = class;
  TLettoDictionary = class;
  TMacroParteDictionary = class;
  TMacroParteLettoDictionary = class;
  TMovimentoMagazzinoDictionary = class;
  TOrdineClienteDictionary = class;
  TOrdineFornitoreDictionary = class;
  TRigaOrdineClienteDictionary = class;
  TRigaOrdineFornitoreDictionary = class;
  TScortaDictionary = class;
  
  [Entity]
  [Table('Clienti')]
  [Sequence('GEN_CLIENTE_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TCliente = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Nome', [TColumnProp.Required], 50)]
    FNome: string;
    
    [Column('Cognome', [TColumnProp.Required], 50)]
    FCognome: string;
    
    [Column('Denominazione', [], 100)]
    FDenominazione: Nullable<string>;
    
    [Column('Azienda', [TColumnProp.Required])]
    FAzienda: Boolean;
    
    [Column('CodiceFiscale', [], 11)]
    FCodiceFiscale: Nullable<string>;
    
    [Column('PIVA', [], 11)]
    FPIVA: Nullable<string>;
    
    [Column('Indirizzo', [], 80)]
    FIndirizzo: Nullable<string>;
    
    [Column('Civico', [], 10)]
    FCivico: Nullable<string>;
    
    [Column('CAP', [], 5)]
    FCAP: Nullable<string>;
    
    [Column('Citta', [], 40)]
    FCitta: Nullable<string>;
    
    [Column('Provincia', [], 2)]
    FProvincia: Nullable<string>;
    
    [Column('Telefono', [], 13)]
    FTelefono: Nullable<string>;
    
    [ManyValuedAssociation([TAssociationProp.Lazy, TAssociationProp.Required], [TCascadeType.SaveUpdate, TCascadeType.Merge], 'FIdCliente')]
    FOrdiniClienteList: Proxy<TList<TOrdineCliente>>;
    function GetOrdiniClienteList: TList<TOrdineCliente>;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Int64 read FId write FId;
    property Nome: string read FNome write FNome;
    property Cognome: string read FCognome write FCognome;
    property Denominazione: Nullable<string> read FDenominazione write FDenominazione;
    property Azienda: Boolean read FAzienda write FAzienda;
    property CodiceFiscale: Nullable<string> read FCodiceFiscale write FCodiceFiscale;
    property PIVA: Nullable<string> read FPIVA write FPIVA;
    property Indirizzo: Nullable<string> read FIndirizzo write FIndirizzo;
    property Civico: Nullable<string> read FCivico write FCivico;
    property CAP: Nullable<string> read FCAP write FCAP;
    property Citta: Nullable<string> read FCitta write FCitta;
    property Provincia: Nullable<string> read FProvincia write FProvincia;
    property Telefono: Nullable<string> read FTelefono write FTelefono;
    property OrdiniClienteList: TList<TOrdineCliente> read GetOrdiniClienteList;
  end;
  
  [Entity]
  [Table('Componenti')]
  [Sequence('GEN_COMPONENTI_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TComponente = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Codice', [], 10)]
    FCodice: Nullable<string>;
    
    [Column('Descrizione', [], 50)]
    FDescrizione: Nullable<string>;
  public
    property Id: Int64 read FId write FId;
    property Codice: Nullable<string> read FCodice write FCodice;
    property Descrizione: Nullable<string> read FDescrizione write FDescrizione;
  end;
  
  [Entity]
  [Table('ComponentiMacroParte')]
  [Sequence('GEN_COMPONENTI_PARTE_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TComponenteMacroParte = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Quantity', [])]
    FQuantity: Nullable<Integer>;
    
    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdMacroParte', [], 'Id')]
    FIdMacroParte: Proxy<TMacroParte>;
    
    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdComponente', [], 'Id')]
    FIdComponente: Proxy<TComponente>;
    function GetIdMacroParte: TMacroParte;
    procedure SetIdMacroParte(const Value: TMacroParte);
    function GetIdComponente: TComponente;
    procedure SetIdComponente(const Value: TComponente);
  public
    property Id: Int64 read FId write FId;
    property Quantity: Nullable<Integer> read FQuantity write FQuantity;
    property IdMacroParte: TMacroParte read GetIdMacroParte write SetIdMacroParte;
    property IdComponente: TComponente read GetIdComponente write SetIdComponente;
  end;
  
  [Entity]
  [Table('Fornitori')]
  [Sequence('GEN_FORNITORE_ID')]
  [Id('FID', TIdGenerator.IdentityOrSequence)]
  TFornitore = class
  private
    [Column('ID', [TColumnProp.Required])]
    FID: Int64;
    
    [Column('Codice', [TColumnProp.Required], 10)]
    FCodice: string;
    
    [Column('RagioneSociale', [TColumnProp.Required], 100)]
    FRagioneSociale: string;
    
    [Column('PartitaIVA', [], 11)]
    FPartitaIVA: Nullable<string>;
    
    [Column('Indirizzo', [], 150)]
    FIndirizzo: Nullable<string>;
    
    [Column('CAP', [], 10)]
    FCAP: Nullable<string>;
    
    [Column('Citta', [], 60)]
    FCitta: Nullable<string>;
    
    [Column('Provincia', [], 2)]
    FProvincia: Nullable<string>;
    
    [Column('Telefono', [], 30)]
    FTelefono: Nullable<string>;
    
    [Column('Email', [], 100)]
    FEmail: Nullable<string>;
    
    [Column('Note', [], 255)]
    FNote: Nullable<string>;
    
    [Column('Attivo', [TColumnProp.Required])]
    FAttivo: Boolean;
  public
    property ID: Int64 read FID write FID;
    property Codice: string read FCodice write FCodice;
    property RagioneSociale: string read FRagioneSociale write FRagioneSociale;
    property PartitaIVA: Nullable<string> read FPartitaIVA write FPartitaIVA;
    property Indirizzo: Nullable<string> read FIndirizzo write FIndirizzo;
    property CAP: Nullable<string> read FCAP write FCAP;
    property Citta: Nullable<string> read FCitta write FCitta;
    property Provincia: Nullable<string> read FProvincia write FProvincia;
    property Telefono: Nullable<string> read FTelefono write FTelefono;
    property Email: Nullable<string> read FEmail write FEmail;
    property Note: Nullable<string> read FNote write FNote;
    property Attivo: Boolean read FAttivo write FAttivo;
  end;
  
  [Entity]
  [Table('Letti')]
  [Sequence('GEN_LETTI_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TLetto = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Codice', [], 10)]
    FCodice: Nullable<string>;
    
    [Column('Descrizione', [], 50)]
    FDescrizione: Nullable<string>;
    
    [Column('Modello', [], 25)]
    FModello: Nullable<string>;
    
    [ManyValuedAssociation([TAssociationProp.Lazy], [TCascadeType.SaveUpdate, TCascadeType.Merge, TCascadeType.Remove], 'FIdLetto')]
    FMacroPartiLettoList: Proxy<TList<TMacroParteLetto>>;
    function GetMacroPartiLettoList: TList<TMacroParteLetto>;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Int64 read FId write FId;
    property Codice: Nullable<string> read FCodice write FCodice;
    property Descrizione: Nullable<string> read FDescrizione write FDescrizione;
    property Modello: Nullable<string> read FModello write FModello;
    property MacroPartiLettoList: TList<TMacroParteLetto> read GetMacroPartiLettoList;
  end;
  
  [Entity]
  [Table('MacroParti')]
  [Sequence('GEN_MACRO_PARTI_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TMacroParte = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Codice', [], 10)]
    FCodice: Nullable<string>;
    
    [Column('Descrizione', [], 80)]
    FDescrizione: Nullable<string>;
    
    [ManyValuedAssociation([TAssociationProp.Lazy], [TCascadeType.SaveUpdate, TCascadeType.Merge, TCascadeType.Remove], 'FIdMacroParte')]
    FComponentiMacroParteList: Proxy<TList<TComponenteMacroParte>>;
    
    [ManyValuedAssociation([TAssociationProp.Lazy, TAssociationProp.Required], [TCascadeType.SaveUpdate, TCascadeType.Merge, TCascadeType.Remove], 'FIdMacroParte')]
    FScorteList: Proxy<TList<TScorta>>;
    function GetComponentiMacroParteList: TList<TComponenteMacroParte>;
    function GetScorteList: TList<TScorta>;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Int64 read FId write FId;
    property Codice: Nullable<string> read FCodice write FCodice;
    property Descrizione: Nullable<string> read FDescrizione write FDescrizione;
    property ComponentiMacroParteList: TList<TComponenteMacroParte> read GetComponentiMacroParteList;
    property ScorteList: TList<TScorta> read GetScorteList;
  end;
  
  [Entity]
  [Table('MacroPartiLetto')]
  [Sequence('GEN_MACRO_PARTI_LETTO_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TMacroParteLetto = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Quantity', [])]
    FQuantity: Nullable<Integer>;
    
    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdLetto', [], 'Id')]
    FIdLetto: Proxy<TLetto>;
    
    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdMacroParte', [], 'Id')]
    FIdMacroParte: Proxy<TMacroParte>;
    function GetIdLetto: TLetto;
    procedure SetIdLetto(const Value: TLetto);
    function GetIdMacroParte: TMacroParte;
    procedure SetIdMacroParte(const Value: TMacroParte);
  public
    property Id: Int64 read FId write FId;
    property Quantity: Nullable<Integer> read FQuantity write FQuantity;
    property IdLetto: TLetto read GetIdLetto write SetIdLetto;
    property IdMacroParte: TMacroParte read GetIdMacroParte write SetIdMacroParte;
  end;
  
  [Entity]
  [Table('MovimentiMagazzino')]
  [Sequence('GEN_MOVIMENTO_MAGAZZINO_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TMovimentoMagazzino = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('DataMovimento', [TColumnProp.Required])]
    FDataMovimento: TDateTime;
    
    [Column('TipoMovimento', [TColumnProp.Required], 1)]
    FTipoMovimento: string;
    
    [Column('Quantita', [TColumnProp.Required])]
    FQuantita: Integer;
    
    [Column('Causale', [TColumnProp.Required], 30)]
    FCausale: string;
    
    [Column('Riferimento', [], 50)]
    FRiferimento: Nullable<string>;
    
    [Column('Note', [], 255)]
    FNote: Nullable<string>;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdMacroParte', [TColumnProp.Required], 'Id')]
    FIdMacroParte: Proxy<TMacroParte>;
    function GetIdMacroParte: TMacroParte;
    procedure SetIdMacroParte(const Value: TMacroParte);
  public
    property Id: Int64 read FId write FId;
    property DataMovimento: TDateTime read FDataMovimento write FDataMovimento;
    property TipoMovimento: string read FTipoMovimento write FTipoMovimento;
    property Quantita: Integer read FQuantita write FQuantita;
    property Causale: string read FCausale write FCausale;
    property Riferimento: Nullable<string> read FRiferimento write FRiferimento;
    property Note: Nullable<string> read FNote write FNote;
    property IdMacroParte: TMacroParte read GetIdMacroParte write SetIdMacroParte;
  end;
  
  [Entity]
  [Table('OrdiniCliente')]
  [Sequence('GEN_ORDINE_CLIENTE_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TOrdineCliente = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Data', [TColumnProp.Required])]
    FData: TDateTime;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdCliente', [TColumnProp.Required], 'Id')]
    FIdCliente: Proxy<TCliente>;
    
    [ManyValuedAssociation([TAssociationProp.Lazy, TAssociationProp.Required], [TCascadeType.SaveUpdate, TCascadeType.Merge, TCascadeType.Remove], 'FIdOrdine')]
    FRigheOrdineClienteList: Proxy<TList<TRigaOrdineCliente>>;
    function GetIdCliente: TCliente;
    procedure SetIdCliente(const Value: TCliente);
    function GetRigheOrdineClienteList: TList<TRigaOrdineCliente>;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Int64 read FId write FId;
    property Data: TDateTime read FData write FData;
    property IdCliente: TCliente read GetIdCliente write SetIdCliente;
    property RigheOrdineClienteList: TList<TRigaOrdineCliente> read GetRigheOrdineClienteList;
  end;
  
  [Entity]
  [Table('OrdiniFornitore')]
  [UniqueKey('Numero, Anno')]
  [Sequence('GEN_ORDINE_FORNITORE_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TOrdineFornitore = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Numero', [TColumnProp.Required])]
    FNumero: Integer;
    
    [Column('Anno', [TColumnProp.Required])]
    FAnno: Integer;
    
    [Column('DataOrdine', [TColumnProp.Required])]
    FDataOrdine: TDateTime;
    
    [Column('DataConsegnaPrevista', [])]
    FDataConsegnaPrevista: Nullable<TDateTime>;
    
    [Column('Stato', [TColumnProp.Required], 20)]
    FStato: string;
    
    [Column('Note', [], 255)]
    FNote: Nullable<string>;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdFornitore', [TColumnProp.Required], 'ID')]
    FIdFornitore: Proxy<TFornitore>;
    function GetIdFornitore: TFornitore;
    procedure SetIdFornitore(const Value: TFornitore);
  public
    property Id: Int64 read FId write FId;
    property Numero: Integer read FNumero write FNumero;
    property Anno: Integer read FAnno write FAnno;
    property DataOrdine: TDateTime read FDataOrdine write FDataOrdine;
    property DataConsegnaPrevista: Nullable<TDateTime> read FDataConsegnaPrevista write FDataConsegnaPrevista;
    property Stato: string read FStato write FStato;
    property Note: Nullable<string> read FNote write FNote;
    property IdFornitore: TFornitore read GetIdFornitore write SetIdFornitore;
  end;
  
  [Entity]
  [Table('RigheOrdineCliente')]
  [Sequence('GEN_RIGA_ORDINE_CLIENTE_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TRigaOrdineCliente = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('Qta', [TColumnProp.Required])]
    FQta: Integer;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdOrdine', [TColumnProp.Required], 'Id')]
    FIdOrdine: Proxy<TOrdineCliente>;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdLetto', [TColumnProp.Required], 'Id')]
    FIdLetto: Proxy<TLetto>;
    function GetIdOrdine: TOrdineCliente;
    procedure SetIdOrdine(const Value: TOrdineCliente);
    function GetIdLetto: TLetto;
    procedure SetIdLetto(const Value: TLetto);
  public
    property Id: Int64 read FId write FId;
    property Qta: Integer read FQta write FQta;
    property IdOrdine: TOrdineCliente read GetIdOrdine write SetIdOrdine;
    property IdLetto: TLetto read GetIdLetto write SetIdLetto;
  end;
  
  [Entity]
  [Table('RigheOrdineFornitore')]
  [Sequence('GEN_RIGA_ORDINE_FORNITORE_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TRigaOrdineFornitore = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('QuantitaOrdinata', [TColumnProp.Required])]
    FQuantitaOrdinata: Integer;
    
    [Column('QuantitaRicevuta', [TColumnProp.Required])]
    FQuantitaRicevuta: Integer;
    
    [Column('PrezzoUnitario', [], 15, 4)]
    FPrezzoUnitario: Nullable<Double>;
    
    [Column('DataConsegnaPrevista', [])]
    FDataConsegnaPrevista: Nullable<TDateTime>;
    
    [Column('Note', [], 255)]
    FNote: Nullable<string>;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdOrdineFornitore', [TColumnProp.Required], 'Id')]
    FIdOrdineFornitore: Proxy<TOrdineFornitore>;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdMacroParte', [TColumnProp.Required], 'Id')]
    FIdMacroParte: Proxy<TMacroParte>;
    function GetIdOrdineFornitore: TOrdineFornitore;
    procedure SetIdOrdineFornitore(const Value: TOrdineFornitore);
    function GetIdMacroParte: TMacroParte;
    procedure SetIdMacroParte(const Value: TMacroParte);
  public
    property Id: Int64 read FId write FId;
    property QuantitaOrdinata: Integer read FQuantitaOrdinata write FQuantitaOrdinata;
    property QuantitaRicevuta: Integer read FQuantitaRicevuta write FQuantitaRicevuta;
    property PrezzoUnitario: Nullable<Double> read FPrezzoUnitario write FPrezzoUnitario;
    property DataConsegnaPrevista: Nullable<TDateTime> read FDataConsegnaPrevista write FDataConsegnaPrevista;
    property Note: Nullable<string> read FNote write FNote;
    property IdOrdineFornitore: TOrdineFornitore read GetIdOrdineFornitore write SetIdOrdineFornitore;
    property IdMacroParte: TMacroParte read GetIdMacroParte write SetIdMacroParte;
  end;
  
  [Entity]
  [Table('Scorte')]
  [UniqueKey('IdMacroParte')]
  [Sequence('GEN_SCORTA_ID')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TScorta = class
  private
    [Column('Id', [TColumnProp.Required])]
    FId: Int64;
    
    [Column('ScortaMinima', [TColumnProp.Required])]
    FScortaMinima: Integer;
    
    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('IdMacroParte', [TColumnProp.Required], 'Id')]
    FIdMacroParte: Proxy<TMacroParte>;
    function GetIdMacroParte: TMacroParte;
    procedure SetIdMacroParte(const Value: TMacroParte);
  public
    property Id: Int64 read FId write FId;
    property ScortaMinima: Integer read FScortaMinima write FScortaMinima;
    property IdMacroParte: TMacroParte read GetIdMacroParte write SetIdMacroParte;
  end;
  
  IClienteDictionary = interface;
  
  IComponenteDictionary = interface;
  
  IComponenteMacroParteDictionary = interface;
  
  IFornitoreDictionary = interface;
  
  ILettoDictionary = interface;
  
  IMacroParteDictionary = interface;
  
  IMacroParteLettoDictionary = interface;
  
  IMovimentoMagazzinoDictionary = interface;
  
  IOrdineClienteDictionary = interface;
  
  IOrdineFornitoreDictionary = interface;
  
  IRigaOrdineClienteDictionary = interface;
  
  IRigaOrdineFornitoreDictionary = interface;
  
  IScortaDictionary = interface;
  
  IClienteDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Nome: TLinqProjection;
    function Cognome: TLinqProjection;
    function Denominazione: TLinqProjection;
    function Azienda: TLinqProjection;
    function CodiceFiscale: TLinqProjection;
    function PIVA: TLinqProjection;
    function Indirizzo: TLinqProjection;
    function Civico: TLinqProjection;
    function CAP: TLinqProjection;
    function Citta: TLinqProjection;
    function Provincia: TLinqProjection;
    function Telefono: TLinqProjection;
    function OrdiniClienteList: IOrdineClienteDictionary;
  end;
  
  IComponenteDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Codice: TLinqProjection;
    function Descrizione: TLinqProjection;
  end;
  
  IComponenteMacroParteDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Quantity: TLinqProjection;
    function IdMacroParte: IMacroParteDictionary;
    function IdComponente: IComponenteDictionary;
  end;
  
  IFornitoreDictionary = interface(IAureliusEntityDictionary)
    function ID: TLinqProjection;
    function Codice: TLinqProjection;
    function RagioneSociale: TLinqProjection;
    function PartitaIVA: TLinqProjection;
    function Indirizzo: TLinqProjection;
    function CAP: TLinqProjection;
    function Citta: TLinqProjection;
    function Provincia: TLinqProjection;
    function Telefono: TLinqProjection;
    function Email: TLinqProjection;
    function Note: TLinqProjection;
    function Attivo: TLinqProjection;
  end;
  
  ILettoDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Codice: TLinqProjection;
    function Descrizione: TLinqProjection;
    function Modello: TLinqProjection;
    function MacroPartiLettoList: IMacroParteLettoDictionary;
  end;
  
  IMacroParteDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Codice: TLinqProjection;
    function Descrizione: TLinqProjection;
    function ComponentiMacroParteList: IComponenteMacroParteDictionary;
    function ScorteList: IScortaDictionary;
  end;
  
  IMacroParteLettoDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Quantity: TLinqProjection;
    function IdLetto: ILettoDictionary;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  IMovimentoMagazzinoDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function DataMovimento: TLinqProjection;
    function TipoMovimento: TLinqProjection;
    function Quantita: TLinqProjection;
    function Causale: TLinqProjection;
    function Riferimento: TLinqProjection;
    function Note: TLinqProjection;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  IOrdineClienteDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Data: TLinqProjection;
    function IdCliente: IClienteDictionary;
    function RigheOrdineClienteList: IRigaOrdineClienteDictionary;
  end;
  
  IOrdineFornitoreDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Numero: TLinqProjection;
    function Anno: TLinqProjection;
    function DataOrdine: TLinqProjection;
    function DataConsegnaPrevista: TLinqProjection;
    function Stato: TLinqProjection;
    function Note: TLinqProjection;
    function IdFornitore: IFornitoreDictionary;
  end;
  
  IRigaOrdineClienteDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function Qta: TLinqProjection;
    function IdOrdine: IOrdineClienteDictionary;
    function IdLetto: ILettoDictionary;
  end;
  
  IRigaOrdineFornitoreDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function QuantitaOrdinata: TLinqProjection;
    function QuantitaRicevuta: TLinqProjection;
    function PrezzoUnitario: TLinqProjection;
    function DataConsegnaPrevista: TLinqProjection;
    function Note: TLinqProjection;
    function IdOrdineFornitore: IOrdineFornitoreDictionary;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  IScortaDictionary = interface(IAureliusEntityDictionary)
    function Id: TLinqProjection;
    function ScortaMinima: TLinqProjection;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  TClienteDictionary = class(TAureliusEntityDictionary, IClienteDictionary)
  public
    function Id: TLinqProjection;
    function Nome: TLinqProjection;
    function Cognome: TLinqProjection;
    function Denominazione: TLinqProjection;
    function Azienda: TLinqProjection;
    function CodiceFiscale: TLinqProjection;
    function PIVA: TLinqProjection;
    function Indirizzo: TLinqProjection;
    function Civico: TLinqProjection;
    function CAP: TLinqProjection;
    function Citta: TLinqProjection;
    function Provincia: TLinqProjection;
    function Telefono: TLinqProjection;
    function OrdiniClienteList: IOrdineClienteDictionary;
  end;
  
  TComponenteDictionary = class(TAureliusEntityDictionary, IComponenteDictionary)
  public
    function Id: TLinqProjection;
    function Codice: TLinqProjection;
    function Descrizione: TLinqProjection;
  end;
  
  TComponenteMacroParteDictionary = class(TAureliusEntityDictionary, IComponenteMacroParteDictionary)
  public
    function Id: TLinqProjection;
    function Quantity: TLinqProjection;
    function IdMacroParte: IMacroParteDictionary;
    function IdComponente: IComponenteDictionary;
  end;
  
  TFornitoreDictionary = class(TAureliusEntityDictionary, IFornitoreDictionary)
  public
    function ID: TLinqProjection;
    function Codice: TLinqProjection;
    function RagioneSociale: TLinqProjection;
    function PartitaIVA: TLinqProjection;
    function Indirizzo: TLinqProjection;
    function CAP: TLinqProjection;
    function Citta: TLinqProjection;
    function Provincia: TLinqProjection;
    function Telefono: TLinqProjection;
    function Email: TLinqProjection;
    function Note: TLinqProjection;
    function Attivo: TLinqProjection;
  end;
  
  TLettoDictionary = class(TAureliusEntityDictionary, ILettoDictionary)
  public
    function Id: TLinqProjection;
    function Codice: TLinqProjection;
    function Descrizione: TLinqProjection;
    function Modello: TLinqProjection;
    function MacroPartiLettoList: IMacroParteLettoDictionary;
  end;
  
  TMacroParteDictionary = class(TAureliusEntityDictionary, IMacroParteDictionary)
  public
    function Id: TLinqProjection;
    function Codice: TLinqProjection;
    function Descrizione: TLinqProjection;
    function ComponentiMacroParteList: IComponenteMacroParteDictionary;
    function ScorteList: IScortaDictionary;
  end;
  
  TMacroParteLettoDictionary = class(TAureliusEntityDictionary, IMacroParteLettoDictionary)
  public
    function Id: TLinqProjection;
    function Quantity: TLinqProjection;
    function IdLetto: ILettoDictionary;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  TMovimentoMagazzinoDictionary = class(TAureliusEntityDictionary, IMovimentoMagazzinoDictionary)
  public
    function Id: TLinqProjection;
    function DataMovimento: TLinqProjection;
    function TipoMovimento: TLinqProjection;
    function Quantita: TLinqProjection;
    function Causale: TLinqProjection;
    function Riferimento: TLinqProjection;
    function Note: TLinqProjection;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  TOrdineClienteDictionary = class(TAureliusEntityDictionary, IOrdineClienteDictionary)
  public
    function Id: TLinqProjection;
    function Data: TLinqProjection;
    function IdCliente: IClienteDictionary;
    function RigheOrdineClienteList: IRigaOrdineClienteDictionary;
  end;
  
  TOrdineFornitoreDictionary = class(TAureliusEntityDictionary, IOrdineFornitoreDictionary)
  public
    function Id: TLinqProjection;
    function Numero: TLinqProjection;
    function Anno: TLinqProjection;
    function DataOrdine: TLinqProjection;
    function DataConsegnaPrevista: TLinqProjection;
    function Stato: TLinqProjection;
    function Note: TLinqProjection;
    function IdFornitore: IFornitoreDictionary;
  end;
  
  TRigaOrdineClienteDictionary = class(TAureliusEntityDictionary, IRigaOrdineClienteDictionary)
  public
    function Id: TLinqProjection;
    function Qta: TLinqProjection;
    function IdOrdine: IOrdineClienteDictionary;
    function IdLetto: ILettoDictionary;
  end;
  
  TRigaOrdineFornitoreDictionary = class(TAureliusEntityDictionary, IRigaOrdineFornitoreDictionary)
  public
    function Id: TLinqProjection;
    function QuantitaOrdinata: TLinqProjection;
    function QuantitaRicevuta: TLinqProjection;
    function PrezzoUnitario: TLinqProjection;
    function DataConsegnaPrevista: TLinqProjection;
    function Note: TLinqProjection;
    function IdOrdineFornitore: IOrdineFornitoreDictionary;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  TScortaDictionary = class(TAureliusEntityDictionary, IScortaDictionary)
  public
    function Id: TLinqProjection;
    function ScortaMinima: TLinqProjection;
    function IdMacroParte: IMacroParteDictionary;
  end;
  
  IDictionary = interface(IAureliusDictionary)
    function Cliente: IClienteDictionary;
    function Componente: IComponenteDictionary;
    function ComponenteMacroParte: IComponenteMacroParteDictionary;
    function Fornitore: IFornitoreDictionary;
    function Letto: ILettoDictionary;
    function MacroParte: IMacroParteDictionary;
    function MacroParteLetto: IMacroParteLettoDictionary;
    function MovimentoMagazzino: IMovimentoMagazzinoDictionary;
    function OrdineCliente: IOrdineClienteDictionary;
    function OrdineFornitore: IOrdineFornitoreDictionary;
    function RigaOrdineCliente: IRigaOrdineClienteDictionary;
    function RigaOrdineFornitore: IRigaOrdineFornitoreDictionary;
    function Scorta: IScortaDictionary;
  end;
  
  TDictionary = class(TAureliusDictionary, IDictionary)
  public
    function Cliente: IClienteDictionary;
    function Componente: IComponenteDictionary;
    function ComponenteMacroParte: IComponenteMacroParteDictionary;
    function Fornitore: IFornitoreDictionary;
    function Letto: ILettoDictionary;
    function MacroParte: IMacroParteDictionary;
    function MacroParteLetto: IMacroParteLettoDictionary;
    function MovimentoMagazzino: IMovimentoMagazzinoDictionary;
    function OrdineCliente: IOrdineClienteDictionary;
    function OrdineFornitore: IOrdineFornitoreDictionary;
    function RigaOrdineCliente: IRigaOrdineClienteDictionary;
    function RigaOrdineFornitore: IRigaOrdineFornitoreDictionary;
    function Scorta: IScortaDictionary;
  end;
  
function Dic: IDictionary;

implementation

var
  __Dic: IDictionary;

function Dic: IDictionary;
begin
  if __Dic = nil then __Dic := TDictionary.Create;
  result := __Dic;
end;

{ TCliente }

constructor TCliente.Create;
begin
  inherited;
  FOrdiniClienteList.SetInitialValue(TList<TOrdineCliente>.Create);
end;

destructor TCliente.Destroy;
begin
  FOrdiniClienteList.DestroyValue;
  inherited;
end;

function TCliente.GetOrdiniClienteList: TList<TOrdineCliente>;
begin
  result := FOrdiniClienteList.Value;
end;

{ TComponenteMacroParte }

function TComponenteMacroParte.GetIdMacroParte: TMacroParte;
begin
  result := FIdMacroParte.Value;
end;

procedure TComponenteMacroParte.SetIdMacroParte(const Value: TMacroParte);
begin
  FIdMacroParte.Value := Value;
end;

function TComponenteMacroParte.GetIdComponente: TComponente;
begin
  result := FIdComponente.Value;
end;

procedure TComponenteMacroParte.SetIdComponente(const Value: TComponente);
begin
  FIdComponente.Value := Value;
end;

{ TLetto }

constructor TLetto.Create;
begin
  inherited;
  FMacroPartiLettoList.SetInitialValue(TList<TMacroParteLetto>.Create);
end;

destructor TLetto.Destroy;
begin
  FMacroPartiLettoList.DestroyValue;
  inherited;
end;

function TLetto.GetMacroPartiLettoList: TList<TMacroParteLetto>;
begin
  result := FMacroPartiLettoList.Value;
end;

{ TMacroParte }

constructor TMacroParte.Create;
begin
  inherited;
  FComponentiMacroParteList.SetInitialValue(TList<TComponenteMacroParte>.Create);
  FScorteList.SetInitialValue(TList<TScorta>.Create);
end;

destructor TMacroParte.Destroy;
begin
  FScorteList.DestroyValue;
  FComponentiMacroParteList.DestroyValue;
  inherited;
end;

function TMacroParte.GetComponentiMacroParteList: TList<TComponenteMacroParte>;
begin
  result := FComponentiMacroParteList.Value;
end;

function TMacroParte.GetScorteList: TList<TScorta>;
begin
  result := FScorteList.Value;
end;

{ TMacroParteLetto }

function TMacroParteLetto.GetIdLetto: TLetto;
begin
  result := FIdLetto.Value;
end;

procedure TMacroParteLetto.SetIdLetto(const Value: TLetto);
begin
  FIdLetto.Value := Value;
end;

function TMacroParteLetto.GetIdMacroParte: TMacroParte;
begin
  result := FIdMacroParte.Value;
end;

procedure TMacroParteLetto.SetIdMacroParte(const Value: TMacroParte);
begin
  FIdMacroParte.Value := Value;
end;

{ TMovimentoMagazzino }

function TMovimentoMagazzino.GetIdMacroParte: TMacroParte;
begin
  result := FIdMacroParte.Value;
end;

procedure TMovimentoMagazzino.SetIdMacroParte(const Value: TMacroParte);
begin
  FIdMacroParte.Value := Value;
end;

{ TOrdineCliente }

function TOrdineCliente.GetIdCliente: TCliente;
begin
  result := FIdCliente.Value;
end;

procedure TOrdineCliente.SetIdCliente(const Value: TCliente);
begin
  FIdCliente.Value := Value;
end;

constructor TOrdineCliente.Create;
begin
  inherited;
  FRigheOrdineClienteList.SetInitialValue(TList<TRigaOrdineCliente>.Create);
end;

destructor TOrdineCliente.Destroy;
begin
  FRigheOrdineClienteList.DestroyValue;
  inherited;
end;

function TOrdineCliente.GetRigheOrdineClienteList: TList<TRigaOrdineCliente>;
begin
  result := FRigheOrdineClienteList.Value;
end;

{ TOrdineFornitore }

function TOrdineFornitore.GetIdFornitore: TFornitore;
begin
  result := FIdFornitore.Value;
end;

procedure TOrdineFornitore.SetIdFornitore(const Value: TFornitore);
begin
  FIdFornitore.Value := Value;
end;

{ TRigaOrdineCliente }

function TRigaOrdineCliente.GetIdOrdine: TOrdineCliente;
begin
  result := FIdOrdine.Value;
end;

procedure TRigaOrdineCliente.SetIdOrdine(const Value: TOrdineCliente);
begin
  FIdOrdine.Value := Value;
end;

function TRigaOrdineCliente.GetIdLetto: TLetto;
begin
  result := FIdLetto.Value;
end;

procedure TRigaOrdineCliente.SetIdLetto(const Value: TLetto);
begin
  FIdLetto.Value := Value;
end;

{ TRigaOrdineFornitore }

function TRigaOrdineFornitore.GetIdOrdineFornitore: TOrdineFornitore;
begin
  result := FIdOrdineFornitore.Value;
end;

procedure TRigaOrdineFornitore.SetIdOrdineFornitore(const Value: TOrdineFornitore);
begin
  FIdOrdineFornitore.Value := Value;
end;

function TRigaOrdineFornitore.GetIdMacroParte: TMacroParte;
begin
  result := FIdMacroParte.Value;
end;

procedure TRigaOrdineFornitore.SetIdMacroParte(const Value: TMacroParte);
begin
  FIdMacroParte.Value := Value;
end;

{ TScorta }

function TScorta.GetIdMacroParte: TMacroParte;
begin
  result := FIdMacroParte.Value;
end;

procedure TScorta.SetIdMacroParte(const Value: TMacroParte);
begin
  FIdMacroParte.Value := Value;
end;

{ TClienteDictionary }

function TClienteDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TClienteDictionary.Nome: TLinqProjection;
begin
  Result := Prop('Nome');
end;

function TClienteDictionary.Cognome: TLinqProjection;
begin
  Result := Prop('Cognome');
end;

function TClienteDictionary.Denominazione: TLinqProjection;
begin
  Result := Prop('Denominazione');
end;

function TClienteDictionary.Azienda: TLinqProjection;
begin
  Result := Prop('Azienda');
end;

function TClienteDictionary.CodiceFiscale: TLinqProjection;
begin
  Result := Prop('CodiceFiscale');
end;

function TClienteDictionary.PIVA: TLinqProjection;
begin
  Result := Prop('PIVA');
end;

function TClienteDictionary.Indirizzo: TLinqProjection;
begin
  Result := Prop('Indirizzo');
end;

function TClienteDictionary.Civico: TLinqProjection;
begin
  Result := Prop('Civico');
end;

function TClienteDictionary.CAP: TLinqProjection;
begin
  Result := Prop('CAP');
end;

function TClienteDictionary.Citta: TLinqProjection;
begin
  Result := Prop('Citta');
end;

function TClienteDictionary.Provincia: TLinqProjection;
begin
  Result := Prop('Provincia');
end;

function TClienteDictionary.Telefono: TLinqProjection;
begin
  Result := Prop('Telefono');
end;

function TClienteDictionary.OrdiniClienteList: IOrdineClienteDictionary;
begin
  Result := TOrdineClienteDictionary.Create(PropName('OrdiniClienteList'));
end;

{ TComponenteDictionary }

function TComponenteDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TComponenteDictionary.Codice: TLinqProjection;
begin
  Result := Prop('Codice');
end;

function TComponenteDictionary.Descrizione: TLinqProjection;
begin
  Result := Prop('Descrizione');
end;

{ TComponenteMacroParteDictionary }

function TComponenteMacroParteDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TComponenteMacroParteDictionary.Quantity: TLinqProjection;
begin
  Result := Prop('Quantity');
end;

function TComponenteMacroParteDictionary.IdMacroParte: IMacroParteDictionary;
begin
  Result := TMacroParteDictionary.Create(PropName('IdMacroParte'));
end;

function TComponenteMacroParteDictionary.IdComponente: IComponenteDictionary;
begin
  Result := TComponenteDictionary.Create(PropName('IdComponente'));
end;

{ TFornitoreDictionary }

function TFornitoreDictionary.ID: TLinqProjection;
begin
  Result := Prop('ID');
end;

function TFornitoreDictionary.Codice: TLinqProjection;
begin
  Result := Prop('Codice');
end;

function TFornitoreDictionary.RagioneSociale: TLinqProjection;
begin
  Result := Prop('RagioneSociale');
end;

function TFornitoreDictionary.PartitaIVA: TLinqProjection;
begin
  Result := Prop('PartitaIVA');
end;

function TFornitoreDictionary.Indirizzo: TLinqProjection;
begin
  Result := Prop('Indirizzo');
end;

function TFornitoreDictionary.CAP: TLinqProjection;
begin
  Result := Prop('CAP');
end;

function TFornitoreDictionary.Citta: TLinqProjection;
begin
  Result := Prop('Citta');
end;

function TFornitoreDictionary.Provincia: TLinqProjection;
begin
  Result := Prop('Provincia');
end;

function TFornitoreDictionary.Telefono: TLinqProjection;
begin
  Result := Prop('Telefono');
end;

function TFornitoreDictionary.Email: TLinqProjection;
begin
  Result := Prop('Email');
end;

function TFornitoreDictionary.Note: TLinqProjection;
begin
  Result := Prop('Note');
end;

function TFornitoreDictionary.Attivo: TLinqProjection;
begin
  Result := Prop('Attivo');
end;

{ TLettoDictionary }

function TLettoDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TLettoDictionary.Codice: TLinqProjection;
begin
  Result := Prop('Codice');
end;

function TLettoDictionary.Descrizione: TLinqProjection;
begin
  Result := Prop('Descrizione');
end;

function TLettoDictionary.Modello: TLinqProjection;
begin
  Result := Prop('Modello');
end;

function TLettoDictionary.MacroPartiLettoList: IMacroParteLettoDictionary;
begin
  Result := TMacroParteLettoDictionary.Create(PropName('MacroPartiLettoList'));
end;

{ TMacroParteDictionary }

function TMacroParteDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TMacroParteDictionary.Codice: TLinqProjection;
begin
  Result := Prop('Codice');
end;

function TMacroParteDictionary.Descrizione: TLinqProjection;
begin
  Result := Prop('Descrizione');
end;

function TMacroParteDictionary.ComponentiMacroParteList: IComponenteMacroParteDictionary;
begin
  Result := TComponenteMacroParteDictionary.Create(PropName('ComponentiMacroParteList'));
end;

function TMacroParteDictionary.ScorteList: IScortaDictionary;
begin
  Result := TScortaDictionary.Create(PropName('ScorteList'));
end;

{ TMacroParteLettoDictionary }

function TMacroParteLettoDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TMacroParteLettoDictionary.Quantity: TLinqProjection;
begin
  Result := Prop('Quantity');
end;

function TMacroParteLettoDictionary.IdLetto: ILettoDictionary;
begin
  Result := TLettoDictionary.Create(PropName('IdLetto'));
end;

function TMacroParteLettoDictionary.IdMacroParte: IMacroParteDictionary;
begin
  Result := TMacroParteDictionary.Create(PropName('IdMacroParte'));
end;

{ TMovimentoMagazzinoDictionary }

function TMovimentoMagazzinoDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TMovimentoMagazzinoDictionary.DataMovimento: TLinqProjection;
begin
  Result := Prop('DataMovimento');
end;

function TMovimentoMagazzinoDictionary.TipoMovimento: TLinqProjection;
begin
  Result := Prop('TipoMovimento');
end;

function TMovimentoMagazzinoDictionary.Quantita: TLinqProjection;
begin
  Result := Prop('Quantita');
end;

function TMovimentoMagazzinoDictionary.Causale: TLinqProjection;
begin
  Result := Prop('Causale');
end;

function TMovimentoMagazzinoDictionary.Riferimento: TLinqProjection;
begin
  Result := Prop('Riferimento');
end;

function TMovimentoMagazzinoDictionary.Note: TLinqProjection;
begin
  Result := Prop('Note');
end;

function TMovimentoMagazzinoDictionary.IdMacroParte: IMacroParteDictionary;
begin
  Result := TMacroParteDictionary.Create(PropName('IdMacroParte'));
end;

{ TOrdineClienteDictionary }

function TOrdineClienteDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TOrdineClienteDictionary.Data: TLinqProjection;
begin
  Result := Prop('Data');
end;

function TOrdineClienteDictionary.IdCliente: IClienteDictionary;
begin
  Result := TClienteDictionary.Create(PropName('IdCliente'));
end;

function TOrdineClienteDictionary.RigheOrdineClienteList: IRigaOrdineClienteDictionary;
begin
  Result := TRigaOrdineClienteDictionary.Create(PropName('RigheOrdineClienteList'));
end;

{ TOrdineFornitoreDictionary }

function TOrdineFornitoreDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TOrdineFornitoreDictionary.Numero: TLinqProjection;
begin
  Result := Prop('Numero');
end;

function TOrdineFornitoreDictionary.Anno: TLinqProjection;
begin
  Result := Prop('Anno');
end;

function TOrdineFornitoreDictionary.DataOrdine: TLinqProjection;
begin
  Result := Prop('DataOrdine');
end;

function TOrdineFornitoreDictionary.DataConsegnaPrevista: TLinqProjection;
begin
  Result := Prop('DataConsegnaPrevista');
end;

function TOrdineFornitoreDictionary.Stato: TLinqProjection;
begin
  Result := Prop('Stato');
end;

function TOrdineFornitoreDictionary.Note: TLinqProjection;
begin
  Result := Prop('Note');
end;

function TOrdineFornitoreDictionary.IdFornitore: IFornitoreDictionary;
begin
  Result := TFornitoreDictionary.Create(PropName('IdFornitore'));
end;

{ TRigaOrdineClienteDictionary }

function TRigaOrdineClienteDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TRigaOrdineClienteDictionary.Qta: TLinqProjection;
begin
  Result := Prop('Qta');
end;

function TRigaOrdineClienteDictionary.IdOrdine: IOrdineClienteDictionary;
begin
  Result := TOrdineClienteDictionary.Create(PropName('IdOrdine'));
end;

function TRigaOrdineClienteDictionary.IdLetto: ILettoDictionary;
begin
  Result := TLettoDictionary.Create(PropName('IdLetto'));
end;

{ TRigaOrdineFornitoreDictionary }

function TRigaOrdineFornitoreDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TRigaOrdineFornitoreDictionary.QuantitaOrdinata: TLinqProjection;
begin
  Result := Prop('QuantitaOrdinata');
end;

function TRigaOrdineFornitoreDictionary.QuantitaRicevuta: TLinqProjection;
begin
  Result := Prop('QuantitaRicevuta');
end;

function TRigaOrdineFornitoreDictionary.PrezzoUnitario: TLinqProjection;
begin
  Result := Prop('PrezzoUnitario');
end;

function TRigaOrdineFornitoreDictionary.DataConsegnaPrevista: TLinqProjection;
begin
  Result := Prop('DataConsegnaPrevista');
end;

function TRigaOrdineFornitoreDictionary.Note: TLinqProjection;
begin
  Result := Prop('Note');
end;

function TRigaOrdineFornitoreDictionary.IdOrdineFornitore: IOrdineFornitoreDictionary;
begin
  Result := TOrdineFornitoreDictionary.Create(PropName('IdOrdineFornitore'));
end;

function TRigaOrdineFornitoreDictionary.IdMacroParte: IMacroParteDictionary;
begin
  Result := TMacroParteDictionary.Create(PropName('IdMacroParte'));
end;

{ TScortaDictionary }

function TScortaDictionary.Id: TLinqProjection;
begin
  Result := Prop('Id');
end;

function TScortaDictionary.ScortaMinima: TLinqProjection;
begin
  Result := Prop('ScortaMinima');
end;

function TScortaDictionary.IdMacroParte: IMacroParteDictionary;
begin
  Result := TMacroParteDictionary.Create(PropName('IdMacroParte'));
end;

{ TDictionary }

function TDictionary.Cliente: IClienteDictionary;
begin
  Result := TClienteDictionary.Create;
end;

function TDictionary.Componente: IComponenteDictionary;
begin
  Result := TComponenteDictionary.Create;
end;

function TDictionary.ComponenteMacroParte: IComponenteMacroParteDictionary;
begin
  Result := TComponenteMacroParteDictionary.Create;
end;

function TDictionary.Fornitore: IFornitoreDictionary;
begin
  Result := TFornitoreDictionary.Create;
end;

function TDictionary.Letto: ILettoDictionary;
begin
  Result := TLettoDictionary.Create;
end;

function TDictionary.MacroParte: IMacroParteDictionary;
begin
  Result := TMacroParteDictionary.Create;
end;

function TDictionary.MacroParteLetto: IMacroParteLettoDictionary;
begin
  Result := TMacroParteLettoDictionary.Create;
end;

function TDictionary.MovimentoMagazzino: IMovimentoMagazzinoDictionary;
begin
  Result := TMovimentoMagazzinoDictionary.Create;
end;

function TDictionary.OrdineCliente: IOrdineClienteDictionary;
begin
  Result := TOrdineClienteDictionary.Create;
end;

function TDictionary.OrdineFornitore: IOrdineFornitoreDictionary;
begin
  Result := TOrdineFornitoreDictionary.Create;
end;

function TDictionary.RigaOrdineCliente: IRigaOrdineClienteDictionary;
begin
  Result := TRigaOrdineClienteDictionary.Create;
end;

function TDictionary.RigaOrdineFornitore: IRigaOrdineFornitoreDictionary;
begin
  Result := TRigaOrdineFornitoreDictionary.Create;
end;

function TDictionary.Scorta: IScortaDictionary;
begin
  Result := TScortaDictionary.Create;
end;

initialization
  RegisterEntity(TLetto);
  RegisterEntity(TMacroParte);
  RegisterEntity(TComponente);
  RegisterEntity(TMacroParteLetto);
  RegisterEntity(TComponenteMacroParte);
  RegisterEntity(TScorta);
  RegisterEntity(TMovimentoMagazzino);
  RegisterEntity(TFornitore);
  RegisterEntity(TOrdineFornitore);
  RegisterEntity(TRigaOrdineFornitore);
  RegisterEntity(TCliente);
  RegisterEntity(TOrdineCliente);
  RegisterEntity(TRigaOrdineCliente);

end.
