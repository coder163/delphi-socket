program Server;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  UnitSocketUtil, Winapi.WinSock2, ScktComp, System.SysUtils;

var
  // 服务器端的Socket对象
  ServerScoket: TScoketRecord;
  ClientSocket: TSocket;
  // 待发送的内容，一共是10个字符
  Content: array [0 .. 9] of char;
  // 发送数据的缓冲区，缓冲区小于待发送内容的长度
  Buf: array [0 .. 3] of char;

begin

  try
    try

      // 初始化网络库
      if TWinSocketUtil.InitSocket() <> 0 then
        writeln('网络库初始化失败');
      // 创建服务器端Socket对象
      ServerScoket := TWinSocketUtil.CreateServerSocket('127.0.0.1', 10086);
      writeln('服务器启动成功');
      // 获取客户端连接对象，
      var
      AddrSize := sizeof(ServerScoket.ServerAddr);
      // 服务器处于监听状态(阻塞)
      ClientSocket := accept(ServerScoket.Scoket, @ServerScoket.ServerAddr, @AddrSize);

      // 当客户端连接成功时，显示一下客户端的IP
      var
      CustomWinSocket := TCustomWinSocket.Create(ClientSocket);
      writeln('客户端IP：' + CustomWinSocket.RemoteAddress);

      // 发送内容
      Content := '欢迎你来到老侯直播间';

      var
      Count := 0;

      while True do begin
        // 将待发送的内容填充到缓冲区中
        for var Index := 0 to Length(Buf) - 1 do begin
          Buf[Index] := Content[Count];

          // 待发送内容2个字，缓冲区是3个字，此时会有冗余数据
          if Count = Length(Content) - 1 then
            break;

          Count := Count + 1;
        end;

        send(ClientSocket, Buf, sizeof(Buf), 0);
        writeln('发送的内容：', Buf);
        if (Buf[Length(Buf) - 1] = #0) or (Count = Length(Content)) then begin
          break;
        end;
        FillChar(Buf, sizeof(Buf), #0);
      end;

      writeln('数据发送完成');
      closesocket(ClientSocket);
    except
      on E: Exception do
        writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    // 关闭socket
    if ServerScoket.Scoket <> INVALID_SOCKET then
      closesocket(ServerScoket.Scoket);
    // 关闭客户端句柄
    if ClientSocket <> INVALID_SOCKET then
      // closesocket(ClientSocket);

      // 清理版本库信息
      if WSACleanup = SOCKET_ERROR then
        writeln('清理版本库失败')
  end;

  Readln;

end.
