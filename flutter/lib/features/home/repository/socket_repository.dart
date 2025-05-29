// socket_repository.dart
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:zure_ai/core/constant.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';

import '../models/message.dart';

class SocketRepository {
  late io.Socket socket;
  final AuthRepository authRepository;

  Function(List<Message>)? onPreviousMessages;
  Function(Message)? onAIMessage;
  Function(Message)? onUserMessage;
  Function()? onConnect;
  Function()? onDisconnect;

  SocketRepository({required this.authRepository});

  void connect() {
    print(authRepository.getToken);
    socket = io.io(Constant.ipAddress, <String, dynamic>{
      'transports': ['websocket'],
      'auth': {'token': authRepository.getToken},
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to server');
      onConnect?.call();
    });

    socket.onDisconnect((_) {
      print('⚠️ Socket disconnected!');
      onDisconnect?.call();
    });

    socket.onConnectError((data) {
      print("❌ Connect error: $data");
    });

    socket.onError((data) {
      print("❌ General error: $data");
    });

    socket.on("previousMessages", (data) {
      final messages = (data as List).map((e) => Message.fromJson(e)).toList();
      onPreviousMessages?.call(messages);
    });

    socket.on('ai_message', (data) {
      final message = Message.fromJson(data);
      onAIMessage?.call(message);
    });

    socket.on('user', (data) {
      final message = Message.fromJson(data);
      onUserMessage?.call(message);
    });
  }

  void sendMessage(String message) {
    socket.emit("user", message);
  }

  void disconnect() {
    socket.disconnect();
  }
}
