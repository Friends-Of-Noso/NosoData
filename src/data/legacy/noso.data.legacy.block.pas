unit Noso.Data.Legacy.Block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, Noso.Data.Legacy.Types
, Noso.Data.Legacy.Transactions
, Noso.Data.Legacy.Transaction
;

const
  cBlockWithPoS      : Int64 = 8425;
  cBlockWithMNandPoS : Int64 = 48010;
  cBlockWithMNOnly   : Int64 = 88500;
  cLegacyBlockFilenameFormat  = '%d.blk';

resourcestring
  rsECannotFindFolder = 'Cannot find folder %s';
  rsECannotFindFile = 'Cannot find file %s';

type
{ ECannotFindFolder }
  ECannotFindFolder = class(Exception);

{ ECannotFindFile }
  ECannotFindFile = class(Exception);

{ TLegacyBlock }
  TLegacyBlock = class(TObject)
  private
    FNumber: Int64;
    FHash: TString32;
    FTimeStart: Int64;
    FTimeEnd: Int64;
    FTimeTotal: Integer;
    FTimeLast20: Integer;
    FTransactionsCount: Integer;
    FTransactions: TLegacyTransactions;
    FDifficulty: Integer;
    FTargetHash: TString32;
    FSolution: TString200;
    FLastBlockHash: TString32;
    FNextBlockDifficulty: Integer;
    FMinerAddress: TString40;
    FFee: Int64;
    FReward: Int64;
    FProofofStakeReward: Int64;
    FProofofStakeAddresses: TArrayOfString32;
    FMasterNodeReward: Int64;
    FMasterNodeAddresses: TArrayOfString32;

    procedure SetHASH;
  protected
  public
    constructor Create; overload;
    constructor Create(const AFilename: String); overload;

    destructor Destroy; override;

    procedure LoadFromFolder(
      const AFolder: String;
      const ANumber: Int64
    );
    procedure LoadFromFile(const AFilePath: String);
    procedure LoadFromStream(const AStream: TStream);

    procedure SaveToFile(const AFilePath: String);
    procedure SaveToStream(const AStream: TStream);

    function FindTransaction(const ATransactionID: String): TLegacyTransaction;

    property Number: Int64
      read FNumber
      write FNumber;
    property Hash: TString32
      read FHASH;
    property TimeStart: Int64
      read FTimeStart
      write FTimeStart;
    property TimeEnd: Int64
      read FTimeEnd
      write FTimeEnd;
    property TimeTotal: Integer
      read FTimeTotal
      write FTimeTotal;
    property TimeLast20: Integer
      read FTimeLast20
      write FTimeLast20;
    property Transactions: TLegacyTransactions
      read FTransactions;
    property Difficulty: Integer
      read FDifficulty
      write FDifficulty;
    property TargetHash: TString32
      read FTargetHash
      write FTargetHash;
    property Solution: TString200
      read FSolution
      write FSolution;
    property LastBlockHash: TString32
      read FLastBlockHash
      write FLastBlockHash;
    property NextBlockDifficulty: Integer
      read FNextBlockDifficulty
      write FNextBlockDifficulty;
    property Miner: TString40
      read FMinerAddress
      write FMinerAddress;
    property Fee: Int64
      read FFee
      write FFee;
    property Reward: Int64
      read FReward
      write FReward;
    property PoSReward: Int64
      read FProofofStakeReward
      write FProofofStakeReward;
    property PoSAddresses: TArrayOfString32
      read FProofofStakeAddresses;
    property MNReward: Int64
      read FMasterNodeReward
      write FMasterNodeReward;
    property MNAddresses: TArrayOfString32
      read FMasterNodeAddresses;
  published
  end;

implementation

uses
  MD5
;

{ TLegacyBlock }

procedure TLegacyBlock.SetHASH;
var
  sBlock: TBytesStream;
begin
  if FHash = EmptyStr then
  begin
    sBlock:= TBytesStream.Create;
    try
      SaveToStream(sBlock);
      FHash:= UpperCase(MD5Print(MD5Buffer(sBlock.Bytes[0], sBlock.Size)));
    finally
      sBlock.Free;
    end;
  end;
end;

procedure TLegacyBlock.LoadFromFolder(
  const AFolder: String;
  const ANumber: Int64
);
var
  filePath: String;
begin
  if not DirectoryExists(AFolder) then
  begin
    raise ECannotFindFolder.Create(Format(rsECannotFindFolder, [AFolder]));
  end;
  filePath:= IncludeTrailingPathDelimiter(AFolder) +
    Format(cLegacyBlockFilenameFormat, [ANumber]);
  LoadFromFile(filePath);
end;

procedure TLegacyBlock.LoadFromFile(const AFilePath: String);
var
  sBlock: TFileStream = nil;
begin
  if not FileExists(AFilePath) then
  begin
    raise ECannotFindFile.Create(Format(rsECannotFindFile, [AFilePath]));
  end;
  sBlock:= TFileStream.Create(AFilePath, fmOpenRead);
  try
    LoadFromStream(sBlock);
  finally
    sBlock.Free;
  end;
end;

procedure TLegacyBlock.LoadFromStream(const AStream: TStream);
var
  posAddressCount: Integer = 0;
  mnAddressCount: Integer = 0;
  index: Integer = 0;
begin
  AStream.Read(FNumber, SizeOf(FNumber));
  AStream.Read(FTimeStart, SizeOf(FTimeStart));
  AStream.Read(FTimeEnd, SizeOf(FTimeEnd));
  AStream.Read(FTimeTotal, SizeOf(FTimeTotal));
  AStream.Read(FTimeLast20, SizeOf(FTimeLast20));
  AStream.Read(FTransactionsCount, SizeOf(FTransactionsCount));
  AStream.Read(FDifficulty, SizeOf(FDifficulty));
  AStream.Read(FTargetHash, SizeOf(FTargetHash));
  AStream.Read(FSolution, SizeOf(FSolution));
  AStream.Read(FLastBlockHash, SizeOf(FLastBlockHash));
  AStream.Read(FNextBlockDifficulty, SizeOf(FNextBlockDifficulty));
  AStream.Read(FMinerAddress, SizeOf(FMinerAddress));
  AStream.Read(FFee, SizeOf(FFee));
  AStream.Read(FReward, SizeOf(FReward));
  // Load Transactions
  if FTransactionsCount > 0 then
  begin
    FTransactions.LoadFromStream(AStream, FTransactionsCount);
  end;
  // Load PoS rewards
  if FNumber >= cBlockWithPoS then
  begin
    AStream.Read(FProofofStakeReward, SizeOf(FProofofStakeReward));
    AStream.Read(posAddressCount, SizeOf(posAddressCount));
    SetLength(FProofofStakeAddresses, posAddressCount);
    for index:= 0 to Pred(posAddressCount) do
    begin
      AStream.Read(FProofofStakeAddresses[index], SizeOf(TString32));
    end;
  end;
  //Load MN rewards
  if FNumber >= cBlockWithMNandPoS then
  begin
    AStream.Read(FMasterNodeReward, SizeOf(FMasterNodeReward));
    AStream.Read(mnAddressCount, SizeOf(mnAddressCount));
    SetLength(FMasterNodeAddresses, mnAddressCount);
    for index:= 0 to Pred(mnAddressCount) do
    begin
      AStream.Read(FMasterNodeAddresses[index], SizeOf(TString32));
    end;
  end;
  SetHASH;
end;

procedure TLegacyBlock.SaveToFile(const AFilePath: String);
var
  sBlock: TFileStream;
begin
  sBlock:= TFileStream.Create(AFilePath, fmOpenWrite);
  try
    SaveToStream(sBlock);
  finally
    sBlock.Free;
  end;
end;

procedure TLegacyBlock.SaveToStream(const AStream: TStream);
var
  posAddressCount: Integer = 0;
  mnAddressCount: Integer = 0;
  index: Integer = 0;
begin
  AStream.Position:= 0;
  AStream.Write(FNumber, SizeOf(FNumber));
  AStream.Write(FTimeStart, SizeOf(FTimeStart));
  AStream.Write(FTimeEnd, SizeOf(FTimeEnd));
  AStream.Write(FTimeTotal, SizeOf(FTimeTotal));
  AStream.Write(FTimeLast20, SizeOf(FTimeLast20));
  AStream.Write(FTransactionsCount, SizeOf(FTransactionsCount));
  AStream.Write(FDifficulty, SizeOf(FDifficulty));
  AStream.Write(FTargetHash, SizeOf(FTargetHash));
  AStream.Write(FSolution, SizeOf(FSolution));
  AStream.Write(FLastBlockHash, SizeOf(FLastBlockHash));
  AStream.Write(FNextBlockDifficulty, SizeOf(FNextBlockDifficulty));
  AStream.Write(FMinerAddress, SizeOf(FMinerAddress));
  AStream.Write(FFee, SizeOf(FFee));
  AStream.Write(FReward, SizeOf(FReward));
  // Save Transactions
  if FTransactionsCount > 0 then
  begin
    FTransactions.SaveToStream(AStream);
  end;
  // Save PoS rewards
  if FNumber >= cBlockWithPoS then
  begin
    AStream.Write(FProofofStakeReward, SizeOf(FProofofStakeReward));
    posAddressCount:= Length(FProofofStakeAddresses);
    AStream.Write(posAddressCount, SizeOf(posAddressCount));
    for index:= 0 to Pred(posAddressCount) do
    begin
      AStream.Write(FProofofStakeAddresses[index], SizeOf(TString32));
    end;
  end;
  // Save MN rewards
  if FNumber >= cBlockWithMNandPoS then
  begin
    AStream.Write(FMasterNodeReward, SizeOf(FMasterNodeReward));
    mnAddressCount:= Length(FMasterNodeAddresses);
    AStream.Write(mnAddressCount, SizeOf(mnAddressCount));
    for index:= 0 to Pred(mnAddressCount) do
    begin
      AStream.Write(FMasterNodeAddresses[index], SizeOf(TString32));
    end;
  end;
end;

function TLegacyBlock.FindTransaction(
  const ATransactionID: String
): TLegacyTransaction;
var
  transaction: TLegacyTransaction;
begin
  Result:= nil;
  for transaction in FTransactions do
  begin
    if ATransactionID = transaction.OrderID then
    begin
      Result:= transaction;
      break;
    end;
  end;
end;

constructor TLegacyBlock.Create;
begin
  FNumber:= -1;
  FHash:= EmptyStr;
  FTimeStart:= -1;
  FTimeEnd:= -1;
  FTimeTotal:= -1;
  FTimeLast20:= -1;
  FTransactions:= TLegacyTransactions.Create;
  FDifficulty:= -1;
  FTargetHash:= EmptyStr;
  FSolution:= EmptyStr;
  FLastBlockHash:= EmptyStr;
  FNextBlockDifficulty:= -1;
  FMinerAddress:= EmptyStr;
  FFee:= 0;
  FReward:= 0;
  FProofofStakeReward:= 0;
  SetLength(FProofofStakeAddresses, 0);
  FMasterNodeReward:= 0;
  SetLength(FMasterNodeAddresses, 0);
end;

constructor TLegacyBlock.Create(const AFilename: String);
begin
  Create;
  LoadFromFile(AFilename);
end;

destructor TLegacyBlock.Destroy;
begin
  SetLength(FProofofStakeAddresses, 0);
  FTransactions.Free;
  inherited Destroy;
end;

end.

