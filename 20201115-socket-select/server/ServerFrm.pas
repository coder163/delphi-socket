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
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormServer: TFormServer;

implementation

// ���õĵ�Ԫ
uses Winapi.WinSock2, ScktComp;

var
  Server: TSocket;
{$R *.dfm}

procedure TFormServer.Button1Click(Sender: TObject);
var
  str1: string;
var
  str2: array of Char;
begin
  SetLength(str2, 10);

//  str2 := str1.ToCharArray;

end;

procedure TFormServer.ButtonStartClick(Sender: TObject);
var

  ServerAddr: TSockAddrIn;

begin
  // �����������˶���
  Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  // �����Ƿ�ɹ�
  if (Server = INVALID_SOCKET) then begin
    MemoLog.Lines.Add('����������ʧ��');
    exit;
  end;

  // ��������ָ��IP�Ͷ˿�
  // ��װ��Ϣ
  with ServerAddr do begin

    sin_family := PF_INET;
    // �˿ں�
    sin_port := StrToInt(EditPort.Text);
    // ���������п��ܵ�IP��Ϊ�������˵�IP
    // sin_addr.S_addr:=INaddr_any;
    sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(EditAddr.Text)));

  end;
  if bind(Server, TSockAddr(ServerAddr), sizeof(ServerAddr)) = SOCKET_ERROR then begin
    MemoLog.Lines.Add('�˿ںű�ռ��');
    exit;
  end;

  // ������ǰ��IP�Ͷ˿ں��Ƿ��пͻ�������
  if listen(Server, SOMAXCONN) = SOCKET_ERROR then begin
    MemoLog.Lines.Add('����ʧ��');
    exit;
  end;

  ButtonStart.Enabled := false;
  TThread.CreateAnonymousThread(
    procedure
    begin

      // ��ȡ�ͻ������Ӷ���
      var
      AddrSize := sizeof(ServerAddr);
      var
      ClientSocket := accept(Server, @ServerAddr, @AddrSize);

      if ClientSocket = INVALID_SOCKET then begin
        case ClientSocket of
          WSAEFAULT:
            MemoLog.Lines.Add('IP��ȡʧ��')
        end;
        MemoLog.Lines.Add('��ȡ����ʧ��');
        exit;
      end;

      // ������result����0ʱ��ʾ�пͻ��˳ɹ����ӵ���ǰ������
      // ���ͻ������ӳɹ�ʱ����ʾһ�¿ͻ��˵�IP
      var
      CustomWinSocket := TCustomWinSocket.Create(ClientSocket);
      MemoLog.Lines.Add('�ͻ���IP��' + CustomWinSocket.RemoteAddress);

      // ����һ�仰
      var
      SendResult := send(ClientSocket, '��ӭ�������Ϻ��ֱ����', 1024, 0);

      if (SendResult = SOCKET_ERROR) or (SendResult <= 0) then begin
        MemoLog.Lines.Add('���ݷ���ʧ��');
      end;

    end).Start;

end;

procedure TFormServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // �ر�socket����
  if Server <> INVALID_SOCKET then begin
    closesocket(Server);
  end;

  // ����汾����Ϣ
  if WSACleanup = SOCKET_ERROR then
    showmessage('����汾��ʧ��')

end;

{ ��ʼ�� }
procedure TFormServer.FormCreate(Sender: TObject);
const
  // �����汾��2.2
  WINSOCKET_VERSION = $0202;
var

  WSAData: TWSAData;

begin

  // ���嵱ǰʹ�������汾
  if WSAStartup(WINSOCKET_VERSION, WSAData) <> 0 then begin
    showmessage('��ʼ��ʧ��');
  end;
  MemoLog.Lines.Add('������ʼ���ɹ�');
end;

end.
