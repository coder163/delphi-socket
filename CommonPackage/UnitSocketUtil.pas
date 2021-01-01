unit UnitSocketUtil;

{
  @Author �趯�Ĵ���
  @Date 2020-10-24 19:54
  @Desc Socket��̵Ĺ����༯��
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
    { ��ʼ�������,�ɹ�����0��ʧ�ܷ���-1 }
    class function InitSocket(): Integer;
    { ��������ָ��IP�Ͷ˿ںŵ�Socket���� }
    class function CreateServerSocket(Address: String; Port: Integer): TScoketRecord;
    { �����ͻ��˵�Socket }
    class function CreateClientSocket(Address: String; Port: Integer): TSocket;

    { �����ַ��� }
    class procedure SendString(Socket: TSocket; Content: array of Char);
    { ��ȡ�ַ��� }
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
  // ����Socket����
  Client := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // ��װIP�Ͷ˿���Ϣ
  with ClientAddr do begin
    sin_family := PF_INET;
    // �˿ں�
    sin_port := Port;

    // ���������п��ܵ�IP��Ϊ�������˵�IP
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Address)));
  end;
  // ���ӷ�����
  var
  ConnectResult := connect(Client, TSockAddr(ClientAddr), SizeOf(ClientAddr));
  if ConnectResult <> 0 then
    raise TWinSocketException.Create('���ӷ�����ʧ��');

  Result := Client;
end;

class function TWinSocketUtil.CreateServerSocket(Address: String; Port: Integer): TScoketRecord;

var
  ServerAddr: TSockAddrIn;
var
  ScoketRecord: TScoketRecord;
begin
  // �����������˶���
  var
  Server := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // �����Ƿ�ɹ�
  if (Server = INVALID_SOCKET) then begin
    raise TWinSocketException.Create('����������ʧ��');
    Exit;
  end;

  // ��������ָ��IP�Ͷ˿� ,��װ��Ϣ
  with ServerAddr do begin
    sin_family := PF_INET;
    // �˿ں�
    sin_port := Port;
    // ���������п��ܵ�IP��Ϊ�������˵�IP
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Address)));
  end;

  ScoketRecord.ServerAddr := ServerAddr;

  if bind(Server, TSockAddr(ServerAddr), SizeOf(ServerAddr)) = SOCKET_ERROR then begin

    raise TWinSocketException.Create('�˿ںű�ռ��');
    Exit;
  end;
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then begin

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
  if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then begin
    Result := -1;
    raise TWinSocketException.Create('������ʼ��ʧ��');
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
    raise TWinSocketException.Create('���ݷ���ʧ��');
  end;
end;

end.
