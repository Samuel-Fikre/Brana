import 'package:flutter/material.dart';
import 'package:quotify/core/theme/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.inputField,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'or sign up with',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.inputField,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
