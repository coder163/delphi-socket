unit UnitSocketUtil;

{
  @Author �趯�Ĵ���
  @Date 2020-10-24 19:54
  @Desc Socket��̵Ĺ����༯��
}
interface

uses Winapi.Windows, Winapi.WinSock2, ScktComp;

type
  TScoketRecord = record
    ServerAddr: TSockAddrIn;
    Scoket: TSocket;
  end;

  TWinSocketUtil = class

  public
    { ��ʼ�������,�ɹ�����0��ʧ�ܷ���-1 }
    class function InitSocket(): Integer;
    { ��������ָ��IP�Ͷ˿ںŵ�Socket���� }
    class function CreateSocket(Address: String; Port: Integer): TScoketRecord;
  end;

implementation

uses UnitException;

{ TWinSocketUtil }
class function TWinSocketUtil.CreateSocket(Address: String; Port: Integer)
  : TScoketRecord;
var
  ServerAddr: TSockAddrIn;
var
  ScoketRecord: TScoketRecord;
begin
  // �����������˶���
  var
  Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // �����Ƿ�ɹ�
  if (Server = INVALID_SOCKET) then
  begin
    raise TWinSocketException.Create('����������ʧ��');
    Exit;
  end;

  // ��������ָ��IP�Ͷ˿� ,��װ��Ϣ
  with ServerAddr do
  begin
    sin_family := PF_INET;
    // �˿ں�
    sin_port := Port;
    // ���������п��ܵ�IP��Ϊ�������˵�IP
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Address)));
  end;

  ScoketRecord.ServerAddr := ServerAddr;

  if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then
  begin

    raise TWinSocketException.Create('�˿ںű�ռ��');
    Exit;
  end;
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then
  begin

    raise TWinSocketException.Create('����ʧ��');
    Exit;
  end;
  ScoketRecord.Scoket := Server;
  Result := ScoketRecord;
end;

class function TWinSocketUtil.InitSocket: Integer;

var
  WSAData: TWSAData;
begin
  // ���嵱ǰʹ�������汾
  if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then
  begin
    Result := -1;
    raise TWinSocketException.Create('������ʼ��ʧ��');
  end;
  Result := 0;
end;

end.
