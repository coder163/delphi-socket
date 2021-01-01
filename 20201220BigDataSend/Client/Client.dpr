program Client;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  UnitSocketUtil, Winapi.WinSock2, ScktComp, System.SysUtils;

var

  ClientSocket: TSocket;

  Buf: array [0 .. 2] of char;

  {
    1、客户端接收数据的循环没有终止

    2、接收的服务器端数据有冗余

  }
begin

  try
    try

      // 初始化网络库
      if TWinSocketUtil.InitSocket() <> 0 then
        Writeln('网络库初始化失败');
      // 创建服务器端Socket对象
      ClientSocket := TWinSocketUtil.CreateClientSocket('127.0.0.1', 10086);

      while True do begin
        Writeln('数据接收中...');
        var
        Resp := recv(ClientSocket, Buf, sizeof(Buf), 0);
        Writeln(Buf);
        // 服务器端连接断开或者数据读取完成
        if (Resp = 0) or (Buf[Length(Buf) - 1] = #0) then begin
          break;
        end;
        // 清空缓冲区
        FillChar(Buf, sizeof(Buf), #0);
      end;
      Writeln('数据接收完成！');
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    // 关闭客户端句柄
    if ClientSocket <> INVALID_SOCKET then
      closesocket(ClientSocket);

    // 清理版本库信息
    if WSACleanup = SOCKET_ERROR then
      Writeln('清理版本库失败')
  end;

  Readln;

end.
