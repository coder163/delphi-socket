unit UnitDynamicClass;

interface

type
  TUser = class

  public
    function ShowMessage(Content: String): String;
  end;

implementation

{ TUser }

function TUser.ShowMessage(Content: String): String;
begin

  Result := Content;
end;

end.
