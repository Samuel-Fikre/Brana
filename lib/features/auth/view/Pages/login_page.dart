import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:brana/core/theme/app_colors.dart';
import 'package:brana/features/auth/view/Pages/sign_up.dart';
import 'package:brana/features/auth/view/Widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:brana/features/pdf_reader/view/library_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brana/features/auth/viewmodel/login_vm.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(loginViewModelProvider.notifier).clearError();
      }
    });

    final loginState = ref.watch(loginViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'Welcome to Brana',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AuthTextField(
                hintText: 'Email address',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (val) {
                      setState(() => rememberMe = val ?? false);
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Text('Remember me',
                      style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              AuthPrimaryButton(
                text: loginState.isLoading ? 'Loading...' : 'Log in',
                onPressed: loginState.isLoading ? () {} : _handleLogin,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: Image.asset(
                  'assets/icons/google.png', // Make sure this asset exists!
                  height: 24,
                  width: 24,
                ),
                label: const Text('Sign in with Google'),
                onPressed: loginState.isLoading ? null : _handleGoogleSignIn,
              ),
              const SizedBox(height: 16),
              // Image row
              // SizedBox(
              //   height: 72,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: imageList.length,
              //     separatorBuilder: (context, index) =>
              //         const SizedBox(width: 12),
              //     itemBuilder: (context, index) {
              //       return ClipRRect(
              //         borderRadius: BorderRadius.circular(16),
              //         child: Image.asset(
              //           imageList[index],
              //           width: 56,
              //           height: 56,
              //           fit: BoxFit.cover,
              //         ),
              //       );
              //     },
              //   ),
              // ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'New to Brana? ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final viewModel = ref.read(loginViewModelProvider.notifier);
    final success = await viewModel.loginWithEmail(email, password);

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LibraryPage()),
      );
    }
  }

  void _handleGoogleSignIn() async {
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final success =
        await viewModel.loginWithGoogle(dotenv.env['GOOGLE_WEB_CLIENT_ID']!);
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LibraryPage()),
      );
    }
  }
}
