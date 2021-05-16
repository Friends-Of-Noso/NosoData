unit Noso.Data.Legacy;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
{ TLegacyOrderData }
  TLegacyOrderData = Packed Record
    Block : integer;
    OrderID : String[64];
    OrderLines : Integer;
    OrderType : String[6];
    TimeStamp : Int64;
    Concept : String[64];
    TrxLine : integer;
    Sender : String[120];
    Address : String[40];
    Receiver : String[40];
    AmmountFee : Int64;
    AmmountTrf : Int64;
    Signature : String[120];
    TrfrID : String[64];
  end;

{ TLegacyMyTrxData }
  TLegacyMyTrxData = packed record
    block : integer;
    time  : int64;
    tipo  : string[6];
    receiver : string[64];
    monto    : int64;
    trfrID   : string[64];
    OrderID  : String[64];
    Concepto : String[64];
  end;

implementation

end.

