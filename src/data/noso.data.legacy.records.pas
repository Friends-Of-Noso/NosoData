unit Noso.Data.Legacy.Records;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

type

{ TLegacyBlockHeaderData }
  TLegacyBlockHeaderData = packed record
    Number         : Int64;
    TimeStart      : Int64;
    TimeEnd        : Int64;
    TimeTotal      : Integer;
    TimeLast20     : Integer;
    TrxTotales     : Integer;
    Difficult      : Integer;
    TargetHash     : String[32];
    Solution       : String[200];
    LastBlockHash  : String[32];
    NxtBlkDiff     : Integer;
    AccountMiner   : String[40];
    MinerFee       : Int64;
    Reward         : Int64;
  end;

{ TLegacyOrderData }
  TLegacyOrderData = packed record
    Block      : integer;
    OrderID    : String[64];
    OrderLines : Integer;
    OrderType  : String[6];
    TimeStamp  : Int64;
    Concept    : String[64];
    TrxLine    : integer;
    Sender     : String[120];
    Address    : String[40];
    Receiver   : String[40];
    AmmountFee : Int64;
    AmmountTrf : Int64;
    Signature  : String[120];
    TrfrID     : String[64];
  end;

{ TLegacyMyTrxData }
  TLegacyMyTrxData = packed record
    block    : integer;
    time     : int64;
    tipo     : string[6];
    receiver : string[64];
    monto    : int64;
    trfrID   : string[64];
    OrderID  : String[64];
    Concepto : String[64];
  end;

implementation

end.

