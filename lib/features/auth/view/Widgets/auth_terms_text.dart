import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quotify/core/theme/app_colors.dart';

class AuthTermsText extends StatelessWidget {
  final void Function()? onTermsTap;
  final void Function()? onPrivacyTap;

  const AuthTermsText({Key? key, this.onTermsTap, this.onPrivacyTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
          children: [
            const TextSpan(
              text: 'By clicking create account you agree to recognotes ',
            ),
            TextSpan(
              text: 'Terms of use',
              style: const TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTermsTap,
            ),
            const TextSpan(
              text: ' and ',
            ),
            TextSpan(
              text: 'Privacy policy',
              style: const TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
            ),
          ],
        ),
      ),
    );
  }
}
