unit TestNosoDataOperation;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
, {testutils,} testregistry
, Noso.Data.Operation
;

type

  { TNosoDataOperation }

  TNosoDataOperation= class(TTestCase)
  private
    FOperation: TOperation;

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
, Noso.JSON.Utils
;

const
  cjOperationTransfer =
    '{'+
      '"operation-type":1,'+ // otTransfer
      '"id":"",'+
      '"block":1,'+
      '"reference":"",'+
      '"sender-public-key":"",'+ // Really needed ?
      '"sender-address":"",'+
      '"receiver-address":"",'+
      '"amount":0,'+
      '"fee":0,'+
      '"signature":"",'+
      '"created":-1'+
    '}';
  cjOperationCustom =
    '{'+
      '"operation-type":2,'+ // otCustom
      '"id":"",'+
      '"block":1,'+
      '"reference":"",'+
      '"sender-public-key":"",'+ // Really needed ?
      '"sender-address":"",'+
      '"receiver-address":"",'+
      '"amount":0,'+
      '"fee":0,'+
      '"signature":"",'+
      '"created":-1'+
    '}';

procedure TNosoDataOperation.CheckFieldsWithTransfer;
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

procedure TNosoDataOperation.CheckFieldsWithCustom;
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

procedure TNosoDataOperation.TestNosoDataOperationCreate;
begin
  FOperation:= TOperation.Create;
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
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationCreateFromJSONOperationTransfer;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationCreateFromJSONOperationCustom;
begin
  FOperation:= TOperation.Create(cjOperationCustom);
  CheckFieldsWithCustom;
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationCreateFromJSONDataOperationTransfer;
begin
  FOperation:= TOperation.Create(GetJSONData(cjOperationTransfer));
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationCreateFromJSONObjectOperationTransfer;
begin
  FOperation:= TOperation.Create(TJSONObject(GetJSONData(cjOperationTransfer)));
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationCreateFromSteamOperationTransfer;
var
  ssOperationObject: TStringStream;
begin
  ssOperationObject:= TStringStream.Create(cjOperationTransfer, TEncoding.UTF8);
  FOperation:= TOperation.Create(ssOperationObject);
  ssOperationObject.Free;
  CheckFieldsWithTransfer;
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationAsJSONFromTransfer;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, FOperation.AsJSON);
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationAsJSONDataFromTransfer;
begin
  FOperation:= TOperation.Create(GetJSONData(cjOperationTransfer));
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, FOperation.AsJSON);
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationAsJSONObjectFromTransfer;
begin
  FOperation:= TOperation.Create(TJSONObject(GetJSONData(cjOperationTransfer)));
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, FOperation.AsJSON);
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationAsStreamFromTransfer;
var
  ssOperationObject: TStringStream;
begin
  ssOperationObject:= TStringStream.Create(cjOperationTransfer, TEncoding.UTF8);
  FOperation:= TOperation.Create(ssOperationObject);
  ssOperationObject.Free;
  AssertEquals('Noso Operation AsJSON matches', cjOperationTransfer, FOperation.AsJSON);
  FOperation.Free;
end;

initialization
  RegisterTest(TNosoDataOperation);
end.

