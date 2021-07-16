unit TestNosoDataOperation;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Operation
;

type
{ TTestNosoDataOperation }
  TTestNosoDataOperation = class(TTestCase)
  private
    FOperation: TOperation;

    procedure CheckFieldsCreate;
    procedure CheckFieldsWithTransfer;
    procedure CheckFieldsWithCustom;
  protected
  public
  published
    procedure TestNosoDataOperationCreate;
    procedure TestNosoDataOperationCreateFromJSONOperationTransfer;
    procedure TestNosoDataOperationCreateFromJSONOperationCustom;
    procedure TestNosoDataOperationCreateFromJSONDataOperationTransfer;
    procedure TestNosoDataOperationCreateFromJSONObjectOperationTransfer;
    procedure TestNosoDataOperationCreateFromSteamOperationTransfer;

    procedure TestNosoDataOperationAsJSONFromTransfer;
    procedure TestNosoDataOperationAsJSONDataFromTransfer;
    procedure TestNosoDataOperationAsJSONObjectFromTransfer;
    procedure TestNosoDataOperationAsStreamFromTransfer;
  end;

implementation

uses
  DateUtils
, fpjson
, jsonparser
;

const
  cjOperationTransfer =
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
    '}';

  cjOperationCustom =
    '{'+
      '"'+cjOperationType+'":2,'+ // otCustom
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
    '}';

procedure TTestNosoDataOperation.CheckFieldsCreate;
begin
  AssertEquals('Noso Operation is type unknown', ord(otUnknown), ord(FOperation.OperationType));
  AssertEquals('Noso Operation ID is empty', EmptyStr, FOperation.ID);
  AssertEquals('Noso Operation Block is -1', -1, FOperation.Block);
  AssertEquals('Noso Operation Reference is empty', EmptyStr, FOperation.Reference);
  AssertEquals('Noso Operation Sender Public Key is empty', EmptyStr, FOperation.SenderPublicKey);
  AssertEquals('Noso Operation Sender Address is empty', EmptyStr, FOperation.SenderAddress);
  AssertEquals('Noso Operation Receiver Address is empty', EmptyStr, FOperation.ReceiverAddress);
  AssertEquals('Noso Operation Amount is 0', 0, FOperation.Amount);
  AssertEquals('Noso Operation Fee is 0', 0, FOperation.Fee);
  AssertEquals('Noso Operation Signature is empty', EmptyStr, FOperation.Signature);
  AssertEquals('Noso Operation Created is 1969-12-31 23:59:59', -1, DateTimeToUnix(FOperation.Created));
end;

procedure TTestNosoDataOperation.CheckFieldsWithTransfer;
begin
  AssertEquals('Noso Operation is type otTransfer(1)', ord(otTransfer), ord(FOperation.OperationType));
  AssertEquals('Noso Operation ID is empty', EmptyStr, FOperation.ID);
  AssertEquals('Noso Operation Block is 1', 1, FOperation.Block);
  AssertEquals('Noso Operation Reference is empty', EmptyStr, FOperation.Reference);
  AssertEquals('Noso Operation Sender Public Key is empty', EmptyStr, FOperation.SenderPublicKey);
  AssertEquals('Noso Operation Sender Address is empty', EmptyStr, FOperation.SenderAddress);
  AssertEquals('Noso Operation Receiver Address is empty', EmptyStr, FOperation.ReceiverAddress);
  AssertEquals('Noso Operation Amount is 0', 0, FOperation.Amount);
  AssertEquals('Noso Operation Fee is 0', 0, FOperation.Fee);
  AssertEquals('Noso Operation Signature is empty', EmptyStr, FOperation.Signature);
  AssertEquals('Noso Operation Created is 1969-12-31 23:59:59', -1, DateTimeToUnix(FOperation.Created));
end;

procedure TTestNosoDataOperation.CheckFieldsWithCustom;
begin
  AssertEquals('Noso Operation is type otCustom(2)', ord(otCustom), ord(FOperation.OperationType));
  AssertEquals('Noso Operation ID is empty', EmptyStr, FOperation.ID);
  AssertEquals('Noso Operation Block is 1', 1, FOperation.Block);
  AssertEquals('Noso Operation Reference is empty', EmptyStr, FOperation.Reference);
  AssertEquals('Noso Operation Sender Public Key is empty', EmptyStr, FOperation.SenderPublicKey);
  AssertEquals('Noso Operation Sender Address is empty', EmptyStr, FOperation.SenderAddress);
  AssertEquals('Noso Operation Receiver Address is empty', EmptyStr, FOperation.ReceiverAddress);
  AssertEquals('Noso Operation Amount is 0', 0, FOperation.Amount);
  AssertEquals('Noso Operation Fee is 0', 0, FOperation.Fee);
  AssertEquals('Noso Operation Signature is empty', EmptyStr, FOperation.Signature);
  AssertEquals('Noso Operation Created is 1969-12-31 23:59:59', -1, DateTimeToUnix(FOperation.Created));
end;

procedure TTestNosoDataOperation.TestNosoDataOperationCreate;
begin
  FOperation:= TOperation.Create;
  CheckFieldsCreate;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationCreateFromJSONOperationTransfer;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationCreateFromJSONOperationCustom;
begin
  FOperation:= TOperation.Create(cjOperationCustom);
  CheckFieldsWithCustom;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationCreateFromJSONDataOperationTransfer;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjOperationTransfer);
  FOperation:= TOperation.Create(jData);
  jData.Free;
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationCreateFromJSONObjectOperationTransfer;
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(cjOperationTransfer);
  FOperation:= TOperation.Create(TJSONObject(jData));
  jData.Free;
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationCreateFromSteamOperationTransfer;
var
  ssOperationObject: TStringStream = nil;
begin
  ssOperationObject:= TStringStream.Create(cjOperationTransfer, TEncoding.UTF8);
  FOperation:= TOperation.Create(ssOperationObject);
  ssOperationObject.Free;
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationAsJSONFromTransfer;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, FOperation.AsJSON);
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationAsJSONDataFromTransfer;
var
  jData: TJSONData = nil;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  jData:= FOperation.AsJSONData;
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, jData.AsJSON);
  jData.Free;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationAsJSONObjectFromTransfer;
var
  jObject: TJSONObject = nil;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  jObject:= FOperation.AsJSONObject;
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, jObject.AsJSON);
  jObject.Free;
  FOperation.Free;
end;

procedure TTestNosoDataOperation.TestNosoDataOperationAsStreamFromTransfer;
var
  ssOperation: TStringStream = nil;
  sOperation: TStream = nil;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  ssOperation:= TStringStream.Create('', TEncoding.UTF8);
  sOperation:= FOperation.AsStream;
  ssOperation.LoadFromStream(sOperation);
  sOperation.Free;
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, ssOperation.DataString);
  ssOperation.Free;
  FOperation.Free;
end;

initialization
  RegisterTest(TTestNosoDataOperation);
end.

