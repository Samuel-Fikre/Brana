import 'package:flutter/material.dart';
import 'package:brana/core/theme/app_colors.dart';

class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SocialButton(
          icon: Image.asset(
            'assets/icons/google.png',
            width: 35,
            height: 35,
          ),
          onTap: () => print('Google tapped'),
        ),
        const SizedBox(width: 16),
        _SocialButton(
          icon: const Icon(Icons.apple, color: AppColors.textPrimary, size: 35),
          onTap: () => print('Apple tapped'),
        ),
        const SizedBox(width: 16),
        _SocialButton(
          icon: const Icon(Icons.facebook, color: AppColors.facebook, size: 35),
          onTap: () => print('Facebook tapped'),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textSecondary, width: 2),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
