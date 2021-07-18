program TestNosoDataGUI;

{$mode objfpc}{$H+}

uses
  Interfaces
, Forms
, GuiTestRunner
, TestNosoDataBlocks
, TestNosoDataBlock
, TestNosoDataOperations
, TestNosoDataOperation
, TestNosoDataLegacyBlock
, TestNosoDataLegacyTransactions
, TestNosoDataLegacyTransaction
;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

