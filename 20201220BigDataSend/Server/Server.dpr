program Server;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  UnitSocketUtil, Winapi.WinSock2, ScktComp, System.SysUtils;

var
  // �������˵�Socket����
  ServerScoket: TScoketRecord;
  ClientSocket: TSocket;
  // �����͵����ݣ�һ����10���ַ�
  Content: array [0 .. 9] of char;
  // �������ݵĻ�������������С�ڴ��������ݵĳ���
  Buf: array [0 .. 3] of char;

begin

  try
    try

      // ��ʼ�������
      if TWinSocketUtil.InitSocket() <> 0 then
        writeln('������ʼ��ʧ��');
      // ������������Socket����
      ServerScoket := TWinSocketUtil.CreateServerSocket('127.0.0.1', 10086);
      writeln('�����������ɹ�');
      // ��ȡ�ͻ������Ӷ���
      var
      AddrSize := sizeof(ServerScoket.ServerAddr);
      // ���������ڼ���״̬(����)
      ClientSocket := accept(ServerScoket.Scoket, @ServerScoket.ServerAddr, @AddrSize);

      // ���ͻ������ӳɹ�ʱ����ʾһ�¿ͻ��˵�IP
      var
      CustomWinSocket := TCustomWinSocket.Create(ClientSocket);
      writeln('�ͻ���IP��' + CustomWinSocket.RemoteAddress);

      // ��������
      Content := '��ӭ�������Ϻ�ֱ����';

      var
      Count := 0;

      while True do begin
        // �������͵�������䵽��������
        for var Index := 0 to Length(Buf) - 1 do begin
          Buf[Index] := Content[Count];

          // ����������2���֣���������3���֣���ʱ������������
          if Count = Length(Content) - 1 then
            break;

          Count := Count + 1;
        end;

        send(ClientSocket, Buf, sizeof(Buf), 0);
        writeln('���͵����ݣ�', Buf);
        if (Buf[Length(Buf) - 1] = #0) or (Count = Length(Content)) then begin
          break;
        end;
        FillChar(Buf, sizeof(Buf), #0);
      end;

      writeln('���ݷ������');
      closesocket(ClientSocket);
    except
      on E: Exception do
        writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    // �ر�socket
    if ServerScoket.Scoket <> INVALID_SOCKET then
      closesocket(ServerScoket.Scoket);
    // �رտͻ��˾��
    if ClientSocket <> INVALID_SOCKET then
      // closesocket(ClientSocket);

      // ����汾����Ϣ
      if WSACleanup = SOCKET_ERROR then
        writeln('����汾��ʧ��')
  end;

  Readln;

end.
