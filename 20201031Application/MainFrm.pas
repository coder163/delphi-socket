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
  // �����������˵�Socket
  ServerScoket := TWinSocketUtil.CreateServerSocket('127.0.0.1', 10086);
  ButtonStartServer.Enabled := false;
  // �����ַ���
  TThread.CreateAnonymousThread(
    procedure
    var
      Content: array [0 .. 1023] of Char;
    begin
      // ��ȡ�ͻ������Ӷ���
      var
      AddrSize := sizeof(ServerScoket.ServerAddr);
      var
      ClientSocket := accept(ServerScoket.Scoket, @ServerScoket.ServerAddr, @AddrSize);

      if ClientSocket = INVALID_SOCKET then begin
        StatusBar1.Panels[0].Text := '��ȡ����ʧ��';
        Exit;
      end;
      Content := '��ӭ�������Ϻ��ֱ����';
      TWinSocketUtil.SendString(ClientSocket, Content);

    end).Start;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // �ر�socket
  if ServerScoket.Scoket <> INVALID_SOCKET then
    closesocket(ServerScoket.Scoket);
  // �رտͻ��˾��
  if ClientSocket <> INVALID_SOCKET then
    closesocket(ClientSocket);

  // ����汾����Ϣ
  if WSACleanup = SOCKET_ERROR then
    ShowMessage('����汾��ʧ��')

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // ��ʼ�������
  if TWinSocketUtil.InitSocket() = 0 then
    StatusBar1.Panels[0].Text := '������ʼ���ɹ�'
  else
    StatusBar1.Panels[0].Text := '������ʼ��ʧ��';

end;

end.
