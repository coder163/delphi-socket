unit MainFrm;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
    TForm1 = class(TForm)
        Memo1: TMemo;
        Memo2: TMemo;
        BtnConnection: TButton;
        BtnSend: TButton;
    Memo3: TMemo;
        procedure FormCreate(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure BtnConnectionClick(Sender: TObject);
        procedure BtnSendClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}

uses
    Winapi.WinSock2, ScktComp;

var

    ClientSocket: TSocket;
    ClientAddr: TSockAddrIn;

procedure TForm1.BtnConnectionClick(Sender: TObject);
begin
    BtnConnection.Enabled := false;
    // 连接服务器
    var
    ConnectResult := connect(ClientSocket, TSockAddr(ClientAddr),
      SizeOf(ClientAddr));

    if ConnectResult = 0 then begin
        self.Memo1.Lines.Add('连接成功');
    end
    else begin
        self.Memo1.Lines.Add('连接失败');
    end;
end;

procedure TForm1.BtnSendClick(Sender: TObject);
begin

    // 连接服务器
    var
    ConnectResult := connect(ClientSocket, TSockAddr(ClientAddr),
      SizeOf(ClientAddr));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // 关闭socket对象
    if ClientSocket <> INVALID_SOCKET then begin
        closesocket(ClientSocket);
    end;

    // 清理版本库信息
    if WSACleanup = SOCKET_ERROR then
        showmessage('清理版本库失败')

end;

procedure TForm1.FormCreate(Sender: TObject);

var
    WSAData: TWSAData;

begin
    if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then begin
        self.Caption := '网络库初始化失败';
        exit;
    end;
    ClientSocket := Socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // 组装IP和端口信息
    with ClientAddr do begin
        sin_family := PF_INET;
        // 端口号
        sin_port := 10086;
        // 本机所有有可能的IP作为服务器端的IP
        sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString('127.0.0.1')));
    end;
    self.Caption := '网络库初始化成功';
end;

end.
