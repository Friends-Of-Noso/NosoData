unit TestNosoDataOperations;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Operations
;

type
{ TTestNosoDataOperations }
  TTestNosoDataOperations = class(TTestCase)
  private
    FOperations: TOperations;

    procedure CheckEmpty;
    procedure CheckOneTransfer;
  protected
  public
  published
    procedure TestNosoDataOperationsCreate;
    procedure TestNosoDataOperationsCreateFromJSON;
    procedure TestNosoDataOperationsCreateFromJSONData;
    procedure TestNosoDataOperationsCreateFromJSONArray;
    procedure TestNosoDataOperationsCreateFromStream;

    procedure TestNosoDataOperationsAsJSONFromOneTransfer;
    procedure TestNosoDataOperationsAsJSONDataFromOneTransfer;
    procedure TestNosoDataOperationsAsJSONArrayFromOneTransfer;
    procedure TestNosoDataOperationsAsStreamFromOneTransfer;
  end;

implementation

uses
  fpjson
, jsonparser
, Noso.Data.Operation
;

const
  cjOperationsOneTransfer =
    '[{'+
      '"'+cjOperationType+'":1,'+ // otTransfer
      '"'+cjID+'":"",'+
      '"'+cjBlock+'":1,'+
      '"'+cjReference+'":"",'+
      '"'+cjSenderPublicKey+'":"",'+
      '"'+cjSenderAddress+'":"",'+
      '"'+cjReceiverAddress+'":"",'+
      '"'+cjAmount+'":0,'+
      '"'+cjFee+'":0,'+
      '"'+cjSignature+'":"",'+
      '"'+cjCreated+'":-1'+
    '}]';

{ TTestNosoDataOperations }

procedure TTestNosoDataOperations.CheckEmpty;
begin
  AssertEquals('Operations has Count 0', 0, FOperations.Count);
end;

procedure TTestNosoDataOperations.CheckOneTransfer;
begin
  AssertEquals('Operations has Count 1', 1, FOperations.Count);
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreate;
begin
  FOperations:= TOperations.Create;
  CheckEmpty;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromJSON;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  CheckOneTransfer;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromJSONData;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjOperationsOneTransfer);
  FOperations:= TOperations.Create(jData);
  jData.Free;
  CheckOneTransfer;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromJSONArray;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjOperationsOneTransfer);
  FOperations:= TOperations.Create(TJSONArray(jData));
  jData.Free;
  CheckOneTransfer;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromStream;
var
  ssOperationsArray: TStringStream = nil;
begin
  ssOperationsArray:= TStringStream.Create(cjOperationsOneTransfer, TEncoding.UTF8);
  FOperations:= TOperations.Create(ssOperationsArray);
  ssOperationsArray.Free;
  CheckOneTransfer;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsJSONFromOneTransfer;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  AssertEquals('Operations from AsJSON matches', cjOperationsOneTransfer, FOperations.AsJSON);
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsJSONDataFromOneTransfer;
var
  jData: TJSONData = nil;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  jData:= FOperations.AsJSONData;
  AssertEquals('Operations from AsJSON matches', cjOperationsOneTransfer, jData.AsJSON);
  jData.Free;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsJSONArrayFromOneTransfer;
var
  jArray: TJSONArray = nil;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  jArray:= FOperations.AsJSONArray;
  AssertEquals('Operations from AsJSON matches', cjOperationsOneTransfer, jArray.AsJSON);
  jArray.Free;
  FOperations.Free;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsStreamFromOneTransfer;
var
  ssOperations: TStringStream = nil;
  sOperations: TStream = nil;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  ssOperations:= TStringStream.Create('', TEncoding.UTF8);
  sOperations:= FOperations.AsStream;
  ssOperations.LoadFromStream(sOperations);
  sOperations.Free;
  AssertEquals('Noso Operation AsJSON matches', cjOperationsOneTransfer, ssOperations.DataString);
  ssOperations.Free;
  FOperations.Free;
end;

initialization
  RegisterTest(TTestNosoDataOperations);
end.

