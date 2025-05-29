import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/core/bloc/common_state.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';

class SignupCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;
  SignupCubit({required this.authRepository}) : super(CommonIntialState());

  void signup(String username, String password) async {
    emit(CommonLoadingState());
    final res = await authRepository.signup(username, password);
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
