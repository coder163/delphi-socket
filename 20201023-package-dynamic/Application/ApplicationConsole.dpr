program ApplicationConsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  WinAPI.windows, System.SysUtils;

type
  // 定义了一个类型
  TPackageProcedure = procedure(Num1, Num2: Integer); stdcall;

var
  Handle: HMODULE;

var
  // 定义一个和调用的那个函数的参数返回值一致的变量
  ShowMsg: function(Content: String): String; stdcall;
  PackageAdd: TPackageProcedure;

begin
  try
    try
      // 加载Package
      Handle := LoadPackage('PackageDynamic.bpl');

      @ShowMsg := GetProcAddress(Handle, 'ShowMessage');
      // 校验函数是否查找成功
      if @ShowMsg <> nil then
        Writeln(ShowMsg('Package的动态加载'));

      @PackageAdd := GetProcAddress(Handle, 'Add');
      // 校验函数是否查找成功
      if @PackageAdd <> nil then
        PackageAdd(10, 20);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
    // 卸载Package
    if Handle <> 0 then
      UnLoadPackage(Handle);

  end;

  readln;

end.
