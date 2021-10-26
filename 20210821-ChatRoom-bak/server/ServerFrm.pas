unit ServerFrm;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
    Vcl.StdCtrls, Vcl.ExtCtrls;

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
    System.Generics.Collections, Winapi.WinSock2, ScktComp;

var
    Server: TSocket;

var
    ClientList: TList<TSocket>;
{$R *.dfm}

procedure WorkerThread();
var
    CurSocketSet: TFdSet;
    // 等待的时间
    TimeVal: TTimeVal;
    Buf: array [0 .. 1023] of Char;
begin
    while (TRUE) do begin
        FormServer.MemoLog.Lines.Add('循环监听中....');
        FD_ZERO(CurSocketSet);

        for var i := 0 to ClientList.Count - 1 do begin
            _FD_SET(ClientList.Items[i], CurSocketSet);
        end;
        FormServer.MemoLog.Lines.Add('当前集合中的数量：' + CurSocketSet.fd_count.ToString);
        TimeVal.tv_sec := 2;
        TimeVal.tv_usec := 0;
        var
        Ret := select(0, @CurSocketSet, nil, nil, @TimeVal);
        // 超时
        if (Ret = 0) then continue;

        for var i := 0 to ClientList.Count - 1 do begin

            if (FD_ISSET(ClientList.Items[i], CurSocketSet)) then begin
                Ret := recv(ClientList.Items[i], Buf, length(Buf), 0);
                // Client socket closed
                if (Ret = 0) or (Ret = SOCKET_ERROR) or (WSAGetLastError() = WSAECONNRESET) then begin
                    FormServer.MemoLog.Lines.Add('客户端退出....' + i.ToString);
                    closesocket(ClientList.Items[i]);
                    ClientList.Delete(i);
                    // break;

                end

                else begin
                    FormServer.MemoRecord.Lines.Add(Buf);
                    for var index := 0 to ClientList.Count - 1 do begin
                        send(ClientList.Items[index], Buf, length(Buf), 0);
                    end;

                end;
            end;
        end;
        TThread.Sleep(10);
    end;
end;

procedure TFormServer.ButtonStartClick(Sender: TObject);
var
    ServerAddr: TSockAddrIn;

    Mode: Cardinal;
    // 服务器对象的容器集合
    CurSocketSet, ServerSocketSet: TFdSet;

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
    // 绑定IP和端口
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

    // 启用工作线程
    TThread.CreateAnonymousThread(WorkerThread).Start;

    TThread.CreateAnonymousThread(
        procedure
        begin

            while TRUE do begin
                FormServer.MemoLog.Lines.Add('等待客户端连接....');
                var
                AddrSize := sizeof(ServerAddr);
                var
                Client := accept(Server, @ServerAddr, @AddrSize);
                ClientList.Add(Client);
                FormServer.MemoLog.Lines.Add('新客户端....');
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
    if WSACleanup = SOCKET_ERROR then showmessage('清理版本库失败')

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

    ClientList := TList<TSocket>.create();
end;

end.
