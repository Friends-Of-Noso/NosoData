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
    procedure TestNosoDataBlockCreateFromJSON;
    procedure TestNosoDataBlockCreateFromJSONData;
    procedure TestNosoDataBlockCreateFromJSONObject;
    procedure TestNosoDataBlockCreateFromStream;

    procedure TestNosoDataBlockAsJSON;
    procedure TestNosoDataBlockAsJSONData;
    procedure TestNosoDataBlockAsJSONObject;
    procedure TestNosoDataBlockAsStream;
  end;
implementation

uses
  fpjson
, jsonparser
;

const
  cjBlockEmpty =
    '{'+
      '"'+cjNumber+'":-1,'+
      '"'+cjTimeStart+'":-1,'+
      '"'+cjTimeEnd+'":-1,'+
      '"'+cjTimeTotal+'":-1,'+
      '"'+cjTimeLast20+'":-1,'+
      '"'+cjOperations+'":[],'+
      '"'+cjDifficulty+'":-1,'+
      '"'+cjTargetHash+'":"",'+
      '"'+cjSolution+'":"",'+
      '"'+cjLastBlockHash+'":"",'+
      '"'+cjNextBlockDifficulty+'":-1,'+
      '"'+cjMiner+'":"",'+
      '"'+cjFee+'":0,'+
      '"'+cjReward+'":0'+
    '}';

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
  try
    CheckFieldsCreate;
  finally
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockCreateFromJSON;
begin
  FBlock:= TBlock.Create(cjBlockEmpty);
  try
    CheckFieldsCreate;
  finally
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockCreateFromJSONData;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjBlockEmpty);
  FBlock:= TBlock.Create(jData);
  jData.Free;
  try
    CheckFieldsCreate;
  finally
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockCreateFromJSONObject;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjBlockEmpty);
  FBlock:= TBlock.Create(TJSONObject(jData));
  jData.Free;
  try
    CheckFieldsCreate;
  finally
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockCreateFromStream;
var
  ssBlockObject: TStringStream = nil;
begin
  ssBlockObject:= TStringStream.Create(cjBlockEmpty, TEncoding.UTF8);
  FBlock:= TBlock.Create(ssBlockObject);
  ssBlockObject.Free;
  try
    CheckFieldsCreate;
  finally
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockAsJSON;
begin
  FBlock:= TBlock.Create(cjBlockEmpty);
  try
    AssertEquals('Noso Block AsJSON matches', cjBlockEmpty, FBlock.AsJSON);
  finally
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockAsJSONData;
var
  jData: TJSONData = nil;
begin
  FBlock:= TBlock.Create(cjBlockEmpty);
  jData:= FBlock.AsJSONData;
  try
    AssertEquals('Noso Block AsJSON matches', cjBlockEmpty, jData.AsJSON);
  finally
    jData.Free;
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockAsJSONObject;
var
  jObject: TJSONObject = nil;
begin
  FBlock:= TBlock.Create(cjBlockEmpty);
  jObject:= FBlock.AsJSONObject;
  try
    AssertEquals('Noso Block AsJSON matches', cjBlockEmpty, jObject.AsJSON);
  finally
    jObject.Free;
    FBlock.Free;
  end;
end;

procedure TTestNosoDataBlock.TestNosoDataBlockAsStream;
begin

end;

initialization
  RegisterTest(TTestNosoDataBlock);
end.

