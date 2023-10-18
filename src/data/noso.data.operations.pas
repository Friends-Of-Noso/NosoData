unit Noso.Data.Operations;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, Contnrs
, fpjson
, jsonparser
, Noso.Data.Operation
;

const
  cjOperationsID = 'operations-id';
  cjOperations   = 'operations';

resourcestring
  rsEOperationsWrongJSONObject = 'JSON data is not an object';

type
{ EOperationsWrongJSONObject }
  EOperationsWrongJSONObject = class(Exception);

  TOperationsEnumerator =  class; // Forward
{ TOperations }
  TOperations = class(TObject)
  private
    FOperationsID: String;
    FOperations: TFPObjectList;
    // Compressed JSON field to mimic TJSON one
    FCompressedJSON: Boolean;

    function GetCount: Integer;
    function GetOperation(Index: Integer): TOperation;
    procedure SetOperation(Index: Integer; AValue: TOperation);

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
    constructor Create; overload;
    constructor Create(const AJSON: TJSONStringType); overload;
    constructor Create(const AJSONData: TJSONData); overload;
    constructor Create(const AJSONObject: TJSONObject); overload;
    constructor Create(const AStream: TStream); overload;

    destructor Destroy; override;

    procedure Clear;
    function Add(const AOperation: TOperation): Integer;
    procedure Delete(const AIndex: Integer); overload;
    procedure Delete(const AOperation: TOperation); overload;

    function FormatJSON(
      AOptions : TFormatOptions = DefaultFormat;
      AIndentsize : Integer = DefaultIndentSize
    ): TJSONStringType;

    function GetEnumerator: TOperationsEnumerator;

    property OperationsID: String
      read FOperationsID
      write FOperationsID;
    property Count: Integer
      read GetCount;
    property Items[Index: Integer]: TOperation
      read GetOperation
      write SetOperation; default;

    property AsJSON: TJSONStringType
      read getAsJSON;
    property AsJSONData: TJSONData
      read getAsJSONData;
    property AsJSONObject: TJSONObject
      read getAsJSONObject;
    property AsStream: TStream
      read getAsStream;

    property CompressedJSON: Boolean
      read FCompressedJSON
      write FCompressedJSON;

  published
  end;

{ TOperationsEnumerator }
  TOperationsEnumerator = class(TObject)
  private
    FOperations: TOperations;
    FPosition: Integer;
  protected
  public
    constructor Create(const AOperations: TOperations);
    function GetCurrent: TOperation;
    function MoveNext: Boolean;

    property Current: TOperation
      read GetCurrent;
  published
  end;


implementation

{ TOperations }

function TOperations.GetCount: Integer;
begin
  Result:= FOperations.Count;
end;

function TOperations.GetOperation(Index: Integer): TOperation;
begin
  Result:= FOperations.Items[Index] as TOperation;
end;

procedure TOperations.SetOperation(Index: Integer; AValue: TOperation);
begin
  if FOperations.Items[Index] = AValue then exit;
  FOperations.Items[Index]:= AValue;
end;

procedure TOperations.setFromJSON(const AJSON: TJSONStringType);
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(AJSON);
  try
    setFromJSONData(jData);
  finally
    jData.Free;
  end;
end;

procedure TOperations.setFromJSONData(const AJSONData: TJSONData);
begin
  if AJSONData.JSONType <> jtObject then
  begin
    raise EOperationsWrongJSONObject.Create(rsEOperationsWrongJSONObject);
  end;
  setFromJSONObject(AJSONData as TJSONObject);
end;

procedure TOperations.setFromJSONObject(const AJSONObject: TJSONObject);
var
  index: Integer;
  jOperations: TJSONArray;
  operation: TOperation = nil;
begin
  FOperationsID:= AJSONObject.Get(cjOperationsID, FOperationsID);
  jOperations:= AJSONObject.Arrays[cjOperations];
  for index:= 0 to Pred(jOperations.Count) do
  begin
    operation:= TOperation.Create(jOperations[index]);
    FOperations.Add(operation);
  end;
end;

procedure TOperations.setFromStream(const AStream: TStream);
var
  jData: TJSONData = nil;
begin
  jData:= GetJSON(AStream);
  try
    setFromJSONData(jData);
  finally
    jData.Free;
  end;
end;

function TOperations.getAsJSON: TJSONStringType;
var
  jObject: TJSONObject = nil;
begin
  Result:= EmptyStr;
  jObject:= getAsJSONObject;
  jObject.CompressedJSON:= FCompressedJSON;
  Result:= jObject.AsJSON;
  jObject.Free;
end;

function TOperations.getAsJSONData: TJSONData;
begin
  Result:= getAsJSONObject as TJSONData;
end;

function TOperations.getAsJSONObject: TJSONObject;
var
  index: Integer;
  jData: TJSONData = nil;
  jOperations: TJSONArray;
begin
  Result:= TJSONObject.Create;
  Result.Add(cjOperationsID, FOperationsID);
  jOperations:= TJSONArray.Create;
  Result.Add(cjOperations, jOperations);
  for index := 0 to Pred(FOperations.Count) do
  begin
    jData:= TOperation(FOperations.Items[index]).AsJSONData;
    jOperations.Add(jData);
  end;
end;

function TOperations.getAsStream: TStream;
begin
  Result:= TStringStream.Create(getAsJSON, TEncoding.UTF8);
end;

procedure TOperations.Clear;
begin
  FOperationsID:= EmptyStr;
  FOperations.Clear;
end;

function TOperations.Add(const AOperation: TOperation): Integer;
begin
  Result:= FOperations.Add(AOperation);
end;

procedure TOperations.Delete(const AIndex: Integer);
begin
  FOperations.Delete(AIndex);
end;

procedure TOperations.Delete(const AOperation: TOperation);
var
  index: Integer;
begin
  index:= FOperations.IndexOf(AOperation);
  FOperations.Delete(index);
end;

function TOperations.FormatJSON(
  AOptions: TFormatOptions;
  AIndentsize: Integer
): TJSONStringType;
var
  objectJSON: TJSONObject;
begin
  objectJSON:= getAsJSONObject;
  Result:= objectJSON.FormatJSON(AOptions, AIndentsize);
  objectJSON.Free;
end;

function TOperations.GetEnumerator: TOperationsEnumerator;
begin
  Result:= TOperationsEnumerator.Create(Self);
end;

constructor TOperations.Create;
begin
  FOperationsID:= EmptyStr;
  FCompressedJSON:= True;
  FOperations:= TFPObjectList.Create(True);
end;

constructor TOperations.Create(const AJSON: TJSONStringType);
begin
  Create;
  setFromJSON(AJSON);
end;

constructor TOperations.Create(const AJSONData: TJSONData);
begin
  Create;
  setFromJSONData(AJSONData);
end;

constructor TOperations.Create(const AJSONObject: TJSONObject);
begin
  Create;
  setFromJSONObject(AJSONObject);
end;

constructor TOperations.Create(const AStream: TStream);
begin
  Create;
  setFromStream(AStream);
end;

destructor TOperations.Destroy;
begin
  FOperations.Free;
  inherited Destroy;
end;

{ TOperationsEnumerator }

constructor TOperationsEnumerator.Create(const AOperations: TOperations);
begin
  FOperations := AOperations;
  FPosition := -1;
end;

function TOperationsEnumerator.GetCurrent: TOperation;
begin
  Result:= FOperations.Items[FPosition] as TOperation;
end;

function TOperationsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FOperations.Count;
end;

end.

