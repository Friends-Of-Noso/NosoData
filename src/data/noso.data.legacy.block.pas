unit Noso.Data.Legacy.Block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

type
{ TLegacyBlock }
  TLegacyBlock = class(TObject)
  private
  protected
  public
    constructor Create;
    destructor Destroy; override;
  published
  end;

implementation

{ TLegacyBlock }

constructor TLegacyBlock.Create;
begin
  //
end;

destructor TLegacyBlock.Destroy;
begin
  //
  inherited Destroy;
end;

end.

