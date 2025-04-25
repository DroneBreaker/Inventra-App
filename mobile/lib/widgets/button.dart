import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/widgets/app_text.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final double? fontSize;
  final Function() onTap;
  final Color? colors;
  // final Size? size;
  final MaterialTapTargetSize? size;
  final BorderRadius? borderRadius;
  final Widget? icon;
  const Button({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.fontSize,
    this.colors,
    this.size,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 2,
      hoverColor: AppColors.grey900,
      height: 50,
      textColor: Colors.black54,
      onPressed: onTap,
      color: colors,
      // materialTapTargetSize: size,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          AppText(
            title: buttonText,
            colors: colors,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
