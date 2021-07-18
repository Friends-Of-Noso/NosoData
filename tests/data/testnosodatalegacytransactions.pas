unit TestNosoDataLegacyTransactions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Transactions
;

type
{ TTestNosoDataLegacyTransactions }
  TTestNosoDataLegacyTransactions = class(TTestCase)
  private
    FTransactions: TLegacyTransactions;
  protected
  public
  published
    procedure TestNosoDataLegacyTransactionsCreate;
  end;

implementation

{ TTestNosoDataLegacyTransactions }

procedure TTestNosoDataLegacyTransactions.TestNosoDataLegacyTransactionsCreate;
begin
  FTransactions:= TLegacyTransactions.Create;
  AssertEquals('Noso Legacy Transactions Count is 0', 0, FTransactions.Count);
  FTransactions.Free;
end;

initialization
  RegisterTest(TTestNosoDataLegacyTransactions);
end.

