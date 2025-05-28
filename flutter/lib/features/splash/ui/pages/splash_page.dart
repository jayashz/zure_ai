import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';
import 'package:zure_ai/features/splash/cubit/startup_cubit.dart';

import 'package:zure_ai/features/splash/ui/widgets/splash_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              StartupCubit(authRepository: context.read<AuthRepository>())
                ..init(),
      child: const SplashWidget(),
    );
  }
}
