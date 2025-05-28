import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zure_ai/features/auth/ui/pages/login_page.dart';
import 'package:zure_ai/features/splash/ui/widgets/splash_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageTransition(type: PageTransitionType.fade, child: const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashWidget();
  }
}
