unit TestNosoDataLegacyAddress;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Address
;

type

{ TTestNosoDataLegacyAddress }
  TTestNosoDataLegacyAddress= class(TTestCase)
  private
    FLegacyAddress: TLegacyAddress;

    procedure CheckFieldsCreate;
    procedure CheckFieldsFromFile;
  protected
  public
  published
    procedure TestNosoDataLegacyAddressCreate;
    procedure TestNosoDataLegacyAddressFromFile;
  end;

implementation

const
  cDataFolder =
    '..'+DirectorySeparator+
    'tests'+DirectorySeparator+
    'test-data'+DirectorySeparator+
    'NOSODATA'+DirectorySeparator;

  cWalletFile = cDataFolder + 'wallet.pkw';

{ TTestNosoDataLegacyAddress }

procedure TTestNosoDataLegacyAddress.CheckFieldsCreate;
begin
  AssertEquals('Noso Data Legacy Address Hash is empty', EmptyStr, FLegacyAddress.Hash);
  AssertEquals('Noso Data Legacy Address Alias is empty', EmptyStr, FLegacyAddress.Alias);
  AssertEquals('Noso Data Legacy Address Public key is empty', EmptyStr, FLegacyAddress.PublicKey);
  AssertEquals('Noso Data Legacy Address Private key is empty', EmptyStr, FLegacyAddress.PrivateKey);
  AssertEquals('Noso Data Legacy Address Balance is 0', 0, FLegacyAddress.Balance);
  AssertEquals('Noso Data Legacy Address Pending is 0', 0, FLegacyAddress.Pending);
  AssertEquals('Noso Data Legacy Address Score is 0', 0, FLegacyAddress.Score);
  AssertEquals('Noso Data Legacy Address LastOp is -1', -1, FLegacyAddress.LastOp);
end;

procedure TTestNosoDataLegacyAddress.CheckFieldsFromFile;
begin
  AssertEquals('Noso Data Legacy Address Hash is N34siDfZvXedoHahiwtZAHSz3YmqxH7',
    'N34siDfZvXedoHahiwtZAHSz3YmqxH7',
    FLegacyAddress.Hash);
  AssertEquals('Noso Data Legacy Address Alias is empty', EmptyStr, FLegacyAddress.Alias);
  AssertEquals('Noso Data Legacy Address Public key is BHE58IfprciS92l+1urkUjLQ2yZbO8nBpatvMafYLwVDqlrfPPVG72782MR8x/qmMa5z2w/ZqhX0tC9p46CKRM4=',
    'BHE58IfprciS92l+1urkUjLQ2yZbO8nBpatvMafYLwVDqlrfPPVG72782MR8x/qmMa5z2w/ZqhX0tC9p46CKRM4=',
    FLegacyAddress.PublicKey);
  AssertEquals('Noso Data Legacy Address Private key is t/y9889GSjfYHP6CNhw4teuNNXI45HSI818YIeDNS14=',
    't/y9889GSjfYHP6CNhw4teuNNXI45HSI818YIeDNS14=',
    FLegacyAddress.PrivateKey);
  AssertEquals('Noso Data Legacy Address Balance is 0', 0, FLegacyAddress.Balance);
  AssertEquals('Noso Data Legacy Address Pending is 0', 0, FLegacyAddress.Pending);
  AssertEquals('Noso Data Legacy Address Score is 0', 0, FLegacyAddress.Score);
  AssertEquals('Noso Data Legacy Address LastOp is 0', 0, FLegacyAddress.LastOp);
end;

procedure TTestNosoDataLegacyAddress.TestNosoDataLegacyAddressCreate;
begin
  FLegacyAddress:= TLegacyAddress.Create;
  try
    CheckFieldsCreate;
  finally
    FLegacyAddress.Free;
  end;
end;

procedure TTestNosoDataLegacyAddress.TestNosoDataLegacyAddressFromFile;
var
  fsWallet: TFileStream;
begin
  if FileExists(ExtractFileDir(ParamStr(0))+DirectorySeparator+cWalletFile) then
  begin
    fsWallet:= TFileStream.Create(ExtractFileDir(ParamStr(0))+DirectorySeparator+cWalletFile, fmOpenRead);
    FLegacyAddress:= TLegacyAddress.Create;
    try
      FLegacyAddress.LoadFromStream(fsWallet);
      CheckFieldsFromFile;
    finally
      FLegacyAddress.Free;
      fsWallet.Free;
    end;
  end
  else
  begin
    Fail('Noso Data Legacy Address: Cannot find wallet file');
  end;
end;

initialization
  RegisterTest(TTestNosoDataLegacyAddress);
end.

