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
    procedure CheckFieldsBlockZero;
    procedure CheckFieldsBlockOne;
    procedure CheckFieldsBlockFifty;
  protected
  public
  published
    procedure TestNosoDataLegacyBlockCreate;
    procedure TestNosoDataLegacyBlockZero;
    procedure TestNosoDataLegacyBlockOne;
    procedure TestNosoDataLegacyBlockFifty;
  end;

implementation

const
  cTestDataFolder =
    '..'+DirectorySeparator+
    'tests'+DirectorySeparator+
    'test-data'+DirectorySeparator+
    'blocks'+DirectorySeparator;

{ TTestNosoDataLegacyBlock }

procedure TTestNosoDataLegacyBlock.CheckFieldsCreate;
begin
  AssertEquals('Noso Legacy Block Number is -1', -1, FLegacyBlock.Number);
  { #todo 100 -ogcarreno : Test for the HASH }
  AssertEquals('Noso Legacy Block TimeStart is -1', -1, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is -1', -1, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is -1', -1, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is -1', -1, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, FLegacyBlock.Transactions);
  AssertEquals('Noso Legacy Block Difficulty is -1', -1, FLegacyBlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is empty', EmptyStr, FLegacyBlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is empty', EmptyStr, FLegacyBlock.Solution);
  AssertEquals('Noso Legacy Block LastBlockHash is empty', EmptyStr, FLegacyBlock.LastBlockHash);
  AssertEquals('Noso Legacy Block NextBlockDifficulty is -1', -1, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is empty', EmptyStr, FLegacyBlock.Miner);
  AssertEquals('Noso Legacy Block Fee is 0', 0, FLegacyBlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 0', 0, FLegacyBlock.Reward);
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockZero;
begin
  AssertEquals('Noso Legacy Block Number is 0', 0, FLegacyBlock.Number);
  { #todo 100 -ogcarreno : Test for the HASH }
  AssertEquals('Noso Legacy Block TimeStart is 1531896783', 1531896783, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615132800', 1615132800, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 83236017', 83236017, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 600', 600, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, FLegacyBlock.Transactions);
  AssertEquals('Noso Legacy Block Difficulty is 60', 60, FLegacyBlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is empty', EmptyStr, FLegacyBlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is empty', EmptyStr, FLegacyBlock.Solution);
  AssertEquals('Noso Legacy Block LastBlockHash is NOSO GENESYS BLOCK',
    'NOSO GENESYS BLOCK',
    FLegacyBlock.LastBlockHash
  );
  AssertEquals('Noso Legacy Block NextBlockDifficulty is 60', 60, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is N4PeJyqj8diSXnfhxSQdLpo8ddXTaGd',
    'N4PeJyqj8diSXnfhxSQdLpo8ddXTaGd',
    FLegacyBlock.Miner
  );
  AssertEquals('Noso Legacy Block Fee is 0', 0, FLegacyBlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 1030390730000', 1030390730000, FLegacyBlock.Reward);
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockOne;
begin
  AssertEquals('Noso Legacy Block Number is 1', 1, FLegacyBlock.Number);
  { #todo 100 -ogcarreno : Test for the HASH }
  AssertEquals('Noso Legacy Block TimeStart is 1615132801', 1615132801, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615132801', 1615132801, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 0', 0, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 600', 600, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, FLegacyBlock.Transactions);
  AssertEquals('Noso Legacy Block Difficulty is 60', 60, FLegacyBlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is 4E8A47', '4E8A47', FLegacyBlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is !!!!!!!!!100160038 !!!!!!!!!100278996 !!!!!!!!!100488684 !!!!!!!!!100670735 !!!!!!!!!100699467 !!!!!!!!!101030725 !!!!!!!!!101080582 !!!!!!!!!101123283 !!!!!!!!!101231910 !!!!!!!!!101805746',
    '!!!!!!!!!100160038 !!!!!!!!!100278996 !!!!!!!!!100488684 !!!!!!!!!100670735 !!!!!!!!!100699467 !!!!!!!!!101030725 !!!!!!!!!101080582 !!!!!!!!!101123283 !!!!!!!!!101231910 !!!!!!!!!101805746',
    FLegacyBlock.Solution
  );
  AssertEquals('Noso Legacy Block LastBlockHash is 4E8A4743AA6083F3833DDA1216FE3717',
    '4E8A4743AA6083F3833DDA1216FE3717',
    FLegacyBlock.LastBlockHash
  );
  AssertEquals('Noso Legacy Block NextBlockDifficulty is 60', 60, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is N3MGKTZviWuMxXbtUwZcLyPNBVMNoFz',
    'N3MGKTZviWuMxXbtUwZcLyPNBVMNoFz',
    FLegacyBlock.Miner
  );
  AssertEquals('Noso Legacy Block Fee is 0', 0, FLegacyBlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 5000000000', 5000000000, FLegacyBlock.Reward);
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockFifty;
begin
  AssertEquals('Noso Legacy Block Number is 50', 50, FLegacyBlock.Number);
  { #todo 100 -ogcarreno : Test for the HASH }
  AssertEquals('Noso Legacy Block TimeStart is 1615145807', 1615145807, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615147132', 1615147132, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 1325', 1325, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 741', 741, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 1', 1, FLegacyBlock.Transactions);
  AssertEquals('Noso Legacy Block Difficulty is 83', 83, FLegacyBlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is 040418C35', '040418C35', FLegacyBlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is !!!!!"!!!263110321 !!!!!#!!!359183507 !!!!!%!!!351463712 !!!!!%!!!500942098 !!!!!%!!!561574482 !!!!!%!!!733354625 !!!!!%!!!749102786 !!!!!%!!!750918362 !!!!!%!!!834534368 !!!!!%!!!985695035',
    '!!!!!"!!!263110321 !!!!!#!!!359183507 !!!!!%!!!351463712 !!!!!%!!!500942098 !!!!!%!!!561574482 !!!!!%!!!733354625 !!!!!%!!!749102786 !!!!!%!!!750918362 !!!!!%!!!834534368 !!!!!%!!!985695035',
    FLegacyBlock.Solution
  );
  AssertEquals('Noso Legacy Block LastBlockHash is 040418C3577AB4C166580830A77CE6D5',
    '040418C3577AB4C166580830A77CE6D5',
    FLegacyBlock.LastBlockHash
  );
  AssertEquals('Noso Legacy Block NextBlockDifficulty is 82', 82, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is N33oJ1A2qft9WsfjCXgJ5reBHKe5QCf',
    'N33oJ1A2qft9WsfjCXgJ5reBHKe5QCf',
    FLegacyBlock.Miner
  );
  AssertEquals('Noso Legacy Block Fee is 10', 10, FLegacyBlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 5000000000', 5000000000, FLegacyBlock.Reward);
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockCreate;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  CheckFieldsCreate;
  FLegacyBlock.Free;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockZero;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  FLegacyBlock.LoadFromFolder(cTestDataFolder, 0);
  CheckFieldsBlockZero;
  FLegacyBlock.Free;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockOne;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  FLegacyBlock.LoadFromFolder(cTestDataFolder, 1);
  CheckFieldsBlockOne;
  FLegacyBlock.Free;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockFifty;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  FLegacyBlock.LoadFromFolder(cTestDataFolder, 50);
  CheckFieldsBlockFifty;
  FLegacyBlock.Free;
end;

initialization
  RegisterTest(TTestNosoDataLegacyBlock);
end.

