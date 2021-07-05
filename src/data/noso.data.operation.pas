unit Noso.Data.Operation;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpjson
;

const
  cjOperationType = 'operation-type';
  cjID = 'id';
  cjBlock = 'block';
  cjReference = 'reference';
  cjSenderPublicKey = 'sender-public-key';
  cjSenderAddress = 'sender-address';
  cjReceiverAddress = 'receiver-address';
  cjAmount = 'amount';
  cjFee = 'fee';
  cjSignature = 'signature';
  cjCreated = 'created';

type
{ TOperationType }
  TOperationType = (
    otUnknown,
    otTransfer,
    otCustom,
    otReserved3,
    otReserved4,
    otReserved5,
    otReserved6,
    otReserved7,
    otReserved8,
    otReserved9
  );

{ EOperationWrongJSONObject }
  EOperationWrongJSONObject = class(Exception);

{ TOperation }
  TOperation = class(TObject)
  private
    FOperationType: TOperationType;
    FID: String;
    FBlock: Int64;
    FReference: TJSONStringType;
    FSenderPublicKey: String;
    FSenderAddress: String;
    FReceiverAddress: String;
    FAmount: Int64;
    FFee: Int64;
    FSignature: String;

    FCreated: TDateTime;

    FCompressedJSON: Boolean;

    procedure setFromJSON(const AJSON: TJSONStringType);
    procedure setFromJSONData(const AJSONData: TJSONData);
    procedure setFromJSONObject(const AJSONObject: TJSONObject);
    procedure setFromStream(const AStream: TStream);

    function getAsJSON: TJSONStringType;
    function getAsJSONData: TJSONData;
    function getAsJSONObject: TJSONObject;
    function getAsStream: TStream;
  protected
  public
    constructor Create;
    constructor Create(const AJSON: TJSONStringType);
    constructor Create(const AJSONData: TJSONData);
    constructor Create(const AJSONObject: TJSONObject);
    constructor Create(const AStream: TStream);

    destructor Destroy; override;

    function FormatJSON(AOptions : TFormatOptions = DefaultFormat;
      AIndentsize : Integer = DefaultIndentSize): TJSONStringType;

    property OperationType: TOperationType
      read FOperationType
      write FOperationType;
    property ID: String
      read FID
      write FID;
    property Block: Int64
      read FBlock
      write FBlock;
    property Reference: TJSONStringType
      read FReference
      write FReference;
    property SenderPublicKey: String
      read FSenderPublicKey
      write FSenderPublicKey;
    property SenderAddress: String
      read FSenderAddress
      write FSenderAddress;
    property ReceiverAddress: String
      read FReceiverAddress
      write FReceiverAddress;
    property Amount: Int64
      read FAmount
      write FAmount;
    property Fee: Int64
      read FFee
      write FFee;
    property Signature: String
      read FSignature
      write FSignature;
    property Created: TDateTime
      read FCreated
      write FCreated;

    property CompressedJSON: Boolean
      read FCompressedJSON
      write FCompressedJSON;

    property AsJSON: TJSONStringType
      read getAsJSON;
    property AsJSONData: TJSONData
      read getAsJSONData;
    property AsJSONObject: TJSONObject
      read getAsJSONObject;
    property AsStream: TStream
      read getAsStream;
  published
  end;

implementation

uses
  DateUtils
, Noso.Data.Legacy
, Noso.JSON.Utils
;

{ TOperation }

procedure TOperation.setFromJSON(const AJSON: TJSONStringType);
var
  jData: TJSONData;
begin
  jData:= GetJSONData(AJSON);
  try
    setFromJSONData(jData);
  finally
    jData.Free;
  end;
end;

procedure TOperation.setFromJSONData(const AJSONData: TJSONData);
begin
  if aJSONData.JSONType <> jtObject then
  begin
    raise EOperationWrongJSONObject.Create('JSON data is not an object');
  end;
  setFromJSONObject(aJSONData as TJSONObject);
end;

procedure TOperation.setFromJSONObject(const AJSONObject: TJSONObject);
begin
  FOperationType:=
    TOperationType(AJSONObject.Get(cjOperationType, Ord(FOperationType)));
  FID:= AJSONObject.get(cjID, FID);
  FBlock:= AJSONObject.get(cjBlock, FBlock);
  FReference:= AJSONObject.get(cjReference, FReference);
  FSenderPublicKey:= AJSONObject.get(cjSenderPublicKey, FSenderPublicKey);
  FSenderAddress:= AJSONObject.get(cjSenderAddress, FSenderAddress);
  FReceiverAddress:= AJSONObject.get(cjReceiverAddress, FReceiverAddress);
  FAmount:= AJSONObject.get(cjAmount, FAmount);
  FFee:= AJSONObject.get(cjFee, FFee);
  FSignature:= AJSONObject.get(cjSignature, FSignature);
  FCreated:= UnixToDateTime(AJSONObject.get(cjCreated, DateTimeToUnix(FCreated)));
end;

procedure TOperation.setFromStream(const AStream: TStream);
var
  jData: TJSONData;
begin
  jData:= GetJSONData(AStream);
  try
    setFromJSONData(jData);
  finally
    jData.Free;
  end;
end;

function TOperation.getAsJSON: TJSONStringType;
var
  jObject: TJSONObject;
begin
  Result:= '';
  jObject:= getAsJSONObject;
  jObject.CompressedJSON:= FCompressedJSON;
  Result:= jObject.AsJSON;
  jObject.Free;
end;

function TOperation.getAsJSONData: TJSONData;
begin
  Result:= getAsJSONObject as TJSONData;
end;

function TOperation.getAsJSONObject: TJSONObject;
begin
  Result:= TJSONObject.Create;
  Result.Add(cjOperationType, Ord(FOperationType));
  Result.Add(cjID, FID);
  Result.Add(cjBlock, FBlock);
  Result.Add(cjReference, FReference);
  Result.Add(cjSenderPublicKey, FSenderPublicKey);
  Result.Add(cjSenderAddress, FSenderAddress);
  Result.Add(cjReceiverAddress, FReceiverAddress);
  Result.Add(cjAmount, FAmount);
  Result.Add(cjFee, FFee);
  Result.Add(cjSignature, FSignature);
  Result.Add(cjCreated, DateTimeToUnix(FCreated));
end;

function TOperation.getAsStream: TStream;
begin
  Result:= TStringStream.Create(getAsJSON, TEncoding.UTF8);
end;

function TOperation.FormatJSON(AOptions: TFormatOptions;
  AIndentsize: Integer): TJSONStringType;
begin
  Result:= getAsJSONObject.FormatJSON(AOptions, AIndentsize);
end;

constructor TOperation.Create;
begin
  inherited Create;
  FCompressedJSON:= True;
  FOperationType:= otUnknown;
  FID:= '';
  FBlock:= -1;
  FReference:= '';
  FSenderPublicKey:= '';
  FSenderAddress:= '';
  FReceiverAddress:= '';
  FAmount:= 0;
  FFee:= 0;
  FSignature:= '';
  FCreated:= UnixToDateTime(-1);
end;

constructor TOperation.Create(const AJSON: TJSONStringType);
begin
  Create;
  setFromJSON(AJSON);
end;

constructor TOperation.Create(const AJSONData: TJSONData);
begin
  Create;
  setFromJSONData(AJSONData);
end;

constructor TOperation.Create(const AJSONObject: TJSONObject);
begin
  Create;
  setFromJSONObject(AJSONObject);
end;

constructor TOperation.Create(const AStream: TStream);
begin
  Create;
  setFromStream(AStream);
end;

destructor TOperation.Destroy;
begin
  inherited Destroy;
end;

end.

