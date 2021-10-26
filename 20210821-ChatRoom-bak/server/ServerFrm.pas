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

// ���õĵ�Ԫ
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
    // �ȴ���ʱ��
    TimeVal: TTimeVal;
    Buf: array [0 .. 1023] of Char;
begin
    while (TRUE) do begin
        FormServer.MemoLog.Lines.Add('ѭ��������....');
        FD_ZERO(CurSocketSet);

        for var i := 0 to ClientList.Count - 1 do begin
            _FD_SET(ClientList.Items[i], CurSocketSet);
        end;
        FormServer.MemoLog.Lines.Add('��ǰ�����е�������' + CurSocketSet.fd_count.ToString);
        TimeVal.tv_sec := 2;
        TimeVal.tv_usec := 0;
        var
        Ret := select(0, @CurSocketSet, nil, nil, @TimeVal);
        // ��ʱ
        if (Ret = 0) then continue;

        for var i := 0 to ClientList.Count - 1 do begin

            if (FD_ISSET(ClientList.Items[i], CurSocketSet)) then begin
                Ret := recv(ClientList.Items[i], Buf, length(Buf), 0);
                // Client socket closed
                if (Ret = 0) or (Ret = SOCKET_ERROR) or (WSAGetLastError() = WSAECONNRESET) then begin
                    FormServer.MemoLog.Lines.Add('�ͻ����˳�....' + i.ToString);
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
    // �������������������
    CurSocketSet, ServerSocketSet: TFdSet;

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
    // ��IP�Ͷ˿�
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

    // ���ù����߳�
    TThread.CreateAnonymousThread(WorkerThread).Start;

    TThread.CreateAnonymousThread(
        procedure
        begin

            while TRUE do begin
                FormServer.MemoLog.Lines.Add('�ȴ��ͻ�������....');
                var
                AddrSize := sizeof(ServerAddr);
                var
                Client := accept(Server, @ServerAddr, @AddrSize);
                ClientList.Add(Client);
                FormServer.MemoLog.Lines.Add('�¿ͻ���....');
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
    if WSACleanup = SOCKET_ERROR then showmessage('����汾��ʧ��')

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

    ClientList := TList<TSocket>.create();
end;

end.
