unit TestNosoDataBlocks;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Blocks
;

type
{ TTestNosoDataBlocks }
  TTestNosoDataBlocks = class(TTestCase)
  private
    FBlocks: TBlocks;

    procedure CheckEmpty;
    procedure CheckOneTransfer;
  protected
  public
  published
    procedure TestNosoDataBlocksCreate;
    procedure TestNosoDataBlocksCreateFromJSON;
    procedure TestNosoDataBlocksCreateFromJSONData;
    procedure TestNosoDataBlocksCreateFromJSONArray;
    procedure TestNosoDataBlocksCreateFromStream;

    procedure TestNosoDataBlocksAsJSONFromOneTransfer;
    procedure TestNosoDataBlocksAsJSONDataFromOneTransfer;
    procedure TestNosoDataBlocksAsJSONArrayFromOneTransfer;
    procedure TestNosoDataBlocksAsStreamFromOneTransfer;
  end;

implementation

uses
  fpjson
, jsonparser
, Noso.Data.Block
;

const
  cjBlocksOneEmpty =
    '[{'+
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
    '}]';

{ TTestNosoDataBlocks }

procedure TTestNosoDataBlocks.CheckEmpty;
begin
  AssertEquals('Blocks has Count 0', 0, FBlocks.Count);
end;

procedure TTestNosoDataBlocks.CheckOneTransfer;
begin
  AssertEquals('Blocks has Count 1', 1, FBlocks.Count);
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksCreate;
begin
  FBlocks:= TBlocks.Create;
  CheckEmpty;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksCreateFromJSON;
begin
  FBlocks:= TBlocks.Create(cjBlocksOneEmpty);
  CheckOneTransfer;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksCreateFromJSONData;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjBlocksOneEmpty);
  FBlocks:= TBlocks.Create(jData);
  jData.Free;
  CheckOneTransfer;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksCreateFromJSONArray;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjBlocksOneEmpty);
  FBlocks:= TBlocks.Create(TJSONArray(jData));
  jData.Free;
  CheckOneTransfer;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksCreateFromStream;
var
  ssBlocksArray: TStringStream = nil;
begin
  ssBlocksArray:= TStringStream.Create(cjBlocksOneEmpty, TEncoding.UTF8);
  FBlocks:= TBlocks.Create(ssBlocksArray);
  ssBlocksArray.Free;
  CheckOneTransfer;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksAsJSONFromOneTransfer;
begin
  FBlocks:= TBlocks.Create(cjBlocksOneEmpty);
  AssertEquals('Blocks from AsJSON matches', cjBlocksOneEmpty, FBlocks.AsJSON);
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksAsJSONDataFromOneTransfer;
var
  jData: TJSONData = nil;
begin
  FBlocks:= TBlocks.Create(cjBlocksOneEmpty);
  jData:= FBlocks.AsJSONData;
  AssertEquals('Blocks from AsJSON matches', cjBlocksOneEmpty, jData.AsJSON);
  jData.Free;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksAsJSONArrayFromOneTransfer;
var
  jArray: TJSONArray = nil;
begin
  FBlocks:= TBlocks.Create(cjBlocksOneEmpty);
  jArray:= FBlocks.AsJSONArray;
  AssertEquals('Blocks from AsJSON matches', cjBlocksOneEmpty, jArray.AsJSON);
  jArray.Free;
  FBlocks.Free;
end;

procedure TTestNosoDataBlocks.TestNosoDataBlocksAsStreamFromOneTransfer;
var
  ssBlocks: TStringStream = nil;
  sBlocks: TStream = nil;
begin
  FBlocks:= TBlocks.Create(cjBlocksOneEmpty);
  ssBlocks:= TStringStream.Create('', TEncoding.UTF8);
  sBlocks:= FBlocks.AsStream;
  ssBlocks.LoadFromStream(sBlocks);
  sBlocks.Free;
  AssertEquals('Noso Block AsJSON matches', cjBlocksOneEmpty, ssBlocks.DataString);
  ssBlocks.Free;
  FBlocks.Free;
end;

initialization
  RegisterTest(TTestNosoDataBlocks);
end.

