unit ServerFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ButtonStart: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

// 引用的单元
uses Winapi.WinSock2, ScktComp;

var
  Server: TSocket;
{$R *.dfm}

procedure TForm1.ButtonStartClick(Sender: TObject);
var

  ServerAddr: TSockAddrIn;

begin
  // 创建服务器端对象
  Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // 创建是否成功
  if (Server = INVALID_SOCKET) then
  begin
    Memo1.Lines.Add('服务器创建失败');
    exit;
  end;
  Memo1.Lines.Add('服务器创建成功');

  // 给服务器指定IP和端口
  // 组装信息
  with ServerAddr do
  begin

    sin_family := PF_INET;
    // 端口号
    sin_port := 8080;
    // 本机所有有可能的IP作为服务器端的IP
    // sin_addr.S_addr:=INaddr_any;
    sin_addr.S_addr := inet_addr('127.0.0.1');

  end;
  if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then
  begin
    Memo1.Lines.Add('端口号被占用');
    exit;
  end;
  Memo1.Lines.Add('IP和端口绑定成功');
  // 监听当前的IP和端口号是否有客户端连接
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then
  begin
    Memo1.Lines.Add('监听失败');
    exit;
  end;
  Memo1.Lines.Add('监听成功');
  // 获取客户端连接对象，

  // TODO 当连接失败时我们需要进行处理
  var
  AddrSize := sizeof(ServerAddr);
  var
  ClientSocket := accept(Server, @ServerAddr, @AddrSize);

  if ClientSocket = INVALID_SOCKET then
  begin
    case ClientSocket of
      WSAEFAULT:
        Memo1.Lines.Add('IP获取失败')
    end;
    Memo1.Lines.Add('获取连接失败');
    exit;
  end;

  // 当上面result返回0时表示有客户端成功连接到当前服务器
  // 当客户端连接成功时，显示一下客户端的IP
  var
  CustomWinSocket := TCustomWinSocket.Create(ClientSocket);
  Memo1.Lines.Add('客户端IP：' + CustomWinSocket.RemoteAddress);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // 关闭socket对象
  if Server <> INVALID_SOCKET then
  begin
    closesocket(Server);
  end;

  // 清理版本库信息
  if WSACleanup = SOCKET_ERROR then
    showmessage('清理版本库失败')

end;

{ 初始化 }
procedure TForm1.FormCreate(Sender: TObject);
const
  // 网络库版本号2.2
  WINSOCKET_VERSION = $0202;
var

  WSAData: TWSAData;

begin

  // 定义当前使用网络库版本
  if WSAStartup(WINSOCKET_VERSION, WSAData) <> 0 then
  begin
    showmessage('初始化失败');
  end;
  Memo1.Lines.Add('网络库初始化成功');
end;

end.
