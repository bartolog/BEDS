object DM: TDM
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object AureliusConnection1: TAureliusConnection
    AdapterName = 'FireDac'
    AdaptedConnection = FDConnection1
    SQLDialect = 'Firebird'
    Left = 192
    Top = 136
  end
  object ObjMgr: TAureliusManager
    Connection = AureliusConnection1
    Left = 184
    Top = 312
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Bartolo\Documents\Embarcadero\Studio\Projects\' +
        'Desktop application\BEDS\DB\BEDS.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    Left = 208
    Top = 224
  end
  object dsLetti: TAureliusDataset
    FieldDefs = <
      item
        Name = 'Codice'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Modello'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Descrizione'
        DataType = ftString
        Size = 20
      end>
    Left = 408
    Top = 184
    object dsLettiCodice: TStringField
      FieldName = 'Codice'
      Size = 15
    end
    object dsLettiModello: TStringField
      FieldName = 'Modello'
      Size = 25
    end
    object dsLettiDescrizione: TStringField
      FieldName = 'Descrizione'
      Size = 80
    end
  end
  object dsMacroPartiLetto: TAureliusDataset
    FieldDefs = <>
    Left = 408
    Top = 272
  end
  object srcLetti: TDataSource
    DataSet = dsLetti
    Left = 464
    Top = 184
  end
  object srcMacroPartiLetto: TDataSource
    DataSet = dsMacroPartiLetto
    Left = 520
    Top = 272
  end
  object dsMacroParti: TAureliusDataset
    FieldDefs = <
      item
        Name = 'Codice'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Modello'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Descrizione'
        DataType = ftString
        Size = 20
      end>
    Left = 304
    Top = 48
    object StringField1: TStringField
      FieldName = 'Codice'
      Size = 15
    end
    object StringField2: TStringField
      FieldName = 'Modello'
      Size = 25
    end
    object StringField3: TStringField
      FieldName = 'Descrizione'
      Size = 80
    end
  end
  object srcMacroParti: TDataSource
    DataSet = dsMacroParti
    Left = 400
    Top = 48
  end
end
