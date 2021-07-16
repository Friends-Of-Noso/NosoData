program TestNosoDataGUI;

{$mode objfpc}{$H+}

uses
  Interfaces
, Forms
, GuiTestRunner
, TestNosoDataBlock
, TestNosoDataOperations
, TestNosoDataOperation
;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

