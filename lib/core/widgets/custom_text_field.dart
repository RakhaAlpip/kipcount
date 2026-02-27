import 'package:flutter/material.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textGrey, size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      color: AppColors.textGrey,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
