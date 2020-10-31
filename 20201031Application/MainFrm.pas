unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    ButtonStartServer: TButton;
    ButtonStartClient: TButton;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonStartServerClick(Sender: TObject);
    procedure ButtonStartClientClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UnitSocketUtil, Winapi.WinSock2, ScktComp;
{$R *.dfm}

var
  ServerScoket: TScoketRecord;
  ClientSocket: TSocket;

procedure TForm1.ButtonStartClientClick(Sender: TObject);
begin
  ClientSocket := TWinSocketUtil.CreateClientSocket('127.0.0.1', 10086);

  var
  StringList := TWinSocketUtil.RecvString(ClientSocket);

  ShowMessage(StringList.Text);

  ButtonStartClient.Enabled := false;
end;

procedure TForm1.ButtonStartServerClick(Sender: TObject);
begin
  // 创建服务器端的Socket
  ServerScoket := TWinSocketUtil.CreateServerSocket('127.0.0.1', 10086);
  ButtonStartServer.Enabled := false;
  // 发送字符串
  TThread.CreateAnonymousThread(
    procedure
    var
      Content: array [0 .. 1023] of Char;
    begin
      // 获取客户端连接对象，
      var
      AddrSize := sizeof(ServerScoket.ServerAddr);
      var
      ClientSocket := accept(ServerScoket.Scoket, @ServerScoket.ServerAddr, @AddrSize);

      if ClientSocket = INVALID_SOCKET then begin
        StatusBar1.Panels[0].Text := '获取连接失败';
        Exit;
      end;
      Content := '欢迎你来到老侯的直播间';
      TWinSocketUtil.SendString(ClientSocket, Content);

    end).Start;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // 关闭socket
  if ServerScoket.Scoket <> INVALID_SOCKET then
    closesocket(ServerScoket.Scoket);
  // 关闭客户端句柄
  if ClientSocket <> INVALID_SOCKET then
    closesocket(ClientSocket);

  // 清理版本库信息
  if WSACleanup = SOCKET_ERROR then
    ShowMessage('清理版本库失败')

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // 初始化网络库
  if TWinSocketUtil.InitSocket() = 0 then
    StatusBar1.Panels[0].Text := '网络库初始化成功'
  else
    StatusBar1.Panels[0].Text := '网络库初始化失败';

end;

end.
