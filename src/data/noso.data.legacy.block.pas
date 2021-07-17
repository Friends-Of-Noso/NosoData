unit Noso.Data.Legacy.Block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

resourcestring
  rsECannotFindFolder = 'Cannot find folder %s';
  rsECannotFindFile = 'Cannot find file %s';

type
{ ECannotFindFolder }
  ECannotFindFolder = class(Exception);

{ ECannotFindFile }
  ECannotFindFile = class(Exception);

{ TString32 }
  TString32 = String[32];

{ TString40 }
  TString40 = String[40];

{ TString200 }
  TString200 = String[200];

{ TLegacyBlock }
  TLegacyBlock = class(TObject)
  private
    FNumber: Int64;
    FHash: TString32;
    FTimeStart: Int64;
    FTimeEnd: Int64;
    FTimeTotal: Integer;
    FTimeLast20: Integer;
    FTransfers: Integer;
    FDifficulty: Integer;
    FTargetHash: TString32;
    FSolution: TString200;
    FLastBlockHash: TString32;
    FNextBlockDifficulty: Integer;
    FMinerAddress: TString40;
    FFee: Int64;
    FReward: Int64;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFolder(
      const AFolder: String;
      const ANumber: Int64
    );
    procedure LoadFromFile(const AFilePath: String);
    procedure LoadFromStream(const AStream: TStream);

    property Number: Int64
      read FNumber
      write FNumber;
    property Hash: TString32
      read FHash;
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
    property Transfers: Integer
      read FTransfers
      write FTransfers;
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
  published
  end;

implementation

const
  cBlockWithPoS : Int64 = 8425;

{ TLegacyBlock }

constructor TLegacyBlock.Create;
begin
  FNumber:= -1;
  FTimeStart:= -1;
  FTimeEnd:= -1;
  FTimeTotal:= -1;
  FTimeLast20:= -1;
  FTransfers:= 0;
  FDifficulty:= -1;
  FTargetHash:= EmptyStr;
  FSolution:= EmptyStr;
  FLastBlockHash:= EmptyStr;
  FNextBlockDifficulty:= -1;
  FMinerAddress:= EmptyStr;
  FFee:= 0;
  FReward:= 0;
  { #todo 100 -ogcarreno : Calculate the HASH }
end;

destructor TLegacyBlock.Destroy;
begin
  inherited Destroy;
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
    Format('%d.blk', [ANumber]);
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
  totalBytes: Int64 = 0;
  bytesRead: Int64 = 0;
begin
  bytesRead:= AStream.Read(FNumber, SizeOf(FNumber));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FTimeStart, SizeOf(FTimeStart));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FTimeEnd, SizeOf(FTimeEnd));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FTimeTotal, SizeOf(FTimeTotal));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FTimeLast20, SizeOf(FTimeLast20));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FTransfers, SizeOf(FTransfers));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FDifficulty, SizeOf(FDifficulty));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FTargetHash, SizeOf(FTargetHash));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FSolution, SizeOf(FSolution));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FLastBlockHash, SizeOf(FLastBlockHash));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FNextBlockDifficulty, SizeOf(FNextBlockDifficulty));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FMinerAddress, SizeOf(FMinerAddress));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FFee, SizeOf(FFee));
  Inc(totalBytes, bytesRead);
  bytesRead:= AStream.Read(FReward, SizeOf(FReward));
  Inc(totalBytes, bytesRead);
  { #todo 100 -ogcarreno : Calculate the HASH }
end;

end.

