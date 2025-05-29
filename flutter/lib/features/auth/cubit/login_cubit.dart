import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/core/bloc/common_state.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';

class LoginCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;
  LoginCubit({required this.authRepository}) : super(CommonIntialState());

  void login(String username, String password) async {
    emit(CommonLoadingState());
    final res = await authRepository.login(username, password);
    res.fold(
      (err) {
        emit(CommonErrorState(message: err));
      },
      (data) {
        authRepository.init();
        emit(CommonSuccessState(data: null));
      },
    );
  }
}
