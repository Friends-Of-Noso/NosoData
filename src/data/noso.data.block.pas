unit Noso.Data.Block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpjson
, jsonparser
, Noso.Data.Legacy.Block
, Noso.Data.Legacy.Transaction
, Noso.Data.Operations
, Noso.Data.Operation
;

const
  cjNumber              = 'number';
  cjHash                = 'hash';
  cjHashLegacy          = 'hash-legacy';
  cjTimeStart           = 'time-start';
  cjTimeEnd             = 'time-end';
  cjTimeTotal           = 'time-total';
  cjTimeLast20          = 'time-last-20';
  cjOperations          = 'operations';
  cjDifficulty          = 'difficulty';
  cjTargetHash          = 'target-hash';
  cjSolution            = 'solution';
  cjLastBlockHash       = 'last-block-hash';
  cjLastBlockHashLegacy = 'last-block-hash-legacy';
  cjNextBlockDifficulty = 'next-block-difficulty';
  cjMiner               = 'miner';
  cjFee                 = 'fee';
  cjReward              = 'reward';
  cjMerkleRoot          = 'merkle-root';

resourcestring
  rsEBlockWrongJSONObject = 'JSON data is not an object';

type
{ EBlockWrongJSONObject }
  EBlockWrongJSONObject = class(Exception);

{ TBlock }
  TBlock = class(TObject)
  private
    FNumber: Int64;
    FHash: String;
    FHashLegacy: String;
    FTimeStart: Int64;
    FTimeEnd: Int64;
    FTimeTotal: Integer;
    FTimeLast20: Integer;
    FDifficulty: Integer;
    FTargetHash: String;
    FSolution: String;
    FLastBlockHash: String;
    FLastBlockHashLegacy: String;
    FNextBlockDifficulty: Integer;
    FMiner: String;
    FFee: int64;
    FReward: Int64;
    FOperations: TOperations;
    FMerkleRoot: String;
    { TODO 99 -ogcarreno : Implement PoS & MN Rewards }

    FCompressedJSON: Boolean;

    procedure setFromLegacy(const ALegacyBlock: TLegacyBlock);

    procedure setFromJSON(const AJSON: TJSONStringType);
    procedure setFromJSONData(const AJSONData: TJSONData);
    procedure setFromJSONObject(const AJSONObject: TJSONObject);
    procedure setFromStream(const AStream: TStream);

    function getAsLegacy: TLegacyBlock;

    function getAsJSON: TJSONStringType;
    function getAsJSONData: TJSONData;
    function getAsJSONObject: TJSONObject;
    function getAsStream: TStream;

  protected
  public
    constructor Create; overload;
    constructor Create(const ALegacyBlock: TLegacyBlock); overload;
    constructor Create(const AJSON: TJSONStringType); overload;
    constructor Create(const AJSONData: TJSONData); overload;
    constructor Create(const AJSONObject: TJSONObject); overload;
    constructor Create(const AStream: TStream); overload;

    destructor Destroy; override;

    function FormatJSON(
      AOptions : TFormatOptions = DefaultFormat;
      AIndentsize : Integer = DefaultIndentSize
    ): TJSONStringType;

    property Number: Int64
      read FNumber
      write FNumber;
    property Hash: String
      read FHash
      write FHash;
    property HashLegacy: String
      read FHashLegacy
      write FHashLegacy;
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
    property Difficulty: Integer
      read FDifficulty
      write FDifficulty;
    property TargetHash: String
      read FTargetHash
      write FTargetHash;
    property Solution: String
      read FSolution
      write FSolution;
    property LastBlockHash: String
      read FLastBlockHash
      write FLastBlockHash;
    property LastBlockHashLegacy: String
      read FLastBlockHashLegacy
      write FLastBlockHashLegacy;
    property NextBlockDifficulty: Integer
      read FNextBlockDifficulty
      write FNextBlockDifficulty;
    property Miner: String
      read FMiner
      write FMiner;
    property Fee: Int64
      read FFee
      write FFee;
    property Reward: Int64
      read FReward
      write FReward;
    property MerkleRoot: String
      read FMerkleRoot
      write FMerkleRoot;
    property Operations: TOperations
      read FOperations;

    property CompressedJSON: Boolean
      read FCompressedJSON
      write FCompressedJSON;

    property AsLegacy: TLegacyBlock
      read getAsLegacy;

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

{ TBlock }

function TBlock.FormatJSON(
  AOptions: TFormatOptions;
  AIndentsize: Integer
): TJSONStringType;
var
  objectJSON: TJSONObject;
begin
  objectJSON:= getAsJSONObject;
  Result:= objectJSON.FormatJSON(AOptions, AIndentsize);
  objectJSON.Free;
end;

procedure TBlock.setFromLegacy(const ALegacyBlock: TLegacyBlock);
var
  legacyTransaction: TLegacyTransaction;
begin
  FNumber:= ALegacyBlock.Number;
  FHashLegacy:= ALegacyBlock.Hash;
  FTimeStart:= ALegacyBlock.TimeStart;
  FTimeEnd:= ALegacyBlock.TimeEnd;
  FTimeTotal:= ALegacyBlock.TimeTotal;
  FTimeLast20:= ALegacyBlock.TimeLast20;
  FDifficulty:= ALegacyBlock.Difficulty;
  FTargetHash:= ALegacyBlock.TargetHash;
  FSolution:= ALegacyBlock.Solution;
  FLastBlockHashLegacy:= ALegacyBlock.LastBlockHash;
  FNextBlockDifficulty:= ALegacyBlock.NextBlockDifficulty;
  FMiner:= ALegacyBlock.Miner;
  FFee:= ALegacyBlock.Fee;
  FReward:= ALegacyBlock.Reward;
  for legacyTransaction in ALegacyBlock.Transactions do
  begin
    FOperations.Add(TOperation.Create(legacyTransaction));
  end;
  if FNumber >= cBlockWithPoS then
  begin
    { TODO 99 -ogcarreno : Implement PoS Rewards as Transactions }
  end;
  if FNumber >= cBlockWithMNandPoS then
  begin
    { TODO 99 -ogcarreno : Implement MN Rewards as Transactions }
  end;
end;

procedure TBlock.setFromJSON(const AJSON: TJSONStringType);
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

procedure TBlock.setFromJSONData(const AJSONData: TJSONData);
begin
  if aJSONData.JSONType <> jtObject then
  begin
    raise EBlockWrongJSONObject.Create(rsEBlockWrongJSONObject);
  end;
  setFromJSONObject(aJSONData as TJSONObject);
end;

procedure TBlock.setFromJSONObject(const AJSONObject: TJSONObject);
var
  jOperations: TJSONData = nil;
begin
  FNumber:= AJSONObject.Get(cjNumber, FNumber);
  FHash:= AJSONObject.Get(cjHash, FHash);
  FHashLegacy:= AJSONObject.Get(cjHashLegacy, FHashLegacy);
  FTimeStart:= AJSONObject.Get(cjTimeStart, FTimeStart);
  FTimeEnd:= AJSONObject.Get(cjTimeEnd, FTimeEnd);
  FTimeTotal:= AJSONObject.Get(cjTimeTotal, FTimeTotal);
  FTimeLast20:= AJSONObject.Get(cjTimeLast20, FTimeLast20);
  jOperations:= AJSONObject.FindPath(cjOperations);
  if jOperations <> nil then
  begin
    if Assigned(FOperations) then
    begin
      FOperations.Free;
    end;
    FOperations:= TOperations.Create(jOperations);
  end
  else
  begin
    FOperations.Clear;
  end;
  FDifficulty:= AJSONObject.Get(cjDifficulty, FDifficulty);
  FTargetHash:= AJSONObject.Get(cjTargetHash, FTargetHash);
  FSolution:= AJSONObject.Get(cjSolution, FSolution);
  FLastBlockHash:= AJSONObject.Get(cjLastBlockHash, FLastBlockHash);
  FLastBlockHashLegacy:= AJSONObject.Get(cjLastBlockHashLegacy, FLastBlockHashLegacy);
  FNextBlockDifficulty:= AJSONObject.Get(cjNextBlockDifficulty, FNextBlockDifficulty);
  FMiner:= AJSONObject.Get(cjMiner, FMiner);
  FFee:= AJSONObject.Get(cjFee, FFee);
  FReward:= AJSONObject.Get(cjReward, FReward);
  FMerkleRoot:= AJSONObject.Get(cjMerkleRoot, FMerkleRoot);
end;

procedure TBlock.setFromStream(const AStream: TStream);
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

function TBlock.getAsLegacy: TLegacyBlock;
var
  operation: TOperation;
begin
  Result:= TLegacyBlock.Create;
  Result.Number:= FNumber;
  Result.TimeStart:= FTimeStart;
  Result.TimeEnd:= FTimeEnd;
  Result.TimeTotal:= FTimeTotal;
  Result.TimeLast20:= FTimeLast20;
  Result.Difficulty:= FDifficulty;
  Result.TargetHash:= FTargetHash;
  Result.Solution:= FSolution;
  Result.LastBlockHash:= FLastBlockHashLegacy;
  Result.NextBlockDifficulty:= FNextBlockDifficulty;
  Result.Miner:= FMiner;
  Result.Fee:= FFee;
  Result.Reward:= FReward;
  for operation in FOperations do
  begin
    if operation.OperationType in [otTransfer, otCustom] then
    begin
      Result.Transactions.Add(operation.AsLegacy);
    end;
  end;
  if Result.Number >= cBlockWithPoS then
  begin
    { TODO 99 -ogcarreno : Implement PoS Rewards as Transactions }
  end;
  if Result.Number >= cBlockWithMNandPoS then
  begin
    { TODO 99 -ogcarreno : Implement MN Rewards as Transactions }
  end;
end;

function TBlock.getAsJSON: TJSONStringType;
var
  jObject: TJSONObject = nil;
begin
  Result:= '';
  jObject:= getAsJSONObject;
  jObject.CompressedJSON:= FCompressedJSON;
  Result:= jObject.AsJSON;
  jObject.Free;
end;

function TBlock.getAsJSONData: TJSONData;
begin
  Result:= getAsJSONObject as TJSONData;
end;

function TBlock.getAsJSONObject: TJSONObject;
var
  jArray: TJSONArray = nil;
begin
  Result:= TJSONObject.Create;
  Result.Add(cjNumber, FNumber);
  Result.Add(cjHash, FHash);
  Result.Add(cjHashLegacy, FHashLegacy);
  Result.Add(cjTimeStart, FTimeStart);
  Result.Add(cjTimeEnd, FTimeEnd);
  Result.Add(cjTimeTotal, FTimeTotal);
  Result.Add(cjTimeLast20, FTimeLast20);
  Result.Add(cjDifficulty, FDifficulty);
  Result.Add(cjTargetHash, FTargetHash);
  Result.Add(cjSolution, FSolution);
  Result.Add(cjLastBlockHash, FLastBlockHash);
  Result.Add(cjLastBlockHashLegacy, FLastBlockHashLegacy);
  Result.Add(cjNextBlockDifficulty, FNextBlockDifficulty);
  Result.Add(cjMiner, FMiner);
  Result.Add(cjFee, FFee);
  Result.Add(cjReward, FReward);
  Result.Add(cjMerkleRoot, FMerkleRoot);
  jArray:= FOperations.AsJSONArray;
  Result.Add(cjOperations, jArray);
end;

function TBlock.getAsStream: TStream;
begin
  Result:= TStringStream.Create(getAsJSON, TEncoding.UTF8);
end;

constructor TBlock.Create;
begin
  FNumber:= -1;
  FHash:= EmptyStr;
  FHashLegacy:= EmptyStr;
  FTimeStart:= -1;
  FTimeEnd:= -1;
  FTimeTotal:= -1;
  FTimeLast20:= -1;
  FOperations:= TOperations.Create;
  FDifficulty:= -1;
  FTargetHash:= EmptyStr;
  FSolution:= EmptyStr;
  FLastBlockHash:= EmptyStr;
  FLastBlockHashLegacy:= EmptyStr;
  FNextBlockDifficulty:= -1;
  FMiner:= EmptyStr;
  FFee:= 0;
  FReward:= 0;
  FMerkleRoot:= EmptyStr;
  FCompressedJSON:= True;
end;

constructor TBlock.Create(const ALegacyBlock: TLegacyBlock);
begin
  Create;
  setFromLegacy(ALegacyBlock);
end;

constructor TBlock.Create(const AJSON: TJSONStringType);
begin
  Create;
  setFromJSON(AJSON);
end;

constructor TBlock.Create(const AJSONData: TJSONData);
begin
  Create;
  setFromJSONData(AJSONData);
end;

constructor TBlock.Create(const AJSONObject: TJSONObject);
begin
  Create;
  setFromJSONObject(AJSONObject);
end;

constructor TBlock.Create(const AStream: TStream);
begin
  Create;
  setFromStream(AStream);
end;

destructor TBlock.Destroy;
begin
  FOperations.Free;
  inherited Destroy;
end;

end.

