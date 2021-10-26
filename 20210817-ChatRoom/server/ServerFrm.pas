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

// ���õĵ�Ԫ
uses
    Winapi.WinSock2, ScktComp;

var
    Server: TSocket;
{$R *.dfm}

procedure TFormServer.ButtonStartClick(Sender: TObject);
var
    ServerAddr: TSockAddrIn;
    //�������������������
    ServerSocketSet: TFdSet;

    //�ȴ���ʱ��
    TimeVal: TTimeVal;
begin

    // �����������˶���
    Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // �����Ƿ�ɹ�
    if (Server = INVALID_SOCKET) then begin
        MemoLog.Lines.Add('����������ʧ��');
        exit;
    end;


    // ��װ��Ϣָ��IP�Ͷ˿�
    with ServerAddr do begin

        sin_family := PF_INET;
        // �˿ں�
        sin_port := StrToInt(EditPort.Text);
        // ���������п��ܵ�IP��Ϊ�������˵�IP
        sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(EditAddr.Text)));

    end;
    //��IP�Ͷ˿�
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

    TTHread.CreateAnonymousThread(
        procedure
        begin
            while True do begin
                //1����ʼ��FD_SET,��ʼ����������
                FD_ZERO(ServerSocketSet);

                //2������������Socket��������
                _FD_SET(Server, ServerSocketSet);
                //3������ select ����������FD_SET��Ԫ��������select����� FD_SET �����е�Ԫ��
                TimeVal.tv_sec := 2;
                TimeVal.tv_usec := 0;

                var Count := select(0, @ServerSocketSet, nil, nil, @TimeVal);
                //4����� FD_SET �������Ƿ���ڴ������ Socket
                var AddrSize := SizeOf(ServerAddr);

                for var Index := 0 to Count - 1 do begin

                    //�ͻ��˶���
                    var Client := accept(Server, @ServerAddr, @AddrSize);

                    if Client <> INVALID_SOCKET then begin

                        //��ȡ�ͻ��˵�IP��ַ
                        MemoLog.Lines.Add('�ͻ���IP��' + TCustomWinSocket.Create(Client).RemoteAddress);
                    end;

                end;
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
var
    WSAData: TWSAData;
begin

    // ���嵱ǰʹ�������汾
    if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then begin
        showmessage('��ʼ��ʧ��');
    end;
    MemoLog.Lines.Add('������ʼ���ɹ�');
end;

end.

