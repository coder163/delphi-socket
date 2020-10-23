unit UnitCallDynamic;

interface

// 动态加载Package-过程
procedure Add(Num1, Num2: Integer); stdcall;

// 动态加载Package-函数
function ShowMessage(Content: String): String; stdcall;

// 函数导出列表
exports Add, ShowMessage;

implementation

procedure Add(Num1, Num2: Integer); stdcall;
begin
  Writeln(Num1 + Num2);
end;

function ShowMessage(Content: String): String; stdcall;
begin
  Result := Content;
end;

end.
