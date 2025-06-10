import 'package:flutter/material.dart';
import 'package:quotify/core/theme/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.inputField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      cursorColor: AppColors.textPrimary,
    );
  }
}
