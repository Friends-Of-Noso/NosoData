unit Noso.Data.Block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpjson
, Noso.Data.Operations
;

const
  cjNumber = 'number';
  cjTimeStart = 'time-start';
  cjTimeEnd = 'time-end';
  cjTimeTotal = 'time-total';
  cjTimeLast20 = 'time-last-20';
  cjOperations = 'operations';
  cjDifficulty = 'difficulty';
  cjTargetHash = 'target-hash';
  cjSolution = 'solution';
  cjLastBlockHash = 'last-block-hash';
  cjNextBlockDifficulty = 'next-block-difficulty';
  cjMiner = 'miner';
  cjFee = 'fee';
  cjReward = 'reward';

type
{ TBlock }
  TBlock = class(TObject)
  private
    FNumber: Int64;
    FTimeStart: Int64;
    FTimeEnd: Int64;
    FTimeTotal: Integer;
    FTimeLast20: Integer;
    FOperations: TOperations;
    FDifficulty: Integer;
    FTargetHash: String;
    FSolution: String;
    FLastBlockHash: String;
    FNextBlockDifficulty: Integer;
    FMiner: String;
    FFee: int64;
    FReward: Int64;
  protected
  public
    constructor Create; overload;
    destructor Destroy; override;

    property Number: Int64
      read FNumber
      write FNumber;
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
    property Operations: TOperations
      read FOperations;
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
  published
  end;

implementation

{ TBlock }

constructor TBlock.Create;
begin
  FNumber:= -1;
  FTimeStart:= -1;
  FTimeEnd:= -1;
  FTimeTotal:= -1;
  FTimeLast20:= -1;
  FOperations:= TOperations.Create;
  FDifficulty:= -1;
  FTargetHash:= EmptyStr;
  FSolution:= EmptyStr;
  FLastBlockHash:= EmptyStr;
  FNextBlockDifficulty:= -1;
  FMiner:= EmptyStr;
  FFee:= 0;
  FReward:= 0;
end;

destructor TBlock.Destroy;
begin
  FOperations.Free;
  inherited Destroy;
end;

end.

