unit UnitSocketUtil;

{
  @Author 舞动的代码
  @Date 2020-10-24 19:54
  @Desc Socket编程的工具类集合
}
interface

uses Vcl.Dialogs, System.SysUtils, System.Classes, Winapi.Windows, Winapi.WinSock2, ScktComp;

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
    class function CreateServerSocket(Address: String; Port: Integer): TScoketRecord;
    { 创建客户端的Socket }
    class function CreateClientSocket(Address: String; Port: Integer): TSocket;

    { 发送字符串 }
    class procedure SendString(Socket: TSocket; Content: array of Char);
    { 读取字符串 }
    class function RecvString(Socket: TSocket): TStringList;
  end;

implementation

uses UnitException;

{ TWinSocketUtil }
class function TWinSocketUtil.CreateClientSocket(Address: String; Port: Integer): TSocket;
var
  Client: TSocket;
  ClientAddr: TSockAddrIn;
begin
  // 创建Socket对象
  Client := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // 组装IP和端口信息
  with ClientAddr do begin
    sin_family := PF_INET;
    // 端口号
    sin_port := Port;

    // 本机所有有可能的IP作为服务器端的IP
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Address)));
  end;
  // 连接服务器
  var
  ConnectResult := connect(Client, TSockAddr(ClientAddr), SizeOf(ClientAddr));
  if ConnectResult <> 0 then
    raise TWinSocketException.Create('连接服务器失败');

  Result := Client;
end;

class function TWinSocketUtil.CreateServerSocket(Address: String; Port: Integer): TScoketRecord;

var
  ServerAddr: TSockAddrIn;
var
  ScoketRecord: TScoketRecord;
begin
  // 创建服务器端对象
  var
  Server := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // 创建是否成功
  if (Server = INVALID_SOCKET) then begin
    raise TWinSocketException.Create('服务器创建失败');
    Exit;
  end;

  // 给服务器指定IP和端口 ,组装信息
  with ServerAddr do begin
    sin_family := PF_INET;
    // 端口号
    sin_port := Port;
    // 本机所有有可能的IP作为服务器端的IP
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Address)));
  end;

  ScoketRecord.ServerAddr := ServerAddr;

  if bind(Server, TSockAddr(ServerAddr), SizeOf(ServerAddr)) = SOCKET_ERROR then begin

    raise TWinSocketException.Create('端口号被占用');
    Exit;
  end;
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then begin

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
  if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then begin
    Result := -1;
    raise TWinSocketException.Create('网络库初始化失败');
  end;
  Result := 0;
end;

class function TWinSocketUtil.RecvString(Socket: TSocket): TStringList;
var
  RecvContent: array [0 .. 123] of Char;

  StringList: TStringList;

begin
  StringList := TStringList.Create;

  while True do begin

    var
    RecvResult := recv(Socket, RecvContent, length(RecvContent), 0);

    StringList.Add(string(RecvContent));

    if RecvResult <= length(RecvContent) then
      break;

  end;

  Result := StringList;

end;

class procedure TWinSocketUtil.SendString(Socket: TSocket; Content: array of Char);
begin
  var

  SendResult := send(Socket, Content, length(Content), 0);

  if (SendResult = SOCKET_ERROR) then begin
    raise TWinSocketException.Create('数据发送失败');
  end;
end;

end.
