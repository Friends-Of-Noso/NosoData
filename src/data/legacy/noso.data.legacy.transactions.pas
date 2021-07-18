unit Noso.Data.Legacy.Transactions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, Contnrs
, Noso.Data.Legacy.Transaction
;

type
{ TLegacyTransactions }
  TLegacyTransactions = class(TObject)
  private
    FTransactions: TFPObjectList;
    function GetCount: Integer;
    function GetTransaction(Index: Integer): TLegacyTransaction;
    procedure SetTransaction(Index: Integer; AValue: TLegacyTransaction);
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add(const ATransaction: TLegacyTransaction): Integer;
    procedure Delete(const AIndex: Integer);
    procedure Delete(const ATransaction: TLegacyTransaction);

    function LoadFromStream(
      const AStream: TStream;
      const ACount: Integer
    ): Int64;

    property Count: Integer
      read GetCount;
    property Items[Index: Integer]: TLegacyTransaction
      read GetTransaction
      write SetTransaction; default;
  published
  end;

implementation

{ TLegacyTransactions }

function TLegacyTransactions.GetTransaction(Index: Integer): TLegacyTransaction;
begin
  Result:= TLegacyTransaction(FTransactions.Items[Index]);
end;

function TLegacyTransactions.GetCount: Integer;
begin
  Result:= FTransactions.Count;
end;

procedure TLegacyTransactions.SetTransaction(
  Index: Integer;
  AValue: TLegacyTransaction
);
begin
  FTransactions.Items[Index]:= AValue;
end;

procedure TLegacyTransactions.Clear;
begin
  FTransactions.Clear;
end;

function TLegacyTransactions.Add(const ATransaction: TLegacyTransaction
  ): Integer;
begin
  Result:= FTransactions.Add(ATransaction);
end;

procedure TLegacyTransactions.Delete(const AIndex: Integer);
begin
  FTransactions.Delete(AIndex);
end;

procedure TLegacyTransactions.Delete(const ATransaction: TLegacyTransaction);
begin
  FTransactions.Delete(FTransactions.IndexOf(ATransaction));
end;

function TLegacyTransactions.LoadFromStream(
  const AStream: TStream;
  const ACount: Integer
): Int64;
var
  index: Integer = 0;
  bytesRead: Int64 = 0;
  transaction: TLegacyTransaction = nil;
begin
  Result:= 0;
  FTransactions.Clear;
  for index:= 0 to Pred(ACount) do
  begin
    transaction:= TLegacyTransaction.Create;
    bytesRead:= transaction.LoadFromStream(AStream);
    Inc(Result, bytesRead);
    FTransactions.Add(transaction);
  end;
end;

constructor TLegacyTransactions.Create;
begin
  FTransactions:= TFPObjectList.Create(True);
end;

destructor TLegacyTransactions.Destroy;
begin
  FTransactions.Free;
  inherited Destroy;
end;

end.

