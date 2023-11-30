unit Noso.Data.Legacy.Block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpjson
, Noso.Data.Legacy.Types
, Noso.Data.Legacy.Transactions
, Noso.Data.Legacy.Transaction
;

const
  cBlockWithPoS      : Int64 = 8425;
  cBlockWithMNandPoS : Int64 = 48010;
  cBlockWithMNOnly   : Int64 = 88500;
  cLegacyBlockFilenameFormat  = '%d.blk';

  cjNumber              = 'number';
  cjHASH                = 'hash';
  cjLastBlockHASH       = 'last-block-hash';
  cjTimeStart           = 'time-start';
  cjTimeEnd             = 'time-end';
  cjTimeTotal           = 'time-total';
  cjTimeLast20          = 'time-last-20';
  cjDifficulty          = 'difficulty';
  cjTargetHASH          = 'target-hash';
  cjSolution            = 'solution';
  cjNextBlockDifficulty = 'number';
  cjMiner               = 'miner';
  cjFee                 = 'fee';
  cjReward              = 'reward';
  cjTransactions        = 'transactions';
  cjProofOfStake        = 'proof-of-stake';
  cjMasterNodes         = 'master-nodes';

resourcestring
  rsECannotFindFolder = 'Cannot find folder %s';
  rsECannotFindFile = 'Cannot find file %s';
  rsELegacyBlockWrongJSONObject = 'JSON data is not an object';

type
{ ECannotFindFolder }
  ECannotFindFolder = class(Exception);

{ ECannotFindFile }
  ECannotFindFile = class(Exception);

{ ELegacyBlockWrongJSONObject }
  ELegacyBlockWrongJSONObject = class(Exception);

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
    FMiner: TString40;
    FFee: Int64;
    FReward: Int64;
    FProofofStakeReward: Int64;
    FProofofStakeAddresses: TArrayOfString32;
    FMasterNodeReward: Int64;
    FMasterNodeAddresses: TArrayOfString32;

    FCompressedJSON: Boolean;

    procedure SetHASH;

    procedure setFromJSON(const AJSON: TJSONStringType);
    procedure setFromJSONData(const AJSONData: TJSONData);
    procedure setFromJSONObject(const AJSONObject: TJSONObject);
    procedure setFromStream(const AStream: TStream);

    function getAsJSON: TJSONStringType;
    function getAsJSONData: TJSONData;
    function getAsJSONObject: TJSONObject;
    function getAsStream: TStream;
  protected
  public
    constructor Create; overload;
    constructor Create(const AFolder: String; const AFilename: String); overload;
    constructor Create(const AJSON: TJSONStringType); overload;
    constructor Create(const AJSONData: TJSONData); overload;
    constructor Create(const AJSONObject: TJSONObject); overload;
    constructor Create(const AStream: TStream); overload;

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
      read FMiner
      write FMiner;
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

    property CompressedJSON: Boolean
      read FCompressedJSON
      write FCompressedJSON;

    property AsJSON: TJSONStringType
      read getAsJSON;
    property AsJSONData: TJSONData
      read getAsJSONData;
    property AsJSONObject: TJSONObject
      read getAsJSONObject;
    property AsStream: TStream
      read getAsStream;
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

procedure TLegacyBlock.setFromJSON(const AJSON: TJSONStringType);
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(AJSON);
  try
    setFromJSONData(jData);
  finally
    jData.Free;
  end;
end;

procedure TLegacyBlock.setFromJSONData(const AJSONData: TJSONData);
begin
  if aJSONData.JSONType <> jtObject then
  begin
    raise ELegacyBlockWrongJSONObject.Create(rsELegacyBlockWrongJSONObject);
  end;
  setFromJSONObject(aJSONData as TJSONObject);
end;

procedure TLegacyBlock.setFromJSONObject(const AJSONObject: TJSONObject);
begin
  FNumber:= AJSONObject.Get(cjNumber, FNumber);
  FHash:= AJSONObject.Get(cjHash, FHash);
  FLastBlockHash:= AJSONObject.Get(cjLastBlockHASH, FLastBlockHash);
  FTimeStart:= AJSONObject.Get(cjTimeStart, FTimeStart);
  FTimeEnd:= AJSONObject.Get(cjTimeEnd, FTimeEnd);
  FTimeTotal:= AJSONObject.Get(cjTimeTotal, FTimeTotal);
  FTimeLast20:= AJSONObject.Get(cjTimeLast20, FTimeLast20);
  FDifficulty:= AJSONObject.Get(cjDifficulty, FDifficulty);
  FTargetHash:= AJSONObject.Get(cjTargetHASH, FTargetHash);
  FSolution:= AJSONObject.Get(cjSolution, FSolution);
  FNextBlockDifficulty:= AJSONObject.Get(cjNextBlockDifficulty, FNextBlockDifficulty);
  FMiner:= AJSONObject.Get(cjMiner, FMiner);
  FFee:= AJSONObject.Get(cjFee, FFee);
  FReward:= AJSONObject.Get(cjReward, FReward);

  { #todo -ogcarreno : Implement the JSON Transactions }
  //FTransactions:= TLegacyTransactions.Create;

  { #todo -ogcarreno : Implement the JSON PoS }

  { #todo -ogcarreno : Implement the JSON MNs }
end;

procedure TLegacyBlock.setFromStream(const AStream: TStream);
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(AStream);
  try
    setFromJSONData(jData);
  finally
    jData.Free;
  end;
end;

function TLegacyBlock.getAsJSON: TJSONStringType;
var
  jObject: TJSONObject = nil;
begin
  Result:= '';
  jObject:= getAsJSONObject;
  jObject.CompressedJSON:= FCompressedJSON;
  Result:= jObject.AsJSON;
  jObject.Free;
end;

function TLegacyBlock.getAsJSONData: TJSONData;
begin
  Result:= getAsJSONObject as TJSONData;
end;

function TLegacyBlock.getAsJSONObject: TJSONObject;
begin
  Result:= TJSONObject.Create;
  Result.Add(cjNumber, FNumber);
  Result.Add(cjHASH, FHash);
  Result.Add(cjLastBlockHASH, FLastBlockHash);
  Result.Add(cjTimeStart, FTimeStart);
  Result.Add(cjTimeEnd, FTimeEnd);
  Result.Add(cjTimeTotal, FTimeTotal);
  Result.Add(cjTimeLast20, FTimeLast20);
  Result.Add(cjDifficulty, FDifficulty);
  Result.Add(cjTargetHASH, FTargetHash);
  Result.Add(cjSolution, FSolution);
  Result.Add(cjNextBlockDifficulty, FNextBlockDifficulty);
  Result.Add(cjMiner, FMiner);
  Result.Add(cjFee, FFee);
  Result.Add(cjReward, FReward);

  { #todo -ogcarreno : Implement JSON Transactions }

  { #todo -ogcarreno : Implement JSON PoS }

  { #todo -ogcarreno : Implement JSON MNs }
end;

function TLegacyBlock.getAsStream: TStream;
begin
  Result:= TStringStream.Create(getAsJSON, TEncoding.UTF8);
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
  AStream.Read(FMiner, SizeOf(FMiner));
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
  AStream.Write(FMiner, SizeOf(FMiner));
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
  FMiner:= EmptyStr;
  FFee:= 0;
  FReward:= 0;
  FProofofStakeReward:= 0;
  SetLength(FProofofStakeAddresses, 0);
  FMasterNodeReward:= 0;
  SetLength(FMasterNodeAddresses, 0);
end;

constructor TLegacyBlock.Create(const AFolder: String; const AFilename: String);
begin
  Create;
  LoadFromFile(
    IncludeTrailingPathDelimiter(AFolder) +
    AFilename
  );
end;

constructor TLegacyBlock.Create(const AJSON: TJSONStringType);
begin
  Create;
  setFromJSON(AJSON);
end;

constructor TLegacyBlock.Create(const AJSONData: TJSONData);
begin
  Create;
  setFromJSONData(AJSONData);
end;

constructor TLegacyBlock.Create(const AJSONObject: TJSONObject);
begin
  Create;
  setFromJSONObject(AJSONObject);
end;

constructor TLegacyBlock.Create(const AStream: TStream);
begin
  Create;
  setFromStream(AStream);
end;

destructor TLegacyBlock.Destroy;
begin
  SetLength(FProofofStakeAddresses, 0);
  FTransactions.Free;
  inherited Destroy;
end;

end.

