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
    // �ͻ����б�
    ClientList: TList<TSocket>;
{$R *.dfm}

    { ���޼������� }
procedure WorkThread();
var
    CurSet: TFdSet;
    TimeVal: TTimeVal;
    Buf: array [0 .. 1023] of Char;
begin

    // ���޼���
    while True do begin
        FormServer.MemoLog.Lines.add('��ǰ�Ŀͻ���������' + ClientList.Count.ToString);
        // ���
        FD_ZERO(CurSet);
        // ��ʼ��CureSet ��ֵ
        for var Index := 0 to ClientList.Count - 1 do begin
            _FD_SET(ClientList.Items[Index], CurSet);
        end;
        // �ȴ�ʱ��
        TimeVal.tv_sec := 2;
        TimeVal.tv_usec := 0;

        // ��ѯ
        var
        Ret := select(0, @CurSet, nil, nil, @TimeVal);

        if Ret = 0 then begin
            FormServer.MemoLog.Lines.add('���ӳ�ʱ');
            Continue;
        end;

        // �����пɶ����ݵ�socket
        for var Index := 0 to ClientList.Count - 1 do begin
            // ��ǰ��ClientList[Index]�Ƿ��� ������CurSet
            if FD_ISSET(ClientList[Index], CurSet) then begin

                // ��ȡ����
                var
                hStatus := recv(ClientList[Index], Buf, length(Buf), 0);
                // ret == 0 || (ret == SOCKET_ERROR && WSAGetLastError() == WSAECONNRESET

                if (hStatus = 0) or ((hStatus = SOCKET_ERROR) and (WSAGetLastError() = WSAECONNRESET)) then begin
                    FormServer.MemoLog.Lines.add(Index.ToString() + '���˳�Ⱥ��');
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
    // ��ʼ���б����
    ClientList := TList<TSocket>.create();

    // �����������˶���
    Server := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    // �����Ƿ�ɹ�
    if (Server = INVALID_SOCKET) then begin
        MemoLog.Lines.add('����������ʧ��');
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
        MemoLog.Lines.add('�˿ںű�ռ��');
        exit;
    end;

    // ������ǰ��IP�Ͷ˿ں��Ƿ��пͻ�������
    if listen(Server, SOMAXCONN) = SOCKET_ERROR then begin
        MemoLog.Lines.add('����ʧ��');
        exit;
    end;
    ButtonStart.Enabled := false;

    // select accept VC��վ

    // 1�����޼���(�߳�) accept �����뼯��
    TThread.CreateAnonymousThread(
        procedure
        begin

            while True do begin
                var
                nAddrLen := sizeof(ServerAddr);
                // ����ִ�У�һ���пͻ������ӣ���������
                var
                Client := accept(Server, @ServerAddr, @nAddrLen);
                MemoLog.Lines.add('�¿ͻ�������');
                // FD_SET,�Լ��������飨���鳤�Ⱦ���FD_SET������������
                ClientList.add(Client);
            end;
        end).Start;
    // 2�����޼���(�߳�) select  ���������������е�socket,�ж���������ж�д����
    TThread.CreateAnonymousThread(WorkThread).Start;
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
    MemoLog.Lines.add('������ʼ���ɹ�');

    ClientList := TList<TSocket>.create();
end;

end.
