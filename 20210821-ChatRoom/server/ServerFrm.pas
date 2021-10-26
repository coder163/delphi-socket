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
    // 客户端列表
    ClientList: TList<TSocket>;
{$R *.dfm}

    { 无限监听集合 }
procedure WorkThread();
var
    CurSet: TFdSet;
    TimeVal: TTimeVal;
    Buf: array [0 .. 1023] of Char;
begin

    // 无限监听
    while True do begin
        FormServer.MemoLog.Lines.add('当前的客户端数量：' + ClientList.Count.ToString);
        // 清空
        FD_ZERO(CurSet);
        // 初始化CureSet 赋值
        for var Index := 0 to ClientList.Count - 1 do begin
            _FD_SET(ClientList.Items[Index], CurSet);
        end;
        // 等待时间
        TimeVal.tv_sec := 2;
        TimeVal.tv_usec := 0;

        // 轮询
        var
        Ret := select(0, @CurSet, nil, nil, @TimeVal);

        if Ret = 0 then begin
            FormServer.MemoLog.Lines.add('连接超时');
            Continue;
        end;

        // 遍历有可读数据的socket
        for var Index := 0 to ClientList.Count - 1 do begin
            // 当前的ClientList[Index]是否在 集合中CurSet
            if FD_ISSET(ClientList[Index], CurSet) then begin

                // 读取数据
                var
                hStatus := recv(ClientList[Index], Buf, length(Buf), 0);
                // ret == 0 || (ret == SOCKET_ERROR && WSAGetLastError() == WSAECONNRESET

                if (hStatus = 0) or ((hStatus = SOCKET_ERROR) and (WSAGetLastError() = WSAECONNRESET)) then begin
                    FormServer.MemoLog.Lines.add(Index.ToString() + '：退出群聊');
                    closesocket(ClientList[Index]);
                    ClientList.Delete(Index);

                end
                else begin
                    for var i := 0 to ClientList.Count - 1 do send(ClientList[i], Buf, length(Buf), 0);
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

begin
    // 初始化列表对象
    ClientList := TList<TSocket>.create();

    // 创建服务器端对象
    Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // 创建是否成功
    if (Server = INVALID_SOCKET) then begin
        MemoLog.Lines.add('服务器创建失败');
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
        MemoLog.Lines.add('端口号被占用');
        exit;
    end;

    // 监听当前的IP和端口号是否有客户端连接
    if listen(Server, SOMAXCONN) = SOCKET_ERROR then begin
        MemoLog.Lines.add('监听失败');
        exit;
    end;
    ButtonStart.Enabled := false;

    // select accept VC驿站

    // 1、无限监听(线程) accept ：存入集合
    TThread.CreateAnonymousThread(
        procedure
        begin

            while True do begin
                var
                nAddrLen := sizeof(ServerAddr);
                // 阻塞执行，一旦有客户端连接，代码会继续
                var
                Client := accept(Server, @ServerAddr, @nAddrLen);
                MemoLog.Lines.add('新客户端连接');
                // FD_SET,自己创建数组（数组长度就是FD_SET）、泛型容器
                ClientList.add(Client);
            end;
        end).Start;
    // 2、无限监听(线程) select  ：监听集合中所有的socket,有读数据则进行读写操作
    TThread.CreateAnonymousThread(WorkThread).Start;
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
    MemoLog.Lines.add('网络库初始化成功');

    ClientList := TList<TSocket>.create();
end;

end.
