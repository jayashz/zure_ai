import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/core/bloc/common_state.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';
import 'package:zure_ai/features/splash/models/startup_data.dart';

class StartupCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;
  StartupCubit({required this.authRepository}) : super(CommonIntialState());
  void init() async {
    print("initiated");

    emit(CommonLoadingState());
    await authRepository.init();
    print("${authRepository.getToken} Token from the startup");
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = authRepository.getToken.isNotEmpty;
    final params = StartupData(isLoggedIn: isLoggedIn);
    emit(CommonSuccessState<StartupData>(data: params));
  }
}
