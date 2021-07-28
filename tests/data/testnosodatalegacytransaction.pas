unit TestNosoDataLegacyTransaction;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
//, Noso.Data.Legacy.Block
, Noso.Data.Legacy.Transaction
;

type
{ TTestNosoDataLegacyTransaction }
  TTestNosoDataLegacyTransaction = class(TTestCase)
  private
    FTransaction: TLegacyTransaction;

    procedure CheckFieldsCreate;
  protected
  public
  published
    procedure TestNosoDataLegacyTransactionCreate;
  end;

implementation

//const
//  cTestDataFolder =
//    '..'+DirectorySeparator+
//    'tests'+DirectorySeparator+
//    'test-data'+DirectorySeparator+
//    'NOSODATA'+DirectorySeparator+
//    'BLOCKS'+DirectorySeparator;

{ TTestNosoDataLegacyTransaction }

procedure TTestNosoDataLegacyTransaction.CheckFieldsCreate;
begin
  AssertEquals('Noso Legacy Transaction Block is -1', -1, FTransaction.Block);
  AssertEquals('Noso Legacy Transaction OrderID is empty', EmptyStr, FTransaction.OrderID);
  AssertEquals('Noso Legacy Transaction OrderLines is -1', -1, FTransaction.OrderLines);
  AssertEquals('Noso Legacy Transaction OrderType is empty', EmptyStr, FTransaction.OrderType);
  AssertEquals('Noso Legacy Transaction TimeStamp is -1', -1, FTransaction.TimeStamp);
  AssertEquals('Noso Legacy Transaction Reference is empty', EmptyStr, FTransaction.Reference);
  AssertEquals('Noso Legacy Transaction TrxLine is -1', -1, FTransaction.TrxLine);
  AssertEquals('Noso Legacy Transaction Sender is empty', EmptyStr, FTransaction.Sender);
  AssertEquals('Noso Legacy Transaction Address is empty', EmptyStr, FTransaction.Address);
  AssertEquals('Noso Legacy Transaction Receiver is empty', EmptyStr, FTransaction.Receiver);
  AssertEquals('Noso Legacy Transaction AmountFee is 0', 0, FTransaction.AmountFee);
  AssertEquals('Noso Legacy Transaction AmountTrf is 0', 0, FTransaction.AmountTrf);
  AssertEquals('Noso Legacy Transaction Signature is empty', EmptyStr, FTransaction.Signature);
  AssertEquals('Noso Legacy Transaction TrfrID is empty', EmptyStr, FTransaction.TrfrID);
end;

procedure TTestNosoDataLegacyTransaction.TestNosoDataLegacyTransactionCreate;
begin
  FTransaction:= TLegacyTransaction.Create;
  try
    CheckFieldsCreate;
  finally
    FTransaction.Free;
  end;
end;

initialization
  RegisterTest(TTestNosoDataLegacyTransaction);
end.

