unit TestNosoDataLegacyBlock;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, Noso.Data.Legacy.Block
;

type
{ TTestNosoDataLegacyBlock }
  TTestNosoDataLegacyBlock = class(TTestCase)
  private
    FLegacyBlock: TLegacyBlock;

    procedure CheckFieldsCreate;
  protected
  public
  published
    procedure TestNosoDataLegacyBlockCreate;
  end;

implementation

{ TTestNosoDataLegacyBlock }

procedure TTestNosoDataLegacyBlock.CheckFieldsCreate;
begin

end;

procedure TTestNosoDataLegacyBlock.TestNosoDataLegacyBlockCreate;
begin
  FLegacyBlock:= TLegacyBlock.Create;
  CheckFieldsCreate;
  FLegacyBlock.Free;
end;

initialization
  RegisterTest(TTestNosoDataLegacyBlock);
end.

