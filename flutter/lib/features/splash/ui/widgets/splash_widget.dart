import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zure_ai/core/bloc/common_state.dart';
import 'package:zure_ai/features/auth/ui/pages/login_page.dart';
import 'package:zure_ai/features/home/ui/pages/home_page.dart';
import 'package:zure_ai/features/splash/cubit/startup_cubit.dart';
import 'package:zure_ai/features/splash/models/startup_data.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<StartupCubit, CommonState>(
        builder: (context, state) {
          if (state is CommonLoadingState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.smart_toy, size: 80, color: Colors.deepPurple),
                  Text(
                    "Zure Ai",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CommonSuccessState<StartupData>) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.data.isLoggedIn == true) {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const HomePage(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const LoginPage(),
                  ),
                );
              }
            });
          }
          return SizedBox();
        },
      ),
    );
  }
}
