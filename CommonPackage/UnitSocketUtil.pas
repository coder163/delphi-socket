unit UnitSocketUtil;

{
  @Author 舞动的代码
  @Date 2020-10-24 19:54
  @Desc Socket编程的工具类集合
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
    { 初始化网络库,成功返回0，失败返回-1 }
    class function InitSocket(): Integer;
    { 创建并绑定指定IP和端口号的Socket对象 }
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
  // 创建服务器端对象
  var
  Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // 创建是否成功
  if (Server = INVALID_SOCKET) then
  begin
    raise TWinSocketException.Create('服务器创建失败');
    Exit;
  end;

  // 给服务器指定IP和端口 ,组装信息
  with ServerAddr do
  begin
    sin_family := PF_INET;
    // 端口号
    sin_port := Port;
    // 本机所有有可能的IP作为服务器端的IP
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Address)));
  end;

  ScoketRecord.ServerAddr := ServerAddr;

  if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then
  begin

    raise TWinSocketException.Create('端口号被占用');
    Exit;
  end;
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then
  begin

    raise TWinSocketException.Create('监听失败');
    Exit;
  end;
  ScoketRecord.Scoket := Server;
  Result := ScoketRecord;
end;

class function TWinSocketUtil.InitSocket: Integer;

var
  WSAData: TWSAData;
begin
  // 定义当前使用网络库版本
  if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then
  begin
    Result := -1;
    raise TWinSocketException.Create('网络库初始化失败');
  end;
  Result := 0;
end;

end.
