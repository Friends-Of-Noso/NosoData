unit TestNosoDataLegacyBlocks;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Blocks
, Noso.Data.Legacy.Block
;

type

  { TTestNosoDataLegacyBlocks }

  TTestNosoDataLegacyBlocks= class(TTestCase)
  private
    FBlocks: TLegacyBlocks;

    procedure CheckFieldsCreate;
    procedure CheckFieldsWithFolder;
    procedure CheckFieldsBlockZero(const ABlock: TLegacyBlock);
  protected
  public
  published
    procedure TestNosoLegacyBlocksCreate;
    procedure TestNosoLegacyBlocksCreateWithFolder;
    procedure TestNosoLegacyBlocksGetBlock;
  end;

const
  cTestDataFolder =
    '..'+DirectorySeparator+
    'tests'+DirectorySeparator+
    'test-data'+DirectorySeparator;

implementation

procedure TTestNosoDataLegacyBlocks.CheckFieldsCreate;
begin
  AssertEquals('Noso Data Legacy Blocks Folder is empty', EmptyStr, FBlocks.Folder);
  AssertEquals('Noso Data Legacy Blocks count is 0', 0, FBlocks.Count);
end;

procedure TTestNosoDataLegacyBlocks.CheckFieldsWithFolder;
begin
  AssertEquals('Noso Data Legacy Blocks Folder is '+cTestDataFolder, cTestDataFolder, FBlocks.Folder);
  AssertEquals('Noso Data Legacy Blocks count is 3', 3, FBlocks.Count);
end;

procedure TTestNosoDataLegacyBlocks.CheckFieldsBlockZero(
  const ABlock: TLegacyBlock
);
begin
  AssertEquals('Noso Legacy Block Number is 0', 0, ABlock.Number);
  AssertEquals('Noso Legacy Block Hash is 4E8A4743AA6083F3833DDA1216FE3717',
    '4E8A4743AA6083F3833DDA1216FE3717',
    ABlock.Hash
  );
  AssertEquals('Noso Legacy Block TimeStart is 1531896783', 1531896783, ABlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615132800', 1615132800, ABlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 83236017', 83236017, ABlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 600', 600, ABlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, ABlock.Transactions.Count);
  AssertEquals('Noso Legacy Block Difficulty is 60', 60, ABlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is empty', EmptyStr, ABlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is empty', EmptyStr, ABlock.Solution);
  AssertEquals('Noso Legacy Block LastBlockHash is NOSO GENESYS BLOCK',
    'NOSO GENESYS BLOCK',
    ABlock.LastBlockHash
  );
  AssertEquals('Noso Legacy Block NextBlockDifficulty is 60', 60, ABlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is N4PeJyqj8diSXnfhxSQdLpo8ddXTaGd',
    'N4PeJyqj8diSXnfhxSQdLpo8ddXTaGd',
    ABlock.Miner
  );
  AssertEquals('Noso Legacy Block Fee is 0', 0, ABlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 1030390730000', 1030390730000, ABlock.Reward);
  AssertEquals('Noso Legacy Block PoS Reward is 0', 0, ABlock.PoSReward);
  AssertEquals('Noso Legacy Block PoS Address Count is 0', 0, Length(ABlock.PoSAddresses));
end;

procedure TTestNosoDataLegacyBlocks.TestNosoLegacyBlocksCreate;
begin
  FBlocks:= TLegacyBlocks.Create;
  try
    CheckFieldsCreate;
  finally
    FBlocks.Free;
  end;
end;

procedure TTestNosoDataLegacyBlocks.TestNosoLegacyBlocksCreateWithFolder;
begin
  FBlocks:= TLegacyBlocks.Create(cTestDataFolder);
  try
    CheckFieldsWithFolder;
  finally
    FBlocks.Free;
  end;
end;

procedure TTestNosoDataLegacyBlocks.TestNosoLegacyBlocksGetBlock;
var
  block: TLegacyBlock;
begin
  FBlocks:= TLegacyBlocks.Create(cTestDataFolder);
  try
    block:= FBlocks[0];
    CheckFieldsBlockZero(block);
  finally
    block.Free;
    FBlocks.Free;
  end;
end;

initialization
  RegisterTest(TTestNosoDataLegacyBlocks);
end.

