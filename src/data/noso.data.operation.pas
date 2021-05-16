unit Noso.Data.Operation;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
;

type
{ TOperationTypes }
  TOperationTypes = (otUnknown, otTransfer, otCustom);

{ TOperation }
  TOperation = class(TObject)
  private
    FOperationType: TOperationTypes;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    property OperationType: TOperationTypes
      read FOperationType
      write FOperationType;
  published
  end;

implementation

uses
  Noso.Data.Legacy
;

{ TOperation }

constructor TOperation.Create;
begin
  inherited Create;
  FOperationType:= otUnknown;
end;

destructor TOperation.Destroy;
begin
  inherited Destroy;
end;

end.

