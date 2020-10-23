unit UnitHello;

interface

uses Vcl.Dialogs;

// Package过程案例
procedure HelloWorld(StrContent: String);

// Package函数案例
function GetHelloWorld(StrContent: String): String;

// Package类案例
type
  TUser = class
  public
    function Add(Num1, Num2: Integer): Integer;
  end;

implementation

procedure HelloWorld(StrContent: String);
begin
  ShowMessage(StrContent);
end;

function GetHelloWorld(StrContent: String): String;
begin

  Result := StrContent;
end;

{ TUser }

function TUser.Add(Num1, Num2: Integer): Integer;
begin
  Result := Num1 + Num2;
end;

end.
