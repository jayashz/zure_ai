import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zure_ai/core/bloc/common_state.dart';
import 'package:zure_ai/features/auth/cubit/login_cubit.dart';
import 'package:zure_ai/features/auth/cubit/signup_cubit.dart';

import 'package:zure_ai/features/auth/ui/pages/sign_page.dart';
import 'package:zure_ai/features/home/repository/socket_repository.dart';

import 'package:zure_ai/features/home/ui/pages/home_page.dart';

class SignWidget extends StatelessWidget {
  const SignWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: BlocConsumer<SignupCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonSuccessState) {
            // Handle successful login
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login Successful')));
            final socketRepo = context.read<SocketRepository>();
            socketRepo.connect(); // ✅ Uses updated token

            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const HomePage(),
              ),
              (route) => false,
            );
          } else if (state is CommonErrorState) {
            // Handle login error
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo or Title
                  const Icon(
                    Icons.smart_toy,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Zure AI Assistant',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        FormBuilderTextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          name: 'email',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Email field cannot be empty";
                            }
                            final isvalid = EmailValidator.validate(val);
                            if (isvalid) {
                              return null;
                            } else {
                              return "Enter valid email address";
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        FormBuilderTextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          name: 'password',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Password field cannot be empty";
                            } else if (val.length < 4) {
                              return "Password field must be at least 4 character long";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.saveAndValidate()) {
                          context.read<SignupCubit>().signup(
                            _formKey.currentState!.value['email'],
                            _formKey.currentState!.value['password'],
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password & Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to forgot password
                        },
                        child: const Text('Forgot Password?'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const SignPage(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
