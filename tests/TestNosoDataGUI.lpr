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
, TestNosoDataLegacyTransaction
;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

