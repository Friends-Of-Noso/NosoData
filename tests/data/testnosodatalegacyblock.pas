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
, Noso.Data.Legacy.Transaction
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
    procedure CheckFieldsBlockFiftyTransactionZero(const ATransaction: TLegacyTransaction);
    procedure CheckFieldsBlockTenKay;
    procedure CheckFieldsBlockTenKayTransactionZero(const ATransaction: TLegacyTransaction);
  protected
  public
  published
    procedure TestNosoDataLegacyBlockCreate;
    procedure TestNosoDataLegacyBlockCreateFromFile;
    procedure TestNosoDataLegacyBlockZero;
    procedure TestNosoDataLegacyBlockOne;
    procedure TestNosoDataLegacyBlockFifty;
    procedure TestNosoDataLegacyBlockTenKay;
    procedure TestNosoDataLegacyBlockFindTransaction;
  end;

implementation

const
  cTestDataFolder =
    '..'+DirectorySeparator+
    'tests'+DirectorySeparator+
    'test-data'+DirectorySeparator+
    'NOSODATA'+DirectorySeparator+
    'BLOCKS'+DirectorySeparator;
  cBlockFiftyTransactionZero =
    'OR1icpcdc3rfhg56jxz4r9cnslnm4y880iusnxpk6jct97lly9x8';

{ TTestNosoDataLegacyBlock }

procedure TTestNosoDataLegacyBlock.CheckFieldsCreate;
begin
  AssertEquals('Noso Legacy Block Number is -1', -1, FLegacyBlock.Number);
  AssertEquals('Noso Legacy Block Hash is empty', EmptyStr, FLegacyBlock.Hash);
  AssertEquals('Noso Legacy Block TimeStart is -1', -1, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is -1', -1, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is -1', -1, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is -1', -1, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, FLegacyBlock.Transactions.Count);
  AssertEquals('Noso Legacy Block Difficulty is -1', -1, FLegacyBlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is empty', EmptyStr, FLegacyBlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is empty', EmptyStr, FLegacyBlock.Solution);
  AssertEquals('Noso Legacy Block LastBlockHash is empty', EmptyStr, FLegacyBlock.LastBlockHash);
  AssertEquals('Noso Legacy Block NextBlockDifficulty is -1', -1, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is empty', EmptyStr, FLegacyBlock.Miner);
  AssertEquals('Noso Legacy Block Fee is 0', 0, FLegacyBlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 0', 0, FLegacyBlock.Reward);
  AssertEquals('Noso Legacy Block PoS Reward is 0', 0, FLegacyBlock.PoSReward);
  AssertEquals('Noso Legacy Block PoS Address Count is 0', 0, Length(FLegacyBlock.PoSAddresses));
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockZero;
begin
  AssertEquals('Noso Legacy Block Number is 0', 0, FLegacyBlock.Number);
  AssertEquals('Noso Legacy Block Hash is empty', EmptyStr, FLegacyBlock.Hash);
  AssertEquals('Noso Legacy Block TimeStart is 1531896783', 1531896783, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615132800', 1615132800, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 83236017', 83236017, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 600', 600, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, FLegacyBlock.Transactions.Count);
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
  AssertEquals('Noso Legacy Block PoS Reward is 0', 0, FLegacyBlock.PoSReward);
  AssertEquals('Noso Legacy Block PoS Address Count is 0', 0, Length(FLegacyBlock.PoSAddresses));
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockOne;
begin
  AssertEquals('Noso Legacy Block Number is 1', 1, FLegacyBlock.Number);
  AssertEquals('Noso Legacy Block Hash is empty', EmptyStr, FLegacyBlock.Hash);
  AssertEquals('Noso Legacy Block TimeStart is 1615132801', 1615132801, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615132801', 1615132801, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 0', 0, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 600', 600, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 0', 0, FLegacyBlock.Transactions.Count);
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
  AssertEquals('Noso Legacy Block PoS Reward is 0', 0, FLegacyBlock.PoSReward);
  AssertEquals('Noso Legacy Block PoS Address Count is 0', 0, Length(FLegacyBlock.PoSAddresses));
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockFifty;
begin
  AssertEquals('Noso Legacy Block Number is 50', 50, FLegacyBlock.Number);
  AssertEquals('Noso Legacy Block Hash is empty', EmptyStr, FLegacyBlock.Hash);
  AssertEquals('Noso Legacy Block TimeStart is 1615145807', 1615145807, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1615147132', 1615147132, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 1325', 1325, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 741', 741, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 1', 1, FLegacyBlock.Transactions.Count);
  CheckFieldsBlockFiftyTransactionZero(FLegacyBlock.Transactions[0]);
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
  AssertEquals('Noso Legacy Block PoS Reward is 0', 0, FLegacyBlock.PoSReward);
  AssertEquals('Noso Legacy Block PoS Address Count is 0', 0, Length(FLegacyBlock.PoSAddresses));
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockFiftyTransactionZero(
  const ATransaction: TLegacyTransaction
);
begin
  AssertEquals('Noso Legacy Transaction Block is 50', 50, ATransaction.Block);
  AssertEquals('Noso Legacy Transaction OrderID is OR1icpcdc3rfhg56jxz4r9cnslnm4y880iusnxpk6jct97lly9x8',
    'OR1icpcdc3rfhg56jxz4r9cnslnm4y880iusnxpk6jct97lly9x8',
    ATransaction.OrderID
  );
  AssertEquals('Noso Legacy Transaction OrderLines is 1', 1, ATransaction.OrderLines);
  AssertEquals('Noso Legacy Transaction OrderType is TRFR', 'TRFR', ATransaction.OrderType);
  AssertEquals('Noso Legacy Transaction TimeStamp is 1615146440', 1615146440, ATransaction.TimeStamp);
  AssertEquals('Noso Legacy Transaction Reference is null', 'null', ATransaction.Reference);
  AssertEquals('Noso Legacy Transaction TrxLine is 1', 1, ATransaction.TrxLine);
  AssertEquals('Noso Legacy Transaction Sender is N2CBtrrutUzdadiCZ2EuMxKT2nithGh',
    'N2CBtrrutUzdadiCZ2EuMxKT2nithGh',
    ATransaction.Sender
  );
  AssertEquals('Noso Legacy Transaction Address is N2CBtrrutUzdadiCZ2EuMxKT2nithGh',
  'N2CBtrrutUzdadiCZ2EuMxKT2nithGh',
  ATransaction.Address
);
  AssertEquals('Noso Legacy Transaction Receiver is N22PR6DiB68vom6LU6E9T7eLy4ekVBQ',
    'N22PR6DiB68vom6LU6E9T7eLy4ekVBQ',
    ATransaction.Receiver);
  AssertEquals('Noso Legacy Transaction AmountFee is 10', 10, ATransaction.AmountFee);
  AssertEquals('Noso Legacy Transaction AmountTrf is 30000', 30000, ATransaction.AmountTrf);
  AssertEquals('Noso Legacy Transaction Signature is MEUCIDpHfJCYYQuef7Q7MO+eYog7G6GoLyAKdBIqrLehDyYTAiEAo4x9WBpqoTmj0orRxKBib6Pz9wGBUkBsoAahQ9MLbwI=',
    'MEUCIDpHfJCYYQuef7Q7MO+eYog7G6GoLyAKdBIqrLehDyYTAiEAo4x9WBpqoTmj0orRxKBib6Pz9wGBUkBsoAahQ9MLbwI=',
    ATransaction.Signature
  );
  AssertEquals('Noso Legacy Transaction TrfrID is tRBbLfRTPmr15Eno1LmumX28gTqr8Pb8PvzqdEGUAnrLBeNS',
    'tRBbLfRTPmr15Eno1LmumX28gTqr8Pb8PvzqdEGUAnrLBeNS',
    ATransaction.TrfrID
  );
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockTenKay;
begin
  AssertEquals('Noso Legacy Block Number is 10000', 10000, FLegacyBlock.Number);
  AssertEquals('Noso Legacy Block Hash is empty', EmptyStr, FLegacyBlock.Hash);
  AssertEquals('Noso Legacy Block TimeStart is 1621570647', 1621570647, FLegacyBlock.TimeStart);
  AssertEquals('Noso Legacy Block TimeEnd is 1621571416', 1621571416, FLegacyBlock.TimeEnd);
  AssertEquals('Noso Legacy Block TimeTotal is 769', 769, FLegacyBlock.TimeTotal);
  AssertEquals('Noso Legacy Block TimeLast20 is 593', 593, FLegacyBlock.TimeLast20);
  AssertEquals('Noso Legacy Block Transactions count is 3', 3, FLegacyBlock.Transactions.Count);
  CheckFieldsBlockTenKayTransactionZero(FLegacyBlock.Transactions[0]);
  AssertEquals('Noso Legacy Block Difficulty is 107', 107, FLegacyBlock.Difficulty);
  AssertEquals('Noso Legacy Block TargetHash is F8C0A43EE55', 'F8C0A43EE55', FLegacyBlock.TargetHash);
  AssertEquals('Noso Legacy Block Solution is "v!!!!#/\c71271mNL "j!!!!#6-c74053wL1 "t!!!!!3Nc73684o6I "v!!!!#/kc72102HA8 "P!!!!#11c77420b6Z ":!!!!!!j4c0192n8W "v!!!!#03c71520kJy "8!!!!!!$c72680oLG !T!!!!!:mc779147h9 !T!!!!!:nc71130itp',
    '"v!!!!#/\c71271mNL "j!!!!#6-c74053wL1 "t!!!!!3Nc73684o6I "v!!!!#/kc72102HA8 "P!!!!#11c77420b6Z ":!!!!!!j4c0192n8W "v!!!!#03c71520kJy "8!!!!!!$c72680oLG !T!!!!!:mc779147h9 !T!!!!!:nc71130itp',
    FLegacyBlock.Solution
  );
  AssertEquals('Noso Legacy Block LastBlockHash is F8C0A43EE55322F874FBD0EC4A303506',
    'F8C0A43EE55322F874FBD0EC4A303506',
    FLegacyBlock.LastBlockHash
  );
  AssertEquals('Noso Legacy Block NextBlockDifficulty is 107', 107, FLegacyBlock.NextBlockDifficulty);
  AssertEquals('Noso Legacy Block Miner is N2qjeXLHDtBbAmX9TwhsEFpGN8wfPEf',
    'N2qjeXLHDtBbAmX9TwhsEFpGN8wfPEf',
    FLegacyBlock.Miner
  );
  AssertEquals('Noso Legacy Block Fee is 266867', 266867, FLegacyBlock.Fee);
  AssertEquals('Noso Legacy Block Reward is 5000000000', 5000000000, FLegacyBlock.Reward);
  AssertEquals('Noso Legacy Block PoS Reward is 2202760', 2202760, FLegacyBlock.PoSReward);
  AssertEquals('Noso Legacy Block PoS Address Count is 227', 227, Length(FLegacyBlock.PoSAddresses));
  AssertEquals('Noso Legacy Block PoS Address 0 is N4PeJyqj8diSXnfhxSQdLpo8ddXTaGd',
    'N4PeJyqj8diSXnfhxSQdLpo8ddXTaGd',
    FLegacyBlock.PoSAddresses[0]
  );
end;

procedure TTestNosoDataLegacyBlock.CheckFieldsBlockTenKayTransactionZero(
  const ATransaction: TLegacyTransaction
);
begin
  AssertEquals('Noso Legacy Transaction Block is 10000', 10000, ATransaction.Block);
  AssertEquals('Noso Legacy Transaction OrderID is OR1nnedtaunr5202m47r8tia7ehnw9qo6k36gu9oet28ce0ppx94',
    'OR1nnedtaunr5202m47r8tia7ehnw9qo6k36gu9oet28ce0ppx94',
    ATransaction.OrderID
  );
  AssertEquals('Noso Legacy Transaction OrderLines is 1', 1, ATransaction.OrderLines);
  AssertEquals('Noso Legacy Transaction OrderType is TRFR', 'TRFR', ATransaction.OrderType);
  AssertEquals('Noso Legacy Transaction TimeStamp is 1621570647', 1621570647, ATransaction.TimeStamp);
  AssertEquals('Noso Legacy Transaction Reference is POOLPAYMENT_DevNoso',
    'POOLPAYMENT_DevNoso',
    ATransaction.Reference
  );
  AssertEquals('Noso Legacy Transaction TrxLine is 1', 1, ATransaction.TrxLine);
  AssertEquals('Noso Legacy Transaction Sender is N2qjeXLHDtBbAmX9TwhsEFpGN8wfPEf',
    'N2qjeXLHDtBbAmX9TwhsEFpGN8wfPEf',
    ATransaction.Sender
  );
  AssertEquals('Noso Legacy Transaction Address is N2qjeXLHDtBbAmX9TwhsEFpGN8wfPEf',
  'N2qjeXLHDtBbAmX9TwhsEFpGN8wfPEf',
  ATransaction.Address
);
  AssertEquals('Noso Legacy Transaction Receiver is N3jt3R2iLfDUnXCWnzacKPK4Z42YDCo',
    'N3jt3R2iLfDUnXCWnzacKPK4Z42YDCo',
    ATransaction.Receiver);
  AssertEquals('Noso Legacy Transaction AmountFee is 162987', 162987, ATransaction.AmountFee);
  AssertEquals('Noso Legacy Transaction AmountTrf is 1629875927', 1629875927, ATransaction.AmountTrf);
  AssertEquals('Noso Legacy Transaction Signature is MEUCIQCRoQBe3B6XqjW+pc2xyfcnN1+/kRZdRTPC4vh9XtIkkgIgRH/EMgS9PrLs58QByE71qkMW1cmnMPVndRQ3kJrNzD4=',
    'MEUCIQCRoQBe3B6XqjW+pc2xyfcnN1+/kRZdRTPC4vh9XtIkkgIgRH/EMgS9PrLs58QByE71qkMW1cmnMPVndRQ3kJrNzD4=',
    ATransaction.Signature
  );
  AssertEquals('Noso Legacy Transaction TrfrID is tR6eH5CQJxRehBZ2EXp8LbWVkRYbMkpe2bjowdpTCmhN2DMv',
    'tR6eH5CQJxRehBZ2EXp8LbWVkRYbMkpe2bjowdpTCmhN2DMv',
    ATransaction.TrfrID
  );
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockCreate;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  try
    CheckFieldsCreate;
  finally
    FLegacyBlock.Free;
  end;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockCreateFromFile;
begin
  FLegacyBlock:= TLegacyBlock.Create(
    ExcludeTrailingPathDelimiter(cTestDataFolder)+DirectorySeparator+
    '0.blk'
  );
  try
    CheckFieldsBlockZero;
  finally
    FLegacyBlock.Free;
  end;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockZero;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  try
    FLegacyBlock.LoadFromFolder(cTestDataFolder, 0);
    CheckFieldsBlockZero;
  finally
    FLegacyBlock.Free;
  end;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockOne;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  try
    FLegacyBlock.LoadFromFolder(cTestDataFolder, 1);
    CheckFieldsBlockOne;
  finally
    FLegacyBlock.Free;
  end;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockFifty;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  try
    FLegacyBlock.LoadFromFolder(cTestDataFolder, 50);
    CheckFieldsBlockFifty;
  finally
    FLegacyBlock.Free;
  end;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockTenKay;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  try
    FLegacyBlock.LoadFromFolder(cTestDataFolder, 10000);
    CheckFieldsBlockTenKay;
  finally
    FLegacyBlock.Free;
  end;
end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockFindTransaction;
var
  transaction: TLegacyTransaction;
begin
  FLegacyBlock:= TLegacyBlock.Create(
    ExcludeTrailingPathDelimiter(cTestDataFolder)+DirectorySeparator+
    '50.blk'
  );
  try
    transaction:= FLegacyBlock.FindTransaction(cBlockFiftyTransactionZero);
    AssertNotNull('Noso Legacy Transaction is not null', transaction);
    CheckFieldsBlockFiftyTransactionZero(transaction);
  finally
    FLegacyBlock.Free;
  end;
end;

initialization
  RegisterTest(TTestNosoDataLegacyBlock);
end.

