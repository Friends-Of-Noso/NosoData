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
  protected
  public
  published
    procedure TestNosoDataOperationCreate;
    procedure TestNosoDataOperationCreateFromOperationTransfer;
    procedure TestNosoDataOperationCreateFromOperationCustom;
  end;

implementation

uses
  DateUtils
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

procedure TNosoDataOperation.TestNosoDataOperationCreateFromOperationTransfer;
begin
  FOperation:= TOperation.Create(cjOperationTransfer);
  AssertEquals('Noso Operation is type unknown', ord(otTransfer), ord(FOperation.OperationType));
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
  FOperation.Free;
end;

procedure TNosoDataOperation.TestNosoDataOperationCreateFromOperationCustom;
begin
  FOperation:= TOperation.Create(cjOperationCustom);
  AssertEquals('Noso Operation is type unknown', ord(otCustom), ord(FOperation.OperationType));
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
  FOperation.Free;
end;



initialization

  RegisterTest(TNosoDataOperation);
end.

