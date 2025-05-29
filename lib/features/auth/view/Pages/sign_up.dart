import 'package:flutter/material.dart';
import 'package:quotify/core/theme/app_colors.dart';
import 'package:quotify/features/auth/view/Widgets/auth_divider.dart';
import 'package:quotify/features/auth/view/Widgets/auth_primary_button.dart';
import 'package:quotify/features/auth/view/Widgets/auth_social_buttons.dart';
import 'package:quotify/features/auth/view/widgets/auth_terms_text.dart';
import '../widgets/auth_text_field.dart';
import 'package:flutter/gestures.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 32),
              AuthPrimaryButton(
                text: 'Continue',
                onPressed: () {},
              ),
              const SizedBox(
                height: 32,
              ),
              AuthDivider(),
              const SizedBox(height: 24),
              AuthSocialButtons(),
              const SizedBox(
                height: 200,
              ),
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
