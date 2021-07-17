unit TestNosoDataLegacyBlock;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Block
;

type
{ TTestNosoDataLegacyBlock }
  TTestNosoDataLegacyBlock = class(TTestCase)
  private
    FLegacyBlock: TLegacyBlock;

    procedure CheckFieldsCreate;
  protected
  public
  published
    procedure TestNosoDataLegacyBlockCreate;
  end;

implementation

{ TTestNosoDataLegacyBlock }

procedure TTestNosoDataLegacyBlock.CheckFieldsCreate;
begin
  AssertEquals('Block Number is -1', -1, FLegacyBlock.Number);
  AssertEquals('Block TimeStart is -1', -1, FLegacyBlock.TimeStart);
  AssertEquals('Block TimeEnd is -1', -1, FLegacyBlock.TimeEnd);
  AssertEquals('Block TimeTotal is -1', -1, FLegacyBlock.TimeTotal);
  AssertEquals('Block TimeLast20 is -1', -1, FLegacyBlock.TimeLast20);
  AssertEquals('Block TrxTotales count is 0', 0, FLegacyBlock.Transfers);
  AssertEquals('Block Difficulty is -1', -1, FLegacyBlock.Difficulty);
  AssertEquals('Block TargetHash is empty', EmptyStr, FLegacyBlock.TargetHash);
  AssertEquals('Block Solution is empty', EmptyStr, FLegacyBlock.Solution);
  AssertEquals('Block LastBlockHash is empty', EmptyStr, FLegacyBlock.LastBlockHash);
  AssertEquals('Block NextBlockDifficulty is -1', -1, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Block Miner is empty', EmptyStr, FLegacyBlock.Miner);
  AssertEquals('Block Fee is 0', 0, FLegacyBlock.Fee);
  AssertEquals('Block Reward is 0', 0, FLegacyBlock.Reward);
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockCreate;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  CheckFieldsCreate;
  FLegacyBlock.Free;
end;

initialization
  RegisterTest(TTestNosoDataLegacyBlock);
end.

