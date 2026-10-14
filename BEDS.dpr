program BEDS;

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EResourceStrings,
  EDebugJCL,
  EDebugExports,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EBase,
  EExtraExceptionInfo,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  Vcl.Forms,
  Data.model in 'Data.model.pas',
  Forms.DataModule in 'Forms.DataModule.pas' {DM: TDataModule},
  Forms.Main in 'Forms.Main.pas' {fMain},
  BEDS.dxSettings in 'BEDS.dxSettings.pas',
  Frames.Dashboard in 'Frames.Dashboard.pas' {fraDashboard: TFrame},
  Frames.MacroParti in 'Frames.MacroParti.pas' {fraMacroParti: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.



