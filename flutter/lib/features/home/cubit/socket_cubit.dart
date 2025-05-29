// socket_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/core/bloc/socket_state.dart';
import 'package:zure_ai/features/home/repository/socket_repository.dart';

class SocketCubit extends Cubit<SocketState> {
  final SocketRepository socketRepository;

  SocketCubit({required this.socketRepository}) : super(SocketInitial());

  void initSocket() {
    emit(SocketConnecting());

    socketRepository.onConnect = () {
      emit(SocketConnected());
    };

    socketRepository.onDisconnect = () {
      emit(SocketDisconnected());
    };

    socketRepository.onPreviousMessages = (messages) {
      emit(MessagesLoaded(messages));
    };

    socketRepository.onAIMessage = (message) {
      emit(NewMessageReceived(message));
    };

    socketRepository.onUserMessage = (message) {
      emit(NewMessageReceived(message));
    };

    socketRepository.connect();
  }

  void sendMessage(String message) {
    socketRepository.sendMessage(message);
  }

  void closeSocket() {
    socketRepository.disconnect();
    emit(SocketDisconnected());
  }
}
