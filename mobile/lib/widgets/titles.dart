import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AppText extends StatelessWidget {
//   final String title;
//   final double? fontSize;
//   final FontWeight? fontWeight;
//   final Color? colors;
//   const AppText(
//       {super.key,
//       required this.title,
//       this.fontSize,
//       this.fontWeight,
//       this.colors});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Text(
//         title,
//         style: TextStyle(
//             fontSize: fontSize, fontWeight: fontWeight, color: colors),
//       ),
//     );
//   }
// }

Widget appTitle({required String title, FontWeight? fontWeight, Color? color}) {
  return Text(
    title, style: TextStyle(
      fontSize: 23.sp,
      fontWeight: fontWeight,
      // fontFamily: ,
      color: color
    )
  );
}

Widget appParagraph({required String title, double fontSize = 17, FontWeight? fontWeight, Color? color}) {
  return Text(title, style: TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      // fontFamily: "Actor",
    )
  );
}
