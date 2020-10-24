program ApplicationConsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Rtti, WinAPI.windows, System.SysUtils;

type
  // 定义了一个类型
  TPackageProcedure = procedure(Num1, Num2: Integer); stdcall;

var
  Handle: HMODULE = 0;

var
  // 定义一个和调用的那个函数的参数返回值一致的变量
  ShowMsg: function(Content: String): String; stdcall;
  PackageAdd: TPackageProcedure;

procedure LoadUnitPorcedure();
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
end;

begin
  try
    try
      // 动态加载Package
      Handle := LoadPackage('PackageDynamic.bpl');
      // 创建上下文对象，该对象中存储了所有运行期类的信息
      var
      Context := TRttiContext.Create;

      // 获取指定的class类型：TRttiType
      var
      ClassType := Context.FindType('UnitDynamicClass.TUser');

      // 获取运行期类型实例
      var
      Instance := ClassType.AsInstance;
      // 通过运行期实例获取引用类型TClass
      var
      Metaclass := Instance.MetaclassType;

      // 获取构造方法的对象:TRttiMethod
      var
      CreateMethod := Instance.GetMethod('Create');
      // 通过构造方法创建TUser对象
      var
      User := CreateMethod.Invoke(Metaclass, []);

      var
      Msg := Instance.GetMethod('ShowMessage').Invoke(User, ['反射方式调用函数']);

      Writeln(Msg.AsString);
    except
      On E: Exception do
        Writeln(E.ClassName, ': ', E.Message);

    end;
  finally
    // 卸载Package
    if Handle <> 0 then
      UnLoadPackage(Handle);

  end;
  readln;

end.
