// socket_state.dart
import 'package:zure_ai/features/home/models/message.dart';

abstract class SocketState {}

class SocketInitial extends SocketState {}

class SocketConnecting extends SocketState {}

class SocketConnected extends SocketState {}

class SocketDisconnected extends SocketState {}

class MessagesLoaded extends SocketState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class NewMessageReceived extends SocketState {
  final Message message;
  NewMessageReceived(this.message);
}
