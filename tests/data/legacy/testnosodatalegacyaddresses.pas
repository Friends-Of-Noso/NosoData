unit TestNosoDataLegacyAddresses;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Addresses
;

type

{ TTestNosoDataLegacyAddresses }
  TTestNosoDataLegacyAddresses= class(TTestCase)
  private
    FLegacyAddresses: TLegacyAddresses;

    procedure CheckFieldsCreate;
  protected
  public
  published
    procedure TestNosoDataLegacyAddressesCreate;
  end;

implementation

{ TTestNosoDataLegacyAddresses }

procedure TTestNosoDataLegacyAddresses.CheckFieldsCreate;
begin
  AssertEquals('Noso Data Legacy Addresses count is 0', 0, FLegacyAddresses.Count);
end;

procedure TTestNosoDataLegacyAddresses.TestNosoDataLegacyAddressesCreate;
begin
  FLegacyAddresses:= TLegacyAddresses.Create;
  try
    CheckFieldsCreate;
  finally
    FLegacyAddresses.Free;
  end;
end;

initialization
  RegisterTest(TTestNosoDataLegacyAddresses);
end.

