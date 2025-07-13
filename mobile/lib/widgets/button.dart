import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/widgets/titles.dart';

// class Button extends StatelessWidget {
//   final String buttonText;
//   final double? fontSize;
//   final Function() onTap;
//   final Color? colors;
//   // final Size? size;
//   final MaterialTapTargetSize? size;
//   final BorderRadius? borderRadius;
//   final Widget? icon;
//   const Button({
//     super.key,
//     required this.buttonText,
//     required this.onTap,
//     this.fontSize,
//     this.colors,
//     this.size,
//     this.borderRadius,
//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: onTap,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if(icon != null) ...[
//             icon!,
//             const SizedBox(width: 8,)
//           ],
//           appParagraph(title: buttonText, color: colors, fontWeight: FontWeight.bold,)
//         ],
//     ),);
    // return MaterialButton(
    //   elevation: 2,
    //   hoverColor: Colors.grey,
    //   height: 50,
    //   onPressed: onTap,
    //   color: colors,
    //   // materialTapTargetSize: size,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       if (icon != null) ...[
    //         icon!,
    //         const SizedBox(width: 8),
    //       ],
    //       AppText(
    //         title: buttonText,
    //         colors: colors,
    //         fontSize: fontSize,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ],
    //   ),
    // );
//   }
// }

Widget appButton({required String buttonText, Color? colors, required Function() onTap, 
  Widget? icon, double? height, double? width
}) {
  return SizedBox(
    height: height,
    width: width,
    child: TextButton(
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(icon != null) ...[
              icon!,
              Gap(8.w)
            ],
            appParagraph(title: buttonText, color: colors, fontWeight: FontWeight.bold,)
          ],
      ),),
  );
}
