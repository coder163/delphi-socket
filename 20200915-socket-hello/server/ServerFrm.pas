unit ServerFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormServer = class(TForm)
    MemoContent: TMemo;
    ButtonStart: TButton;
    MemoRecord: TMemo;
    MemoLog: TMemo;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditAddr: TEdit;
    EditPort: TEdit;
    ButtonSend: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormServer: TFormServer;

implementation

// 引用的单元
uses Winapi.WinSock2, ScktComp;

var
  Server: TSocket;
{$R *.dfm}

procedure TFormServer.ButtonStartClick(Sender: TObject);
var

  ServerAddr: TSockAddrIn;

begin
  // 创建服务器端对象
  Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // 创建是否成功
  if (Server = INVALID_SOCKET) then
  begin
    MemoLog.Lines.Add('服务器创建失败');
    exit;
  end;

  // 给服务器指定IP和端口
  // 组装信息
  with ServerAddr do
  begin

    sin_family := PF_INET;
    // 端口号
    sin_port := StrToInt(EditPort.Text);
    // 本机所有有可能的IP作为服务器端的IP
    // sin_addr.S_addr:=INaddr_any;
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(EditAddr.Text)));

  end;
  if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then
  begin
    MemoLog.Lines.Add('端口号被占用');
    exit;
  end;

  // 监听当前的IP和端口号是否有客户端连接
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then
  begin
    MemoLog.Lines.Add('监听失败');
    exit;
  end;

  ButtonStart.Enabled := false;
  TThread.CreateAnonymousThread(
    procedure
    begin

      // 获取客户端连接对象，
      var
      AddrSize := sizeof(ServerAddr);
      var
      ClientSocket := accept(Server, @ServerAddr, @AddrSize);

      if ClientSocket = INVALID_SOCKET then
      begin
        case ClientSocket of
          WSAEFAULT:
            MemoLog.Lines.Add('IP获取失败')
        end;
        MemoLog.Lines.Add('获取连接失败');
        exit;
      end;

      // 当上面result返回0时表示有客户端成功连接到当前服务器
      // 当客户端连接成功时，显示一下客户端的IP
      var
      CustomWinSocket := TCustomWinSocket.Create(ClientSocket);
      MemoLog.Lines.Add('客户端IP：' + CustomWinSocket.RemoteAddress);

      // 发送一句话
      var
      SendResult := send(ClientSocket, '欢迎你来到老侯的直播间', 1024, 0);

      if (SendResult = SOCKET_ERROR) or (SendResult <= 0) then
      begin
        MemoLog.Lines.Add('数据发送失败');
      end;

    end).Start;

end;

procedure TFormServer.FormClose(Sender: TObject; var Action: TCloseAction);
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
procedure TFormServer.FormCreate(Sender: TObject);
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
  MemoLog.Lines.Add('网络库初始化成功');
end;

end.
