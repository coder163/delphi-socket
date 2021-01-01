program Client;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  UnitSocketUtil, Winapi.WinSock2, ScktComp, System.SysUtils;

var

  ClientSocket: TSocket;

  Buf: array [0 .. 2] of char;

  {
    1���ͻ��˽������ݵ�ѭ��û����ֹ

    2�����յķ�����������������

  }
begin

  try
    try

      // ��ʼ�������
      if TWinSocketUtil.InitSocket() <> 0 then
        Writeln('������ʼ��ʧ��');
      // ������������Socket����
      ClientSocket := TWinSocketUtil.CreateClientSocket('127.0.0.1', 10086);

      while True do begin
        Writeln('���ݽ�����...');
        var
        Resp := recv(ClientSocket, Buf, sizeof(Buf), 0);
        Writeln(Buf);
        // �����������ӶϿ��������ݶ�ȡ���
        if (Resp = 0) or (Buf[Length(Buf) - 1] = #0) then begin
          break;
        end;
        // ��ջ�����
        FillChar(Buf, sizeof(Buf), #0);
      end;
      Writeln('���ݽ�����ɣ�');
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    // �رտͻ��˾��
    if ClientSocket <> INVALID_SOCKET then
      closesocket(ClientSocket);

    // ����汾����Ϣ
    if WSACleanup = SOCKET_ERROR then
      Writeln('����汾��ʧ��')
  end;

  Readln;

end.
