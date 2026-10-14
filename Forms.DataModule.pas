unit Forms.DataModule;

interface

uses
  System.SysUtils, System.Classes, Aurelius.Sql.Firebird,
  Aurelius.Schema.Firebird, Aurelius.Drivers.UniDac,
  Aurelius.Engine.ObjectManager, Aurelius.Linq, Data.DB, DBAccess, Uni,
  Aurelius.Comp.Manager, Aurelius.Comp.Connection,InterBaseUniProvider,
  Aurelius.Drivers.FireDac, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.model,
  Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset ;

type
  TDM = class(TDataModule)
    AureliusConnection1: TAureliusConnection;
    ObjMgr: TAureliusManager;
    FDConnection1: TFDConnection;
    dsLetti: TAureliusDataset;
    dsMacroPartiLetto: TAureliusDataset;
    srcLetti: TDataSource;
    srcMacroPartiLetto: TDataSource;
    dsLettiCodice: TStringField;
    dsLettiModello: TStringField;
    dsLettiDescrizione: TStringField;
    dsMacroParti: TAureliusDataset;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    srcMacroParti: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }

    FModelDbErrors : TStringList;
    function GetDbFile : string;
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
Aurelius.Engine.DatabaseManager,Aurelius.Schema.Messages;

procedure TDM.DataModuleCreate(Sender: TObject);
var
 DBMngr : TDatabaseManager;
// I : integer;

 Err: TSchemaError;
 DatabaseName : string;
begin


   DBMngr := TDatabaseManager.Create(AureliusConnection1.CreateConnection);
   try
   if not DBMngr.ValidateDatabase then
   begin
     FModelDbErrors := TStringList.Create;
 for Err in DBMngr.Errors do
  begin
    // Si usa .Text al posto di .Message
    FModelDbErrors.Add(Err.Text);
  end;
   end;


    DatabaseName := GetDbFile;
    if not FileExists(DatabaseName) then
    DBMngr.BuildDatabase
    else
    DBMngr.UpdateDatabase

   finally
     DBMngr.Free
   end;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
     if assigned(FModelDbErrors) then
     FreeAndNil(FModelDbErrors)

end;

function TDM.GetDbFile: string;
begin
 result :=  FDConnection1.Params.Values['Database']
end;

end.
