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
    '{'+
      '"'+cjOperationsID+'":"",'+
      '"'+cjOperations+'":['+
        '{'+
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
        '}'+
      ']}';

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
  try
    CheckEmpty;
  finally
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromJSON;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  try
    CheckOneTransfer;
  finally
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromJSONData;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjOperationsOneTransfer);
  FOperations:= TOperations.Create(jData);
  jData.Free;
  try
    CheckOneTransfer;
  finally
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromJSONArray;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjOperationsOneTransfer);
  FOperations:= TOperations.Create(TJSONObject(jData));
  jData.Free;
  try
    CheckOneTransfer;
  finally
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsCreateFromStream;
var
  ssOperationsObject: TStringStream = nil;
begin
  ssOperationsObject:= TStringStream.Create(cjOperationsOneTransfer, TEncoding.UTF8);
  FOperations:= TOperations.Create(ssOperationsObject);
  ssOperationsObject.Free;
  try
    CheckOneTransfer;
  finally
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsJSONFromOneTransfer;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  try
    AssertEquals('Operations from AsJSON matches', cjOperationsOneTransfer, FOperations.AsJSON);
  finally
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsJSONDataFromOneTransfer;
var
  jData: TJSONData = nil;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  jData:= FOperations.AsJSONData;
  try
    AssertEquals('Operations from AsJSON matches', cjOperationsOneTransfer, jData.AsJSON);
  finally
    jData.Free;
    FOperations.Free;
  end;
end;

procedure TTestNosoDataOperations.TestNosoDataOperationsAsJSONArrayFromOneTransfer;
var
  jObject: TJSONObject = nil;
begin
  FOperations:= TOperations.Create(cjOperationsOneTransfer);
  jObject:= FOperations.AsJSONObject;
  try
    AssertEquals('Operations from AsJSON matches', cjOperationsOneTransfer, jObject.AsJSON);
  finally
    jObject.Free;
    FOperations.Free;
  end;
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
  try
    AssertEquals('Noso Operation AsJSON matches', cjOperationsOneTransfer, ssOperations.DataString);
  finally
    ssOperations.Free;
    FOperations.Free;
  end;
end;

initialization
  RegisterTest(TTestNosoDataOperations);
end.

