unit ClientFrm;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
    TFormClient = class(TForm)
        ButtonConnection: TButton;
        MemoContent: TMemo;
        MemoRecord: TMemo;
        GroupBox1: TGroupBox;
        MemoLog: TMemo;
        Label1: TLabel;
        Label2: TLabel;
        EditAddr: TEdit;
        EditPort: TEdit;
        ButtonSend: TButton;
        procedure ButtonConnectionClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure ButtonSendClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    FormClient: TFormClient;

implementation

{$R *.dfm}

// 引用的单元
uses
    Winapi.WinSock2, ScktComp;

var
    Client: TSocket;

procedure TFormClient.ButtonConnectionClick(Sender: TObject);
var
    ServerAddr: TSockAddrIn;
    RecvContent: array[0..1023] of Char;
begin



    // 创建Socket对象
    Client := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // 组装IP和端口信息
    with ServerAddr do begin
        sin_family := PF_INET;
        // 端口号
        sin_port := StrToInt(EditPort.Text);

        // 本机所有有可能的IP作为服务器端的IP
        sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(EditAddr.Text)));
    end;
    // 连接服务器
    var ConnectResult := connect(Client, TSockAddr(ServerAddr), SizeOf(ServerAddr));
    if ConnectResult <> 0 then begin
        MemoLog.Lines.Add('连接失败');

    end;
    ButtonConnection.Enabled := false;

    TThread.CreateAnonymousThread(
        procedure
        begin
            // 读取数据
            while True do begin
                var RecvResult := recv(Client, RecvContent, length(RecvContent), 0);
                if RecvResult > 0 then begin
                    MemoRecord.Lines.Add(RecvContent);

                end;
            end;
        end).Start;

end;

procedure TFormClient.ButtonSendClick(Sender: TObject);
var
    Buf: array[0..1023] of Char;
begin
    //字符串复制
    StrCopy(@Buf, PChar(MemoContent.Text));
    // 发送内容
    var SendResult := send(Client, Buf, Length(Buf), 0);

    if (SendResult = SOCKET_ERROR) or (SendResult <= 0) then begin
        MemoLog.Lines.Add('数据发送失败');
    end;
    MemoContent.Text := '';
end;

procedure TFormClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // 关闭socket对象
    if Client <> INVALID_SOCKET then begin
        closesocket(Client);
    end;

    // 清理版本库信息
    if WSACleanup = SOCKET_ERROR then
        showmessage('清理版本库失败')
end;

procedure TFormClient.FormCreate(Sender: TObject);
var
    WSAData: TWSAData;
begin
    // 初始化网络库版本
    if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then
        FormClient.Caption := '网络库加载失败'
end;

end.

