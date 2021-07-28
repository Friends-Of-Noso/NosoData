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
, TestNosoDataLegacyBlocks
, TestNosoDataLegacyBlock
, TestNosoDataLegacyTransactions
, TestNosoDataLegacyTransaction
, TestNosoDataLegacyWallet
, TestNosoDataLegacyAddress
;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

