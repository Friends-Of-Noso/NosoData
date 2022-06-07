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

procedure TTestNosoDataLegacyWallet.CheckFieldsCreate;
begin
  AssertEquals('Noso Legacy Wallet Addresses count is 0', 0, FLegacyWallet.Addresses.Count);
end;

procedure TTestNosoDataLegacyWallet.TestNosoDataLegacyWalletCreate;
begin
  FLegacyWallet:= TLegacyWallet.Create;
  CheckFieldsCreate;
  FLegacyWallet.Free;
end;

initialization
  RegisterTest(TTestNosoDataLegacyWallet);
end.

