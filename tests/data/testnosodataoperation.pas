unit TestNosoDataOperation;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
, {testutils,} testregistry
, Noso.Data.Operation
;

type

  TNosoDataOperation= class(TTestCase)
  private
    FOperation: TOperation;
  protected
  public
  published
    procedure TestNosoDataOperationCreate;
  end;

implementation

procedure TNosoDataOperation.TestNosoDataOperationCreate;
begin
  FOperation:= TOperation.Create;
  AssertEquals('Noso Operation is type unknown', ord(otUnknown), ord(FOperation.OperationType));
  FOperation.Free;
end;



initialization

  RegisterTest(TNosoDataOperation);
end.

