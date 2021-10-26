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

// ���õĵ�Ԫ
uses
    Winapi.WinSock2, ScktComp;

var
    Client: TSocket;

procedure TFormClient.ButtonConnectionClick(Sender: TObject);
var
    ServerAddr: TSockAddrIn;
    RecvContent: array[0..1023] of Char;
begin



    // ����Socket����
    Client := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // ��װIP�Ͷ˿���Ϣ
    with ServerAddr do begin
        sin_family := PF_INET;
        // �˿ں�
        sin_port := StrToInt(EditPort.Text);

        // ���������п��ܵ�IP��Ϊ�������˵�IP
        sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(EditAddr.Text)));
    end;
    // ���ӷ�����
    var ConnectResult := connect(Client, TSockAddr(ServerAddr), SizeOf(ServerAddr));
    if ConnectResult <> 0 then begin
        MemoLog.Lines.Add('����ʧ��');

    end;
    ButtonConnection.Enabled := false;
    // ��ȡ����
//    var RecvResult := recv(Client, RecvContent, length(RecvContent), 0);
//
//    if RecvResult > 0 then begin
//        MemoRecord.Lines.Add(RecvContent);
//
//    end;

end;

procedure TFormClient.ButtonSendClick(Sender: TObject);
begin
    // ����һ�仰
    var SendResult := send(Client, '��ӭ�������Ϻ��ֱ����', 1024, 0);

    if (SendResult = SOCKET_ERROR) or (SendResult <= 0) then begin
        MemoLog.Lines.Add('���ݷ���ʧ��');
    end;
end;

procedure TFormClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // �ر�socket����
    if Client <> INVALID_SOCKET then begin
        closesocket(Client);
    end;

    // ����汾����Ϣ
    if WSACleanup = SOCKET_ERROR then
        showmessage('����汾��ʧ��')
end;

procedure TFormClient.FormCreate(Sender: TObject);
var
    WSAData: TWSAData;
begin
    // ��ʼ�������汾
    if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then
        FormClient.Caption := '��������ʧ��'
end;

end.

