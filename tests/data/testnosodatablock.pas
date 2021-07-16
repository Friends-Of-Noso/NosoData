unit TestNosoDataBlock;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Block
;

type
{ TTestNosoDataBlock }
  TTestNosoDataBlock = class(TTestCase)
  private
    FBlock: TBlock;

    procedure CheckFieldsCreate;
  protected
  public
  published
    procedure TestNosoDataBlockCreate;
  end;
implementation

{ TTestNosoDataBlock }

procedure TTestNosoDataBlock.CheckFieldsCreate;
begin
  AssertEquals('Block '+cjNumber+' is -1', -1, FBlock.Number);
  AssertEquals('Block '+cjTimeStart+' is -1', -1, FBlock.TimeStart);
  AssertEquals('Block '+cjTimeEnd+' is -1', -1, FBlock.TimeEnd);
  AssertEquals('Block '+cjTimeTotal+' is -1', -1, FBlock.TimeTotal);
  AssertEquals('Block '+cjTimeLast20+' is -1', -1, FBlock.TimeLast20);
  AssertNotNull('Block '+cjOperations+' is not null', Fblock.Operations);
  AssertEquals('Block '+cjOperations+' count is 0', 0, FBlock.Operations.Count);
  AssertEquals('Block '+cjDifficulty+' is -1', -1, FBlock.Difficulty);
  AssertEquals('Block '+cjTargetHash+' is empty', EmptyStr, FBlock.TargetHash);
  AssertEquals('Block '+cjSolution+' is empty', EmptyStr, FBlock.Solution);
  AssertEquals('Block '+cjLastBlockHash+' is empty', EmptyStr, FBlock.LastBlockHash);
  AssertEquals('Block '+cjNextBlockDifficulty+' is -1', -1, FBlock.NextBlockDifficulty);
  AssertEquals('Block '+cjMiner+' is empty', EmptyStr, FBlock.Miner);
  AssertEquals('Block '+cjFee+' is 0', 0, FBlock.Fee);
  AssertEquals('Block '+cjReward+' is 0', 0, FBlock.Reward);
end;

procedure TTestNosoDataBlock.TestNosoDataBlockCreate;
begin
  FBlock:= TBlock.Create;
  CheckFieldsCreate;
  FBlock.Free;
end;

initialization
  RegisterTest(TTestNosoDataBlock);
end.

