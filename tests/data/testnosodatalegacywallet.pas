unit TestNosoDataLegacyWallet;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Wallet
;

type

{ TTestNosoDataLegacyWallet }
  TTestNosoDataLegacyWallet= class(TTestCase)
  private
    FLegacyWallet: TLegacyWallet;

    procedure CheckFieldsCreate;
  protected
  public
  published
    procedure TestNosoDataLegacyWalletCreate;
  end;

implementation

{ TTestNosoDataLegacyWallet }

procedure TTestNosoDataLegacyWallet.CheckFieldsCreate;
begin
  AssertEquals('Noso Data Legacy Wallet count is 0', 0, FLegacyWallet.Count);
end;

procedure TTestNosoDataLegacyWallet.TestNosoDataLegacyWalletCreate;
begin
  FLegacyWallet:= TLegacyWallet.Create;
  try
    CheckFieldsCreate;
  finally
    FLegacyWallet.Free;
  end;
end;

initialization
  RegisterTest(TTestNosoDataLegacyWallet);
end.

