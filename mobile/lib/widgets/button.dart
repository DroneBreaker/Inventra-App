import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/widgets/titles.dart';

Widget appButton({
  required String buttonText,
  double? fontSize,
  Color? colors,
  required Function() onTap,
  Widget? icon,
  double? height,
  double? width,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: TextButton(
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, Gap(8.w)],
          appParagraph(
            title: buttonText,
            color: colors,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    ),
  );
}

Widget appButton2(
  String buttonText,
  Function() onTap, {
  double? width,
  double? fontSize,
  Color? color,
  double? letterSpacing,
}) {
  return SizedBox(
    height: 50.h,
    width: width,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentLight),
      child: appParagraph(
        title: buttonText,
        fontSize: 17,
        letterSpacing: letterSpacing,
        color: AppColors.textPrimary,
      ),
    ),
  );
}
