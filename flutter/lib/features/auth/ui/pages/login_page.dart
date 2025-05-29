import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/features/auth/cubit/login_cubit.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';
import 'package:zure_ai/features/auth/ui/widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create:
          (context) =>
              LoginCubit(authRepository: context.read<AuthRepository>()),
      child: const LoginWidget(),
    );
  }
}
