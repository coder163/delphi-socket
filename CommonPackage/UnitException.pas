unit UnitException;

{
  @Author �趯�Ĵ���
  @Date 2020-10-24 19:54
  @Desc �Զ����쳣�����ĵ�Ԫ
}
interface

uses System.SysUtils;

type

  { �����쳣 }
  TWinSocketException = class(Exception)

    { ���췽�� }
    constructor Create(const Msg: string);
  end;

implementation

{ TWinSocketException }

constructor TWinSocketException.Create(const Msg: string);
begin
  inherited Create(Msg);
end;

end.
