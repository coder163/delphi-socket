unit ServerFrm;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
    TFormServer = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    MemoRecord: TMemo;
    MemoLog: TMemo;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditAddr: TEdit;
    EditPort: TEdit;
    MemoContent: TMemo;
    ButtonStart: TButton;
    GroupBox2: TGroupBox;
    Button1: TButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
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
uses
    Winapi.WinSock2, ScktComp;

var
    Server: TSocket;
{$R *.dfm}

procedure TFormServer.ButtonStartClick(Sender: TObject);
var
    ServerAddr: TSockAddrIn;
    //服务器对象的容器集合
    ServerSocketSet: TFdSet;

    //等待的时间
    TimeVal: TTimeVal;
begin

    // 创建服务器端对象
    Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // 创建是否成功
    if (Server = INVALID_SOCKET) then begin
        MemoLog.Lines.Add('服务器创建失败');
        exit;
    end;


    // 组装信息指定IP和端口
    with ServerAddr do begin

        sin_family := PF_INET;
        // 端口号
        sin_port := StrToInt(EditPort.Text);
        // 本机所有有可能的IP作为服务器端的IP
        sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(EditAddr.Text)));

    end;
    //绑定IP和端口
    if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then begin
        MemoLog.Lines.Add('端口号被占用');
        exit;
    end;

    // 监听当前的IP和端口号是否有客户端连接
    if listen(Server, SOMAXCONN) = SOCKET_ERROR then begin
        MemoLog.Lines.Add('监听失败');
        exit;
    end;

    ButtonStart.Enabled := false;

    TTHread.CreateAnonymousThread(
        procedure
        begin
            while True do begin
                //1、初始化FD_SET,初始化容器对象
                FD_ZERO(ServerSocketSet);

                //2、将待监听的Socket加入容器
                _FD_SET(Server, ServerSocketSet);
                //3、调用 select 函数，返回FD_SET的元素总数，select会更新 FD_SET 容器中的元素
                TimeVal.tv_sec := 2;
                TimeVal.tv_usec := 0;

                var Count := select(0, @ServerSocketSet, nil, nil, @TimeVal);
                //4、检查 FD_SET 容器中是否存在待处理的 Socket
                var AddrSize := SizeOf(ServerAddr);

                for var Index := 0 to Count - 1 do begin

                    //客户端对象
                    var Client := accept(Server, @ServerAddr, @AddrSize);

                    if Client <> INVALID_SOCKET then begin

                        //获取客户端的IP地址
                        MemoLog.Lines.Add('客户端IP：' + TCustomWinSocket.Create(Client).RemoteAddress);
                    end;

                end;
            end;
        end).Start;

end;

procedure TFormServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // 关闭socket对象
    if Server <> INVALID_SOCKET then begin
        closesocket(Server);
    end;

    // 清理版本库信息
    if WSACleanup = SOCKET_ERROR then
        showmessage('清理版本库失败')

end;

{ 初始化 }
procedure TFormServer.FormCreate(Sender: TObject);
var
    WSAData: TWSAData;
begin

    // 定义当前使用网络库版本
    if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then begin
        showmessage('初始化失败');
    end;
    MemoLog.Lines.Add('网络库初始化成功');
end;

end.

