import 'package:brana/features/auth/viewmodel/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brana/core/theme/app_colors.dart';
import 'package:brana/features/auth/view/Widgets/auth_divider.dart';
import 'package:brana/features/auth/view/Widgets/auth_primary_button.dart';
import 'package:brana/features/auth/view/widgets/auth_terms_text.dart';
import '../widgets/auth_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:brana/features/pdf_reader/view/pdf_reader_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Client-side validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 6 characters.')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    final viewModel = ref.read(signUpViewModelProvider.notifier);
    final success = await viewModel.signUp(email, password);

    final state = ref.read(signUpViewModelProvider);
    if (success && !state.emailConfirmationRequired) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PdfReaderPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpViewModelProvider);

    // Show error message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (signUpState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(signUpState.errorMessage!)),
        );
      }
      if (signUpState.emailConfirmationRequired) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm your email'),
            content: const Text(
                'A confirmation link has been sent to your email. Please check your inbox and confirm your email before logging in.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'Create an account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                    ),
                  ],
                ),
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
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              AuthPrimaryButton(
                text: signUpState.isLoading ? 'Loading...' : 'Continue',
                onPressed: signUpState.isLoading ? () {} : _handleSignUp,
              ),
              const SizedBox(height: 32),
              AuthDivider(),
              const SizedBox(height: 24),
              // Add your social sign-in buttons here if needed
              const Spacer(),
              AuthTermsText(
                onTermsTap: () {},
                onPrivacyTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
