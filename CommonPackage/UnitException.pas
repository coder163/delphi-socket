unit UnitException;

{
  @Author 舞动的代码
  @Date 2020-10-24 19:54
  @Desc 自定义异常相关类的单元
}
interface

uses System.SysUtils;

type

  { 网络异常 }
  TWinSocketException = class(Exception)

    { 构造方法 }
    constructor Create(const Msg: string);
  end;

implementation

{ TWinSocketException }

constructor TWinSocketException.Create(const Msg: string);
begin
  inherited Create(Msg);
end;

end.
