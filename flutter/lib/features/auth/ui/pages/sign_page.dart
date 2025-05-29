import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/features/auth/cubit/signup_cubit.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';
import 'package:zure_ai/features/auth/ui/widgets/sign_widget.dart';

class SignPage extends StatelessWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SignupCubit(authRepository: context.read<AuthRepository>()),
      child: const SignWidget(),
    );
  }
}
