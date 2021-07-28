unit Noso.Data.Legacy.Wallet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, Contnrs
, Noso.Data.Legacy.Address
;

type
  TLegacyWalletEnumerator = class; // Forward
{ TLegacyWallet }
  TLegacyWallet = class(TObject)
  private
    FAddresses: TFPObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TLegacyAddress;
    procedure SetItem(Index: Integer; AValue: TLegacyAddress);
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add(const AAddress: TLegacyAddress): Integer;
    procedure Delete(const AAddress: TLegacyAddress);

    function GetEnumerator: TLegacyWalletEnumerator;

    property Count: Integer
      read GetCount;
    property Items[Index: Integer]: TLegacyAddress
      read GetItem
      write SetItem;
  published
  end;


{ TLegacyWalletEnumerator }
  TLegacyWalletEnumerator = class
  private
    FLegacyWallet: TLegacyWallet;
    FPosition: Integer;
  protected
  public
    constructor Create(const ALegacyWallet: TLegacyWallet);
    function GetCurrent: TLegacyAddress;
    function MoveNext: Boolean;

    property Current: TLegacyAddress
      read GetCurrent;
  published
  end;

implementation

{ TLegacyWallet }

function TLegacyWallet.GetItem(Index: Integer): TLegacyAddress;
begin
  Result:= FAddresses.Items[Index] as TLegacyAddress;
end;

function TLegacyWallet.GetCount: Integer;
begin
  Result:= FAddresses.Count;
end;

procedure TLegacyWallet.SetItem(Index: Integer; AValue: TLegacyAddress);
begin
  if FAddresses.Items[Index] = AValue then exit;
  FAddresses.Items[Index]:= AValue;
end;

procedure TLegacyWallet.Clear;
begin
  FAddresses.Clear;
end;

function TLegacyWallet.Add(const AAddress: TLegacyAddress): Integer;
begin
  Result:= FAddresses.Add(AAddress);
end;

procedure TLegacyWallet.Delete(const AAddress: TLegacyAddress);
begin
  FAddresses.Delete(FAddresses.IndexOf(AAddress));
end;

function TLegacyWallet.GetEnumerator: TLegacyWalletEnumerator;
begin
  Result:= TLegacyWalletEnumerator.Create(Self);
end;

constructor TLegacyWallet.Create;
begin
  FAddresses:= TFPObjectList.Create(True);
end;

destructor TLegacyWallet.Destroy;
begin
  FAddresses.Free;
  inherited Destroy;
end;

{ TLegacyWalletEnumerator }

constructor TLegacyWalletEnumerator.Create(const ALegacyWallet: TLegacyWallet);
begin
  FLegacyWallet:= ALegacyWallet;
  FPosition:= -1;
end;

function TLegacyWalletEnumerator.GetCurrent: TLegacyAddress;
begin
  Result:= FLegacyWallet.Items[FPosition];
end;

function TLegacyWalletEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FLegacyWallet.Count;
end;

end.

